local CreateRoomModal = {}

function CreateRoomModal.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "CreateRoomOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.35
    overlay.Visible = false
    overlay.ZIndex = 50
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 320, 0, 250)
    modal.Position = UDim2.new(0.5, -160, 0.5, -125)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 51
    modal.Parent = overlay

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 32)
    title.Position = UDim2.new(0, 12, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Crear Sala"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 52
    title.Parent = modal

    local roomInput = Instance.new("TextBox")
    roomInput.Name = "RoomNameInput"
    roomInput.Size = UDim2.new(1, -24, 0, 38)
    roomInput.Position = UDim2.new(0, 12, 0, 58)
    roomInput.BackgroundColor3 = Theme.Colors.PanelLight
    roomInput.BorderSizePixel = 0
    roomInput.PlaceholderText = "Nombre de la sala..."
    roomInput.Text = ""
    roomInput.TextColor3 = Theme.Colors.Text
    roomInput.PlaceholderColor3 = Theme.Colors.TextMuted
    roomInput.Font = Theme.Font.Regular
    roomInput.TextSize = 14
    roomInput.ClearTextOnFocus = false
    roomInput.ZIndex = 52
    roomInput.Parent = modal

    local roomCorner = Instance.new("UICorner")
    roomCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    roomCorner.Parent = roomInput

    local roomPadding = Instance.new("UIPadding")
    roomPadding.PaddingLeft = UDim.new(0, 12)
    roomPadding.Parent = roomInput

    local privateToggle = Instance.new("TextButton")
    privateToggle.Name = "PrivateToggle"
    privateToggle.Size = UDim2.new(1, -24, 0, 34)
    privateToggle.Position = UDim2.new(0, 12, 0, 108)
    privateToggle.BackgroundColor3 = Theme.Colors.PanelLight
    privateToggle.BorderSizePixel = 0
    privateToggle.Text = "Sala Pública"
    privateToggle.TextColor3 = Theme.Colors.Text
    privateToggle.Font = Theme.Font.Bold
    privateToggle.TextSize = 13
    privateToggle.ZIndex = 52
    privateToggle.Parent = modal

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    toggleCorner.Parent = privateToggle

    local passwordInput = Instance.new("TextBox")
    passwordInput.Name = "PasswordInput"
    passwordInput.Size = UDim2.new(1, -24, 0, 38)
    passwordInput.Position = UDim2.new(0, 12, 0, 152)
    passwordInput.BackgroundColor3 = Theme.Colors.PanelLight
    passwordInput.BorderSizePixel = 0
    passwordInput.PlaceholderText = "Contraseña..."
    passwordInput.Text = ""
    passwordInput.TextColor3 = Theme.Colors.Text
    passwordInput.PlaceholderColor3 = Theme.Colors.TextMuted
    passwordInput.Font = Theme.Font.Regular
    passwordInput.TextSize = 14
    passwordInput.ClearTextOnFocus = false
    passwordInput.Visible = false
    passwordInput.ZIndex = 52
    passwordInput.Parent = modal

    local passwordCorner = Instance.new("UICorner")
    passwordCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    passwordCorner.Parent = passwordInput

    local passwordPadding = Instance.new("UIPadding")
    passwordPadding.PaddingLeft = UDim.new(0, 12)
    passwordPadding.Parent = passwordInput

    local createButton = Instance.new("TextButton")
    createButton.Name = "CreateButton"
    createButton.Size = UDim2.new(0.5, -18, 0, 38)
    createButton.Position = UDim2.new(0, 12, 1, -50)
    createButton.BackgroundColor3 = Theme.Colors.AccentSoft
    createButton.BorderSizePixel = 0
    createButton.Text = "Crear"
    createButton.TextColor3 = Color3.fromRGB(255,255,255)
    createButton.Font = Theme.Font.Bold
    createButton.TextSize = 13
    createButton.ZIndex = 52
    createButton.Parent = modal

    local createCorner = Instance.new("UICorner")
    createCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    createCorner.Parent = createButton

    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0.5, -18, 0, 38)
    cancelButton.Position = UDim2.new(0.5, 6, 1, -50)
    cancelButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelButton.BorderSizePixel = 0
    cancelButton.Text = "Cancelar"
    cancelButton.TextColor3 = Theme.Colors.Text
    cancelButton.Font = Theme.Font.Bold
    cancelButton.TextSize = 13
    cancelButton.ZIndex = 52
    cancelButton.Parent = modal

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelCorner.Parent = cancelButton

    local isPrivate = false

    privateToggle.MouseButton1Click:Connect(function()
        isPrivate = not isPrivate

        if isPrivate then
            privateToggle.Text = "Sala Privada"
            passwordInput.Visible = true
        else
            privateToggle.Text = "Sala Pública"
            passwordInput.Visible = false
        end
    end)

    return {
        Overlay = overlay,
        RoomInput = roomInput,
        PasswordInput = passwordInput,
        PrivateToggle = privateToggle,
        CreateButton = createButton,
        CancelButton = cancelButton,

        IsPrivate = function()
            return isPrivate
        end,

        Open = function()
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end
    }
end

return CreateRoomModal