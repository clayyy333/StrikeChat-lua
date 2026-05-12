local ClanTableUI = {}

function ClanTableUI.Create(parent, Theme)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ClanTableUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(1, 0, 1, 0)
    root.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
    root.BorderSizePixel = 0
    root.Parent = gui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 0, 54)
    title.Position = UDim2.new(0, 64, 0, 18)
    title.BackgroundTransparency = 1
    title.Text = "TABLA DE CLANES"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 28
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = root

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 52, 0, 52)
    closeButton.Position = UDim2.new(1, -72, 0, 18)
    closeButton.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 26
    closeButton.Parent = root

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, -40, 1, -150)
    mainContainer.Position = UDim2.new(0, 20, 0, 88)
    mainContainer.BackgroundTransparency = 1
    mainContainer.BorderSizePixel = 0
    mainContainer.Parent = root

    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "LeftPanel"
    leftPanel.Size = UDim2.new(0.56, -8, 1, 0)
    leftPanel.Position = UDim2.new(0, 0, 0, 0)
    leftPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    leftPanel.BorderSizePixel = 0
    leftPanel.Parent = mainContainer

    local leftCorner = Instance.new("UICorner")
    leftCorner.CornerRadius = UDim.new(0, 8)
    leftCorner.Parent = leftPanel

    local leftStroke = Instance.new("UIStroke")
    leftStroke.Color = Color3.fromRGB(75, 75, 82)
    leftStroke.Thickness = 1
    leftStroke.Transparency = 0.15
    leftStroke.Parent = leftPanel

    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "RightPanel"
    rightPanel.Size = UDim2.new(0.44, -8, 1, 0)
    rightPanel.Position = UDim2.new(0.56, 8, 0, 0)
    rightPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    rightPanel.BorderSizePixel = 0
    rightPanel.Parent = mainContainer

    local rightCorner = Instance.new("UICorner")
    rightCorner.CornerRadius = UDim.new(0, 8)
    rightCorner.Parent = rightPanel

    local rightStroke = Instance.new("UIStroke")
    rightStroke.Color = Color3.fromRGB(75, 75, 82)
    rightStroke.Thickness = 1
    rightStroke.Transparency = 0.15
    rightStroke.Parent = rightPanel

    local footer = Instance.new("Frame")
    footer.Name = "Footer"
    footer.Size = UDim2.new(1, -40, 0, 64)
    footer.Position = UDim2.new(0, 20, 1, -76)
    footer.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    footer.BorderSizePixel = 0
    footer.Parent = root

    local footerCorner = Instance.new("UICorner")
    footerCorner.CornerRadius = UDim.new(0, 8)
    footerCorner.Parent = footer

    local footerStroke = Instance.new("UIStroke")
    footerStroke.Color = Color3.fromRGB(55, 55, 64)
    footerStroke.Thickness = 1
    footerStroke.Transparency = 0.25
    footerStroke.Parent = footer

    local footerText = Instance.new("TextLabel")
    footerText.Name = "FooterText"
    footerText.Size = UDim2.new(1, -24, 1, 0)
    footerText.Position = UDim2.new(0, 12, 0, 0)
    footerText.BackgroundTransparency = 1
    footerText.Text = "Los clanes se actualizan automáticamente. Juega, suma puntos y lleva a tu clan a la cima."
    footerText.TextColor3 = Theme.Colors.TextMuted
    footerText.Font = Theme.Font.Regular
    footerText.TextSize = 13
    footerText.TextXAlignment = Enum.TextXAlignment.Left
    footerText.TextWrapped = true
    footerText.Parent = footer

    return {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        LeftPanel = leftPanel,
        RightPanel = rightPanel,
        Footer = footer,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ClanTableUI