local MainWindow = {}

function MainWindow.ChooseLayout(CoreGui, Theme, I18n)
    local TweenService = game:GetService("TweenService")
    local LocalizationService = game:GetService("LocalizationService")
    local selectedEvent = Instance.new("BindableEvent")
    local selectedMode = nil

    local function isEnglishRoblox()
        local locale = ""

        pcall(function()
            locale = tostring(LocalizationService.RobloxLocaleId or "")
        end)

        return locale:lower():sub(1, 2) == "en"
    end

    local titleText = "Elige una opcion para una mejor Experiencia :"

    if isEnglishRoblox() then
        titleText = "Choose an option for a better Experience :"
    elseif I18n and I18n.TranslateText then
        titleText = I18n.TranslateText(titleText)
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeChat_LayoutChoice"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9998
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    overlay.BackgroundTransparency = 0.28
    overlay.BorderSizePixel = 0
    overlay.Parent = gui

    local panel = Instance.new("Frame")
    panel.Name = "ChoicePanel"
    panel.Size = UDim2.new(0.92, 0, 0, 186)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Theme.Colors.Panel
    panel.BackgroundTransparency = 0
    panel.BorderSizePixel = 0
    panel.ZIndex = 5
    panel.Parent = overlay

    local panelScale = Instance.new("UIScale")
    panelScale.Scale = 1.22
    panelScale.Parent = panel

    local panelSize = Instance.new("UISizeConstraint")
    panelSize.MaxSize = Vector2.new(430, 186)
    panelSize.MinSize = Vector2.new(300, 170)
    panelSize.Parent = panel

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    panelCorner.Parent = panel

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Theme.Colors.Border
    panelStroke.Thickness = 1.4
    panelStroke.Transparency = 0.25
    panelStroke.Parent = panel

    local betaLabel = Instance.new("TextLabel")
    betaLabel.Name = "BetaLabel"
    betaLabel.Size = UDim2.new(0, 180, 0, 18)
    betaLabel.Position = UDim2.new(0, 12, 0, 6)
    betaLabel.BackgroundTransparency = 1
    betaLabel.Text = "Pre Lanzamiento Beta 1.0v"
    betaLabel.TextColor3 = Theme.Colors.TextMuted
    betaLabel.TextTransparency = 0.05
    betaLabel.Font = Theme.Font.Bold
    betaLabel.TextSize = 10
    betaLabel.TextXAlignment = Enum.TextXAlignment.Left
    betaLabel.TextYAlignment = Enum.TextYAlignment.Center
    betaLabel.ZIndex = 6
    betaLabel.Parent = panel

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -34, 0, 52)
    title.Position = UDim2.new(0, 17, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Theme.Colors.Text
    title.TextTransparency = 1
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextScaled = true
    title.TextWrapped = true
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 6
    title.Parent = panel

    local titleTextSize = Instance.new("UITextSizeConstraint")
    titleTextSize.MinTextSize = 11
    titleTextSize.MaxTextSize = 16
    titleTextSize.Parent = title

    local function createChoiceButton(name, text, position, mode)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0.5, -24, 0, 46)
        button.Position = position
        button.BackgroundColor3 = Theme.Colors.PanelLight
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Theme.Colors.Text
        button.TextTransparency = 1
        button.Font = Theme.Font.Bold
        button.TextSize = 13
        button.TextScaled = true
        button.ZIndex = 6
        button.Parent = panel

        local buttonTextSize = Instance.new("UITextSizeConstraint")
        buttonTextSize.MinTextSize = 9
        buttonTextSize.MaxTextSize = 13
        buttonTextSize.Parent = button

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        corner.Parent = button

        button.MouseButton1Click:Connect(function()
            if selectedMode then
                return
            end

            selectedMode = mode
            _G.StrikeChatLayoutMode = mode

            TweenService:Create(panelScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Scale = 0.94
            }):Play()

            TweenService:Create(overlay, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()

            task.wait(0.2)
            selectedEvent:Fire(mode)
        end)

        return button
    end

    local pcButton = createChoiceButton(
        "PCEmulatorButton",
        "PC/Emulator",
        UDim2.new(0, 18, 1, -66),
        "pc"
    )

    local mobileButton = createChoiceButton(
        "MobileButton",
        "Mobile(Celulares/Tablet)",
        UDim2.new(0.5, 6, 1, -66),
        "mobile"
    )

    TweenService:Create(panelScale, TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    task.delay(0.08, function()
        if not panel.Parent then
            return
        end

        TweenService:Create(title, TweenInfo.new(0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()

        TweenService:Create(pcButton, TweenInfo.new(0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            TextTransparency = 0
        }):Play()

        TweenService:Create(mobileButton, TweenInfo.new(0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            TextTransparency = 0
        }):Play()
    end)

    local mode = selectedEvent.Event:Wait()

    if gui.Parent then
        gui:Destroy()
    end

    selectedEvent:Destroy()

    return mode
end

function MainWindow.Create(CoreGui, Theme, layoutMode)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CONTENT_ZINDEX = 8
    local DEFAULT_BACKGROUND_DESIGN_ID = "114828705105935"
    local resolvedImageCache = {}

    if layoutMode == "mobile" or layoutMode == "pc" then
        _G.StrikeChatLayoutMode = layoutMode
    end

    local function getViewportSize()
        local camera = workspace.CurrentCamera

        if camera then
            return camera.ViewportSize
        end

        return Vector2.new(1280, 720)
    end

    local function isMobileLandscape()
        if _G.StrikeChatLayoutMode == "mobile" then
            return true
        end

        if _G.StrikeChatLayoutMode == "pc" then
            return false
        end

        local viewport = getViewportSize()
        local shortSide = math.min(viewport.X, viewport.Y)
        local longSide = math.max(viewport.X, viewport.Y)

        return UserInputService.TouchEnabled
            and viewport.X > viewport.Y
            and shortSide <= 650
            and longSide <= 1400
    end

    local function getAssetImage(assetId)
        if assetId == nil then
            return "rbxassetid://" .. DEFAULT_BACKGROUND_DESIGN_ID
        end

        local value = tostring(assetId):gsub("^%s+", ""):gsub("%s+$", "")

        if value == "" then
            return "rbxassetid://" .. DEFAULT_BACKGROUND_DESIGN_ID
        end

        if value == "0" or value == "none" or value == "strikechat_space" then
            return nil
        end

        if value:match("^rbxassetid://") or value:match("^rbxasset://") or value:match("^http") then
            return value
        end

        if value:match("^%d+$") then
            return "rbxassetid://" .. value
        end

        return value
    end

    local function resolveImageAsset(assetId)
        local fallbackImage = getAssetImage(assetId)

        if assetId == nil then
            assetId = DEFAULT_BACKGROUND_DESIGN_ID
        end

        local value = tostring(assetId):gsub("^%s+", ""):gsub("%s+$", "")

        if value == "" then
            value = DEFAULT_BACKGROUND_DESIGN_ID
        end

        if not value:match("^%d+$") then
            return fallbackImage
        end

        if resolvedImageCache[value] then
            return resolvedImageCache[value]
        end

        local resolvedImage = nil
        local success, objects = pcall(function()
            return game:GetObjects("rbxassetid://" .. value)
        end)

        if success and objects then
            for _, object in ipairs(objects) do
                if object:IsA("Decal") or object:IsA("Texture") then
                    if object.Texture and object.Texture ~= "" then
                        resolvedImage = object.Texture
                        break
                    end
                elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    if object.Image and object.Image ~= "" then
                        resolvedImage = object.Image
                        break
                    end
                end

                for _, descendant in ipairs(object:GetDescendants()) do
                    if descendant:IsA("Decal") or descendant:IsA("Texture") then
                        if descendant.Texture and descendant.Texture ~= "" then
                            resolvedImage = descendant.Texture
                            break
                        end
                    elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                        if descendant.Image and descendant.Image ~= "" then
                            resolvedImage = descendant.Image
                            break
                        end
                    end
                end

                if resolvedImage then
                    break
                end
            end

            for _, object in ipairs(objects) do
                pcall(function()
                    object:Destroy()
                end)
            end
        end

        resolvedImageCache[value] = resolvedImage or fallbackImage

        return resolvedImageCache[value]
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeChat_Main"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = _G.StrikeChatLayoutMode == "mobile"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    local function applyScreenBoundsMode(useFullBounds)
        gui.IgnoreGuiInset = useFullBounds

        if not useFullBounds then
            return
        end

        pcall(function()
            gui.ScreenInsets = Enum.ScreenInsets.None
        end)

        pcall(function()
            gui.ClipToDeviceSafeArea = false
        end)
    end

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0.86, 0, 0.86, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Theme.Colors.Panel
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui

    local backgroundImage = Instance.new("ImageLabel")
    backgroundImage.Name = "MainBackgroundImage"
    backgroundImage.Size = UDim2.new(1, 0, 1, 0)
    backgroundImage.Position = UDim2.new(0, 0, 0, 0)
    backgroundImage.BackgroundTransparency = 1
    backgroundImage.Image = resolveImageAsset(nil)
    backgroundImage.ScaleType = Enum.ScaleType.Crop
    backgroundImage.ImageTransparency = 0
    backgroundImage.ZIndex = 1
    backgroundImage.Parent = main

    local backgroundImageCorner = Instance.new("UICorner")
    backgroundImageCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    backgroundImageCorner.Parent = backgroundImage

    local function applyBackgroundDesign(designId)
        local image = resolveImageAsset(designId)

        if image then
            backgroundImage.Image = image
            backgroundImage.ImageTransparency = 0
            backgroundImage.Visible = true
        else
            backgroundImage.Image = ""
            backgroundImage.Visible = false
        end
    end

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    mainCorner.Parent = main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.Colors.Border
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.25
    mainStroke.Parent = main

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 46)
    topBar.BackgroundTransparency = 1
    topBar.ZIndex = 2
    topBar.Parent = main

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -110, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "StrikeChat"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Theme.Font.Bold
    title.TextSize = 18
    title.TextTransparency = 0
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.ZIndex = 3
    title.Parent = topBar

    local titleGradients = {
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 6, 235)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 70, 190)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 142, 245))
        }),
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 190)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(74, 142, 245)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 6, 235))
        }),
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 142, 245)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168, 6, 235)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 190))
        })
    }

    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = titleGradients[1]
    titleGradient.Rotation = 0
    titleGradient.Parent = title

    task.spawn(function()
        local gradientIndex = 1

        while title.Parent do
            TweenService:Create(
                title,
                TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {
                    TextTransparency = 0.18
                }
            ):Play()

            task.wait(2.2)

            gradientIndex = (gradientIndex % #titleGradients) + 1
            titleGradient.Color = titleGradients[gradientIndex]

            TweenService:Create(
                title,
                TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {
                    TextTransparency = 0
                }
            ):Play()

            task.wait(2.2)
        end
    end)

    local minimize = Instance.new("TextButton")
    minimize.Name = "Minimize"
    minimize.Size = UDim2.new(0, 34, 0, 30)
    minimize.Position = UDim2.new(1, -78, 0, 8)
    minimize.BackgroundColor3 = Theme.Colors.PanelLight
    minimize.Text = "-"
    minimize.TextColor3 = Theme.Colors.Text
    minimize.Font = Theme.Font.Bold
    minimize.TextSize = 18
    minimize.ZIndex = 3
    minimize.Parent = topBar

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    minCorner.Parent = minimize

    local close = Instance.new("TextButton")
    close.Name = "Close"
    close.Size = UDim2.new(0, 34, 0, 30)
    close.Position = UDim2.new(1, -40, 0, 8)
    close.BackgroundColor3 = Theme.Colors.PanelLight
    close.Text = "X"
    close.TextColor3 = Theme.Colors.Danger
    close.Font = Theme.Font.Bold
    close.TextSize = 15
    close.ZIndex = 3
    close.Parent = topBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = close

    local musicPlayer = Instance.new("Frame")
    musicPlayer.Name = "StrikeMusicTopPlayer"
    musicPlayer.Size = UDim2.new(0.46, 0, 0, 34)
    musicPlayer.Position = UDim2.new(0.5, 0, 0, 6)
    musicPlayer.AnchorPoint = Vector2.new(0.5, 0)
    musicPlayer.BackgroundColor3 = Theme.Colors.Background
    musicPlayer.BackgroundTransparency = 0.12
    musicPlayer.BorderSizePixel = 0
    musicPlayer.Visible = false
    musicPlayer.ZIndex = 4
    musicPlayer.Parent = topBar

    local musicPlayerCorner = Instance.new("UICorner")
    musicPlayerCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    musicPlayerCorner.Parent = musicPlayer

    local musicPlayerStroke = Instance.new("UIStroke")
    musicPlayerStroke.Color = Theme.Colors.Border
    musicPlayerStroke.Thickness = 1
    musicPlayerStroke.Transparency = 0.45
    musicPlayerStroke.Parent = musicPlayer

    local miniTitle = Instance.new("TextLabel")
    miniTitle.Name = "Title"
    miniTitle.Size = UDim2.new(0.34, 0, 0, 17)
    miniTitle.Position = UDim2.new(0, 12, 0, 3)
    miniTitle.BackgroundTransparency = 1
    miniTitle.Text = "StrikeMusic"
    miniTitle.TextColor3 = Theme.Colors.Text
    miniTitle.Font = Theme.Font.Bold
    miniTitle.TextSize = 11
    miniTitle.TextXAlignment = Enum.TextXAlignment.Left
    miniTitle.TextTruncate = Enum.TextTruncate.AtEnd
    miniTitle.ZIndex = 5
    miniTitle.Parent = musicPlayer

    local miniArtist = Instance.new("TextLabel")
    miniArtist.Name = "Artist"
    miniArtist.Size = UDim2.new(0.34, 0, 0, 13)
    miniArtist.Position = UDim2.new(0, 12, 0, 18)
    miniArtist.BackgroundTransparency = 1
    miniArtist.Text = ""
    miniArtist.TextColor3 = Theme.Colors.TextMuted
    miniArtist.Font = Theme.Font.Regular
    miniArtist.TextSize = 9
    miniArtist.TextXAlignment = Enum.TextXAlignment.Left
    miniArtist.TextTruncate = Enum.TextTruncate.AtEnd
    miniArtist.ZIndex = 5
    miniArtist.Parent = musicPlayer

    local function createMiniButton(name, text, position)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 28, 0, 28)
        button.Position = position
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Theme.Colors.Text
        button.Font = Theme.Font.Bold
        button.TextSize = 13
        button.ZIndex = 5
        button.Parent = musicPlayer
        return button
    end

    local miniPrevious = createMiniButton("PreviousButton", "|<", UDim2.new(0.42, -42, 0.5, -14))
    local miniPlay = createMiniButton("PlayButton", ">", UDim2.new(0.5, -14, 0.5, -14))
    local miniNext = createMiniButton("NextButton", ">|", UDim2.new(0.58, 14, 0.5, -14))
    miniPlay.BackgroundColor3 = Theme.Colors.Accent
    miniPlay.BackgroundTransparency = 0

    local miniPlayCorner = Instance.new("UICorner")
    miniPlayCorner.CornerRadius = UDim.new(1, 0)
    miniPlayCorner.Parent = miniPlay

    local miniProgressBack = Instance.new("Frame")
    miniProgressBack.Name = "ProgressBack"
    miniProgressBack.Size = UDim2.new(0.24, 0, 0, 3)
    miniProgressBack.Position = UDim2.new(0.72, 0, 0.5, -1)
    miniProgressBack.BackgroundColor3 = Theme.Colors.Border
    miniProgressBack.BackgroundTransparency = 0.25
    miniProgressBack.BorderSizePixel = 0
    miniProgressBack.ZIndex = 5
    miniProgressBack.Parent = musicPlayer

    local miniProgressBackCorner = Instance.new("UICorner")
    miniProgressBackCorner.CornerRadius = UDim.new(1, 0)
    miniProgressBackCorner.Parent = miniProgressBack

    local miniProgressFill = Instance.new("Frame")
    miniProgressFill.Name = "ProgressFill"
    miniProgressFill.Size = UDim2.new(0, 0, 1, 0)
    miniProgressFill.BackgroundColor3 = Theme.Colors.Accent
    miniProgressFill.BorderSizePixel = 0
    miniProgressFill.ZIndex = 6
    miniProgressFill.Parent = miniProgressBack

    local miniProgressFillCorner = Instance.new("UICorner")
    miniProgressFillCorner.CornerRadius = UDim.new(1, 0)
    miniProgressFillCorner.Parent = miniProgressFill

    local musicPlayerApi = {
        Frame = musicPlayer,
        PreviousButton = miniPrevious,
        PlayButton = miniPlay,
        NextButton = miniNext,
        SetVisible = function(visible)
            musicPlayer.Visible = visible == true
        end,
        SetPlaybackState = function(isPlaying)
            miniPlay.Text = isPlaying and "||" or ">"
        end,
        SetNowPlaying = function(item, progress)
            if item then
                miniTitle.Text = tostring(item.title or "StrikeMusic")
                miniArtist.Text = tostring(item.artist or "")
                musicPlayer.Visible = true
            else
                miniTitle.Text = "StrikeMusic"
                miniArtist.Text = ""
                musicPlayer.Visible = false
            end

            miniProgressFill.Size = UDim2.new(math.clamp(tonumber(progress) or 0, 0, 1), 0, 1, 0)
        end
    }

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -24, 1, -58)
    content.Position = UDim2.new(0, 12, 0, 50)
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "LeftPanel"
    leftPanel.Size = UDim2.new(0.22, -7, 1, 0)
    leftPanel.BackgroundColor3 = Theme.Colors.Background
    leftPanel.BackgroundTransparency = 0.16
    leftPanel.BorderSizePixel = 0
    leftPanel.ZIndex = 2
    leftPanel.LayoutOrder = 1
    leftPanel.Parent = content

    local leftCorner = Instance.new("UICorner")
    leftCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    leftCorner.Parent = leftPanel

    local chatPanel = Instance.new("Frame")
    chatPanel.Name = "ChatPanel"
    chatPanel.Size = UDim2.new(0.56, -7, 1, 0)
    chatPanel.BackgroundColor3 = Theme.Colors.Background
    chatPanel.BackgroundTransparency = 0.16
    chatPanel.BorderSizePixel = 0
    chatPanel.ZIndex = 2
    chatPanel.LayoutOrder = 2
    chatPanel.Parent = content

    local chatCorner = Instance.new("UICorner")
    chatCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    chatCorner.Parent = chatPanel

    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "RightPanel"
    rightPanel.Size = UDim2.new(0.22, -7, 1, 0)
    rightPanel.BackgroundColor3 = Theme.Colors.Background
    rightPanel.BackgroundTransparency = 0
    rightPanel.BorderSizePixel = 0
    rightPanel.ZIndex = 2
    rightPanel.LayoutOrder = 3
    rightPanel.Parent = content

    local rightCorner = Instance.new("UICorner")
    rightCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    rightCorner.Parent = rightPanel

    local function applyResponsiveLayout()
        if isMobileLandscape() then
            applyScreenBoundsMode(true)
            main.Size = UDim2.new(1, 0, 1, -64)
            main.Position = UDim2.new(0, 0, 1, 0)
            main.AnchorPoint = Vector2.new(0, 1)

            topBar.Size = UDim2.new(1, 0, 0, 42)
            title.Size = UDim2.new(1, -100, 1, 0)
            title.Position = UDim2.new(0, 14, 0, 0)
            title.TextSize = 16
            minimize.Size = UDim2.new(0, 34, 0, 28)
            minimize.Position = UDim2.new(1, -78, 0, 7)
            close.Size = UDim2.new(0, 34, 0, 28)
            close.Position = UDim2.new(1, -40, 0, 7)
            musicPlayer.Size = UDim2.new(0.46, 0, 0, 32)
            musicPlayer.Position = UDim2.new(0.5, 0, 0, 5)
            miniTitle.Size = UDim2.new(0.3, 0, 0, 16)
            miniArtist.Size = UDim2.new(0.3, 0, 0, 12)
            miniProgressBack.Size = UDim2.new(0.2, 0, 0, 3)
            miniProgressBack.Position = UDim2.new(0.76, 0, 0.5, -1)

            content.Size = UDim2.new(1, 0, 1, -50)
            content.Position = UDim2.new(0, 0, 0, 44)
            layout.Padding = UDim.new(0, 6)
            leftPanel.Size = UDim2.new(0.26, -4, 1, 0)
            chatPanel.Size = UDim2.new(0.48, -4, 1, 0)
            rightPanel.Size = UDim2.new(0.26, -4, 1, 0)
        else
            applyScreenBoundsMode(false)
            main.Size = UDim2.new(0.86, 0, 0.86, 0)
            main.Position = UDim2.new(0.5, 0, 0.5, 0)
            main.AnchorPoint = Vector2.new(0.5, 0.5)

            topBar.Size = UDim2.new(1, 0, 0, 46)
            title.Size = UDim2.new(1, -110, 1, 0)
            title.Position = UDim2.new(0, 16, 0, 0)
            title.TextSize = 18
            minimize.Size = UDim2.new(0, 34, 0, 30)
            minimize.Position = UDim2.new(1, -78, 0, 8)
            close.Size = UDim2.new(0, 34, 0, 30)
            close.Position = UDim2.new(1, -40, 0, 8)
            musicPlayer.Size = UDim2.new(0.46, 0, 0, 34)
            musicPlayer.Position = UDim2.new(0.5, 0, 0, 6)
            miniTitle.Size = UDim2.new(0.34, 0, 0, 17)
            miniArtist.Size = UDim2.new(0.34, 0, 0, 13)
            miniProgressBack.Size = UDim2.new(0.24, 0, 0, 3)
            miniProgressBack.Position = UDim2.new(0.72, 0, 0.5, -1)

            content.Size = UDim2.new(1, -24, 1, -58)
            content.Position = UDim2.new(0, 12, 0, 50)
            layout.Padding = UDim.new(0, 10)
            leftPanel.Size = UDim2.new(0.22, -7, 1, 0)
            chatPanel.Size = UDim2.new(0.56, -7, 1, 0)
            rightPanel.Size = UDim2.new(0.22, -7, 1, 0)
        end
    end

    applyResponsiveLayout()

    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveLayout)
    end

    local minimizedButton = Instance.new("TextButton")
    minimizedButton.Name = "MinimizedButton"
    minimizedButton.Size = UDim2.new(0, 58, 0, 58)
    minimizedButton.Position = UDim2.new(0, 18, 0.5, -29)
    minimizedButton.BackgroundColor3 = Theme.Colors.SoftBlack
    minimizedButton.Text = "SC"
    minimizedButton.TextColor3 = Theme.Colors.Text
    minimizedButton.Font = Theme.Font.Bold
    minimizedButton.TextSize = 18
    minimizedButton.Visible = false
    minimizedButton.Parent = gui

    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 16)
    miniCorner.Parent = minimizedButton

    local miniStroke = Instance.new("UIStroke")
    miniStroke.Color = Theme.Colors.Accent
    miniStroke.Thickness = 1.2
    miniStroke.Transparency = 0.3
    miniStroke.Parent = minimizedButton

    minimize.MouseButton1Click:Connect(function()
        main.Visible = false
        minimizedButton.Visible = true
    end)

    minimizedButton.MouseButton1Click:Connect(function()
        minimizedButton.Visible = false
        main.Visible = true
    end)

    local function raiseGuiContent(root)
        for _, item in ipairs(root:GetDescendants()) do
            if item:IsA("GuiObject") then
                item.ZIndex = math.max(item.ZIndex, CONTENT_ZINDEX)
            end
        end
    end

    local function playOpeningReveal()
        local revealZIndex = CONTENT_ZINDEX + 20

        local leftReveal = Instance.new("Frame")
        leftReveal.Name = "LeftOpeningReveal"
        leftReveal.Size = UDim2.new(0.5, 1, 1, 0)
        leftReveal.Position = UDim2.new(0, 0, 0, 0)
        leftReveal.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        leftReveal.BorderSizePixel = 0
        leftReveal.ZIndex = revealZIndex
        leftReveal.Parent = main

        local leftGradient = Instance.new("UIGradient")
        leftGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 22, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(54, 38, 78))
        })
        leftGradient.Rotation = 0
        leftGradient.Parent = leftReveal

        local rightReveal = Instance.new("Frame")
        rightReveal.Name = "RightOpeningReveal"
        rightReveal.Size = UDim2.new(0.5, 1, 1, 0)
        rightReveal.Position = UDim2.new(0.5, -1, 0, 0)
        rightReveal.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        rightReveal.BorderSizePixel = 0
        rightReveal.ZIndex = revealZIndex
        rightReveal.Parent = main

        local rightGradient = Instance.new("UIGradient")
        rightGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(54, 38, 78)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 22, 36))
        })
        rightGradient.Rotation = 0
        rightGradient.Parent = rightReveal

        local tweenInfo = TweenInfo.new(
            0.62,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        )

        task.delay(0.08, function()
            if not main.Parent then
                return
            end

            TweenService:Create(leftReveal, tweenInfo, {
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()

            TweenService:Create(rightReveal, tweenInfo, {
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()

            task.delay(0.7, function()
                if leftReveal.Parent then
                    leftReveal:Destroy()
                end

                if rightReveal.Parent then
                    rightReveal:Destroy()
                end
            end)
        end)
    end

    content.DescendantAdded:Connect(function(item)
        if item:IsA("GuiObject") then
            item.ZIndex = math.max(item.ZIndex, CONTENT_ZINDEX)
        end
    end)

    raiseGuiContent(content)
    playOpeningReveal()

    return {
        Gui = gui,
        Main = main,
        Content = content,
        LeftPanel = leftPanel,
        ChatPanel = chatPanel,
        RightPanel = rightPanel,
        CloseButton = close,
        MinimizeButton = minimize,
        MinimizedButton = minimizedButton,
        MusicPlayer = musicPlayerApi,
        SetBackgroundDesign = applyBackgroundDesign,
        RaiseContent = function()
            raiseGuiContent(content)
        end
    }
end

return MainWindow
