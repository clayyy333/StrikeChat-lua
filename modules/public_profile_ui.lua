local PublicProfileUI = {}

function PublicProfileUI.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")

    profile = profile or {}

    local modalColor = Color3.fromRGB(50, 51, 57)
    local panelColor = Color3.fromRGB(57, 58, 65)
    local inputColor = Color3.fromRGB(48, 49, 55)
    local borderColor = Color3.fromRGB(80, 82, 92)

    local overlay = Instance.new("Frame")
    overlay.Name = "PublicProfileOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.ZIndex = 90
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0.78, 0, 0.72, 0)
    modal.Position = UDim2.new(0.5, 0, 0.52, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = modalColor
    modal.BorderSizePixel = 0
    modal.ClipsDescendants = true
    modal.ZIndex = 91
    modal.Parent = overlay

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(620, 470)
    sizeConstraint.MaxSize = Vector2.new(760, 540)
    sizeConstraint.Parent = modal

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

    round(modal, Theme.Radius.Main)
    stroke(modal, Color3.fromRGB(96, 98, 110), 0.48)

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 28, 0, 24)
    closeButton.Position = UDim2.new(1, -38, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(65, 66, 74)
    closeButton.BackgroundTransparency = 0.12
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 96
    closeButton.Parent = modal
    round(closeButton, 10)

    local card = Instance.new("Frame")
    card.Name = "PublicProfileCard"
    card.Size = UDim2.new(0, 430, 1, -44)
    card.Position = UDim2.new(0.5, 0, 0.52, 0)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = panelColor
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 92
    card.Parent = modal
    round(card, 14)
    stroke(card, Color3.fromRGB(82, 84, 94), 0.36)

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 118)
    banner.BackgroundColor3 = Color3.fromRGB(18, 18, 34)
    banner.BorderSizePixel = 0
    banner.ClipsDescendants = true
    banner.ZIndex = 93
    banner.Parent = card

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 13, 28)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(24, 19, 58)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(18, 22, 48)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(31, 34, 50)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(47, 48, 56))
    })
    bannerGradient.Rotation = 20
    bannerGradient.Parent = banner

    local bannerShade = Instance.new("Frame")
    bannerShade.Name = "BannerShade"
    bannerShade.Size = UDim2.new(1, 0, 1, 0)
    bannerShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bannerShade.BackgroundTransparency = 0.55
    bannerShade.BorderSizePixel = 0
    bannerShade.ZIndex = 94
    bannerShade.Parent = banner

    local activityText = tostring(profile.activity_text or "")

    if activityText ~= "" then
        local activityLabel = Instance.new("TextLabel")
        activityLabel.Name = "ActivityText"
        activityLabel.Size = UDim2.new(0.52, -22, 0, 24)
        activityLabel.Position = UDim2.new(0.48, 0, 1, -38)
        activityLabel.BackgroundTransparency = 1
        activityLabel.Text = activityText
        activityLabel.TextColor3 = Theme.Colors.Text
        activityLabel.Font = Theme.Font.Bold
        activityLabel.TextSize = 13
        activityLabel.TextXAlignment = Enum.TextXAlignment.Right
        activityLabel.TextTruncate = Enum.TextTruncate.AtEnd
        activityLabel.ZIndex = 96
        activityLabel.Parent = banner
    end

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 1, -118)
    body.Position = UDim2.new(0, 0, 0, 118)
    body.BackgroundColor3 = panelColor
    body.BorderSizePixel = 0
    body.ZIndex = 93
    body.Parent = card

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 98, 0, 98)
    avatarFrame.Position = UDim2.new(0, 32, 0, -50)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(31, 32, 38)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 97
    avatarFrame.Parent = body
    round(avatarFrame, 49)
    stroke(avatarFrame, Color3.fromRGB(128, 130, 148), 0.08)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -8, 1, -8)
    avatarImage.Position = UDim2.new(0, 4, 0, 4)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ZIndex = 98
    avatarImage.Parent = avatarFrame
    round(avatarImage, 45)

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

    local identityX = 0
    local identityOffset = 154

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -182, 0, 30)
    displayName.Position = UDim2.new(identityX, identityOffset, 0, 16)
    displayName.BackgroundTransparency = 1
    displayName.Text = tostring(profile.display_name or "Usuario")
    displayName.TextColor3 = Theme.Colors.Text
    displayName.Font = Theme.Font.Bold
    displayName.TextSize = 24
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.ZIndex = 95
    displayName.Parent = body

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -182, 0, 18)
    username.Position = UDim2.new(identityX, identityOffset, 0, 47)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Bold
    username.TextSize = 12
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = 95
    username.Parent = body

    local pointsLabel = Instance.new("TextLabel")
    pointsLabel.Name = "PointsLabel"
    pointsLabel.Size = UDim2.new(1, -52, 0, 22)
    pointsLabel.Position = UDim2.new(0, 26, 0, 78)
    pointsLabel.BackgroundTransparency = 1
    pointsLabel.Text = "Puntos de Usuario:"
    pointsLabel.TextColor3 = Theme.Colors.Text
    pointsLabel.Font = Theme.Font.Bold
    pointsLabel.TextSize = 14
    pointsLabel.TextXAlignment = Enum.TextXAlignment.Center
    pointsLabel.ZIndex = 95
    pointsLabel.Parent = body

    local pointsValue = Instance.new("TextLabel")
    pointsValue.Name = "PointsValue"
    pointsValue.Size = UDim2.new(1, -52, 0, 24)
    pointsValue.Position = UDim2.new(0, 26, 0, 102)
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(profile.personal_points or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 18
    pointsValue.TextXAlignment = Enum.TextXAlignment.Center
    pointsValue.TextTruncate = Enum.TextTruncate.AtEnd
    pointsValue.ZIndex = 95
    pointsValue.Parent = body

    local clanLabel = Instance.new("TextLabel")
    clanLabel.Name = "ClanLabel"
    clanLabel.Size = UDim2.new(1, -76, 0, 20)
    clanLabel.Position = UDim2.new(0, 40, 0, 138)
    clanLabel.BackgroundTransparency = 1
    clanLabel.Text = "Clan:"
    clanLabel.TextColor3 = Theme.Colors.Text
    clanLabel.Font = Theme.Font.Bold
    clanLabel.TextSize = 13
    clanLabel.TextXAlignment = Enum.TextXAlignment.Left
    clanLabel.ZIndex = 95
    clanLabel.Parent = body

    local clanValue = Instance.new("TextLabel")
    clanValue.Name = "ClanValue"
    clanValue.Size = UDim2.new(1, -76, 0, 20)
    clanValue.Position = UDim2.new(0, 40, 0, 158)
    clanValue.BackgroundTransparency = 1
    clanValue.Text = tostring(profile.clan_name or "Sin clan")
    clanValue.TextColor3 = Theme.Colors.Text
    clanValue.Font = Theme.Font.Regular
    clanValue.TextSize = 13
    clanValue.TextXAlignment = Enum.TextXAlignment.Left
    clanValue.TextTruncate = Enum.TextTruncate.AtEnd
    clanValue.ZIndex = 95
    clanValue.Parent = body

    local descriptionTitle = Instance.new("TextLabel")
    descriptionTitle.Name = "DescriptionTitle"
    descriptionTitle.Size = UDim2.new(1, -76, 0, 20)
    descriptionTitle.Position = UDim2.new(0, 40, 0, 180)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.Text = "Descripcion:"
    descriptionTitle.TextColor3 = Theme.Colors.Text
    descriptionTitle.Font = Theme.Font.Bold
    descriptionTitle.TextSize = 13
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    descriptionTitle.ZIndex = 95
    descriptionTitle.Parent = body

    local descriptionBox = Instance.new("TextLabel")
    descriptionBox.Name = "DescriptionBox"
    descriptionBox.Size = UDim2.new(1, -92, 0, 50)
    descriptionBox.Position = UDim2.new(0, 46, 0, 204)
    descriptionBox.BackgroundColor3 = inputColor
    descriptionBox.BackgroundTransparency = 0
    descriptionBox.BorderSizePixel = 0
    descriptionBox.Text = tostring(profile.bio or "Cuentales algo sobre ti...")
    descriptionBox.TextColor3 = profile.bio and Theme.Colors.Text or Theme.Colors.TextMuted
    descriptionBox.Font = Theme.Font.Regular
    descriptionBox.TextSize = 12
    descriptionBox.TextWrapped = true
    descriptionBox.TextXAlignment = Enum.TextXAlignment.Left
    descriptionBox.TextYAlignment = Enum.TextYAlignment.Top
    descriptionBox.ZIndex = 95
    descriptionBox.Parent = body
    round(descriptionBox, 8)
    stroke(descriptionBox, Color3.fromRGB(43, 44, 50), 0.62)
    addPadding(descriptionBox, 12, 12, 10, 10)

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(0, 150, 0, 32)
    actions.Position = UDim2.new(0.5, -75, 1, -38)
    actions.BackgroundTransparency = 1
    actions.ZIndex = 95
    actions.Parent = body

    local messageButton = Instance.new("TextButton")
    messageButton.Name = "MessageButton"
    messageButton.Size = UDim2.new(0, 94, 0, 30)
    messageButton.Position = UDim2.new(0, 0, 0, 0)
    messageButton.BackgroundColor3 = Color3.fromRGB(82, 92, 232)
    messageButton.BackgroundTransparency = 0.02
    messageButton.BorderSizePixel = 0
    messageButton.Text = "Mensaje"
    messageButton.TextColor3 = Theme.Colors.Text
    messageButton.Font = Theme.Font.Bold
    messageButton.TextSize = 12
    messageButton.ZIndex = 96
    messageButton.Parent = actions
    round(messageButton, 8)

    local addButton = Instance.new("TextButton")
    addButton.Name = "AddButton"
    addButton.Size = UDim2.new(0, 34, 0, 30)
    addButton.Position = UDim2.new(0, 102, 0, 0)
    addButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    addButton.BackgroundTransparency = 0.04
    addButton.BorderSizePixel = 0
    addButton.Text = "+"
    addButton.TextColor3 = Theme.Colors.Text
    addButton.Font = Theme.Font.Bold
    addButton.TextSize = 18
    addButton.ZIndex = 96
    addButton.Parent = actions
    round(addButton, 8)

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
