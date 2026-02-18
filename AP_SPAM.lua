local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TCS = game:GetService("TextChatService")
local RS = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 8)

local selectedPlayerName = nil
local selectedBtn = nil

-- GUI stylée
local sg = Instance.new("ScreenGui")
sg.Name = "SeylixAP"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = lp:WaitForChild("PlayerGui")

local mf = Instance.new("Frame")
mf.Size = UDim2.new(0.38, 0, 0.42, 0)  -- un peu plus haut pour esthétique
mf.Position = UDim2.new(0.5, 0, 0.5, 0)
mf.AnchorPoint = Vector2.new(0.5, 0.5)
mf.BackgroundColor3 = Color3.fromRGB(15, 15, 20)  -- noir mat profond
mf.BorderSizePixel = 0
mf.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)  -- coins plus arrondis
corner.Parent = mf

-- Ombre légère
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"  -- ombre Roblox classique
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.Parent = mf
shadow.ZIndex = -1

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1.0  -- plus carré, plus moderne
aspect.Parent = mf

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,36)  -- barre plus haute
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mf

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 16)
titleBarCorner.Parent = titleBar

-- Drapeau algérien (à gauche)
local flag = Instance.new("ImageLabel")
flag.Size = UDim2.new(0, 32, 0, 24)
flag.Position = UDim2.new(0, 12, 0.5, -12)
flag.BackgroundTransparency = 1
flag.Image = "rbxassetid://6239941415"  -- ID public drapeau Algérie (vert-blanc-rouge + croissant)
flag.ScaleType = Enum.ScaleType.Fit
flag.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 55, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Seylix AP"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Animation arc-en-ciel plus douce
local hue = 0
RS.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 45) % 360  -- plus lent et élégant
    title.TextColor3 = Color3.fromHSV(hue/360, 0.9, 1)
end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -40, 0.5, -16)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(200,200,255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)  -- cercle parfait
minCorner.Parent = minBtn

-- Bouton Exécuter stylé
local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0.92, 0, 0.16, 0)
execBtn.Position = UDim2.new(0.04, 0, 0.82, 0)  -- en bas fixe
execBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
execBtn.Text = "EXÉCUTER (F)"
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBlack
execBtn.TextColor3 = Color3.fromRGB(255,255,255)
execBtn.Parent = mf

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 12)
execCorner.Parent = execBtn

-- Gradient rouge → orange sur execBtn
local execGradient = Instance.new("UIGradient")
execGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220,40,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,140,0))
}
execGradient.Rotation = 45
execGradient.Parent = execBtn

-- ScrollingFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 0.58, -50)  -- ajusté pour esthétique
scroll.Position = UDim2.new(0, 10, 0.18, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,200)
scroll.Parent = mf

local scrollList = Instance.new("UIListLayout")
scrollList.Padding = UDim.new(0.008, 0)
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

-- Minimize : taille fixe, seule liste disparaît
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        scroll.Visible = false
        minBtn.Text = "+"
    else
        scroll.Visible = true
        minBtn.Text = "-"
    end
end)

-- Spam
local function spam(targetName)
    if not targetName or targetName == "" then return end
    
    local ch = TCS.TextChannels:FindFirstChild("RBXGeneral")
    if not ch then warn("Canal introuvable") return end

    ch:SendAsync(";balloon " .. targetName)
    ch:SendAsync(";rocket " .. targetName)
    
    task.wait(0.09)
    ch:SendAsync(";inverse " .. targetName)
    
    task.wait(0.09)
    ch:SendAsync(";tiny " .. targetName)
end

-- Touche F
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

-- Boutons joueurs (plus stylés)
local function createBtn(p)
    if p == lp then return end
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,34)  -- boutons plus hauts
    b.BackgroundColor3 = Color3.fromRGB(30,30,45)
    b.TextColor3 = Color3.fromRGB(220,220,255)
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    b.Text = p.Name
    b.Parent = scroll
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,10)
    bc.Parent = b
    
    b.MouseButton1Click:Connect(function()
        selectedPlayerName = p.Name
        if selectedBtn then 
            selectedBtn.BackgroundColor3 = Color3.fromRGB(30,30,45) 
        end
        b.BackgroundColor3 = Color3.fromRGB(60,80,180)  -- bleu-violet sélection
        selectedBtn = b
    end)
end

-- Refresh
local function refresh()
    local prev = selectedPlayerName
    
    for _,c in scroll:GetChildren() do 
        if c:IsA("TextButton") then c:Destroy() end 
    end
    
    for _,p in Players:GetPlayers() do 
        createBtn(p) 
    end
    
    if prev then
        local exists = Players:FindFirstChild(prev) ~= nil
        if exists then
            selectedPlayerName = prev
            for _, b in scroll:GetChildren() do
                if b:IsA("TextButton") and b.Text == prev then
                    if selectedBtn then
                        selectedBtn.BackgroundColor3 = Color3.fromRGB(30,30,45)
                    end
                    b.BackgroundColor3 = Color3.fromRGB(60,80,180)
                    selectedBtn = b
                    break
                end
            end
        else
            selectedPlayerName = nil
            selectedBtn = nil
        end
    end
    
    task.delay(0.05, function()
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

print("Seylix AP - Version esthétique + drapeau Algérie")
