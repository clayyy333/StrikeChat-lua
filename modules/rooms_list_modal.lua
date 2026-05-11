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
    modal.Size = UDim2.new(0, 360, 0, 360)
    modal.Position = UDim2.new(0.5, -180, 0.5, -180)
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
    list.Size = UDim2.new(1, -28, 1, -64)
    list.Position = UDim2.new(0, 14, 0, 52)
    list.BackgroundColor3 = Theme.Colors.Background
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
    padding.PaddingTop = UDim.new(0, 8)
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