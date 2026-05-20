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
    root.Size = UDim2.new(0.72, 0, 0.72, 0)
    root.Position = UDim2.new(0.5, 0, 0.52, 0)
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.BackgroundColor3 = Theme.Colors.Panel
    root.BorderSizePixel = 0
    root.Parent = gui

    local rootSize = Instance.new("UISizeConstraint")
    rootSize.MinSize = Vector2.new(300, 390)
    rootSize.MaxSize = Vector2.new(520, 560)
    rootSize.Parent = root

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    rootCorner.Parent = root

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color = Theme.Colors.Border
    rootStroke.Thickness = 1
    rootStroke.Transparency = 0.18
    rootStroke.Parent = root

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 42)
    topBar.BackgroundTransparency = 1
    topBar.Parent = root

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Perfil"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -42, 0, 7)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.Parent = topBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = closeButton

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -24, 1, -52)
    content.Position = UDim2.new(0, 12, 0, 44)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Parent = root

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 3)
    padding.PaddingRight = UDim.new(0, 3)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = content

    local function round(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or Theme.Radius.Button)
        corner.Parent = instance
        return corner
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

    local function makePanel(name, height)
        local panel = Instance.new("Frame")
        panel.Name = name
        panel.Size = UDim2.new(1, -6, 0, height)
        panel.BackgroundColor3 = Theme.Colors.Background
        panel.BorderSizePixel = 0
        panel.Parent = content
        round(panel)
        return panel
    end

    local header = makePanel("Header", 138)
    header.ClipsDescendants = true

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 82)
    banner.BackgroundColor3 = Theme.Colors.PanelLight
    banner.BorderSizePixel = 0
    banner.Parent = header

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Colors.Accent),
        ColorSequenceKeypoint.new(0.55, Theme.Colors.PanelLight),
        ColorSequenceKeypoint.new(1, Theme.Colors.Background)
    })
    bannerGradient.Rotation = 24
    bannerGradient.Parent = banner

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 74, 0, 74)
    avatarFrame.Position = UDim2.new(0, 14, 0, 46)
    avatarFrame.BackgroundColor3 = Theme.Colors.Panel
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = header
    round(avatarFrame, 14)

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Theme.Colors.Panel
    avatarStroke.Thickness = 3
    avatarStroke.Parent = avatarFrame

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -6, 1, -6)
    avatarImage.Position = UDim2.new(0, 3, 0, 3)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatarFrame
    round(avatarImage, 12)

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
    displayInput.Size = UDim2.new(1, -112, 0, 30)
    displayInput.Position = UDim2.new(0, 100, 0, 54)
    displayInput.BackgroundColor3 = Theme.Colors.Panel
    displayInput.BackgroundTransparency = 0.08
    displayInput.BorderSizePixel = 0
    displayInput.Text = original.display_name
    displayInput.PlaceholderText = "Display Name"
    displayInput.TextColor3 = Theme.Colors.Text
    displayInput.PlaceholderColor3 = Theme.Colors.TextMuted
    displayInput.Font = Theme.Font.Bold
    displayInput.TextSize = 14
    displayInput.TextXAlignment = Enum.TextXAlignment.Left
    displayInput.ClearTextOnFocus = false
    displayInput.Parent = header
    round(displayInput, 8)
    addPadding(displayInput, 10, 10)

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -112, 0, 18)
    username.Position = UDim2.new(0, 102, 0, 86)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Regular
    username.TextSize = 11
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.Parent = header

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(1, -112, 0, 20)
    status.Position = UDim2.new(0, 102, 0, 105)
    status.BackgroundTransparency = 1
    status.Text = "Jugando a Metro Life RP"
    status.TextColor3 = Theme.Colors.Text
    status.Font = Theme.Font.Bold
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.Parent = header

    local publicView = makePanel("PublicView", 190)
    publicView.Visible = false

    local publicTitle = Instance.new("TextLabel")
    publicTitle.Name = "PublicTitle"
    publicTitle.Size = UDim2.new(1, -20, 0, 24)
    publicTitle.Position = UDim2.new(0, 10, 0, 8)
    publicTitle.BackgroundTransparency = 1
    publicTitle.Text = "Vista publica"
    publicTitle.TextColor3 = Theme.Colors.Text
    publicTitle.Font = Theme.Font.Bold
    publicTitle.TextSize = 14
    publicTitle.TextXAlignment = Enum.TextXAlignment.Left
    publicTitle.Parent = publicView

    local publicName = Instance.new("TextLabel")
    publicName.Name = "PublicName"
    publicName.Size = UDim2.new(1, -20, 0, 26)
    publicName.Position = UDim2.new(0, 10, 0, 36)
    publicName.BackgroundTransparency = 1
    publicName.Text = ""
    publicName.TextColor3 = Theme.Colors.Text
    publicName.Font = Theme.Font.Bold
    publicName.TextSize = 16
    publicName.TextXAlignment = Enum.TextXAlignment.Center
    publicName.TextTruncate = Enum.TextTruncate.AtEnd
    publicName.Parent = publicView

    local publicUsername = Instance.new("TextLabel")
    publicUsername.Name = "PublicUsername"
    publicUsername.Size = UDim2.new(1, -20, 0, 18)
    publicUsername.Position = UDim2.new(0, 10, 0, 62)
    publicUsername.BackgroundTransparency = 1
    publicUsername.Text = ""
    publicUsername.TextColor3 = Theme.Colors.TextMuted
    publicUsername.Font = Theme.Font.Regular
    publicUsername.TextSize = 11
    publicUsername.TextXAlignment = Enum.TextXAlignment.Center
    publicUsername.TextTruncate = Enum.TextTruncate.AtEnd
    publicUsername.Parent = publicView

    local publicStatus = Instance.new("TextLabel")
    publicStatus.Name = "PublicStatus"
    publicStatus.Size = UDim2.new(1, -20, 0, 20)
    publicStatus.Position = UDim2.new(0, 10, 0, 82)
    publicStatus.BackgroundTransparency = 1
    publicStatus.Text = "Jugando a Metro Life RP"
    publicStatus.TextColor3 = Theme.Colors.Text
    publicStatus.Font = Theme.Font.Bold
    publicStatus.TextSize = 11
    publicStatus.TextXAlignment = Enum.TextXAlignment.Center
    publicStatus.Parent = publicView

    local publicInfo = Instance.new("TextLabel")
    publicInfo.Name = "PublicInfo"
    publicInfo.Size = UDim2.new(1, -20, 0, 32)
    publicInfo.Position = UDim2.new(0, 10, 0, 108)
    publicInfo.BackgroundColor3 = Theme.Colors.PanelLight
    publicInfo.BorderSizePixel = 0
    publicInfo.Text = ""
    publicInfo.TextColor3 = Theme.Colors.Text
    publicInfo.Font = Theme.Font.Bold
    publicInfo.TextSize = 12
    publicInfo.TextXAlignment = Enum.TextXAlignment.Center
    publicInfo.Parent = publicView
    round(publicInfo, 8)

    local publicBio = Instance.new("TextLabel")
    publicBio.Name = "PublicBio"
    publicBio.Size = UDim2.new(1, -20, 0, 34)
    publicBio.Position = UDim2.new(0, 10, 0, 146)
    publicBio.BackgroundTransparency = 1
    publicBio.Text = ""
    publicBio.TextColor3 = Theme.Colors.TextMuted
    publicBio.Font = Theme.Font.Regular
    publicBio.TextSize = 11
    publicBio.TextWrapped = true
    publicBio.TextXAlignment = Enum.TextXAlignment.Center
    publicBio.TextYAlignment = Enum.TextYAlignment.Top
    publicBio.Parent = publicView

    local infoBox = makePanel("InfoBox", 76)

    local function createInfoRow(y, labelText, valueText)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -18, 0, 28)
        row.Position = UDim2.new(0, 9, 0, y)
        row.BackgroundColor3 = Theme.Colors.PanelLight
        row.BorderSizePixel = 0
        row.Parent = infoBox
        round(row, 8)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.38, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.Colors.TextMuted
        label.Font = Theme.Font.Bold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.62, -12, 1, 0)
        value.Position = UDim2.new(0.38, 2, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = valueText
        value.TextColor3 = Theme.Colors.Text
        value.Font = Theme.Font.Bold
        value.TextSize = 12
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.Parent = row

        return value
    end

    local clanValue = createInfoRow(8, "Clan", tostring(profile.clan_name or "Sin clan"))
    local pointsValue = createInfoRow(42, "Puntos", tostring(profile.personal_points or 0))

    local visibilityBox = makePanel("VisibilityBox", 48)

    local visibilityTitle = Instance.new("TextLabel")
    visibilityTitle.Size = UDim2.new(0.32, -8, 1, 0)
    visibilityTitle.Position = UDim2.new(0, 10, 0, 0)
    visibilityTitle.BackgroundTransparency = 1
    visibilityTitle.Text = "Estado"
    visibilityTitle.TextColor3 = Theme.Colors.TextMuted
    visibilityTitle.Font = Theme.Font.Bold
    visibilityTitle.TextSize = 12
    visibilityTitle.TextXAlignment = Enum.TextXAlignment.Left
    visibilityTitle.Parent = visibilityBox

    local selectedVisibility = original.game_status_visibility

    local publicButton = Instance.new("TextButton")
    publicButton.Name = "PublicButton"
    publicButton.Size = UDim2.new(0.33, -8, 0, 28)
    publicButton.Position = UDim2.new(0.34, 2, 0, 10)
    publicButton.BorderSizePixel = 0
    publicButton.Text = "Publico"
    publicButton.TextColor3 = Theme.Colors.Text
    publicButton.Font = Theme.Font.Bold
    publicButton.TextSize = 11
    publicButton.Parent = visibilityBox
    round(publicButton, 8)

    local privateButton = Instance.new("TextButton")
    privateButton.Name = "PrivateButton"
    privateButton.Size = UDim2.new(0.33, -8, 0, 28)
    privateButton.Position = UDim2.new(0.67, 2, 0, 10)
    privateButton.BorderSizePixel = 0
    privateButton.Text = "Privado"
    privateButton.TextColor3 = Theme.Colors.Text
    privateButton.Font = Theme.Font.Bold
    privateButton.TextSize = 11
    privateButton.Parent = visibilityBox
    round(privateButton, 8)

    local function updateVisibilityButtons()
        publicButton.BackgroundColor3 =
            selectedVisibility == "public" and Theme.Colors.Accent or Theme.Colors.PanelLight
        privateButton.BackgroundColor3 =
            selectedVisibility == "private" and Theme.Colors.Accent or Theme.Colors.PanelLight
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

    local descriptionBox = makePanel("DescriptionBox", 102)

    local descriptionTitle = Instance.new("TextLabel")
    descriptionTitle.Size = UDim2.new(1, -18, 0, 20)
    descriptionTitle.Position = UDim2.new(0, 9, 0, 6)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.Text = "Descripcion"
    descriptionTitle.TextColor3 = Theme.Colors.TextMuted
    descriptionTitle.Font = Theme.Font.Bold
    descriptionTitle.TextSize = 12
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    descriptionTitle.Parent = descriptionBox

    local descriptionInput = Instance.new("TextBox")
    descriptionInput.Name = "DescriptionInput"
    descriptionInput.Size = UDim2.new(1, -18, 0, 66)
    descriptionInput.Position = UDim2.new(0, 9, 0, 28)
    descriptionInput.BackgroundColor3 = Theme.Colors.PanelLight
    descriptionInput.BorderSizePixel = 0
    descriptionInput.Text = original.bio
    descriptionInput.PlaceholderText = "Escribe una descripcion corta"
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
    addPadding(descriptionInput, 9, 9, 7, 7)

    descriptionInput:GetPropertyChangedSignal("Text"):Connect(function()
        if #descriptionInput.Text > 120 then
            descriptionInput.Text = string.sub(descriptionInput.Text, 1, 120)
        end
    end)

    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(1, -6, 0, 32)
    inventoryButton.BackgroundColor3 = Theme.Colors.PanelLight
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "Ver Inventario"
    inventoryButton.TextColor3 = Theme.Colors.Text
    inventoryButton.Font = Theme.Font.Bold
    inventoryButton.TextSize = 12
    inventoryButton.Parent = content
    round(inventoryButton, 8)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -6, 0, 20)
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
    actions.Size = UDim2.new(1, -6, 0, 34)
    actions.BackgroundTransparency = 1
    actions.Parent = content

    local saveButton = Instance.new("TextButton")
    saveButton.Name = "SaveButton"
    saveButton.Size = UDim2.new(0.5, -4, 1, 0)
    saveButton.BackgroundColor3 = Theme.Colors.Accent
    saveButton.BorderSizePixel = 0
    saveButton.Text = "Guardar Cambios"
    saveButton.TextColor3 = Theme.Colors.Text
    saveButton.Font = Theme.Font.Bold
    saveButton.TextSize = 11
    saveButton.Parent = actions
    round(saveButton, 8)

    local publicProfileButton = Instance.new("TextButton")
    publicProfileButton.Name = "PublicProfileButton"
    publicProfileButton.Size = UDim2.new(0.5, -4, 1, 0)
    publicProfileButton.Position = UDim2.new(0.5, 4, 0, 0)
    publicProfileButton.BackgroundColor3 = Theme.Colors.PanelLight
    publicProfileButton.BorderSizePixel = 0
    publicProfileButton.Text = "Ver Perfil Publico"
    publicProfileButton.TextColor3 = Theme.Colors.Text
    publicProfileButton.Font = Theme.Font.Bold
    publicProfileButton.TextSize = 11
    publicProfileButton.Parent = actions
    round(publicProfileButton, 8)

    local function refreshCanvas()
        task.defer(function()
            content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
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
        end,

        ShowPublicProfile = function(publicProfile)
            if not publicProfile then
                return
            end

            publicView.Visible = true
            publicName.Text = tostring(publicProfile.display_name or "Usuario")
            publicUsername.Text = "@" .. tostring(publicProfile.roblox_username or player.Name)
            publicInfo.Text = "Clan: " .. tostring(publicProfile.clan_name or "Sin clan")
            publicBio.Text = tostring(publicProfile.bio or "Sin descripcion")
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
