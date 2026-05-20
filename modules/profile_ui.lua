local ProfileUI = {}

function ProfileUI.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")

    profile = profile or {}

    local original = {
        display_name = tostring(profile.display_name or player.DisplayName),
        bio = tostring(profile.bio or ""),
        game_status_visibility = tostring(profile.game_status_visibility or "public")
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "ProfileUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0.74, 0, 0.76, 0)
    root.Position = UDim2.new(0.5, 0, 0.52, 0)
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.BackgroundColor3 = Theme.Colors.Panel
    root.BorderSizePixel = 0
    root.Parent = gui

    local rootSize = Instance.new("UISizeConstraint")
    rootSize.MinSize = Vector2.new(310, 430)
    rootSize.MaxSize = Vector2.new(520, 580)
    rootSize.Parent = root

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    rootCorner.Parent = root

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color = Color3.fromRGB(31, 74, 93)
    rootStroke.Thickness = 1
    rootStroke.Transparency = 0.18
    rootStroke.Parent = root

    local rootGradient = Instance.new("UIGradient")
    rootGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 19, 29)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 20, 32))
    })
    rootGradient.Rotation = 90
    rootGradient.Parent = root

    local function round(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or Theme.Radius.Button)
        corner.Parent = instance
        return corner
    end

    local function stroke(instance, color, transparency)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = color or Theme.Colors.Border
        uiStroke.Thickness = 1
        uiStroke.Transparency = transparency or 0.25
        uiStroke.Parent = instance
        return uiStroke
    end

    local function addPadding(instance, left, right, top, bottom)
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, left or 10)
        pad.PaddingRight = UDim.new(0, right or 10)
        pad.PaddingTop = UDim.new(0, top or 0)
        pad.PaddingBottom = UDim.new(0, bottom or 0)
        pad.Parent = instance
        return pad
    end

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 44)
    topBar.BackgroundTransparency = 1
    topBar.Parent = root

    local titleIcon = Instance.new("TextLabel")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 30, 0, 30)
    titleIcon.Position = UDim2.new(0, 14, 0, 7)
    titleIcon.BackgroundColor3 = Color3.fromRGB(16, 176, 205)
    titleIcon.BackgroundTransparency = 0.68
    titleIcon.BorderSizePixel = 0
    titleIcon.Text = ""
    titleIcon.Parent = topBar
    round(titleIcon, 10)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -92, 1, 0)
    title.Position = UDim2.new(0, 52, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "MI PERFIL (PRIVADO)"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Parent = topBar

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -42, 0, 8)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BackgroundTransparency = 0.45
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 13
    closeButton.Parent = topBar
    round(closeButton, 8)

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -24, 1, -56)
    content.Position = UDim2.new(0, 12, 0, 48)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Parent = root

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 2)
    padding.PaddingRight = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = content

    local function makePanel(name, height)
        local panel = Instance.new("Frame")
        panel.Name = name
        panel.Size = UDim2.new(1, -4, 0, height)
        panel.BackgroundColor3 = Color3.fromRGB(15, 24, 35)
        panel.BackgroundTransparency = 0.05
        panel.BorderSizePixel = 0
        panel.Parent = content
        round(panel, 10)
        stroke(panel, Color3.fromRGB(36, 69, 88), 0.34)
        return panel
    end

    local selectedVisibility = original.game_status_visibility

    local header = makePanel("Header", 180)
    header.ClipsDescendants = true

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 112)
    banner.BackgroundColor3 = Color3.fromRGB(10, 17, 27)
    banner.BorderSizePixel = 0
    banner.Parent = header

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 18, 31)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(17, 45, 62)),
        ColorSequenceKeypoint.new(0.72, Color3.fromRGB(20, 31, 54)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 24))
    })
    bannerGradient.Rotation = 20
    bannerGradient.Parent = banner

    local bannerShade = Instance.new("Frame")
    bannerShade.Name = "BannerShade"
    bannerShade.Size = UDim2.new(1, 0, 1, 0)
    bannerShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bannerShade.BackgroundTransparency = 0.58
    bannerShade.BorderSizePixel = 0
    bannerShade.Parent = banner

    local infoOverlay = Instance.new("Frame")
    infoOverlay.Name = "InfoOverlay"
    infoOverlay.Size = UDim2.new(1, -104, 0, 102)
    infoOverlay.Position = UDim2.new(0, 92, 0, 18)
    infoOverlay.BackgroundColor3 = Color3.fromRGB(7, 13, 22)
    infoOverlay.BackgroundTransparency = 0.2
    infoOverlay.BorderSizePixel = 0
    infoOverlay.Parent = header
    round(infoOverlay, 12)
    stroke(infoOverlay, Color3.fromRGB(45, 88, 110), 0.5)

    local overlayGradient = Instance.new("UIGradient")
    overlayGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 24, 37)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 13, 22))
    })
    overlayGradient.Rotation = 0
    overlayGradient.Parent = infoOverlay

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 104, 0, 104)
    avatarFrame.Position = UDim2.new(0, 18, 0, 34)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(8, 13, 21)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = header
    round(avatarFrame, 52)
    stroke(avatarFrame, Color3.fromRGB(24, 201, 229), 0.08)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -8, 1, -8)
    avatarImage.Position = UDim2.new(0, 4, 0, 4)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatarFrame
    round(avatarImage, 50)

    local ok, image = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size180x180
        )
    end)

    if ok then
        avatarImage.Image = image
    end

    local displayLabel = Instance.new("TextLabel")
    displayLabel.Name = "DisplayNameLabel"
    displayLabel.Size = UDim2.new(1, -18, 0, 18)
    displayLabel.Position = UDim2.new(0, 12, 0, 8)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Text = "Nombre de Usuario"
    displayLabel.TextColor3 = Theme.Colors.Text
    displayLabel.Font = Theme.Font.Regular
    displayLabel.TextSize = 11
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.Parent = infoOverlay

    local displayInput = Instance.new("TextBox")
    displayInput.Name = "DisplayNameInput"
    displayInput.Size = UDim2.new(1, -24, 0, 32)
    displayInput.Position = UDim2.new(0, 12, 0, 28)
    displayInput.BackgroundColor3 = Color3.fromRGB(8, 15, 25)
    displayInput.BackgroundTransparency = 0.05
    displayInput.BorderSizePixel = 0
    displayInput.Text = original.display_name
    displayInput.PlaceholderText = "Display Name"
    displayInput.TextColor3 = Theme.Colors.Text
    displayInput.PlaceholderColor3 = Theme.Colors.TextMuted
    displayInput.Font = Theme.Font.Bold
    displayInput.TextSize = 13
    displayInput.TextXAlignment = Enum.TextXAlignment.Left
    displayInput.ClearTextOnFocus = false
    displayInput.Parent = infoOverlay
    round(displayInput, 8)
    stroke(displayInput, Color3.fromRGB(38, 64, 83), 0.42)
    addPadding(displayInput, 10, 10)

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(0.45, -8, 0, 18)
    username.Position = UDim2.new(0, 12, 0, 66)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Regular
    username.TextSize = 11
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.Parent = infoOverlay

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(0.55, -16, 0, 18)
    status.Position = UDim2.new(0.45, 4, 0, 66)
    status.BackgroundTransparency = 1
    status.Text = "Jugando a Metro Life RP"
    status.TextColor3 = Theme.Colors.Text
    status.Font = Theme.Font.Bold
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.Parent = infoOverlay

    local visibilityRow = Instance.new("Frame")
    visibilityRow.Name = "VisibilityRow"
    visibilityRow.Size = UDim2.new(1, -142, 0, 28)
    visibilityRow.Position = UDim2.new(0, 132, 0, 140)
    visibilityRow.BackgroundTransparency = 1
    visibilityRow.Parent = header

    local function makeVisibilityButton(name, text, xScale)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0.5, -4, 1, 0)
        button.Position = UDim2.new(xScale, xScale == 0 and 0 or 4, 0, 0)
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Theme.Colors.Text
        button.Font = Theme.Font.Bold
        button.TextSize = 11
        button.Parent = visibilityRow
        round(button, 8)
        stroke(button, Color3.fromRGB(35, 95, 115), 0.4)
        return button
    end

    local privateButton = makeVisibilityButton("PrivateButton", "Privado", 0)
    local publicButton = makeVisibilityButton("PublicButton", "Publico", 0.5)

    local function updateVisibilityButtons()
        publicButton.BackgroundColor3 =
            selectedVisibility == "public" and Color3.fromRGB(15, 120, 145) or Theme.Colors.PanelLight
        publicButton.BackgroundTransparency =
            selectedVisibility == "public" and 0.08 or 0.35

        privateButton.BackgroundColor3 =
            selectedVisibility == "private" and Color3.fromRGB(15, 120, 145) or Theme.Colors.PanelLight
        privateButton.BackgroundTransparency =
            selectedVisibility == "private" and 0.08 or 0.35
    end

    publicButton.MouseButton1Click:Connect(function()
        selectedVisibility = "public"
        updateVisibilityButtons()
    end)

    privateButton.MouseButton1Click:Connect(function()
        selectedVisibility = "private"
        updateVisibilityButtons()
    end)

    updateVisibilityButtons()

    local function createStatPanel(name, labelText, valueText)
        local panel = Instance.new("Frame")
        panel.Name = name
        panel.Size = UDim2.new(1, -4, 0, 58)
        panel.BackgroundColor3 = Color3.fromRGB(16, 27, 39)
        panel.BackgroundTransparency = 0.05
        panel.BorderSizePixel = 0
        panel.Parent = content
        round(panel, 9)
        stroke(panel, Color3.fromRGB(35, 63, 80), 0.42)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 22)
        label.Position = UDim2.new(0, 10, 0, 7)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.Colors.TextMuted
        label.Font = Theme.Font.Bold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Parent = panel

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(1, -20, 0, 23)
        value.Position = UDim2.new(0, 10, 0, 28)
        value.BackgroundTransparency = 1
        value.Text = valueText
        value.TextColor3 = Theme.Colors.Text
        value.Font = Theme.Font.Bold
        value.TextSize = 13
        value.TextXAlignment = Enum.TextXAlignment.Center
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.Parent = panel

        return value
    end

    local clanValue = createStatPanel(
        "ClanBox",
        "Clan",
        tostring(profile.clan_name or "Sin clan")
    )

    local pointsValue = createStatPanel(
        "PointsBox",
        "Puntos Personales",
        tostring(profile.personal_points or 0)
    )

    local descriptionBox = makePanel("DescriptionBox", 112)

    local descriptionTitle = Instance.new("TextLabel")
    descriptionTitle.Size = UDim2.new(1, -18, 0, 22)
    descriptionTitle.Position = UDim2.new(0, 9, 0, 7)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.Text = "Descripcion"
    descriptionTitle.TextColor3 = Theme.Colors.Text
    descriptionTitle.Font = Theme.Font.Bold
    descriptionTitle.TextSize = 12
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    descriptionTitle.Parent = descriptionBox

    local descriptionInput = Instance.new("TextBox")
    descriptionInput.Name = "DescriptionInput"
    descriptionInput.Size = UDim2.new(1, -18, 0, 74)
    descriptionInput.Position = UDim2.new(0, 9, 0, 30)
    descriptionInput.BackgroundColor3 = Color3.fromRGB(8, 15, 25)
    descriptionInput.BackgroundTransparency = 0.05
    descriptionInput.BorderSizePixel = 0
    descriptionInput.Text = original.bio
    descriptionInput.PlaceholderText = "Cuentales algo sobre ti..."
    descriptionInput.TextColor3 = Theme.Colors.Text
    descriptionInput.PlaceholderColor3 = Theme.Colors.TextMuted
    descriptionInput.Font = Theme.Font.Regular
    descriptionInput.TextSize = 12
    descriptionInput.TextWrapped = true
    descriptionInput.TextXAlignment = Enum.TextXAlignment.Left
    descriptionInput.TextYAlignment = Enum.TextYAlignment.Top
    descriptionInput.ClearTextOnFocus = false
    descriptionInput.MultiLine = true
    descriptionInput.Parent = descriptionBox
    round(descriptionInput, 8)
    stroke(descriptionInput, Color3.fromRGB(35, 63, 80), 0.48)
    addPadding(descriptionInput, 9, 9, 7, 7)

    descriptionInput:GetPropertyChangedSignal("Text"):Connect(function()
        if #descriptionInput.Text > 120 then
            descriptionInput.Text = string.sub(descriptionInput.Text, 1, 120)
        end
    end)

    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(1, -4, 0, 40)
    inventoryButton.BackgroundColor3 = Color3.fromRGB(13, 76, 96)
    inventoryButton.BackgroundTransparency = 0.05
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "Ver Inventario"
    inventoryButton.TextColor3 = Theme.Colors.Text
    inventoryButton.Font = Theme.Font.Bold
    inventoryButton.TextSize = 13
    inventoryButton.Parent = content
    round(inventoryButton, 8)
    stroke(inventoryButton, Color3.fromRGB(30, 181, 216), 0.18)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -4, 0, 20)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Bold
    statusLabel.TextSize = 11
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = content

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(1, -4, 0, 40)
    actions.BackgroundTransparency = 1
    actions.Parent = content

    local saveButton = Instance.new("TextButton")
    saveButton.Name = "SaveButton"
    saveButton.Size = UDim2.new(0.5, -5, 1, 0)
    saveButton.BackgroundColor3 = Color3.fromRGB(18, 111, 55)
    saveButton.BackgroundTransparency = 0.05
    saveButton.BorderSizePixel = 0
    saveButton.Text = "Guardar Cambios"
    saveButton.TextColor3 = Theme.Colors.Text
    saveButton.Font = Theme.Font.Bold
    saveButton.TextSize = 12
    saveButton.Parent = actions
    round(saveButton, 8)
    stroke(saveButton, Color3.fromRGB(52, 191, 99), 0.28)

    local publicProfileButton = Instance.new("TextButton")
    publicProfileButton.Name = "PublicProfileButton"
    publicProfileButton.Size = UDim2.new(0.5, -5, 1, 0)
    publicProfileButton.Position = UDim2.new(0.5, 5, 0, 0)
    publicProfileButton.BackgroundColor3 = Color3.fromRGB(27, 39, 55)
    publicProfileButton.BackgroundTransparency = 0.05
    publicProfileButton.BorderSizePixel = 0
    publicProfileButton.Text = "Ver Perfil Publico"
    publicProfileButton.TextColor3 = Theme.Colors.Text
    publicProfileButton.Font = Theme.Font.Bold
    publicProfileButton.TextSize = 12
    publicProfileButton.Parent = actions
    round(publicProfileButton, 8)
    stroke(publicProfileButton, Color3.fromRGB(43, 64, 84), 0.22)

    local function refreshCanvas()
        task.defer(function()
            content.CanvasSize = UDim2.new(
                0,
                0,
                0,
                layout.AbsoluteContentSize.Y + 16
            )
        end)
    end

    refreshCanvas()

    return {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        SaveButton = saveButton,
        PublicProfileButton = publicProfileButton,
        InventoryButton = inventoryButton,
        StatusLabel = statusLabel,

        GetChangedData = function()
            local data = {}
            local nextDisplayName = displayInput.Text or ""
            local nextBio = descriptionInput.Text or ""

            if nextDisplayName ~= original.display_name then
                data.display_name = nextDisplayName
            end

            if nextBio ~= original.bio then
                data.bio = nextBio
            end

            if selectedVisibility ~= original.game_status_visibility then
                data.game_status_visibility = selectedVisibility
            end

            return data
        end,

        GetChanges = function()
            return {
                display_name = displayInput.Text,
                bio = descriptionInput.Text,
                game_status_visibility = selectedVisibility
            }
        end,

        ApplyProfile = function(nextProfile)
            profile = nextProfile or profile

            original.display_name = tostring(profile.display_name or player.DisplayName)
            original.bio = tostring(profile.bio or "")
            original.game_status_visibility = tostring(profile.game_status_visibility or "public")

            displayInput.Text = original.display_name
            descriptionInput.Text = original.bio
            selectedVisibility = original.game_status_visibility
            pointsValue.Text = tostring(profile.personal_points or 0)
            clanValue.Text = tostring(profile.clan_name or "Sin clan")
            updateVisibilityButtons()
            refreshCanvas()
        end,

        ShowStatus = function(message, isError)
            statusLabel.Text = message or ""
            statusLabel.TextColor3 = isError and Theme.Colors.Danger or Theme.Colors.TextMuted
        end,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ProfileUI
