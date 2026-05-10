local RightPanel = {}

function RightPanel.Create(parent, Theme)
    local title = Instance.new("TextLabel")
    title.Name = "OnlineTitle"
    title.Size = UDim2.new(1, -24, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "Usuarios Online"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = parent

    local list = Instance.new("ScrollingFrame")
    list.Name = "OnlineList"
    list.Size = UDim2.new(1, -24, 1, -56)
    list.Position = UDim2.new(0, 12, 0, 46)
    list.BackgroundColor3 = Theme.Colors.Panel
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
    padding.PaddingLeft = UDim.new(0, 8)
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
        row.Size = UDim2.new(1, -4, 0, 38)
        row.BackgroundColor3 = Theme.Colors.PanelLight
        row.BorderSizePixel = 0
        row.Parent = list

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        rowCorner.Parent = row

        local statusDot = Instance.new("Frame")
        statusDot.Name = "StatusDot"
        statusDot.Size = UDim2.new(0, 8, 0, 8)
        statusDot.Position = UDim2.new(0, 10, 0.5, -4)
        statusDot.BackgroundColor3 = Theme.Colors.Success
        statusDot.BorderSizePixel = 0
        statusDot.Parent = row

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = statusDot

        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Size = UDim2.new(1, -34, 1, 0)
        name.Position = UDim2.new(0, 26, 0, 0)
        name.BackgroundTransparency = 1
        name.TextColor3 = Theme.Colors.Text
        name.Font = Theme.Font.Bold
        name.TextSize = 12
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd

        local displayName = user.display_name or user.roblox_username or "Usuario"

        if user.clan_tag then
            if user.clan_tag_style == "plain" then
                displayName = displayName .. user.clan_tag
            else
                displayName = displayName .. "[" .. user.clan_tag .. "]"
            end
        end

        name.Text = displayName
        name.Parent = row
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
        List = list,
        Render = render
    }
end

return RightPanel