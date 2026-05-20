local PublicProfileUI = {}

function PublicProfileUI.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")

    profile = profile or {}

    local overlay = Instance.new("Frame")
    overlay.Name = "PublicProfileOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.38
    overlay.ZIndex = 90
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0.84, 0, 0.76, 0)
    modal.Position = UDim2.new(0.5, 0, 0.52, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = Color3.fromRGB(16, 16, 30)
    modal.BorderSizePixel = 0
    modal.ZIndex = 91
    modal.Parent = overlay

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(310, 430)
    sizeConstraint.MaxSize = Vector2.new(470, 590)
    sizeConstraint.Parent = modal

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

    round(modal, Theme.Radius.Main)
    stroke(modal, Color3.fromRGB(75, 50, 126), 0.18)

    local modalGradient = Instance.new("UIGradient")
    modalGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 16, 34)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(15, 17, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 14, 26))
    })
    modalGradient.Rotation = 90
    modalGradient.Parent = modal

    local titleIcon = Instance.new("TextLabel")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 30, 0, 30)
    titleIcon.Position = UDim2.new(0, 16, 0, 12)
    titleIcon.BackgroundColor3 = Color3.fromRGB(128, 76, 242)
    titleIcon.BackgroundTransparency = 0.35
    titleIcon.BorderSizePixel = 0
    titleIcon.Text = ""
    titleIcon.ZIndex = 92
    titleIcon.Parent = modal
    round(titleIcon, 10)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -98, 0, 38)
    title.Position = UDim2.new(0, 54, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "PERFIL PUBLICO"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.ZIndex = 92
    title.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 34, 0, 28)
    closeButton.Position = UDim2.new(1, -48, 0, 12)
    closeButton.BackgroundTransparency = 1
    closeButton.BorderSizePixel = 0
    closeButton.Text = "..."
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 18
    closeButton.ZIndex = 92
    closeButton.Parent = modal

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -24, 1, -62)
    content.Position = UDim2.new(0, 12, 0, 52)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ZIndex = 92
    content.Parent = modal

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 2)
    padding.PaddingRight = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = content

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, -4, 0, 190)
    header.BackgroundColor3 = Color3.fromRGB(17, 17, 31)
    header.BorderSizePixel = 0
    header.ClipsDescendants = true
    header.ZIndex = 93
    header.Parent = content
    round(header, 12)
    stroke(header, Color3.fromRGB(78, 54, 132), 0.25)

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 1, 0)
    banner.BackgroundColor3 = Color3.fromRGB(17, 18, 31)
    banner.BorderSizePixel = 0
    banner.ZIndex = 94
    banner.Parent = header

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 29, 58)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(88, 42, 121)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(34, 31, 56)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 12, 24))
    })
    bannerGradient.Rotation = 18
    bannerGradient.Parent = banner

    local shade = Instance.new("Frame")
    shade.Name = "Shade"
    shade.Size = UDim2.new(1, 0, 1, 0)
    shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shade.BackgroundTransparency = 0.42
    shade.BorderSizePixel = 0
    shade.ZIndex = 95
    shade.Parent = header

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 118, 0, 118)
    avatarFrame.Position = UDim2.new(0, 24, 0, 32)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 34)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 96
    avatarFrame.Parent = header
    round(avatarFrame, 59)
    stroke(avatarFrame, Color3.fromRGB(152, 74, 255), 0.04)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -8, 1, -8)
    avatarImage.Position = UDim2.new(0, 4, 0, 4)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ZIndex = 97
    avatarImage.Parent = avatarFrame
    round(avatarImage, 55)

    local userId = tonumber(profile.roblox_user_id) or player.UserId
    local ok, image = pcall(function()
        return Players:GetUserThumbnailAsync(
            userId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size180x180
        )
    end)

    if ok then
        avatarImage.Image = image
    end

    local identityBox = Instance.new("Frame")
    identityBox.Name = "IdentityBox"
    identityBox.Size = UDim2.new(1, -174, 0, 92)
    identityBox.Position = UDim2.new(0, 154, 0, 48)
    identityBox.BackgroundColor3 = Color3.fromRGB(8, 9, 18)
    identityBox.BackgroundTransparency = 0.28
    identityBox.BorderSizePixel = 0
    identityBox.ZIndex = 96
    identityBox.Parent = header
    round(identityBox, 12)
    stroke(identityBox, Color3.fromRGB(78, 54, 132), 0.48)

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -18, 0, 30)
    displayName.Position = UDim2.new(0, 9, 0, 8)
    displayName.BackgroundTransparency = 1
    displayName.Text = tostring(profile.display_name or "Usuario")
    displayName.TextColor3 = Theme.Colors.Text
    displayName.Font = Theme.Font.Bold
    displayName.TextSize = 22
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.ZIndex = 97
    displayName.Parent = identityBox

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -18, 0, 20)
    username.Position = UDim2.new(0, 9, 0, 39)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Regular
    username.TextSize = 13
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = 97
    username.Parent = identityBox

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(1, -18, 0, 24)
    status.Position = UDim2.new(0, 9, 0, 61)
    status.BackgroundColor3 = Color3.fromRGB(14, 17, 29)
    status.BackgroundTransparency = 0.08
    status.BorderSizePixel = 0
    status.Text = "Jugando a Metro Life RP"
    status.TextColor3 = Theme.Colors.Text
    status.Font = Theme.Font.Bold
    status.TextSize = 12
    status.TextXAlignment = Enum.TextXAlignment.Center
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.ZIndex = 97
    status.Parent = identityBox
    round(status, 7)
    stroke(status, Color3.fromRGB(82, 70, 128), 0.48)

    local function makeInfoRow(name, labelText, valueText, height)
        local row = Instance.new("Frame")
        row.Name = name
        row.Size = UDim2.new(1, -4, 0, height or 56)
        row.BackgroundColor3 = Color3.fromRGB(18, 18, 34)
        row.BackgroundTransparency = 0.08
        row.BorderSizePixel = 0
        row.ZIndex = 93
        row.Parent = content
        round(row, 10)
        stroke(row, Color3.fromRGB(70, 53, 119), 0.36)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -22, 0, 24)
        label.Position = UDim2.new(0, 11, 0, 8)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.Colors.Text
        label.Font = Theme.Font.Bold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 94
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(1, -22, 0, 22)
        value.Position = UDim2.new(0, 11, 0, 30)
        value.BackgroundTransparency = 1
        value.Text = valueText
        value.TextColor3 = Theme.Colors.TextMuted
        value.Font = Theme.Font.Bold
        value.TextSize = 12
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.ZIndex = 94
        value.Parent = row

        return row, value
    end

    makeInfoRow(
        "ClanRow",
        "Nombre de Clan",
        tostring(profile.clan_name or "-")
    )

    makeInfoRow(
        "PointsRow",
        "Puntos de Usuario",
        "-"
    )

    local bioRow, bioValue = makeInfoRow(
        "BioRow",
        "Descripcion",
        tostring(profile.bio or "Sin descripcion"),
        78
    )

    bioValue.Size = UDim2.new(1, -22, 0, 38)
    bioValue.TextWrapped = true
    bioValue.TextXAlignment = Enum.TextXAlignment.Left
    bioValue.TextYAlignment = Enum.TextYAlignment.Top

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(1, -4, 0, 60)
    actions.BackgroundColor3 = Color3.fromRGB(17, 17, 31)
    actions.BackgroundTransparency = 0.18
    actions.BorderSizePixel = 0
    actions.ZIndex = 93
    actions.Parent = content
    round(actions, 10)
    stroke(actions, Color3.fromRGB(55, 43, 97), 0.52)

    local addButton = Instance.new("TextButton")
    addButton.Name = "AddButton"
    addButton.Size = UDim2.new(0.5, -8, 0, 38)
    addButton.Position = UDim2.new(0, 10, 0, 11)
    addButton.BackgroundColor3 = Color3.fromRGB(78, 36, 146)
    addButton.BackgroundTransparency = 0.03
    addButton.BorderSizePixel = 0
    addButton.Text = "Agregar"
    addButton.TextColor3 = Theme.Colors.Text
    addButton.Font = Theme.Font.Bold
    addButton.TextSize = 13
    addButton.ZIndex = 94
    addButton.Parent = actions
    round(addButton, 8)
    stroke(addButton, Color3.fromRGB(151, 80, 255), 0.12)

    local messageButton = Instance.new("TextButton")
    messageButton.Name = "MessageButton"
    messageButton.Size = UDim2.new(0.5, -8, 0, 38)
    messageButton.Position = UDim2.new(0.5, -2, 0, 11)
    messageButton.BackgroundColor3 = Color3.fromRGB(27, 29, 48)
    messageButton.BackgroundTransparency = 0.02
    messageButton.BorderSizePixel = 0
    messageButton.Text = "Enviar Mensaje"
    messageButton.TextColor3 = Theme.Colors.Text
    messageButton.Font = Theme.Font.Bold
    messageButton.TextSize = 13
    messageButton.ZIndex = 94
    messageButton.Parent = actions
    round(messageButton, 8)
    stroke(messageButton, Color3.fromRGB(55, 53, 84), 0.2)

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

    closeButton.MouseButton1Click:Connect(function()
        overlay:Destroy()
    end)

    return {
        Overlay = overlay,
        CloseButton = closeButton,

        Destroy = function()
            overlay:Destroy()
        end
    }
end

return PublicProfileUI
