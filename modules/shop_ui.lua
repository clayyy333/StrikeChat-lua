local ShopUI = {}

function ShopUI.Create(parent, Theme)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ShopUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0, 920, 0, 510)
    root.Position = UDim2.new(0.5, -460, 0.5, -238)
    root.BackgroundColor3 = Color3.fromRGB(11, 12, 18)
    root.BorderSizePixel = 0
    root.Parent = gui

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, 14)
    rootCorner.Parent = root

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -58, 0, 8)
    closeButton.BackgroundColor3 = Color3.fromRGB(120, 36, 36)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 18
    closeButton.Parent = root

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -140, 0, 48)
    title.Position = UDim2.new(0, 70, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "TIENDA"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = root

    return {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ShopUI