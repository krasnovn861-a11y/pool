-- ROCKET ESP (FIXED VERSION)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Удаляем старые сломанные меню, если они остались в памяти
if LocalPlayer:FindFirstChild("PlayerGui") then
    local oldMenu = LocalPlayer.PlayerGui:FindFirstChild("RocketESP_Menu")
    if oldMenu then oldMenu:Destroy() end
end

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RocketESP_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0, 50) -- По центру сверху
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно таскать мышкой/пальцем
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "ROCKET ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "ESP: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = MainFrame

-- Логика
local isEspOn = false

local function ClearESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local hl = player.Character:FindFirstChild("RocketHL")
            if hl then hl:Destroy() end
        end
    end
end

local function ApplyESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not player.Character:FindFirstChild("RocketHL") then
                local hl = Instance.new("Highlight")
                hl.Name = "RocketHL"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.FillTransparency = 0.3
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = player.Character
            end
        end
    end
end

-- Кнопка
ToggleBtn.MouseButton1Click:Connect(function()
    isEspOn = not isEspOn
    
    if isEspOn then
        ToggleBtn.Text = "ESP: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        ApplyESP()
    else
        ToggleBtn.Text = "ESP: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ClearESP()
    end
end)

-- Обновление при респавне игроков
task.spawn(function()
    while task.wait(1) do
        if isEspOn then
            ApplyESP()
        end
    end
end)
