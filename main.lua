local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local P = Players
local CAM = Camera
local L = Lighting
local RS = RunService
local TS = TweenService
local UIS = UserInputService
local FB = Enum.Font.GothamBold
local FNM = Enum.Font.GothamMedium

local function GetGuiParent()
    local ok, cg = pcall(function() return CoreGui end)
    if ok and cg then return cg end
    return LP:WaitForChild("PlayerGui")
end
local GUIPARENT = GetGuiParent()

local CFG = {
    SJ = false, Speed = 22, NoClip = false,
    FOV = 90, FB = false,
    Aim = false, AimFOV = 200, AimSmooth = 5, AimShowCircle = false,
    
    P_ESP = false, P_Color = Color3.fromRGB(0,170,255), P_HiddenColor = Color3.fromRGB(255, 50, 50), P_Dst = 500,
    M_ESP = false, M_Dst = 500,
    L_ESP = false, L_Dst = 500,
    S_ESP = false, S_Color = Color3.fromRGB(0,255,120), S_Dst = 500,
    ESP_Name = true, ESP_Dist = true, ESP_Size = 100, IgnoreDead = true,
    
    Chams = false, ChamsPlayers = true, ChamsMonsters = true,
    ChamsRange = 500,
    ChamsVisibleColor = Color3.fromRGB(0, 150, 255),
    ChamsHiddenColor  = Color3.fromRGB(255, 50, 50),
    
    MonsterVisibleColor = Color3.fromRGB(0, 255, 100),
    MonsterHiddenColor  = Color3.fromRGB(255, 50, 50),
    
    ChamsTransparency = 0.5, ChamsOutline = true,
    
    Theme = "Glass", 
    MenuColor = Color3.fromRGB(14, 14, 20),
    MenuAccent = Color3.fromRGB(88, 101, 242),
    MenuTextColor = Color3.fromRGB(240, 240, 245),
    MenuSizeX = 680,
    MenuSizeY = 480,
    ToggleBtnSize = 64,
    ToggleBtnColor = Color3.fromRGB(14, 14, 20),
    ToggleBtnTextColor = Color3.fromRGB(255, 255, 255),
    ToggleBtnVisible = true,
    
    SelectedEffect = "None",
    EffectColor = Color3.fromRGB(0, 170, 255),
    EffectSpeed = 1,
    EffectTransparency = 0.4,
    EffectSize = 1,
    EffectAmount = 1,
    EffectOrbitRadius = 5,
    EffectOrbitGlow = true,
    EffectGlowDistance = 4,
    EffectRGB = false,
    
    FogEnabled = false,
    FogColor = Color3.fromRGB(200, 200, 200),
    FogStart = 30,
    FogEnd = 150,
    
    Language = "RU",
    ConfirmExit = true,
}

local SAVE_FILE = "sAs_pop_ultimate.json"
local hasFS = (typeof(writefile) == "function") and (typeof(readfile) == "function")

local LOC = {
    RU = {
        title = "sAs_pop", subtitle = "ULTIMATE v6",
        speed = "Скорость", speedhack = "Спидхак", noclip = "NoClip",
        camera = "Камера", light = "Свет", fullbright = "FullBright",
        esp = "ESP", players = "Игроки", monsters = "Монстры", loot = "Лут", sellers = "Продавцы",
        esp_name = "Имя", esp_dist = "Дистанция", esp_size = "Размер ESP",
        chams = "Chams", chams_enable = "Включить Chams", chams_players = "Chams игроки",
        chams_monsters = "Chams монстры", chams_range = "Дальность",
        chams_transp = "Прозрачность", chams_vis = "Видим", chams_hid = "Невидим",
        aim = "Аим", aim_enable = "Включить аим", aim_fov = "FOV", aim_smooth = "Плавность", aim_circle = "Круг аима",
        effects = "Эффекты", effects_desc = "Один эффект за раз (3D в мире).",
        eff_speed = "Скорость", eff_transp = "Прозрачность", eff_color = "Цвет",
        config = "Конфиг", save = "💾 Сохранить", load = "📂 Загрузить",
        menu = "Меню", menu_color = "Цвет меню", menu_accent = "Акцент",
        menu_text = "Текст", menu_w = "Ширина", menu_h = "Высота",
        language = "Язык", confirm_exit = "Подтверждение выхода",
        confirm_title = "Выход", confirm_text = "Вы уверены, что хотите выйти?",
        yes = "Да", no = "Нет", off = "❌ Выключить все эффекты",
        saved = "Сохранено", loaded = "Загружено", err_fs = "Нет доступа к файлам",
        monster_color = "Цвета монстров", black_menu = "⬛ Чёрный цвет меню",
        toggle = "sAs",
    },
    EN = {
        title = "sAs_pop", subtitle = "ULTIMATE v6",
        speed = "Speed", speedhack = "Speedhack", noclip = "NoClip",
        camera = "Camera", light = "Light", fullbright = "FullBright",
        esp = "ESP", players = "Players", monsters = "Monsters", loot = "Loot", sellers = "Sellers",
        esp_name = "Name", esp_dist = "Distance", esp_size = "ESP Size",
        chams = "Chams", chams_enable = "Enable Chams", chams_players = "Chams players",
        chams_monsters = "Chams monsters", chams_range = "Range",
        chams_transp = "Transparency", chams_vis = "Visible", chams_hid = "Hidden",
        aim = "Aim", aim_enable = "Enable aim", aim_fov = "FOV", aim_smooth = "Smoothness", aim_circle = "Aim circle",
        effects = "Effects", effects_desc = "One effect at a time (3D in world).",
        eff_speed = "Speed", eff_transp = "Transparency", eff_color = "Color",
        config = "Config", save = "💾 Save", load = "📂 Load",
        menu = "Menu", menu_color = "Menu color", menu_accent = "Accent",
        menu_text = "Text", menu_w = "Width", menu_h = "Height",
        language = "Language", confirm_exit = "Confirm exit",
        confirm_title = "Exit", confirm_text = "Are you sure you want to exit?",
        yes = "Yes", no = "No", off = "❌ Disable all effects",
        saved = "Saved", loaded = "Loaded", err_fs = "No file access",
        monster_color = "Monster colors", black_menu = "⬛ Black menu color",
        toggle = "sAs",
    },
    ABORT = {
        title = "sAs_pop", subtitle = "v6",
        speed = "Скорость", speedhack = "Спидхак", noclip = "NoClip",
        camera = "Камера", light = "Свет", fullbright = "FullBright",
        esp = "ESP", players = "Игроки", monsters = "Монстры", loot = "Лут", sellers = "Продавцы",
        esp_name = "Имя", esp_dist = "Дист.", esp_size = "Разм. ESP",
        chams = "Chams", chams_enable = "Chams", chams_players = "Chams игр.",
        chams_monsters = "Chams монстры", chams_range = "Дальн.",
        chams_transp = "Прозр.", chams_vis = "Вид.", chams_hid = "Невид.",
        aim = "Аим", aim_enable = "Аим", aim_fov = "FOV", aim_smooth = "Плавн.", aim_circle = "Круг аима",
        effects = "Эффекты", effects_desc = "Один за раз.",
        eff_speed = "Скор.", eff_transp = "Прозр.", eff_color = "Цвет",
        config = "Конфиг", save = "💾 Сохр.", load = "📂 Загр.",
        menu = "Меню", menu_color = "Цвет", menu_accent = "Акцент",
        menu_text = "Текст", menu_w = "Шир.", menu_h = "Выс.",
        language = "Язык", confirm_exit = "Подтв.",
        confirm_title = "Выход", confirm_text = "Вы уверены?",
        yes = "Да", no = "Нет", off = "❌ Выкл.",
        saved = "OK", loaded = "OK", err_fs = "FS err",
        monster_color = "Цвета монстров", black_menu = "⬛ Чёрный",
        toggle = "sAs",
    },
}

local function T(key)
    local lang = LOC[CFG.Language] or LOC.RU
    return lang[key] or LOC.RU[key] or key
end

local function Notify(text, color)
    local gui = Instance.new("ScreenGui")
    gui.Name = "sAs_pop_Notify"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 5000
    gui.Parent = GUIPARENT
    local lbl = Instance.new("TextLabel", gui)
    lbl.Size = UDim2.new(0, 320, 0, 44)
    lbl.Position = UDim2.new(0.5, -160, 0, -60)
    lbl.BackgroundColor3 = color or Color3.fromRGB(88, 101, 242)
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Text = text
    lbl.Font = FNM
    lbl.TextSize = 14
    lbl.TextWrapped = true
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", lbl)
    stroke.Color = Color3.new(1,1,1)
    stroke.Transparency = 0.8
    TS:Create(lbl, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -160, 0, 20)
    }):Play()
    task.delay(2.2, function()
        local t = TS:Create(lbl, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -160, 0, -60),
            BackgroundTransparency = 1
        })
        t:Play()
        t.Completed:Connect(function() gui:Destroy() end)
    end)
end

local function SaveCFG(silent)
    if not hasFS then
        if not silent then Notify(T("err_fs"), Color3.fromRGB(200, 50, 50)) end
        return
    end
    pcall(function()
        local data = {}
        for k, v in pairs(CFG) do
            if typeof(v) == "Color3" then
                data[k] = {__c = true, r = v.R, g = v.G, b = v.B}
            elseif typeof(v) == "boolean" or typeof(v) == "number" or typeof(v) == "string" then
                data[k] = v
            end
        end
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end)
    if not silent then Notify(T("saved")) end
end

local function LoadCFG()
    if not hasFS then return end
    pcall(function()
        if not isfile(SAVE_FILE) then return end
        local raw = readfile(SAVE_FILE)
        if not raw or raw == "" then return end
        local data = HttpService:JSONDecode(raw)
        for k, v in pairs(data) do
            if type(v) == "table" and v.__c then
                CFG[k] = Color3.new(v.r, v.g, v.b)
            elseif CFG[k] ~= nil and type(v) == type(CFG[k]) then
                CFG[k] = v
            end
        end
    end)
    local Monsters, Loot, Sellers = {}, {}, {}
local ActiveESP = {}
local ActiveChams = {}
local OriginalLighting = { Ambient = L.Ambient, Brightness = L.Brightness }

local function IsAliveMob(m)
    if not CFG.IgnoreDead then return true end
    local h = m:FindFirstChildOfClass("Humanoid")
    if h and h.Health <= 0 then return false end
    return true
end
local function IsMob(o)
    if not o or not o:IsA("Model") or o == LP.Character or P:GetPlayerFromCharacter(o) then return false end
    local n = string.lower(o.Name)
    if o:FindFirstChildOfClass("Humanoid") then return true end
    if string.find(n,"monster") or string.find(n,"bacteria") or string.find(n,"hound") then return true end
    return false
end
local function IsLoot(o)
    if not o or not o:IsA("BasePart") then return false end
    local n = string.lower(o.Name)
    if string.find(n,"gold") or string.find(n,"item") or string.find(n,"key") then return true end
    return false
end
local function IsSeller(o)
    if not o or not o:IsA("Model") then return false end
    local n = string.lower(o.Name)
    if string.find(n,"seller") or string.find(n,"shop") or string.find(n,"trader")
        or string.find(n,"vendor") or string.find(n,"merchant") or string.find(n,"npc")
        or string.find(n,"armory") or string.find(n,"armoury") or string.find(n,"store")
        or string.find(n,"market") or string.find(n,"buy") or string.find(n,"cashier") then
        return true
    end
    return false
end

task.spawn(function()
    while task.wait(1.5) do
        local m, l, s = {}, {}, {}
        local function Scan(f)
            for _, o in ipairs(f:GetChildren()) do
                if IsMob(o) then
                    if IsAliveMob(o) then
                        local p = o:FindFirstChild("Head") or o:FindFirstChild("HumanoidRootPart") or o:FindFirstChildOfClass("BasePart")
                        if p then table.insert(m, {M = o, P = p}) end
                    end
                elseif IsLoot(o) then
                    table.insert(l, o)
                elseif IsSeller(o) then
                    table.insert(s, o)
                elseif o:IsA("Folder") or o:IsA("Model") then
                    if o ~= LP.Character then Scan(o) end
                end
            end
        end
        Scan(workspace)
        Monsters, Loot, Sellers = m, l, s
    end
end)

local function GetMonsterColor(model, visible)
    if visible == nil then visible = true end
    return visible and CFG.MonsterVisibleColor or CFG.MonsterHiddenColor
end

local function ClosestMob()
    local best, bestD = nil, CFG.AimFOV
    local ctr = Vector2.new(CAM.ViewportSize.X*0.5, CAM.ViewportSize.Y*0.5)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local exclude = {LP.Character}
    for _, d in ipairs(Monsters) do
        if d.M then table.insert(exclude, d.M) end
    end
    for _, p in ipairs(P:GetPlayers()) do
        if p.Character then table.insert(exclude, p.Character) end
    end
    rp.FilterDescendantsInstances = exclude
    for _, d in ipairs(Monsters) do
        if d.P and d.P.Parent and IsAliveMob(d.M) then
            local sp, on = CAM:WorldToViewportPoint(d.P.Position)
            if on then
                local md = (Vector2.new(sp.X, sp.Y) - ctr).Magnitude
                if md < bestD then
                    local hit = workspace:Raycast(CAM.CFrame.Position, d.P.Position - CAM.CFrame.Position, rp)
                    if not hit then
                        bestD = md; best = d.P
                    end
                end
            end
        end
    end
    return best
end

local lastAimCheck = 0
local currentAimTarget = nil

RS.RenderStepped:Connect(function(dt)
    if CFG.Aim then
        lastAimCheck = lastAimCheck + dt
        if lastAimCheck > 0.06 then 
            lastAimCheck = 0
            currentAimTarget = ClosestMob()
        end
        if currentAimTarget then
            local target = CFrame.new(CAM.CFrame.Position, currentAimTarget.Position)
            local a = math.clamp(dt * (60 / math.max(CFG.AimSmooth, 1)), 0, 1)
            CAM.CFrame = CAM.CFrame:Lerp(target, a)
        end
    end

    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        
        if hum then hum.WalkSpeed = CFG.SJ and CFG.Speed or 16 end
        
        if rootPart then
            local isCurrentlyNoClip = CFG.NoClip
            local wasNoClip = char:GetAttribute("sAs_LastNoClip")
            
            if isCurrentlyNoClip then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            else
                if wasNoClip == true then
                    rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 3, 0)
                    task.spawn(function()
                        task.wait(0.1)
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" 
                            and p.Name ~= "RightHand" and p.Name ~= "LeftHand" 
                            and p.Name ~= "RightUpperArm" and p.Name ~= "LeftUpperArm"
                            and p.Name ~= "RightLowerArm" and p.Name ~= "LeftLowerArm"
                            and not p:FindFirstChild("Weapon") then
                                p.CanCollide = true
                            end
                        end
                    end)
                end
            end
            char:SetAttribute("sAs_LastNoClip", isCurrentlyNoClip)
        end
    end

    if math.abs(CAM.FieldOfView - CFG.FOV) > 0.1 then CAM.FieldOfView = CFG.FOV end

    if CFG.FB then
        L.Ambient = Color3.fromRGB(255,255,255)
        L.Brightness = 2
    else
        if L.Ambient ~= OriginalLighting.Ambient then L.Ambient = OriginalLighting.Ambient end
        if L.Brightness ~= OriginalLighting.Brightness then L.Brightness = OriginalLighting.Brightness end
    end
end)

RS.Heartbeat:Connect(function()
    if CFG.FogEnabled then
        L.FogColor = CFG.FogColor
        L.FogStart = CFG.FogStart
        L.FogEnd = CFG.FogEnd
    else
        L.FogStart = 0
        L.FogEnd = 100000
    end
end)
    local function RemoveESP(o)
    local d = ActiveESP[o]
    if d then
        if d.B then pcall(function() d.B:Destroy() end) end
        ActiveESP[o] = nil
    end
end

local function RefreshESP(o, clr, name, key, maxD)
    if not CFG[key] then 
        RemoveESP(o) 
        return 
    end
    
    if not o or not o.Parent then RemoveESP(o) return end
    local root = o:FindFirstChild("HumanoidRootPart") or o:FindFirstChild("Head") or o:FindFirstChildOfClass("BasePart")
    if not root then RemoveESP(o) return end
    local lpR = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not lpR then return end
    local d = (root.Position - lpR.Position).Magnitude
    if d > CFG[maxD] then RemoveESP(o) return end
    
    local x = ActiveESP[o]
    if not x then
        x = {}
        local b = Instance.new("BillboardGui")
        b.AlwaysOnTop = true
        b.StudsOffset = Vector3.new(0, 2.5, 0)
        b.Size = UDim2.new(0, 200 * (CFG.ESP_Size / 100), 0, 34 * (CFG.ESP_Size / 100)) 
        b.Adornee = root
        b.Parent = GUIPARENT
        
        local frame = Instance.new("Frame", b)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.BackgroundTransparency = 0.4
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = clr
        stroke.Thickness = 1.5
        
        local t = Instance.new("TextLabel", frame)
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.TextColor3 = clr
        t.Font = FNM
        t.TextSize = math.floor(12 * (CFG.ESP_Size / 100))
        t.TextStrokeTransparency = 0.5
        
        x.B = b; x.T = t; x.S = stroke
        ActiveESP[o] = x
    else
        x.B.Size = UDim2.new(0, 200 * (CFG.ESP_Size / 100), 0, 34 * (CFG.ESP_Size / 100))
        if x.T then x.T.TextSize = math.floor(12 * (CFG.ESP_Size / 100)) end
    end
    
    if x.T then
        x.T.TextColor3 = clr
        if x.S then x.S.Color = clr end
        local parts = {}
        if CFG.ESP_Name then table.insert(parts, name) end
        if CFG.ESP_Dist then table.insert(parts, "["..math.floor(d).."m]") end
        x.T.Text = table.concat(parts, " ")
    end
end

local function IsVisible(model)
    local lpChar = LP.Character
    if not lpChar then return false end
    local lpRoot = lpChar:FindFirstChild("HumanoidRootPart")
    if not lpRoot then return false end
    
    local target = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
    if not target then return false end
    
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local exclude = {lpChar, model}
    for _, d in ipairs(Monsters) do
        if d.M and d.M ~= model then table.insert(exclude, d.M) end
    end
    for _, p in ipairs(P:GetPlayers()) do
        if p.Character and p.Character ~= model then table.insert(exclude, p.Character) end
    end
    rp.FilterDescendantsInstances = exclude
    
    local hit = workspace:Raycast(lpRoot.Position, target.Position - lpRoot.Position, rp)
    
    if not hit then return true end
    if hit.Instance.Transparency > 0.5 then return true end 
    return false
end

task.spawn(function()
    while task.wait(0.2) do
        if CFG.P_ESP then
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character then
                    local vis = IsVisible(p.Character)
                    local textColor = vis and CFG.P_Color or CFG.P_HiddenColor
                    RefreshESP(p.Character, textColor, p.Name, "P_ESP", "P_Dst")
                end
            end
        end
        if CFG.M_ESP then
            for _, d in ipairs(Monsters) do
                if d.M and d.M.Parent and IsAliveMob(d.M) then
                    local vis = IsVisible(d.M)
                    local textColor = GetMonsterColor(d.M, vis)
                    RefreshESP(d.M, textColor, d.M.Name, "M_ESP", "M_Dst")
                end
            end
        end
        if CFG.L_ESP then
            for _, o in ipairs(Loot) do
                if o and o.Parent then RefreshESP(o, Color3.fromRGB(255,220,0), o.Name, "L_ESP", "L_Dst") end
            end
        end
        if CFG.S_ESP then
            for _, o in ipairs(Sellers) do
                if o and o.Parent then RefreshESP(o, CFG.S_Color, o.Name, "S_ESP", "S_Dst") end
            end
        end
        
        for obj in pairs(ActiveESP) do
            if obj.Parent == nil then RemoveESP(obj) end
        end
    end
end)

local function RemoveChams(model)
    local data = ActiveChams[model]
    if data then
        for _, hl in ipairs(data.Highlights) do
            if hl and hl.Parent then pcall(function() hl:Destroy() end) end
        end
        ActiveChams[model] = nil
    end
end

local function ApplyChams(model, visible, isMonster)
    if not model or not model.Parent then RemoveChams(model) return end
    local lpChar = LP.Character
    local lpRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
    if not lpRoot then RemoveChams(model) return end
    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChildOfClass("BasePart")
    if not root then RemoveChams(model) return end
    local dist = (root.Position - lpRoot.Position).Magnitude
    if dist > CFG.ChamsRange then RemoveChams(model) return end
    
    local clr
    if isMonster and CFG.ChamsMonsters then
        clr = GetMonsterColor(model, visible)
    else
        clr = visible and CFG.ChamsVisibleColor or CFG.ChamsHiddenColor
    end
    
    local data = ActiveChams[model]
    if not data then
        data = {Highlights = {}}
        local hl = Instance.new("Highlight")
        hl.Adornee = model
        hl.Parent = GUIPARENT
        hl.FillColor = clr
        hl.FillTransparency = CFG.ChamsTransparency
        hl.OutlineColor = CFG.ChamsOutline and clr or Color3.new(0,0,0)
        hl.OutlineTransparency = CFG.ChamsOutline and 0 or 1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(data.Highlights, hl)
        ActiveChams[model] = data
    end
    for _, hl in ipairs(data.Highlights) do
        if hl and hl.Parent then
            hl.FillColor = clr
            hl.FillTransparency = CFG.ChamsTransparency
            hl.OutlineColor = CFG.ChamsOutline and clr or Color3.new(0,0,0)
            hl.OutlineTransparency = CFG.ChamsOutline and 0 or 1
        end
    end
end

task.spawn(function()
    while task.wait(0.2) do
        if not CFG.Chams then
            for model in pairs(ActiveChams) do RemoveChams(model) end
        else
            if CFG.ChamsPlayers then
                for _, p in ipairs(P:GetPlayers()) do
                    if p ~= LP and p.Character then
                        ApplyChams(p.Character, IsVisible(p.Character), false)
                    end
                end
            end
            if CFG.ChamsMonsters then
                for _, d in ipairs(Monsters) do
                    if d.M and d.M.Parent and IsAliveMob(d.M) then
                        ApplyChams(d.M, IsVisible(d.M), true)
                    end
                end
            end
            for model in pairs(ActiveChams) do
                if not model.Parent then RemoveChams(model) end
            end
        end
    end
end)
    local AimCircleGui = nil
local AimCircleStroke = nil
local function UpdateAimCircle()
    if not CFG.AimShowCircle then
        if AimCircleGui then
            pcall(function() AimCircleGui:Destroy() end)
            AimCircleGui = nil
            AimCircleStroke = nil
        end
        return
    end
    if not AimCircleGui then
        AimCircleGui = Instance.new("ScreenGui")
        AimCircleGui.Name = "sAs_pop_AimCircle"
        AimCircleGui.ResetOnSpawn = false
        AimCircleGui.IgnoreGuiInset = true
        AimCircleGui.DisplayOrder = 900
        AimCircleGui.Parent = GUIPARENT
        local frame = Instance.new("Frame", AimCircleGui)
        frame.Name = "Frame"
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        AimCircleStroke = Instance.new("UIStroke", frame)
        AimCircleStroke.Thickness = 2
        AimCircleStroke.Transparency = 0.3
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(1, 0)
    end
    local frame = AimCircleGui:FindFirstChild("Frame")
    if frame then
        frame.Size = UDim2.new(0, CFG.AimFOV * 2, 0, CFG.AimFOV * 2)
        if AimCircleStroke then AimCircleStroke.Color = CFG.MenuAccent end
    end
end

task.spawn(function()
    while task.wait(0.1) do
        UpdateAimCircle()
    end
end)

local EffectFolder = nil
local EffectRunning = false
local EffectTask = nil
local EffectParts = {}

local EffectDescriptions = {
    Fireflies = "Светлячки", Sparks = "Искры", Rain = "Дождь",
    Snow = "Снег", Orbits = "Кольцо из шаров", GroundGlow = "Свечение",
}

local function ClearEffectParts()
    if EffectFolder then pcall(function() EffectFolder:Destroy() end) EffectFolder = nil end
    EffectParts = {}
end

local function StopCurrentEffect()
    EffectRunning = false
    if EffectTask then pcall(function() task.cancel(EffectTask) end) EffectTask = nil end
    ClearEffectParts()
end

local function MakeBall(name, size, clr, transparency, parent)
    local p = Instance.new("Part")
    p.Name = name
    p.Shape = Enum.PartType.Ball 
    p.Size = Vector3.new(size, size, size)
    p.Color = clr
    p.Material = Enum.Material.Neon
    p.Transparency = transparency
    p.CanCollide = false
    p.Anchored = true
    p.CastShadow = false
    p.Locked = true
    p.Parent = parent
    return p
end

local function StartEffectByName(name)
    StopCurrentEffect()
    if not name or name == "None" then return end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    EffectFolder = Instance.new("Folder")
    EffectFolder.Name = "sAs_pop_EffectWorld"
    EffectFolder.Parent = workspace

    local clr = CFG.EffectColor
    local speed = math.max(CFG.EffectSpeed, 0.1)
    local trans = CFG.EffectTransparency
    local pSize = CFG.EffectSize
    EffectRunning = true

    if name == "Fireflies" then
        local count = math.floor(15 * CFG.EffectAmount)
        for i = 1, count do
            local p = MakeBall("Firefly", pSize, clr, trans, EffectFolder)
            local angle = math.random() * math.pi * 2
            local height = math.random(2, 8)
            local radius = math.random(3, 15)
            table.insert(EffectParts, {part = p, angle = angle, height = height, radius = radius, speed = math.random(5, 10)/10})
        end
        EffectTask = task.spawn(function()
            while EffectRunning and EffectFolder and EffectFolder.Parent do
                local t = tick() * speed
                if CFG.EffectRGB then clr = Color3.fromHSV((t/10)%1, 1, 1) end
                for _, data in ipairs(EffectParts) do
                    if data.part and data.part.Parent then
                        data.part.Color = clr
                        local a = data.angle + t * data.speed
                        data.part.Position = hrp.Position + Vector3.new(
                            math.cos(a) * data.radius,
                            data.height + math.sin(t * 2 + data.angle) * 1,
                            math.sin(a) * data.radius
                        )
                    end
                end
                task.wait(0.03)
            end
        end)
    elseif name == "Sparks" then
        EffectTask = task.spawn(function()
            while EffectRunning and EffectFolder and EffectFolder.Parent do
                local count = math.floor(3 * CFG.EffectAmount)
                for i = 1, count do
                    local p = MakeBall("Spark", pSize, clr, trans, EffectFolder)
                    local angle = math.random() * math.pi * 2
                    local radius = math.random(1, 5)
                    local startPos = hrp.Position + Vector3.new(math.cos(angle) * radius, -2.5, math.sin(angle) * radius)
                    p.Position = startPos
                    local vel = Vector3.new((math.random() - 0.5) * 0.5, math.random(2, 6), (math.random() - 0.5) * 0.5)
                    task.spawn(function()
                        local life = 0
                        while life < 1.5 and p.Parent do
                            life = life + 0.03
                            if CFG.EffectRGB then p.Color = Color3.fromHSV((tick()/2)%1, 1, 1) end
                            vel = vel - Vector3.new(0, 9.8 * 0.03, 0)
                            p.Position = p.Position + vel * 0.05
                            p.Transparency = math.clamp(trans + life * 0.6, 0, 1)
                            task.wait(0.03)
                        end
                        if p then p:Destroy() end
                    end)
                end
                task.wait(0.1 / speed)
            end
        end)
    elseif name == "Rain" then
        EffectTask = task.spawn(function()
            while EffectRunning and EffectFolder and EffectFolder.Parent do
                local count = math.floor(8 * CFG.EffectAmount)
                for i = 1, count do
                    local p = MakeBall("Rain", pSize * 2, clr, trans, EffectFolder)
                    local offset = Vector3.new(math.random(-20, 20), math.random(10, 20), math.random(-20, 20))
                    p.Position = hrp.Position + offset
                    task.spawn(function()
                        local fallSpeed = 0.5
                        while p.Parent and offset.Y > -5 do
                            if CFG.EffectRGB then p.Color = Color3.fromHSV((tick()/2)%1, 1, 1) end
                            offset = offset - Vector3.new(0, fallSpeed, 0)
                            p.Position = hrp.Position + offset
                            task.wait(0.03)
                        end
                        if p then p:Destroy() end
                    end)
                end
                task.wait(0.1 / speed)
            end
        end)
    elseif name == "Snow" then
        EffectTask = task.spawn(function()
            while EffectRunning and EffectFolder and EffectFolder.Parent do
                local count = math.floor(5 * CFG.EffectAmount)
                for i = 1, count do
                    local p = MakeBall("Snow", pSize, clr, trans, EffectFolder)
                    local offset = Vector3.new(math.random(-20, 20), math.random(5, 20), math.random(-20, 20))
                    p.Position = hrp.Position + offset
                    task.spawn(function()
                        local drift = math.random() * math.pi * 2
                        while p.Parent and offset.Y > -5 do
                            if CFG.EffectRGB then p.Color = Color3.fromHSV((tick()/3)%1, 1, 1) end
                            offset = offset + Vector3.new(math.sin(drift) * 0.03, -0.1, math.cos(drift) * 0.03)
                            drift = drift + 0.02
                            p.Position = hrp.Position + offset
                            task.wait(0.03)
                        end
                        if p then p:Destroy() end
                    end)
                end
                task.wait(0.1 / speed)
            end
        end)
    elseif name == "Orbits" then
        local count = math.floor(24 * CFG.EffectAmount)
        for i = 1, count do
            local p = MakeBall("OrbitPoint", pSize, clr, trans, EffectFolder)
            table.insert(EffectParts, {part = p, angle = (i / count) * math.pi * 2})
        end
        
        EffectTask = task.spawn(function()
            local colorStep = 0
            while EffectRunning and EffectFolder and EffectFolder.Parent do
                local t = tick() * speed
                
                if CFG.EffectRGB then
                    colorStep = colorStep + 0.5 * speed
                    local hue = (colorStep / 360) % 1
                    clr = Color3.fromHSV(hue, 1, 1)
                end

                for i, data in ipairs(EffectParts) do
                    if data.part and data.part.Parent then
                        local angle = data.angle + t
                        local radius = CFG.EffectOrbitRadius
                        local height = math.sin(t * 2 + i) * 1.5
                        
                        data.part.Position = hrp.Position + Vector3.new(
                            math.cos(angle) * radius,
                            height,
                            math.sin(angle) * radius
                        )
                        
                        data.part.Color = clr
                        if CFG.EffectOrbitGlow then
                            local light = data.part:FindFirstChildOfClass("PointLight")
                            if not light then
                                light = Instance.new("PointLight", data.part)
                            end
                            light.Color = clr
                            light.Range = CFG.EffectGlowDistance
                            light.Brightness = 2
                        else
                            local light = data.part:FindFirstChildOfClass("PointLight")
                            if light then light:Destroy() end
                        end
                    end
                end
                task.wait(0.03)
            end
        end)
    elseif name == "GroundGlow" then
        local glow = Instance.new("Part")
        glow.Shape = Enum.PartType.Cylinder
        glow.Size = Vector3.new(0.1, 8, 8)
        glow.Orientation = Vector3.new(0, 0, 90)
        glow.Color = clr
        glow.Material = Enum.Material.Neon
        glow.Transparency = trans
        glow.CanCollide = false
        glow.Anchored = true
        glow.CastShadow = false
        glow.Parent = EffectFolder
        local light = Instance.new("PointLight", glow)
        light.Color = clr
        light.Range = 12
        light.Brightness = 2
        EffectTask = task.spawn(function()
            local t = 0
            while EffectRunning and EffectFolder and EffectFolder.Parent do
                t = t + 0.05 * speed
                if CFG.EffectRGB then glow.Color = Color3.fromHSV((t/5)%1, 1, 1) end
                glow.Position = hrp.Position - Vector3.new(0, 2.5, 0)
                glow.Size = Vector3.new(0.1, 8 + math.sin(t) * 2, 8 + math.sin(t) * 2)
                glow.Transparency = math.clamp(trans + math.sin(t) * 0.2, 0, 1)
                task.wait(0.05)
            end
        end)
    end
end

local function RefreshEffects()
    StartEffectByName(CFG.SelectedEffect)
    end
    local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "sAs_pop_Menu"
MenuGui.ResetOnSpawn = false
MenuGui.IgnoreGuiInset = true
MenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MenuGui.DisplayOrder = 1000
MenuGui.Parent = GUIPARENT

local Main = Instance.new("Frame", MenuGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, CFG.MenuSizeX, 0, CFG.MenuSizeY)
Main.Position = UDim2.new(0.5, -CFG.MenuSizeX/2, 0.5, -CFG.MenuSizeY/2)
Main.BackgroundColor3 = CFG.MenuColor
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 170, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.ClipsDescendants = true
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 20)

local LogoFrame = Instance.new("Frame", Sidebar)
LogoFrame.Size = UDim2.new(1, -24, 0, 60)
LogoFrame.Position = UDim2.new(0, 12, 0, 12)
LogoFrame.BackgroundTransparency = 1

local LogoDot = Instance.new("Frame", LogoFrame)
LogoDot.Size = UDim2.new(0, 36, 0, 36)
LogoDot.Position = UDim2.new(0, 0, 0.5, -18)
LogoDot.BorderSizePixel = 0
Instance.new("UICorner", LogoDot).CornerRadius = UDim.new(0, 10)

local LogoDotGrad = Instance.new("UIGradient", LogoDot)
LogoDotGrad.Rotation = 45

local LogoLbl = Instance.new("TextLabel", LogoFrame)
LogoLbl.Size = UDim2.new(1, -46, 0, 18)
LogoLbl.Position = UDim2.new(0, 46, 0.5, -20)
LogoLbl.BackgroundTransparency = 1
LogoLbl.Text = T("title")
LogoLbl.Font = FB
LogoLbl.TextSize = 14
LogoLbl.TextXAlignment = Enum.TextXAlignment.Left

local LogoSub = Instance.new("TextLabel", LogoFrame)
LogoSub.Size = UDim2.new(1, -46, 0, 14)
LogoSub.Position = UDim2.new(0, 46, 0.5, 0)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = T("subtitle")
LogoSub.Font = FNM
LogoSub.TextSize = 11
LogoSub.TextXAlignment = Enum.TextXAlignment.Left

local SideSep = Instance.new("Frame", Sidebar)
SideSep.Size = UDim2.new(1, -24, 0, 1)
SideSep.Position = UDim2.new(0, 12, 0, 82)
SideSep.BackgroundTransparency = 0.85
SideSep.BorderSizePixel = 0

local TabList = Instance.new("Frame", Sidebar)
TabList.Size = UDim2.new(1, -16, 1, -180)
TabList.Position = UDim2.new(0, 8, 0, 92)
TabList.BackgroundTransparency = 1
local TabListLayout = Instance.new("UIListLayout", TabList)
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local CloseBtn = Instance.new("TextButton", Sidebar)
CloseBtn.Size = UDim2.new(1, -24, 0, 36)
CloseBtn.Position = UDim2.new(0, 12, 1, -48)
CloseBtn.BackgroundTransparency = 0.7
CloseBtn.Text = "×  " .. T("confirm_title")
CloseBtn.Font = FNM
CloseBtn.TextSize = 13
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)
CloseBtn.MouseEnter:Connect(function() TS:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play() end)
CloseBtn.MouseLeave:Connect(function() TS:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play() end)

local Body = Instance.new("Frame", Main)
Body.Size = UDim2.new(1, -170, 1, 0)
Body.Position = UDim2.new(0, 170, 0, 0)
Body.BackgroundTransparency = 1

local ContentHolder = Instance.new("Frame", Body)
ContentHolder.Size = UDim2.new(1, -24, 1, -24)
ContentHolder.Position = UDim2.new(0, 12, 0, 12)
ContentHolder.BackgroundTransparency = 1

local Pages = {}
local Tabs = {}
local TabLabels = {}
local CurrentTab = "speed"

local ApplyMenuColors
local RefreshTabColors
local RefreshLangBtns
local ReloadMenuTexts
local RefreshEffectButtons

ApplyMenuColors = function()
    if CFG.Theme == "Glass" then
        Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Main.BackgroundTransparency = 0.85
        MainStroke.Color = Color3.fromRGB(255, 255, 255)
        MainStroke.Transparency = 0.2
        Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Sidebar.BackgroundTransparency = 0.9
        LogoLbl.TextColor3 = Color3.fromRGB(20, 20, 20)
        LogoSub.TextColor3 = CFG.MenuAccent
        LogoDot.BackgroundColor3 = CFG.MenuAccent
        SideSep.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        CloseBtn.TextColor3 = Color3.fromRGB(220, 60, 60)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    elseif CFG.Theme == "Light" then
        Main.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        Main.BackgroundTransparency = 0
        MainStroke.Color = Color3.fromRGB(200, 200, 200)
        MainStroke.Transparency = 0
        Sidebar.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        Sidebar.BackgroundTransparency = 0
        LogoLbl.TextColor3 = Color3.fromRGB(20, 20, 20)
        LogoSub.TextColor3 = CFG.MenuAccent
        LogoDot.BackgroundColor3 = CFG.MenuAccent
        SideSep.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    else
        Main.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
        Main.BackgroundTransparency = 0.05
        MainStroke.Color = CFG.MenuAccent
        MainStroke.Transparency = 0.5
        Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Sidebar.BackgroundTransparency = 0.4
        LogoLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        LogoSub.TextColor3 = CFG.MenuAccent
        LogoDot.BackgroundColor3 = CFG.MenuAccent
        SideSep.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        CloseBtn.TextColor3 = Color3.fromRGB(255, 130, 130)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    end
    
    LogoDotGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CFG.MenuAccent),
        ColorSequenceKeypoint.new(1, CFG.MenuAccent:Lerp(Color3.new(1,1,1), 0.4)),
    })
    
    if RefreshTabColors then RefreshTabColors() end
    for _, item in ipairs(AllColorPickers) do
        item.preview.BackgroundColor3 = CFG[item.key]
    end
    if ToggleBtn then
        if CFG.Theme == "Glass" then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.BackgroundTransparency = 0.85
            ToggleBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
            if ToggleStroke then
                ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
                ToggleStroke.Transparency = 0.2
            end
        elseif CFG.Theme == "Light" then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.BackgroundTransparency = 0
            ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            if ToggleStroke then
                ToggleStroke.Color = Color3.fromRGB(200, 200, 200)
                ToggleStroke.Transparency = 0
            end
        else
            ToggleBtn.BackgroundColor3 = CFG.ToggleBtnColor
            ToggleBtn.BackgroundTransparency = 0
            ToggleBtn.TextColor3 = CFG.ToggleBtnTextColor
            if ToggleStroke then
                ToggleStroke.Color = CFG.MenuAccent
                ToggleStroke.Transparency = 0
            end
        end
    end
end

local function MakeTab(id, label, icon)
    local btn = Instance.new("TextButton", TabList)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = CFG.MenuAccent
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local iconLbl = Instance.new("TextLabel", btn)
    iconLbl.Size = UDim2.new(0, 24, 0, 24)
    iconLbl.Position = UDim2.new(0, 10, 0.5, -12)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon or "•"
    iconLbl.Font = FNM
    iconLbl.TextSize = 16
    iconLbl.TextTransparency = 0.4

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -44, 1, 0)
    lbl.Position = UDim2.new(0, 40, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = FNM
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTransparency = 0.4

    btn.MouseEnter:Connect(function()
        if CurrentTab ~= id then TS:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentTab ~= id then TS:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play() end
    end)

    btn.MouseButton1Click:Connect(function()
        CurrentTab = id
        RefreshTabColors()
        for pid, pg in pairs(Pages) do
            if pid == id then
                pg.Visible = true
                pg.Position = UDim2.new(0, 10, 0, 0)
                TS:Create(pg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            else
                pg.Visible = false
            end
        end
    end)

    Tabs[id] = btn
    TabLabels[id] = {icon = iconLbl, label = lbl}

    local page = Instance.new("ScrollingFrame", ContentHolder)
    page.Name = id
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = CFG.MenuAccent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = (id == CurrentTab)
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    Pages[id] = page
    return page
end

RefreshTabColors = function()
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    local textColor = isLight and Color3.fromRGB(20,20,20) or Color3.fromRGB(240,240,245)
    
    for tid, tbtn in pairs(Tabs) do
        local data = TabLabels[tid]
        if tid == CurrentTab then
            tbtn.BackgroundTransparency = 0.2
            tbtn.BackgroundColor3 = CFG.MenuAccent
            if data then
                data.icon.TextColor3 = Color3.new(1,1,1)
                data.icon.TextTransparency = 0
                data.label.TextColor3 = Color3.new(1,1,1)
                data.label.TextTransparency = 0
            end
        else
            tbtn.BackgroundTransparency = 1
            if data then
                data.icon.TextColor3 = textColor
                data.icon.TextTransparency = 0.4
                data.label.TextColor3 = textColor
                data.label.TextTransparency = 0.4
            end
        end
    end
end

local PageSpeed  = MakeTab("speed",  T("speed"),  "⚡")
local PageESP    = MakeTab("esp",    T("esp"),    "👁")
local PageChams  = MakeTab("chams",  T("chams"),  "🎨")
local PageEffect = MakeTab("effect", T("effects"),"✨")
local PageMenu   = MakeTab("menu",   T("menu"),   "⚙")
end
LoadCFG()
local function Section(parent, title)
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1, 0, 0, 26)
    holder.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", holder)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title:upper()
    lbl.TextColor3 = CFG.MenuAccent
    lbl.Font = FB
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return holder
end

local function Desc(parent, text)
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    local textColor = isLight and Color3.fromRGB(100,100,100) or CFG.MenuTextColor
    local d = Instance.new("TextLabel", parent)
    d.Size = UDim2.new(1, 0, 0, 18)
    d.BackgroundTransparency = 1
    d.Text = text
    d.TextColor3 = textColor
    d.TextTransparency = 0.2
    d.Font = FNM
    d.TextSize = 11
    d.TextXAlignment = Enum.TextXAlignment.Left
    return d
end

local function Check(parent, key, label)
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    local textColor = isLight and Color3.fromRGB(20,20,20) or CFG.MenuTextColor
    local bgTransparency = isLight and 0.9 or 0.95
    
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = isLight and Color3.fromRGB(255,255,255) or CFG.MenuTextColor
    btn.BackgroundTransparency = bgTransparency
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local t = Instance.new("TextLabel", btn)
    t.Size = UDim2.new(1, -60, 1, 0)
    t.Position = UDim2.new(0, 12, 0, 0)
    t.BackgroundTransparency = 1
    t.Text = label
    t.TextColor3 = textColor
    t.Font = FNM
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBg = Instance.new("Frame", btn)
    toggleBg.Size = UDim2.new(0, 34, 0, 18)
    toggleBg.Position = UDim2.new(1, -46, 0.5, -9)
    toggleBg.BackgroundColor3 = CFG[key] and CFG.MenuAccent or Color3.fromRGB(150, 150, 160)
    toggleBg.BorderSizePixel = 0
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", toggleBg)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = CFG[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    btn.MouseEnter:Connect(function() TS:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = bgTransparency - 0.05}):Play() end)
    btn.MouseLeave:Connect(function() TS:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = bgTransparency}):Play() end)

    btn.MouseButton1Click:Connect(function()
        CFG[key] = not CFG[key]
        local targetPos = CFG[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = CFG[key] and CFG.MenuAccent or Color3.fromRGB(150, 150, 160)
        TS:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TS:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        SaveCFG(true)
    end)
end

local function Slider(parent, key, label, min, max, step)
    step = step or 1
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    local textColor = isLight and Color3.fromRGB(20,20,20) or CFG.MenuTextColor
    local bgTransparency = isLight and 0.9 or 0.95

    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 54)
    frame.BackgroundColor3 = isLight and Color3.fromRGB(255,255,255) or CFG.MenuTextColor
    frame.BackgroundTransparency = bgTransparency
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -80, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = textColor
    lbl.Font = FNM
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", frame)
    valLbl.Size = UDim2.new(0, 60, 0, 20)
    valLbl.Position = UDim2.new(1, -72, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(CFG[key])
    valLbl.TextColor3 = CFG.MenuAccent
    valLbl.Font = FB
    valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local barBg = Instance.new("Frame", frame)
    barBg.Size = UDim2.new(1, -24, 0, 4)
    barBg.Position = UDim2.new(0, 12, 1, -16)
    barBg.BackgroundColor3 = isLight and Color3.fromRGB(220,220,230) or Color3.fromRGB(30, 30, 40)
    barBg.BorderSizePixel = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new((CFG[key] - min) / (max - min), 0, 1, 0)
    barFill.BackgroundColor3 = CFG.MenuAccent
    barFill.BorderSizePixel = 0
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", barBg)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((CFG[key] - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function setFromX(x)
        local rel = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = min + rel * (max - min)
        val = math.floor(val / step + 0.5) * step
        val = math.clamp(val, min, max)
        CFG[key] = val
        barFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        knob.Position = UDim2.new((val - min) / (max - min), -6, 0.5, -6)
        valLbl.Text = tostring(val)
        if key:find("Effect") then RefreshEffects() end
    end
    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            SaveCFG(true)
        end
    end)
end

local AllColorPickers = {}
local function ColorPicker(parent, key, label)
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    local textColor = isLight and Color3.fromRGB(20,20,20) or CFG.MenuTextColor
    local bgTransparency = isLight and 0.9 or 0.95

    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = isLight and Color3.fromRGB(255,255,255) or CFG.MenuTextColor
    frame.BackgroundTransparency = bgTransparency
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local t = Instance.new("TextLabel", frame)
    t.Size = UDim2.new(1, -64, 1, 0)
    t.Position = UDim2.new(0, 12, 0, 0)
    t.BackgroundTransparency = 1
    t.Text = label
    t.TextColor3 = textColor
    t.Font = FNM
    t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left

    local swatch = Instance.new("Frame", frame)
    swatch.Size = UDim2.new(0, 44, 0, 22)
    swatch.Position = UDim2.new(1, -56, 0.5, -11)
    swatch.BackgroundColor3 = CFG[key]
    swatch.BorderSizePixel = 0
    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 5)
    
    local swatchStroke = Instance.new("UIStroke", swatch)
    swatchStroke.Color = Color3.new(1,1,1)
    swatchStroke.Transparency = 0.5

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local hue = 0
    btn.MouseButton1Click:Connect(function()
        hue = (hue + 45) % 360
        CFG[key] = Color3.fromHSV(hue/360, 0.8, 1)
        swatch.BackgroundColor3 = CFG[key]
        if key == "EffectColor" then RefreshEffects() end
        if key == "MenuColor" or key == "MenuAccent" or key == "MenuTextColor" then ApplyMenuColors() end
        SaveCFG(true)
    end)
    table.insert(AllColorPickers, {key = key, preview = swatch})
end

Section(PageSpeed, T("speed"))
Check(PageSpeed, "SJ", T("speedhack"))
Slider(PageSpeed, "Speed", T("speed"), 16, 300)
Check(PageSpeed, "NoClip", T("noclip"))
Section(PageSpeed, T("camera"))
Slider(PageSpeed, "FOV", "FOV", 70, 140)
Section(PageSpeed, T("light"))
Check(PageSpeed, "FB", T("fullbright"))
Section(PageSpeed, T("aim"))
Check(PageSpeed, "Aim", T("aim_enable"))
Slider(PageSpeed, "AimFOV", T("aim_fov"), 10, 600)
Slider(PageSpeed, "AimSmooth", T("aim_smooth"), 1, 20)
Check(PageSpeed, "AimShowCircle", T("aim_circle"))

Section(PageESP, T("esp"))
Check(PageESP, "P_ESP", T("players"))
Check(PageESP, "M_ESP", T("monsters"))
Check(PageESP, "L_ESP", T("loot"))
Check(PageESP, "S_ESP", T("sellers"))
Check(PageESP, "ESP_Name", T("esp_name"))
Check(PageESP, "ESP_Dist", T("esp_dist"))
Slider(PageESP, "P_Dst", "Players dist", 50, 2000)
Slider(PageESP, "M_Dst", "Monsters dist", 50, 2000)
Slider(PageESP, "ESP_Size", T("esp_size"), 10, 300, 10)
ColorPicker(PageESP, "P_Color", "Игроки (Видим)")
ColorPicker(PageESP, "P_HiddenColor", "Игроки (Невидим)")

Section(PageChams, T("chams"))
Check(PageChams, "Chams", T("chams_enable"))
Check(PageChams, "ChamsPlayers", T("chams_players"))
Check(PageChams, "ChamsMonsters", T("chams_monsters"))
Slider(PageChams, "ChamsRange", T("chams_range"), 50, 1000)
Slider(PageChams, "ChamsTransparency", T("chams_transp"), 0, 1, 0.05)
ColorPicker(PageChams, "ChamsVisibleColor", "Chams (Видим)")
ColorPicker(PageChams, "ChamsHiddenColor", "Chams (Невидим)")

Section(PageChams, "ЦВЕТ МОНСТРОВ")
Desc(PageChams, "Применяется к именам и Chams.")
ColorPicker(PageChams, "MonsterVisibleColor", "Монстры (Видим)")
ColorPicker(PageChams, "MonsterHiddenColor", "Монстры (Невидим)")

Section(PageEffect, T("effects"))
Desc(PageEffect, T("effects_desc"))

local EffectNames = {"None", "Fireflies", "Sparks", "Rain", "Snow", "Orbits", "GroundGlow"}
local EffectButtons = {}

RefreshEffectButtons = function()
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    for name, btn in pairs(EffectButtons) do
        if name == CFG.SelectedEffect then
            btn.BackgroundColor3 = CFG.MenuAccent
            btn.BackgroundTransparency = 0.2
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = isLight and Color3.fromRGB(255,255,255) or CFG.MenuTextColor
            btn.BackgroundTransparency = isLight and 0.9 or 0.95
            btn.TextColor3 = isLight and Color3.fromRGB(20,20,20) or CFG.MenuTextColor
        end
    end
end

for _, name in ipairs(EffectNames) do
    local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
    local btn = Instance.new("TextButton", PageEffect)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = isLight and Color3.fromRGB(255,255,255) or CFG.MenuTextColor
    btn.BackgroundTransparency = isLight and 0.9 or 0.95
    btn.Text = (name == "None") and T("off") or (name .. "  ·  " .. (EffectDescriptions[name] or ""))
    btn.TextColor3 = isLight and Color3.fromRGB(20,20,20) or CFG.MenuTextColor
    btn.Font = FNM
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(function()
        CFG.SelectedEffect = name
        RefreshEffectButtons()
        RefreshEffects()
        SaveCFG(true)
    end)
    EffectButtons[name] = btn
end
RefreshEffectButtons()

Section(PageEffect, "Effect")
Slider(PageEffect, "EffectSpeed", T("eff_speed"), 0.1, 5, 0.1)
Slider(PageEffect, "EffectTransparency", T("eff_transp"), 0, 1, 0.05)
ColorPicker(PageEffect, "EffectColor", T("eff_color"))
Slider(PageEffect, "EffectSize", "Размер шаров", 0.1, 5, 0.1)
Slider(PageEffect, "EffectAmount", "Плотность", 0.5, 3, 0.5)
Check(PageEffect, "EffectRGB", "RGB режим")
Slider(PageEffect, "EffectOrbitRadius", "Радиус кольца", 1, 15, 0.5)
Check(PageEffect, "EffectOrbitGlow", "Свечение кольца")
Slider(PageEffect, "EffectGlowDistance", "Дальность свечения", 1, 20, 1)

Section(PageEffect, "ТУМАН (Настоящий)")
Check(PageEffect, "FogEnabled", "Включить туман")
ColorPicker(PageEffect, "FogColor", "Цвет тумана")
Slider(PageEffect, "FogStart", "Начало (метры)", 5, 100, 1)
Slider(PageEffect, "FogEnd", "Конец (метры)", 50, 500, 10)

Section(PageMenu, "Темы")
local themeRow = Instance.new("Frame", PageMenu)
themeRow.Size = UDim2.new(1, 0, 0, 36)
themeRow.BackgroundTransparency = 1
local themeLayout = Instance.new("UIListLayout", themeRow)
themeLayout.FillDirection = Enum.FillDirection.Horizontal
themeLayout.Padding = UDim.new(0, 6)

local themeBtns = {}
local function RefreshThemeBtns()
    for code, b in pairs(themeBtns) do
        if code == CFG.Theme then
            b.BackgroundColor3 = CFG.MenuAccent
            b.BackgroundTransparency = 0.2
            b.TextColor3 = Color3.new(1,1,1)
        else
            local isLight = CFG.Theme == "Glass" or CFG.Theme == "Light"
            b.BackgroundColor3 = isLight and Color3.fromRGB(255,255,255) or CFG.MenuTextColor
            b.BackgroundTransparency = isLight and 0.9 or 0.95
            b.TextColor3 = isLight and Color3.fromRGB(20,20,20) or CFG.MenuTextColor
        end
    end
end

for _, theme in ipairs({"Glass", "Dark", "Light"}) do
    local b = Instance.new("TextButton", themeRow)
    b.Size = UDim2.new(0, 100, 1, 0)
    b.Text = (theme == "Glass") and "Стекло" or (theme == "Dark" and "Тёмная" or "Светлая")
    b.Font = FNM
    b.TextSize = 12
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        CFG.Theme = theme
        ApplyMenuColors()
        RefreshThemeBtns()
        RefreshEffectButtons()
        SaveCFG(true)
    end)
    themeBtns[theme] = b
end
RefreshThemeBtns()

Section(PageMenu, T("menu"))
Slider(PageMenu, "MenuSizeX", T("menu_w"), 400, 1000, 10)
Slider(PageMenu, "MenuSizeY", T("menu_h"), 250, 800, 10)

Section(PageMenu, T("config"))
local saveBtn = Instance.new("TextButton", PageMenu)
saveBtn.Size = UDim2.new(1, 0, 0, 36)
saveBtn.BackgroundColor3 = CFG.MenuAccent
saveBtn.BackgroundTransparency = 0.2
saveBtn.Text = T("save")
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Font = FNM
saveBtn.TextSize = 13
saveBtn.AutoButtonColor = false
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
saveBtn.MouseButton1Click:Connect(function() SaveCFG(false) end)

local loadBtn = Instance.new("TextButton", PageMenu)
loadBtn.Size = UDim2.new(1, 0, 0, 36)
loadBtn.Text = T("load")
loadBtn.Font = FNM
loadBtn.TextSize = 13
loadBtn.AutoButtonColor = false
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 8)
loadBtn.MouseButton1Click:Connect(function()
    LoadCFG()
    if ApplyMenuColors then ApplyMenuColors() end
    if RefreshEffects then RefreshEffects() end
    Notify(T("loaded"), CFG.MenuAccent)
end)

Check(PageMenu, "ConfirmExit", T("confirm_exit"))

-- КНОПКА sAs
local ToggleBtn = Instance.new("TextButton", MenuGui)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, CFG.ToggleBtnSize, 0, CFG.ToggleBtnSize)
ToggleBtn.Position = UDim2.new(1, -100, 0.5, -CFG.ToggleBtnSize/2)
ToggleBtn.Text = T("toggle")
ToggleBtn.Font = FB
ToggleBtn.TextSize = 14
ToggleBtn.AutoButtonColor = false
ToggleBtn.Visible = true
ToggleBtn.Active = true
ToggleBtn.ZIndex = 100
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Thickness = 2

local draggingToggle = false
local dragStart = nil
local startPos = nil

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if draggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local clickStart = nil
ToggleBtn.MouseButton1Down:Connect(function() clickStart = tick() end)
ToggleBtn.MouseButton1Click:Connect(function()
    if clickStart and (tick() - clickStart) < 0.2 then
        MenuGui.Enabled = true
        Main.Visible = not Main.Visible
    end
end)

-- ЛОГИКА ВЫХОДА
local ConfirmGui = Instance.new("ScreenGui")
ConfirmGui.Name = "sAs_pop_Confirm"
ConfirmGui.ResetOnSpawn = false
ConfirmGui.IgnoreGuiInset = true
ConfirmGui.DisplayOrder = 2000
ConfirmGui.Parent = GUIPARENT
ConfirmGui.Enabled = false

local Overlay = Instance.new("Frame", ConfirmGui)
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.new(0,0,0)
Overlay.BackgroundTransparency = 0.5
Overlay.BorderSizePixel = 0

local Dialog = Instance.new("Frame", ConfirmGui)
Dialog.Size = UDim2.new(0, 360, 0, 180)
Dialog.Position = UDim2.new(0.5, -180, 0.5, -90)
Dialog.BackgroundColor3 = CFG.MenuColor
Dialog.BorderSizePixel = 0
Instance.new("UICorner", Dialog).CornerRadius = UDim.new(0, 14)
local DialogStroke = Instance.new("UIStroke", Dialog)
DialogStroke.Color = CFG.MenuAccent
DialogStroke.Thickness = 2

local DialogTitle = Instance.new("TextLabel", Dialog)
DialogTitle.Size = UDim2.new(1, -30, 0, 40)
DialogTitle.Position = UDim2.new(0, 15, 0, 15)
DialogTitle.BackgroundTransparency = 1
DialogTitle.Text = T("confirm_title")
DialogTitle.TextColor3 = CFG.MenuTextColor
DialogTitle.Font = FB
DialogTitle.TextSize = 18
DialogTitle.TextXAlignment = Enum.TextXAlignment.Left

local DialogText = Instance.new("TextLabel", Dialog)
DialogText.Size = UDim2.new(1, -30, 0, 40)
DialogText.Position = UDim2.new(0, 15, 0, 55)
DialogText.BackgroundTransparency = 1
DialogText.Text = T("confirm_text")
DialogText.TextColor3 = CFG.MenuTextColor
DialogText.TextTransparency = 0.2
DialogText.Font = FNM
DialogText.TextSize = 14
DialogText.TextWrapped = true
DialogText.TextXAlignment = Enum.TextXAlignment.Left

local YesBtn = Instance.new("TextButton", Dialog)
YesBtn.Size = UDim2.new(0, 140, 0, 40)
YesBtn.Position = UDim2.new(0, 15, 1, -55)
YesBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
YesBtn.Text = T("yes")
YesBtn.TextColor3 = Color3.new(1,1,1)
YesBtn.Font = FB
YesBtn.TextSize = 14
YesBtn.AutoButtonColor = false
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 8)

local NoBtn = Instance.new("TextButton", Dialog)
NoBtn.Size = UDim2.new(0, 140, 0, 40)
NoBtn.Position = UDim2.new(1, -155, 1, -55)
NoBtn.BackgroundColor3 = CFG.MenuColor:Lerp(Color3.new(1,1,1), 0.12)
NoBtn.Text = T("no")
NoBtn.TextColor3 = CFG.MenuTextColor
NoBtn.Font = FB
NoBtn.TextSize = 14
NoBtn.AutoButtonColor = false
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 8)

local function ShowConfirm()
    if not CFG.ConfirmExit then
        Main.Visible = false
        return
    end
    DialogTitle.Text = T("confirm_title")
    DialogText.Text = T("confirm_text")
    YesBtn.Text = T("yes")
    NoBtn.Text = T("no")
    Dialog.BackgroundColor3 = CFG.MenuColor
    DialogStroke.Color = CFG.MenuAccent
    Dialog.BackgroundTransparency = 1
    Dialog.Size = UDim2.new(0, 300, 0, 150)
    ConfirmGui.Enabled = true
    local ti = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TS:Create(Dialog, ti, {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 360, 0, 180),
    }):Play()
end

CloseBtn.MouseButton1Click:Connect(ShowConfirm)

YesBtn.MouseButton1Click:Connect(function()
    local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local t = TS:Create(Dialog, ti, {BackgroundTransparency = 1, Size = UDim2.new(0, 300, 0, 150)})
    t:Play()
    t.Completed:Connect(function()
        ConfirmGui.Enabled = false
        Main.Visible = false
    end)
end)

NoBtn.MouseButton1Click:Connect(function()
    local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local t = TS:Create(Dialog, ti, {BackgroundTransparency = 1, Size = UDim2.new(0, 300, 0, 150)})
    t:Play()
    t.Completed:Connect(function()
        ConfirmGui.Enabled = false
    end)
end)

task.spawn(function()
    while task.wait(0.3) do
        if Main.Visible then
            local newSize = UDim2.new(0, CFG.MenuSizeX, 0, CFG.MenuSizeY)
            if Main.Size ~= newSize then Main.Size = newSize end
        end
    end
end)

ApplyMenuColors()
RefreshEffects()
