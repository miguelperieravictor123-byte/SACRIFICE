--=============================================================
-- SACRIFICE HUB — DELTA EXECUTOR EDITION
-- LOADING + WINDUI + KING TAG + AIMBOT + HITBOX + ESP + FLING + SKIN + ANIMAÇÕES
-- Tema: SAKURA 🌸
--=============================================================

--========== SERVIÇOS ==========
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")

--========== HTTP SEGURO (Delta-safe) ==========
local function safeHttpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res then return res end
    if syn and syn.request then
        local r = syn.request({Url = url, Method = "GET"})
        if r and r.Body then return r.Body end
    end
    if request then
        local r = request({Url = url, Method = "GET"})
        if r and r.Body then return r.Body end
    end
    if http_request then
        local r = http_request({Url = url, Method = "GET"})
        if r and r.Body then return r.Body end
    end
    return nil
end

--========== DRAWING SEGURO ==========
local DrawingSupported = (typeof(Drawing) == "table" and typeof(Drawing.new) == "function")
local function SafeDrawing(class)
    if not DrawingSupported then return nil end
    local ok, obj = pcall(function() return Drawing.new(class) end)
    if ok then return obj end
    return nil
end

--========== PARENT SEGURO (Delta-safe) ==========
local guiParent
do
    local ok, result = pcall(function() return gethui() end)
    if ok and result then guiParent = result end
end
if not guiParent then
    local ok2, result2 = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and result2 then guiParent = result2 end
end
if not guiParent then
    local player = Players.LocalPlayer
    if player then
        guiParent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 10)
    end
end
if not guiParent then
    warn("[SACRIFICE HUB] Não foi possível obter GUI Parent.")
    return
end

--========== LIMPEZA ==========
for _, child in ipairs(guiParent:GetChildren()) do
    if child.Name == "SacrificeHubLoading" or child.Name == "SacrificeAimbotFloat" or child.Name == "SacrificeObrigado" then
        child:Destroy()
    end
end

--========== CONFIG ==========
local CONFIG = {
    CorPinkEscuro    = Color3.fromRGB(255, 20, 147),
    CorPinkClaro     = Color3.fromRGB(255, 179, 209),
    CorPinkMedio     = Color3.fromRGB(255, 77, 148),
    CorFundo         = Color3.fromRGB(10, 2, 8),
    TempoTotal       = 5,
    QuantidadePetalas = 60,
    GlowVelocidade   = 1.2,
    GlowMin          = 0.15,
    GlowMax          = 0.75,
}

local screenW = workspace.CurrentCamera.ViewportSize.X
local screenH = workspace.CurrentCamera.ViewportSize.Y

--=============================================================
-- 👑 TAG KING
--=============================================================
local function criarTagKing()
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 10)
    if not head then return end

    local antiga = head:FindFirstChild("KingSakuraTag")
    if antiga then antiga:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KingSakuraTag"
    billboard.Size = UDim2.new(0, 260, 0, 120)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 200
    billboard.Parent = head

    local nomeKing = Instance.new("TextLabel")
    nomeKing.Name = "KingText"
    nomeKing.Size = UDim2.new(1, 0, 0.55, 0)
    nomeKing.Position = UDim2.new(0, 0, 0.15, 0)
    nomeKing.BackgroundTransparency = 1
    nomeKing.Text = "KING"
    nomeKing.Font = Enum.Font.GothamBlack
    nomeKing.TextSize = 48
    nomeKing.TextColor3 = Color3.fromRGB(255, 105, 180)
    nomeKing.TextStrokeTransparency = 0.3
    nomeKing.TextStrokeColor3 = Color3.fromRGB(255, 20, 147)
    nomeKing.Parent = billboard

    local gradTexto = Instance.new("UIGradient")
    gradTexto.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 192, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147)),
    })
    gradTexto.Rotation = 90
    gradTexto.Parent = nomeKing

    local coroa = Instance.new("TextLabel")
    coroa.Size = UDim2.new(1, 0, 0.4, 0)
    coroa.Position = UDim2.new(0, 0, -0.15, 0)
    coroa.BackgroundTransparency = 1
    coroa.Text = "👑"
    coroa.Font = Enum.Font.GothamBold
    coroa.TextSize = 36
    coroa.TextColor3 = Color3.fromRGB(255, 215, 0)
    coroa.Parent = billboard

    local subtexto = Instance.new("TextLabel")
    subtexto.Size = UDim2.new(1, 0, 0.25, 0)
    subtexto.Position = UDim2.new(0, 0, 0.68, 0)
    subtexto.BackgroundTransparency = 1
    subtexto.Text = "◆ SACRIFICE HUB ◆"
    subtexto.Font = Enum.Font.GothamBold
    subtexto.TextSize = 12
    subtexto.TextColor3 = Color3.fromRGB(255, 179, 209)
    subtexto.TextStrokeTransparency = 0.5
    subtexto.Parent = billboard

    local petalasTag = {}
    for i = 1, 8 do
        local petala = Instance.new("TextLabel")
        petala.Size = UDim2.new(0, 20, 0, 20)
        petala.BackgroundTransparency = 1
        petala.Text = "🌸"
        petala.Font = Enum.Font.GothamBold
        petala.TextSize = math.random(14, 22)
        petala.TextColor3 = Color3.fromRGB(255, 179, 209)
        petala.Position = UDim2.new(math.random(), 0, math.random(), 0)
        petala.Parent = billboard
        table.insert(petalasTag, {
            obj = petala,
            velY = math.random(20, 45) / 100,
            velX = math.random(-15, 15) / 100,
            rotVel = math.random(-3, 3),
            offsetY = math.random(),
        })
    end

    local brilhoAtivo = true
    task.spawn(function()
        while brilhoAtivo and billboard.Parent do
            local i1 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(nomeKing, i1, {
                TextColor3 = Color3.fromRGB(255, 192, 220),
                TextStrokeTransparency = 0,
            }):Play()
            task.wait(0.8)
            local i2 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(nomeKing, i2, {
                TextColor3 = Color3.fromRGB(255, 105, 180),
                TextStrokeTransparency = 0.3,
            }):Play()
            task.wait(0.8)
        end
    end)

    local connPetalas = RunService.RenderStepped:Connect(function(dt)
        if not billboard.Parent then return end
        for _, p in ipairs(petalasTag) do
            if p.obj and p.obj.Parent then
                local pos = p.obj.Position
                p.offsetY = p.offsetY + p.velY * dt
                if p.offsetY > 1.1 then
                    p.offsetY = -0.1
                    pos = UDim2.new(math.random(), 0, -0.1, 0)
                end
                p.obj.Position = UDim2.new(pos.X.Scale + p.velX * dt, 0, p.offsetY, 0)
                p.obj.Rotation = p.obj.Rotation + p.rotVel * dt * 30
            end
        end
    end)

    local connMorte
    connMorte = Players.LocalPlayer.CharacterAdded:Connect(function()
        brilhoAtivo = false
        if connPetalas then connPetalas:Disconnect() end
        if connMorte then connMorte:Disconnect() end
        if billboard then billboard:Destroy() end
        task.wait(1)
        criarTagKing()
    end)
end

--=============================================================
-- LOADING GUI
--=============================================================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "SacrificeHubLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999999
loadingGui.Parent = guiParent

local fundo = Instance.new("Frame")
fundo.Size = UDim2.new(1, 0, 1, 0)
fundo.BackgroundColor3 = CONFIG.CorFundo
fundo.BorderSizePixel = 0
fundo.Parent = loadingGui

local gradFundo = Instance.new("UIGradient")
gradFundo.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 10, 26)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 2, 8)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(42, 10, 26)),
})
gradFundo.Rotation = 45
gradFundo.Parent = fundo

local card = Instance.new("Frame")
card.Size = UDim2.new(0, 420, 0, 220)
card.Position = UDim2.new(0.5, -210, 0.5, -110)
card.BackgroundColor3 = Color3.fromRGB(20, 5, 15)
card.BackgroundTransparency = 0.15
card.BorderSizePixel = 0
card.Parent = loadingGui

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 16)
cardCorner.Parent = card

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = CONFIG.CorPinkEscuro
stroke.Transparency = 0.1
stroke.Parent = card

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 55)
titulo.Position = UDim2.new(0, 0, 0, 30)
titulo.BackgroundTransparency = 1
titulo.Text = "SACRIFICE HUB"
titulo.TextColor3 = CONFIG.CorPinkEscuro
titulo.TextSize = 38
titulo.Font = Enum.Font.GothamBold
titulo.TextStrokeTransparency = 0.4
titulo.TextStrokeColor3 = CONFIG.CorPinkEscuro
titulo.Parent = card

local gradTitulo = Instance.new("UIGradient")
gradTitulo.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.CorPinkEscuro),
    ColorSequenceKeypoint.new(0.5, CONFIG.CorPinkClaro),
    ColorSequenceKeypoint.new(1, CONFIG.CorPinkEscuro),
})
gradTitulo.Parent = titulo

local subtitulo = Instance.new("TextLabel")
subtitulo.Size = UDim2.new(1, 0, 0, 20)
subtitulo.Position = UDim2.new(0, 0, 0, 85)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "LOADING EXPERIENCE"
subtitulo.TextColor3 = CONFIG.CorPinkClaro
subtitulo.TextSize = 11
subtitulo.Font = Enum.Font.Gotham
subtitulo.Parent = card

-- Barra
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 340, 0, 10)
barBg.Position = UDim2.new(0.5, -170, 1, -80)
barBg.BackgroundColor3 = Color3.fromRGB(40, 15, 30)
barBg.BorderSizePixel = 0
barBg.Parent = card

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = CONFIG.CorPinkEscuro
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local txtPercent = Instance.new("TextLabel")
txtPercent.Size = UDim2.new(0, 60, 0, 20)
txtPercent.Position = UDim2.new(1, -60, 1, -55)
txtPercent.BackgroundTransparency = 1
txtPercent.Text = "0%"
txtPercent.TextColor3 = CONFIG.CorPinkEscuro
txtPercent.TextSize = 14
txtPercent.Font = Enum.Font.GothamBold
txtPercent.TextXAlignment = Enum.TextXAlignment.Right
txtPercent.Parent = card

local txtStatus = Instance.new("TextLabel")
txtStatus.Size = UDim2.new(0, 300, 0, 20)
txtStatus.Position = UDim2.new(0, 0, 1, -55)
txtStatus.BackgroundTransparency = 1
txtStatus.Text = "Iniciando..."
txtStatus.TextColor3 = CONFIG.CorPinkClaro
txtStatus.TextSize = 12
txtStatus.Font = Enum.Font.Gotham
txtStatus.TextXAlignment = Enum.TextXAlignment.Left
txtStatus.Parent = card

--=============================================================
-- CHUVA DE SAKURA
--=============================================================
local petalas = {}
local connectionPetalas

if DrawingSupported then
    for i = 1, CONFIG.QuantidadePetalas do
        local petala = SafeDrawing("Circle")
        if petala then
            petala.Radius = math.random(4, 9)
            petala.Color = Color3.fromRGB(255, 105, 180)
            petala.Filled = true
            petala.Transparency = math.random(50, 90) / 100
            petala.Position = Vector2.new(math.random(0, screenW), math.random(-screenH, 0))
            petala.Visible = true
            table.insert(petalas, {
                objeto = petala,
                velocidadeY = math.random(80, 200) / 100,
                velocidadeX = math.random(-30, 30) / 100,
                rotacao = 0,
                rotacaoVel = math.random(-2, 2),
                tamanhoBase = petala.Radius,
            })
        end
    end

    if #petalas > 0 then
        connectionPetalas = RunService.RenderStepped:Connect(function(dt)
            for _, p in ipairs(petalas) do
                if p.objeto and p.objeto.Visible then
                    local pos = p.objeto.Position
                    pos = Vector2.new(
                        pos.X + p.velocidadeX * dt * 60,
                        pos.Y + p.velocidadeY * dt * 60
                    )
                    if pos.Y > screenH + 20 then
                        pos = Vector2.new(math.random(0, screenW), -20)
                    end
                    if pos.X < -20 then pos = Vector2.new(screenW + 20, pos.Y) end
                    if pos.X > screenW + 20 then pos = Vector2.new(-20, pos.Y) end
                    p.objeto.Position = pos
                    p.rotacao = p.rotacao + p.rotacaoVel * dt
                    local fator = 0.7 + math.abs(math.sin(p.rotacao)) * 0.6
                    p.objeto.Radius = p.tamanhoBase * fator
                end
            end
        end)
    end
end

--=============================================================
-- PROGRESSO
--=============================================================
local stages = {
    { at = 0,   texto = "Iniciando..." },
    { at = 20,  texto = "Carregando módulos..." },
    { at = 45,  texto = "Aplicando scripts..." },
    { at = 70,  texto = "Otimizando sistema..." },
    { at = 90,  texto = "Finalizando..." },
    { at = 100, texto = "Pronto! 🌸" },
}
local valorAtual = 0

--=============================================================
-- FUNÇÃO PRINCIPAL
--=============================================================
local function carregarWindUI()
    -- HttpGet seguro
    local src = safeHttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    if not src then
        warn("[SACRIFICE HUB] Falha ao baixar WindUI!")
        return
    end

    local func, err = loadstring(src)
    if not func then
        warn("[SACRIFICE HUB] loadstring falhou: " .. tostring(err))
        return
    end

    local WindUI = func()
    if not WindUI then
        warn("[SACRIFICE HUB] WindUI retornou nil!")
        return
    end

    -- Tema Sakura
    pcall(function()
        WindUI:AddTheme({
            Name        = "Sakura",
            Accent      = Color3.fromHex("#ff4d94"),
            Background  = Color3.fromHex("#1a0510"),
            Outline     = Color3.fromHex("#ff69b4"),
            Text        = Color3.fromHex("#ffd1e3"),
            Placeholder = Color3.fromHex("#b3748f"),
            Button      = Color3.fromHex("#ff4d94"),
            Icon        = Color3.fromHex("#ffb3d1"),
        })
        WindUI:SetTheme("Sakura")
    end)

    local LocalPlayer = Players.LocalPlayer
    local avatarUrl = ""
    pcall(function()
        avatarUrl = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)

    local Window = WindUI:CreateWindow({
        Title       = "SACRIFICE HUB",
        Icon        = "flower",
        Author      = LocalPlayer.DisplayName,
        Folder      = "SacrificeHub-Sakura",
        Size        = UDim2.fromOffset(580, 460),
        Transparent = true,
        Theme       = "Sakura",
        User        = { Enabled = true, Anonymous = false },
        SideBarWidth = 200,
        HasOutline   = true,
    })

    pcall(function()
        Window:Tag({
            Title = "v1.3.0-Delta",
            Icon  = "flower",
            Color = Color3.fromHex("#ff4d94"),
            Radius = 0,
        })
    end)

    --========== VOCÊ ==========
    local SectionUser = Window:Section({ Title = "🌸 Você", Icon = "user", Opened = true })
    pcall(function()
        SectionUser:Image({
            Title = LocalPlayer.DisplayName,
            Desc  = "@" .. LocalPlayer.Name .. " • UserId: " .. tostring(LocalPlayer.UserId),
            Image = avatarUrl,
        })
    end)
    pcall(function()
        SectionUser:Paragraph({
            Title = "Bem-vindo!",
            Desc  = "Olá, " .. LocalPlayer.DisplayName .. "! ESP + Aimbot + Hitbox + Fling + Skin + Animações carregados. 🌸",
            Color = Color3.fromHex("#ff4d94"),
        })
    end)

    --========== KING TAG ==========
    local TabKing = Window:Tab({ Title = "King Tag", Icon = "crown", Locked = false })

    TabKing:Button({
        Title = "👑 Recriar Tag KING",
        Desc  = "Recria a tag brilhante acima da sua cabeça",
        Callback = function()
            criarTagKing()
            WindUI:Notify({ Title = "👑 KING", Content = "Tag recriada!", Duration = 2, Icon = "crown" })
        end,
    })

    TabKing:Button({
        Title = "❌ Remover Tag KING",
        Desc  = "Remove a tag acima da cabeça",
        Callback = function()
            local char = Players.LocalPlayer.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local tag = head:FindFirstChild("KingSakuraTag")
                    if tag then tag:Destroy() end
                end
            end
            WindUI:Notify({ Title = "👑 KING", Content = "Tag removida!", Duration = 2, Icon = "trash" })
        end,
    })

    --========== AIMBOT ==========
    local TabAimbot = Window:Tab({ Title = "Aimbot", Icon = "crosshair", Locked = false })

    local AimbotConfig = {
        Enabled = false, Keybind = Enum.KeyCode.E, Mode = "Always",
        ShowFloating = true, ShowFOV = true, FOVSize = 200,
        MaxDistance = 800, TargetPart = "Head", Smoothness = 0.10,
        TeamCheck = true, Sticky = true, VisibleOnly = false, Active = false,
    }

    local camera = workspace.CurrentCamera
    local currentTarget = nil
    local savedCamType = nil

    local fovCircle = SafeDrawing("Circle")
    if fovCircle then
        fovCircle.Thickness = 2
        fovCircle.Color = Color3.fromRGB(255, 77, 148)
        fovCircle.Filled = false
        fovCircle.Transparency = 1
        fovCircle.NumSides = 100
        fovCircle.Visible = false
        fovCircle.Radius = AimbotConfig.FOVSize / 2
        fovCircle.Position = camera.ViewportSize / 2
    end

    local targetCircle = SafeDrawing("Circle")
    if targetCircle then
        targetCircle.Thickness = 2
        targetCircle.Color = Color3.fromRGB(255, 20, 147)
        targetCircle.Filled = false
        targetCircle.Transparency = 1
        targetCircle.NumSides = 40
        targetCircle.Radius = 14
        targetCircle.Visible = false
    end

    local floatingGui = Instance.new("ScreenGui")
    floatingGui.Name = "SacrificeAimbotFloat"
    floatingGui.ResetOnSpawn = false
    floatingGui.IgnoreGuiInset = true
    floatingGui.DisplayOrder = 999998
    floatingGui.Parent = guiParent

    local floatFrame = Instance.new("Frame")
    floatFrame.Size = UDim2.new(0, 150, 0, 42)
    floatFrame.Position = UDim2.new(0.5, -75, 0, 110)
    floatFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 15)
    floatFrame.BackgroundTransparency = 0.15
    floatFrame.BorderSizePixel = 0
    floatFrame.Active = true
    floatFrame.Draggable = true
    floatFrame.Parent = floatingGui

    local floatCorner = Instance.new("UICorner")
    floatCorner.CornerRadius = UDim.new(0, 10)
    floatCorner.Parent = floatFrame

    local floatStroke = Instance.new("UIStroke")
    floatStroke.Color = Color3.fromRGB(255, 77, 148)
    floatStroke.Thickness = 2
    floatStroke.Parent = floatFrame

    local floatLabel = Instance.new("TextLabel")
    floatLabel.Size = UDim2.new(1, 0, 1, 0)
    floatLabel.BackgroundTransparency = 1
    floatLabel.Text = "🎯 AIMBOT: OFF"
    floatLabel.TextColor3 = Color3.fromRGB(180, 130, 160)
    floatLabel.Font = Enum.Font.GothamBold
    floatLabel.TextSize = 14
    floatLabel.Parent = floatFrame

    local function getTargetPart(char)
        if not char then return nil end
        if AimbotConfig.TargetPart == "Head" then
            return char:FindFirstChild("Head")
        else
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                or char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart")
        end
    end

    local function isSameTeam(plr)
        if not AimbotConfig.TeamCheck then return false end
        local lp = Players.LocalPlayer
        if not lp.Team or not plr.Team then return false end
        return lp.Team == plr.Team
    end

    local function isVisible(part)
        if not AimbotConfig.VisibleOnly then return true end
        local origin = camera.CFrame.Position
        local dir = part.Position - origin
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local lpc = Players.LocalPlayer.Character
        params.FilterDescendantsInstances = lpc and { lpc } or {}
        local hit = workspace:Raycast(origin, dir, params)
        return hit == nil or hit.Instance:IsDescendantOf(part.Parent)
    end

    local function isTargetValid(part)
        if not part or not part.Parent then return false end
        local hum = part.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        local dist3D = (camera.CFrame.Position - part.Position).Magnitude
        if dist3D > AimbotConfig.MaxDistance then return false end
        local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
        if not onScreen or screenPos.Z <= 0 then return false end
        local center = camera.ViewportSize / 2
        local diff = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if diff > (AimbotConfig.FOVSize / 2) then return false end
        if not isVisible(part) then return false end
        return true
    end

    local function getClosestTarget()
        local shortest, targetPart = math.huge, nil
        local center = camera.ViewportSize / 2
        local localPos = camera.CFrame.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and not isSameTeam(plr) then
                    local part = getTargetPart(plr.Character)
                    if part then
                        local dist3D = (localPos - part.Position).Magnitude
                        if dist3D <= AimbotConfig.MaxDistance then
                            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                            if onScreen and screenPos.Z > 0 then
                                local diff = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                                if diff <= (AimbotConfig.FOVSize / 2) and diff < shortest then
                                    if isVisible(part) then
                                        shortest, targetPart = diff, part
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return targetPart
    end

    local function getTarget()
        if AimbotConfig.Sticky and currentTarget and isTargetValid(currentTarget) then
            return currentTarget
        end
        currentTarget = getClosestTarget()
        return currentTarget
    end

    local function isAimbotActive()
        if not AimbotConfig.Enabled then return false end
        if AimbotConfig.Mode == "Always" then return true end
        return AimbotConfig.Active
    end

    local function releaseAimbot()
        currentTarget = nil
        if savedCamType then
            camera.CameraType = savedCamType
            savedCamType = nil
        end
    end

    RunService.RenderStepped:Connect(function(dt)
        camera = workspace.CurrentCamera
        if fovCircle then
            if AimbotConfig.ShowFOV and AimbotConfig.Enabled then
                fovCircle.Visible = true
                fovCircle.Radius = AimbotConfig.FOVSize / 2
                fovCircle.Position = camera.ViewportSize / 2
            else
                fovCircle.Visible = false
            end
        end

        if AimbotConfig.ShowFloating then
            floatFrame.Visible = true
            if AimbotConfig.Enabled then
                floatLabel.Text = "🎯 AIMBOT: ON"
                floatLabel.TextColor3 = Color3.fromRGB(255, 77, 148)
            else
                floatLabel.Text = "🎯 AIMBOT: OFF"
                floatLabel.TextColor3 = Color3.fromRGB(180, 130, 160)
            end
        else
            floatFrame.Visible = false
        end

        if isAimbotActive() then
            local target = getTarget()
            if target and target.Parent then
                if camera.CameraType ~= Enum.CameraType.Scriptable then
                    savedCamType = camera.CameraType
                    camera.CameraType = Enum.CameraType.Scriptable
                end
                local camPos = camera.CFrame.Position
                local desired = CFrame.new(camPos, target.Position)
                local smooth = math.clamp(AimbotConfig.Smoothness, 0, 0.99)
                if smooth <= 0.01 then
                    camera.CFrame = desired
                else
                    local alpha = 1 - math.pow(smooth, dt * 60)
                    camera.CFrame = camera.CFrame:Lerp(desired, math.clamp(alpha, 0, 1))
                end
                if targetCircle then
                    local sp, onScr = camera:WorldToViewportPoint(target.Position)
                    if onScr and sp.Z > 0 then
                        targetCircle.Position = Vector2.new(sp.X, sp.Y)
                        targetCircle.Visible = true
                    else
                        targetCircle.Visible = false
                    end
                end
            else
                if targetCircle then targetCircle.Visible = false end
                releaseAimbot()
            end
        else
            if targetCircle then targetCircle.Visible = false end
            releaseAimbot()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == AimbotConfig.Keybind then
            if AimbotConfig.Mode == "Toggle" then
                AimbotConfig.Active = not AimbotConfig.Active
            elseif AimbotConfig.Mode == "Hold" then
                AimbotConfig.Active = true
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == AimbotConfig.Keybind and AimbotConfig.Mode == "Hold" then
            AimbotConfig.Active = false
        end
    end)

    TabAimbot:Toggle({ Title = "Aimbot", Desc = "Ativa mira automática", Default = false,
        Callback = function(s) AimbotConfig.Enabled = s; if not s then AimbotConfig.Active = false; releaseAimbot() end end })
    TabAimbot:Dropdown({ Title = "Modo", Desc = "Always/Hold/Toggle", Values = { "Always", "Hold", "Toggle" },
        Value = "Always", Multi = false, Callback = function(o) AimbotConfig.Mode = o end })
    TabAimbot:Toggle({ Title = "Sticky", Desc = "Gruda no alvo", Default = true,
        Callback = function(s) AimbotConfig.Sticky = s end })
    TabAimbot:Keybind({ Title = "Tecla", Desc = "Tecla pra ativar", Default = Enum.KeyCode.E,
        Callback = function(k) AimbotConfig.Keybind = k end })
    TabAimbot:Slider({ Title = "Smoothness", Desc = "0 = instantâneo", Value = { Min = 0, Max = 95, Default = 10 },
        Callback = function(v) AimbotConfig.Smoothness = v / 100 end })
    TabAimbot:Toggle({ Title = "Floating", Desc = "Mostra indicador", Default = true,
        Callback = function(s) AimbotConfig.ShowFloating = s end })
    TabAimbot:Toggle({ Title = "FOV Circle", Desc = "Círculo de FOV", Default = true,
        Callback = function(s) AimbotConfig.ShowFOV = s end })
    TabAimbot:Toggle({ Title = "Wall Check", Desc = "Só alvos visíveis", Default = false,
        Callback = function(s) AimbotConfig.VisibleOnly = s end })
    TabAimbot:Slider({ Title = "FOV Size", Desc = "Tamanho do FOV", Value = { Min = 0, Max = 800, Default = 200 },
        Callback = function(v) AimbotConfig.FOVSize = v end })
    TabAimbot:Slider({ Title = "Max Distance", Desc = "Distância máx", Value = { Min = 10, Max = 2000, Default = 800 },
        Callback = function(v) AimbotConfig.MaxDistance = v end })
    TabAimbot:Dropdown({ Title = "Target", Desc = "Parte do corpo", Values = { "Head", "Torso" },
        Value = "Head", Multi = false, Callback = function(o) AimbotConfig.TargetPart = o end })
    TabAimbot:Toggle({ Title = "Team Check", Desc = "Ignora aliados", Default = true,
        Callback = function(s) AimbotConfig.TeamCheck = s end })

    --========== HITBOX ==========
    local TabHitbox = Window:Tab({ Title = "Hitbox", Icon = "box", Locked = false })
    local HitboxConfig = { Enabled = false, Size = 50, TeamCheck = true }
    local hitboxData = {}

    local function removeHitbox(plr)
        local box = hitboxData[plr]
        if box and box.Parent then box:Destroy() end
        hitboxData[plr] = nil
        if plr.Character then
            local b = plr.Character:FindFirstChild("SacrificeHitbox")
            if b then b:Destroy() end
        end
    end

    local function applyHitbox(plr)
        if not HitboxConfig.Enabled then return end
        if plr == LocalPlayer then return end
        if HitboxConfig.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            removeHitbox(plr)
            return
        end
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local box = char:FindFirstChild("SacrificeHitbox")
        if not box then
            box = Instance.new("Part")
            box.Name = "SacrificeHitbox"
            box.Transparency = 1
            box.CanCollide = false
            box.CanQuery = true
            box.CanTouch = false
            box.Massless = true
            box.Anchored = false
            box.Parent = char
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = hrp
            weld.Part1 = box
            weld.Parent = box
        end
        local studSize = HitboxConfig.Size / 10
        box.Size = Vector3.new(studSize, studSize, studSize)
        box.CFrame = hrp.CFrame
        hitboxData[plr] = box
    end

    local function refreshAllHitboxes()
        for plr, _ in pairs(hitboxData) do removeHitbox(plr) end
        if HitboxConfig.Enabled then
            for _, plr in ipairs(Players:GetPlayers()) do applyHitbox(plr) end
        end
    end

    Players.PlayerAdded:Connect(function(plr)
        task.wait(1.5)
        if HitboxConfig.Enabled then applyHitbox(plr) end
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if HitboxConfig.Enabled then applyHitbox(plr) end
        end)
    end)
    Players.PlayerRemoving:Connect(removeHitbox)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if HitboxConfig.Enabled then applyHitbox(plr) end
            end)
        end
    end

    RunService.RenderStepped:Connect(function()
        if not HitboxConfig.Enabled then return end
        for plr, box in pairs(hitboxData) do
            if box and box.Parent and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then box.CFrame = hrp.CFrame end
            end
        end
    end)

    TabHitbox:Toggle({ Title = "📦 Ativar Hitbox", Desc = "Expande hitbox dos inimigos", Default = false,
        Callback = function(s) HitboxConfig.Enabled = s; refreshAllHitboxes() end })
    TabHitbox:Slider({ Title = "📦 Tamanho (%)", Desc = "1 a 100", Value = { Min = 1, Max = 100, Default = 50 },
        Callback = function(v) HitboxConfig.Size = v; if HitboxConfig.Enabled then for p,_ in pairs(hitboxData) do applyHitbox(p) end end end })
    TabHitbox:Toggle({ Title = "📦 Team Check", Desc = "Não expande aliados", Default = true,
        Callback = function(s) HitboxConfig.TeamCheck = s; refreshAllHitboxes() end })

    --========== ESP ==========
    local TabESP = Window:Tab({ Title = "Sakura ESP", Icon = "flower", Locked = false })
    local ENEMY_COLOR = Color3.fromRGB(255, 20, 147)
    local ALLY_COLOR = Color3.fromRGB(255, 179, 209)
    local BORDER_COLOR = Color3.fromRGB(255, 77, 148)

    local ESPConfig = { Tracers = false, Names = false, Chams = false,
        Distance = false, TeamCheck = false, MaxRange = 500, Petals = true }
    local espData = {}

    local function getESPColor(plr)
        if ESPConfig.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            return ALLY_COLOR
        end
        return ENEMY_COLOR
    end

    local function getValidESPData(plr)
        if plr == LocalPlayer then return false end
        local char = plr.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        if not char:FindFirstChildOfClass("Humanoid") then return false end
        local dist = (camera.CFrame.Position - hrp.Position).Magnitude
        if dist > ESPConfig.MaxRange then return false end
        return true, hrp, dist
    end

    local function createESP(plr)
        if espData[plr] then return end
        local data = {
            tracer = SafeDrawing("Line"),
            name = SafeDrawing("Text"),
            distance = SafeDrawing("Text"),
            petal = SafeDrawing("Text"),
            highlight = Instance.new("Highlight"),
        }
        if data.tracer then
            data.tracer.Thickness = 2
            data.tracer.Transparency = 0.7
            data.tracer.Visible = false
        end
        if data.name then
            data.name.Size = 14; data.name.Center = true; data.name.Outline = true
            data.name.Font = 2; data.name.Visible = false
        end
        if data.distance then
            data.distance.Size = 13; data.distance.Center = true; data.distance.Outline = true
            data.distance.Font = 2; data.distance.Visible = false
        end
        if data.petal then
            data.petal.Size = 16; data.petal.Center = true; data.petal.Outline = true
            data.petal.Font = 2; data.petal.Text = "🌸"; data.petal.Color = BORDER_COLOR
            data.petal.Visible = false
        end
        data.highlight.FillTransparency = 0.6
        data.highlight.OutlineTransparency = 0
        data.highlight.OutlineColor = BORDER_COLOR
        data.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        data.highlight.Enabled = false
        espData[plr] = data
    end

    local function removeESP(plr)
        local data = espData[plr]
        if not data then return end
        if data.tracer then pcall(function() data.tracer:Remove() end) end
        if data.name then pcall(function() data.name:Remove() end) end
        if data.distance then pcall(function() data.distance:Remove() end) end
        if data.petal then pcall(function() data.petal:Remove() end) end
        if data.highlight then data.highlight:Destroy() end
        espData[plr] = nil
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then createESP(plr) end
    end
    Players.PlayerAdded:Connect(function(plr) if plr ~= LocalPlayer then createESP(plr) end end)
    Players.PlayerRemoving:Connect(removeESP)

    RunService.RenderStepped:Connect(function()
        camera = workspace.CurrentCamera
        local screenSize = camera.ViewportSize
        local origin = Vector2.new(screenSize.X / 2, screenSize.Y)

        for plr, data in pairs(espData) do
            local ok, hrp, dist = getValidESPData(plr)
            if not ok then
                if data.tracer then data.tracer.Visible = false end
                if data.name then data.name.Visible = false end
                if data.distance then data.distance.Visible = false end
                if data.petal then data.petal.Visible = false end
                data.highlight.Enabled = false
            else
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if not onScreen then
                    if data.tracer then data.tracer.Visible = false end
                    if data.name then data.name.Visible = false end
                    if data.distance then data.distance.Visible = false end
                    if data.petal then data.petal.Visible = false end
                    data.highlight.Enabled = false
                else
                    local color = getESPColor(plr)
                    if data.tracer then
                        data.tracer.Visible = ESPConfig.Tracers
                        if ESPConfig.Tracers then
                            data.tracer.From = origin
                            data.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                            data.tracer.Color = color
                        end
                    end
                    if data.name then
                        data.name.Visible = ESPConfig.Names
                        if ESPConfig.Names then
                            data.name.Text = (ESPConfig.Petals and "🌸 " or "") .. plr.Name
                            data.name.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                            data.name.Color = color
                        end
                    end
                    if data.distance then
                        data.distance.Visible = ESPConfig.Distance
                        if ESPConfig.Distance then
                            data.distance.Text = string.format("[%d studs]", math.floor(dist))
                            data.distance.Position = Vector2.new(screenPos.X, screenPos.Y + 25)
                            data.distance.Color = color
                        end
                    end
                    if data.petal then
                        data.petal.Visible = ESPConfig.Petals and (ESPConfig.Names or ESPConfig.Tracers)
                        if data.petal.Visible then
                            data.petal.Position = Vector2.new(screenPos.X, screenPos.Y - 50)
                        end
                    end
                    if ESPConfig.Chams then
                        data.highlight.Enabled = true
                        data.highlight.FillColor = color
                        if data.highlight.Parent ~= plr.Character then
                            data.highlight.Parent = plr.Character
                        end
                    else
                        data.highlight.Enabled = false
                    end
                end
            end
        end
    end)

    TabESP:Toggle({ Title = "🌸 Tracers", Desc = "Linhas", Value = false, Callback = function(v) ESPConfig.Tracers = v end })
    TabESP:Toggle({ Title = "🌸 Names", Desc = "Nomes", Value = false, Callback = function(v) ESPConfig.Names = v end })
    TabESP:Toggle({ Title = "🌸 Petals", Desc = "Florzinha", Value = true, Callback = function(v) ESPConfig.Petals = v end })
    TabESP:Toggle({ Title = "🌸 Chams", Desc = "Contorno", Value = false, Callback = function(v) ESPConfig.Chams = v end })
    TabESP:Toggle({ Title = "🌸 Distance", Desc = "Distância", Value = false, Callback = function(v) ESPConfig.Distance = v end })
    TabESP:Toggle({ Title = "🌸 Team Check", Desc = "Cores por time", Value = false, Callback = function(v) ESPConfig.TeamCheck = v end })
    TabESP:Slider({ Title = "🌸 Max Range", Desc = "Distância máxima", Value = { Min = 0, Max = 1000, Default = 500 },
        Callback = function(v) ESPConfig.MaxRange = v end })

    --========== FLING ==========
    local TabFling = Window:Tab({ Title = "Fling", Icon = "wind", Locked = false })
    local FlingConfig = { FlingPower = 1e9, SelectedPlayer = nil, AntiFlingActive = false }

    local connAntiFling
    local function setAntiFling(state)
        FlingConfig.AntiFlingActive = state
        if connAntiFling then connAntiFling:Disconnect(); connAntiFling = nil end
        if state then
            connAntiFling = RunService.Heartbeat:Connect(function()
                local char = Players.LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                if hrp.AssemblyLinearVelocity.Magnitude > 500 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
                if hrp.AssemblyAngularVelocity.Magnitude > 500 then
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        end
    end

    local function flingPlayer(target)
        if not target or target == Players.LocalPlayer then return end
        local char = Players.LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tChar = target.Character
        if not tChar then return end
        local tHrp = tChar:FindFirstChild("HumanoidRootPart")
        if not tHrp then return end
        pcall(function() hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 1.5) end)
        task.wait(0.05)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            tHrp.AssemblyLinearVelocity = Vector3.zero
        end)
        task.wait()
        for _ = 1, 4 do
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.new(FlingConfig.FlingPower, FlingConfig.FlingPower, FlingConfig.FlingPower)
                tHrp.AssemblyLinearVelocity = Vector3.new(FlingConfig.FlingPower, FlingConfig.FlingPower, FlingConfig.FlingPower)
            end)
            RunService.Heartbeat:Wait()
        end
        pcall(function() hrp.CFrame = hrp.CFrame + Vector3.new(0, 500, 0) end)
    end

    local playerListCache = {}
    local playerDropdown

    local function refreshPlayerList()
        local names = {}
        playerListCache = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                local entry = plr.Name .. "  |  " .. plr.DisplayName
                table.insert(names, entry)
                playerListCache[entry] = plr
            end
        end
        if playerDropdown then
            pcall(function() playerDropdown:Refresh(names) end)
        end
    end

    playerDropdown = TabFling:Dropdown({
        Title = "🎯 Jogadores", Desc = "Selecione um alvo",
        Values = (function()
            local t = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Players.LocalPlayer then
                    local e = plr.Name .. "  |  " .. plr.DisplayName
                    table.insert(t, e)
                    playerListCache[e] = plr
                end
            end
            return t
        end)(),
        Value = nil, Multi = false,
        Callback = function(opt) FlingConfig.SelectedPlayer = playerListCache[opt] end,
    })

    TabFling:Button({ Title = "🌀 FLINGAR Jogador", Desc = "Arremessa o alvo",
        Callback = function()
            if not FlingConfig.SelectedPlayer or not FlingConfig.SelectedPlayer.Character then
                WindUI:Notify({ Title = "🌀", Content = "Selecione um alvo!", Duration = 2, Icon = "alert-triangle" })
                return
            end
            task.spawn(function() flingPlayer(FlingConfig.SelectedPlayer) end)
        end })

    TabFling:Button({ Title = "💥 FLINGAR TODOS", Desc = "Arremessa todo mundo",
        Callback = function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Players.LocalPlayer and plr.Character then
                    task.spawn(flingPlayer, plr)
                    task.wait(0.15)
                end
            end
        end })

    TabFling:Button({ Title = "🔄 Atualizar Lista", Desc = "Recarrega jogadores",
        Callback = function() refreshPlayerList() end })

    TabFling:Toggle({ Title = "🛡️ Anti-Fling", Desc = "Proteção", Default = false,
        Callback = function(s) setAntiFling(s) end })

    TabFling:Slider({ Title = "🌀 Força", Desc = "1 a 20", Value = { Min = 1, Max = 20, Default = 10 },
        Callback = function(v) FlingConfig.FlingPower = 10 ^ v end })

    Players.PlayerAdded:Connect(function() task.wait(1); refreshPlayerList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshPlayerList() end)

    --=========================================================
    -- 💀 SKIN CHANGER (CORRIGIDO PARA DELTA)
    --=========================================================
    local TabSkin = Window:Tab({ Title = "Skin Changer", Icon = "shirt", Locked = false })

    local SkinConfig = { Headless = false, Korblox = false, LastId = "" }

    local function getSkinChar()
        local lp = Players.LocalPlayer
        return lp.Character or lp.CharacterAdded:Wait()
    end

    local function addAccessoryById(id)
        local char = getSkinChar()
        if not char then return false, "Sem personagem" end
        local head = char:FindFirstChild("Head")
        if not head then return false, "Sem cabeça" end

        local ok, objects = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(id))
        end)

        if not ok or not objects or #objects == 0 then
            local ok2, model = pcall(function()
                return game:GetService("InsertService"):LoadAsset(tonumber(id))
            end)
            if ok2 and model then
                objects = { model }
            else
                return false, "ID inválido ou asset privado"
            end
        end

        local added = false
        for _, root in ipairs(objects) do
            local items = root:IsA("Accessory") and { root } or root:GetDescendants()
            for _, obj in ipairs(items) do
                if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") then
                    if obj:IsA("Accessory") or obj:IsA("Hat") then
                        local clone = obj:Clone()
                        clone.Name = "SacrificeAcc_" .. tostring(id)
                        clone.Parent = char
                        local handle = clone:FindFirstChild("Handle")
                        if handle then
                            for _, w in ipairs(handle:GetChildren()) do
                                if w:IsA("Weld") or w:IsA("Motor6D") or w:IsA("WeldConstraint") then
                                    w:Destroy()
                                end
                            end
                            local weld = Instance.new("Weld")
                            weld.Part0 = head
                            weld.Part1 = handle
                            weld.C0 = CFrame.new(0, 0.6, 0)
                            weld.Parent = handle
                        end
                        added = true
                    else
                        local clone = obj:Clone()
                        clone.Parent = char
                        added = true
                    end
                end
            end
        end
        return added, added and nil or "Nada encontrado no asset"
    end

    local function applyHeadless(state)
        local char = getSkinChar()
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        if state then
            if not head:GetAttribute("SacOrigTrans") then
                head:SetAttribute("SacOrigTrans", head.Transparency)
            end
            head.Transparency = 1
            for _, v in ipairs(head:GetChildren()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    if not v:GetAttribute("SacOrigTrans") then
                        v:SetAttribute("SacOrigTrans", v.Transparency)
                    end
                    v.Transparency = 1
                end
            end
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("Accessory") then
                    local h = v:FindFirstChild("Handle")
                    if h then
                        if not h:GetAttribute("SacOrigTrans") then
                            h:SetAttribute("SacOrigTrans", h.Transparency)
                        end
                        h.Transparency = 1
                    end
                end
            end

            pcall(function()
                local objects = game:GetObjects("rbxassetid://134082579")
                if objects and #objects > 0 then
                    for _, root in ipairs(objects) do
                        for _, obj in ipairs(root:GetDescendants()) do
                            if obj:IsA("Accessory") or obj:IsA("Hat") then
                                local clone = obj:Clone()
                                clone.Name = "SacrificeHeadless"
                                clone.Parent = char
                                local handle = clone:FindFirstChild("Handle")
                                if handle then
                                    handle.Transparency = 1
                                    local weld = Instance.new("Weld")
                                    weld.Part0 = head
                                    weld.Part1 = handle
                                    weld.C0 = CFrame.new(0, 0.5, 0)
                                    weld.Parent = handle
                                end
                            end
                        end
                    end
                end
            end)
        else
            head.Transparency = head:GetAttribute("SacOrigTrans") or 0
            for _, v in ipairs(head:GetChildren()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = v:GetAttribute("SacOrigTrans") or 0
                end
            end
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("Accessory") then
                    local h = v:FindFirstChild("Handle")
                    if h and h:GetAttribute("SacOrigTrans") ~= nil then
                        h.Transparency = h:GetAttribute("SacOrigTrans")
                    end
                end
            end
            local hl = char:FindFirstChild("SacrificeHeadless")
            if hl then hl:Destroy() end
        end
    end

    local function applyKorblox(state)
        local char = getSkinChar()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local isR15 = hum.RigType == Enum.HumanoidRigType.R15
        local names = isR15 and { "RightUpperLeg", "RightLowerLeg", "RightFoot" } or { "Right Leg" }

        for _, name in ipairs(names) do
            local part = char:FindFirstChild(name)
            if part then
                if state then
                    if not part:GetAttribute("SacOrigTrans") then
                        part:SetAttribute("SacOrigTrans", part.Transparency)
                        part:SetAttribute("SacOrigColor", part.Color)
                        part:SetAttribute("SacOrigMat", part.Material)
                    end
                    for _, m in ipairs(part:GetChildren()) do
                        if m:IsA("SpecialMesh") or m:IsA("Mesh") then m:Destroy() end
                    end
                    part.Transparency = 0
                    part.Material = Enum.Material.SmoothPlastic
                    part.Color = Color3.fromRGB(0, 0, 0)

                    local sm = Instance.new("SpecialMesh")
                    sm.MeshId = "rbxassetid://139607718"
                    sm.Scale = Vector3.new(1, 1, 1)
                    sm.Parent = part
                else
                    for _, m in ipairs(part:GetChildren()) do
                        if m:IsA("SpecialMesh") and m.MeshId == "rbxassetid://139607718" then
                            m:Destroy()
                        end
                    end
                    part.Transparency = part:GetAttribute("SacOrigTrans") or 0
                    if part:GetAttribute("SacOrigColor") then
                        part.Color = part:GetAttribute("SacOrigColor")
                    end
                    if part:GetAttribute("SacOrigMat") then
                        part.Material = part:GetAttribute("SacOrigMat")
                    end
                end
            end
        end
    end

    Players.LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if SkinConfig.Headless then applyHeadless(true) end
        if SkinConfig.Korblox then applyKorblox(true) end
    end)

    TabSkin:Section({ Title = "💀 Presets Rápidos", Icon = "skull" })

    TabSkin:Toggle({
        Title = "💀 Headless", Desc = "Sem cabeça", Default = false,
        Callback = function(s)
            SkinConfig.Headless = s
            applyHeadless(s)
            WindUI:Notify({ Title = "💀 Headless", Content = s and "Ativado!" or "Desativado.", Duration = 2 })
        end,
    })

    TabSkin:Toggle({
        Title = "🦴 Korblox (Perna Direita)", Desc = "Transforma a perna direita", Default = false,
        Callback = function(s)
            SkinConfig.Korblox = s
            applyKorblox(s)
            WindUI:Notify({ Title = "🦴 Korblox", Content = s and "Ativado!" or "Desativado.", Duration = 2 })
        end,
    })

    TabSkin:Button({
        Title = "💀🦴 Aplicar TUDO", Desc = "Headless + Korblox",
        Callback = function()
            SkinConfig.Headless = true
            SkinConfig.Korblox = true
            applyHeadless(true)
            applyKorblox(true)
            WindUI:Notify({ Title = "💀🦴", Content = "Aplicado!", Duration = 2 })
        end,
    })

    TabSkin:Button({
        Title = "🔄 Resetar Personagem", Desc = "Volta ao normal",
        Callback = function()
            SkinConfig.Headless = false
            SkinConfig.Korblox = false
            applyHeadless(false)
            applyKorblox(false)
            WindUI:Notify({ Title = "🔄", Content = "Resetado!", Duration = 2 })
        end,
    })

    TabSkin:Section({ Title = "🎩 Acessórios por ID", Icon = "shopping-bag" })

    TabSkin:Input({
        Title = "ID do Acessório", Desc = "Ex: 134082579 (Headless)",
        Placeholder = "Ex: 134082579", Value = "", Type = "number",
        Callback = function(t) SkinConfig.LastId = t end,
    })

    TabSkin:Button({
        Title = "➕ Adicionar Acessório", Desc = "Aplica no personagem",
        Callback = function()
            local id = SkinConfig.LastId
            if not id or tostring(id) == "" then
                WindUI:Notify({ Title = "⚠️", Content = "Coloque um ID!", Duration = 2, Icon = "alert-triangle" })
                return
            end
            local ok, err = addAccessoryById(id)
            if ok then
                WindUI:Notify({ Title = "🎩", Content = "Adicionado: " .. tostring(id), Duration = 2, Icon = "check" })
            else
                WindUI:Notify({ Title = "⚠️", Content = err or "Falha", Duration = 3, Icon = "alert-triangle" })
            end
        end,
    })

    TabSkin:Button({
        Title = "💀 ID do Headless (134082579)", Desc = "Atalho rápido",
        Callback = function()
            SkinConfig.LastId = "134082579"
            local ok = addAccessoryById("134082579")
            applyHeadless(true)
            WindUI:Notify({ Title = "💀", Content = ok and "Aplicado!" or "Fallback aplicado", Duration = 2 })
        end,
    })

    TabSkin:Button({
        Title = "🧹 Remover Todos os Acessórios", Desc = "Limpa o personagem",
        Callback = function()
            local char = getSkinChar()
            if not char then return end
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy() end
            end
            WindUI:Notify({ Title = "🧹", Content = "Removidos!", Duration = 2 })
        end,
    })

    --========== ANIMAÇÕES ==========
    local TabAnim = Window:Tab({ Title = "Animações", Icon = "play", Locked = false })

    local AnimConfig = {
        BundleLoaded = false,
        LastLoad = 0,
    }

    local BUNDLE_URL = "https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/BundleAnimations.lua"

    local function carregarBundleAnimacoes()
        -- Cooldown anti-spam (3 segundos)
        if tick() - AnimConfig.LastLoad < 3 then
            WindUI:Notify({
                Title = "⏳ Aguarde",
                Content = "Espere alguns segundos antes de recarregar.",
                Duration = 2,
                Icon = "clock",
            })
            return
        end
        AnimConfig.LastLoad = tick()

        task.spawn(function()
            local ok, err = pcall(function()
                local src = safeHttpGet(BUNDLE_URL)
                if not src or src == "" then
                    error("Falha no download do bundle")
                end

                local func, loadErr = loadstring(src)
                if not func then
                    error("loadstring falhou: " .. tostring(loadErr))
                end

                func()
            end)

            if ok then
                AnimConfig.BundleLoaded = true
                WindUI:Notify({
                    Title = "🎬 Animações",
                    Content = "Bundle carregado com sucesso!",
                    Duration = 3,
                    Icon = "play",
                })
            else
                WindUI:Notify({
                    Title = "⚠️ Erro",
                    Content = "Não foi possível carregar: " .. tostring(err),
                    Duration = 4,
                    Icon = "alert-triangle",
                })
            end
        end)
    end

    TabAnim:Section({ Title = "🎬 Bundle de Animações", Icon = "play" })

    TabAnim:Paragraph({
        Title = "Sobre",
        Desc = "Carrega o pacote de animações BundleAnimations do repositório Bac0nHck. Use quando quiser trocar suas animações.",
        Color = Color3.fromHex("#ff4d94"),
    })

    TabAnim:Button({
        Title = "🎬 Carregar Bundle de Animações",
        Desc = "Executa o script BundleAnimations.lua",
        Callback = function()
            carregarBundleAnimacoes()
        end,
    })

    TabAnim:Button({
        Title = "🔄 Recarregar Bundle",
        Desc = "Força o recarregamento (respeitando cooldown)",
        Callback = function()
            carregarBundleAnimacoes()
        end,
    })

    TabAnim:Divider()

    TabAnim:Section({ Title = "⚙️ Opções", Icon = "settings" })

    TabAnim:Toggle({
        Title = "🚀 Auto-carregar ao iniciar",
        Desc = "Carrega o bundle automaticamente quando o hub abre",
        Default = false,
        Callback = function(state)
            if state then
                carregarBundleAnimacoes()
            end
        end,
    })

    TabAnim:Button({
        Title = "📋 Copiar URL do Bundle",
        Desc = "Copia o link do raw para a área de transferência",
        Callback = function()
            pcall(function()
                if setclipboard then
                    setclipboard(BUNDLE_URL)
                elseif toclipboard then
                    toclipboard(BUNDLE_URL)
                end
            end)
            WindUI:Notify({
                Title = "📋 Copiado",
                Content = BUNDLE_URL,
                Duration = 3,
                Icon = "clipboard",
            })
        end,
    })

    --========== NOTIFICAÇÃO FINAL ==========
    WindUI:Notify({
        Title = "🌸 Sacrifice Hub",
        Content = "Todas as abas carregadas!",
        Duration = 4,
        Icon = "flower",
    })

    --=============================================================
    -- 💖 MENSAGEM AGRADECIMENTO A CADA 10 MINUTOS
    --=============================================================
    task.spawn(function()
        task.wait(600) -- primeira mensagem depois de 10 min
        while true do
            pcall(function()
                WindUI:Notify({
                    Title   = "🌸 OBRIGADO POR USAR O HUB",
                    Content = "SACRIFICE HUB • Delta Edition — aproveite! 💖",
                    Duration = 6,
                    Icon    = "heart",
                })
            end)
            task.wait(600) -- repete a cada 10 minutos
        end
    end)

    print("[SACRIFICE HUB] WindUI carregado com sucesso no Delta! 🌸")
end

--=============================================================
-- LOOP DE PROGRESSO + TRANSIÇÃO
--=============================================================
task.spawn(function()
    local inicio = tick()
    while valorAtual < 100 do
        local decorrido = tick() - inicio
        local progresso = math.min(decorrido / CONFIG.TempoTotal, 1)
        valorAtual = math.floor(progresso * 100)
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        TweenService:Create(barFill, info, { Size = UDim2.new(progresso, 0, 1, 0) }):Play()
        txtPercent.Text = valorAtual .. "%"
        for i = #stages, 1, -1 do
            if valorAtual >= stages[i].at then
                txtStatus.Text = stages[i].texto
                break
            end
        end
        task.wait(0.1)
    end
    task.wait(1.5)

    local fadeInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    TweenService:Create(fundo, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(card, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(titulo, fadeInfo, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
    TweenService:Create(subtitulo, fadeInfo, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
    TweenService:Create(txtPercent, fadeInfo, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
    TweenService:Create(txtStatus, fadeInfo, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
    TweenService:Create(barBg, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(barFill, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(stroke, fadeInfo, { Transparency = 1 }):Play()

    task.wait(1.2)

    if connectionPetalas then connectionPetalas:Disconnect() end
    for _, p in ipairs(petalas) do
        if p.objeto then pcall(function() p.objeto:Destroy() end) end
    end
    loadingGui:Destroy()

    print("[SACRIFICE HUB] Loading finalizada! 🌸")

    pcall(criarTagKing)
    pcall(carregarWindUI)
end)

print("[SACRIFICE HUB] Script carregado. 🌸")
