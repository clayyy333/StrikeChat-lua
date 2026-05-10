local LeftPanel = {}

function LeftPanel.Create(parent, Theme, profile, player)
    local avatar = Instance.new("Frame")
    avatar.Name = "AvatarPlaceholder"
    avatar.Size = UDim2.new(0, 58, 0, 58)
    avatar.Position = UDim2.new(0, 14, 0, 14)
    avatar.BackgroundColor3 = Theme.Colors.PanelLight
    avatar.BorderSizePixel = 0
    avatar.Parent = parent

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
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
    displayName.Size = UDim2.new(1, -90, 0, 24)
    displayName.Position = UDim2.new(0, 82, 0, 16)
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
    username.Size = UDim2.new(1, -90, 0, 20)
    username.Position = UDim2.new(0, 82, 0, 40)
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
    pointsBox.Position = UDim2.new(0, 14, 0, 88)
    pointsBox.BackgroundColor3 = Theme.Colors.Panel
    pointsBox.BorderSizePixel = 0
    pointsBox.Parent = parent

    local pointsCorner = Instance.new("UICorner")
    pointsCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    pointsCorner.Parent = pointsBox

    local pointsTitle = Instance.new("TextLabel")
    pointsTitle.Size = UDim2.new(1, -16, 0, 20)
    pointsTitle.Position = UDim2.new(0, 8, 0, 6)
    pointsTitle.BackgroundTransparency = 1
    pointsTitle.Text = "Puntos de Jugador"
    pointsTitle.TextColor3 = Theme.Colors.TextMuted
    pointsTitle.Font = Theme.Font.Regular
    pointsTitle.TextSize = 11
    pointsTitle.Parent = pointsBox

    local pointsValue = Instance.new("TextLabel")
    pointsValue.Size = UDim2.new(1, -16, 0, 24)
    pointsValue.Position = UDim2.new(0, 8, 0, 25)
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(profile.personal_points or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 17
    pointsValue.Parent = pointsBox

    local buttons = {
        {text = "Perfil", y = 156},
        {text = "Tienda", y = 200},
        {text = "Salas", y = 244},
        {text = "Clanes", y = 288}
    }

    local createdButtons = {}

    for _, data in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Name = data.text .. "Button"
        btn.Size = UDim2.new(1, -28, 0, 34)
        btn.Position = UDim2.new(0, 14, 0, data.y)
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = data.text
        btn.TextColor3 = Theme.Colors.Text
        btn.Font = Theme.Font.Bold
        btn.TextSize = 13
        btn.Parent = parent

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