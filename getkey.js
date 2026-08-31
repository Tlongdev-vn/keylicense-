export default async function handler(req, res) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');

    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    // 1. CẤU HÌNH LINK4M (Thay Token của bạn vào đây)
    const LINK4M_API_TOKEN = "68b3dda628184c43725cb671"; 

    // 2. TẠO KEY CHUẨN MÚI GIỜ VIỆT NAM (Asia/Ho_Chi_Minh)
    const options = { timeZone: 'Asia/Ho_Chi_Minh', day: '2-digit', month: '2-digit', year: 'numeric' };
    const formatter = new Intl.DateTimeFormat('en-GB', options);
    const parts = formatter.formatToParts(new Date());

    const day = parts.find(p => p.type === 'day').value;
    const month = parts.find(p => p.type === 'month').value;
    const year = parts.find(p => p.type === 'year').value;
    
    const todayDateStr = `${day}${month}${year}`; // Kết quả: DDMMYYYY theo giờ VN

    const randomCode = Math.random().toString(36).substring(2, 8).toUpperCase();
    const generatedKey = `TLong-${todayDateStr}-${randomCode}`;

    // 3. TẠO LINK HIỂN THỊ KEY SAU KHI VƯỢT LINK
    const targetUrl = `https://keylicenseprenium.vercel.app/showkey.html?key=${generatedKey}`;

    try {
        // 4. GỌI API LINK4M ĐỂ TẠO LINK RÚT GỌN CHỨA KEY MỚI
        const link4mApiUrl = `https://link4m.co/api-shorten?api=${LINK4M_API_TOKEN}&url=${encodeURIComponent(targetUrl)}`;
        
        const response = await fetch(link4mApiUrl);
        const data = await response.json();

        if (data && (data.shortenedUrl || data.url)) {
            return res.status(200).json({
                success: true,
                key: generatedKey,
                shortLink: data.shortenedUrl || data.url
            });
        } else {
            // Nếu Link4m lỗi, trả về link đích trực tiếp để không làm gián đoạn người dùng
            return res.status(200).json({
                success: true,
                key: generatedKey,
                shortLink: targetUrl
            });
        }
    } catch (error) {
        return res.status(500).json({ success: false, message: "Lỗi kết nối Link4m API" });
    }
}
