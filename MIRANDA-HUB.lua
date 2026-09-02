-- =================================================================
-- HỆ THỐNG GET KEY SOLIX HUB - TLONG SYSTEM (AUTO-SAVE KEY)
-- =================================================================

local DOMAIN_VERCEL = "https://keylicensenew2.vercel.app/"
local DISCORD_INVITE = "https://discord.gg/TvwRC4tba"
local DISCORD_ICON_URL = "rbxassetid://99761773347476"
local SAVE_FILE_NAME = "TLongHub_Key.txt" -- File lưu trạng thái key

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Hàm lấy định dạng ngày GMT+7 (DDMMYYYY)
local function GetCurrentDateString()
    local date = os.date("!*t", os.time() + (7 * 3600))
    return string.format("%02d%02d%04d", date.day, date.month, date.year)
end

-- Hàm khởi chạy Script chính
local function LaunchMainScript()
    task.spawn(function()
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/stealaegg"))()
        end)
        if not success then
            warn("[Clover Hub Error]:", result)
        end
    end)
end

-- =================================================================
-- ⚡ KIỂM TRA KEY ĐÃ SỬ DỤNG TRƯỚC ĐÓ CHƯA (TỰ ĐỘNG BỎ QUA UI)
-- =================================================================
local todayDateStr = GetCurrentDateString()

local function CheckSavedKeyStatus()
    if readfile and isfile and isfile(SAVE_FILE_NAME) then
        local savedData = readfile(SAVE_FILE_NAME)
        -- Kiểm tra nếu file chứa đúng ngày hôm nay -> Đã get key & kích hoạt thành công
        if savedData == todayDateStr then
            return true
        end
    end
    return false
end

-- Nếu đã xác thực thành công hôm nay -> Chạy luôn script chính & Hủy khởi tạo UI
if CheckSavedKeyStatus() then
    print("[TLong System]: Key hôm nay đã được xác thực trước đó. Đang vào game...")
    LaunchMainScript()
    return -- Dừng thực thi đoạn code UI bên dưới
end

-- =================================================================
-- KHỞI TẠO UI (Nếu chưa Get Key hoặc Key đã hết hạn ngày mới)
-- =================================================================

if CoreGui:FindFirstChild("TLongHub_GetKeyUI") then
    CoreGui.TLongHub_GetKeyUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TLongHub_GetKeyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 390, 0, 380)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 8, 19)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Viền cầu vồng
local RainbowStroke = Instance.new("UIStroke")
RainbowStroke.Thickness = 1.8
RainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RainbowStroke.Parent = MainFrame

RunService.RenderStepped:Connect(function()
    if MainFrame and MainFrame.Parent then
        local hue = (tick() * 0.2) % 1
        RainbowStroke.Color = Color3.fromHSV(hue, 0.75, 1)
    end
end)

-- Tiêu đề
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -30, 0, 22)
TitleLabel.Position = UDim2.new(0, 15, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "TLONG KEY SYSTEM - MIRANDA HUB"
TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Ô nhập Key
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -30, 0, 34)
InputBox.Position = UDim2.new(0, 15, 0, 33)
InputBox.BackgroundColor3 = Color3.fromRGB(22, 18, 36)
InputBox.TextColor3 = Color3.fromRGB(245, 245, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(120, 115, 140)
InputBox.PlaceholderText = "Nhập Key xác thực vào đây..."
InputBox.Text = ""
InputBox.TextSize = 12
InputBox.Font = Enum.Font.GothamMedium
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputBox

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(45, 38, 70)
InputStroke.Thickness = 1
InputStroke.Parent = InputBox

-- Hàng nút bấm
local ButtonsRow = Instance.new("Frame")
ButtonsRow.Size = UDim2.new(1, -30, 0, 34)
ButtonsRow.Position = UDim2.new(0, 15, 0, 72)
ButtonsRow.BackgroundTransparency = 1
ButtonsRow.Parent = MainFrame

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.5, -5, 1, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
GetKeyBtn.Text = "🔗 LẤY LINK KEY"
GetKeyBtn.TextColor3 = Color3.fromRGB(8, 8, 12)
GetKeyBtn.TextSize = 12
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.AutoButtonColor = false
GetKeyBtn.Parent = ButtonsRow

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 8)
GetKeyCorner.Parent = GetKeyBtn

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0.5, -5, 1, 0)
CheckKeyBtn.Position = UDim2.new(0.5, 5, 0, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(38, 30, 62)
CheckKeyBtn.Text = "✔ KIỂM TRA KEY"
CheckKeyBtn.TextColor3 = Color3.fromRGB(245, 245, 255)
CheckKeyBtn.TextSize = 12
CheckKeyBtn.Font = Enum.Font.GothamBold
CheckKeyBtn.AutoButtonColor = false
CheckKeyBtn.Parent = ButtonsRow

local CheckCorner = Instance.new("UICorner")
CheckCorner.CornerRadius = UDim.new(0, 8)
CheckCorner.Parent = CheckKeyBtn

-- Banner trạng thái
local StatusBanner = Instance.new("Frame")
StatusBanner.Size = UDim2.new(1, -30, 0, 28)
StatusBanner.Position = UDim2.new(0, 15, 0, 112)
StatusBanner.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
StatusBanner.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusBanner

local StatusMsg = Instance.new("TextLabel")
StatusMsg.Size = UDim2.new(1, -12, 1, 0)
StatusMsg.Position = UDim2.new(0, 6, 0, 0)
StatusMsg.BackgroundTransparency = 1
StatusMsg.Text = "⚡ Key tự động làm mới lúc 00:00 hàng ngày"
StatusMsg.TextColor3 = Color3.fromRGB(180, 175, 205)
StatusMsg.TextSize = 9.5
StatusMsg.Font = Enum.Font.GothamMedium
StatusMsg.TextWrapped = true
StatusMsg.Parent = StatusBanner

-- Card Discord
local DiscordCard = Instance.new("Frame")
DiscordCard.Size = UDim2.new(1, -30, 0, 48)
DiscordCard.Position = UDim2.new(0, 15, 0, 146)
DiscordCard.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
DiscordCard.Parent = MainFrame

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 8)
DiscordCorner.Parent = DiscordCard

local DiscordStroke = Instance.new("UIStroke")
DiscordStroke.Color = Color3.fromRGB(88, 101, 242)
DiscordStroke.Parent = DiscordCard

local DiscordAvatar = Instance.new("ImageLabel")
DiscordAvatar.Size = UDim2.new(0, 34, 0, 34)
DiscordAvatar.Position = UDim2.new(0, 8, 0.5, -17)
DiscordAvatar.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordAvatar.Image = DISCORD_ICON_URL
DiscordAvatar.Parent = DiscordCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = DiscordAvatar

local ServerName = Instance.new("TextLabel")
ServerName.Size = UDim2.new(0, 180, 0, 18)
ServerName.Position = UDim2.new(0, 48, 0, 8)
ServerName.BackgroundTransparency = 1
ServerName.Text = "TLong System Community"
ServerName.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerName.TextSize = 11.5
ServerName.Font = Enum.Font.GothamBold
ServerName.TextXAlignment = Enum.TextXAlignment.Left
ServerName.Parent = DiscordCard

local ServerSub = Instance.new("TextLabel")
ServerSub.Size = UDim2.new(0, 180, 0, 14)
ServerSub.Position = UDim2.new(0, 48, 0, 25)
ServerSub.BackgroundTransparency = 1
ServerSub.Text = "🟢 Join Server Discord Support"
ServerSub.TextColor3 = Color3.fromRGB(80, 255, 140)
ServerSub.TextSize = 9.5
ServerSub.Font = Enum.Font.GothamMedium
ServerSub.TextXAlignment = Enum.TextXAlignment.Left
ServerSub.Parent = DiscordCard

local JoinDiscordBtn = Instance.new("TextButton")
JoinDiscordBtn.Size = UDim2.new(0, 100, 0, 28)
JoinDiscordBtn.Position = UDim2.new(1, -108, 0.5, -14)
JoinDiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
JoinDiscordBtn.Text = "Coppy"
JoinDiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinDiscordBtn.TextSize = 10.5
JoinDiscordBtn.Font = Enum.Font.GothamBold
JoinDiscordBtn.Parent = DiscordCard

local JoinCorner = Instance.new("UICorner")
JoinCorner.CornerRadius = UDim.new(0, 6)
JoinCorner.Parent = JoinDiscordBtn

-- Card Lưu ý
local NoteCard = Instance.new("Frame")
NoteCard.Size = UDim2.new(1, -30, 0, 160)
NoteCard.Position = UDim2.new(0, 15, 0, 202)
NoteCard.BackgroundColor3 = Color3.fromRGB(17, 13, 29)
NoteCard.Parent = MainFrame

local NoteCardCorner = Instance.new("UICorner")
NoteCardCorner.CornerRadius = UDim.new(0, 8)
NoteCardCorner.Parent = NoteCard

local NoteLabel = Instance.new("TextLabel")
NoteLabel.Size = UDim2.new(1, -16, 1, -10)
NoteLabel.Position = UDim2.new(0, 8, 0, 5)
NoteLabel.BackgroundTransparency = 1
NoteLabel.TextColor3 = Color3.fromRGB(242, 160, 120)
NoteLabel.TextSize = 9.5
NoteLabel.Font = Enum.Font.Gotham
NoteLabel.TextWrapped = true
NoteLabel.TextYAlignment = Enum.TextYAlignment.Top
NoteLabel.TextXAlignment = Enum.TextXAlignment.Left
NoteLabel.Text = "📌 Lưu ý quan trọng:\n• Truy cập link web để lấy Key trong ngày.\n• Mỗi Key chỉ áp dụng cho 1 thiết bị duy nhất.\n• Key tự động làm mới vào 00:00 (Giờ Việt Nam).\n• Tham gia Discord để nhận trợ giúp khi gặp lỗi Script.\n• TikTok: Royah Roblox or @python_c3"
NoteLabel.Parent = NoteCard

-- =================================================================
-- HIỆU ỨNG TƯƠNG TÁC & FADE OUT THÀNH CÔNG
-- =================================================================

local function PlayBounce(btn)
    local origSize = btn.Size
    local origPos = btn.Position
    local shrinkSize = UDim2.new(origSize.X.Scale, origSize.X.Offset - 4, origSize.Y.Scale, origSize.Y.Offset - 4)
    local shrinkPos = UDim2.new(origPos.X.Scale, origPos.X.Offset + 2, origPos.Y.Scale, origPos.Y.Offset + 2)
    
    local t1 = TweenService:Create(btn, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = shrinkSize, Position = shrinkPos})
    local t2 = TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize, Position = origPos})
    t1:Play()
    t1.Completed:Connect(function() t2:Play() end)
end

local function SetClipboardSafe(text)
    if setclipboard then setclipboard(text) elseif toclipboard then toclipboard(text) end
end

local function PlaySuccessFadeOut()
    local duration = 0.45
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

    TweenService:Create(MainFrame, tweenInfo, {
        Position = UDim2.new(0.5, 0, 0.58, 0),
        Size = UDim2.new(0, 360, 0, 350),
        BackgroundTransparency = 1
    }):Play()

    TweenService:Create(RainbowStroke, tweenInfo, {Transparency = 1}):Play()

    for _, desc in ipairs(MainFrame:GetDescendants()) do
        if desc:IsA("Frame") then
            TweenService:Create(desc, tweenInfo, {BackgroundTransparency = 1}):Play()
        elseif desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
            TweenService:Create(desc, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        elseif desc:IsA("ImageLabel") then
            TweenService:Create(desc, tweenInfo, {BackgroundTransparency = 1, ImageTransparency = 1}):Play()
        elseif desc:IsA("UIStroke") then
            TweenService:Create(desc, tweenInfo, {Transparency = 1}):Play()
        end
    end

    task.wait(duration)
    ScreenGui:Destroy()
end

-- =================================================================
-- SỰ KIỆN NÚT BẤM
-- =================================================================

JoinDiscordBtn.MouseButton1Click:Connect(function()
    PlayBounce(JoinDiscordBtn)
    SetClipboardSafe(DISCORD_INVITE)
    
    if request then
        pcall(function()
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
                Body = game:GetService("HttpService"):JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {code = "TvwRC4tba"},
                    nonce = game:GetService("HttpService"):GenerateGUID(false)
                })
            })
        end)
    end
    
    StatusBanner.BackgroundColor3 = Color3.fromRGB(30, 35, 75)
    StatusMsg.TextColor3 = Color3.fromRGB(120, 150, 255)
    StatusMsg.Text = "💬 Đã copy link Discord! Đã mở ứng dụng Discord (nếu có)."
    
    JoinDiscordBtn.Text = "✔ ĐÃ COPY"
    task.delay(2, function()
        if JoinDiscordBtn and JoinDiscordBtn.Parent then
            JoinDiscordBtn.Text = "Coppy"
        end
    end)
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    PlayBounce(GetKeyBtn)
    SetClipboardSafe(DOMAIN_VERCEL)
    
    StatusBanner.BackgroundColor3 = Color3.fromRGB(0, 50, 60)
    StatusMsg.TextColor3 = Color3.fromRGB(0, 240, 255)
    StatusMsg.Text = "📋 Đã sao chép Link Web! Hãy dán lên trình duyệt để Get Key."
    
    GetKeyBtn.Text = "✔ ĐÃ SAO CHÉP"
    task.delay(2, function()
        if GetKeyBtn and GetKeyBtn.Parent then
            GetKeyBtn.Text = "🔗 LẤY LINK KEY"
        end
    end)
end)

local isChecking = false
CheckKeyBtn.MouseButton1Click:Connect(function()
    if isChecking then return end
    isChecking = true
    PlayBounce(CheckKeyBtn)
    
    CheckKeyBtn.Text = "⏳ Đang duyệt..."
    StatusBanner.BackgroundColor3 = Color3.fromRGB(26, 20, 45)
    StatusMsg.TextColor3 = Color3.fromRGB(240, 240, 255)
    StatusMsg.Text = "Đang kiểm tra tính hợp lệ..."
    
    task.wait(0.35)
    local enteredKey = string.gsub(InputBox.Text, "%s+", "")
    
    if enteredKey:find("TLong%-" .. todayDateStr) then
        StatusBanner.BackgroundColor3 = Color3.fromRGB(15, 60, 30)
        StatusMsg.TextColor3 = Color3.fromRGB(80, 255, 140)
        StatusMsg.Text = "✔ Key hợp lệ! Đang khởi chạy Solix Hub..."
        CheckKeyBtn.Text = "✔ THÀNH CÔNG"
        CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 70)
        
        -- 🌟 LƯU TRẠNG THÁI XÁC THỰC VÀO FILE MÁY TÍNH/ĐIỆN THOẠI
        if writefile then
            pcall(function()
                writefile(SAVE_FILE_NAME, todayDateStr)
            end)
        end
        
        -- Khởi chạy script chính
        LaunchMainScript()
        
        task.wait(0.3)
        PlaySuccessFadeOut()
    else
        isChecking = false
        CheckKeyBtn.Text = "✔ KIỂM TRA KEY"
        StatusBanner.BackgroundColor3 = Color3.fromRGB(65, 15, 20)
        StatusMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusMsg.Text = "✖ Key không hợp lệ hoặc đã hết hạn ngày hôm nay!"
        
        InputStroke.Color = Color3.fromRGB(255, 70, 70)
        task.wait(0.6)
        InputStroke.Color = Color3.fromRGB(45, 38, 70)
    end
end)
