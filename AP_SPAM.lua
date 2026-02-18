local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TCS = game:GetService("TextChatService")
local RS = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 8)

local selectedPlayerName = nil
local selectedBtn = nil

-- GUI esthétique
local sg = Instance.new("ScreenGui")
sg.Name = "SeylixAP"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = lp:WaitForChild("PlayerGui")

local mf = Instance.new("Frame")
mf.Size = UDim2.new(0.38, 0, 0.38, 0)
mf.Position = UDim2.new(0.5, 0, 0.5, 0)
mf.AnchorPoint = Vector2.new(0.5, 0.5)
mf.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
mf.BorderSizePixel = 0
mf.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mf

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 18))
}
gradient.Rotation = 90
gradient.Parent = mf

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.Parent = mf
shadow.ZIndex = -1

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1.0
aspect.Parent = mf

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mf

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 16)
titleBarCorner.Parent = titleBar

local flag = Instance.new("ImageLabel")
flag.Size = UDim2.new(0, 40, 0, 30)
flag.Position = UDim2.new(0, 15, 0.5, -15)
flag.BackgroundTransparency = 1
flag.Image = "rbxassetid://9423183864"
flag.ScaleType = Enum.ScaleType.Fit
flag.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 65, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Seylix AP"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local hue = 0
RS.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 40) % 360
    title.TextColor3 = Color3.fromHSV(hue/360, 0.85, 1)
end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 36, 0, 36)
minBtn.Position = UDim2.new(1, -45, 0.5, -18)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(180,180,255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minBtn

local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0.92, 0, 0.18, 0)
execBtn.Position = UDim2.new(0.04, 0, 0.78, 0)
execBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
execBtn.Text = "EXÉCUTER (F)"
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBlack
execBtn.TextColor3 = Color3.fromRGB(255,255,255)
execBtn.Parent = mf

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 12)
execCorner.Parent = execBtn

local execGradient = Instance.new("UIGradient")
execGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220,40,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,100,0))
}
execGradient.Rotation = 45
execGradient.Parent = execBtn

-- ScrollingFrame sans AutomaticCanvasSize (buggé)
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 0.58, -60)
scroll.Position = UDim2.new(0, 10, 0.18, 10)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(100,100,220)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)  -- on met à jour manuellement
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = mf

local scrollList = Instance.new("UIListLayout")
scrollList.Padding = UDim.new(0.01, 0)
scrollList.FillDirection = Enum.FillDirection.Vertical
scrollList.SortOrder = Enum.SortOrder.LayoutOrder
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

-- Minimize
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    scroll.Visible = not minimized
    minBtn.Text = minimized and "+" or "-"
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

execBtn.MouseButton1Click:Connect(function()
    if selectedPlayerName then spam(selectedPlayerName) end
end)

-- Boutons
local function createBtn(p)
    if p == lp then return end
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,32)
    b.BackgroundColor3 = Color3.fromRGB(35,35,50)
    b.TextColor3 = Color3.fromRGB(220,220,255)
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    b.Text = p.Name
    b.Parent = scroll
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,10)
    bc.Parent = b
    
    b.MouseEnter:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(50,50,70)
    end)
    b.MouseLeave:Connect(function()
        if selectedPlayerName ~= p.Name then
            b.BackgroundColor3 = Color3.fromRGB(35,35,50)
        end
    end)
    
    b.MouseButton1Click:Connect(function()
        selectedPlayerName = p.Name
        if selectedBtn then 
            selectedBtn.BackgroundColor3 = Color3.fromRGB(35,35,50) 
        end
        b.BackgroundColor3 = Color3.fromRGB(70,90,200)
        selectedBtn = b
    end)
end

-- Refresh corrigé
local function refresh()
    local prevName = selectedPlayerName
    
    for _,c in scroll:GetChildren() do 
        if c:IsA("TextButton") then c:Destroy() end 
    end
    
    for _,p in Players:GetPlayers() do 
        createBtn(p) 
    end
    
    if prevName and Players:FindFirstChild(prevName) then
        selectedPlayerName = prevName
        for _, b in scroll:GetChildren() do
            if b:IsA("TextButton") and b.Text == prevName then
                if selectedBtn then selectedBtn.BackgroundColor3 = Color3.fromRGB(35,35,50) end
                b.BackgroundColor3 = Color3.fromRGB(70,90,200)
                selectedBtn = b
                break
            end
        end
    else
        selectedPlayerName = nil
        selectedBtn = nil
    end
    
    -- Mise à jour CanvasSize manuelle avec délai (fixe le bug "un seul joueur")
    task.wait(0.1)  -- 0.1s suffisant pour AbsoluteContentSize à jour
    scroll.CanvasSize = UDim2.new(0, 0, 0, scrollList.AbsoluteContentSize.Y + 40)  -- +40 marge
end

refresh()
task.delay(1, refresh)

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

lp.CharacterAdded:Connect(function(nc)
    char = nc
    hrp = nc:WaitForChild("HumanoidRootPart", 5)
end)

print("Seylix AP - Liste complète + scroll jusqu'en bas corrigé")