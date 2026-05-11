local RightPanel = {}

function RightPanel.Create(parent, Theme)
    local title = Instance.new("TextLabel")
    title.Name = "OnlineTitle"
    title.Size = UDim2.new(1, -24, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "En Línea - 0"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = parent

    local list = Instance.new("ScrollingFrame")
    list.Name = "OnlineList"
    list.Size = UDim2.new(1, -24, 1, -56)
    list.Position = UDim2.new(0, 12, 0, 46)
    list.BackgroundColor3 = Theme.Colors.Background
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Parent = parent

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    listCorner.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = list

    local function clear()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
    end

    local function renderUser(user)
        local row = Instance.new("Frame")
        row.Name = "UserRow"
        row.Size = UDim2.new(1, 0, 0, 54)
        row.BackgroundColor3 = Theme.Colors.Background
        row.BorderSizePixel = 0
        row.Parent = list

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        rowCorner.Parent = row

        local avatarHolder = Instance.new("Frame")
        avatarHolder.Name = "AvatarHolder"
        avatarHolder.Size = UDim2.new(0, 34, 0, 34)
        avatarHolder.Position = UDim2.new(0, -2, 0.5, -17)
        avatarHolder.BackgroundColor3 = Theme.Colors.Panel
        avatarHolder.BorderSizePixel = 0
        avatarHolder.Parent = row

        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = avatarHolder

        local avatar = Instance.new("ImageLabel")
        avatar.Name = "Avatar"
        avatar.Size = UDim2.new(1, 0, 1, 0)
        avatar.BackgroundTransparency = 1
        avatar.Image =
            "https://www.roblox.com/headshot-thumbnail/image?userId="
            .. tostring(user.roblox_user_id)
            .. "&width=48&height=48&format=png"
        avatar.Parent = avatarHolder

        local avatarImageCorner = Instance.new("UICorner")
        avatarImageCorner.CornerRadius = UDim.new(1, 0)
        avatarImageCorner.Parent = avatar

        local statusDot = Instance.new("Frame")
        statusDot.Name = "StatusDot"
        statusDot.Size = UDim2.new(0, 10, 0, 10)
        statusDot.Position = UDim2.new(1, -8, 1, -8)
        statusDot.BackgroundColor3 = Theme.Colors.Success
        statusDot.BorderSizePixel = 0
        statusDot.ZIndex = 5
        statusDot.Parent = avatarHolder

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = statusDot

        local displayName = user.display_name or user.roblox_username or "Usuario"

        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Size = UDim2.new(1, -54, 0, 16)
        name.Position = UDim2.new(0, 46, 0, 8)
        name.BackgroundTransparency = 1

        local clanText = ""

        if user.clan_tag then
            clanText = "[" .. tostring(user.clan_tag) .. "]"
        end

        name.Text = displayName .. clanText
        name.TextColor3 = Theme.Colors.Text
        name.Font = Theme.Font.Bold
        name.TextSize = 12
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.Parent = row

        

        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Size = UDim2.new(1, -60, 0, 14)
        status.Position = UDim2.new(0, 46, 0, 26)
        status.BackgroundTransparency = 1
        status.Text = "En línea"
        status.TextColor3 = Theme.Colors.TextMuted
        status.Font = Theme.Font.Regular
        status.TextSize = 11
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Parent = row
    end

    local function render(users)
        clear()


        for _, user in ipairs(users or {}) do
            renderUser(user)
        end

        task.wait()
        list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end

    return {
        Title = title,
        List = list,
        Render = render
    }
end

return RightPanel