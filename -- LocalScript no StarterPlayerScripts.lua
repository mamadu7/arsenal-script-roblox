-- LocalScript no StarterPlayerScripts

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
    Size = UDim2.new(1, 0, 0, 30), -- Ajuste o tamanho conforme necessário
    Position = UDim2.new(0.5, -100, 0, 10), -- Centralizado no meio (ajuste o valor -100 conforme o tamanho do texto)
    AnchorPoint = Vector2.new(0.5, 0),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1, -- Transparente
    TextScaled = true, -- Ajusta o tamanho do texto
    Font = Enum.Font.SourceSansBold,
    TextSize = 24 -- Tamanho do texto
}

-- Variáveis de controle
local isEnabled = false
local flying = false
local running = false

local function toggleScript(State)
    isEnabled = State
end

local function toggleFly(State)
    flying = State
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = flying
    end
end

local function toggleRun(State)
    running = State
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = running and 50 or 16
    end
end

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

local function highlightPlayers()
    while isEnabled do
        for _, obj in pairs(workspace:FindPartsInRegion3(camera.CFrame:ToWorldSpace(CFrame.new(0, 0, -500)).Position, Vector3.new(1000, 1000, 1000), nil)) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                local teamColor = obj.Parent:FindFirstChild("TeamColor") and obj.Parent.TeamColor.Value
                if teamColor and teamColors[teamColor] then
                    -- Desenhar a caixa ao redor do jogador
                    -- Note: Para desenhar uma caixa, você precisará adicionar objetos de GUI ou usar o método de desenho do Roblox
                end
            end
        end
        wait(1) -- Atualizar a cada segundo
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
    Default = Color3.fromRGB(0, 255, 255),
    Callback = function(Value)
        -- Atualizar a cor do ESP se necessário
        -- No código real, você pode usar essa cor para desenhar caixas ao redor dos inimigos
    end
}

local function onCharacterAdded(character)
    character:WaitForChild("Humanoid").PlatformStand = false
    if isEnabled then
        setWeaponColors()
        highlightPlayers()
    end
end

-- Conectar evento de adicionar personagem
player.CharacterAdded:Connect(onCharacterAdded)

-- Se o personagem já estiver carregado, configurar as funcionalidades
if player.Character then
    onCharacterAdded(player.Character)
end

-- Botão para fechar a UI
local Quit = Settings:Button{
    Name = "Close UI",
    Callback = function()
        UI:Quit{
            Message = "Closing UI...",
            Length = 1
        }
    end
}
