local ChatPanel = {}

function ChatPanel.Create(parent, Theme)
    local title = Instance.new("TextLabel")
    title.Name = "ChatTitle"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 12, 0, 2)
    title.BackgroundTransparency = 1
    title.Text = "Chat General"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = parent

    local messagesBox = Instance.new("ScrollingFrame")
    messagesBox.Name = "MessagesBox"
    messagesBox.Size = UDim2.new(1, -24, 1, -92)
    messagesBox.Position = UDim2.new(0, 12, 0, 36)
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
    statusLabel.Size = UDim2.new(1, -24, 0, 18)
    statusLabel.Position = UDim2.new(0, 12, 1, -58)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.Danger
    statusLabel.Font = Theme.Font.Regular
    statusLabel.TextSize = 13
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = parent

    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.new(1, -24, 0, 40)
    inputContainer.Position = UDim2.new(0, 12, 1, -42)
    inputContainer.BackgroundColor3 = Theme.Colors.PanelLight
    inputContainer.BorderSizePixel = 0
    inputContainer.Parent = parent

    local inputContainerCorner = Instance.new("UICorner")
    inputContainerCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    inputContainerCorner.Parent = inputContainer

    local emojiButton = Instance.new("TextButton")
    emojiButton.Name = "EmojiButton"
    emojiButton.Size = UDim2.new(0, 30, 0, 30)
    emojiButton.Position = UDim2.new(1, -80, 0.5, -15)
    emojiButton.BackgroundTransparency = 1
    emojiButton.Text = "🙂"
    emojiButton.TextColor3 = Theme.Colors.TextMuted
    emojiButton.Font = Theme.Font.Bold
    emojiButton.TextSize = 17
    emojiButton.Parent = inputContainer

    local input = Instance.new("TextBox")
    input.Name = "MessageInput"
    input.Size = UDim2.new(1, -110, 1, 0)
    input.Position = UDim2.new(0, 28, 0, 0)
    input.BackgroundTransparency = 1
    input.PlaceholderText = "Escribe un mensaje..."
    input.Text = ""
    input.TextColor3 = Theme.Colors.Text
    input.PlaceholderColor3 = Theme.Colors.TextMuted
    input.Font = Theme.Font.Regular
    input.TextSize = 14
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = false
    input.Parent = inputContainer

    local send = Instance.new("TextButton")
    send.Name = "SendButton"
    send.Size = UDim2.new(0, 46, 0, 30)
    send.Position = UDim2.new(1, -52, 0.5, -15)
    send.BackgroundColor3 = Theme.Colors.AccentSoft
    send.Text = "Enviar"
    send.TextColor3 = Color3.fromRGB(255, 255, 255)
    send.Font = Theme.Font.Bold
    send.TextSize = 11
    send.Parent = inputContainer

    local sendCorner = Instance.new("UICorner")
    sendCorner.CornerRadius = UDim.new(1, 0)
    sendCorner.Parent = send

    return {
        MessagesBox = messagesBox,
        Layout = layout,
        Input = input,
        SendButton = send,
        EmojiButton = emojiButton,
        StatusLabel = statusLabel
    }
end

return ChatPanel