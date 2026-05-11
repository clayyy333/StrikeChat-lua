local RoomsListModal = {}

function RoomsListModal.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "RoomsListOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.35
    overlay.Visible = false
    overlay.ZIndex = 60
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 520, 0, 420)
    modal.Position = UDim2.new(0.5, -260, 0.5, -210)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 61
    modal.Parent = overlay

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 0, 36)
    title.Position = UDim2.new(0, 14, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Salas Públicas"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 62
    title.Parent = modal

    local columns = Instance.new("TextLabel")
    columns.Name = "Columns"
    columns.Size = UDim2.new(1, -28, 0, 18)
    columns.Position = UDim2.new(0, 14, 0, 52)
    columns.BackgroundTransparency = 1
    columns.Text = ""
    columns.TextColor3 = Theme.Colors.TextMuted
    columns.Font = Theme.Font.Bold
    columns.TextSize = 11
    columns.TextXAlignment = Enum.TextXAlignment.Left
    columns.ZIndex = 62
    columns.Parent = modal

    local numberHeader = Instance.new("TextLabel")
    numberHeader.Size = UDim2.new(0, 40, 0, 18)
    numberHeader.Position = UDim2.new(0, 18, 0, 52)
    numberHeader.BackgroundTransparency = 1
    numberHeader.Text = "Nº"
    numberHeader.TextColor3 = Theme.Colors.TextMuted
    numberHeader.Font = Theme.Font.Bold
    numberHeader.TextSize = 11
    numberHeader.TextXAlignment = Enum.TextXAlignment.Left
    numberHeader.ZIndex = 62
    numberHeader.Parent = modal

    local roomHeader = Instance.new("TextLabel")
    roomHeader.Size = UDim2.new(0, 220, 0, 18)
    roomHeader.Position = UDim2.new(0, 98, 0, 52)
    roomHeader.BackgroundTransparency = 1
    roomHeader.Text = "Nombre de sala"
    roomHeader.TextColor3 = Theme.Colors.TextMuted
    roomHeader.Font = Theme.Font.Bold
    roomHeader.TextSize = 11
    roomHeader.TextXAlignment = Enum.TextXAlignment.Left
    roomHeader.ZIndex = 62
    roomHeader.Parent = modal

    local membersHeader = Instance.new("TextLabel")
    membersHeader.Size = UDim2.new(0, 120, 0, 18)
    membersHeader.Position = UDim2.new(1, -128, 0, 52)
    membersHeader.BackgroundTransparency = 1
    membersHeader.Text = "Participantes"
    membersHeader.TextColor3 = Theme.Colors.TextMuted
    membersHeader.Font = Theme.Font.Bold
    membersHeader.TextSize = 11
    membersHeader.TextXAlignment = Enum.TextXAlignment.Left
    membersHeader.ZIndex = 62
    membersHeader.Parent = modal

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -52, 0, 1)
    divider.Position = UDim2.new(0, 26, 0, 76)
    divider.BackgroundColor3 = Color3.fromRGB(75, 75, 88)
    divider.BackgroundTransparency = 0.2
    divider.BorderSizePixel = 0
    divider.ZIndex = 62
    divider.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -44, 0, 12)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Danger
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 13
    closeButton.ZIndex = 62
    closeButton.Parent = modal

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = closeButton

    local list = Instance.new("ScrollingFrame")
    list.Name = "RoomsList"
    list.Size = UDim2.new(1, -28, 1, -92)
    list.Position = UDim2.new(0, 14, 0, 40)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ZIndex = 62
    list.Parent = modal

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    listCorner.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 0)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = list

    local function clear()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
    end

    return {
        Overlay = overlay,
        Title = title,
        List = list,
        Layout = layout,
        CloseButton = closeButton,
        Clear = clear,

        Open = function()
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end
    }
end

return RoomsListModal