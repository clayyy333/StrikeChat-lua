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
    modal.Size = UDim2.new(0.82, 0, 0.68, 0)
    modal.Position = UDim2.new(0.5, 0, 0.52, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 91
    modal.Parent = overlay

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(300, 360)
    sizeConstraint.MaxSize = Vector2.new(460, 500)
    sizeConstraint.Parent = modal

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local modalStroke = Instance.new("UIStroke")
    modalStroke.Color = Theme.Colors.Border
    modalStroke.Thickness = 1
    modalStroke.Transparency = 0.18
    modalStroke.Parent = modal

    local function round(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or Theme.Radius.Button)
        corner.Parent = instance
        return corner
    end

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -62, 0, 36)
    title.Position = UDim2.new(0, 14, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "Perfil Publico"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 92
    title.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -42, 0, 10)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 92
    closeButton.Parent = modal
    round(closeButton)

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, -24, 1, -56)
    body.Position = UDim2.new(0, 12, 0, 46)
    body.BackgroundColor3 = Theme.Colors.Background
    body.BorderSizePixel = 0
    body.ClipsDescendants = true
    body.ZIndex = 92
    body.Parent = modal
    round(body, Theme.Radius.Panel)

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 118)
    banner.BackgroundColor3 = Theme.Colors.PanelLight
    banner.BorderSizePixel = 0
    banner.ZIndex = 93
    banner.Parent = body

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(98, 118, 232)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(124, 92, 207)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(37, 45, 76))
    })
    bannerGradient.Rotation = 22
    bannerGradient.Parent = banner

    local headerOverlay = Instance.new("Frame")
    headerOverlay.Name = "HeaderOverlay"
    headerOverlay.Size = UDim2.new(1, -24, 0, 74)
    headerOverlay.Position = UDim2.new(0, 12, 0, 72)
    headerOverlay.BackgroundColor3 = Color3.fromRGB(10, 11, 18)
    headerOverlay.BackgroundTransparency = 0.18
    headerOverlay.BorderSizePixel = 0
    headerOverlay.ZIndex = 94
    headerOverlay.Parent = body
    round(headerOverlay, 12)

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 70, 0, 70)
    avatarFrame.Position = UDim2.new(0, 18, 0, 48)
    avatarFrame.BackgroundColor3 = Theme.Colors.Panel
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 95
    avatarFrame.Parent = body
    round(avatarFrame, 14)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -6, 1, -6)
    avatarImage.Position = UDim2.new(0, 3, 0, 3)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ZIndex = 96
    avatarImage.Parent = avatarFrame
    round(avatarImage, 12)

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

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -122, 0, 24)
    displayName.Position = UDim2.new(0, 96, 0, 82)
    displayName.BackgroundTransparency = 1
    displayName.Text = tostring(profile.display_name or "Usuario")
    displayName.TextColor3 = Theme.Colors.Text
    displayName.Font = Theme.Font.Bold
    displayName.TextSize = 16
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.ZIndex = 96
    displayName.Parent = body

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -122, 0, 18)
    username.Position = UDim2.new(0, 96, 0, 106)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Regular
    username.TextSize = 11
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = 96
    username.Parent = body

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -24, 1, -166)
    content.Position = UDim2.new(0, 12, 0, 154)
    content.BackgroundTransparency = 1
    content.ZIndex = 93
    content.Parent = body

    local function getCosmeticsSummary()
        local cosmetics = {}

        if profile.active_username_color then
            table.insert(cosmetics, "Nombre")
        end

        if profile.active_chat_color then
            table.insert(cosmetics, "Chat")
        end

        if profile.active_chat_style then
            table.insert(cosmetics, "Estilo")
        end

        if #cosmetics == 0 then
            return "Base"
        end

        return table.concat(cosmetics, " / ")
    end

    local function makeInfoBox(name, xScale, xOffset, labelText, valueText)
        local box = Instance.new("Frame")
        box.Name = name
        box.Size = UDim2.new(0.5, -6, 0, 54)
        box.Position = UDim2.new(xScale, xOffset, 0, 0)
        box.BackgroundColor3 = Theme.Colors.PanelLight
        box.BorderSizePixel = 0
        box.ZIndex = 94
        box.Parent = content
        round(box, 8)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -14, 0, 20)
        label.Position = UDim2.new(0, 7, 0, 6)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Theme.Colors.TextMuted
        label.Font = Theme.Font.Bold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 95
        label.Parent = box

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(1, -14, 0, 22)
        value.Position = UDim2.new(0, 7, 0, 26)
        value.BackgroundTransparency = 1
        value.Text = valueText
        value.TextColor3 = Theme.Colors.Text
        value.Font = Theme.Font.Bold
        value.TextSize = 12
        value.TextXAlignment = Enum.TextXAlignment.Center
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.ZIndex = 95
        value.Parent = box
    end

    makeInfoBox(
        "ClanBox",
        0,
        0,
        "Clan",
        tostring(profile.clan_name or "Sin clan")
    )

    makeInfoBox(
        "CosmeticBox",
        0.5,
        6,
        "Cosmeticos",
        getCosmeticsSummary()
    )

    local bioBox = Instance.new("Frame")
    bioBox.Name = "BioBox"
    bioBox.Size = UDim2.new(1, 0, 1, -66)
    bioBox.Position = UDim2.new(0, 0, 0, 66)
    bioBox.BackgroundColor3 = Theme.Colors.PanelLight
    bioBox.BorderSizePixel = 0
    bioBox.ZIndex = 94
    bioBox.Parent = content
    round(bioBox, 8)

    local bioTitle = Instance.new("TextLabel")
    bioTitle.Size = UDim2.new(1, -18, 0, 22)
    bioTitle.Position = UDim2.new(0, 9, 0, 7)
    bioTitle.BackgroundTransparency = 1
    bioTitle.Text = "Descripcion"
    bioTitle.TextColor3 = Theme.Colors.TextMuted
    bioTitle.Font = Theme.Font.Bold
    bioTitle.TextSize = 11
    bioTitle.TextXAlignment = Enum.TextXAlignment.Left
    bioTitle.ZIndex = 95
    bioTitle.Parent = bioBox

    local bio = Instance.new("TextLabel")
    bio.Name = "Bio"
    bio.Size = UDim2.new(1, -18, 1, -36)
    bio.Position = UDim2.new(0, 9, 0, 30)
    bio.BackgroundTransparency = 1
    bio.Text = tostring(profile.bio or "Sin descripcion")
    bio.TextColor3 = Theme.Colors.Text
    bio.Font = Theme.Font.Regular
    bio.TextSize = 12
    bio.TextWrapped = true
    bio.TextXAlignment = Enum.TextXAlignment.Left
    bio.TextYAlignment = Enum.TextYAlignment.Top
    bio.ZIndex = 95
    bio.Parent = bioBox

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
