-- Seylix AP - Version finale (touche exécution modifiable)
-- Touche par défaut : F (changeable en haut)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TCS = game:GetService("TextChatService")
local RS = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 8)

-- Touche d'exécution (modifiable ici)
local KEY_EXECUTE = Enum.KeyCode.F  -- ← Change F par E, Q, G, R, etc.

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
mf.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mf.BorderSizePixel = 0
mf.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = mf

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 25))
}
gradient.Rotation = 90
gradient.Parent = mf

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1.0
aspect.Parent = mf

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mf

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 18)
titleBarCorner.Parent = titleBar

-- Drapeau Algérie
local flag = Instance.new("ImageLabel")
flag.Size = UDim2.new(0, 40, 0, 30)
flag.Position = UDim2.new(0, 15, 0.5, -15)
flag.BackgroundTransparency = 1
flag.Image = "rbxassetid://9423183864"
flag.ScaleType = Enum.ScaleType.Fit
flag.Parent = titleBar

-- Titre toujours visible
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.5, 0, 0, 0)
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundTransparency = 1
title.Text = "Seylix AP"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(240,240,255)
title.Parent = titleBar

local hue = 0
RS.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 45) % 360
    title.TextColor3 = Color3.fromHSV(hue/360, 0.85, 1)
end)

-- Bouton Minimize stylé néon
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 40, 0, 40)
minBtn.Position = UDim2.new(1, -50, 0.5, -20)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 255)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minBtn

local minStroke = Instance.new("UIStroke")
minStroke.Color = Color3.fromRGB(0, 255, 255)
minStroke.Thickness = 2
minStroke.Transparency = 0.4
minStroke.Parent = minBtn

-- Bouton Exécuter
local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0.92, 0, 0.18, 0)
execBtn.Position = UDim2.new(0.04, 0, 0.78, 0)
execBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
execBtn.Text = "EXÉCUTER (" .. KEY_EXECUTE.Name .. ")"
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBlack
execBtn.TextColor3 = Color3.fromRGB(255,255,255)
execBtn.Parent = mf

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 14)
execCorner.Parent = execBtn

local execGradient = Instance.new("UIGradient")
execGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220,40,40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,100,0))
}
execGradient.Rotation = 45
execGradient.Parent = execBtn

-- Texte animation
local animText = Instance.new("TextLabel")
animText.Size = UDim2.new(1,0,1,0)
animText.BackgroundTransparency = 1
animText.Text = "Commandes Exécutées !"
animText.TextScaled = true
animText.Font = Enum.Font.GothamBlack
animText.TextColor3 = Color3.fromRGB(255,255,255)
animText.TextTransparency = 1
animText.Visible = false
animText.Parent = execBtn

-- ScrollingFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 0.55, 0)
scroll.Position = UDim2.new(0, 8, 0.2, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(110,110,230)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = mf

local scrollList = Instance.new("UIListLayout")
scrollList.Padding = UDim.new(0.008, 0)
scrollList.FillDirection = Enum.FillDirection.Vertical
scrollList.SortOrder = Enum.SortOrder.LayoutOrder
scrollList.Parent = scroll

-- Mise à jour scroll
scrollList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, scrollList.AbsoluteContentSize.Y + 50)
end)

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
    minBtn.Text = minimized and "＋" or "−"
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

-- Touche personnalisable + animation
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == KEY_EXECUTE then
        if selectedPlayerName then 
            spam(selectedPlayerName)
            -- Animation arc-en-ciel
            animText.Visible = true
            animText.TextTransparency = 0
            animText.TextStrokeTransparency = 0.5
            animText.TextStrokeColor3 = Color3.fromRGB(255,255,255)
            
            local start = tick()
            local conn
            conn = RS.Heartbeat:Connect(function()
                local t = tick() - start
                if t > 1.2 then
                    animText.Visible = false
                    conn:Disconnect()
                    return
                end
                local h = (t * 360) % 360
                animText.TextColor3 = Color3.fromHSV(h/360, 1, 1)
            end)
        end
    end
end)

-- Bouton Exécuter + animation
execBtn.MouseButton1Click:Connect(function()
    if selectedPlayerName then 
        spam(selectedPlayerName)
        -- Même animation
        animText.Visible = true
        animText.TextTransparency = 0
        animText.TextStrokeTransparency = 0.5
        animText.TextStrokeColor3 = Color3.fromRGB(255,255,255)
        
        local start = tick()
        local conn
        conn = RS.Heartbeat:Connect(function()
            local t = tick() - start
            if t > 1.2 then
                animText.Visible = false
                conn:Disconnect()
                return
            end
            local h = (t * 360) % 360
            animText.TextColor3 = Color3.fromHSV(h/360, 1, 1)
        end)
    end
end)

-- Boutons joueurs
local function createBtn(p)
    if p == lp then return end
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,32)
    b.BackgroundColor3 = Color3.fromRGB(35,35,50)
    b.TextColor3 = Color3.fromRGB(230,230,255)
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    b.Text = p.Name
    b.Parent = scroll
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,10)
    bc.Parent = b
    
    b.MouseEnter:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(50,50,75)
    end)
    b.MouseLeave:Connect(function()
        if selectedPlayerName ~= p.Name then
            b.BackgroundColor3 = Color3.fromRGB(35,35,50)
        end
    end)
    
    b.MouseButton1Click:Connect(function()
        selectedPlayerName = p.Name
        if selectedBtn then selectedBtn.BackgroundColor3 = Color3.fromRGB(35,35,50) end
        b.BackgroundColor3 = Color3.fromRGB(80,90,200)
        selectedBtn = b
    end)
end

-- Refresh
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
                b.BackgroundColor3 = Color3.fromRGB(80,90,200)
                selectedBtn = b
                break
            end
        end
    else
        selectedPlayerName = nil
        selectedBtn = nil
    end
    
    RS.RenderStepped:Wait()
    RS.RenderStepped:Wait()
    scroll.CanvasSize = UDim2.new(0, 0, 0, scrollList.AbsoluteContentSize.Y + 60)
end

refresh()
task.delay(1, refresh)

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

lp.CharacterAdded:Connect(function(nc)
    char = nc
    hrp = nc:WaitForChild("HumanoidRootPart", 5)
end)

print("Seylix AP - Touche exécution modifiable (" .. KEY_EXECUTE.Name .. ")")