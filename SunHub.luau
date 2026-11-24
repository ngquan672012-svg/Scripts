-- lang: Luau, file: SunHub.luau, target: Roblox (Blox Fruits), executor: Synapse/Delta/KRNL
-- ☀️ Sun Hub v1.0 | NightCracked • NoKey

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- THEME: Đỏ cam lửa
local T = {
    Bg         = Color3.fromRGB(12, 8, 18),
    Surface    = Color3.fromRGB(22, 14, 30),
    TopBar     = Color3.fromRGB(180, 35, 15),
    TopBar2    = Color3.fromRGB(255, 100, 0),
    Primary    = Color3.fromRGB(255, 100, 0),
    Accent     = Color3.fromRGB(255, 180, 30),
    Text       = Color3.fromRGB(255, 255, 255),
    Sub        = Color3.fromRGB(180, 160, 150),
    TgOn       = Color3.fromRGB(255, 100, 0),
    TgOff      = Color3.fromRGB(55, 55, 55),
    Divider    = Color3.fromRGB(80, 30, 10),
}

local State = {
    AutoFarm     = false,
    AutoQuest    = false,
    KillAura     = false,
    AutoMastery  = false,
    Fly          = false,
    GodMode      = false,
    SpeedHack    = false,
    FruitNotif   = false,
    ESPPlayers   = false,
    FlySpeed     = 60,
}

-- ScreenGui
local SG = Instance.new("ScreenGui")
SG.Name = "SunHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then syn.protect_gui(SG) end
pcall(function() SG.Parent = game.CoreGui end)
if not SG.Parent then SG.Parent = Player.PlayerGui end

-- Main Frame
local MF = Instance.new("Frame")
MF.Name = "Main"
MF.Size = UDim2.new(0, 600, 0, 420)
MF.Position = UDim2.new(0.5,-300,0.5,-210)
MF.BackgroundColor3 = T.Bg
MF.BorderSizePixel = 0
MF.Parent = SG
Instance.new("UICorner", MF).CornerRadius = UDim.new(0,10)

local BG = Instance.new("UIGradient", MF)
BG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12,5,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28,8,8)),
})
BG.Rotation = 135

-- TopBar
local TB = Instance.new("Frame", MF)
TB.Size = UDim2.new(1,0,0,52)
TB.BackgroundColor3 = T.TopBar
TB.BorderSizePixel = 0
Instance.new("UICorner", TB).CornerRadius = UDim.new(0,10)
local TBFix = Instance.new("Frame", TB)
TBFix.Size = UDim2.new(1,0,0.5,0)
TBFix.Position = UDim2.new(0,0,0.5,0)
TBFix.BackgroundColor3 = T.TopBar
TBFix.BorderSizePixel = 0
local TBG = Instance.new("UIGradient", TB)
TBG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.TopBar),
    ColorSequenceKeypoint.new(1, T.TopBar2),
})
TBG.Rotation = 90

local Title = Instance.new("TextLabel", TB)
Title.Size = UDim2.new(0,250,1,0)
Title.Position = UDim2.new(0,14,0,0)
Title.BackgroundTransparency = 1
Title.Text = "☀️  Sun Hub"
Title.TextColor3 = T.Text
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local Sub = Instance.new("TextLabel", TB)
Sub.Size = UDim2.new(0,250,0,14)
Sub.Position = UDim2.new(0,38,1,-17)
Sub.BackgroundTransparency = 1
Sub.Text = "NightCracked • NoKey • v1.0"
Sub.TextColor3 = Color3.fromRGB(255,200,150)
Sub.TextSize = 11
Sub.Font = Enum.Font.Gotham
Sub.TextXAlignment = Enum.TextXAlignment.Left

local function MakeBtn(parent, txt, color, pos)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,30,0,28)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = T.Text
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

local CloseBtn = MakeBtn(TB,"✕",Color3.fromRGB(200,40,20),UDim2.new(1,-40,0.5,-14))
local MinBtn   = MakeBtn(TB,"—",Color3.fromRGB(70,70,70),UDim2.new(1,-78,0.5,-14))

CloseBtn.MouseButton1Click:Connect(function() MF.Visible = not MF.Visible end)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(MF:GetChildren()) do
        if v ~= TB then v.Visible = not minimized end
    end
    TweenService:Create(MF,TweenInfo.new(0.2),{
        Size = minimized and UDim2.new(0,600,0,52) or UDim2.new(0,600,0,420)
    }):Play()
end)

-- Drag
local drag, dragIn, dragS, startP
TB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = true; dragS = i.Position; startP = MF.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
    end
end)
TB.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then dragIn = i end
end)
UserInputService.InputChanged:Connect(function(i)
    if i == dragIn and drag then
        local d = i.Position - dragS
        MF.Position = UDim2.new(startP.X.Scale,startP.X.Offset+d.X,startP.Y.Scale,startP.Y.Offset+d.Y)
    end
end)

-- Sidebar
local SB = Instance.new("Frame", MF)
SB.Name = "Sidebar"
SB.Size = UDim2.new(0,130,1,-52)
SB.Position = UDim2.new(0,0,0,52)
SB.BackgroundColor3 = Color3.fromRGB(15,8,22)
SB.BorderSizePixel = 0
local SBList = Instance.new("UIListLayout", SB)
SBList.Padding = UDim.new(0,2)
SBList.SortOrder = Enum.SortOrder.LayoutOrder
local SBPad = Instance.new("UIPadding", SB)
SBPad.PaddingTop = UDim.new(0,8)
SBPad.PaddingLeft = UDim.new(0,6)
SBPad.PaddingRight = UDim.new(0,6)

local SDivider = Instance.new("Frame", MF)
SDivider.Size = UDim2.new(0,1,1,-52)
SDivider.Position = UDim2.new(0,130,0,52)
SDivider.BackgroundColor3 = T.Divider
SDivider.BorderSizePixel = 0

-- Content
local CA = Instance.new("Frame", MF)
CA.Size = UDim2.new(1,-131,1,-52)
CA.Position = UDim2.new(0,131,0,52)
CA.BackgroundTransparency = 1

local Pages, Tabs = {}, {}

local function MakePage(name, icon, order)
    local TBtn = Instance.new("TextButton", SB)
    TBtn.Name = name
    TBtn.Size = UDim2.new(1,0,0,36)
    TBtn.BackgroundColor3 = T.Surface
    TBtn.BackgroundTransparency = 1
    TBtn.Text = icon.."  "..name
    TBtn.TextColor3 = T.Sub
    TBtn.TextSize = 13
    TBtn.Font = Enum.Font.Gotham
    TBtn.TextXAlignment = Enum.TextXAlignment.Left
    TBtn.BorderSizePixel = 0
    TBtn.LayoutOrder = order
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0,6)
    local TP = Instance.new("UIPadding", TBtn)
    TP.PaddingLeft = UDim.new(0,10)
    local Ind = Instance.new("Frame", TBtn)
    Ind.Size = UDim2.new(0,3,0.6,0)
    Ind.Position = UDim2.new(0,-10,0.2,0)
    Ind.BackgroundColor3 = T.Primary
    Ind.BorderSizePixel = 0
    Ind.Visible = false
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(0,2)

    local Page = Instance.new("ScrollingFrame", CA)
    Page.Name = name.."P"
    Page.Size = UDim2.new(1,0,1,0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = T.Primary
    Page.Visible = false
    local PL = Instance.new("UIListLayout", Page)
    PL.Padding = UDim.new(0,6)
    PL.SortOrder = Enum.SortOrder.LayoutOrder
    local PP = Instance.new("UIPadding", Page)
    PP.PaddingTop = UDim.new(0,10)
    PP.PaddingLeft = UDim.new(0,10)
    PP.PaddingRight = UDim.new(0,12)
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0,0,0,PL.AbsoluteContentSize.Y+20)
    end)

    Pages[name] = Page
    Tabs[name] = {btn=TBtn,ind=Ind}

    TBtn.MouseButton1Click:Connect(function()
        for n,p in pairs(Pages) do
            p.Visible = false
            Tabs[n].btn.BackgroundTransparency = 1
            Tabs[n].btn.TextColor3 = T.Sub
            Tabs[n].ind.Visible = false
        end
        Page.Visible = true
        TBtn.BackgroundTransparency = 0.75
        TBtn.TextColor3 = T.Primary
        Ind.Visible = true
    end)
    return Page
end

local function Section(parent, text)
    local L = Instance.new("TextLabel", parent)
    L.Size = UDim2.new(1,0,0,22)
    L.BackgroundTransparency = 1
    L.Text = "  "..text
    L.TextColor3 = T.Primary
    L.TextSize = 12
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    local D = Instance.new("Frame", parent)
    D.Size = UDim2.new(1,0,0,1)
    D.BackgroundColor3 = T.Divider
    D.BorderSizePixel = 0
end

local function Toggle(parent, label, desc, default, cb)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1,0,0,52)
    F.BackgroundColor3 = T.Surface
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0,8)
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1,-60,0,20)
    L.Position = UDim2.new(0,12,0,8)
    L.BackgroundTransparency = 1
    L.Text = label
    L.TextColor3 = T.Text
    L.TextSize = 13
    L.Font = Enum.Font.GothamSemibold
    L.TextXAlignment = Enum.TextXAlignment.Left
    local D = Instance.new("TextLabel", F)
    D.Size = UDim2.new(1,-60,0,15)
    D.Position = UDim2.new(0,12,0,28)
    D.BackgroundTransparency = 1
    D.Text = desc
    D.TextColor3 = T.Sub
    D.TextSize = 11
    D.Font = Enum.Font.Gotham
    D.TextXAlignment = Enum.TextXAlignment.Left
    local TBg = Instance.new("Frame", F)
    TBg.Size = UDim2.new(0,42,0,24)
    TBg.Position = UDim2.new(1,-54,0.5,-12)
    TBg.BackgroundColor3 = default and T.TgOn or T.TgOff
    TBg.BorderSizePixel = 0
    Instance.new("UICorner", TBg).CornerRadius = UDim.new(1,0)
    local K = Instance.new("Frame", TBg)
    K.Size = UDim2.new(0,18,0,18)
    K.Position = default and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    K.BackgroundColor3 = T.Text
    K.BorderSizePixel = 0
    Instance.new("UICorner", K).CornerRadius = UDim.new(1,0)
    local on = default or false
    local function set(v)
        on = v
        TweenService:Create(TBg,TweenInfo.new(0.18),{BackgroundColor3=v and T.TgOn or T.TgOff}):Play()
        TweenService:Create(K,TweenInfo.new(0.18),{Position=v and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
        cb(v)
    end
    F.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then set(not on) end
    end)
    return {Set=set,Get=function() return on end}
end

local function Button(parent, label, desc, cb)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1,0,0,46)
    F.BackgroundColor3 = T.Surface
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0,8)
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(1,0,1,0)
    B.BackgroundTransparency = 1
    B.Text = ""
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1,-20,0,20)
    L.Position = UDim2.new(0,12,0,6)
    L.BackgroundTransparency = 1
    L.Text = label
    L.TextColor3 = T.Accent
    L.TextSize = 13
    L.Font = Enum.Font.GothamSemibold
    L.TextXAlignment = Enum.TextXAlignment.Left
    local D2 = Instance.new("TextLabel", F)
    D2.Size = UDim2.new(1,-20,0,14)
    D2.Position = UDim2.new(0,12,0,26)
    D2.BackgroundTransparency = 1
    D2.Text = desc
    D2.TextColor3 = T.Sub
    D2.TextSize = 11
    D2.Font = Enum.Font.Gotham
    D2.TextXAlignment = Enum.TextXAlignment.Left
    B.MouseButton1Click:Connect(cb)
    B.MouseEnter:Connect(function() TweenService:Create(F,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(35,20,45)}):Play() end)
    B.MouseLeave:Connect(function() TweenService:Create(F,TweenInfo.new(0.12),{BackgroundColor3=T.Surface}):Play() end)
end

-- ===== PAGES =====
local PFarm    = MakePage("Farm",    "⚔️", 1)
local PTP      = MakePage("Teleport","🌀", 2)
local PFruit   = MakePage("Fruit",   "🍎", 3)
local PPlayer  = MakePage("Player",  "👤", 4)
local PMisc    = MakePage("Misc",    "⚙️", 5)

-- ===== FARM =====
Section(PFarm, "Auto Farm")
Toggle(PFarm,"Auto Farm","Tự farm mob gần nhất",false,function(v) State.AutoFarm=v end)
Toggle(PFarm,"Auto Quest","Tự nhận và hoàn thành quest",false,function(v) State.AutoQuest=v end)
Toggle(PFarm,"Kill Aura","Tấn công mob trong vùng",false,function(v) State.KillAura=v end)
Toggle(PFarm,"Auto Mastery","Farm mastery trái ác quỷ",false,function(v) State.AutoMastery=v end)

Section(PFarm, "Boss")
Button(PFarm,"Teleport đến Boss gần nhất","Tìm và teleport đến boss",function()
    local char=Player.Character
    if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local best,bd=nil,math.huge
    for _,m in pairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("Humanoid") and m~=char then
            local h=m.Humanoid
            if h.Health>0 and h.MaxHealth>=5000 then
                local r=m:FindFirstChild("HumanoidRootPart")
                if r then
                    local d=(r.Position-root.Position).Magnitude
                    if d<bd then best=r;bd=d end
                end
            end
        end
    end
    if best then root.CFrame=best.CFrame*CFrame.new(5,0,5) end
end)

-- ===== TELEPORT =====
Section(PTP,"First Sea")
local S1={
    {"Starter Island",Vector3.new(999,15,1013)},
    {"Marine Starter",Vector3.new(-2174,10,1479)},
    {"Jungle",Vector3.new(-1500,50,-900)},
    {"Pirate Village",Vector3.new(-1476,23,-1428)},
    {"Desert",Vector3.new(927,15,3772)},
    {"Frozen Village",Vector3.new(1225,138,-3350)},
    {"Middle Town",Vector3.new(466,27,-185)},
    {"Skylands",Vector3.new(-4836,2042,-2272)},
    {"Colosseum",Vector3.new(-1198,73,507)},
    {"Magma Village",Vector3.new(642,20,5008)},
}
for _,v in pairs(S1) do
    Button(PTP,v[1],"Sea 1",function()
        local c=Player.Character
        if c and c.HumanoidRootPart then c.HumanoidRootPart.CFrame=CFrame.new(v[2]) end
    end)
end

Section(PTP,"Second Sea")
local S2={
    {"Kingdom of Rose",Vector3.new(-221,11,-4727)},
    {"Green Zone",Vector3.new(4349,69,-3328)},
    {"Graveyard",Vector3.new(4467,9,-4588)},
    {"Snow Mountain",Vector3.new(979,318,-5245)},
    {"Hot & Cold",Vector3.new(-3237,234,-5428)},
    {"Cursed Ship",Vector3.new(972,10,-9305)},
    {"Ice Castle",Vector3.new(5195,162,-6600)},
}
for _,v in pairs(S2) do
    Button(PTP,v[1],"Sea 2",function()
        local c=Player.Character
        if c and c.HumanoidRootPart then c.HumanoidRootPart.CFrame=CFrame.new(v[2]) end
    end)
end

Section(PTP,"Third Sea")
local S3={
    {"Port Town",Vector3.new(-15553,15,-6727)},
    {"Hydra Island",Vector3.new(-13820,118,-11321)},
    {"Great Tree",Vector3.new(-17863,423,-15738)},
    {"Floating Turtle",Vector3.new(-18239,589,-17800)},
    {"Mansion",Vector3.new(-17816,83,-20395)},
    {"Castle on the Sea",Vector3.new(-25625,240,-17525)},
}
for _,v in pairs(S3) do
    Button(PTP,v[1],"Sea 3",function()
        local c=Player.Character
        if c and c.HumanoidRootPart then c.HumanoidRootPart.CFrame=CFrame.new(v[2]) end
    end)
end

-- ===== FRUIT =====
Section(PFruit,"Devil Fruit")
Toggle(PFruit,"Fruit Notifier","Thông báo khi có trái spawn",false,function(v) State.FruitNotif=v end)
Toggle(PFruit,"Auto Snipe Fruit","Tự động lấy trái gần nhất",false,function(v)
    if v then
        RunService:BindToRenderStep("SunSnipe",1,function()
            if not State.AutoFarm then end
            local c=Player.Character
            if not c then return end
            local root=c:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _,o in pairs(workspace:GetDescendants()) do
                if o.Name=="Fruit" or (o:IsA("Model") and o:FindFirstChild("PickUp")) then
                    local h=o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart")
                    if h then root.CFrame=CFrame.new(h.Position) end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("SunSnipe")
    end
end)

Button(PFruit,"Lấy Fruit Gần Nhất","Teleport đến trái ác quỷ",function()
    local c=Player.Character
    if not c then return end
    local root=c:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local best,bd=nil,math.huge
    for _,o in pairs(workspace:GetDescendants()) do
        if o.Name=="Fruit" then
            local p=o:IsA("BasePart") and o.Position or (o:FindFirstChildWhichIsA("BasePart") and o:FindFirstChildWhichIsA("BasePart").Position)
            if p then
                local d=(p-root.Position).Magnitude
                if d<bd then best=p;bd=d end
            end
        end
    end
    if best then root.CFrame=CFrame.new(best) end
end)

-- ===== PLAYER =====
Section(PPlayer,"Movement")
Toggle(PPlayer,"Fly","Bay tự do (WASD + Space/Shift)",false,function(v)
    State.Fly=v
    local c=Player.Character
    if not c then return end
    local root=c:FindFirstChild("HumanoidRootPart")
    local hum=c:FindFirstChild("Humanoid")
    if not root or not hum then return end
    if v then
        hum.PlatformStand=true
        local bg=Instance.new("BodyGyro",root)
        bg.Name="SunFlyG"
        bg.MaxTorque=Vector3.new(1e9,1e9,1e9)
        bg.D=50
        local bv=Instance.new("BodyVelocity",root)
        bv.Name="SunFlyV"
        bv.MaxForce=Vector3.new(1e9,1e9,1e9)
        bv.Velocity=Vector3.zero
        RunService:BindToRenderStep("SunFly",Enum.RenderPriority.Camera.Value+1,function()
            if not State.Fly then RunService:UnbindFromRenderStep("SunFly") return end
            local cam=workspace.CurrentCamera
            local dir=Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir-=Vector3.new(0,1,0) end
            if dir.Magnitude>0 then dir=dir.Unit end
            bv.Velocity=dir*State.FlySpeed
            bg.CFrame=cam.CFrame
        end)
    else
        hum.PlatformStand=false
        if root:FindFirstChild("SunFlyG") then root.SunFlyG:Destroy() end
        if root:FindFirstChild("SunFlyV") then root.SunFlyV:Destroy() end
        RunService:UnbindFromRenderStep("SunFly")
    end
end)

Toggle(PPlayer,"God Mode","Hồi máu liên tục, không chết",false,function(v)
    State.GodMode=v
end)

Toggle(PPlayer,"Speed Hack","Tăng WalkSpeed lên 60",false,function(v)
    State.SpeedHack=v
    local c=Player.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.WalkSpeed=v and 60 or 16
    end
end)

Section(PPlayer,"Utility")
Button(PPlayer,"Rejoin Server","Vào lại server hiện tại",function()
    game:GetService("TeleportService"):Teleport(game.PlaceId,Player)
end)

Button(PPlayer,"Reset Character","Reset nhân vật",function()
    local c=Player.Character
    if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health=0 end
end)

-- ===== MISC =====
Section(PMisc,"Visual")
Toggle(PMisc,"ESP Players","Hiện tên player qua tường",false,function(v)
    State.ESPPlayers=v
    if v then
        for _,p in pairs(Players:GetPlayers()) do
            if p~=Player and p.Character then
                local r=p.Character:FindFirstChild("HumanoidRootPart")
                if r and not r:FindFirstChild("SunESP") then
                    local bb=Instance.new("BillboardGui",r)
                    bb.Name="SunESP"; bb.Size=UDim2.new(0,120,0,30)
                    bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
                    local lbl=Instance.new("TextLabel",bb)
                    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
                    lbl.Text=p.Name; lbl.TextColor3=T.Accent
                    lbl.TextSize=14; lbl.Font=Enum.Font.GothamBold
                end
            end
        end
    else
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character then
                local r=p.Character:FindFirstChild("HumanoidRootPart")
                if r and r:FindFirstChild("SunESP") then r.SunESP:Destroy() end
            end
        end
    end
end)

Section(PMisc,"Server")
Button(PMisc,"Anti AFK","Ngăn bị kick vì AFK",function()
    local VU=game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VU:Button2Down(Vector2.zero,workspace.CurrentCamera.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.zero,workspace.CurrentCamera.CFrame)
    end)
end)

Button(PMisc,"Copy Join Script","Copy rejoin script server này",function()
    if setclipboard then
        setclipboard(('game:GetService("TeleportService"):TeleportToPlaceInstance(%d,"%s")'):format(game.PlaceId,game.JobId))
    end
end)

Section(PMisc,"Info")
local Info=Instance.new("TextLabel",PMisc)
Info.Size=UDim2.new(1,0,0,55)
Info.BackgroundColor3=T.Surface
Info.BorderSizePixel=0
Info.Text="  ☀️ Sun Hub v1.0  |  NightCracked • NoKey\n  Blox Fruits  |  RightCtrl = Toggle UI"
Info.TextColor3=T.Sub; Info.TextSize=12; Info.Font=Enum.Font.Gotham
Info.TextXAlignment=Enum.TextXAlignment.Left
Instance.new("UICorner",Info).CornerRadius=UDim.new(0,8)

-- Default tab
Pages["Farm"].Visible=true
Tabs["Farm"].btn.BackgroundTransparency=0.75
Tabs["Farm"].btn.TextColor3=T.Primary
Tabs["Farm"].ind.Visible=true

-- Auto Farm heartbeat
RunService.Heartbeat:Connect(function()
    local c=Player.Character
    if not c then return end
    local root=c:FindFirstChild("HumanoidRootPart")
    local hum=c:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health<=0 then return end

    if State.GodMode then hum.Health=hum.MaxHealth end

    if State.AutoFarm or State.KillAura then
        local best,bd=nil,math.huge
        for _,m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and m~=c then
                local h=m.Humanoid
                if h.Health>0 and h.MaxHealth<5000 then
                    local r=m:FindFirstChild("HumanoidRootPart")
                    if r then
                        local d=(r.Position-root.Position).Magnitude
                        if d<bd then best=r;bd=d end
                    end
                end
            end
        end
        if best and State.AutoFarm then
            if bd>12 then root.CFrame=best.CFrame*CFrame.new(5,0,5) end
            hum:MoveTo(best.Position)
        end
    end
end)

-- Fruit Notifier heartbeat
RunService.Heartbeat:Connect(function()
    if not State.FruitNotif then return end
    for _,o in pairs(workspace:GetDescendants()) do
        if o.Name=="Fruit" and not o:FindFirstChild("SunTagged") then
            Instance.new("BoolValue",o).Name="SunTagged"
            local notifGui=Instance.new("ScreenGui",Player.PlayerGui)
            notifGui.Name="SunNotif"; notifGui.ResetOnSpawn=false
            local nf=Instance.new("Frame",notifGui)
            nf.Size=UDim2.new(0,280,0,56)
            nf.Position=UDim2.new(1,-296,0,16)
            nf.BackgroundColor3=T.Surface; nf.BorderSizePixel=0
            Instance.new("UICorner",nf).CornerRadius=UDim.new(0,8)
            local nl=Instance.new("TextLabel",nf)
            nl.Size=UDim2.new(1,-16,1,0); nl.Position=UDim2.new(0,10,0,0)
            nl.BackgroundTransparency=1
            nl.Text="🍎 Devil Fruit Spawned!\n"..tostring(o.Parent.Name)
            nl.TextColor3=T.Accent; nl.TextSize=13; nl.Font=Enum.Font.GothamBold
            nl.TextXAlignment=Enum.TextXAlignment.Left
            task.delay(5,function() notifGui:Destroy() end)
        end
    end
end)

-- Toggle hotkey
UserInputService.InputBegan:Connect(function(i,gpe)
    if gpe then return end
    if i.KeyCode==Enum.KeyCode.RightControl then MF.Visible=not MF.Visible end
end)

print("☀️ Sun Hub loaded | NightCracked NoKey")
