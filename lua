--[[
    para usar esse Script basta mudar o link do grupo pelo link do grupo falso.
    -----------------------------------------------
    Configurações rápidas:
    - Troque o link da comunidade em COMMUNITY_LINK
    - Troque a key válida em VALID_KEY
    - Troque os ícones das abas em ICON_KEY / ICON_EXIT (rbxassetid://)
    - Callback ON_SUCCESS roda quando a key é validada com sucesso
]]


local COMMUNITY_LINK = "https://abre.ai/s68t"
local VALID_KEY = "SUA_KEY_AQ"


-- troque pelos seus próprios asset ids (apenas as abas usam ícone)
local ICON_KEY  = "rbxassetid://7733960981"   -- ícone da aba Key
local ICON_EXIT = "rbxassetid://7733964719"   -- ícone da aba Exit


local ON_SUCCESS = function()
    print("Key validada! Liberando script...")
    -- coloque aqui o script que deve rodar após a key ser aceita
end


----------------------------------------------------------------
-- PALETA DE CORES
----------------------------------------------------------------
local COLOR_BG          = Color3.fromRGB(14, 14, 16)
local COLOR_TITLEBAR    = Color3.fromRGB(20, 20, 23)
local COLOR_SIDEBAR     = Color3.fromRGB(18, 18, 21)
local COLOR_FIELD       = Color3.fromRGB(24, 24, 27)
local COLOR_WHITE       = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT        = Color3.fromRGB(230, 230, 235)
local COLOR_MUTED       = Color3.fromRGB(140, 140, 150)
local COLOR_PLACEHOLDER = Color3.fromRGB(110, 110, 120)
local COLOR_SUCCESS     = Color3.fromRGB(130, 235, 165)
local COLOR_ERROR       = Color3.fromRGB(255, 110, 110)


----------------------------------------------------------------
-- SERVIÇOS
----------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")


local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


if playerGui:FindFirstChild("KeySystemUI") then
    playerGui.KeySystemUI:Destroy()
end
if Lighting:FindFirstChild("KeySystemBlur") then
    Lighting.KeySystemBlur:Destroy()
end


----------------------------------------------------------------
-- BLUR NO FUNDO
----------------------------------------------------------------
local blur = Instance.new("BlurEffect")
blur.Name = "KeySystemBlur"
blur.Size = 22
blur.Parent = Lighting


----------------------------------------------------------------
-- SCREENGUI
----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui


----------------------------------------------------------------
-- FRAME PRINCIPAL (janela)
----------------------------------------------------------------
local MAIN_WIDTH = 440
local MAIN_HEIGHT = 278
local TITLEBAR_HEIGHT = 32
local SIDEBAR_WIDTH = 58
local CORNER_RADIUS = 8


local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = COLOR_BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui


local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
mainCorner.Parent = main


local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLOR_WHITE
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.25
mainStroke.Parent = main




----------------------------------------------------------------
-- BARRA DE TÍTULO (estilo Windows, arrastável)
----------------------------------------------------------------
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, TITLEBAR_HEIGHT)
titleBar.BackgroundColor3 = COLOR_TITLEBAR
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 3
titleBar.Parent = main


local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
titleBarCorner.Parent = titleBar


-- máscara para deixar só o topo da barra arredondado
local titleBarMask = Instance.new("Frame")
titleBarMask.Name = "Mask"
titleBarMask.Size = UDim2.new(1, 0, 0, CORNER_RADIUS)
titleBarMask.Position = UDim2.new(0, 0, 1, -CORNER_RADIUS)
titleBarMask.BackgroundColor3 = COLOR_TITLEBAR
titleBarMask.BorderSizePixel = 0
titleBarMask.ZIndex = 3
titleBarMask.Parent = titleBar


local titleBarDivider = Instance.new("Frame")
titleBarDivider.Name = "Divider"
titleBarDivider.Size = UDim2.new(1, 0, 0, 1)
titleBarDivider.Position = UDim2.new(0, 0, 1, 0)
titleBarDivider.BackgroundColor3 = COLOR_WHITE
titleBarDivider.BackgroundTransparency = 0.9
titleBarDivider.BorderSizePixel = 0
titleBarDivider.ZIndex = 3
titleBarDivider.Parent = titleBar


local windowTitle = Instance.new("TextLabel")
windowTitle.Name = "WindowTitle"
windowTitle.Size = UDim2.new(1, -100, 1, 0)
windowTitle.Position = UDim2.new(0, 14, 0, 0)
windowTitle.BackgroundTransparency = 1
windowTitle.Text = "Key System"
windowTitle.Font = Enum.Font.GothamBold
windowTitle.TextSize = 13
windowTitle.TextColor3 = COLOR_TEXT
windowTitle.TextXAlignment = Enum.TextXAlignment.Left
windowTitle.ZIndex = 4
windowTitle.Parent = titleBar


-- botões de controle da janela (minimizar / fechar)
local controls = Instance.new("Frame")
controls.Name = "Controls"
controls.Size = UDim2.new(0, 64, 1, 0)
controls.Position = UDim2.new(1, 0, 0, 0)
controls.AnchorPoint = Vector2.new(1, 0)
controls.BackgroundTransparency = 1
controls.ZIndex = 4
controls.Parent = titleBar


local controlsLayout = Instance.new("UIListLayout")
controlsLayout.FillDirection = Enum.FillDirection.Horizontal
controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
controlsLayout.Padding = UDim.new(0, 2)
controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
controlsLayout.Parent = controls


local function createWindowButton(name, text, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 32, 0, TITLEBAR_HEIGHT)
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = false
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = COLOR_MUTED
    btn.LayoutOrder = order
    btn.ZIndex = 4
    btn.Parent = controls
    return btn
end


local minimizeBtn = createWindowButton("MinimizeButton", "—", 1)
local closeBtn = createWindowButton("CloseButton", "X", 2)


minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85, TextColor3 = COLOR_WHITE}):Play()
end)
minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = COLOR_MUTED}):Play()
end)


closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(232, 17, 35), BackgroundTransparency = 0, TextColor3 = COLOR_WHITE}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = COLOR_MUTED}):Play()
end)


----------------------------------------------------------------
-- ARRASTAR JANELA PELA BARRA DE TÍTULO
----------------------------------------------------------------
local dragging = false
local dragStart, startPos


titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)


UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)


----------------------------------------------------------------
-- FUNDO ANIMADO (gradiente girando, respeitando os cantos)
----------------------------------------------------------------
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, 0, 1, -TITLEBAR_HEIGHT)
body.Position = UDim2.new(0, 0, 0, TITLEBAR_HEIGHT)
body.BackgroundTransparency = 1
body.ClipsDescendants = true
body.ZIndex = 1
body.Parent = main


local bgAnim = Instance.new("Frame")
bgAnim.Name = "AnimatedBackground"
bgAnim.Size = UDim2.new(1, 0, 1, 0)
bgAnim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgAnim.BorderSizePixel = 0
bgAnim.ZIndex = 1
bgAnim.Parent = body


local bgAnimCorner = Instance.new("UICorner")
bgAnimCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
bgAnimCorner.Parent = bgAnim


local bgAnimTopMask = Instance.new("Frame")
bgAnimTopMask.Name = "TopMask"
bgAnimTopMask.Size = UDim2.new(1, 0, 0, CORNER_RADIUS)
bgAnimTopMask.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgAnimTopMask.BorderSizePixel = 0
bgAnimTopMask.ZIndex = 1
bgAnimTopMask.Parent = bgAnim


local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 22)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(48, 48, 52)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 14)),
})
gradient.Rotation = 0
gradient.Parent = bgAnim


task.spawn(function()
    while bgAnim.Parent do
        for i = 0, 360, 1 do
            if not bgAnim.Parent then break end
            gradient.Rotation = i
            task.wait(0.03)
        end
    end
end)


----------------------------------------------------------------
-- SIDEBAR (abas verticais, com ícone)
----------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0)
sidebar.BackgroundColor3 = COLOR_SIDEBAR
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = body


local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
sidebarCorner.Parent = sidebar


-- máscara para deixar só o canto inferior arredondado (o topo encosta na barra de título)
local sidebarTopMask = Instance.new("Frame")
sidebarTopMask.Name = "TopMask"
sidebarTopMask.Size = UDim2.new(1, 0, 0, CORNER_RADIUS)
sidebarTopMask.BackgroundColor3 = COLOR_SIDEBAR
sidebarTopMask.BorderSizePixel = 0
sidebarTopMask.ZIndex = 2
sidebarTopMask.Parent = sidebar


-- máscara para corrigir o canto direito (não deve arredondar, encosta no conteúdo)
local sidebarRightMask = Instance.new("Frame")
sidebarRightMask.Name = "RightMask"
sidebarRightMask.Size = UDim2.new(0, CORNER_RADIUS, 1, 0)
sidebarRightMask.Position = UDim2.new(1, -CORNER_RADIUS, 0, 0)
sidebarRightMask.BackgroundColor3 = COLOR_SIDEBAR
sidebarRightMask.BorderSizePixel = 0
sidebarRightMask.ZIndex = 2
sidebarRightMask.Parent = sidebar


local sidebarDivider = Instance.new("Frame")
sidebarDivider.Name = "Divider"
sidebarDivider.Size = UDim2.new(0, 1, 1, -16)
sidebarDivider.Position = UDim2.new(1, 0, 0.5, 0)
sidebarDivider.AnchorPoint = Vector2.new(0, 0.5)
sidebarDivider.BackgroundColor3 = COLOR_WHITE
sidebarDivider.BackgroundTransparency = 0.92
sidebarDivider.BorderSizePixel = 0
sidebarDivider.ZIndex = 2
sidebarDivider.Parent = sidebar


-- container das abas
local tabsList = Instance.new("Frame")
tabsList.Name = "TabsList"
tabsList.Size = UDim2.new(1, -12, 0, 110)
tabsList.Position = UDim2.new(0.5, 0, 0, 18)
tabsList.AnchorPoint = Vector2.new(0.5, 0)
tabsList.BackgroundTransparency = 1
tabsList.ZIndex = 3
tabsList.Parent = sidebar


local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Vertical
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.Padding = UDim.new(0, 8)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabsList


local function createTab(name, label, icon, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundColor3 = COLOR_WHITE
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.LayoutOrder = order
    btn.ZIndex = 3
    btn.Parent = tabsList


    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn


    local icn = Instance.new("ImageLabel")
    icn.Name = "Icon"
    icn.Size = UDim2.new(0, 16, 0, 16)
    icn.Position = UDim2.new(0.5, 0, 0, 7)
    icn.AnchorPoint = Vector2.new(0.5, 0)
    icn.BackgroundTransparency = 1
    icn.Image = icon
    icn.ImageColor3 = COLOR_MUTED
    icn.ZIndex = 4
    icn.Parent = btn


    local lbl = Instance.new("TextLabel")
    lbl.Name = "Label"
    lbl.Size = UDim2.new(1, 0, 0, 12)
    lbl.Position = UDim2.new(0, 0, 0, 26)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextColor3 = COLOR_MUTED
    lbl.ZIndex = 4
    lbl.Parent = btn


    return btn, icn, lbl
end


local keyTabBtn, keyTabIcon, keyTabLabel = createTab("KeyTab", "KEY", ICON_KEY, 1)
local exitTabBtn, exitTabIcon, exitTabLabel = createTab("ExitTab", "EXIT", ICON_EXIT, 2)


local function setActiveTab(activeBtn)
    for _, entry in ipairs({
        {btn = keyTabBtn, icon = keyTabIcon, label = keyTabLabel},
        {btn = exitTabBtn, icon = exitTabIcon, label = exitTabLabel},
    }) do
        local isActive = (entry.btn == activeBtn)
        TweenService:Create(entry.btn, TweenInfo.new(0.2), {
            BackgroundTransparency = isActive and 0 or 1,
        }):Play()
        TweenService:Create(entry.icon, TweenInfo.new(0.2), {
            ImageColor3 = isActive and Color3.fromRGB(0, 0, 0) or COLOR_MUTED,
        }):Play()
        TweenService:Create(entry.label, TweenInfo.new(0.2), {
            TextColor3 = isActive and Color3.fromRGB(0, 0, 0) or COLOR_MUTED,
        }):Play()
    end
end


local function hoverTab(btn, icon, label)
    btn.MouseEnter:Connect(function()
        if icon.ImageColor3 ~= Color3.fromRGB(0, 0, 0) then
            TweenService:Create(icon, TweenInfo.new(0.15), {ImageColor3 = COLOR_TEXT}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = COLOR_TEXT}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if icon.ImageColor3 ~= Color3.fromRGB(0, 0, 0) then
            TweenService:Create(icon, TweenInfo.new(0.15), {ImageColor3 = COLOR_MUTED}):Play()
            TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = COLOR_MUTED}):Play()
        end
    end)
end


hoverTab(keyTabBtn, keyTabIcon, keyTabLabel)
hoverTab(exitTabBtn, exitTabIcon, exitTabLabel)


----------------------------------------------------------------
-- ÁREA DE CONTEÚDO (à direita da sidebar)
----------------------------------------------------------------
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, 0)
content.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 0)
content.BackgroundTransparency = 1
content.ZIndex = 2
content.Parent = body


local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 20)
contentPadding.PaddingRight = UDim.new(0, 20)
contentPadding.PaddingTop = UDim.new(0, 18)
contentPadding.PaddingBottom = UDim.new(0, 18)
contentPadding.Parent = content


-- ===== PÁGINA: KEY =====
local keyPage = Instance.new("Frame")
keyPage.Name = "KeyPage"
keyPage.Size = UDim2.new(1, 0, 1, 0)
keyPage.BackgroundTransparency = 1
keyPage.ZIndex = 2
keyPage.Parent = content


local message = Instance.new("TextLabel")
message.Name = "Message"
message.Size = UDim2.new(1, 0, 0, 34)
message.Position = UDim2.new(0, 0, 0, 0)
message.BackgroundTransparency = 1
message.Text = "Entre na comunidade do Roblox para desbloquear o script"
message.Font = Enum.Font.Gotham
message.TextSize = 12
message.TextWrapped = true
message.TextXAlignment = Enum.TextXAlignment.Left
message.TextColor3 = COLOR_MUTED
message.ZIndex = 2
message.Parent = keyPage


local keyBox = Instance.new("TextBox")
keyBox.Name = "KeyBox"
keyBox.Size = UDim2.new(1, 0, 0, 34)
keyBox.Position = UDim2.new(0, 0, 0, 42)
keyBox.BackgroundColor3 = COLOR_FIELD
keyBox.PlaceholderText = "Cole sua key aqui..."
keyBox.PlaceholderColor3 = COLOR_WHITE
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 12
keyBox.TextColor3 = COLOR_TEXT
keyBox.ClearTextOnFocus = false
keyBox.ZIndex = 2
keyBox.Parent = keyPage


local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox


local keyBoxStroke = Instance.new("UIStroke")
keyBoxStroke.Color = Color3.fromRGB(0, 0, 0)
keyBoxStroke.Transparency = 0
keyBoxStroke.Thickness = 1.5
keyBoxStroke.Parent = keyBox


local keyBoxPad = Instance.new("UIPadding")
keyBoxPad.PaddingLeft = UDim.new(0, 10)
keyBoxPad.Parent = keyBox


local buttonsRow = Instance.new("Frame")
buttonsRow.Name = "ButtonsRow"
buttonsRow.Size = UDim2.new(1, 0, 0, 34)
buttonsRow.Position = UDim2.new(0, 0, 0, 84)
buttonsRow.BackgroundTransparency = 1
buttonsRow.ZIndex = 2
buttonsRow.Parent = keyPage


local rowLayout = Instance.new("UIListLayout")
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.Padding = UDim.new(0, 8)
rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
rowLayout.Parent = buttonsRow


local getAccessBtn = Instance.new("TextButton")
getAccessBtn.Name = "GetAccessButton"
getAccessBtn.Size = UDim2.new(0.5, -4, 1, 0)
getAccessBtn.BackgroundColor3 = COLOR_WHITE
getAccessBtn.Text = "GET ACCESS"
getAccessBtn.Font = Enum.Font.GothamBold
getAccessBtn.TextSize = 11
getAccessBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
getAccessBtn.AutoButtonColor = false
getAccessBtn.LayoutOrder = 1
getAccessBtn.ZIndex = 2
getAccessBtn.Parent = buttonsRow


local getAccessCorner = Instance.new("UICorner")
getAccessCorner.CornerRadius = UDim.new(0, 8)
getAccessCorner.Parent = getAccessBtn


local loginBtn = Instance.new("TextButton")
loginBtn.Name = "LoginButton"
loginBtn.Size = UDim2.new(0.5, -4, 1, 0)
loginBtn.BackgroundColor3 = COLOR_FIELD
loginBtn.Text = "LOGIN"
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 11
loginBtn.TextColor3 = COLOR_WHITE
loginBtn.AutoButtonColor = false
loginBtn.LayoutOrder = 2
loginBtn.ZIndex = 2
loginBtn.Parent = buttonsRow


local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 8)
loginCorner.Parent = loginBtn


local loginStroke = Instance.new("UIStroke")
loginStroke.Color = Color3.fromRGB(0, 0, 0)
loginStroke.Thickness = 1.5
loginStroke.Transparency = 0
loginStroke.Parent = loginBtn


local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, 0, 0, 16)
status.Position = UDim2.new(0, 0, 0, 124)
status.BackgroundTransparency = 1
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = COLOR_ERROR
status.ZIndex = 2
status.Parent = keyPage


-- ===== PÁGINA: EXIT =====
local exitPage = Instance.new("Frame")
exitPage.Name = "ExitPage"
exitPage.Size = UDim2.new(1, 0, 1, 0)
exitPage.BackgroundTransparency = 1
exitPage.Visible = false
exitPage.ZIndex = 2
exitPage.Parent = content


local exitMessage = Instance.new("TextLabel")
exitMessage.Size = UDim2.new(1, 0, 0, 40)
exitMessage.BackgroundTransparency = 1
exitMessage.Text = "Tem certeza que deseja fechar o Key System?"
exitMessage.Font = Enum.Font.Gotham
exitMessage.TextSize = 12
exitMessage.TextWrapped = true
exitMessage.TextXAlignment = Enum.TextXAlignment.Left
exitMessage.TextColor3 = COLOR_MUTED
exitMessage.ZIndex = 2
exitMessage.Parent = exitPage


local confirmExitBtn = Instance.new("TextButton")
confirmExitBtn.Size = UDim2.new(1, 0, 0, 34)
confirmExitBtn.Position = UDim2.new(0, 0, 0, 50)
confirmExitBtn.BackgroundColor3 = COLOR_WHITE
confirmExitBtn.Text = "FECHAR"
confirmExitBtn.Font = Enum.Font.GothamBold
confirmExitBtn.TextSize = 11
confirmExitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
confirmExitBtn.AutoButtonColor = false
confirmExitBtn.ZIndex = 2
confirmExitBtn.Parent = exitPage


local confirmExitCorner = Instance.new("UICorner")
confirmExitCorner.CornerRadius = UDim.new(0, 8)
confirmExitCorner.Parent = confirmExitBtn


----------------------------------------------------------------
-- TROCA DE ABAS
----------------------------------------------------------------
local function switchTab(page, btn)
    for _, p in ipairs({keyPage, exitPage}) do
        p.Visible = (p == page)
    end
    setActiveTab(btn)
end


keyTabBtn.MouseButton1Click:Connect(function()
    switchTab(keyPage, keyTabBtn)
end)


exitTabBtn.MouseButton1Click:Connect(function()
    switchTab(exitPage, exitTabBtn)
end)


switchTab(keyPage, keyTabBtn) -- aba inicial


----------------------------------------------------------------
-- HOVER NOS BOTÕES GRANDES
----------------------------------------------------------------
local function hoverEffect(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = normalColor}):Play()
    end)
end


hoverEffect(getAccessBtn, Color3.fromRGB(220, 220, 220), COLOR_WHITE)
hoverEffect(loginBtn, Color3.fromRGB(32, 32, 36), COLOR_FIELD)
hoverEffect(confirmExitBtn, Color3.fromRGB(220, 220, 220), COLOR_WHITE)


----------------------------------------------------------------
-- FUNÇÕES DA JANELA (fechar / minimizar)
----------------------------------------------------------------
local function closeUI()
    local fadeOut = TweenService:Create(main, TweenInfo.new(0.3), {
        Size = UDim2.new(0, MAIN_WIDTH, 0, 0),
        BackgroundTransparency = 1,
    })
    fadeOut:Play()
    fadeOut.Completed:Wait()
    blur:Destroy()
    screenGui:Destroy()
end


local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    TweenService:Create(main, TweenInfo.new(0.25), {
        Size = minimized and UDim2.new(0, MAIN_WIDTH, 0, TITLEBAR_HEIGHT) or UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT),
    }):Play()
end)


closeBtn.MouseButton1Click:Connect(closeUI)
confirmExitBtn.MouseButton1Click:Connect(closeUI)


----------------------------------------------------------------
-- FUNÇÕES DOS BOTÕES DA KEY
----------------------------------------------------------------
getAccessBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(COMMUNITY_LINK)
        status.TextColor3 = COLOR_SUCCESS
        status.Text = "Link copiado para a área de transferência!"
    else
        status.TextColor3 = COLOR_ERROR
        status.Text = "Seu executor não suporta copiar links."
    end
end)


loginBtn.MouseButton1Click:Connect(function()
    local inputKey = keyBox.Text


    if inputKey == "" then
        status.TextColor3 = COLOR_ERROR
        status.Text = "Digite uma key antes de continuar."
        return
    end


    if inputKey == VALID_KEY then
        status.TextColor3 = COLOR_SUCCESS
        status.Text = "Key aceita! Carregando..."
        task.wait(0.6)
        closeUI()
        ON_SUCCESS()
    else
        status.TextColor3 = COLOR_ERROR
        status.Text = "Key inválida. Tente novamente."
    end
end)


----------------------------------------------------------------
-- ANIMAÇÃO DE ENTRADA
----------------------------------------------------------------
main.Size = UDim2.new(0, 0, 0, 0)
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT),
    BackgroundTransparency = 0,
}):Play()
