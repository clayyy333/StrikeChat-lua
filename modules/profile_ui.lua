local ProfileUI = {}

function ProfileUI.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")

    local gui = Instance.new("ScreenGui")
    gui.Name = "ProfileUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0.86, 0, 0.82, 0)
    root.Position = UDim2.new(0.5, 0, 0.52, 0)
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.BackgroundColor3 = Theme.Colors.Panel
    root.BorderSizePixel = 0
    root.Parent = gui

    local rootSize = Instance.new("UISizeConstraint")
    rootSize.MinSize = Vector2.new(320, 420)
    rootSize.MaxSize = Vector2.new(620, 640)
    rootSize.Parent = root

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    rootCorner.Parent = root

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color = Theme.Colors.Border
    rootStroke.Thickness = 1
    rootStroke.Transparency = 0.2
    rootStroke.Parent = root

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -72, 0, 36)
    title.Position = UDim2.new(0, 18, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Perfil"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = root

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 34, 0, 30)
    closeButton.Position = UDim2.new(1, -46, 0, 12)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 13
    closeButton.Parent = root

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = closeButton

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -28, 1, -68)
    content.Position = UDim2.new(0, 14, 0, 52)
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
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = content

    local function createBox(name, height)
        local box = Instance.new("Frame")
        box.Name = name
        box.Size = UDim2.new(1, -8, 0, height)
        box.BackgroundColor3 = Theme.Colors.Background
        box.BorderSizePixel = 0
        box.Parent = content

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        corner.Parent = box

        return box
    end

    local banner = createBox("Banner", 72)
    banner.BackgroundColor3 = Theme.Colors.PanelLight

    local bannerText = Instance.new("TextLabel")
    bannerText.Size = UDim2.new(1, -20, 1, 0)
    bannerText.Position = UDim2.new(0, 10, 0, 0)
    bannerText.BackgroundTransparency = 1
    bannerText.Text = "Banner de perfil"
    bannerText.TextColor3 = Theme.Colors.TextMuted
    bannerText.Font = Theme.Font.Bold
    bannerText.TextSize = 12
    bannerText.TextXAlignment = Enum.TextXAlignment.Left
    bannerText.Parent = banner

    local header = createBox("Header", 112)

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 78, 0, 78)
    avatarFrame.Position = UDim2.new(0, 12, 0, 16)
    avatarFrame.BackgroundColor3 = Theme.Colors.PanelLight
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = header

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 12)
    avatarCorner.Parent = avatarFrame

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatarFrame

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 12)
    imageCorner.Parent = avatarImage

    local success, image = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size180x180
        )
    end)

    if success then
        avatarImage.Image = image
    end

    local displayInput = Instance.new("TextBox")
    displayInput.Name = "DisplayNameInput"
    displayInput.Size = UDim2.new(1, -112, 0, 34)
    displayInput.Position = UDim2.new(0, 102, 0, 16)
    displayInput.BackgroundColor3 = Theme.Colors.PanelLight
    displayInput.BorderSizePixel = 0
    displayInput.Text = tostring(profile.display_name or player.DisplayName)
    displayInput.PlaceholderText = "Display Name"
    displayInput.TextColor3 = Theme.Colors.Text
    displayInput.PlaceholderColor3 = Theme.Colors.TextMuted
    displayInput.Font = Theme.Font.Bold
    displayInput.TextSize = 14
    displayInput.TextXAlignment = Enum.TextXAlignment.Left
    displayInput.ClearTextOnFocus = false
    displayInput.Parent = header

    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    displayCorner.Parent = displayInput

    local displayPadding = Instance.new("UIPadding")
    displayPadding.PaddingLeft = UDim.new(0, 10)
    displayPadding.PaddingRight = UDim.new(0, 10)
    displayPadding.Parent = displayInput

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -112, 0, 20)
    username.Position = UDim2.new(0, 104, 0, 52)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Regular
    username.TextSize = 12
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.Parent = header

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(1, -112, 0, 22)
    status.Position = UDim2.new(0, 104, 0, 76)
    status.BackgroundTransparency = 1
    status.Text = "Jugando a Metro Life RP"
    status.TextColor3 = Theme.Colors.Text
    status.Font = Theme.Font.Bold
    status.TextSize = 12
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.Parent = header

    local infoBox = createBox("InfoBox", 92)

    local clanLabel = Instance.new("TextLabel")
    clanLabel.Name = "ClanLabel"
    clanLabel.Size = UDim2.new(1, -20, 0, 26)
    clanLabel.Position = UDim2.new(0, 10, 0, 8)
    clanLabel.BackgroundColor3 = Theme.Colors.PanelLight
    clanLabel.BorderSizePixel = 0
    clanLabel.Text = "Clan: " .. tostring(profile.clan_name or "Sin clan")
    clanLabel.TextColor3 = Theme.Colors.Text
    clanLabel.Font = Theme.Font.Bold
    clanLabel.TextSize = 12
    clanLabel.TextXAlignment = Enum.TextXAlignment.Left
    clanLabel.Parent = infoBox

    local clanCorner = Instance.new("UICorner")
    clanCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    clanCorner.Parent = clanLabel

    local clanPadding = Instance.new("UIPadding")
    clanPadding.PaddingLeft = UDim.new(0, 10)
    clanPadding.PaddingRight = UDim.new(0, 10)
    clanPadding.Parent = clanLabel

    local pointsLabel = Instance.new("TextLabel")
    pointsLabel.Name = "PointsLabel"
    pointsLabel.Size = UDim2.new(1, -20, 0, 26)
    pointsLabel.Position = UDim2.new(0, 10, 0, 42)
    pointsLabel.BackgroundColor3 = Theme.Colors.PanelLight
    pointsLabel.BorderSizePixel = 0
    pointsLabel.Text = "Puntos: " .. tostring(profile.personal_points or 0)
    pointsLabel.TextColor3 = Theme.Colors.Text
    pointsLabel.Font = Theme.Font.Bold
    pointsLabel.TextSize = 12
    pointsLabel.TextXAlignment = Enum.TextXAlignment.Left
    pointsLabel.Parent = infoBox

    local pointsCorner = Instance.new("UICorner")
    pointsCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    pointsCorner.Parent = pointsLabel

    local pointsPadding = Instance.new("UIPadding")
    pointsPadding.PaddingLeft = UDim.new(0, 10)
    pointsPadding.PaddingRight = UDim.new(0, 10)
    pointsPadding.Parent = pointsLabel

    local visibilityBox = createBox("VisibilityBox", 56)

    local visibilityTitle = Instance.new("TextLabel")
    visibilityTitle.Size = UDim2.new(0.34, -8, 1, 0)
    visibilityTitle.Position = UDim2.new(0, 10, 0, 0)
    visibilityTitle.BackgroundTransparency = 1
    visibilityTitle.Text = "Estado"
    visibilityTitle.TextColor3 = Theme.Colors.TextMuted
    visibilityTitle.Font = Theme.Font.Bold
    visibilityTitle.TextSize = 12
    visibilityTitle.TextXAlignment = Enum.TextXAlignment.Left
    visibilityTitle.Parent = visibilityBox

    local selectedVisibility = profile.game_status_visibility or "public"

    local publicButton = Instance.new("TextButton")
    publicButton.Name = "PublicButton"
    publicButton.Size = UDim2.new(0.33, -8, 0, 32)
    publicButton.Position = UDim2.new(0.34, 4, 0, 12)
    publicButton.BorderSizePixel = 0
    publicButton.Text = "Publico"
    publicButton.TextColor3 = Theme.Colors.Text
    publicButton.Font = Theme.Font.Bold
    publicButton.TextSize = 12
    publicButton.Parent = visibilityBox

    local privateButton = Instance.new("TextButton")
    privateButton.Name = "PrivateButton"
    privateButton.Size = UDim2.new(0.33, -8, 0, 32)
    privateButton.Position = UDim2.new(0.67, 4, 0, 12)
    privateButton.BorderSizePixel = 0
    privateButton.Text = "Privado"
    privateButton.TextColor3 = Theme.Colors.Text
    privateButton.Font = Theme.Font.Bold
    privateButton.TextSize = 12
    privateButton.Parent = visibilityBox

    local publicCorner = Instance.new("UICorner")
    publicCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    publicCorner.Parent = publicButton

    local privateCorner = Instance.new("UICorner")
    privateCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    privateCorner.Parent = privateButton

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

    local descriptionBox = createBox("DescriptionBox", 118)

    local descriptionTitle = Instance.new("TextLabel")
    descriptionTitle.Size = UDim2.new(1, -20, 0, 22)
    descriptionTitle.Position = UDim2.new(0, 10, 0, 8)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.Text = "Descripcion"
    descriptionTitle.TextColor3 = Theme.Colors.TextMuted
    descriptionTitle.Font = Theme.Font.Bold
    descriptionTitle.TextSize = 12
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    descriptionTitle.Parent = descriptionBox

    local descriptionInput = Instance.new("TextBox")
    descriptionInput.Name = "DescriptionInput"
    descriptionInput.Size = UDim2.new(1, -20, 0, 72)
    descriptionInput.Position = UDim2.new(0, 10, 0, 34)
    descriptionInput.BackgroundColor3 = Theme.Colors.PanelLight
    descriptionInput.BorderSizePixel = 0
    descriptionInput.Text = tostring(profile.bio or "")
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

    local descriptionCorner = Instance.new("UICorner")
    descriptionCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    descriptionCorner.Parent = descriptionInput

    local descriptionPadding = Instance.new("UIPadding")
    descriptionPadding.PaddingTop = UDim.new(0, 8)
    descriptionPadding.PaddingLeft = UDim.new(0, 10)
    descriptionPadding.PaddingRight = UDim.new(0, 10)
    descriptionPadding.PaddingBottom = UDim.new(0, 8)
    descriptionPadding.Parent = descriptionInput

    descriptionInput:GetPropertyChangedSignal("Text"):Connect(function()
        if #descriptionInput.Text > 120 then
            descriptionInput.Text = string.sub(descriptionInput.Text, 1, 120)
        end
    end)

    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(1, -8, 0, 36)
    inventoryButton.BackgroundColor3 = Theme.Colors.PanelLight
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "Ver Inventario"
    inventoryButton.TextColor3 = Theme.Colors.Text
    inventoryButton.Font = Theme.Font.Bold
    inventoryButton.TextSize = 13
    inventoryButton.Parent = content

    local inventoryCorner = Instance.new("UICorner")
    inventoryCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    inventoryCorner.Parent = inventoryButton

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -8, 0, 22)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Bold
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = content

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(1, -8, 0, 38)
    actions.BackgroundTransparency = 1
    actions.Parent = content

    local saveButton = Instance.new("TextButton")
    saveButton.Name = "SaveButton"
    saveButton.Size = UDim2.new(0.5, -5, 1, 0)
    saveButton.Position = UDim2.new(0, 0, 0, 0)
    saveButton.BackgroundColor3 = Theme.Colors.Accent
    saveButton.BorderSizePixel = 0
    saveButton.Text = "Guardar Cambios"
    saveButton.TextColor3 = Theme.Colors.Text
    saveButton.Font = Theme.Font.Bold
    saveButton.TextSize = 12
    saveButton.Parent = actions

    local publicProfileButton = Instance.new("TextButton")
    publicProfileButton.Name = "PublicProfileButton"
    publicProfileButton.Size = UDim2.new(0.5, -5, 1, 0)
    publicProfileButton.Position = UDim2.new(0.5, 5, 0, 0)
    publicProfileButton.BackgroundColor3 = Theme.Colors.PanelLight
    publicProfileButton.BorderSizePixel = 0
    publicProfileButton.Text = "Ver Perfil Publico"
    publicProfileButton.TextColor3 = Theme.Colors.Text
    publicProfileButton.Font = Theme.Font.Bold
    publicProfileButton.TextSize = 12
    publicProfileButton.Parent = actions

    local saveCorner = Instance.new("UICorner")
    saveCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    saveCorner.Parent = saveButton

    local publicProfileCorner = Instance.new("UICorner")
    publicProfileCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    publicProfileCorner.Parent = publicProfileButton

    task.defer(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 18)
    end)

    return {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        SaveButton = saveButton,
        PublicProfileButton = publicProfileButton,
        InventoryButton = inventoryButton,
        StatusLabel = statusLabel,

        GetChanges = function()
            return {
                display_name = displayInput.Text,
                bio = descriptionInput.Text,
                game_status_visibility = selectedVisibility
            }
        end,

        ApplyProfile = function(nextProfile)
            profile = nextProfile or profile
            displayInput.Text = tostring(profile.display_name or player.DisplayName)
            descriptionInput.Text = tostring(profile.bio or "")
            selectedVisibility = profile.game_status_visibility or "public"
            pointsLabel.Text = "Puntos: " .. tostring(profile.personal_points or 0)
            clanLabel.Text = "Clan: " .. tostring(profile.clan_name or "Sin clan")
            updateVisibilityButtons()
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
