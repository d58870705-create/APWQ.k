-- Kuskc Hub - ESP & Name Tag (Mobile Delta Fixed)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ลบ UI เก่าทิ้งถ้ามีอยู่แล้ว
if PlayerGui:FindFirstChild("KuskcHub_ESP") then
    PlayerGui.KuskcHub_ESP:Destroy()
end

-- สร้าง ScreenGui (ย้ายมาไว้ที่ PlayerGui เพื่อให้มือถือมองเห็น)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KuskcHub_ESP"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- สร้างกรอบหน้าต่างหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -90)
MainFrame.Size = UDim2.new(0, 220, 0, 180)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- แถบหัวข้อ (TitleBar สำหรับลาก UI)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -15, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Kuskc Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มเปิด/ปิด ESP (Toggle Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 45)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ESP: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Parent = MainFrame
CreditLabel.BackgroundTransparency = 1
CreditLabel.Position = UDim2.new(0, 0, 0.8, 0)
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Font = Enum.Font.Gotham
CreditLabel.Text = "By Kuskc Hub"
CreditLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
CreditLabel.TextSize = 11

-- ระบบลาก UI (Draggable สำหรับมือถือ)
local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ฟังก์ชัน ESP
local espEnabled = false
local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "KuskcHighlight"
    highlight.FillColor = Color3.fromRGB(0, 170, 255) -- ฟ้า
    highlight.OutlineColor = Color3.fromRGB(255, 220, 0) -- เหลือง
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Enabled = false
    
    local function onCharacterAdded(char)
        highlight.Adornee = char
        highlight.Parent = char
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    espCache[player] = highlight
end

local function removeESP(player)
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ToggleButton.Text = "ESP: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "ESP: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end
    
    for _, hl in pairs(espCache) do
        hl.Enabled = espEnabled
    end
end)

print("Kuskc Hub Loaded Successfully!")
