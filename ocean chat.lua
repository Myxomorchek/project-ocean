local renv = getrenv()
local mps = renv.MarketplaceService or renv.game:GetService("MarketplaceService")

if mps and mps.PromptPurchaseRequestedV2 then

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Exploit Functions
local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request
local getAssetFunc = getcustomasset or getsynasset

if not requestFunc then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Your exploit doesn't support HTTP requests!",
        Duration = 10
    })
    return
end

-- Configuration
local API_URL = "https://script.google.com/macros/s/AKfycbxIEDU1_FcJ2pOz4WdItaro_ZZ8QronK1--9Z368MSVnvddqrRCEVYszqhFk2ugkYZP9g/exec"
local currentWidth, currentHeight = 340, 300
local isMinimized = false

-- UI Setup – Library Style
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxChatStyle"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or CoreGui

local ChatWindow = Instance.new("Frame")
ChatWindow.Name = "ChatWindow"
ChatWindow.Size = UDim2.new(0, currentWidth, 0, currentHeight)
ChatWindow.Position = UDim2.new(0, 12, 0.5, -150)
ChatWindow.BackgroundColor3 = Color3.fromRGB(8, 8, 8)      -- dark background
ChatWindow.BorderColor3 = Color3.fromRGB(0, 60, 0)         -- green outline
ChatWindow.BorderSizePixel = 1
ChatWindow.ClipsDescendants = true
ChatWindow.Parent = ScreenGui

-- Custom Background Image Label (overlay)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "CustomBackground"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.ImageTransparency = 1
BackgroundImage.ZIndex = 0
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = ChatWindow

-- Title Bar – Library style
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
TitleBar.BorderColor3 = Color3.fromRGB(0, 40, 0)
TitleBar.BorderSizePixel = 1
TitleBar.ZIndex = 2
TitleBar.Parent = ChatWindow

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -160, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "> Global Chat"
TitleText.TextColor3 = Color3.fromRGB(0, 180, 0)      -- green header
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 3
TitleText.Parent = TitleBar

-- Window Controls (Library style)
local function createControlButton(text, posX, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.Position = UDim2.new(1, posX, 0.5, -12)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(100, 100, 100)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.ZIndex = 3
    btn.Parent = TitleBar

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = hoverColor or Color3.fromRGB(0, 180, 0)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play()
    end)

    return btn
end

local BtnMinimize = createControlButton("_", -30)
local BtnPlus = createControlButton("+", -58)
local BtnMinus = createControlButton("-", -86)
local BtnSettings = createControlButton("⚙", -114)

-- Main Chat Container
local ChatContainer = Instance.new("Frame")
ChatContainer.Name = "ChatContainer"
ChatContainer.Size = UDim2.new(1, 0, 1, -32)
ChatContainer.Position = UDim2.new(0, 0, 0, 32)
ChatContainer.BackgroundTransparency = 1
ChatContainer.Parent = ChatWindow

local ChatScroll = Instance.new("ScrollingFrame")
ChatScroll.Name = "ChatScroll"
ChatScroll.Size = UDim2.new(1, -16, 1, -56)
ChatScroll.Position = UDim2.new(0, 8, 0, 4)
ChatScroll.BackgroundTransparency = 1
ChatScroll.ScrollBarThickness = 2
ChatScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 60, 0)
ChatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatScroll.BorderSizePixel = 0
ChatScroll.Parent = ChatContainer

local ChatListLayout = Instance.new("UIListLayout")
ChatListLayout.Padding = UDim.new(0, 6)
ChatListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatListLayout.Parent = ChatScroll

-- Input area – Library style
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, -16, 0, 36)
InputFrame.Position = UDim2.new(0, 8, 1, -44)
InputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InputFrame.BorderColor3 = Color3.fromRGB(0, 60, 0)
InputFrame.BorderSizePixel = 1
InputFrame.Parent = ChatContainer

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -44, 1, -8)
InputBox.Position = UDim2.new(0, 8, 0, 4)
InputBox.BackgroundTransparency = 1
InputBox.TextColor3 = Color3.fromRGB(0, 180, 0)
InputBox.PlaceholderText = "Type a message..."
InputBox.Text = ""
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
InputBox.Font = Enum.Font.Code
InputBox.TextSize = 12
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextWrapped = true
InputBox.ClearTextOnFocus = false
InputBox.Parent = InputFrame

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0, 28, 0, 28)
SendButton.Position = UDim2.new(1, -32, 0.5, -14)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
SendButton.BorderColor3 = Color3.fromRGB(0, 100, 0)
SendButton.BorderSizePixel = 1
SendButton.Text = "↑"
SendButton.TextColor3 = Color3.fromRGB(0, 180, 0)
SendButton.Font = Enum.Font.Code
SendButton.TextSize = 16
SendButton.Parent = InputFrame

-- Settings Menu (updated to library style)
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SettingsFrame.BorderColor3 = Color3.fromRGB(0, 60, 0)
SettingsFrame.BorderSizePixel = 1
SettingsFrame.Visible = false
SettingsFrame.ZIndex = 5
SettingsFrame.Parent = ChatContainer

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 10)
SettingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SettingsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
SettingsLayout.Parent = SettingsFrame

local BgImageInput = Instance.new("TextBox")
BgImageInput.Size = UDim2.new(0.9, 0, 0, 30)
BgImageInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BgImageInput.BorderColor3 = Color3.fromRGB(0, 60, 0)
BgImageInput.BorderSizePixel = 1
BgImageInput.TextColor3 = Color3.fromRGB(0, 180, 0)
BgImageInput.PlaceholderText = "URL or Asset ID..."
BgImageInput.Text = ""
BgImageInput.Font = Enum.Font.Code
BgImageInput.TextSize = 12
BgImageInput.Parent = SettingsFrame

local TransparencyInput = Instance.new("TextBox")
TransparencyInput.Size = UDim2.new(0.9, 0, 0, 30)
TransparencyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TransparencyInput.BorderColor3 = Color3.fromRGB(0, 60, 0)
TransparencyInput.BorderSizePixel = 1
TransparencyInput.TextColor3 = Color3.fromRGB(0, 180, 0)
TransparencyInput.PlaceholderText = "Transparency (0 - 1)"
TransparencyInput.Text = ""
TransparencyInput.Font = Enum.Font.Code
TransparencyInput.TextSize = 12
TransparencyInput.Parent = SettingsFrame

local ApplySettingsBtn = Instance.new("TextButton")
ApplySettingsBtn.Size = UDim2.new(0.5, 0, 0, 30)
ApplySettingsBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
ApplySettingsBtn.BorderColor3 = Color3.fromRGB(0, 100, 0)
ApplySettingsBtn.BorderSizePixel = 1
ApplySettingsBtn.TextColor3 = Color3.fromRGB(0, 180, 0)
ApplySettingsBtn.Text = "APPLY"
ApplySettingsBtn.Font = Enum.Font.Code
ApplySettingsBtn.TextSize = 12
ApplySettingsBtn.Parent = SettingsFrame

-- ===== DRAG SUPPORT (Mouse + Touch) =====
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ChatWindow.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ChatWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ===== BUTTON LOGIC =====
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    BtnMinimize.Text = isMinimized and "+" or "_"
    TweenService:Create(ChatWindow, TweenInfo.new(0.3), {Size = isMinimized and UDim2.new(0, currentWidth, 0, 32) or UDim2.new(0, currentWidth, 0, currentHeight)}):Play()
    ChatContainer.Visible = not isMinimized
end)

BtnPlus.MouseButton1Click:Connect(function()
    if isMinimized then return end
    currentWidth = currentWidth + 40
    currentHeight = currentHeight + 40
    TweenService:Create(ChatWindow, TweenInfo.new(0.2), {Size = UDim2.new(0, currentWidth, 0, currentHeight)}):Play()
end)

BtnMinus.MouseButton1Click:Connect(function()
    if isMinimized then return end
    currentWidth = math.max(260, currentWidth - 40)
    currentHeight = math.max(260, currentHeight - 40)
    TweenService:Create(ChatWindow, TweenInfo.new(0.2), {Size = UDim2.new(0, currentWidth, 0, currentHeight)}):Play()
end)

BtnSettings.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible
end)

-- Settings Background Applier
ApplySettingsBtn.MouseButton1Click:Connect(function()
    local trans = tonumber(TransparencyInput.Text) or 0.5
    BackgroundImage.ImageTransparency = trans
    local inputStr = BgImageInput.Text
    
    if inputStr == "" then
        BackgroundImage.Image = ""
        return
    end

    if inputStr:sub(1, 4) == "http" then
        local fileName = "custom_bg_" .. tostring(math.random(1, 1000000)) .. ".png"
        pcall(function()
            writefile(fileName, game:HttpGet(inputStr))
            BackgroundImage.Image = getAssetFunc(fileName)
        end)
    else
        local id = inputStr:match("%d+")
        if id then
            BackgroundImage.Image = "rbxassetid://" .. id
        end
    end
end)

-- ===== CHAT HANDLING =====
local msgCount = 0

local function createMessageUI(sender, text, isLocal)
    msgCount += 1
    
    local MsgFrame = Instance.new("Frame")
    MsgFrame.Size = UDim2.new(1, 0, 0, 0)
    MsgFrame.AutomaticSize = Enum.AutomaticSize.Y
    MsgFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MsgFrame.BorderColor3 = Color3.fromRGB(0, 40, 0)
    MsgFrame.BorderSizePixel = 1
    MsgFrame.LayoutOrder = msgCount
    MsgFrame.Parent = ChatScroll
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 6)
    Padding.PaddingBottom = UDim.new(0, 6)
    Padding.PaddingLeft = UDim.new(0, 8)
    Padding.PaddingRight = UDim.new(0, 8)
    Padding.Parent = MsgFrame
    
    local MsgLayout = Instance.new("UIListLayout")
    MsgLayout.Padding = UDim.new(0, 2)
    MsgLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MsgLayout.Parent = MsgFrame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0, 16)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.Code
    NameLabel.TextSize = 12
    NameLabel.TextColor3 = isLocal and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(255, 200, 100)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Text = sender
    NameLabel.LayoutOrder = 1
    NameLabel.Parent = MsgFrame
    
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, 0, 0, 0)
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Font = Enum.Font.Code
    ContentLabel.TextSize = 12
    ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.RichText = true
    ContentLabel.Text = text
    ContentLabel.LayoutOrder = 2
    ContentLabel.Parent = MsgFrame
    
    task.delay(0.05, function()
        ChatScroll.CanvasPosition = Vector2.new(0, ChatScroll.AbsoluteCanvasSize.Y)
    end)
end

local function handleSendMessage()
    local text = InputBox.Text
    if text == "" or text:match("^%s*$") then return end
    
    InputBox.Text = ""
    createMessageUI(LocalPlayer.Name, text, true)
    
    task.spawn(function()
        local payload = { sender = LocalPlayer.Name, message = text }
        pcall(function()
            requestFunc({
                Url = API_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

SendButton.MouseButton1Click:Connect(handleSendMessage)
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        handleSendMessage()
    end
end)

-- Polling Loop
task.spawn(function()
    local lastTimestamp = 0
    while task.wait(3) do
        local success, response = pcall(function()
            return requestFunc({
                Url = API_URL .. "?after=" .. tostring(lastTimestamp),
                Method = "GET"
            })
        end)
        
        if success and response and response.StatusCode == 200 then
            local decodeSuccess, data = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            
            if decodeSuccess and type(data) == "table" then
                table.sort(data, function(a, b) return (a.timestamp or 0) < (b.timestamp or 0) end)
                for _, msg in ipairs(data) do
                    if msg.sender ~= LocalPlayer.Name then
                        createMessageUI(msg.sender, msg.message, false)
                    end
                    if msg.timestamp and msg.timestamp > lastTimestamp then
                        lastTimestamp = msg.timestamp
                    end
                end
            end
        end
    end
end)

end