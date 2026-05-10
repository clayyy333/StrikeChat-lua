local LeftPanel = {}

function LeftPanel.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")

    local avatar = Instance.new("Frame")
    avatar.Name = "AvatarPlaceholder"
    avatar.Size = UDim2.new(0, 68, 0, 68)
    avatar.Position = UDim2.new(0, 14, 0, 14)
    avatar.BackgroundColor3 = Theme.Colors.PanelLight
    avatar.BorderSizePixel = 0
    avatar.Parent = parent

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 14)
    avatarCorner.Parent = avatar

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatar

    local avatarImageCorner = Instance.new("UICorner")
    avatarImageCorner.CornerRadius = UDim.new(0, 14)
    avatarImageCorner.Parent = avatarImage

    local success, content = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size420x420
        )
    end)

    if success then
        avatarImage.Image = content
    end

    local onlineDot = Instance.new("Frame")
    onlineDot.Name = "OnlineDot"
    onlineDot.Size = UDim2.new(0, 12, 0, 12)
    onlineDot.Position = UDim2.new(1, -10, 1, -10)
    onlineDot.BackgroundColor3 = Theme.Colors.Success
    onlineDot.BorderSizePixel = 0
    onlineDot.ZIndex = 3
    onlineDot.Parent = avatar

    local onlineCorner = Instance.new("UICorner")
    onlineCorner.CornerRadius = UDim.new(1, 0)
    onlineCorner.Parent = onlineDot

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -104, 0, 24)
    displayName.Position = UDim2.new(0, 92, 0, 18)
    displayName.BackgroundTransparency = 1
    displayName.Text = tostring(profile.display_name or player.DisplayName)
    displayName.TextColor3 = Theme.Colors.Text
    displayName.Font = Theme.Font.Bold
    displayName.TextSize = 15
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.Parent = parent

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -104, 0, 20)
    username.Position = UDim2.new(0, 92, 0, 42)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Regular
    username.TextSize = 12
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.Parent = parent

    local pointsBox = Instance.new("Frame")
    pointsBox.Name = "PointsBox"
    pointsBox.Size = UDim2.new(1, -28, 0, 54)
    pointsBox.Position = UDim2.new(0, 14, 0, 92)
    pointsBox.BackgroundColor3 = Theme.Colors.Panel
    pointsBox.BorderSizePixel = 0
    pointsBox.Parent = parent

    local pointsCorner = Instance.new("UICorner")
    pointsCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    pointsCorner.Parent = pointsBox

    local pointsTitle = Instance.new("TextLabel")
    pointsTitle.Size = UDim2.new(1, -16, 0, 20)
    pointsTitle.Position = UDim2.new(0, 10, 0, 6)
    pointsTitle.BackgroundTransparency = 1
    pointsTitle.Text = "Puntos de Jugador"
    pointsTitle.TextColor3 = Theme.Colors.TextMuted
    pointsTitle.Font = Theme.Font.Regular
    pointsTitle.TextSize = 11
    pointsTitle.TextXAlignment = Enum.TextXAlignment.Left
    pointsTitle.Parent = pointsBox

    local pointsValue = Instance.new("TextLabel")
    pointsValue.Size = UDim2.new(1, -16, 0, 24)
    pointsValue.Position = UDim2.new(0, 8, 0, 25)
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(profile.personal_points or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 17
    pointsValue.TextXAlignment = Enum.TextXAlignment.Center
    pointsValue.Parent = pointsBox

    local createdButtons = {}

    local function createTopButton(name, text, icon, size, position)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Button"
        btn.Size = size
        btn.Position = position
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = ""
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -36, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.Colors.Text
        label.Font = Theme.Font.Bold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = btn

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 24, 1, 0)
        iconLabel.Position = UDim2.new(1, -30, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Theme.Colors.Text
        iconLabel.Font = Theme.Font.Bold
        iconLabel.TextSize = 14
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = btn

        createdButtons[name] = btn
        return btn
    end

    local function createMenuButton(name, text, icon, y)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Button"
        btn.Size = UDim2.new(1, -36, 0, 32)
        btn.Position = UDim2.new(0, 18, 0, y)
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = ""
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -58, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.Colors.Text
        label.Font = Theme.Font.Bold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = btn

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 26, 1, 0)
        iconLabel.Position = UDim2.new(1, -38, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Theme.Colors.Text
        iconLabel.Font = Theme.Font.Bold
        iconLabel.TextSize = 14
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = btn

        createdButtons[name] = btn
        return btn
    end

    createTopButton(
        "Tienda",
        "Tienda",
        "🛒",
        UDim2.new(0.5, -19, 0, 32),
        UDim2.new(0, 14, 0, 158)
    )

    createTopButton(
        "Perfil",
        "Perfil",
        "👤",
        UDim2.new(0.5, -19, 0, 32),
        UDim2.new(0.5, 5, 0, 158)
    )

    createMenuButton("CrearSalas", "Crear Sala", "+", 204)
    createMenuButton("SalasPublicas", "Salas Públicas", "🌐", 244)
    createMenuButton("SalasPrivadas", "Salas Privadas", "🔒", 284)
    createMenuButton("TablaClanes", "Tabla de Clanes", "🏆", 324)

    return {
        Avatar = avatar,
        DisplayName = displayName,
        Username = username,
        PointsValue = pointsValue,
        Buttons = createdButtons
    }
end

return LeftPanel