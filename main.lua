local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local running = true

local currentRoom = {
    id = "global",
    name = "Chat General",
    type = "GLOBAL"
}

local HEARTBEAT_INTERVAL = 15
local CHAT_REFRESH_INTERVAL = 3
local ONLINE_REFRESH_INTERVAL = 5

local BASE_RAW = "https://raw.githubusercontent.com/clayyy333/StrikeChat-lua/main/"

local Theme = loadstring(game:HttpGet(BASE_RAW .. "modules/theme.lua"))()
local Api = loadstring(game:HttpGet(BASE_RAW .. "modules/api.lua"))()
local MainWindow = loadstring(game:HttpGet(BASE_RAW .. "modules/main_window.lua"))()
local ChatPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/chat_panel.lua"))()
local LeftPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/left_panel.lua"))()
local RightPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/right_panel.lua"))()
local CreateRoomModal = loadstring(game:HttpGet(BASE_RAW .. "modules/create_room_modal.lua"))()
local RoomsListModal = loadstring(game:HttpGet(BASE_RAW .. "modules/rooms_list_modal.lua"))()
local PasswordModal = loadstring(game:HttpGet(BASE_RAW .. "modules/password_modal.lua"))()
local ConfirmModal = loadstring(game:HttpGet(BASE_RAW .. "modules/confirm_modal.lua"))()
local ClanTableUI = loadstring(game:HttpGet(BASE_RAW .. "modules/clan_table_ui.lua"))()
local ShopUI = loadstring(game:HttpGet(BASE_RAW .. "modules/shop_ui.lua"))()
local RewardModal = loadstring(game:HttpGet(BASE_RAW .. "modules/reward_modal.lua"))()
local ProfileUI = loadstring(game:HttpGet(BASE_RAW .. "modules/profile_ui.lua"))()
local PublicProfileUI = loadstring(game:HttpGet(BASE_RAW .. "modules/public_profile_ui.lua"))()
local InventoryUI = loadstring(game:HttpGet(BASE_RAW .. "modules/inventory_ui.lua"))()

local function getCurrentGameActivity()
    local placeName = nil

    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)

    if success and info and info.Name then
        placeName = tostring(info.Name)
    end

    if not placeName or placeName:gsub("%s+", "") == "" then
        placeName = tostring(game.Name or "Roblox")
    end

    return {
        place_id = game.PlaceId,
        place_name = placeName
    }
end

local currentGameActivity = getCurrentGameActivity()

if not Api.HasRequest() then
    warn("Executor sin soporte request/http_request")
    return
end

local heartbeatResult = Api.Heartbeat(player, currentGameActivity)

if not heartbeatResult or heartbeatResult.status ~= "ok" then
    warn("No se pudo conectar con StrikeChat API")
    return
end

local window = MainWindow.Create(CoreGui, Theme)
local chatPanel = ChatPanel.Create(window.ChatPanel, Theme)
local leftPanel = LeftPanel.Create(window.LeftPanel, Theme, heartbeatResult.profile, player)
local rightPanel = RightPanel.Create(window.RightPanel, Theme)

local adminNotice = Instance.new("TextLabel")
adminNotice.Name = "AdminNotice"
adminNotice.Size = UDim2.new(0, 360, 0, 22)
adminNotice.Position = UDim2.new(0.5, -170, 0, 92)
adminNotice.BackgroundTransparency = 1
adminNotice.Text = ""
adminNotice.Visible = false
adminNotice.TextColor3 = Color3.fromRGB(255, 175, 8)
adminNotice.Font = Theme.Font.Bold
adminNotice.TextSize = 13
adminNotice.TextTransparency = 0
adminNotice.TextXAlignment = Enum.TextXAlignment.Center
adminNotice.Parent = window.Gui

task.spawn(function()
    local fadeOut = true

    while adminNotice.Parent do
        if fadeOut then
            adminNotice.TextTransparency += 0.02

            if adminNotice.TextTransparency >= 0.45 then
                fadeOut = false
            end
        else
            adminNotice.TextTransparency -= 0.02

            if adminNotice.TextTransparency <= 0 then
                fadeOut = true
            end
        end

        task.wait(0.05)
    end
end)



if heartbeatResult.user and heartbeatResult.user.current_room_id then
    currentRoom.id = heartbeatResult.user.current_room_id
    currentRoom.name = heartbeatResult.user.current_room_name or "Sala"
    currentRoom.type = "SALA"

    chatPanel.Title.Text = currentRoom.name
    chatPanel.RoomType.Text = currentRoom.type
    chatPanel.LeaveButton.Visible = true

    leftPanel.Buttons.CrearSalas.Active = false
    leftPanel.Buttons.CrearSalas.AutoButtonColor = false
    leftPanel.Buttons.CrearSalas.BackgroundTransparency = 0.45
else
    chatPanel.LeaveButton.Visible = false
end

local createRoomModal = CreateRoomModal.Create(window.Gui, Theme)
local roomsListModal = RoomsListModal.Create(window.Gui, Theme)
local passwordModal = PasswordModal.Create(window.Gui, Theme)
local confirmModal = ConfirmModal.Create(window.Gui, Theme)




chatPanel.Title.Text = currentRoom.name
chatPanel.RoomType.Text = currentRoom.type

local lastChatSignature = ""

local avatarCache = {}
local setRoom
local selectedPrivateRoom = nil
local confirmAction = nil

local CUTE_CLOUD_IMAGE = "rbxassetid://104316530590118"
local GATODARK_CHAT_IMAGE = "rbxassetid://127028607584333"

local clanColorMap = {
    white = Color3.fromRGB(245, 245, 245),
    red = Color3.fromRGB(235, 74, 74),
    green = Color3.fromRGB(78, 190, 92),
    blue = Color3.fromRGB(74, 142, 245),
    yellow = Color3.fromRGB(245, 205, 70),
    orange = Color3.fromRGB(255, 156, 64),
    pink = Color3.fromRGB(255, 110, 180),
    purple = Color3.fromRGB(168, 6, 235),
    black = Color3.fromRGB(32, 32, 36),
    cyan = Color3.fromRGB(64, 210, 230)
}

local function getClanColor(colorName)
    local key = tostring(colorName or ""):lower()

    return clanColorMap[key] or Theme.Colors.TextMuted
end


task.spawn(function()
    while true do
        local noticesResult = Api.GetAdminNotices()

        if noticesResult
            and noticesResult.status == "ok"
            and noticesResult.notices
            and #noticesResult.notices > 0
        then
            local firstNotice = noticesResult.notices[1]

            adminNotice.Text =
                "ADMIN : " .. tostring(firstNotice.message)

            adminNotice.Visible = true
        else
            adminNotice.Visible = false
        end

        task.wait(15)
    end
end)



local function getAvatarImage(userId)
    if avatarCache[userId] then
        return avatarCache[userId]
    end

    local success, content = pcall(function()
        return Players:GetUserThumbnailAsync(
            userId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)

    if success then
        avatarCache[userId] = content
        return content
    end

    return ""
end

local function renderMessages(messages)
    local signature = HttpService:JSONEncode(messages or {})

    if signature == lastChatSignature then
        return
    end

    lastChatSignature = signature

    for _, child in ipairs(chatPanel.MessagesBox:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, msg in ipairs(messages or {}) do
        if msg.type == "system" then
            local systemLabel = Instance.new("TextLabel")
            systemLabel.Size = UDim2.new(1, -8, 0, 28)
            systemLabel.BackgroundTransparency = 1
            systemLabel.TextColor3 = Theme.Colors.TextMuted
            systemLabel.Font = Theme.Font.Regular
            systemLabel.TextSize = 12
            systemLabel.TextXAlignment = Enum.TextXAlignment.Left
            systemLabel.TextWrapped = true
            systemLabel.Text = "[SYSTEM] " .. tostring(msg.message)
            systemLabel.Parent = chatPanel.MessagesBox
        else
            local container = Instance.new("Frame")
            container.Name = "MessageContainer"
            container.Size = UDim2.new(1, -8, 0, 58)
            container.BackgroundColor3 = Theme.Colors.Panel
            container.BackgroundTransparency = 1
            container.BorderSizePixel = 0
            container.Parent = chatPanel.MessagesBox

            local avatar = Instance.new("ImageLabel")
            avatar.Name = "Avatar"
            avatar.Size = UDim2.new(0, 34, 0, 34)
            avatar.Position = UDim2.new(0, 0, 0, 4)
            avatar.BackgroundTransparency = 1
            avatar.Image = getAvatarImage(msg.roblox_user_id)
            avatar.ZIndex = 3
            avatar.Parent = container

            local avatarCorner = Instance.new("UICorner")
            avatarCorner.CornerRadius = UDim.new(1, 0)
            avatarCorner.Parent = avatar

            local name = msg.display_name or msg.username or "Usuario"

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "Name"
            nameLabel.Size = UDim2.new(0, 0, 0, 18)
            nameLabel.Position = UDim2.new(0, 44, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = tostring(name)
            nameLabel.TextColor3 = Theme.Colors.Text
            nameLabel.Font = Theme.Font.Bold
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.ZIndex = 3
            nameLabel.Parent = container

            local clanText = ""

            if msg.clan_tag then
                if msg.clan_tag_style == "plain" then
                    clanText = "_" .. tostring(msg.clan_tag)
                else
                    clanText = "[" .. tostring(msg.clan_tag) .. "]"
                end
            end

            local clanLabel = Instance.new("TextLabel")
            clanLabel.Name = "ClanTag"
            clanLabel.Size = UDim2.new(0, 0, 0, 18)
            clanLabel.Position = UDim2.new(0, 44, 0, 0)
            clanLabel.BackgroundTransparency = 1
            clanLabel.Text = clanText
            clanLabel.TextColor3 = getClanColor(msg.clan_color)
            clanLabel.Font = Theme.Font.Bold
            clanLabel.TextSize = 11
            clanLabel.TextXAlignment = Enum.TextXAlignment.Left
            clanLabel.TextTruncate = Enum.TextTruncate.AtEnd
            clanLabel.ZIndex = 3
            clanLabel.Parent = container

            local headerWidth =
                math.max(container.AbsoluteSize.X - 52, 180)
            local spacing = 0
            local tagWidth = 0

            if clanText ~= "" then
                tagWidth = TextService:GetTextSize(
                    clanText,
                    clanLabel.TextSize,
                    clanLabel.Font,
                    Vector2.new(headerWidth, 18)
                ).X + 4
            end

            local maxNameWidth = math.max(headerWidth - tagWidth - spacing, 60)
            local measuredNameWidth = TextService:GetTextSize(
                tostring(name),
                nameLabel.TextSize,
                nameLabel.Font,
                Vector2.new(maxNameWidth, 18)
            ).X + 2
            local nameWidth = math.min(measuredNameWidth, maxNameWidth)

            nameLabel.Size = UDim2.new(0, nameWidth, 0, 18)
            clanLabel.Visible = clanText ~= ""
            clanLabel.Size = UDim2.new(0, math.max(tagWidth, 20), 0, 18)
            clanLabel.Position = UDim2.new(0, 44 + nameWidth + spacing, 0, 0)

            local chatStyle = tostring(msg.chat_style or ""):lower()
            local hasCuteCloudStyle =
                chatStyle == "cloud" or
                chatStyle == "chat_style_cloud"
            local hasGatoDarkStyle =
                chatStyle == "gatodark" or
                chatStyle == "gato_dark" or
                chatStyle == "chat_style_gatodark"
            local hasPremiumChatStyle = hasCuteCloudStyle or hasGatoDarkStyle
            local gatoRightPadding = 214
            local gatoMinHeight = 64
            local messageRightPadding = hasGatoDarkStyle and gatoRightPadding or 50

            if hasCuteCloudStyle then
                messageRightPadding = 152
            end

            local messageMeasureWidth = math.max(
                chatPanel.MessagesBox.AbsoluteSize.X - 44 - messageRightPadding - 8,
                80
            )
            local measuredMessage = TextService:GetTextSize(
                tostring(msg.message),
                13,
                Theme.Font.Regular,
                Vector2.new(messageMeasureWidth, math.huge)
            )
            local messageHeight = math.max(34, math.ceil(measuredMessage.Y) + 2)
            local containerHeight = math.max(58, 20 + messageHeight + 6)

            if hasGatoDarkStyle then
                containerHeight = math.max(gatoMinHeight, 24 + messageHeight + 10)
            end

            container.Size = UDim2.new(1, -8, 0, containerHeight)

            if hasCuteCloudStyle then
                local premiumBubble = Instance.new("Frame")
                premiumBubble.Name = "PremiumChatBubble"
                premiumBubble.Size = UDim2.new(1, -72, 0, containerHeight - 16)
                premiumBubble.Position = UDim2.new(0, 40, 0, 14)
                premiumBubble.BackgroundColor3 = Color3.fromRGB(242, 247, 255)
                premiumBubble.BackgroundTransparency = 0.04
                premiumBubble.BorderSizePixel = 0
                premiumBubble.ZIndex = 1
                premiumBubble.Parent = container

                local premiumCorner = Instance.new("UICorner")
                premiumCorner.CornerRadius = UDim.new(0, 12)
                premiumCorner.Parent = premiumBubble

                local premiumStroke = Instance.new("UIStroke")
                premiumStroke.Color = Color3.fromRGB(205, 228, 255)
                premiumStroke.Thickness = 1
                premiumStroke.Transparency = 0.25
                premiumStroke.Parent = premiumBubble

                local premiumAccent = Instance.new("ImageLabel")
                premiumAccent.Name = "CuteCloudAccent"
                premiumAccent.Size = UDim2.new(0, 96, 0, 50)
                premiumAccent.Position = UDim2.new(1, -104, 0, 4)
                premiumAccent.BackgroundTransparency = 1
                premiumAccent.Image = CUTE_CLOUD_IMAGE
                premiumAccent.ScaleType = Enum.ScaleType.Fit
                premiumAccent.ImageTransparency = 0
                premiumAccent.ZIndex = 2
                premiumAccent.Parent = container
            end

            if hasGatoDarkStyle then
                local gatoDarkBubble = Instance.new("Frame")
                gatoDarkBubble.Name = "GatoDarkBubble"
                gatoDarkBubble.Size = UDim2.new(1, 0, 0, containerHeight)
                gatoDarkBubble.Position = UDim2.new(0, 0, 0, 0)
                gatoDarkBubble.BackgroundColor3 = Theme.Colors.Panel
                gatoDarkBubble.BackgroundTransparency = 0
                gatoDarkBubble.BorderSizePixel = 0
                gatoDarkBubble.ClipsDescendants = true
                gatoDarkBubble.ZIndex = 2
                gatoDarkBubble.Parent = container

                local gatoDarkGradient = Instance.new("UIGradient")
                gatoDarkGradient.Rotation = 0
                gatoDarkGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Theme.Colors.Panel),
                    ColorSequenceKeypoint.new(0.24, Color3.fromRGB(62, 45, 68)),
                    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(142, 52, 74)),
                    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(72, 58, 92)),
                    ColorSequenceKeypoint.new(1.00, Theme.Colors.Panel)
                })
                gatoDarkGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.00, 1.00),
                    NumberSequenceKeypoint.new(0.22, 0.42),
                    NumberSequenceKeypoint.new(0.48, 0.10),
                    NumberSequenceKeypoint.new(0.74, 0.48),
                    NumberSequenceKeypoint.new(1.00, 1.00)
                })
                gatoDarkGradient.Parent = gatoDarkBubble

                local gatoDarkCorner = Instance.new("UICorner")
                gatoDarkCorner.CornerRadius = UDim.new(0, 12)
                gatoDarkCorner.Parent = gatoDarkBubble

                local gatoDarkEdgeLeft = Instance.new("Frame")
                gatoDarkEdgeLeft.Name = "GatoDarkEdgeLeft"
                gatoDarkEdgeLeft.Size = UDim2.new(0, 90, 1, 0)
                gatoDarkEdgeLeft.Position = UDim2.new(0, 0, 0, 0)
                gatoDarkEdgeLeft.BackgroundColor3 = Color3.fromRGB(118, 44, 70)
                gatoDarkEdgeLeft.BackgroundTransparency = 0.18
                gatoDarkEdgeLeft.BorderSizePixel = 0
                gatoDarkEdgeLeft.ZIndex = 2
                gatoDarkEdgeLeft.Parent = gatoDarkBubble

                local gatoDarkEdgeLeftGradient = Instance.new("UIGradient")
                gatoDarkEdgeLeftGradient.Rotation = 0
                gatoDarkEdgeLeftGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Theme.Colors.Panel),
                    ColorSequenceKeypoint.new(0.46, Color3.fromRGB(132, 52, 82)),
                    ColorSequenceKeypoint.new(1.00, Theme.Colors.Panel)
                })
                gatoDarkEdgeLeftGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.00, 1.00),
                    NumberSequenceKeypoint.new(0.34, 0.62),
                    NumberSequenceKeypoint.new(1.00, 1.00)
                })
                gatoDarkEdgeLeftGradient.Parent = gatoDarkEdgeLeft

                local gatoDarkEdgeRight = Instance.new("Frame")
                gatoDarkEdgeRight.Name = "GatoDarkEdgeRight"
                gatoDarkEdgeRight.Size = UDim2.new(0, 170, 1, 0)
                gatoDarkEdgeRight.Position = UDim2.new(1, -170, 0, 0)
                gatoDarkEdgeRight.BackgroundColor3 = Color3.fromRGB(144, 54, 68)
                gatoDarkEdgeRight.BackgroundTransparency = 0.1
                gatoDarkEdgeRight.BorderSizePixel = 0
                gatoDarkEdgeRight.ZIndex = 2
                gatoDarkEdgeRight.Parent = gatoDarkBubble

                local gatoDarkEdgeRightGradient = Instance.new("UIGradient")
                gatoDarkEdgeRightGradient.Rotation = 0
                gatoDarkEdgeRightGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Theme.Colors.Panel),
                    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(176, 62, 72)),
                    ColorSequenceKeypoint.new(0.72, Color3.fromRGB(84, 58, 100)),
                    ColorSequenceKeypoint.new(1.00, Theme.Colors.Panel)
                })
                gatoDarkEdgeRightGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.00, 1.00),
                    NumberSequenceKeypoint.new(0.28, 0.54),
                    NumberSequenceKeypoint.new(0.58, 0.18),
                    NumberSequenceKeypoint.new(1.00, 1.00)
                })
                gatoDarkEdgeRightGradient.Parent = gatoDarkEdgeRight

                local gatoDarkAccent = Instance.new("ImageLabel")
                gatoDarkAccent.Name = "GatoDarkAccent"
                gatoDarkAccent.Size = UDim2.new(0, 190, 0, 82)
                gatoDarkAccent.Position = UDim2.new(1, -176, 0, -24)
                gatoDarkAccent.BackgroundTransparency = 1
                gatoDarkAccent.Image = GATODARK_CHAT_IMAGE
                gatoDarkAccent.ScaleType = Enum.ScaleType.Fit
                gatoDarkAccent.ImageTransparency = 0.08
                gatoDarkAccent.ZIndex = 3
                gatoDarkAccent.Parent = container
            end

            local messageText = Instance.new("TextLabel")
            messageText.Name = "Message"
            if hasCuteCloudStyle then
                messageText.Size = UDim2.new(1, -152, 0, messageHeight)
            elseif hasGatoDarkStyle then
                messageText.Size = UDim2.new(1, -gatoRightPadding, 0, messageHeight)
            else
                messageText.Size = UDim2.new(1, -50, 0, messageHeight)
            end
            if hasGatoDarkStyle then
                messageText.Position = UDim2.new(0, 44, 0, 20)
            else
                messageText.Position = UDim2.new(0, 44, 0, 20)
            end
            messageText.BackgroundTransparency = 1
            messageText.Text = tostring(msg.message)
            if hasCuteCloudStyle then
                messageText.TextColor3 = Color3.fromRGB(20, 20, 20)
            elseif hasGatoDarkStyle then
                messageText.TextColor3 = Color3.fromRGB(238, 238, 245)
            else
                messageText.TextColor3 = Theme.Colors.Text
            end
            messageText.Font = Theme.Font.Regular
            messageText.TextSize = 13
            messageText.TextXAlignment = Enum.TextXAlignment.Left
            messageText.TextYAlignment = Enum.TextYAlignment.Top
            messageText.TextWrapped = true
            messageText.ZIndex = hasPremiumChatStyle and 5 or 1
            messageText.Parent = container
        end
    end

    task.wait()

    chatPanel.MessagesBox.CanvasSize = UDim2.new(
        0,
        0,
        0,
        chatPanel.Layout.AbsoluteContentSize.Y + 16
    )

    chatPanel.MessagesBox.CanvasPosition = Vector2.new(
        0,
        chatPanel.MessagesBox.AbsoluteCanvasSize.Y
    )
end

local function refreshChat()
    local result

    if currentRoom.id == "global" then
        result = Api.GetGlobalMessages()
    else
        result = Api.GetRoomMessages(currentRoom.id)
    end

    if result and result.messages then
        renderMessages(result.messages)
    end
end

local function refreshOnlineUsers()
    if currentRoom.id == "global" then
        local result = Api.GetOnlineUsers()

        if result and result.users then
            rightPanel.Title.Text =
                "En Línea - " .. tostring(#result.users)

            rightPanel.Render(result.users)
        end

        return
    end

    local membersResult = Api.GetRoomMembers(currentRoom.id)

    if not membersResult or not membersResult.members then
        return
    end

    local onlineResult = Api.GetOnlineUsers()

    if not onlineResult or not onlineResult.users then
        return
    end

    local roomUsers = {}

    for _, onlineUser in ipairs(onlineResult.users) do
        for _, memberId in ipairs(membersResult.members) do
            if onlineUser.roblox_user_id == memberId then
                table.insert(roomUsers, onlineUser)
                break
            end
        end
    end

    rightPanel.Title.Text =
        "En Sala - " .. tostring(#roomUsers)

    rightPanel.Render(roomUsers)
end

local function refreshRooms(isPrivate)
    roomsListModal.Clear()

    local testLabel = Instance.new("TextLabel")
    testLabel.Size = UDim2.new(1, 0, 0, 40)
    testLabel.BackgroundTransparency = 1
    testLabel.Text = "Cargando salas..."
    testLabel.TextColor3 = Theme.Colors.Text
    testLabel.Font = Theme.Font.Bold
    testLabel.TextSize = 13
    testLabel.Parent = roomsListModal.List

    local result

    if isPrivate then
        result = Api.GetPrivateRooms()
        roomsListModal.Title.Text = "Salas Privadas"
    else
        result = Api.GetPublicRooms()
        roomsListModal.Title.Text = "Salas Públicas"
    end

    if not result or not result.rooms then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text = "No se pudieron cargar salas."
        empty.TextColor3 = Theme.Colors.TextMuted
        empty.Font = Theme.Font.Regular
        empty.TextSize = 12
        empty.Parent = roomsListModal.List
        return
    end

    for index, room in ipairs(result.rooms) do

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 34)
        button.BackgroundColor3 = Theme.Colors.PanelLight
        button.BackgroundTransparency = 0.25
        button.BorderSizePixel = 0
        button.Text = ""
        button.ZIndex = 63
        button.Parent = roomsListModal.List

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        corner.Parent = button

        local roomNumber = Instance.new("TextLabel")
        roomNumber.Size = UDim2.new(0, 40, 1, 0)
        roomNumber.Position = UDim2.new(0, 18, 0, 0)
        roomNumber.BackgroundTransparency = 1
        roomNumber.Text = tostring(index) .. "."
        roomNumber.TextColor3 = Theme.Colors.Text
        roomNumber.Font = Theme.Font.Bold
        roomNumber.TextSize = 13
        roomNumber.TextXAlignment = Enum.TextXAlignment.Left
        roomNumber.ZIndex = 64
        roomNumber.Active = false
        roomNumber.Parent = button

        local roomName = Instance.new("TextLabel")
        roomName.Size = UDim2.new(1, -80, 1, 0)
        roomName.Position = UDim2.new(0, 88, 0, 0)
        roomName.BackgroundTransparency = 1
        roomName.Text = room.display_name
        roomName.TextColor3 = Theme.Colors.Text
        roomName.Font = Theme.Font.Bold
        roomName.TextSize = 13
        roomName.TextXAlignment = Enum.TextXAlignment.Left
        roomName.TextTruncate = Enum.TextTruncate.AtEnd
        roomName.ZIndex = 64
        roomName.Active = false
        roomName.Parent = button

        local memberCount = Instance.new("TextLabel")
        memberCount.Size = UDim2.new(0, 56, 1, 0)
        memberCount.Position = UDim2.new(1, -108, 0, 0)
        memberCount.BackgroundTransparency = 1
        memberCount.Text =
            tostring(#(room.members or {})) ..
            " usuarios"
        memberCount.TextColor3 = Theme.Colors.TextMuted
        memberCount.Font = Theme.Font.Regular
        memberCount.TextSize = 11
        memberCount.TextXAlignment = Enum.TextXAlignment.Right
        memberCount.ZIndex = 64
        memberCount.Active = false
        memberCount.Parent = button

        button.MouseButton1Click:Connect(function()

            if currentRoom.id == room.room_id then

                confirmAction = function()

                    confirmModal.Close()
                    roomsListModal.Close()

                end

                confirmModal.Open(
                    "Ya perteneces a esta sala",
                    "Volver a la sala",
                    ""
                )

                confirmModal.SecondaryButton.Visible = false

                return
            end
            
            if currentRoom.id ~= "global" then

                selectedPrivateRoom = room

                confirmAction = function()

                    Api.LeaveRoom(player, currentRoom.id)

                    if isPrivate then
                        passwordModal.Open()
                        confirmModal.Close()
                        return
                    end

                    local result = Api.JoinRoom(
                        player,
                        room.room_id,
                        ""
                    )

                    if result and result.status == "joined" then

                        local joinedRoom = result.room or room

                        setRoom(
                            joinedRoom.room_id,
                            joinedRoom.display_name,
                            "PUBLICA"
                        )

                        roomsListModal.Close()

                        refreshChat()
                        refreshOnlineUsers()
                    end

                end


                confirmModal.Open(
                    "Te encuentras en una sala.\n¿Quieres moverte a esta sala?",
                    "Entrar",
                    "Cancelar"
                )

                confirmModal.SecondaryButton.Visible = true

                return
            end


            if isPrivate then
                selectedPrivateRoom = room
                passwordModal.Open()
                return
            end

            
            local result = Api.JoinRoom(player, room.room_id, "")

            if result and result.status == "joined" then
                local joinedRoom = result.room or room

                setRoom(
                    joinedRoom.room_id,
                    joinedRoom.display_name,
                    "PUBLICA"
                )

                roomsListModal.Close()
                refreshChat()
                refreshOnlineUsers()
            else
                showStatus(result and result.reason or "No se pudo entrar a la sala.")
            end
        end)



    end

    task.wait()

    roomsListModal.List.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            roomsListModal.Layout.AbsoluteContentSize.Y + 16
        )
end


local function showStatus(message)
    chatPanel.StatusLabel.Text = message or ""

    if message and message ~= "" then
        task.spawn(function()
            local currentMessage = chatPanel.StatusLabel.Text

            task.wait(4)

            if chatPanel.StatusLabel.Text == currentMessage then
                chatPanel.StatusLabel.Text = ""
            end
        end)
    end
end

setRoom = function(roomId, roomName, roomType)
    currentRoom.id = roomId
    currentRoom.name = roomName
    currentRoom.type = roomType

    chatPanel.Title.Text = roomName
    chatPanel.RoomType.Text = roomType

    chatPanel.LeaveButton.Visible = roomId ~= "global"

    local createRoomButton = leftPanel.Buttons.CrearSalas
    local isInRoom = roomId ~= "global"

    chatPanel.LeaveButton.Visible = isInRoom
    createRoomButton.Active = not isInRoom
    createRoomButton.AutoButtonColor = not isInRoom

    if isInRoom then
        createRoomButton.BackgroundTransparency = 0.45
    else
        createRoomButton.BackgroundTransparency = 0
    end

    lastChatSignature = ""
end

local function sendCurrentMessage()
    local text = chatPanel.Input.Text

    if not text or text:gsub("%s+", "") == "" then
        return
    end

    chatPanel.Input.Text = ""

    local result

    if currentRoom.id == "global" then
        result = Api.SendGlobalMessage(player, text)
    else
        result = Api.SendRoomMessage(player, currentRoom.id, text)
    end

    if result and result.status == "blocked" then
        showStatus(result.display_message or "No puedes enviar este mensaje.")
    else
        showStatus("")
    end

    task.wait(0.2)
    refreshChat()
end

chatPanel.SendButton.MouseButton1Click:Connect(sendCurrentMessage)

chatPanel.Input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendCurrentMessage()
    end
end)

leftPanel.Buttons.CrearSalas.MouseButton1Click:Connect(function()
    if currentRoom.id ~= "global" then
        return
    end

    createRoomModal.Open()
end)

leftPanel.Buttons.SalasPublicas.MouseButton1Click:Connect(function()
    refreshRooms(false)
    roomsListModal.Open()
end)

leftPanel.Buttons.SalasPrivadas.MouseButton1Click:Connect(function()
    refreshRooms(true)
    roomsListModal.Open()
end)


leftPanel.Buttons.TablaClanes.MouseButton1Click:Connect(function()
    window.Gui.Enabled = false

    local clansResult = Api.GetClans()
    local clans = {}

    if clansResult and clansResult.clans then
        clans = clansResult.clans
    end

    local clanUI = ClanTableUI.Create(CoreGui, Theme, clans)

    clanUI.CloseButton.MouseButton1Click:Connect(function()
        clanUI.Destroy()
        window.Gui.Enabled = true
    end)
end)


leftPanel.Buttons.Perfil.MouseButton1Click:Connect(function()
    window.Gui.Enabled = false

    local profileResult = Api.GetMyProfile(player)
    local profile = heartbeatResult.profile

    if profileResult and profileResult.status == "ok" and profileResult.profile then
        profile = profileResult.profile
    end

    local profileUI = ProfileUI.Create(CoreGui, Theme, profile, player)
    local inventoryUI = InventoryUI.Create(profileUI.Gui, Theme)
    local publicProfileUI = nil
    local saveLocked = false
    local inventoryLocked = false

    local function closeProfile()
        if publicProfileUI then
            publicProfileUI.Destroy()
            publicProfileUI = nil
        end

        inventoryUI.Destroy()
        profileUI.Destroy()
        window.Gui.Enabled = true
    end

    profileUI.CloseButton.MouseButton1Click:Connect(closeProfile)

    local function getInventoryErrorMessage(reason)
        local messages = {
            profile_not_found = "No se encontro tu perfil.",
            item_not_owned = "Este item no esta en tu inventario.",
            item_not_found = "Este item ya no esta disponible.",
            item_not_usable = "Este item aun no se puede usar desde inventario."
        }

        return messages[reason] or "No se pudo usar el item."
    end

    local function getClanCreateErrorMessage(reason)
        local messages = {
            profile_not_found = "No se encontro tu perfil.",
            user_already_in_clan = "Ya perteneces a un clan.",
            clan_ticket_required = "Necesitas un ticket de clan en tu inventario.",
            clan_name_too_short = "El nombre del clan debe tener minimo 3 caracteres.",
            clan_name_too_long = "El nombre del clan es demasiado largo.",
            clan_name_invalid_characters = "El nombre solo puede usar letras, numeros y espacios.",
            clan_tag_too_short = "El tag debe tener minimo 2 caracteres.",
            clan_tag_too_long = "El tag es demasiado largo.",
            clan_tag_invalid_characters = "El tag solo puede usar letras y numeros.",
            clan_color_not_allowed = "Ese color de clan no esta permitido.",
            clan_tag_style_not_allowed = "Ese estilo de tag no esta permitido.",
            clan_name_already_taken = "Ese nombre de clan ya esta en uso.",
            clan_tag_already_taken = "Ese tag de clan ya esta en uso."
        }

        return messages[reason] or "No se pudo crear el clan."
    end

    local function refreshInventory()
        local inventoryResult = Api.GetMyInventory(player)

        if inventoryResult and inventoryResult.status == "ok" then
            inventoryUI.Render(inventoryResult.items or {}, function(itemId)
                if inventoryLocked then
                    return
                end

                inventoryLocked = true
                inventoryUI.ShowStatus("Aplicando item...", false)

                local useResult = Api.UseInventoryItem(player, itemId)

                if useResult and useResult.status == "ok" then
                    if useResult.action == "create_clan" then
                        inventoryUI.ShowClanForm()
                        inventoryLocked = false
                        return
                    end

                    if useResult.profile then
                        profileUI.ApplyProfile(useResult.profile)
                    end

                    inventoryUI.ShowList()
                    refreshInventory()
                    inventoryUI.ShowStatus("Item aplicado correctamente.", false)
                else
                    inventoryUI.ShowStatus(
                        getInventoryErrorMessage(useResult and useResult.reason),
                        true
                    )
                end

                inventoryLocked = false
            end)
            inventoryUI.ShowStatus("", false)
        else
            inventoryUI.RenderEmpty("No se pudo cargar tu inventario.")
            inventoryUI.ShowStatus("No se pudo cargar tu inventario.", true)
        end
    end

    profileUI.InventoryButton.MouseButton1Click:Connect(function()
        inventoryUI.Open()
        inventoryUI.ShowList()
        inventoryUI.ShowStatus("Cargando inventario...", false)
        refreshInventory()
    end)

    inventoryUI.CreateClanButton.MouseButton1Click:Connect(function()
        if inventoryLocked then
            return
        end

        local clanData = inventoryUI.GetClanFormData()

        if not clanData.name or clanData.name:gsub("%s+", "") == "" then
            inventoryUI.ShowStatus("Ingresa el nombre del clan.", true)
            return
        end

        if not clanData.tag or clanData.tag:gsub("%s+", "") == "" then
            inventoryUI.ShowStatus("Ingresa el tag del clan.", true)
            return
        end

        inventoryLocked = true
        inventoryUI.ShowStatus("Creando clan...", false)

        local clanResult = Api.CreateClan(
            player,
            clanData.name,
            clanData.tag,
            clanData.color,
            clanData.tag_style
        )

        if clanResult and clanResult.status == "created" then
            if clanResult.profile then
                profileUI.ApplyProfile(clanResult.profile)
            end

            inventoryUI.ShowList()
            refreshInventory()
            inventoryUI.ShowStatus("Clan creado correctamente.", false)
            refreshOnlineUsers()
        else
            inventoryUI.ShowStatus(
                getClanCreateErrorMessage(clanResult and clanResult.reason),
                true
            )
        end

        inventoryLocked = false
    end)

    profileUI.PublicProfileButton.MouseButton1Click:Connect(function()
        local publicResult = Api.GetPublicProfile(player.UserId)

        if publicResult and publicResult.status == "ok" and publicResult.profile then
            if publicProfileUI then
                publicProfileUI.Destroy()
            end

            publicProfileUI = PublicProfileUI.Create(
                profileUI.Gui,
                Theme,
                publicResult.profile,
                player
            )

            publicProfileUI.CloseButton.MouseButton1Click:Connect(function()
                publicProfileUI = nil
            end)

            profileUI.ShowStatus("Perfil publico cargado correctamente.", false)
        else
            profileUI.ShowStatus("No se pudo cargar el perfil publico.", true)
        end
    end)

    profileUI.SaveButton.MouseButton1Click:Connect(function()
        if saveLocked then
            return
        end

        saveLocked = true
        profileUI.ShowStatus("Guardando cambios...", false)

        local changes = profileUI.GetChangedData()

        if not next(changes) then
            profileUI.ShowStatus("No hay cambios para guardar.", false)
            saveLocked = false
            return
        end

        local result = Api.SaveMyProfile(
            player,
            changes
        )

        if result and result.status == "ok" and result.profile then
            profileUI.ApplyProfile(result.profile)
            profileUI.ShowStatus("Cambios guardados.", false)

            if leftPanel.DisplayName then
                leftPanel.DisplayName.Text = tostring(result.profile.display_name or player.DisplayName)
            end

            if leftPanel.PointsValue then
                leftPanel.PointsValue.Text = tostring(result.profile.personal_points or 0)
            end
        else
            profileUI.ShowStatus(result and result.reason or "No se pudo guardar el perfil.", true)
        end

        saveLocked = false
    end)
end)


leftPanel.Buttons.Tienda.MouseButton1Click:Connect(function()
    window.Gui.Enabled = false

    local shopUI = ShopUI.Create(CoreGui, Theme)
    local rewardModal = RewardModal.Create(shopUI.Gui, Theme)
    local rewardPurchaseLocked = false
    local shopPurchaseLocked = false

    local function applyLimitedStock(key, remaining)
        local label = shopUI.LimitedStockLabels[key]
        local button = shopUI.LimitedButtons[key]

        if not label or not button then
            return
        end

        label.Text = "Restante " .. tostring(remaining)

        if remaining <= 0 then
            button.Text = "AGOTADO"
            button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            button.AutoButtonColor = false
        end
    end

    local function refreshLimitedStock()
        local latestStockResult = Api.GetLimitedRewardStock()

        if latestStockResult
            and latestStockResult.status == "ok"
            and latestStockResult.stock
        then
            applyLimitedStock("Robux1000", latestStockResult.stock.robux_1000 or 0)
            applyLimitedStock("Robux100", latestStockResult.stock.robux_100 or 0)
        end
    end

    local function getRewardClaimErrorMessage(reason)
        local messages = {
            reward_code_not_found = "Codigo de premio no encontrado.",
            reward_code_not_owned_by_user = "Este codigo pertenece a otro usuario.",
            reward_already_claimed_or_delivered = "Este codigo ya fue canjeado o entregado.",
            reward_code_expired = "Este codigo expiro. Genera uno nuevo desde la tienda.",
            reward_not_claimed = "Este premio aun no fue canjeado."
        }

        return messages[reason] or "No se pudo canjear el codigo."
    end

    local function getShopBuyErrorMessage(reason)
        local messages = {
            profile_not_found = "No se encontro tu perfil.",
            item_not_found = "Este item no existe.",
            item_not_purchasable = "Este item no se puede comprar.",
            item_already_owned = "Ya tienes este item en tu inventario.",
            insufficient_points = "No tienes puntos suficientes."
        }

        return messages[reason] or "No se pudo comprar el item."
    end

    local stock = {
        robux_1000 = 2,
        robux_100 = 10
    }

    local stockResult = Api.GetLimitedRewardStock()

    if stockResult and stockResult.status == "ok" and stockResult.stock then
        stock.robux_1000 = stockResult.stock.robux_1000 or stock.robux_1000
        stock.robux_100 = stockResult.stock.robux_100 or stock.robux_100
    end

    applyLimitedStock("Robux1000", stock.robux_1000)
    applyLimitedStock("Robux100", stock.robux_100)

    local function buyReward(itemId, stockKey)
        if rewardPurchaseLocked then
            return
        end

        rewardPurchaseLocked = true

        local result = Api.BuyShopItem(player, itemId)

        if result
            and result.status == "ok"
            and result.reward_redeem
        then
            rewardModal.Open(
                result.reward_redeem.code,
                player.UserId,
                player.Name
            )
        else
            showStatus(result and result.reason or "No se pudo comprar el premio.")
        end

        rewardPurchaseLocked = false
    end

    local function buyInventoryItem(itemId, button)
        if shopPurchaseLocked then
            return
        end

        shopPurchaseLocked = true

        local originalText = button and button.Text

        if button then
            button.Text = "Comprando..."
        end

        local result = Api.BuyShopItem(player, itemId)

        if result and result.status == "ok" and result.inventory_item then
            if button then
                button.Text = "COMPRADO"
                button.AutoButtonColor = false
                button.Active = false
            end

            if result.profile then
                if leftPanel.PointsValue then
                    leftPanel.PointsValue.Text = tostring(result.profile.personal_points or 0)
                end
            end
        else
            if button and result and result.reason == "item_already_owned" then
                button.Text = "YA LO TIENES"
                button.AutoButtonColor = false
                button.Active = false
            elseif button then
                button.Text = originalText or "Comprar"
            end

            showStatus(getShopBuyErrorMessage(result and result.reason))
        end

        shopPurchaseLocked = false
    end

    shopUI.LimitedButtons.Robux1000.MouseButton1Click:Connect(function()
        buyReward("robux_1000", "Robux1000")
    end)

    shopUI.LimitedButtons.Robux100.MouseButton1Click:Connect(function()
        buyReward("robux_100", "Robux100")
    end)

    shopUI.ItemButtons.ClanTicket.MouseButton1Click:Connect(function()
        buyInventoryItem("clan_ticket", shopUI.ItemButtons.ClanTicket)
    end)

    shopUI.ItemButtons.NameColor.MouseButton1Click:Connect(function()
        buyInventoryItem("username_color_purple", shopUI.ItemButtons.NameColor)
    end)

    shopUI.ItemButtons.CustomChat.MouseButton1Click:Connect(function()
        buyInventoryItem("chat_style_cloud", shopUI.ItemButtons.CustomChat)
    end)

    shopUI.ItemButtons.GatoDark.MouseButton1Click:Connect(function()
        buyInventoryItem("chat_style_gatodark", shopUI.ItemButtons.GatoDark)
    end)

    shopUI.ItemButtons.ChatColor.MouseButton1Click:Connect(function()
        buyInventoryItem("chat_color_pink", shopUI.ItemButtons.ChatColor)
    end)

    shopUI.ItemButtons.BackgroundDesign.MouseButton1Click:Connect(function()
        buyInventoryItem("profile_banner_space", shopUI.ItemButtons.BackgroundDesign)
    end)

    rewardModal.RedeemButton.MouseButton1Click:Connect(function()
        local code = rewardModal.GetCode()

        if not code or code:gsub("%s+", "") == "" then
            rewardModal.ShowError("Introduce un codigo para canjear.")
            return
        end

        rewardModal.ClearError()
        local result = Api.ClaimReward(player, code)

        if result and result.status == "ok" then
            refreshLimitedStock()
            rewardModal.ShowSuccess()
        else
            rewardModal.ShowError(getRewardClaimErrorMessage(result and result.reason))
        end
    end)

    rewardModal.CloseButton.MouseButton1Click:Connect(function()
        rewardModal.Close()
    end)

    rewardModal.CancelButton.MouseButton1Click:Connect(function()
        rewardModal.Close()
    end)

    

    shopUI.CloseButton.MouseButton1Click:Connect(function()
        rewardModal.Overlay:Destroy()
        shopUI.Destroy()
        window.Gui.Enabled = true
    end)
end)


createRoomModal.CancelButton.MouseButton1Click:Connect(function()
    createRoomModal.Close()
end)

roomsListModal.CloseButton.MouseButton1Click:Connect(function()
    roomsListModal.Close()
end)

passwordModal.CancelButton.MouseButton1Click:Connect(function()
    passwordModal.Close()
end)

confirmModal.CloseButton.MouseButton1Click:Connect(function()
    confirmModal.Close()
end)

confirmModal.PrimaryButton.MouseButton1Click:Connect(function()

    if confirmAction then
        confirmAction()
    end

    confirmModal.Close()

end)

confirmModal.SecondaryButton.MouseButton1Click:Connect(function()

    confirmModal.Close()

end)



passwordModal.EnterButton.MouseButton1Click:Connect(function()

    if not selectedPrivateRoom then
        return
    end

    local password = passwordModal.Input.Text or ""

    local result = Api.JoinRoom(
        player,
        selectedPrivateRoom.room_id,
        password
    )

    if result and result.status == "joined" then

        local joinedRoom = result.room or selectedPrivateRoom

        setRoom(
            joinedRoom.room_id,
            joinedRoom.display_name,
            "PRIVADA"
        )

        passwordModal.Close()
        roomsListModal.Close()

        refreshChat()
        refreshOnlineUsers()

    else

        passwordModal.ErrorLabel.Text = "Contraseña incorrecta"
        
    end
end)



createRoomModal.CreateButton.MouseButton1Click:Connect(function()
    local roomName = createRoomModal.RoomInput.Text
    local password = nil

    if createRoomModal.IsPrivate() then
        password = createRoomModal.PasswordInput.Text
    end

    local isPrivate = createRoomModal.IsPrivate()

    if not roomName or roomName:gsub("%s+", "") == "" then
        showStatus("Ingresa un nombre para la sala.")
        return
    end

    if isPrivate and (#password < 3) then
        showStatus("La contraseña debe tener mínimo 3 caracteres.")
        return
    end

    local result = Api.CreateRoom(
        player,
        roomName,
        isPrivate,
        password
    )

    if not result then
        showStatus("No se pudo crear la sala.")
        return
    end

    if result.status == "created" then
        local room = result.room

        setRoom(
            room.room_id,
            room.display_name,
            room.is_private and "PRIVADA" or "PUBLICA"
        )

        createRoomModal.Close()
        refreshChat()
    else
        if result.reason == "user_already_in_room" then
            Api.LeaveAnyRoom(player)
            showStatus("Se limpió una sala anterior. Intenta crear la sala otra vez.")
        else
            showStatus(result.reason or "No se pudo crear la sala.")
        end
    end
end)

chatPanel.LeaveButton.MouseButton1Click:Connect(function()
    if currentRoom.id == "global" then
        return
    end

    local result = Api.LeaveRoom(player, currentRoom.id)

    if result and (
        result.status == "left" or
        result.status == "deleted"
    ) then

        setRoom(
            "global",
            "Chat General",
            "GLOBAL"
        )

        refreshChat()
        refreshOnlineUsers()
    end
end)

window.CloseButton.MouseButton1Click:Connect(function()
    running = false

    if currentRoom.id ~= "global" then
        Api.LeaveRoom(player, currentRoom.id)
    end

    window.Gui:Destroy()
end)

task.spawn(function()
    while running do
        Api.Heartbeat(player, currentGameActivity)
        task.wait(HEARTBEAT_INTERVAL)
    end
end)

task.spawn(function()
    while running do
        refreshChat()
        task.wait(CHAT_REFRESH_INTERVAL)
    end
end)

task.spawn(function()
    while running do
        refreshOnlineUsers()
        task.wait(ONLINE_REFRESH_INTERVAL)
    end
end)

refreshChat()
refreshOnlineUsers()
