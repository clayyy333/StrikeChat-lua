local ProfileUI = {}

function ProfileUI.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

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
    root.Size = UDim2.new(0.60, 0, 0.72, 0)
    root.Position = UDim2.new(0.5, 0, 0.52, 0)
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.BackgroundColor3 = Theme.Colors.Panel
    root.BorderSizePixel = 0
    root.Parent = gui

    local rootSize = Instance.new("UISizeConstraint")
    rootSize.MinSize = Vector2.new(300, 440)
    rootSize.MaxSize = Vector2.new(420, 520)
    rootSize.Parent = root

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    rootCorner.Parent = root

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color = Color3.fromRGB(18, 20, 26)
    rootStroke.Thickness = 1
    rootStroke.Transparency = 0.22
    rootStroke.Parent = root

    local rootGradient = Instance.new("UIGradient")
    rootGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 25, 36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 23, 34))
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

    local function createStar(parent, xScale, yScale, size)
        local star = Instance.new("Frame")
        star.AnchorPoint = Vector2.new(0.5, 0.5)
        star.Position = UDim2.new(xScale, 0, yScale, 0)
        star.Size = UDim2.new(0, size, 0, size)
        star.BackgroundColor3 = Color3.fromRGB(220, 245, 255)
        star.BackgroundTransparency = 1
        star.BorderSizePixel = 0
        star.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = star

        local glow = Instance.new("UIStroke")
        glow.Color = Color3.fromRGB(120, 220, 255)
        glow.Transparency = 1
        glow.Thickness = 2
        glow.Parent = star

        task.spawn(function()
            while star.Parent do
                local delayTime = math.random(8, 30) / 10
                task.wait(delayTime)

                TweenService:Create(star, TweenInfo.new(0.35), {
                    BackgroundTransparency = 0.1
                }):Play()

                TweenService:Create(glow, TweenInfo.new(0.35), {
                    Transparency = 0.25,
                    Thickness = 4
                }):Play()

                task.wait(math.random(4, 10) / 10)

                TweenService:Create(star, TweenInfo.new(0.6), {
                    BackgroundTransparency = 1
                }):Play()

                TweenService:Create(glow, TweenInfo.new(0.6), {
                    Transparency = 1,
                    Thickness = 2
                }):Play()
            end
        end)
    end

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundTransparency = 1
    topBar.Parent = root

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 26)
    closeButton.Position = UDim2.new(1, -40, 0, 7)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BackgroundTransparency = 0.45
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 13
    closeButton.Parent = topBar
    round(closeButton, 8)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -22, 1, -48)
    content.Position = UDim2.new(0, 11, 0, 42)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Parent = root

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 2)
    padding.PaddingRight = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.Parent = content

    local function makePanel(name, height)
        local panel = Instance.new("Frame")
        panel.Name = name
        panel.Size = UDim2.new(1, -4, 0, height)
        panel.BackgroundColor3 = Color3.fromRGB(18, 32, 46)
        panel.BackgroundTransparency = 0.16
        panel.BorderSizePixel = 0
        panel.Parent = content
        round(panel, 10)
        stroke(panel, Color3.fromRGB(50, 88, 108), 0.55)
        return panel
    end

    local selectedVisibility = original.game_status_visibility

    local header = makePanel("Header", 138)
    header.BackgroundColor3 = Color3.fromRGB(18, 25, 34)
    header.BackgroundTransparency = 0.08
    header.ClipsDescendants = true
    local headerStroke = header:FindFirstChildOfClass("UIStroke")
    if headerStroke then
        headerStroke.Color = Color3.fromRGB(28, 34, 42)
        headerStroke.Transparency = 0.38
    end

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 78)
    banner.BackgroundColor3 = Color3.fromRGB(18, 34, 50)
    banner.BorderSizePixel = 0
    banner.Parent = header

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 54, 76)),
        ColorSequenceKeypoint.new(0.44, Color3.fromRGB(30, 76, 96)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(26, 46, 74)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 24, 42))
    })
    bannerGradient.Rotation = 20
    bannerGradient.Parent = banner

    local bannerShade = Instance.new("Frame")
    bannerShade.Name = "BannerShade"
    bannerShade.Size = UDim2.new(1, 0, 1, 0)
    bannerShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bannerShade.BackgroundTransparency = 0.74
    bannerShade.BorderSizePixel = 0
    bannerShade.Parent = banner

    local stars = {
        {0.10, 0.24, 2},
        {0.18, 0.62, 3},
        {0.26, 0.34, 2},
        {0.35, 0.18, 3},
        {0.44, 0.58, 2},
        {0.53, 0.29, 3},
        {0.62, 0.70, 2},
        {0.70, 0.22, 2},
        {0.78, 0.48, 3},
        {0.88, 0.30, 2},
        {0.93, 0.66, 3}
    }

    for _, starData in ipairs(stars) do
        createStar(banner, starData[1], starData[2], starData[3])
    end

    local infoOverlay = Instance.new("Frame")
    infoOverlay.Name = "InfoOverlay"
    infoOverlay.Size = UDim2.new(1, -112, 0, 98)
    infoOverlay.Position = UDim2.new(0, 100, 0, 35)
    infoOverlay.BackgroundColor3 = Color3.fromRGB(15, 30, 44)
    infoOverlay.BackgroundTransparency = 1
    infoOverlay.BorderSizePixel = 0
    infoOverlay.Parent = header
    round(infoOverlay, 10)

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 80, 0, 80)
    avatarFrame.Position = UDim2.new(0, 16, 0, 46)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = header
    round(avatarFrame, 40)
    stroke(avatarFrame, Color3.fromRGB(52, 58, 70), 0.18)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -6, 1, -6)
    avatarImage.Position = UDim2.new(0, 3, 0, 3)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatarFrame
    round(avatarImage, 38)

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
    displayInput.Size = UDim2.new(1, -20, 0, 28)
    displayInput.Position = UDim2.new(0, 10, 0, 12)
    displayInput.BackgroundColor3 = Color3.fromRGB(13, 25, 38)
    displayInput.BackgroundTransparency = 1
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
    addPadding(displayInput, 9, 9)

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -20, 0, 17)
    username.Position = UDim2.new(0, 10, 0, 44)
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
    status.Size = UDim2.new(1, -20, 0, 17)
    status.Position = UDim2.new(0, 10, 0, 60)
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
    visibilityRow.Size = UDim2.new(0, 148, 0, 18)
    visibilityRow.Position = UDim2.new(0, 10, 0, 80)
    visibilityRow.BackgroundTransparency = 1
    visibilityRow.Parent = infoOverlay

    local function makeVisibilityButton(name, text, xScale)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 70, 1, 0)
        button.Position = UDim2.new(0, xScale == 0 and 0 or 78, 0, 0)
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Theme.Colors.Text
        button.Font = Theme.Font.Bold
        button.TextSize = 10
        button.Parent = visibilityRow
        round(button, 7)
        stroke(button, Color3.fromRGB(58, 110, 128), 0.6)
        return button
    end

    local privateButton = makeVisibilityButton("PrivateButton", "Privado", 0)
    local publicButton = makeVisibilityButton("PublicButton", "Publico", 0.5)

    local function updateVisibilityButtons()
        publicButton.BackgroundColor3 =
            selectedVisibility == "public" and Color3.fromRGB(22, 124, 148) or Color3.fromRGB(24, 42, 57)
        publicButton.BackgroundTransparency =
            selectedVisibility == "public" and 0.12 or 0.44

        privateButton.BackgroundColor3 =
            selectedVisibility == "private" and Color3.fromRGB(22, 124, 148) or Color3.fromRGB(24, 42, 57)
        privateButton.BackgroundTransparency =
            selectedVisibility == "private" and 0.12 or 0.44
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
        panel.Size = UDim2.new(1, -4, 0, 40)
        panel.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
        panel.BackgroundTransparency = 0.08
        panel.BorderSizePixel = 0
        panel.Parent = content
        round(panel, 8)
        stroke(panel, Color3.fromRGB(28, 34, 42), 0.38)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -18, 0, 18)
        label.Position = UDim2.new(0, 9, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.Colors.TextMuted
        label.Font = Theme.Font.Bold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Parent = panel

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(1, -18, 0, 18)
        value.Position = UDim2.new(0, 9, 0, 20)
        value.BackgroundTransparency = 1
        value.Text = valueText
        value.TextColor3 = Theme.Colors.Text
        value.Font = Theme.Font.Bold
        value.TextSize = 12
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

    local descriptionBox = makePanel("DescriptionBox", 72)
    descriptionBox.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
    descriptionBox.BackgroundTransparency = 0.08
    local descriptionBoxStroke = descriptionBox:FindFirstChildOfClass("UIStroke")
    if descriptionBoxStroke then
        descriptionBoxStroke.Color = Color3.fromRGB(28, 34, 42)
        descriptionBoxStroke.Transparency = 0.38
    end

    local descriptionTitle = Instance.new("TextLabel")
    descriptionTitle.Size = UDim2.new(1, -18, 0, 18)
    descriptionTitle.Position = UDim2.new(0, 9, 0, 4)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.Text = "Descripcion"
    descriptionTitle.TextColor3 = Theme.Colors.Text
    descriptionTitle.Font = Theme.Font.Bold
    descriptionTitle.TextSize = 12
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    descriptionTitle.Parent = descriptionBox

    local descriptionInput = Instance.new("TextBox")
    descriptionInput.Name = "DescriptionInput"
    descriptionInput.Size = UDim2.new(1, -18, 0, 42)
    descriptionInput.Position = UDim2.new(0, 9, 0, 22)
    descriptionInput.BackgroundColor3 = Color3.fromRGB(10, 14, 20)
    descriptionInput.BackgroundTransparency = 0.1
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
    stroke(descriptionInput, Color3.fromRGB(26, 31, 38), 0.42)
    addPadding(descriptionInput, 8, 8, 6, 6)

    descriptionInput:GetPropertyChangedSignal("Text"):Connect(function()
        if #descriptionInput.Text > 120 then
            descriptionInput.Text = string.sub(descriptionInput.Text, 1, 120)
        end
    end)

    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(1, -4, 0, 30)
    inventoryButton.BackgroundColor3 = Color3.fromRGB(17, 88, 108)
    inventoryButton.BackgroundTransparency = 0.12
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "Ver Inventario"
    inventoryButton.TextColor3 = Theme.Colors.Text
    inventoryButton.Font = Theme.Font.Bold
    inventoryButton.TextSize = 12
    inventoryButton.Parent = content
    round(inventoryButton, 8)
    stroke(inventoryButton, Color3.fromRGB(30, 181, 216), 0.18)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -4, 0, 12)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Bold
    statusLabel.TextSize = 10
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = content

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(1, -4, 0, 30)
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
    saveButton.TextSize = 11
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
    publicProfileButton.TextSize = 11
    publicProfileButton.Parent = actions
    round(publicProfileButton, 8)
    stroke(publicProfileButton, Color3.fromRGB(43, 64, 84), 0.22)

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
