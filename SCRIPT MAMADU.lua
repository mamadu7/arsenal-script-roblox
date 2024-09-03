-- Carregar a biblioteca de UI
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/7yhx/kwargs_Ui_Library/main/source.lua"))()

-- Criar a interface gráfica
local UI = Lib:Create{
    Theme = "Dark",
    Size = UDim2.new(0, 555, 0, 400)
}

local Main = UI:Tab{
    Name = "Main"
}

local Settings = Main:Divider{
    Name = "Settings"
}

local Controls = Main:Divider{
    Name = "Controls"
}

local ESPSettings = Main:Divider{
    Name = "ESP Settings"
}

-- Mensagem centralizada
local CenterMessage = Main:TextLabel{
    Text = "by mamadu",
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0.5, -100, 0, 10),
    AnchorPoint = Vector2.new(0.5, 0),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    TextScaled = true,
    Font = Enum.Font.SourceSansBold,
    TextSize = 24
}

-- Variáveis de controle
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local isEnabled = false
local flying = false
local running = false

-- Função para ativar/desativar o script
local function toggleScript(State)
    isEnabled = State
end

-- Função para ativar/desativar o voo
local function toggleFly(State)
    flying = State
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = flying
    end
end

-- Função para ativar/desativar a corrida rápida
local function toggleRun(State)
    running = State
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = running and 50 or 16
    end
end

-- Função para aplicar cores RGB às armas
local function setWeaponColors()
    while isEnabled do
        for _, tool in pairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                for _, part in pairs(tool:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(tick() % 1, 1, 1) -- Cores RGB baseadas no tempo
                    end
                end
            end
        end
        wait(5) -- Atualizar a cada 5 segundos
    end
end

-- Função para desenhar a caixa ao redor dos inimigos
local function highlightPlayers()
    while isEnabled do
        for _, obj in pairs(workspace:FindPartsInRegion3(camera.CFrame:ToWorldSpace(CFrame.new(0, 0, -500)).Position, Vector3.new(1000, 1000, 1000), nil)) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= player.Name then
                local head = obj:FindFirstChild("Head")
                if head then
                    local box = Instance.new("BillboardGui")
                    box.Adornee = head
                    box.Size = UDim2.new(0, 200, 0, 200)
                    box.StudsOffset = Vector3.new(0, 2, 0)
                    box.AlwaysOnTop = true
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    frame.BackgroundTransparency = 0.5
                    frame.Parent = box
                    box.Parent = camera:FindFirstChildOfClass("PlayerGui")
                end
            end
        end
        wait(1) -- Atualizar a cada segundo
    end
end

-- Função para aimbot (mirar automaticamente nos inimigos)
local function aimbot()
    while isEnabled do
        local target = nil
        local shortestDistance = math.huge
        for _, obj in pairs(workspace:FindPartsInRegion3(camera.CFrame:ToWorldSpace(CFrame.new(0, 0, -500)).Position, Vector3.new(1000, 1000, 1000), nil)) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= player.Name then
                local head = obj:FindFirstChild("Head")
                if head then
                    local screenPosition, isVisible = camera:WorldToViewportPoint(head.Position)
                    local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        target = head
                    end
                end
            end
        end
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
        wait(0.1) -- Atualizar a cada 0.1 segundos
    end
end

-- Configuração da UI
Settings:Toggle{
    Name = "Enable Script",
    Description = "Ativa ou desativa o script.",
    Callback = function(State)
        toggleScript(State)
        if State then
            if player.Character then
                setWeaponColors()
                highlightPlayers()
                aimbot()
            end
        end
    end
}

Controls:Toggle{
    Name = "Enable Fly",
    Description = "Ativa ou desativa o voo.",
    Callback = function(State)
        toggleFly(State)
    end
}

Controls:Toggle{
    Name = "Enable Speed",
    Description = "Ativa ou desativa a corrida rápida.",
    Callback = function(State)
        toggleRun(State)
    end
}

ESPSettings:ColorPicker{
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        -- Atualizar a cor do ESP se necessário
    end
}

-- Botão para fechar a UI
local Quit = Settings:Button{
    Name = "MAMADU",
    Callback = function()
        UI:Quit{
            Message = "Closing UI...",
            Length = 1
        }
    end
}

-- Função para atualizar o FOV (não implementado diretamente no código; depende do seu método de visualização)
-- Se necessário, você pode adicionar uma implementação personalizada para ajustar o campo de visão.
