export default async function handler(req, res) {
    // 1. Lấy thông tin thiết bị/IP người dùng
    const userAgent = req.headers['user-agent'] || '';
    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1';
    
    // Tạo Fingerprint thiết bị từ IP + User Agent
    const deviceId = Buffer.from(`${ip}-${userAgent}`).toString('base64').substring(0, 16);

    // 2. Tính ngày hiện tại theo giờ Việt Nam (GMT+7)
    const now = new Date();
    const vnOffset = 7 * 60 * 60 * 1000;
    const vnTime = new Date(now.getTime() + (now.getTimezoneOffset() * 60000) + vnOffset);
    
    const day = String(vnTime.getDate()).padStart(2, '0');
    const month = String(vnTime.getMonth() + 1).padStart(2, '0');
    const year = vnTime.getFullYear();
    const todayStr = `${day}${month}${year}`;

    // 3. Định dạng Key: TLong-DDMMYYYY-DeviceID
    const generatedKey = `TLong-${todayStr}-${deviceId}`;

    // 4. Kiểm tra hành động từ Client
    const action = req.query.action;

    if (action === 'generate-link') {
        // Tự động gọi API Link4m rút gọn
        const apiToken = '68b3dda628184c43725cb671';
        const targetUrl = `https://${req.headers.host}/api/getkey?action=view-key&device=${deviceId}`;
        const apiUrl = `https://link4m.co/api-shorten/v2?api=${apiToken}&url=${encodeURIComponent(targetUrl)}`;

        try {
            const response = await fetch(apiUrl);
            const data = await response.json();
            if (data.status === 'success') {
                return res.status(200).json({ success: true, shortUrl: data.shortenedUrl });
            } else {
                return res.status(200).json({ success: true, shortUrl: targetUrl });
            }
        } catch (error) {
            return res.status(200).json({ success: true, shortUrl: targetUrl });
        }
    } 
    
    if (action === 'view-key') {
        // Hiển thị Key sau khi vượt link rút gọn thành công
        return res.status(200).send(`
            <!DOCTYPE html>
            <html lang="vi">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>TLong Key - Lấy Key Thành Công</title>
                <style>
                    body { font-family: sans-serif; background: #0b0813; color: #fff; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
                    .card { background: #161224; padding: 25px; border-radius: 12px; border: 1px solid #00f0ff; text-align: center; max-width: 90%; width: 360px; box-shadow: 0 0 15px rgba(0,240,255,0.3); }
                    h2 { color: #00f0ff; margin-bottom: 15px; }
                    .key-box { background: #000; padding: 12px; border-radius: 6px; font-weight: bold; font-size: 16px; color: #50ff8c; word-break: break-all; margin: 15px 0; border: 1px dashed #50ff8c; }
                    button { background: #00f0ff; color: #000; border: none; padding: 10px 20px; font-weight: bold; border-radius: 6px; cursor: pointer; }
                    .note { font-size: 12px; color: #aaa; margin-top: 15px; }
                </style>
            </head>
            <body>
                <div class="card">
                    <h2>★ TLONG KEY ★</h2>
                    <p>Key của bạn hôm nay là:</p>
                    <div class="key-box" id="keyText">${generatedKey}</div>
                    <button onclick="copyKey()">Sao Chép Key</button>
                    <p class="note">⚠️ Key chỉ áp dụng cho 1 thiết bị và tự hết hạn lúc 00:00.</p>
                </div>
                <script>
                    function copyKey() {
                        const key = document.getElementById('keyText').innerText;
                        navigator.clipboard.writeText(key);
                        alert('Đã sao chép Key!');
                    }
                </script>
            </body>
            </html>
        `);
    }

    return res.status(400).json({ error: 'Yêu cầu không hợp lệ' });
}
