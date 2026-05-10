local LeftPanel = {}

function LeftPanel.Create(parent, Theme, profile, player)
    local avatar = Instance.new("Frame")
    avatar.Name = "AvatarPlaceholder"
    avatar.Size = UDim2.new(0, 64, 0, 64)
    avatar.Position = UDim2.new(0, 14, 0, 14)
    avatar.BackgroundColor3 = Theme.Colors.PanelLight
    avatar.BorderSizePixel = 0
    avatar.Parent = parent

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 14)
    avatarCorner.Parent = avatar

    local avatarText = Instance.new("TextLabel")
    avatarText.Size = UDim2.new(1, 0, 1, 0)
    avatarText.BackgroundTransparency = 1
    avatarText.Text = "👤"
    avatarText.TextColor3 = Theme.Colors.Text
    avatarText.Font = Theme.Font.Bold
    avatarText.TextSize = 24
    avatarText.Parent = avatar

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -96, 0, 24)
    displayName.Position = UDim2.new(0, 88, 0, 18)
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
    username.Size = UDim2.new(1, -96, 0, 20)
    username.Position = UDim2.new(0, 88, 0, 42)
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
    pointsBox.Position = UDim2.new(0, 14, 0, 94)
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
    pointsValue.Position = UDim2.new(0, 10, 0, 25)
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(profile.personal_points or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 17
    pointsValue.TextXAlignment = Enum.TextXAlignment.Left
    pointsValue.Parent = pointsBox

    local topButtons = {
        {
            name = "Perfil",
            icon = "👤",
            x = 14
        },
        {
            name = "Tienda",
            icon = "🛒",
            x = 116
        }
    }

    local createdButtons = {}

    for _, data in ipairs(topButtons) do
        local btn = Instance.new("TextButton")
        btn.Name = data.name .. "Button"
        btn.Size = UDim2.new(0, 88, 0, 36)
        btn.Position = UDim2.new(0, data.x, 0, 162)
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = data.icon .. "  " .. data.name
        btn.TextColor3 = Theme.Colors.Text
        btn.Font = Theme.Font.Bold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = parent

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.Parent = btn

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        createdButtons[data.name] = btn
    end

    local menuButtons = {
        {
            text = "+  Salas",
            y = 214
        },
        {
            text = "🌐  Salas Públicas",
            y = 258
        },
        {
            text = "🔒  Salas Privadas",
            y = 302
        },
        {
            text = "🏆  Tabla de Clanes",
            y = 346
        }
    }

    for _, data in ipairs(menuButtons) do
        local btn = Instance.new("TextButton")
        btn.Name = data.text .. "Button"
        btn.Size = UDim2.new(1, -28, 0, 36)
        btn.Position = UDim2.new(0, 14, 0, data.y)
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = data.text
        btn.TextColor3 = Theme.Colors.Text
        btn.Font = Theme.Font.Bold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = parent

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 12)
        padding.Parent = btn

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        createdButtons[data.text] = btn
    end

    return {
        Avatar = avatar,
        DisplayName = displayName,
        Username = username,
        PointsValue = pointsValue,
        Buttons = createdButtons
    }
end

return LeftPanel