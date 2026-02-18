--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TCS = game:GetService("TextChatService")
local RS = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 8)

local selectedPlayerName = nil

--// GUI
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

Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 12)

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1.05
aspect.Parent = mf

local mainList = Instance.new("UIListLayout")
mainList.Padding = UDim.new(0.01, 0)
mainList.Parent = mf

--// Title bar
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

-- Rainbow title
local hue = 0
RS.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 90) % 360
    title.TextColor3 = Color3.fromHSV(hue/360, 0.95, 1)
end)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.16,0,0.8,0)
minBtn.Position = UDim2.new(1,-6,0.1,0)
minBtn.AnchorPoint = Vector2.new(1,0)
minBtn.Text = "-"
minBtn.TextScaled = true
minBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
minBtn.Parent = titleBar

-- Execute button
local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0.92,0,0.18,0)
execBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
execBtn.Text = "Exécuter sur sélectionné (F)"
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBlack
execBtn.Parent = mf

-- Player list
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
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        ds = i.Position
        sp = mf.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - ds
        mf.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Minimize
local minimized = false
local norm = mf.Size
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    scroll.Visible = not minimized
    mf.Size = minimized and UDim2.new(0.38,0,0.18,0) or norm
    minBtn.Text = minimized and "+" or "-"
end)

--// SPAM AVEC TIMING EXACT
local function spam(target)
    if not target then return end

    local ch = TCS.TextChannels:FindFirstChild("RBXGeneral")
    if not ch then return end

    -- Instant
    ch:SendAsync(";balloon " .. target)
    ch:SendAsync(";rocket " .. target)

    -- tiny après 0.15
    task.wait(0.15)
    ch:SendAsync(";tiny " .. target)

    -- inverse après 0.15
    task.wait(0.15)
    ch:SendAsync(";inverse " .. target)

    -- jail après 1.6
    task.wait(1.6)
    ch:SendAsync(";jail " .. target)
end

-- Touche F
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.F then
        spam(selectedPlayerName)
    end
end)

-- Bouton Exécuter
execBtn.MouseButton1Click:Connect(function()
    spam(selectedPlayerName)
end)

-- Player buttons
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

    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

    b.MouseButton1Click:Connect(function()
        selectedPlayerName = p.Name
        if selectedBtn then selectedBtn.BackgroundColor3 = Color3.fromRGB(28,28,28) end
        b.BackgroundColor3 = Color3.fromRGB(50,50,100)
        selectedBtn = b
    end)
end

-- Refresh list
local function refresh()
    for _,c in ipairs(scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    for _,p in ipairs(Players:GetPlayers()) do
        createBtn(p)
    end

    task.wait()
    scroll.CanvasSize = UDim2.new(0,0,0, scrollList.AbsoluteContentSize.Y + 20)
end

refresh()
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

print("Seylix AP - Version finale avec timing personnalisé")
