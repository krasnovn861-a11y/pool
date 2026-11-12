-- ROCKET ESP Template for Delta
-- Создано для RIVALS / универсального использования

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local ESP_COLOR = Color3.fromRGB(255, 0, 0) -- Красный цвет для врагов
local ESP_ENABLED = false
local ESP_OBJECTS = {}

-- ========================
-- 1. СОЗДАНИЕ МЕНЮ
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RocketESP_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Позволяет перетаскивать меню
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.BorderSizePixel = 0
Title.Text = "ROCKET ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Кнопка включения/выключения
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "ESP: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = MainFrame

-- ========================
-- 2. ЛОГИКА ESP
-- ========================
local function ClearESP()
    for _, obj in pairs(ESP_OBJECTS) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    ESP_OBJECTS = {}
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function ApplyHighlight(character)
        if not character then return end
        
        -- Удаляем старый highlight, если есть
        local oldHighlight = character:FindFirstChild("RocketESP_Highlight")
        if oldHighlight then oldHighlight:Destroy() end
        
        -- Создаём Highlight (виден сквозь стены)
        local highlight = Instance.new("Highlight")
        highlight.Name = "RocketESP_Highlight"
        highlight.FillColor = ESP_COLOR
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Ключевой параметр: всегда сверху
        highlight.Parent = character
        
        table.insert(ESP_OBJECTS, highlight)
    end
    
    -- Если персонаж уже есть
    if player.Character then
        ApplyHighlight(player.Character)
    end
    
    -- Отслеживаем появление/смерть персонажа
    player.CharacterAdded:Connect(function(char)
        if ESP_ENABLED then
            task.wait(0.5) -- Небольшая задержка для загрузки
            ApplyHighlight(char)
        end
    end)
end

local function EnableESP()
    ESP_ENABLED = true
    ToggleBtn.Text = "ESP: ON"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    
    -- Применяем ко всем текущим игрокам
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
    
    -- Слушаем новых игроков
    Players.PlayerAdded:Connect(function(player)
        if ESP_ENABLED then
            CreateESP(player)
        end
    end)
end

local function DisableESP()
    ESP_ENABLED = false
    ToggleBtn.Text = "ESP: OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ClearESP()
end

-- Обработчик кнопки
ToggleBtn.MouseButton1Click:Connect(function()
    if ESP_ENABLED then
        DisableESP()
    else
        EnableESP()
end
end)

-- ========================
-- 3. ОЧИСТКА ПРИ ВЫХОДЕ
-- ========================
-- При смерти/респавне можно добавить повторное применение, 
-- но Highlight сам привязывается к персонажу.
print("ROCKET ESP Loaded. Menu created.")