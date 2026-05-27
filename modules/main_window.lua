local MainWindow = {}

function MainWindow.Create(CoreGui, Theme)
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
    main.Parent = gui

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
    topBar.Parent = main

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -110, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "StrikeChat"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local minimize = Instance.new("TextButton")
    minimize.Name = "Minimize"
    minimize.Size = UDim2.new(0, 34, 0, 30)
    minimize.Position = UDim2.new(1, -78, 0, 8)
    minimize.BackgroundColor3 = Theme.Colors.PanelLight
    minimize.Text = "-"
    minimize.TextColor3 = Theme.Colors.Text
    minimize.Font = Theme.Font.Bold
    minimize.TextSize = 18
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
    close.Parent = topBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = close

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -24, 1, -58)
    content.Position = UDim2.new(0, 12, 0, 50)
    content.BackgroundTransparency = 1
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
    leftPanel.BorderSizePixel = 0
    leftPanel.LayoutOrder = 1
    leftPanel.Parent = content

    local leftCorner = Instance.new("UICorner")
    leftCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    leftCorner.Parent = leftPanel

    local chatPanel = Instance.new("Frame")
    chatPanel.Name = "ChatPanel"
    chatPanel.Size = UDim2.new(0.56, -7, 1, 0)
    chatPanel.BackgroundColor3 = Theme.Colors.Background
    chatPanel.BorderSizePixel = 0
    chatPanel.LayoutOrder = 2
    chatPanel.Parent = content

    local chatCorner = Instance.new("UICorner")
    chatCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    chatCorner.Parent = chatPanel

    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "RightPanel"
    rightPanel.Size = UDim2.new(0.22, -7, 1, 0)
    rightPanel.BackgroundColor3 = Theme.Colors.Background
    rightPanel.BorderSizePixel = 0
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

    return {
        Gui = gui,
        Main = main,
        LeftPanel = leftPanel,
        ChatPanel = chatPanel,
        RightPanel = rightPanel,
        CloseButton = close,
        MinimizeButton = minimize,
        MinimizedButton = minimizedButton
    }
end

return MainWindow
