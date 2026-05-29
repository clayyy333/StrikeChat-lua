local MainWindow = {}

function MainWindow.Create(CoreGui, Theme)
    local TweenService = game:GetService("TweenService")
    local CONTENT_ZINDEX = 8
    local DEFAULT_BACKGROUND_DESIGN_ID = "114828705105935"
    local IMAGE_SOURCE_OVERRIDES = {
        ["114828705105935"] = "rbxthumb://type=Asset&id=114828705105935&w=420&h=420",
        ["87212336811608"] = "rbxthumb://type=Asset&id=87212336811608&w=420&h=420",
        ["106061011904389"] = "rbxthumb://type=Asset&id=106061011904389&w=420&h=420",
        ["88694974755838"] = "rbxthumb://type=Asset&id=88694974755838&w=420&h=420"
    }

    local function getAssetImage(assetId)
        if assetId == nil then
            return IMAGE_SOURCE_OVERRIDES[DEFAULT_BACKGROUND_DESIGN_ID] or "rbxassetid://" .. DEFAULT_BACKGROUND_DESIGN_ID
        end

        local value = tostring(assetId):gsub("^%s+", ""):gsub("%s+$", "")

        if value == "" then
            return IMAGE_SOURCE_OVERRIDES[DEFAULT_BACKGROUND_DESIGN_ID] or "rbxassetid://" .. DEFAULT_BACKGROUND_DESIGN_ID
        end

        if value == "0" or value == "none" or value == "strikechat_space" then
            return nil
        end

        if IMAGE_SOURCE_OVERRIDES[value] then
            return IMAGE_SOURCE_OVERRIDES[value]
        end

        if value:match("^rbxassetid://") or value:match("^rbxasset://") or value:match("^http") then
            return value
        end

        if value:match("^%d+$") then
            return "rbxassetid://" .. value
        end

        return value
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeChat_Main"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

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
    backgroundImage.Image = getAssetImage(nil)
    backgroundImage.ScaleType = Enum.ScaleType.Crop
    backgroundImage.ImageTransparency = 0
    backgroundImage.ZIndex = 1
    backgroundImage.Parent = main

    local backgroundImageCorner = Instance.new("UICorner")
    backgroundImageCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    backgroundImageCorner.Parent = backgroundImage

    local function applyBackgroundDesign(designId)
        local image = getAssetImage(designId)

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

    content.DescendantAdded:Connect(function(item)
        if item:IsA("GuiObject") then
            item.ZIndex = math.max(item.ZIndex, CONTENT_ZINDEX)
        end
    end)

    raiseGuiContent(content)

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
        SetBackgroundDesign = applyBackgroundDesign,
        RaiseContent = function()
            raiseGuiContent(content)
        end
    }
end

return MainWindow
