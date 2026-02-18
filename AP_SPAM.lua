local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TCS = game:GetService("TextChatService")
local RS = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 8)

local selectedPlayerName = nil

-- GUI compact
local sg = Instance.new("ScreenGui")
sg.Name = "SeylixAP"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = lp:WaitForChild("PlayerGui")

local mf = Instance.new("Frame")
mf.Size = UDim2.new(0.38, 0, 0.38, 0)
mf.Position = UDim2.new(0.5, 0, 0.5, 0)
mf.AnchorPoint = Vector2.new(0.5, 0.5)
mf.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mf.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mf

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1.05
aspect.Parent = mf

local mainList = Instance.new("UIListLayout")
mainList.Padding = UDim.new(0.01, 0)
mainList.Parent = mf

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,28)
titleBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
titleBar.Parent = mf

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.82,0,1,0)
title.Position = UDim2.new(0.03,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Seylix AP"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = titleBar

local hue = 0
RS.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 90) % 360
    title.TextColor3 = Color3.fromHSV(hue/360, 0.95, 1)
end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.16,0,0.8,0)
minBtn.Position = UDim2.new(1,-6,0.1,0)
minBtn.AnchorPoint = Vector2.new(1,0)
minBtn.Text = "-"
minBtn.TextScaled = true
minBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
minBtn.Parent = titleBar

-- Bouton Exécuter (taille fixe, reste grand même minimisé)
local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0.92,0,0.18,0)           -- taille fixe
execBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
execBtn.Text = "Exécuter sur sélectionné (F)"
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBlack
execBtn.Parent = mf

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-12,0.55,0)
scroll.Position = UDim2.new(0,6,0.2,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.Parent = mf

local scrollList = Instance.new("UIListLayout")
scrollList.Padding = UDim.new(0.006,0)
scrollList.Parent = scroll

-- Drag
local dragging, ds, sp = false, nil, nil
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        ds = i.Position
        sp = mf.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - ds
        mf.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Minimize : liste disparaît, bouton Exécuter reste grand
local minimized = false
local norm = mf.Size
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        scroll.Visible = false
        mf.Size = UDim2.new(0.38, 0, 0.18, 0)   -- petit, mais bouton Exécuter garde sa taille complète
        minBtn.Text = "+"
    else
        scroll.Visible = true
        mf.Size = norm
        minBtn.Text = "-"
    end
end)

-- Spam avec délais personnalisés
local function spam(targetName)
    if not targetName or targetName == "" then return end
    
    local ch = TCS.TextChannels:FindFirstChild("RBXGeneral")
    if not ch then warn("Canal introuvable") return end

    -- Balloon immédiat (0ms)
    ch:SendAsync(";balloon " .. targetName)
    
    -- Rocket après 0.01s
    ch:SendAsync(";rocket " .. targetName)
    
    -- Le reste (tiny, inverse) avec 0.12s entre eux
    task.wait(0.12)
    ch:SendAsync(";tiny " .. targetName)
    
    task.wait(0.15)
    ch:SendAsync(";inverse " .. targetName)
    
    -- Jail après 0.2s (assumant que c'est 0.2s, pas ms)
    task.wait(3.3)
    ch:SendAsync(";jail " .. targetName)
end

-- Touche F = exécuter sélectionné
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.F then
        if selectedPlayerName then spam(selectedPlayerName) end
    end
end)

-- Bouton Exécuter
execBtn.MouseButton1Click:Connect(function()
    if selectedPlayerName then spam(selectedPlayerName) end
end)

-- Boutons sélection
local selectedBtn = nil
local function createBtn(p)
    if p == lp then return end
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,26)
    b.BackgroundColor3 = Color3.fromRGB(28,28,28)
    b.TextColor3 = Color3.fromRGB(230,230,230)
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    b.Text = p.Name
    b.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,8)
    c.Parent = b
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0.04,0)
    pad.PaddingBottom = UDim.new(0.04,0)
    pad.Parent = b
    
    b.MouseButton1Click:Connect(function()
        selectedPlayerName = p.Name
        if selectedBtn then selectedBtn.BackgroundColor3 = Color3.fromRGB(28,28,28) end
        b.BackgroundColor3 = Color3.fromRGB(50,50,100)
        selectedBtn = b
    end)
end

-- Refresh
local function refresh()
    for _,c in scroll:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end
    
    local pls = Players:GetPlayers()
    for _,p in pls do createBtn(p) end
    
    task.delay(0.3, function()
        scroll.CanvasSize = UDim2.new(0,0,0, scrollList.AbsoluteContentSize.Y + 20)
    end)
end

refresh()
task.delay(1, refresh)

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
lp.CharacterAdded:Connect(function(nc)
    char = nc
    hrp = nc:WaitForChild("HumanoidRootPart", 5)
end)

print("Seylix AP - Bouton Exécuter grand même minimisé")
