-- LocalScript (StarterGui -> ScreenGui)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local guiName = "DuplicatorGUI"
local event = ReplicatedStorage:WaitForChild("DuplicateEvent")

-- Nombre del modelo en Workspace que se duplicará (ajusta al nombre real)
local TARGET_NAME = "PlantToDuplicate"

-- Crea ScreenGui y botón si no existen
local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild(guiName)
if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = guiName
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Contenedor
local frame = screenGui:FindFirstChild("Frame")
if not frame then
    frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.Position = UDim2.new(0.5, -100, 0.9, -30)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 0.4
    frame.Parent = screenGui
end

-- Botón "Duplicar"
local button = frame:FindFirstChild("DuplicarButton")
if not button then
    button = Instance.new("TextButton")
    button.Name = "DuplicarButton"
    button.Size = UDim2.new(1, -10, 1, -10)
    button.Position = UDim2.new(0, 5, 0, 5)
    button.Text = "Duplicar"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.Parent = frame
end

-- Feedback simple (texto temporal)
local function showTempText(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 24)
    lbl.Position = UDim2.new(0, 5, 0, -28)
    lbl.Text = text
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 18
    lbl.BackgroundTransparency = 0.6
    lbl.Parent = frame
    delay(2, function() pcall(function() lbl:Destroy() end) end)
end

-- Enviar petición al servidor
button.MouseButton1Click:Connect(function()
    -- Evita que el cliente intente duplicar nombres vacíos
    if not TARGET_NAME or TARGET_NAME == "" then
        showTempText("Objetivo no configurado")
        return
    end

    -- Pedimos al servidor duplicar ese modelo
    event:FireServer(TARGET_NAME)
    showTempText("Pedido enviado...")
end)
