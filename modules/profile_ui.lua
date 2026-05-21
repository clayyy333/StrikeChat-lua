local ProfileUI = {}

function ProfileUI.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")

    profile = profile or {}

    local original = {
        display_name = tostring(profile.display_name or player.DisplayName),
        bio = tostring(profile.bio or ""),
        game_status_visibility = tostring(profile.game_status_visibility or "public")
    }

    local modalColor = Color3.fromRGB(50, 51, 57)
    local panelColor = Color3.fromRGB(57, 58, 65)
    local inputColor = Color3.fromRGB(48, 49, 55)
    local borderColor = Color3.fromRGB(80, 82, 92)

    local gui = Instance.new("ScreenGui")
    gui.Name = "ProfileUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0.94, 0, 0.82, 0)
    root.Position = UDim2.new(0.5, 0, 0.52, 0)
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.BackgroundColor3 = modalColor
    root.BorderSizePixel = 0
    root.ClipsDescendants = true
    root.Parent = gui

    local rootSize = Instance.new("UISizeConstraint")
    rootSize.MinSize = Vector2.new(820, 560)
    rootSize.MaxSize = Vector2.new(980, 650)
    rootSize.Parent = root

    local function round(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or Theme.Radius.Button)
        corner.Parent = instance
        return corner
    end

    local function stroke(instance, color, transparency)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = color or borderColor
        uiStroke.Thickness = 1
        uiStroke.Transparency = transparency or 0.35
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

    round(root, Theme.Radius.Main)
    stroke(root, Color3.fromRGB(96, 98, 110), 0.48)

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 44)
    topBar.BackgroundTransparency = 1
    topBar.Parent = root

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -42, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(65, 66, 74)
    closeButton.BackgroundTransparency = 0.12
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.Parent = topBar
    round(closeButton, 10)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -90, 1, -76)
    content.Position = UDim2.new(0, 45, 0, 56)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Parent = root

    local selectedVisibility = original.game_status_visibility

    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "PrivateProfilePanel"
    leftPanel.Size = UDim2.new(0.45, -10, 1, 0)
    leftPanel.Position = UDim2.new(0, 0, 0, 0)
    leftPanel.BackgroundColor3 = panelColor
    leftPanel.BorderSizePixel = 0
    leftPanel.ClipsDescendants = true
    leftPanel.Parent = content
    round(leftPanel, 14)
    stroke(leftPanel, Color3.fromRGB(82, 84, 94), 0.52)

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 140)
    banner.BackgroundColor3 = Color3.fromRGB(18, 18, 34)
    banner.BorderSizePixel = 0
    banner.ClipsDescendants = true
    banner.Parent = leftPanel

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(10, 12, 30)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(52, 35, 100)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(123, 48, 118)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(20, 88, 112)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(189, 112, 80))
    })
    bannerGradient.Rotation = 24
    bannerGradient.Parent = banner

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 112, 0, 112)
    avatarFrame.Position = UDim2.new(0, 26, 0, 82)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(31, 32, 38)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 4
    avatarFrame.Parent = leftPanel
    round(avatarFrame, 56)
    stroke(avatarFrame, Color3.fromRGB(118, 120, 134), 0.15)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -8, 1, -8)
    avatarImage.Position = UDim2.new(0, 4, 0, 4)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ZIndex = avatarFrame.ZIndex + 1
    avatarImage.Parent = avatarFrame
    round(avatarImage, 52)

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

    local displayInput = Instance.new("TextBox")
    displayInput.Name = "DisplayNameInput"
    displayInput.Size = UDim2.new(1, -178, 0, 32)
    displayInput.Position = UDim2.new(0, 154, 0, 148)
    displayInput.BackgroundTransparency = 1
    displayInput.BorderSizePixel = 0
    displayInput.Text = original.display_name
    displayInput.PlaceholderText = "Display Name"
    displayInput.TextColor3 = Theme.Colors.Text
    displayInput.PlaceholderColor3 = Theme.Colors.TextMuted
    displayInput.Font = Theme.Font.Bold
    displayInput.TextSize = 24
    displayInput.TextXAlignment = Enum.TextXAlignment.Left
    displayInput.TextTruncate = Enum.TextTruncate.AtEnd
    displayInput.ClearTextOnFocus = false
    displayInput.ZIndex = 5
    displayInput.Parent = leftPanel

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -178, 0, 18)
    username.Position = UDim2.new(0, 154, 0, 182)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Bold
    username.TextSize = 12
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = 5
    username.Parent = leftPanel

    local pointsLabel = Instance.new("TextLabel")
    pointsLabel.Name = "PointsLabel"
    pointsLabel.Size = UDim2.new(1, -48, 0, 20)
    pointsLabel.Position = UDim2.new(0, 24, 0, 226)
    pointsLabel.BackgroundTransparency = 1
    pointsLabel.Text = "Puntos de Usuario:"
    pointsLabel.TextColor3 = Theme.Colors.Text
    pointsLabel.Font = Theme.Font.Bold
    pointsLabel.TextSize = 14
    pointsLabel.TextXAlignment = Enum.TextXAlignment.Center
    pointsLabel.Parent = leftPanel

    local pointsValue = Instance.new("TextLabel")
    pointsValue.Name = "PointsValue"
    pointsValue.Size = UDim2.new(1, -48, 0, 24)
    pointsValue.Position = UDim2.new(0, 24, 0, 248)
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(profile.personal_points or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 15
    pointsValue.TextXAlignment = Enum.TextXAlignment.Center
    pointsValue.TextTruncate = Enum.TextTruncate.AtEnd
    pointsValue.Parent = leftPanel

    local clanLabel = Instance.new("TextLabel")
    clanLabel.Name = "ClanLabel"
    clanLabel.Size = UDim2.new(1, -52, 0, 20)
    clanLabel.Position = UDim2.new(0, 26, 0, 298)
    clanLabel.BackgroundTransparency = 1
    clanLabel.Text = "Clan:"
    clanLabel.TextColor3 = Theme.Colors.Text
    clanLabel.Font = Theme.Font.Bold
    clanLabel.TextSize = 14
    clanLabel.TextXAlignment = Enum.TextXAlignment.Left
    clanLabel.Parent = leftPanel

    local clanValue = Instance.new("TextLabel")
    clanValue.Name = "ClanValue"
    clanValue.Size = UDim2.new(1, -52, 0, 20)
    clanValue.Position = UDim2.new(0, 26, 0, 318)
    clanValue.BackgroundTransparency = 1
    clanValue.Text = tostring(profile.clan_name or "Sin clan")
    clanValue.TextColor3 = Theme.Colors.Text
    clanValue.Font = Theme.Font.Regular
    clanValue.TextSize = 13
    clanValue.TextXAlignment = Enum.TextXAlignment.Left
    clanValue.TextTruncate = Enum.TextTruncate.AtEnd
    clanValue.Parent = leftPanel

    local descriptionTitle = Instance.new("TextLabel")
    descriptionTitle.Name = "DescriptionTitle"
    descriptionTitle.Size = UDim2.new(1, -52, 0, 22)
    descriptionTitle.Position = UDim2.new(0, 26, 0.64, 0)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.Text = "Descripcion:"
    descriptionTitle.TextColor3 = Theme.Colors.Text
    descriptionTitle.Font = Theme.Font.Bold
    descriptionTitle.TextSize = 14
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    descriptionTitle.Parent = leftPanel

    local descriptionInput = Instance.new("TextBox")
    descriptionInput.Name = "DescriptionInput"
    descriptionInput.Size = UDim2.new(1, -64, 0.18, 0)
    descriptionInput.Position = UDim2.new(0, 32, 0.70, 0)
    descriptionInput.BackgroundColor3 = inputColor
    descriptionInput.BackgroundTransparency = 0
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
    descriptionInput.Parent = leftPanel
    round(descriptionInput, 6)
    stroke(descriptionInput, Color3.fromRGB(43, 44, 50), 0.55)
    addPadding(descriptionInput, 10, 10, 8, 8)

    descriptionInput:GetPropertyChangedSignal("Text"):Connect(function()
        if #descriptionInput.Text > 120 then
            descriptionInput.Text = string.sub(descriptionInput.Text, 1, 120)
        end
    end)

    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(0, 160, 0, 34)
    inventoryButton.Position = UDim2.new(0.5, -80, 1, -52)
    inventoryButton.BackgroundColor3 = Color3.fromRGB(61, 62, 70)
    inventoryButton.BackgroundTransparency = 0.02
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "Inventario"
    inventoryButton.TextColor3 = Theme.Colors.Text
    inventoryButton.Font = Theme.Font.Bold
    inventoryButton.TextSize = 13
    inventoryButton.Parent = leftPanel
    round(inventoryButton, 8)
    stroke(inventoryButton, Color3.fromRGB(235, 237, 245), 0.04)

    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "ActivityPanel"
    rightPanel.Size = UDim2.new(0.52, 0, 1, 0)
    rightPanel.Position = UDim2.new(0.48, 0, 0, 0)
    rightPanel.BackgroundTransparency = 1
    rightPanel.BorderSizePixel = 0
    rightPanel.Parent = content

    local tabRow = Instance.new("Frame")
    tabRow.Name = "TabRow"
    tabRow.Size = UDim2.new(1, 0, 0, 52)
    tabRow.BackgroundTransparency = 1
    tabRow.Parent = rightPanel

    local activityTab = Instance.new("TextLabel")
    activityTab.Name = "ActivityTab"
    activityTab.Size = UDim2.new(0, 92, 0, 34)
    activityTab.Position = UDim2.new(0, 0, 0, 10)
    activityTab.BackgroundTransparency = 1
    activityTab.Text = "Actividad"
    activityTab.TextColor3 = Theme.Colors.Text
    activityTab.Font = Theme.Font.Bold
    activityTab.TextSize = 14
    activityTab.TextXAlignment = Enum.TextXAlignment.Left
    activityTab.Parent = tabRow

    local activityUnderline = Instance.new("Frame")
    activityUnderline.Name = "ActivityUnderline"
    activityUnderline.Size = UDim2.new(0, 60, 0, 2)
    activityUnderline.Position = UDim2.new(0, 0, 1, -8)
    activityUnderline.BackgroundColor3 = Theme.Colors.Text
    activityUnderline.BorderSizePixel = 0
    activityUnderline.Parent = tabRow

    local visibilityRow = Instance.new("Frame")
    visibilityRow.Name = "VisibilityRow"
    visibilityRow.Size = UDim2.new(0, 260, 0, 34)
    visibilityRow.Position = UDim2.new(0, 100, 0, 10)
    visibilityRow.BackgroundTransparency = 1
    visibilityRow.Parent = tabRow

    local function makeVisibilityButton(name, text, x)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 106, 1, 0)
        button.Position = UDim2.new(0, x, 0, 0)
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Theme.Colors.Text
        button.Font = Theme.Font.Bold
        button.TextSize = 14
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = visibilityRow

        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 8, 0, 8)
        indicator.Position = UDim2.new(1, -18, 0.5, -4)
        indicator.BorderSizePixel = 0
        indicator.Parent = button
        round(indicator, 4)

        return button, indicator
    end

    local publicButton, publicIndicator = makeVisibilityButton("PublicButton", "Publico", 0)
    local privateButton, privateIndicator = makeVisibilityButton("PrivateButton", "Privado", 152)

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0, 52)
    divider.BackgroundColor3 = Color3.fromRGB(71, 72, 82)
    divider.BackgroundTransparency = 0.35
    divider.BorderSizePixel = 0
    divider.Parent = rightPanel

    local recentLabel = Instance.new("TextLabel")
    recentLabel.Name = "RecentLabel"
    recentLabel.Size = UDim2.new(1, 0, 0, 18)
    recentLabel.Position = UDim2.new(0, 0, 0, 74)
    recentLabel.BackgroundTransparency = 1
    recentLabel.Text = "Actividad reciente"
    recentLabel.TextColor3 = Theme.Colors.TextMuted
    recentLabel.Font = Theme.Font.Bold
    recentLabel.TextSize = 12
    recentLabel.TextXAlignment = Enum.TextXAlignment.Left
    recentLabel.Parent = rightPanel

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(1, -20, 0, 30)
    status.Position = UDim2.new(0, 8, 0, 110)
    status.BackgroundTransparency = 1
    status.Text = "Jugando a : Metro Life RP"
    status.TextColor3 = Theme.Colors.Text
    status.Font = Theme.Font.Bold
    status.TextSize = 15
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.Parent = rightPanel

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 32)
    statusLabel.Position = UDim2.new(0, 0, 1, -104)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Bold
    statusLabel.TextSize = 11
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = rightPanel

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(1, 0, 0, 40)
    actions.Position = UDim2.new(0, 0, 1, -58)
    actions.BackgroundTransparency = 1
    actions.Parent = rightPanel

    local saveButton = Instance.new("TextButton")
    saveButton.Name = "SaveButton"
    saveButton.Size = UDim2.new(0.5, -12, 1, 0)
    saveButton.Position = UDim2.new(0, 20, 0, 0)
    saveButton.BackgroundColor3 = modalColor
    saveButton.BackgroundTransparency = 1
    saveButton.BorderSizePixel = 0
    saveButton.Text = "Guardar Cambios"
    saveButton.TextColor3 = Theme.Colors.Text
    saveButton.Font = Theme.Font.Bold
    saveButton.TextSize = 14
    saveButton.Parent = actions

    local publicProfileButton = Instance.new("TextButton")
    publicProfileButton.Name = "PublicProfileButton"
    publicProfileButton.Size = UDim2.new(0.5, -12, 1, 0)
    publicProfileButton.Position = UDim2.new(0.5, 4, 0, 0)
    publicProfileButton.BackgroundColor3 = modalColor
    publicProfileButton.BackgroundTransparency = 1
    publicProfileButton.BorderSizePixel = 0
    publicProfileButton.Text = "Ver Perfil Publico"
    publicProfileButton.TextColor3 = Theme.Colors.Text
    publicProfileButton.Font = Theme.Font.Bold
    publicProfileButton.TextSize = 14
    publicProfileButton.Parent = actions

    local function updateVisibilityButtons()
        publicIndicator.BackgroundColor3 =
            selectedVisibility == "public" and Color3.fromRGB(235, 237, 245) or Color3.fromRGB(116, 118, 130)
        publicIndicator.BackgroundTransparency =
            selectedVisibility == "public" and 0 or 0.45

        privateIndicator.BackgroundColor3 =
            selectedVisibility == "private" and Color3.fromRGB(235, 237, 245) or Color3.fromRGB(116, 118, 130)
        privateIndicator.BackgroundTransparency =
            selectedVisibility == "private" and 0 or 0.45
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

    local function refreshCanvas()
        return
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
            username.Text = "@" .. tostring(profile.roblox_username or player.Name)
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
