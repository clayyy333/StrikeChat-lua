local InventoryUI = {}

local CATEGORY_LABELS = {
    username_color = "Color de nombre",
    chat_color = "Color de chat",
    chat_style = "Estilo de chat",
    profile_banner = "Fondo de perfil",
    clan = "Clan"
}

local CATEGORY_COLORS = {
    username_color = Color3.fromRGB(78, 158, 58),
    chat_color = Color3.fromRGB(255, 110, 180),
    chat_style = Color3.fromRGB(66, 135, 245),
    profile_banner = Color3.fromRGB(255, 170, 70),
    clan = Color3.fromRGB(168, 6, 235)
}

local COLOR_OPTIONS = {
    { value = "purple", label = "Morado", color = Color3.fromRGB(168, 6, 235) },
    { value = "blue", label = "Azul", color = Color3.fromRGB(66, 135, 245) },
    { value = "pink", label = "Rosado", color = Color3.fromRGB(255, 110, 180) },
    { value = "green", label = "Verde", color = Color3.fromRGB(78, 158, 58) },
    { value = "yellow", label = "Amarillo", color = Color3.fromRGB(245, 190, 60) }
}

local STYLE_OPTIONS = {
    { value = "bracket", label = "Tag Profesional = [TAG]" },
    { value = "plain", label = "Tag Normal = TAG" }
}

local CHAT_STYLE_NAMES = {
    bubble = "Burbuja",
    cloud = "Cute Cloud",
    galaxy = "Galaxy",
    hackermstrix = "HackerMatrix",
    dog = "Perrito",
    cat = "Gatito",
    rainbow = "Arcoiris",
    hacker = "Hacker"
}

local CUSTOM_CHAT_ITEM_ID = "chat_personalizado"

local CUSTOM_CHAT_STYLES = {
    { value = "cloud", label = "Cute Cloud" },
    { value = "galaxy", label = "Galaxy" },
    { value = "hackermstrix", label = "HackerMatrix" }
}

local function getInventoryEntryData(entry)
    local item = entry.item or entry
    local inventoryItem = entry.inventory_item or entry

    return item, inventoryItem
end

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
    modal.Size = UDim2.new(0.86, 0, 0, 330)
    modal.Position = UDim2.new(0.5, 0, 0.5, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 81
    modal.Parent = overlay

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(320, 270)
    sizeConstraint.MaxSize = Vector2.new(520, 380)
    sizeConstraint.Parent = modal

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -64, 0, 30)
    title.Position = UDim2.new(0, 16, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "Mis Items"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 82
    title.Parent = modal

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -64, 0, 18)
    statusLabel.Position = UDim2.new(0, 16, 0, 39)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Regular
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 82
    statusLabel.Parent = modal

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

    local list = Instance.new("ScrollingFrame")
    list.Name = "ItemsList"
    list.Size = UDim2.new(1, -32, 1, -76)
    list.Position = UDim2.new(0, 16, 0, 62)
    list.BackgroundColor3 = Theme.Colors.Background
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = Theme.Colors.Accent
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ZIndex = 82
    list.Parent = modal

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    listCorner.Parent = list

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local clanForm = Instance.new("Frame")
    clanForm.Name = "ClanCreateForm"
    clanForm.Size = UDim2.new(1, -32, 1, -76)
    clanForm.Position = UDim2.new(0, 16, 0, 62)
    clanForm.BackgroundColor3 = Theme.Colors.Background
    clanForm.BorderSizePixel = 0
    clanForm.Visible = false
    clanForm.ZIndex = 86
    clanForm.Parent = modal

    local clanFormCorner = Instance.new("UICorner")
    clanFormCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    clanFormCorner.Parent = clanForm

    local formPadding = Instance.new("UIPadding")
    formPadding.PaddingTop = UDim.new(0, 12)
    formPadding.PaddingLeft = UDim.new(0, 12)
    formPadding.PaddingRight = UDim.new(0, 12)
    formPadding.Parent = clanForm

    local formTitle = Instance.new("TextLabel")
    formTitle.Name = "FormTitle"
    formTitle.Size = UDim2.new(1, -8, 0, 24)
    formTitle.BackgroundTransparency = 1
    formTitle.Text = "Crear Clan"
    formTitle.TextColor3 = Theme.Colors.Text
    formTitle.Font = Theme.Font.Bold
    formTitle.TextSize = 15
    formTitle.TextXAlignment = Enum.TextXAlignment.Left
    formTitle.ZIndex = 87
    formTitle.Parent = clanForm

    local function createInput(name, placeholder, y)
        local input = Instance.new("TextBox")
        input.Name = name
        input.Size = UDim2.new(1, -8, 0, 34)
        input.Position = UDim2.new(0, 0, 0, y)
        input.BackgroundColor3 = Theme.Colors.PanelLight
        input.BorderSizePixel = 0
        input.PlaceholderText = placeholder
        input.Text = ""
        input.TextColor3 = Theme.Colors.Text
        input.PlaceholderColor3 = Theme.Colors.TextMuted
        input.Font = Theme.Font.Regular
        input.TextSize = 12
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.ClearTextOnFocus = false
        input.ZIndex = 87
        input.Parent = clanForm

        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        inputCorner.Parent = input

        local inputPadding = Instance.new("UIPadding")
        inputPadding.PaddingLeft = UDim.new(0, 10)
        inputPadding.PaddingRight = UDim.new(0, 10)
        inputPadding.Parent = input

        return input
    end

    local clanNameInput = createInput("ClanNameInput", "Nombre del clan", 34)
    local clanTagInput = createInput("ClanTagInput", "Tag corto, ejemplo SC", 76)

    local selectedColorIndex = 1
    local selectedStyleIndex = 1

    local function getSelectedColorOption()
        return COLOR_OPTIONS[selectedColorIndex]
    end

    local function getSelectedStyleOption()
        return STYLE_OPTIONS[selectedStyleIndex]
    end

    local colorButton = Instance.new("TextButton")
    colorButton.Name = "ColorButton"
    colorButton.Size = UDim2.new(0.5, -8, 0, 32)
    colorButton.Position = UDim2.new(0, 0, 0, 120)
    colorButton.BackgroundColor3 = getSelectedColorOption().color
    colorButton.BorderSizePixel = 0
    colorButton.Text = "Color: " .. getSelectedColorOption().label
    colorButton.TextColor3 = Theme.Colors.Text
    colorButton.Font = Theme.Font.Bold
    colorButton.TextSize = 11
    colorButton.ZIndex = 87
    colorButton.Parent = clanForm

    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    colorCorner.Parent = colorButton

    local styleButton = Instance.new("TextButton")
    styleButton.Name = "StyleButton"
    styleButton.Size = UDim2.new(0.5, -8, 0, 32)
    styleButton.Position = UDim2.new(0.5, 8, 0, 120)
    styleButton.BackgroundColor3 = Theme.Colors.PanelLight
    styleButton.BorderSizePixel = 0
    styleButton.Text = getSelectedStyleOption().label
    styleButton.TextColor3 = Theme.Colors.Text
    styleButton.Font = Theme.Font.Bold
    styleButton.TextSize = 11
    styleButton.ZIndex = 87
    styleButton.Parent = clanForm

    local styleCorner = Instance.new("UICorner")
    styleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    styleCorner.Parent = styleButton

    local cancelClanButton = Instance.new("TextButton")
    cancelClanButton.Name = "CancelClanButton"
    cancelClanButton.Size = UDim2.new(0.5, -8, 0, 34)
    cancelClanButton.Position = UDim2.new(0, 0, 1, -46)
    cancelClanButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelClanButton.BorderSizePixel = 0
    cancelClanButton.Text = "Cancelar"
    cancelClanButton.TextColor3 = Theme.Colors.TextMuted
    cancelClanButton.Font = Theme.Font.Bold
    cancelClanButton.TextSize = 12
    cancelClanButton.ZIndex = 87
    cancelClanButton.Parent = clanForm

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelCorner.Parent = cancelClanButton

    local createClanButton = Instance.new("TextButton")
    createClanButton.Name = "CreateClanButton"
    createClanButton.Size = UDim2.new(0.5, -8, 0, 34)
    createClanButton.Position = UDim2.new(0.5, 8, 1, -46)
    createClanButton.BackgroundColor3 = CATEGORY_COLORS.clan
    createClanButton.BorderSizePixel = 0
    createClanButton.Text = "Crear"
    createClanButton.TextColor3 = Theme.Colors.Text
    createClanButton.Font = Theme.Font.Bold
    createClanButton.TextSize = 12
    createClanButton.ZIndex = 87
    createClanButton.Parent = clanForm

    local createCorner = Instance.new("UICorner")
    createCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    createCorner.Parent = createClanButton

    local chatStyleForm = Instance.new("Frame")
    chatStyleForm.Name = "ChatStyleForm"
    chatStyleForm.Size = UDim2.new(1, -32, 1, -76)
    chatStyleForm.Position = UDim2.new(0, 16, 0, 62)
    chatStyleForm.BackgroundColor3 = Theme.Colors.Background
    chatStyleForm.BorderSizePixel = 0
    chatStyleForm.Visible = false
    chatStyleForm.ZIndex = 86
    chatStyleForm.Parent = modal

    local chatStyleCorner = Instance.new("UICorner")
    chatStyleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    chatStyleCorner.Parent = chatStyleForm

    local chatStylePadding = Instance.new("UIPadding")
    chatStylePadding.PaddingTop = UDim.new(0, 12)
    chatStylePadding.PaddingLeft = UDim.new(0, 12)
    chatStylePadding.PaddingRight = UDim.new(0, 12)
    chatStylePadding.Parent = chatStyleForm

    local chatStyleTitle = Instance.new("TextLabel")
    chatStyleTitle.Name = "ChatStyleTitle"
    chatStyleTitle.Size = UDim2.new(1, -8, 0, 24)
    chatStyleTitle.BackgroundTransparency = 1
    chatStyleTitle.Text = "Chat Personalizado"
    chatStyleTitle.TextColor3 = Theme.Colors.Text
    chatStyleTitle.Font = Theme.Font.Bold
    chatStyleTitle.TextSize = 15
    chatStyleTitle.TextXAlignment = Enum.TextXAlignment.Left
    chatStyleTitle.ZIndex = 87
    chatStyleTitle.Parent = chatStyleForm

    local chatStyleHint = Instance.new("TextLabel")
    chatStyleHint.Name = "ChatStyleHint"
    chatStyleHint.Size = UDim2.new(1, -8, 0, 34)
    chatStyleHint.Position = UDim2.new(0, 0, 0, 26)
    chatStyleHint.BackgroundTransparency = 1
    chatStyleHint.Text = "Elige el estilo que quieres usar en tus mensajes."
    chatStyleHint.TextColor3 = Theme.Colors.TextMuted
    chatStyleHint.Font = Theme.Font.Regular
    chatStyleHint.TextSize = 12
    chatStyleHint.TextWrapped = true
    chatStyleHint.TextXAlignment = Enum.TextXAlignment.Left
    chatStyleHint.ZIndex = 87
    chatStyleHint.Parent = chatStyleForm

    local chatStyleOptions = Instance.new("Frame")
    chatStyleOptions.Name = "ChatStyleOptions"
    chatStyleOptions.Size = UDim2.new(1, -8, 1, -126)
    chatStyleOptions.Position = UDim2.new(0, 0, 0, 68)
    chatStyleOptions.BackgroundTransparency = 1
    chatStyleOptions.ZIndex = 87
    chatStyleOptions.Parent = chatStyleForm

    local chatStyleOptionsLayout = Instance.new("UIListLayout")
    chatStyleOptionsLayout.Padding = UDim.new(0, 8)
    chatStyleOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    chatStyleOptionsLayout.Parent = chatStyleOptions

    local cancelChatStyleButton = Instance.new("TextButton")
    cancelChatStyleButton.Name = "CancelChatStyleButton"
    cancelChatStyleButton.Size = UDim2.new(0.5, -8, 0, 34)
    cancelChatStyleButton.Position = UDim2.new(0, 0, 1, -46)
    cancelChatStyleButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelChatStyleButton.BorderSizePixel = 0
    cancelChatStyleButton.Text = "Cancelar"
    cancelChatStyleButton.TextColor3 = Theme.Colors.TextMuted
    cancelChatStyleButton.Font = Theme.Font.Bold
    cancelChatStyleButton.TextSize = 12
    cancelChatStyleButton.ZIndex = 87
    cancelChatStyleButton.Parent = chatStyleForm

    local cancelChatStyleCorner = Instance.new("UICorner")
    cancelChatStyleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelChatStyleCorner.Parent = cancelChatStyleButton

    local applyChatStyleButton = Instance.new("TextButton")
    applyChatStyleButton.Name = "ApplyChatStyleButton"
    applyChatStyleButton.Size = UDim2.new(0.5, -8, 0, 34)
    applyChatStyleButton.Position = UDim2.new(0.5, 8, 1, -46)
    applyChatStyleButton.BackgroundColor3 = CATEGORY_COLORS.chat_style
    applyChatStyleButton.BorderSizePixel = 0
    applyChatStyleButton.Text = "Usar"
    applyChatStyleButton.TextColor3 = Theme.Colors.Text
    applyChatStyleButton.Font = Theme.Font.Bold
    applyChatStyleButton.TextSize = 12
    applyChatStyleButton.ZIndex = 87
    applyChatStyleButton.Parent = chatStyleForm

    local applyChatStyleCorner = Instance.new("UICorner")
    applyChatStyleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    applyChatStyleCorner.Parent = applyChatStyleButton

    local selectedChatStyleItemId = nil
    local selectedChatStyleValue = nil
    local selectedChatStyleRows = {}
    local chatStyleUseCallback = nil

    local function clearList()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
    end

    local function setStatus(message, isError)
        statusLabel.Text = message or ""
        statusLabel.TextColor3 = isError and Color3.fromRGB(255, 120, 120) or Theme.Colors.TextMuted
    end

    local function showList()
        clanForm.Visible = false
        chatStyleForm.Visible = false
        list.Visible = true
    end

    local function showClanForm()
        list.Visible = false
        chatStyleForm.Visible = false
        clanForm.Visible = true
        setStatus("Completa los datos para crear tu clan.", false)
    end

    local function clearChatStyleOptions()
        for _, child in ipairs(chatStyleOptions:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        selectedChatStyleRows = {}
    end

    local function setSelectedChatStyle(itemId, styleValue)
        selectedChatStyleItemId = itemId
        selectedChatStyleValue = styleValue
        local selectedKey = tostring(itemId or "") .. ":" .. tostring(styleValue or "")

        for rowKey, row in pairs(selectedChatStyleRows) do
            row.BackgroundColor3 = rowKey == selectedKey and CATEGORY_COLORS.chat_style or Theme.Colors.PanelLight
        end
    end

    local function showChatStyleForm(items, onUse)
        list.Visible = false
        clanForm.Visible = false
        chatStyleForm.Visible = true
        chatStyleUseCallback = onUse
        selectedChatStyleItemId = nil
        selectedChatStyleValue = nil

        clearChatStyleOptions()

        local firstAvailableItemId = nil
        local firstAvailableStyleValue = nil

        for _, entry in ipairs(items or {}) do
            local item = getInventoryEntryData(entry)

            if item.category == "chat_style" then
                local styleOptions = {}

                if item.item_id == CUSTOM_CHAT_ITEM_ID then
                    styleOptions = CUSTOM_CHAT_STYLES
                else
                    local styleValue = tostring(item.value or item.item_id or "")

                    styleOptions = {
                        {
                            value = styleValue,
                            label = CHAT_STYLE_NAMES[styleValue] or tostring(item.name or "Estilo")
                        }
                    }
                end

                for _, styleOption in ipairs(styleOptions) do
                    local isStyleEquipped = tostring(entry.active_chat_style or "") == styleOption.value
                    local option = Instance.new("TextButton")
                    option.Name = "ChatStyleOption"
                    option.Size = UDim2.new(1, 0, 0, 38)
                    option.BackgroundColor3 = Theme.Colors.PanelLight
                    option.BorderSizePixel = 0
                    option.Text = styleOption.label .. (isStyleEquipped and "  En uso" or "")
                    option.TextColor3 = Theme.Colors.Text
                    option.Font = Theme.Font.Bold
                    option.TextSize = 12
                    option.TextXAlignment = Enum.TextXAlignment.Left
                    option.ZIndex = 88
                    option.Parent = chatStyleOptions

                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
                    optionCorner.Parent = option

                    local optionPadding = Instance.new("UIPadding")
                    optionPadding.PaddingLeft = UDim.new(0, 12)
                    optionPadding.PaddingRight = UDim.new(0, 12)
                    optionPadding.Parent = option

                    local rowKey = tostring(item.item_id or "") .. ":" .. tostring(styleOption.value or "")
                    selectedChatStyleRows[rowKey] = option

                    if not firstAvailableItemId and not isStyleEquipped then
                        firstAvailableItemId = item.item_id
                        firstAvailableStyleValue = styleOption.value
                    end

                    option.MouseButton1Click:Connect(function()
                        if not isStyleEquipped then
                            setSelectedChatStyle(item.item_id, styleOption.value)
                        end
                    end)
                end
            end
        end

        if firstAvailableItemId then
            setSelectedChatStyle(firstAvailableItemId, firstAvailableStyleValue)
            setStatus("Selecciona el estilo de chat que quieres usar.", false)
        else
            setStatus("No tienes estilos de chat disponibles para aplicar.", true)
        end
    end

    local function renderEmpty(message)
        clearList()

        local empty = Instance.new("TextLabel")
        empty.Name = "Empty"
        empty.Size = UDim2.new(1, -10, 0, 118)
        empty.BackgroundTransparency = 1
        empty.Text = message or "Todavia no tienes items comprados."
        empty.TextColor3 = Theme.Colors.TextMuted
        empty.Font = Theme.Font.Regular
        empty.TextSize = 12
        empty.TextWrapped = true
        empty.TextXAlignment = Enum.TextXAlignment.Center
        empty.TextYAlignment = Enum.TextYAlignment.Center
        empty.ZIndex = 83
        empty.Parent = list
    end

    local function renderItem(entry, onUse, items)
        local item = getInventoryEntryData(entry)
        local accent = CATEGORY_COLORS[item.category] or Theme.Colors.Accent

        local row = Instance.new("Frame")
        row.Name = "InventoryItem"
        row.Size = UDim2.new(1, -4, 0, 74)
        row.BackgroundColor3 = Theme.Colors.PanelLight
        row.BackgroundTransparency = 0.08
        row.BorderSizePixel = 0
        row.ZIndex = 83
        row.Parent = list

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        rowCorner.Parent = row

        local stroke = Instance.new("UIStroke")
        stroke.Color = accent
        stroke.Thickness = 1
        stroke.Transparency = entry.is_equipped and 0.05 or 0.45
        stroke.Parent = row

        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Size = UDim2.new(1, -126, 0, 22)
        name.Position = UDim2.new(0, 12, 0, 9)
        name.BackgroundTransparency = 1
        name.Text = tostring(item.name or item.item_id or "Item")
        name.TextColor3 = Theme.Colors.Text
        name.Font = Theme.Font.Bold
        name.TextSize = 13
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.ZIndex = 84
        name.Parent = row

        local category = Instance.new("TextLabel")
        category.Name = "Category"
        category.Size = UDim2.new(1, -126, 0, 18)
        category.Position = UDim2.new(0, 12, 0, 31)
        category.BackgroundTransparency = 1
        category.Text = CATEGORY_LABELS[item.category] or tostring(item.category or "Item")
        category.TextColor3 = accent
        category.Font = Theme.Font.Bold
        category.TextSize = 11
        category.TextXAlignment = Enum.TextXAlignment.Left
        category.TextTruncate = Enum.TextTruncate.AtEnd
        category.ZIndex = 84
        category.Parent = row

        local description = Instance.new("TextLabel")
        description.Name = "Description"
        description.Size = UDim2.new(1, -126, 0, 18)
        description.Position = UDim2.new(0, 12, 0, 50)
        description.BackgroundTransparency = 1
        description.Text = tostring(item.description or "")
        description.TextColor3 = Theme.Colors.TextMuted
        description.Font = Theme.Font.Regular
        description.TextSize = 10
        description.TextXAlignment = Enum.TextXAlignment.Left
        description.TextTruncate = Enum.TextTruncate.AtEnd
        description.ZIndex = 84
        description.Parent = row

        local useButton = Instance.new("TextButton")
        useButton.Name = "UseButton"
        useButton.Size = UDim2.new(0, 88, 0, 32)
        useButton.Position = UDim2.new(1, -100, 0.5, -16)
        useButton.BackgroundColor3 = entry.is_equipped and Color3.fromRGB(60, 65, 75) or accent
        useButton.BorderSizePixel = 0
        useButton.Text = entry.is_equipped and "En uso" or "Usar"
        useButton.TextColor3 = Theme.Colors.Text
        useButton.Font = Theme.Font.Bold
        useButton.TextSize = 11
        useButton.AutoButtonColor = entry.can_use and not entry.is_equipped
        useButton.Active = entry.can_use and not entry.is_equipped
        useButton.ZIndex = 84
        useButton.Parent = row

        local useCorner = Instance.new("UICorner")
        useCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        useCorner.Parent = useButton

        if not entry.can_use then
            useButton.Text = "Guardado"
            useButton.BackgroundColor3 = Color3.fromRGB(55, 58, 66)
            useButton.TextColor3 = Theme.Colors.TextMuted
        elseif item.item_id == "clan_ticket" and not entry.is_equipped then
            useButton.Text = "Crear"
        elseif item.category == "chat_style" and (not entry.is_equipped or item.item_id == CUSTOM_CHAT_ITEM_ID) then
            useButton.Text = "Elegir"
            useButton.AutoButtonColor = entry.can_use
            useButton.Active = entry.can_use
        end

        useButton.MouseButton1Click:Connect(function()
            if entry.can_use and (not entry.is_equipped or item.item_id == CUSTOM_CHAT_ITEM_ID) and onUse then
                if item.category == "chat_style" then
                    showChatStyleForm(items, onUse)
                else
                    onUse(item.item_id)
                end
            end
        end)
    end

    local function render(items, onUse)
        clearList()

        if not items or #items == 0 then
            renderEmpty("Todavia no tienes items comprados.")
            return
        end

        for _, entry in ipairs(items) do
            renderItem(entry, onUse, items)
        end

        task.wait()

        list.CanvasSize = UDim2.new(
            0,
            0,
            0,
            layout.AbsoluteContentSize.Y + 22
        )
    end

    closeButton.MouseButton1Click:Connect(function()
        overlay.Visible = false
    end)

    colorButton.MouseButton1Click:Connect(function()
        selectedColorIndex = selectedColorIndex + 1

        if selectedColorIndex > #COLOR_OPTIONS then
            selectedColorIndex = 1
        end

        local option = getSelectedColorOption()

        colorButton.Text = "Color: " .. option.label
        colorButton.BackgroundColor3 = option.color
    end)

    styleButton.MouseButton1Click:Connect(function()
        selectedStyleIndex = selectedStyleIndex + 1

        if selectedStyleIndex > #STYLE_OPTIONS then
            selectedStyleIndex = 1
        end

        styleButton.Text = getSelectedStyleOption().label
    end)

    cancelClanButton.MouseButton1Click:Connect(function()
        showList()
        setStatus("", false)
    end)

    cancelChatStyleButton.MouseButton1Click:Connect(function()
        showList()
        setStatus("", false)
    end)

    applyChatStyleButton.MouseButton1Click:Connect(function()
        if selectedChatStyleItemId and chatStyleUseCallback then
            chatStyleUseCallback(selectedChatStyleItemId, selectedChatStyleValue)
        else
            setStatus("Selecciona un estilo de chat.", true)
        end
    end)

    renderEmpty("Abre el inventario para cargar tus items.")

    return {
        Overlay = overlay,
        CloseButton = closeButton,
        StatusLabel = statusLabel,

        Open = function()
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end,

        Render = render,
        RenderEmpty = renderEmpty,
        ShowStatus = setStatus,
        ShowClanForm = showClanForm,
        ShowChatStyleForm = showChatStyleForm,
        ShowList = showList,
        CreateClanButton = createClanButton,

        GetClanFormData = function()
            return {
                name = clanNameInput.Text or "",
                tag = clanTagInput.Text or "",
                color = getSelectedColorOption().value,
                tag_style = getSelectedStyleOption().value
            }
        end,

        Destroy = function()
            overlay:Destroy()
        end
    }
end

return InventoryUI
