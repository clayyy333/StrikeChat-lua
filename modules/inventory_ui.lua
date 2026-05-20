local InventoryUI = {}

function InventoryUI.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "InventoryOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.Visible = false
    overlay.ZIndex = 80
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0.82, 0, 0, 230)
    modal.Position = UDim2.new(0.5, 0, 0.5, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 81
    modal.Parent = overlay

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(300, 210)
    sizeConstraint.MaxSize = Vector2.new(430, 260)
    sizeConstraint.Parent = modal

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -58, 0, 34)
    title.Position = UDim2.new(0, 16, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "Mis Items"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 82
    title.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -44, 0, 14)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 82
    closeButton.Parent = modal

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = closeButton

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, -32, 1, -72)
    body.Position = UDim2.new(0, 16, 0, 56)
    body.BackgroundColor3 = Theme.Colors.Background
    body.BorderSizePixel = 0
    body.ZIndex = 82
    body.Parent = modal

    local bodyCorner = Instance.new("UICorner")
    bodyCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    bodyCorner.Parent = body

    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -28, 1, -24)
    message.Position = UDim2.new(0, 14, 0, 12)
    message.BackgroundTransparency = 1
    message.Text = "La base del inventario esta separada del perfil. El listado real se implementara en el siguiente paso."
    message.TextColor3 = Theme.Colors.TextMuted
    message.Font = Theme.Font.Regular
    message.TextSize = 12
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Center
    message.TextYAlignment = Enum.TextYAlignment.Center
    message.ZIndex = 83
    message.Parent = body

    closeButton.MouseButton1Click:Connect(function()
        overlay.Visible = false
    end)

    return {
        Overlay = overlay,
        CloseButton = closeButton,

        Open = function()
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end,

        Destroy = function()
            overlay:Destroy()
        end
    }
end

return InventoryUI
