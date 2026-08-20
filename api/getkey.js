const https = require('https');

function fetchShortenLink(apiUrl) {
    return new Promise((resolve) => {
        https.get(apiUrl, (res) => {
            let data = '';
            res.on('data', (chunk) => { data += chunk; });
            res.on('end', () => {
                try {
                    const parsed = JSON.parse(data);
                    if (parsed.status === 'success' && parsed.shortenedUrl) {
                        resolve(parsed.shortenedUrl);
                    } else {
                        resolve(null);
                    }
                } catch (e) {
                    resolve(null);
                }
            });
        }).on('error', () => resolve(null));
    });
}

module.exports = async (req, res) => {
    try {
        const userAgent = req.headers['user-agent'] || '';
        const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1';
        const deviceId = Buffer.from(`${ip}-${userAgent}`).toString('base64').substring(0, 16);

        const now = new Date();
        const vnTime = new Date(now.getTime() + (7 * 3600 * 1000));
        const day = String(vnTime.getUTCDate()).padStart(2, '0');
        const month = String(vnTime.getUTCMonth() + 1).padStart(2, '0');
        const year = vnTime.getUTCFullYear();
        const todayStr = `${day}${month}${year}`;

        const generatedKey = `TLong-${todayStr}-${deviceId}`;
        const action = req.query.action;

        if (action === 'generate-link') {
            const apiToken = '68b3dda628184c43725cb671';
            const protocol = req.headers['x-forwarded-proto'] || 'https';
            const host = req.headers.host;
            const targetUrl = `${protocol}://${host}/api/getkey?action=view-key&device=${deviceId}`;
            const apiUrl = `https://link4m.co/api-shorten/v2?api=${apiToken}&url=${encodeURIComponent(targetUrl)}`;

            const shortUrl = await fetchShortenLink(apiUrl);
            return res.status(200).json({ 
                success: true, 
                shortUrl: shortUrl || targetUrl 
            });
        } 

        if (action === 'view-key') {
            res.setHeader('Content-Type', 'text/html; charset=utf-8');
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
                        .key-box { background: #000; padding: 12px; border-radius: 6px; font-weight: bold; font-size: 15px; color: #50ff8c; word-break: break-all; margin: 15px 0; border: 1px dashed #50ff8c; }
                        button { background: #00f0ff; color: #000; border: none; padding: 10px 20px; font-weight: bold; border-radius: 6px; cursor: pointer; }
                    </style>
                </head>
                <body>
                    <div class="card">
                        <h2>★ TLONG KEY ★</h2>
                        <p>Key của bạn hôm nay là:</p>
                        <div class="key-box" id="keyText">${generatedKey}</div>
                        <button onclick="copyKey()">Sao Chép Key</button>
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
    } catch (err) {
        return res.status(500).json({ error: err.message });
    }
};
