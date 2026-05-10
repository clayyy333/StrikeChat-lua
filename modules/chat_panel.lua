local ChatPanel = {}

function ChatPanel.Create(parent, Theme)
    local title = Instance.new("TextLabel")
    title.Name = "ChatTitle"
    title.Size = UDim2.new(1, -20, 0, 38)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "Chat General"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = parent

    local messagesBox = Instance.new("ScrollingFrame")
    messagesBox.Name = "MessagesBox"
    messagesBox.Size = UDim2.new(1, -24, 1, -98)
    messagesBox.Position = UDim2.new(0, 12, 0, 50)
    messagesBox.BackgroundColor3 = Theme.Colors.Panel
    messagesBox.BorderSizePixel = 0
    messagesBox.ScrollBarThickness = 4
    messagesBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    messagesBox.Parent = parent

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    boxCorner.Parent = messagesBox

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = messagesBox

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = messagesBox

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -24, 0, 20)
    statusLabel.Position = UDim2.new(0, 12, 1, -60)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.Danger
    statusLabel.Font = Theme.Font.Regular
    statusLabel.TextSize = 13
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = parent

    local input = Instance.new("TextBox")
    input.Name = "MessageInput"
    input.Size = UDim2.new(1, -112, 0, 38)
    input.Position = UDim2.new(0, 12, 1, -43)
    input.BackgroundColor3 = Theme.Colors.PanelLight
    input.BorderSizePixel = 0
    input.PlaceholderText = "Escribe un mensaje..."
    input.Text = ""
    input.TextColor3 = Theme.Colors.Text
    input.PlaceholderColor3 = Theme.Colors.TextMuted
    input.Font = Theme.Font.Regular
    input.TextSize = 14
    input.TextXAlignment = Enum.TextXAlignment.Left

    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 12)
    inputPadding.Parent = input
    input.ClearTextOnFocus = false
    input.Parent = parent

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    inputCorner.Parent = input

    local send = Instance.new("TextButton")
    send.Name = "SendButton"
    send.Size = UDim2.new(0, 84, 0, 38)
    send.Position = UDim2.new(1, -96, 1, -43)
    send.BackgroundColor3 = Theme.Colors.AccentSoft
    send.Text = "Enviar"
    send.TextColor3 = Color3.fromRGB(255, 255, 255)
    send.Font = Theme.Font.Bold
    send.TextSize = 14
    send.Parent = parent

    local sendCorner = Instance.new("UICorner")
    sendCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    sendCorner.Parent = send

    return {
        MessagesBox = messagesBox,
        Layout = layout,
        Input = input,
        SendButton = send,
        StatusLabel = statusLabel
    }
end

return ChatPanel