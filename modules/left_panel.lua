local LeftPanel = {}

function LeftPanel.Create(parent, Theme, profile, player)
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

    local avatarText = Instance.new("TextLabel")
    avatarText.Size = UDim2.new(1, 0, 1, 0)
    avatarText.BackgroundTransparency = 1
    avatarText.Text = "👤"
    avatarText.TextColor3 = Theme.Colors.Text
    avatarText.Font = Theme.Font.Bold
    avatarText.TextSize = 25
    avatarText.Parent = avatar

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
    pointsBox.Position = UDim2.new(0, 14, 0, 98)
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

    local function createButton(name, text, icon, size, position)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Button"
        btn.Size = size
        btn.Position = position
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = text .. "  " .. icon
        btn.TextColor3 = Theme.Colors.Text
        btn.Font = Theme.Font.Bold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        createdButtons[name] = btn
        return btn
    end

    createButton(
        "Tienda",
        "Tienda",
        "🛒",
        UDim2.new(0.5, -19, 0, 32),
        UDim2.new(0, 14, 0, 166)
    )

    createButton(
        "Perfil",
        "Perfil",
        "👤",
        UDim2.new(0.5, -19, 0, 32),
        UDim2.new(0.5, 5, 0, 166)
    )

    local menuButtons = {
        {
            name = "CrearSalas",
            text = "+  Salas",
            y = 214
        },
        {
            name = "SalasPublicas",
            text = "Salas Públicas  🌐",
            y = 254
        },
        {
            name = "SalasPrivadas",
            text = "Salas Privadas  🔒",
            y = 294
        },
        {
            name = "TablaClanes",
            text = "Tabla de Clanes  🏆",
            y = 334
        }
    }

    for _, data in ipairs(menuButtons) do
        local btn = Instance.new("TextButton")
        btn.Name = data.name .. "Button"
        btn.Size = UDim2.new(1, -36, 0, 32)
        btn.Position = UDim2.new(0, 18, 0, data.y)
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = data.text
        btn.TextColor3 = Theme.Colors.Text
        btn.Font = Theme.Font.Bold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        createdButtons[data.name] = btn
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