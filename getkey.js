// =================================================================
// BACKEND API - GET KEY SYSTEM (TLONG SYSTEM)
// =================================================================

const SHORTENER_API = "https://link4m.co/api-shorten"; // Đổi link API web rút gọn của bạn tại đây
const SHORTENER_TOKEN = "68b3dda628184c43725cb671";              // Đổi API Token của bạn tại đây

// Hàm lấy ngày GMT+7 định dạng DDMMYYYY
function getTodayGMT7() {
    const now = new Date();
    const formatter = new Intl.DateTimeFormat('en-GB', {
        timeZone: 'Asia/Ho_Chi_Minh',
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
    });
    const [{ value: day }, , { value: month }, , { value: year }] = formatter.formatToParts(now);
    return `${day}${month}${year}`;
}

export default async function handler(req, res) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    const { action, deviceId } = req.query;

    // 1. Tạo Link Get Key
    if (action === 'generate-link') {
        try {
            const today = getTodayGMT7();
            const destinationUrl = `https://${req.headers.host}/?key_generated=true&date=${today}`;

            // Gọi sang API web rút gọn
            const response = await fetch(`${SHORTENER_API}?api=${SHORTENER_TOKEN}&url=${encodeURIComponent(destinationUrl)}`);
            const data = await response.json();

            if (data && (data.shortenedUrl || data.shortlink || data.url)) {
                return res.status(200).json({
                    success: true,
                    shortUrl: data.shortenedUrl || data.shortlink || data.url
                });
            } else {
                // Nếu chưa cài token rút gọn -> Fallback về link gốc
                return res.status(200).json({
                    success: true,
                    shortUrl: destinationUrl
                });
            }
        } catch (err) {
            return res.status(500).json({ success: false, message: "Lỗi kết nối máy chủ!" });
        }
    }

    // 2. Trả về Key theo thiết bị
    if (action === 'get-key-value') {
        const today = getTodayGMT7();
        const clientDevice = deviceId || "DEVICE";
        return res.status(200).json({
            success: true,
            key: `TLong-${today}-${clientDevice}`
        });
    }

    return res.status(400).json({ success: false, message: "Action không hợp lệ!" });
}
