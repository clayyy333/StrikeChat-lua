local ClanTableUI = {}

function ClanTableUI.Create(parent, Theme)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ClanTableUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0, 920, 0, 490)
    root.Position = UDim2.new(0.5, -460, 0.5, -245)
    root.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
    
    local backgroundImage = Instance.new("ImageLabel")
    backgroundImage.Name = "BackgroundImage"
    backgroundImage.Size = UDim2.new(1, 0, 1, 0)
    backgroundImage.Position = UDim2.new(0, 0, 0, 0)
    backgroundImage.BackgroundTransparency = 1
    backgroundImage.Image = "rbxassetid://17124418086"
    backgroundImage.ScaleType = Enum.ScaleType.Crop
    backgroundImage.ImageTransparency = 0.55
    backgroundImage.ZIndex = 0
    backgroundImage.Parent = root
    root.BorderSizePixel = 0
    root.Parent = gui

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, 12)
    rootCorner.Parent = root

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color = Color3.fromRGB(55, 55, 64)
    rootStroke.Thickness = 1
    rootStroke.Transparency = 0.2
    rootStroke.Parent = root


    local titleContainer = Instance.new("Frame")
    titleContainer.Name = "TitleContainer"
    titleContainer.Size = UDim2.new(1, -160, 0, 54)
    titleContainer.Position = UDim2.new(0, 80, 0, 18)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = root

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "TABLA DE CLANES / FAMILIAS"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = titleContainer

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -58, 0, 18)
    closeButton.BackgroundColor3 = Color3.fromRGB(120, 36, 36)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 18
    closeButton.Parent = root

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, -40, 1, -138)
    mainContainer.Position = UDim2.new(0, 20, 0, 78)
    mainContainer.BackgroundTransparency = 1
    mainContainer.BorderSizePixel = 0
    mainContainer.Parent = root

    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "LeftPanel"
    leftPanel.Size = UDim2.new(0.64, -10, 1, 0)
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

    local tableHeader = Instance.new("Frame")
    tableHeader.Name = "TableHeader"
    tableHeader.Size = UDim2.new(1, -24, 0, 34)
    tableHeader.Position = UDim2.new(0, 12, 0, 12)
    tableHeader.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
    tableHeader.BorderSizePixel = 0
    tableHeader.Parent = leftPanel

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 6)
    headerCorner.Parent = tableHeader

    local posHeader = Instance.new("TextLabel")
    posHeader.Size = UDim2.new(0, 52, 1, 0)
    posHeader.Position = UDim2.new(0, 10, 0, 0)
    posHeader.BackgroundTransparency = 1
    posHeader.Text = "POS"
    posHeader.TextColor3 = Theme.Colors.TextMuted
    posHeader.Font = Theme.Font.Bold
    posHeader.TextSize = 11
    posHeader.TextXAlignment = Enum.TextXAlignment.Left
    posHeader.Parent = tableHeader

    local nameHeader = Instance.new("TextLabel")
    nameHeader.Size = UDim2.new(0, 150, 1, 0)
    nameHeader.Position = UDim2.new(0, 64, 0, 0)
    nameHeader.BackgroundTransparency = 1
    nameHeader.Text = "CLAN/FAMILIA"
    nameHeader.TextColor3 = Theme.Colors.TextMuted
    nameHeader.Font = Theme.Font.Bold
    nameHeader.TextSize = 11
    nameHeader.TextXAlignment = Enum.TextXAlignment.Left
    nameHeader.Parent = tableHeader

    local pointsHeader = Instance.new("TextLabel")
    pointsHeader.Size = UDim2.new(0, 80, 1, 0)
    pointsHeader.Position = UDim2.new(0, 220, 0, 0)
    pointsHeader.BackgroundTransparency = 1
    pointsHeader.Text = "PUNTOS"
    pointsHeader.TextColor3 = Theme.Colors.TextMuted
    pointsHeader.Font = Theme.Font.Bold
    pointsHeader.TextSize = 11
    pointsHeader.TextXAlignment = Enum.TextXAlignment.Left
    pointsHeader.Parent = tableHeader

    local descHeader = Instance.new("TextLabel")
    descHeader.Size = UDim2.new(1, -310, 1, 0)
    descHeader.Position = UDim2.new(0, 310, 0, 0)
    descHeader.BackgroundTransparency = 1
    descHeader.Text = "DESCRIPCIÓN"
    descHeader.TextColor3 = Theme.Colors.TextMuted
    descHeader.Font = Theme.Font.Bold
    descHeader.TextSize = 11
    descHeader.TextXAlignment = Enum.TextXAlignment.Left
    descHeader.Parent = tableHeader

    local clanList = Instance.new("ScrollingFrame")
    clanList.Name = "ClanList"
    clanList.Size = UDim2.new(1, -24, 1, -62)
    clanList.Position = UDim2.new(0, 12, 0, 54)
    clanList.BackgroundTransparency = 1
    clanList.BorderSizePixel = 0
    clanList.ScrollBarThickness = 4
    clanList.CanvasSize = UDim2.new(0, 0, 0, 0)
    clanList.Parent = leftPanel

    local clanListLayout = Instance.new("UIListLayout")
    clanListLayout.Padding = UDim.new(0, 6)
    clanListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    clanListLayout.Parent = clanList

    local clanListPadding = Instance.new("UIPadding")
    clanListPadding.PaddingTop = UDim.new(0, 6)
    clanListPadding.Parent = clanList


    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "RightPanel"
    rightPanel.Size = UDim2.new(0.36, -10, 1, 28)
    rightPanel.Position = UDim2.new(0.64, 10, 0, 0)
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

    local function createClanRow(position, clan)
        local row = Instance.new("TextButton")
        row.Name = "ClanRow"
        row.Size = UDim2.new(1, 0, 0, 42)
        row.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
        row.BorderSizePixel = 0
        row.Text = ""
        row.Parent = clanList

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row

        local rowStroke = Instance.new("UIStroke")
        rowStroke.Color = Color3.fromRGB(55, 55, 64)
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.35
        rowStroke.Parent = row

        local pos = Instance.new("TextLabel")
        pos.Size = UDim2.new(0, 52, 1, 0)
        pos.Position = UDim2.new(0, 10, 0, 0)
        pos.BackgroundTransparency = 1
        pos.Text = tostring(position)
        pos.TextColor3 = Theme.Colors.Text
        pos.Font = Theme.Font.Bold
        pos.TextSize = 13
        pos.TextXAlignment = Enum.TextXAlignment.Left
        pos.Parent = row

        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(0, 150, 1, 0)
        name.Position = UDim2.new(0, 64, 0, 0)
        name.BackgroundTransparency = 1
        name.Text = tostring(clan.name or "Clan")
        name.TextColor3 = Theme.Colors.Text
        name.Font = Theme.Font.Bold
        name.TextSize = 13
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.Parent = row

        local points = Instance.new("TextLabel")
        points.Size = UDim2.new(0, 80, 1, 0)
        points.Position = UDim2.new(0, 220, 0, 0)
        points.BackgroundTransparency = 1
        points.Text = tostring(clan.total_points_earned or 0)
        points.TextColor3 = Theme.Colors.TextMuted
        points.Font = Theme.Font.Bold
        points.TextSize = 12
        points.TextXAlignment = Enum.TextXAlignment.Left
        points.Parent = row

        local description = Instance.new("TextLabel")
        description.Size = UDim2.new(1, -310, 1, 0)
        description.Position = UDim2.new(0, 310, 0, 0)
        description.BackgroundTransparency = 1
        description.Text = tostring(clan.description or "")
        description.TextColor3 = Theme.Colors.TextMuted
        description.Font = Theme.Font.Regular
        description.TextSize = 11
        description.TextXAlignment = Enum.TextXAlignment.Left
        description.TextTruncate = Enum.TextTruncate.AtEnd
        description.Parent = row

        return row
    end

    createClanRow(1, {
        name = "Evil Geniuses",
        total_points_earned = 15240,
        description = "Clan competitivo enfocado en guerras y eventos."
    })

    createClanRow(2, {
        name = "Shadow Legacy",
        total_points_earned = 12890,
        description = "Reclutando jugadores activos diariamente."
    })

    createClanRow(3, {
        name = "Night Hunters",
        total_points_earned = 11020,
        description = "Dominando la tabla desde la temporada pasada."
    })

    clanList.CanvasSize = UDim2.new(
        0,
        0,
        0,
        clanListLayout.AbsoluteContentSize.Y + 12
    )



    local footer = Instance.new("Frame")
    footer.Name = "Footer"
    footer.Size = UDim2.new(0.64, -38, 0, 28)
    footer.Position = UDim2.new(0, 20, 1, -38)
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

        LeftPanel = leftPanel,
        RightPanel = rightPanel,

        Footer = footer,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ClanTableUI