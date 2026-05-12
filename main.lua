local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

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

if not Api.HasRequest() then
    warn("Executor sin soporte request/http_request")
    return
end

local heartbeatResult = Api.Heartbeat(player)

if not heartbeatResult or heartbeatResult.status ~= "ok" then
    warn("No se pudo conectar con StrikeChat API")
    return
end

local window = MainWindow.Create(CoreGui, Theme)
local chatPanel = ChatPanel.Create(window.ChatPanel, Theme)
local leftPanel = LeftPanel.Create(window.LeftPanel, Theme, heartbeatResult.profile, player)
local rightPanel = RightPanel.Create(window.RightPanel, Theme)

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

chatPanel.Title.Text = currentRoom.name
chatPanel.RoomType.Text = currentRoom.type

local lastChatSignature = ""

local avatarCache = {}
local setRoom



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
            avatar.Parent = container

            local avatarCorner = Instance.new("UICorner")
            avatarCorner.CornerRadius = UDim.new(1, 0)
            avatarCorner.Parent = avatar

            local name = msg.display_name or msg.username or "Usuario"

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "Name"
            nameLabel.Size = UDim2.new(0.65, 0, 0, 18)
            nameLabel.Position = UDim2.new(0, 44, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = tostring(name)
            nameLabel.TextColor3 = Theme.Colors.Text
            nameLabel.Font = Theme.Font.Bold
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = container

            local clanText = ""

            if msg.clan_tag then
                if msg.clan_tag_style == "plain" then
                    clanText = tostring(msg.clan_tag)
                else
                    clanText = "[" .. tostring(msg.clan_tag) .. "]"
                end
            end

            local clanLabel = Instance.new("TextLabel")
            clanLabel.Name = "ClanTag"
            clanLabel.Size = UDim2.new(0.3, 0, 0, 18)
            clanLabel.Position = UDim2.new(0.65, 44, 0, 0)
            clanLabel.BackgroundTransparency = 1
            clanLabel.Text = clanText
            clanLabel.TextColor3 = Theme.Colors.TextMuted
            clanLabel.Font = Theme.Font.Bold
            clanLabel.TextSize = 11
            clanLabel.TextXAlignment = Enum.TextXAlignment.Left
            clanLabel.TextTruncate = Enum.TextTruncate.AtEnd
            clanLabel.Parent = container

            local messageText = Instance.new("TextLabel")
            messageText.Name = "Message"
            messageText.Size = UDim2.new(1, -50, 0, 34)
            messageText.Position = UDim2.new(0, 44, 0, 20)
            messageText.BackgroundTransparency = 1
            messageText.Text = tostring(msg.message)
            messageText.TextColor3 = Theme.Colors.Text
            messageText.Font = Theme.Font.Regular
            messageText.TextSize = 13
            messageText.TextXAlignment = Enum.TextXAlignment.Left
            messageText.TextYAlignment = Enum.TextYAlignment.Top
            messageText.TextWrapped = true
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

            if isPrivate then
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


createRoomModal.CancelButton.MouseButton1Click:Connect(function()
    createRoomModal.Close()
end)

roomsListModal.CloseButton.MouseButton1Click:Connect(function()
    roomsListModal.Close()
end)

passwordModal.CancelButton.MouseButton1Click:Connect(function()
    passwordModal.Close()
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
        Api.Heartbeat(player)
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