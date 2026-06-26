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
local I18n = loadstring(game:HttpGet(BASE_RAW .. "modules/i18n.lua"))()
_G.StrikeChatI18n = I18n
local MainWindow = loadstring(game:HttpGet(BASE_RAW .. "modules/main_window.lua"))()
local ChatPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/chat_panel.lua"))()
local LeftPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/left_panel.lua"))()
local RightPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/right_panel.lua"))()
local CreateRoomModal = loadstring(game:HttpGet(BASE_RAW .. "modules/create_room_modal.lua"))()
local RoomsListModal = loadstring(game:HttpGet(BASE_RAW .. "modules/rooms_list_modal.lua"))()
local PasswordModal = loadstring(game:HttpGet(BASE_RAW .. "modules/password_modal.lua"))()
local ConfirmModal = loadstring(game:HttpGet(BASE_RAW .. "modules/confirm_modal.lua"))()
local ClanTableUI = loadstring(game:HttpGet(BASE_RAW .. "modules/clan_table_ui.lua"))()
local ClanRequestModal = loadstring(game:HttpGet(BASE_RAW .. "modules/clan_request_modal.lua"))()
local ShopUI = loadstring(game:HttpGet(BASE_RAW .. "modules/shop_ui.lua"))()
local RewardModal = loadstring(game:HttpGet(BASE_RAW .. "modules/reward_modal.lua"))()
local ProfileUI = loadstring(game:HttpGet(BASE_RAW .. "modules/profile_ui.lua"))()
local PublicProfileUI = loadstring(game:HttpGet(BASE_RAW .. "modules/public_profile_ui.lua"))()
local InventoryUI = loadstring(game:HttpGet(BASE_RAW .. "modules/inventory_ui.lua"))()
local ChatStyles = loadstring(game:HttpGet(BASE_RAW .. "modules/chat_styles.lua"))()
local AvatarRenderer = loadstring(game:HttpGet(BASE_RAW .. "modules/avatar_renderer.lua"))()
local AdminPanelUI = loadstring(game:HttpGet(BASE_RAW .. "modules/admin_panel_ui.lua"))()
local StrikeMusicStorage = loadstring(game:HttpGet(BASE_RAW .. "modules/strikemusic_storage.lua"))()
local StrikeMusicClient = loadstring(game:HttpGet(BASE_RAW .. "modules/strikemusic_client.lua"))()
local StrikeMusicUI = loadstring(game:HttpGet(BASE_RAW .. "modules/strikemusic_ui.lua"))()

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

local adminUserIds = {
    [7929273069] = true
}

local function isCurrentUserAdmin()
    return adminUserIds[player.UserId] == true
end

local function tr(text)
    return I18n.TranslateText(text)
end

if not Api.HasRequest() then
    warn("Executor sin soporte request/http_request")
    return
end

local heartbeatResult = Api.Heartbeat(player, currentGameActivity)

if not heartbeatResult or heartbeatResult.status ~= "ok" then
    warn("No se pudo conectar con StrikeChat API")
    return
end

local selectedLayoutMode = MainWindow.ChooseLayout(CoreGui, Theme, I18n)
local window = MainWindow.Create(CoreGui, Theme, selectedLayoutMode)
local chatPanel = ChatPanel.Create(window.ChatPanel, Theme)
local leftPanel = LeftPanel.Create(window.LeftPanel, Theme, heartbeatResult.profile, player)
local rightPanel = RightPanel.Create(window.RightPanel, Theme, AvatarRenderer)
local strikeMusicClient = StrikeMusicClient.Create(Api, StrikeMusicStorage)
local adminPanel = nil
local adminSecurityPrompt = nil
local adminAccessVerified = false
local selectedRewardGroup = nil

if window.SetBackgroundDesign then
    window.SetBackgroundDesign(heartbeatResult.profile and heartbeatResult.profile.profile_banner_id)
end

if window.RaiseContent then
    window.RaiseContent()
end

local adminNoticeGui = Instance.new("ScreenGui")
adminNoticeGui.Name = "StrikeChatAdminNoticeGui"
adminNoticeGui.ResetOnSpawn = false
adminNoticeGui.IgnoreGuiInset = true
adminNoticeGui.DisplayOrder = 9999
adminNoticeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
adminNoticeGui.Parent = CoreGui

local adminNotice = Instance.new("TextLabel")
adminNotice.Name = "AdminNotice"
adminNotice.Size = UDim2.new(0, 620, 0, 24)
adminNotice.Position = selectedLayoutMode == "mobile"
    and UDim2.new(0.5, 0, 0, 62)
    or UDim2.new(0.5, 0, 0, 92)
adminNotice.AnchorPoint = Vector2.new(0.5, 0)
adminNotice.BackgroundTransparency = 1
adminNotice.Text = ""
adminNotice.Visible = false
adminNotice.TextColor3 = Color3.fromRGB(255, 175, 8)
adminNotice.Font = Theme.Font.Bold
adminNotice.TextSize = 14
adminNotice.TextTransparency = 0
adminNotice.TextXAlignment = Enum.TextXAlignment.Center
adminNotice.TextTruncate = Enum.TextTruncate.AtEnd
adminNotice.ZIndex = 10000
adminNotice.Parent = adminNoticeGui

local DEFAULT_ADMIN_NOTICE_MESSAGE = "El sistema de puntos y Premios estara disponible pronto"
local DEFAULT_ADMIN_NOTICE_DURATION = 10
local defaultAdminNoticeExpiresAt = 0

local function showDefaultAdminNotice()
    defaultAdminNoticeExpiresAt = os.clock() + DEFAULT_ADMIN_NOTICE_DURATION
    adminNotice.Text = "ADMIN : " .. tr(DEFAULT_ADMIN_NOTICE_MESSAGE)
    adminNotice.Visible = true
end

_G.StrikeChatShowDefaultAdminNotice = showDefaultAdminNotice
showDefaultAdminNotice()

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

I18n.RegisterRoot(window.Gui)




chatPanel.Title.Text = currentRoom.name
chatPanel.RoomType.Text = currentRoom.type

local lastChatSignature = ""

local activityProfileCache = {}
local setRoom
local selectedPrivateRoom = nil
local confirmAction = nil
local confirmSecondaryAction = nil
local activePublicProfileUI = nil
local clanRequestModal = nil
local activeClanTableUI = nil
local activeStrikeMusicUI = nil
local pendingClanJoinRequest = nil
local shownClanJoinRequests = {}
local clanRequestModalBusy = false

local function ensureClanRequestModal()
    if clanRequestModal then
        return clanRequestModal
    end

    clanRequestModal = ClanRequestModal.Create(CoreGui, Theme)
    I18n.RegisterRoot(clanRequestModal.Gui or clanRequestModal.Overlay)

    return clanRequestModal
end

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

local usernameColorMap = {
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

local function getUsernameColor(colorName, fallbackColor)
    local key = tostring(colorName or ""):lower()

    return usernameColorMap[key] or fallbackColor
end

local function buildPendingRewardGroups(redeems)
    local groupsByKey = {}
    local groups = {}

    for _, redeem in ipairs(redeems or {}) do
        local key = tostring(redeem.roblox_user_id) .. ":" .. tostring(redeem.reward_type)
        local group = groupsByKey[key]

        if not group then
            group = {
                roblox_user_id = redeem.roblox_user_id,
                roblox_username = redeem.roblox_username,
                reward_type = redeem.reward_type,
                count = 0,
                codes = {}
            }

            groupsByKey[key] = group
            table.insert(groups, group)
        end

        group.count += 1
        table.insert(group.codes, redeem.code)
    end

    table.sort(groups, function(a, b)
        return tostring(a.roblox_username):lower() < tostring(b.roblox_username):lower()
    end)

    return groups
end

local function refreshAdminPendingRewards()
    if not adminPanel then
        return
    end

    adminPanel.ShowStatus("Cargando premios pendientes...", false)

    local result = Api.GetPendingRewardRedeems(player)

    if result and result.status == "ok" and result.redeems then
        local groups = buildPendingRewardGroups(result.redeems)

        adminPanel.RenderPending(groups, function(group)
            selectedRewardGroup = group
            adminPanel.OpenRewardDetail(group)
        end)

        adminPanel.ShowStatus("Premios pendientes actualizados.", false)
    else
        adminPanel.RenderPending({}, nil)
        adminPanel.ShowStatus("No se pudieron cargar los premios pendientes.", true)
    end
end


task.spawn(function()
    while true do
        if os.clock() < defaultAdminNoticeExpiresAt then
            adminNotice.Text = "ADMIN : " .. tr(DEFAULT_ADMIN_NOTICE_MESSAGE)
            adminNotice.Visible = true
        else
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
        end

        task.wait(15)
    end
end)

local function ensureAdminPanel()
    if adminPanel then
        return
    end

    adminPanel = AdminPanelUI.Create(window.Gui, Theme)

    adminPanel.CloseButton.MouseButton1Click:Connect(function()
        adminPanel.Close()
    end)

    adminPanel.SendNoticeButton.MouseButton1Click:Connect(function()
        local message = adminPanel.NoticeInput.Text or ""

        if message:gsub("%s+", "") == "" then
            adminPanel.ShowStatus("Escribe un aviso antes de enviarlo.", true)
            return
        end

        adminPanel.ShowStatus("Enviando aviso...", false)

        local result = Api.CreateAdminNotice(player, message)

        if result and result.status == "created" then
            adminPanel.NoticeInput.Text = ""
            adminPanel.ShowStatus("Aviso enviado correctamente.", false)
        else
            adminPanel.ShowStatus("No se pudo enviar el aviso.", true)
        end
    end)

    adminPanel.RefreshButton.MouseButton1Click:Connect(refreshAdminPendingRewards)

    adminPanel.BackButton.MouseButton1Click:Connect(function()
        selectedRewardGroup = nil
        adminPanel.CloseRewardDetail()
    end)

    adminPanel.DeliveredButton.MouseButton1Click:Connect(function()
        if not selectedRewardGroup then
            return
        end

        adminPanel.ShowStatus("Marcando premio como entregado...", false)

        local deliveredCount = 0

        for _, code in ipairs(selectedRewardGroup.codes or {}) do
            local result = Api.MarkRewardDelivered(player, code)

            if result and result.status == "delivered" then
                deliveredCount += 1
            end
        end

        selectedRewardGroup = nil
        adminPanel.CloseRewardDetail()
        refreshAdminPendingRewards()
        adminPanel.ShowStatus("Entregados: " .. tostring(deliveredCount), false)
    end)

    I18n.Apply(window.Gui)
end

local function openAdminPanel()
    ensureAdminPanel()
    adminPanel.Open()
    refreshAdminPendingRewards()
end

local function ensureAdminSecurityPrompt()
    if adminSecurityPrompt then
        return
    end

    adminSecurityPrompt = AdminPanelUI.CreateSecurityPrompt(window.Gui, Theme)

    adminSecurityPrompt.CloseButton.MouseButton1Click:Connect(function()
        adminSecurityPrompt.Close()
    end)

    adminSecurityPrompt.AcceptButton.MouseButton1Click:Connect(function()
        local code = adminSecurityPrompt.CodeInput.Text or ""

        if code:gsub("%s+", "") == "" then
            adminSecurityPrompt.ShowStatus("Introduce el codigo.", true)
            return
        end

        Api.SetAdminCode(code)
        adminSecurityPrompt.ShowStatus("Verificando codigo...", false)

        local result = Api.VerifyAdminAccess(player)

        if result and result.status == "ok" then
            adminAccessVerified = true
            adminSecurityPrompt.CodeInput.Text = ""
            adminSecurityPrompt.Close()
            openAdminPanel()
        else
            Api.SetAdminCode("")
            adminSecurityPrompt.ShowStatus("Codigo incorrecto.", true)
        end
    end)

    I18n.Apply(window.Gui)
end

if isCurrentUserAdmin() and leftPanel.AdminButton then
    leftPanel.AdminButton.Visible = true

    leftPanel.AdminButton.MouseButton1Click:Connect(function()
        if adminAccessVerified then
            openAdminPanel()
            return
        end

        ensureAdminSecurityPrompt()
        adminSecurityPrompt.Open()
    end)
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

            local messageStyle = ChatStyles.Get(msg, Theme)
            local premiumContentZIndex = ChatStyles.GetContentZIndex(messageStyle)

            local avatar = Instance.new("ImageLabel")
            avatar.Name = "Avatar"
            avatar.Size = UDim2.new(0, 34, 0, 34)
            avatar.Position = UDim2.new(0, 0, 0, 4)
            avatar.BackgroundTransparency = 1
            avatar.ImageTransparency = 0
            avatar.ZIndex = premiumContentZIndex
            avatar.Parent = container

            AvatarRenderer.SetAvatar(avatar, msg.roblox_user_id, msg.profile_avatar_id)

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
            nameLabel.TextColor3 = getUsernameColor(
                msg.username_color,
                ChatStyles.GetTextColor(messageStyle, Theme.Colors.Text)
            )
            nameLabel.Font = Theme.Font.Bold
            nameLabel.TextSize = 12
            nameLabel.TextTransparency = 0
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.ZIndex = premiumContentZIndex
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
            clanLabel.TextTransparency = 0
            clanLabel.TextXAlignment = Enum.TextXAlignment.Left
            clanLabel.TextTruncate = Enum.TextTruncate.AtEnd
            clanLabel.ZIndex = premiumContentZIndex
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

            local messageRightPadding = 50
            local messageLeftOffset = 44

            local messageMeasureWidth = math.max(
                chatPanel.MessagesBox.AbsoluteSize.X - messageLeftOffset - messageRightPadding - 8,
                80
            )
            local measuredMessage = TextService:GetTextSize(
                tostring(msg.message),
                13,
                Theme.Font.Regular,
                Vector2.new(messageMeasureWidth, math.huge)
            )
            local styleSizing = ChatStyles.GetSizing(messageStyle)
            local minMessageHeight = styleSizing.minMessageHeight
            local minContainerHeight = styleSizing.minContainerHeight
            local bottomPadding = styleSizing.bottomPadding
            local messageHeight = math.max(minMessageHeight, math.ceil(measuredMessage.Y) + 2)
            local containerHeight = math.max(minContainerHeight, 20 + messageHeight + bottomPadding)

            container.Size = UDim2.new(1, -8, 0, containerHeight)
            container.ZIndex = ChatStyles.GetContainerZIndex(messageStyle)

            ChatStyles.ApplyBackground(container, Theme, messageStyle, containerHeight)

            avatar.ZIndex = premiumContentZIndex
            nameLabel.ZIndex = premiumContentZIndex
            clanLabel.ZIndex = premiumContentZIndex

            local messageText = Instance.new("TextLabel")
            messageText.Name = "Message"
            messageText.Size = UDim2.new(1, -50, 0, messageHeight)
            messageText.Position = UDim2.new(0, 44, 0, 20)
            messageText.BackgroundTransparency = 1
            messageText.Text = tostring(msg.message)
            messageText.TextColor3 = ChatStyles.GetTextColor(messageStyle, Theme.Colors.Text)
            messageText.Font = Theme.Font.Regular
            messageText.TextSize = 13
            messageText.TextXAlignment = Enum.TextXAlignment.Left
            messageText.TextYAlignment = Enum.TextYAlignment.Top
            messageText.TextWrapped = true
            messageText.ZIndex = ChatStyles.GetTextZIndex(messageStyle)
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

local function enrichOnlineUserActivities(users)
    local now = os.clock()

    for _, onlineUser in ipairs(users or {}) do
        local userId = onlineUser.roblox_user_id

        if userId then
            local cached = activityProfileCache[userId]

            if not cached or (now - cached.updated_at) > 30 then
                local publicResult = Api.GetPublicProfile(userId)
                local profile = publicResult and publicResult.profile
                local activityText = profile and profile.activity_text

                cached = {
                    updated_at = now,
                    activity_text = activityText,
                    active_username_color = profile and profile.active_username_color
                }

                activityProfileCache[userId] = cached
            end

            if cached.active_username_color then
                onlineUser.active_username_color = cached.active_username_color
            end

            if cached.activity_text and tostring(cached.activity_text):gsub("%s+", "") ~= "" then
                onlineUser.activity_text = cached.activity_text
                onlineUser.game_status_visibility = "public"
            else
                onlineUser.activity_text = nil
                onlineUser.game_status_visibility = "private"
            end
        end
    end

    return users
end

local function openPublicProfileForUser(user)
    if not user or not user.roblox_user_id then
        return
    end

    local publicResult = Api.GetPublicProfile(user.roblox_user_id)

    if not publicResult or publicResult.status ~= "ok" or not publicResult.profile then
        return
    end

    if activePublicProfileUI then
        activePublicProfileUI.Destroy()
        activePublicProfileUI = nil
    end

    activePublicProfileUI = PublicProfileUI.Create(
        window.Gui,
        Theme,
        publicResult.profile,
        player,
        AvatarRenderer
    )
    I18n.Apply(window.Gui)

    activePublicProfileUI.CloseButton.MouseButton1Click:Connect(function()
        activePublicProfileUI = nil
    end)
end

local function refreshOnlineUsers()
    if currentRoom.id == "global" then
        local result = Api.GetOnlineUsers()

        if result and result.users then
            enrichOnlineUserActivities(result.users)

            rightPanel.Title.Text =
                tr("En Línea - " .. tostring(#result.users))

            rightPanel.Render(result.users, openPublicProfileForUser)
            I18n.Apply(window.Gui)
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

    enrichOnlineUserActivities(roomUsers)

    rightPanel.Title.Text =
        tr("En Sala - " .. tostring(#roomUsers))

    rightPanel.Render(roomUsers, openPublicProfileForUser)
    I18n.Apply(window.Gui)
end

local function refreshRooms(isPrivate)
    roomsListModal.Clear()

    local testLabel = Instance.new("TextLabel")
    testLabel.Size = UDim2.new(1, 0, 0, 40)
    testLabel.BackgroundTransparency = 1
    testLabel.Text = tr("Cargando salas...")
    testLabel.TextColor3 = Theme.Colors.Text
    testLabel.Font = Theme.Font.Bold
    testLabel.TextSize = 13
    testLabel.Parent = roomsListModal.List

    local result

    if isPrivate then
        result = Api.GetPrivateRooms()
        roomsListModal.Title.Text = tr("Salas Privadas")
    else
        result = Api.GetPublicRooms()
        roomsListModal.Title.Text = tr("Salas Públicas")
    end

    testLabel:Destroy()

    if not result or not result.rooms then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text = tr("No se pudieron cargar salas.")
        empty.TextColor3 = Theme.Colors.TextMuted
        empty.Font = Theme.Font.Regular
        empty.TextSize = 12
        empty.Parent = roomsListModal.List
        return
    end

    for index, room in ipairs(result.rooms) do
        local isMobileRoomsLayout = selectedLayoutMode == "mobile"
        local roomRowHeight = isMobileRoomsLayout and 28 or 34

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, roomRowHeight)
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

        if isMobileRoomsLayout then
            roomNumber.Size = UDim2.new(0, 30, 1, 0)
            roomNumber.Position = UDim2.new(0, 10, 0, 0)
            roomNumber.TextSize = 11

            roomName.Size = UDim2.new(1, -102, 1, 0)
            roomName.Position = UDim2.new(0, 46, 0, 0)
            roomName.TextSize = 12

            memberCount.Size = UDim2.new(0, 58, 1, 0)
            memberCount.Position = UDim2.new(1, -66, 0, 0)
            memberCount.TextSize = 10
        end

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

    I18n.Apply(window.Gui)
end


local function showStatus(message)
    chatPanel.StatusLabel.Text = tr(message or "")

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

local function findOwnedClan(profile, clans)
    local profileClanId = profile and profile.clan_id

    if not profileClanId then
        return nil
    end

    for _, clan in ipairs(clans or {}) do
        if tostring(clan.clan_id) == tostring(profileClanId)
            and tostring(clan.owner_user_id) == tostring(player.UserId)
        then
            return clan
        end
    end

    return nil
end

local function getOwnedClan(profile)
    local clansResult = Api.GetClans()

    if not clansResult or not clansResult.clans then
        return nil
    end

    return findOwnedClan(profile, clansResult.clans)
end

local function applyLatestProfile(applyProfile)
    local latestProfileResult = Api.GetMyProfile(player)

    if latestProfileResult
        and latestProfileResult.status == "ok"
        and latestProfileResult.profile
    then
        heartbeatResult.profile = latestProfileResult.profile

        if applyProfile then
            applyProfile(latestProfileResult.profile)
        end

        if leftPanel.DisplayName then
            leftPanel.DisplayName.Text = tostring(latestProfileResult.profile.display_name or player.DisplayName)
        end

        if leftPanel.PointsValue then
            leftPanel.PointsValue.Text = tostring(latestProfileResult.profile.personal_points or 0)
        end

        return latestProfileResult.profile
    end

    return nil
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

chatPanel.EmojiButton.MouseButton1Click:Connect(function()
    chatPanel.Input:CaptureFocus()
end)

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

if leftPanel.Buttons.StrikeMusic then
    leftPanel.Buttons.StrikeMusic.MouseButton1Click:Connect(function()
        if activeStrikeMusicUI then
            return
        end

        window.Gui.Enabled = false

        activeStrikeMusicUI = StrikeMusicUI.Create(CoreGui, Theme)
        I18n.RegisterRoot(activeStrikeMusicUI.Gui)

        local musicUI = activeStrikeMusicUI
        local popularTracks = {}
        local currentPopularTrack = nil
        local currentPlaybackKind = nil
        local currentLocalDownload = nil
        local localDownloadQueue = {}
        local shuffleEnabled = false
        local repeatEnabled = false

        local function formatMusicTime(seconds)
            local safeSeconds = math.max(math.floor(tonumber(seconds) or 0), 0)
            return string.format(
                "%d:%02d",
                math.floor(safeSeconds / 60),
                safeSeconds % 60
            )
        end

        local function extractRobloxAudioId(query)
            local text = tostring(query or "")
            local directId = text:match("^%s*(%d+)%s*$")
            local linkedId = text:match("[?&]id=(%d+)")
                or text:match("rbxassetid://(%d+)")
                or text:match("/library/(%d+)")
                or text:match("/audio/(%d+)")

            return tonumber(directId or linkedId)
        end

        local function getRobloxAudioTrack(audioId)
            for _, track in ipairs(popularTracks) do
                if tonumber(track.roblox_audio_id) == audioId then
                    return track
                end
            end

            return {
                roblox_audio_id = audioId,
                title = "Audio Roblox " .. tostring(audioId),
                artist = nil
            }
        end
        local function refreshRecentMusic()
            task.spawn(function()
                local historyResult = strikeMusicClient.GetHistory(player, 3)

                if not musicUI or not historyResult or historyResult.status ~= "ok" then
                    return
                end

                local items = {}

                for _, historyItem in ipairs(historyResult.items or {}) do
                    table.insert(items, historyItem.media or historyItem)
                end

                musicUI.RenderRecent(items)
            end)
        end

        local playLocalDownload
        local deleteLocalDownload
        local saveReadyDownload
        local function getLocalDownloadKey(job)
            if not job then
                return nil
            end

            return tostring(
                job.file_key
                    or (job.local_metadata and job.local_metadata.file_key)
                    or job.source_id
                    or ""
            )
        end
        local currentMusicSearchResults = {}
        local favoriteLibraryIds = {}
        local currentFavoriteItems = {}
        local currentPlaylists = {}
        local currentPlaylist = nil
        local refreshMusicFavorites
        local refreshMusicPlaylists
        local openPlaylist
        local openAddToPlaylistPicker
        local renderCurrentMusicSearchResults

        local function refreshMusicDownloads()
            task.spawn(function()
                local metadataResult = StrikeMusicStorage.ListMetadata()
                local metadataItems = metadataResult and metadataResult.items or {}
                local localSupport = strikeMusicClient.GetLocalAudioSupport()
                local localJobs = {}
                local libraryByFileKey = {}
                strikeMusicClient.RebuildLibraryFromLocal(player)
                local libraryResult = strikeMusicClient.GetLibrary(player)

                if libraryResult and libraryResult.status == "ok" and libraryResult.items then
                    for _, item in ipairs(libraryResult.items) do
                        if item.file_key then
                            libraryByFileKey[tostring(item.file_key)] = item
                        end
                    end
                end


                for _, metadata in ipairs(metadataItems) do
                    if StrikeMusicStorage.MediaExists(metadata) then
                        local libraryItem = libraryByFileKey[tostring(metadata.file_key or "")]
                        strikeMusicClient.CacheThumbnail(metadata)

                        if metadata.local_thumbnail_path then
                            StrikeMusicStorage.SaveMetadata(metadata)
                        end

                        table.insert(localJobs, {
                            status = "completed",
                            media_type = metadata.media_type,
                            title = metadata.title,
                            artist = metadata.artist,
                            duration_seconds = metadata.duration_seconds,
                            file_size_bytes = metadata.file_size_bytes,
                            quality = metadata.quality,
                            thumbnail_url = metadata.thumbnail_url,
                            thumbnail_original_url = metadata.thumbnail_original_url,
                            local_thumbnail_path = metadata.local_thumbnail_path,
                            source_id = metadata.source_id,
                            source_url = metadata.source_url,
                            file_key = metadata.file_key,
                            local_metadata = metadata,
                            local_playback_supported = metadata.media_type == "mp3"
                                and localSupport.supported == true,
                            library_item_id = (libraryItem and libraryItem.library_item_id) or metadata.library_item_id,
                            local_playback_label = localSupport.supported
                                and tr("Listo para reproducir")
                                or tr("Audio local no compatible")
                        })
                    end
                end

                strikeMusicClient.SyncExistingFiles(player)

                local downloadsResult = strikeMusicClient.GetDownloads(player)
                local jobsToRender = localJobs

                if downloadsResult
                    and downloadsResult.status == "ok"
                    and activeStrikeMusicUI == musicUI
                then
                    local downloadErrorMessages = {
                        youtube_automation_blocked = "YouTube bloqueó la descarga automática.",
                        media_download_failed = "No se pudo procesar la descarga.",
                        source_url_required = "La descarga no tiene una URL válida.",
                        ffmpeg_not_installed = "El conversor de audio no está disponible.",
                    }
                    local mergedJobs = {}
                    local seenLocalKeys = {}

                    for _, job in ipairs(downloadsResult.jobs or {}) do
                        if job.status == "failed" then
                            job.display_status = tr(
                                downloadErrorMessages[job.error_reason]
                                    or "La descarga falló."
                            )
                        end

                        if job.status == "completed" and job.media_type == "mp3" then
                            for _, localJob in ipairs(localJobs) do
                                local metadata = localJob.local_metadata

                                if metadata
                                    and tostring(metadata.source_id) == tostring(job.source_id)
                                    and metadata.media_type == job.media_type
                                then
                                    job.thumbnail_url = metadata.thumbnail_url or job.thumbnail_url
                                    job.thumbnail_original_url = metadata.thumbnail_original_url
                                    job.local_thumbnail_path = metadata.local_thumbnail_path
                                    job.local_metadata = metadata
                                    job.local_playback_supported = localJob.local_playback_supported
                                    job.local_playback_label = localJob.local_playback_label
                                    seenLocalKeys[tostring(metadata.file_key)] = true
                                    break
                                end
                            end
                        end

                        table.insert(mergedJobs, job)
                    end

                    for _, localJob in ipairs(localJobs) do
                        if not seenLocalKeys[tostring(localJob.file_key)] then
                            table.insert(mergedJobs, localJob)
                        end
                    end

                    jobsToRender = mergedJobs
                elseif activeStrikeMusicUI ~= musicUI then
                    return
                end

                for _, result in ipairs(currentMusicSearchResults) do
                    result.local_download = nil
                    result.local_playback_supported = false

                    for _, job in ipairs(jobsToRender or {}) do
                        if job.status == "completed"
                            and job.media_type == "mp3"
                            and job.local_playback_supported
                            and tostring(job.source_id) == tostring(result.source_id)
                        then
                            result.local_download = job
                            result.local_playback_supported = true
                            break
                        end
                    end
                end

                localDownloadQueue = {}
                local currentLocalKey = getLocalDownloadKey(currentLocalDownload)

                for _, job in ipairs(jobsToRender or {}) do
                    if job.status == "completed"
                        and job.media_type == "mp3"
                        and job.local_playback_supported
                    then
                        job.is_playing = currentPlaybackKind == "local"
                            and currentLocalKey ~= nil
                            and currentLocalKey ~= ""
                            and getLocalDownloadKey(job) == currentLocalKey
                        table.insert(localDownloadQueue, job)
                    else
                        job.is_playing = false
                    end
                end

                musicUI.RenderDownloads(
                    jobsToRender or {},
                    playLocalDownload,
                    deleteLocalDownload,
                    saveReadyDownload,
                    function(job)
                        if job and job.library_item_id then
                            strikeMusicClient.AddFavorite(player, job.library_item_id)
                            favoriteLibraryIds[tostring(job.library_item_id)] = true
                            refreshMusicFavorites(false)
                        end
                    end,
                    function(job)
                        if job and job.library_item_id then
                            strikeMusicClient.AddToQueue(player, job.library_item_id)
                        end
                    end,
                    openAddToPlaylistPicker
                )

                if renderCurrentMusicSearchResults then
                    renderCurrentMusicSearchResults()
                end
            end)
        end

        local function getLocalDownloadIndex(job)
            local currentKey = getLocalDownloadKey(job)

            if currentKey == "" then
                return nil
            end

            for index, queuedJob in ipairs(localDownloadQueue) do
                if getLocalDownloadKey(queuedJob) == currentKey then
                    return index
                end
            end

            return nil
        end

        local function playAdjacentLocalDownload(direction)
            if #localDownloadQueue == 0 then
                return false
            end

            local currentIndex = getLocalDownloadIndex(currentLocalDownload)

            if not currentIndex then
                return false
            end

            local nextIndex = currentIndex + direction

            if nextIndex < 1 or nextIndex > #localDownloadQueue then
                return false
            end

            playLocalDownload(localDownloadQueue[nextIndex])
            return true
        end
        local playPopularRobloxTrack

        local function getAdjacentPopularTrack(direction)
            if #popularTracks == 0 then
                return nil
            end

            if shuffleEnabled and #popularTracks > 1 then
                local currentId = currentPopularTrack and currentPopularTrack.catalog_track_id
                local nextTrack = popularTracks[math.random(1, #popularTracks)]

                while nextTrack.catalog_track_id == currentId do
                    nextTrack = popularTracks[math.random(1, #popularTracks)]
                end

                return nextTrack
            end

            local currentIndex = 1

            for index, track in ipairs(popularTracks) do
                if currentPopularTrack
                    and track.catalog_track_id == currentPopularTrack.catalog_track_id
                then
                    currentIndex = index
                    break
                end
            end

            local nextIndex = ((currentIndex - 1 + direction) % #popularTracks) + 1
            return popularTracks[nextIndex]
        end

        playPopularRobloxTrack = function(track)
            if not musicUI or activeStrikeMusicUI ~= musicUI
                or not track or not track.roblox_audio_id
            then
                return
            end

            task.spawn(function()
                local libraryResult = strikeMusicClient.AddRobloxAudio(player, track)
                local libraryItem = libraryResult and libraryResult.item

                if not libraryItem then
                    return
                end

                local playbackResult = strikeMusicClient.PlayRobloxAudio(
                    track.roblox_audio_id,
                    musicUI.VolumeSlider.GetValue()
                )

                if playbackResult and playbackResult.status == "playing"
                    and activeStrikeMusicUI == musicUI
                then
                    currentPopularTrack = track
                    currentPlaybackKind = "popular"
                    currentLocalDownload = nil
                    track.library_item_id = libraryItem.library_item_id
                    musicUI.SetPlaybackState(true)
                    musicUI.SetNowPlaying(track, 0, "0:00", "0:00")
                    musicUI.SetFavoriteActive(favoriteLibraryIds[tostring(libraryItem.library_item_id)] == true)
                    strikeMusicClient.StartPlayback(
                        player,
                        libraryItem.library_item_id,
                        "manual",
                        0
                    )
                    if track.catalog_track_id then
                        Api.RegisterStrikeMusicPopularPlay(player, track.catalog_track_id)
                    end

                    refreshRecentMusic()
                end
            end)
        end

        playLocalDownload = function(job)
            if not job or not job.local_metadata then
                return
            end

            local playbackResult = strikeMusicClient.PlayLocalAudio(
                job.local_metadata,
                musicUI.VolumeSlider.GetValue()
            )

            if playbackResult and playbackResult.status == "playing" then
                currentPopularTrack = job.local_metadata
                currentPlaybackKind = "local"
                currentLocalDownload = job
                musicUI.SetPlaybackState(true)
                musicUI.SetNowPlaying(job.local_metadata, 0, "0:00", "0:00")
                musicUI.SetFavoriteActive(job.library_item_id and favoriteLibraryIds[tostring(job.library_item_id)] == true)
                refreshMusicDownloads()

                if job.library_item_id then
                    task.spawn(function()
                        strikeMusicClient.StartPlayback(
                            player,
                            job.library_item_id,
                            "manual",
                            0
                        )
                        refreshRecentMusic()
                    end)
                end
            end
        end

        deleteLocalDownload = function(job)
            if not job then
                return
            end

            if not job.local_metadata then
                if job.download_job_id then
                    local deleteJobResult = strikeMusicClient.DeleteDownloadJob(
                        player,
                        job.download_job_id
                    )

                    if deleteJobResult and deleteJobResult.status ~= "deleted" then
                        warn(
                            "StrikeMusic: download job delete failed",
                            tostring(deleteJobResult.reason or "unknown")
                        )
                    end

                    refreshMusicDownloads()
                end

                return
            end

            local deletedKey = getLocalDownloadKey(job)
            local currentKey = getLocalDownloadKey(currentLocalDownload)

            if currentPlaybackKind == "local"
                and deletedKey ~= ""
                and deletedKey == currentKey
            then
                strikeMusicClient.StopRobloxAudio()
                strikeMusicClient.StopPlayback(player)
                currentLocalDownload = nil
                currentPlaybackKind = nil
                musicUI.SetPlaybackState(false)
                musicUI.SetNowPlaying(nil, 0, "0:00", "0:00")
                musicUI.SetFavoriteActive(false)
            end

            local deleteResult = strikeMusicClient.DeleteLocalItem(
                player,
                job.local_metadata
            )

            if deleteResult and deleteResult.status ~= "deleted" then
                warn(
                    "StrikeMusic: local delete failed",
                    tostring(deleteResult.reason or "unknown")
                )
            end

            refreshMusicDownloads()
        end
        local function getLibraryItemIdFromFavorite(item)
            if not item then
                return nil
            end

            return item.library_item_id
                or (item.media and item.media.library_item_id)
        end

        local function playFavoriteItem(item)
            local media = item and (item.media or item)

            if not media then
                return
            end

            if media.media_type == "roblox_audio" and media.source_id then
                playPopularRobloxTrack({
                    roblox_audio_id = tonumber(media.source_id),
                    title = media.title,
                    artist = media.artist,
                    library_item_id = media.library_item_id
                })
                return
            end

            if media.file_key then
                local metadata = StrikeMusicStorage.ReadMetadata(media.file_key)

                if metadata then
                    strikeMusicClient.CacheThumbnail(metadata)
                    playLocalDownload({
                        title = metadata.title,
                        artist = metadata.artist,
                        media_type = metadata.media_type,
                        source_id = metadata.source_id,
                        thumbnail_url = metadata.thumbnail_url,
                        thumbnail_original_url = metadata.thumbnail_original_url,
                        local_thumbnail_path = metadata.local_thumbnail_path,
                        local_metadata = metadata,
                        local_playback_supported = true,
                        library_item_id = media.library_item_id
                    })
                end
            end
        end


        local function getLibraryItemIdFromMediaLike(item)
            if not item then
                return nil
            end

            return item.library_item_id
                or (item.media and item.media.library_item_id)
                or (item.local_metadata and item.local_metadata.library_item_id)
        end

        local function playPlaylistItem(item)
            playFavoriteItem(item)
        end

        local function renderCurrentPlaylist()
            if not currentPlaylist then
                return
            end

            musicUI.SetContentView("playlist", currentPlaylist.name)
            musicUI.RenderPlaylistItems(
                currentPlaylist.items or {},
                playPlaylistItem,
                function(item)
                    local media = item and (item.media or item)
                    local libraryItemId = media and media.library_item_id

                    if libraryItemId and currentPlaylist then
                        strikeMusicClient.DeleteFromPlaylist(
                            player,
                            currentPlaylist.playlist_id,
                            libraryItemId
                        )
                        openPlaylist(currentPlaylist)
                    end
                end,
                function(item)
                    local libraryItemId = getLibraryItemIdFromMediaLike(item)

                    if libraryItemId then
                        strikeMusicClient.AddFavorite(player, libraryItemId)
                        favoriteLibraryIds[tostring(libraryItemId)] = true
                        refreshMusicFavorites(false)
                    end
                end,
                function(item)
                    local libraryItemId = getLibraryItemIdFromMediaLike(item)

                    if libraryItemId then
                        strikeMusicClient.AddToQueue(player, libraryItemId)
                    end
                end,
                openAddToPlaylistPicker
            )
        end

        refreshMusicPlaylists = function()
            task.spawn(function()
                local result = strikeMusicClient.GetPlaylists(player)

                if activeStrikeMusicUI ~= musicUI then
                    return
                end

                currentPlaylists = {}

                if result and result.status == "ok" and result.items then
                    currentPlaylists = result.items
                end

                musicUI.RenderPlaylists(currentPlaylists, function(playlist)
                    openPlaylist(playlist)
                end)
            end)
        end

        openPlaylist = function(playlist)
            if not playlist or not playlist.playlist_id then
                return
            end

            task.spawn(function()
                local result = strikeMusicClient.GetPlaylist(player, playlist.playlist_id)

                if activeStrikeMusicUI ~= musicUI then
                    return
                end

                if result and result.status == "ok" and result.item then
                    currentPlaylist = result.item
                else
                    currentPlaylist = playlist
                end

                for _, playlistItem in ipairs(currentPlaylist.items or {}) do
                    local media = playlistItem.media or playlistItem

                    if media then
                        strikeMusicClient.CacheThumbnail(media)
                    end
                end

                renderCurrentPlaylist()
            end)
        end

        openAddToPlaylistPicker = function(item)
            local libraryItemId = getLibraryItemIdFromMediaLike(item)

            if not libraryItemId then
                return
            end

            musicUI.OpenPlaylistPicker(currentPlaylists, function(playlist)
                if playlist and playlist.playlist_id then
                    strikeMusicClient.AddToPlaylist(
                        player,
                        playlist.playlist_id,
                        libraryItemId
                    )

                    refreshMusicPlaylists()

                    if currentPlaylist
                        and tostring(currentPlaylist.playlist_id) == tostring(playlist.playlist_id)
                    then
                        openPlaylist(currentPlaylist)
                    end
                end
            end)
        end

        refreshMusicFavorites = function(showView)
            task.spawn(function()
                local result = strikeMusicClient.GetFavorites(player)

                if activeStrikeMusicUI ~= musicUI then
                    return
                end

                favoriteLibraryIds = {}
                currentFavoriteItems = {}

                if result and result.status == "ok" and result.items then
                    for _, item in ipairs(result.items) do
                        local libraryItemId = getLibraryItemIdFromFavorite(item)

                        if libraryItemId then
                            favoriteLibraryIds[tostring(libraryItemId)] = true
                        end

                        local media = item.media or item
                        if media then
                            strikeMusicClient.CacheThumbnail(media)
                        end

                        table.insert(currentFavoriteItems, item)
                    end
                end

                if showView then
                    musicUI.SetContentView("favorites")
                    musicUI.RenderFavorites(
                        currentFavoriteItems,
                        playFavoriteItem,
                        function(item)
                            local libraryItemId = getLibraryItemIdFromFavorite(item)

                            if libraryItemId then
                                strikeMusicClient.DeleteFavorite(player, libraryItemId)
                                favoriteLibraryIds[tostring(libraryItemId)] = nil
                            end

                            refreshMusicFavorites(true)
                        end,
                        function(item)
                            local libraryItemId = getLibraryItemIdFromFavorite(item)

                            if libraryItemId then
                                strikeMusicClient.AddToQueue(player, libraryItemId)
                            end
                        end,
                        openAddToPlaylistPicker
                    )
                end

                if currentPlaybackKind == "local"
                    and currentLocalDownload
                    and currentLocalDownload.library_item_id
                then
                    musicUI.SetFavoriteActive(
                        favoriteLibraryIds[tostring(currentLocalDownload.library_item_id)] == true
                    )
                elseif currentPopularTrack and currentPopularTrack.library_item_id then
                    musicUI.SetFavoriteActive(
                        favoriteLibraryIds[tostring(currentPopularTrack.library_item_id)] == true
                    )
                else
                    musicUI.SetFavoriteActive(false)
                end
            end)
        end

        local function toggleCurrentFavorite()
            local libraryItemId = nil

            if currentPlaybackKind == "local" and currentLocalDownload then
                libraryItemId = currentLocalDownload.library_item_id
            elseif currentPopularTrack then
                libraryItemId = currentPopularTrack.library_item_id
            end

            if not libraryItemId then
                return
            end

            task.spawn(function()
                local key = tostring(libraryItemId)

                if favoriteLibraryIds[key] then
                    strikeMusicClient.DeleteFavorite(player, libraryItemId)
                    favoriteLibraryIds[key] = nil
                    musicUI.SetFavoriteActive(false)
                else
                    local result = strikeMusicClient.AddFavorite(player, libraryItemId)

                    if result and (result.status == "created" or result.status == "ok") then
                        favoriteLibraryIds[key] = true
                        musicUI.SetFavoriteActive(true)
                    end
                end

                refreshMusicFavorites(false)
            end)
        end
        local musicDownloadLocked = false

        saveReadyDownload = function(job)
            if musicDownloadLocked then
                print("StrikeMusic: ready download ignored because another download is active")
                return
            end

            if not job or job.status ~= "ready" then
                return
            end

            musicDownloadLocked = true

            task.spawn(function()
                local ok, downloadedResult = pcall(function()
                    return strikeMusicClient.DownloadReadyJob(player, job)
                end)

                if not ok then
                    warn("StrikeMusic: ready download flow crashed", tostring(downloadedResult))
                else
                    print(
                        "StrikeMusic: ready download result",
                        tostring(downloadedResult and downloadedResult.status or "nil"),
                        tostring(downloadedResult and downloadedResult.reason or "")
                    )

                    local completedItem = downloadedResult
                        and downloadedResult.complete
                        and downloadedResult.complete.item

                    if downloadedResult
                        and downloadedResult.status == "downloaded"
                        and downloadedResult.metadata
                    then
                        strikeMusicClient.CacheThumbnail(downloadedResult.metadata)

                        playLocalDownload({
                            title = downloadedResult.metadata.title,
                            artist = downloadedResult.metadata.artist,
                            media_type = downloadedResult.metadata.media_type,
                            source_id = downloadedResult.metadata.source_id,
                            thumbnail_url = downloadedResult.metadata.thumbnail_url,
                            thumbnail_original_url = downloadedResult.metadata.thumbnail_original_url,
                            local_thumbnail_path = downloadedResult.metadata.local_thumbnail_path,
                            local_metadata = downloadedResult.metadata,
                            local_playback_supported = true,
                            library_item_id = completedItem
                                and completedItem.library_item_id
                        })
                    end
                end

                refreshMusicDownloads()
                musicDownloadLocked = false
            end)
        end

        local function downloadSearchResult(result, mediaType)
            if musicDownloadLocked then
                print("StrikeMusic: download ignored because another download is active")
                return
            end

            if not result then
                warn("StrikeMusic: download callback received no result")
                return
            end

            print("StrikeMusic: download callback", tostring(mediaType), tostring(result.source_id or "unknown"))
            musicDownloadLocked = true

            task.spawn(function()
                local ok, downloadedResult = pcall(function()
                    return strikeMusicClient.DownloadResult(player, result, mediaType)
                end)

                if not ok then
                    warn("StrikeMusic: download flow crashed", tostring(downloadedResult))
                else
                    print(
                        "StrikeMusic: download result",
                        tostring(downloadedResult and downloadedResult.status or "nil"),
                        tostring(downloadedResult and downloadedResult.reason or "")
                    )

                    local completedItem = downloadedResult
                        and downloadedResult.complete
                        and downloadedResult.complete.item

                    if downloadedResult
                        and downloadedResult.status == "downloaded"
                        and downloadedResult.metadata
                    then
                        strikeMusicClient.CacheThumbnail(downloadedResult.metadata)

                        playLocalDownload({
                            title = downloadedResult.metadata.title,
                            artist = downloadedResult.metadata.artist,
                            media_type = downloadedResult.metadata.media_type,
                            source_id = downloadedResult.metadata.source_id,
                            thumbnail_url = downloadedResult.metadata.thumbnail_url,
                            thumbnail_original_url = downloadedResult.metadata.thumbnail_original_url,
                            local_thumbnail_path = downloadedResult.metadata.local_thumbnail_path,
                            local_metadata = downloadedResult.metadata,
                            local_playback_supported = true,
                            library_item_id = completedItem
                                and completedItem.library_item_id
                        })
                    end
                end

                refreshMusicDownloads()
                musicDownloadLocked = false
            end)
        end
        renderCurrentMusicSearchResults = function()
            if activeStrikeMusicUI ~= musicUI then
                return
            end

            musicUI.RenderSearchResults(
                currentMusicSearchResults,
                function(result)
                    if result and result.local_download then
                        playLocalDownload(result.local_download)
                    end
                end,
                true,
                downloadSearchResult
            )
        end

        local function getSearchProviderErrorMessage(providerStatus)
            local messages = {
                youtube_api_key_not_configured = "La clave de YouTube API no esta configurada en el backend.",
                youtube_api_request_failed = "La API oficial de YouTube no pudo responder.",
                yt_dlp_not_installed = "El buscador yt-dlp no esta instalado en el backend.",
                provider_request_failed = "El buscador no pudo conectarse a YouTube."
            }

            return tr(messages[providerStatus] or "No se pudo consultar el buscador.")
        end
        local function searchMusic(query)
            local normalizedQuery = tostring(query or ""):gsub("^%s+", ""):gsub("%s+$", "")

            if normalizedQuery == "" then
                return
            end

            local audioId = extractRobloxAudioId(normalizedQuery)

            if audioId and audioId > 0 then
                local track = getRobloxAudioTrack(audioId)
                musicUI.RenderSearchResults({track}, playPopularRobloxTrack)
                return
            end

            task.spawn(function()
                local searchResult = strikeMusicClient.Search(player, normalizedQuery, 6)

                if activeStrikeMusicUI ~= musicUI then
                    return
                end

                if not searchResult or searchResult.status ~= "ok" then
                    musicUI.RenderSearchResults(
                        {},
                        nil,
                        true,
                        nil,
                        tr("No se pudo consultar el buscador.")
                    )
                    return
                end

                if searchResult.provider_status ~= "ok" then
                    musicUI.RenderSearchResults(
                        {},
                        nil,
                        true,
                        nil,
                        getSearchProviderErrorMessage(searchResult.provider_status)
                    )
                    return
                end

                local results = {}

                local thumbnailMessages = {
                    thumbnail_url_missing = "Portada no disponible",
                    filesystem_not_supported = "Sin almacenamiento local",
                    local_asset_loader_not_supported = "Sin cargador local de imagen",
                    thumbnail_folder_failed = "No se pudo crear caché de portada",
                    thumbnail_download_failed = "No se pudo descargar portada",
                    thumbnail_asset_load_failed = "Delta no pudo cargar portada"
                }

                for _, result in ipairs(searchResult.results or {}) do
                    result.downloadable = true
                    strikeMusicClient.CacheThumbnail(result)
                    result.thumbnail_debug_text = thumbnailMessages[result.thumbnail_debug]
                    table.insert(results, result)
                end

                currentMusicSearchResults = results
                renderCurrentMusicSearchResults()
            end)
        end

        musicUI.SearchInput.FocusLost:Connect(function()
            local query = tostring(musicUI.SearchInput.Text or "")

            if query:gsub("%s+", "") ~= "" then
                searchMusic(query)
            end
        end)
        local function playAdjacentPopularTrack(direction)
            local track = getAdjacentPopularTrack(direction)

            if track then
                playPopularRobloxTrack(track)
            end
        end

        local function togglePlayback()
            local state = strikeMusicClient.GetRobloxAudioState()

            if state.status == "playing" then
                local paused = strikeMusicClient.PauseRobloxAudio()
                musicUI.SetPlaybackState(false)

                task.spawn(function()
                    strikeMusicClient.PausePlayback(player, paused.position_seconds or 0)
                end)
            elseif state.status == "paused" then
                strikeMusicClient.ResumeRobloxAudio()
                musicUI.SetPlaybackState(true)

                task.spawn(function()
                    strikeMusicClient.ResumePlayback(player)
                end)
            elseif currentPlaybackKind == "local" and currentLocalDownload then
                playLocalDownload(currentLocalDownload)
            elseif currentPopularTrack then
                playPopularRobloxTrack(currentPopularTrack)
            end
        end

        strikeMusicClient.SetRobloxAudioEndedHandler(function()
            if activeStrikeMusicUI ~= musicUI then
                return
            end

            if currentPlaybackKind == "local" then
                if repeatEnabled and currentLocalDownload then
                    playLocalDownload(currentLocalDownload)
                elseif playAdjacentLocalDownload(1) then
                    return
                else
                    musicUI.SetPlaybackState(false)
                    currentLocalDownload = nil

                    task.spawn(function()
                        strikeMusicClient.StopPlayback(player)
                    end)
                end

                return
            end

            if repeatEnabled and currentPopularTrack then
                playPopularRobloxTrack(currentPopularTrack)
            else
                playAdjacentPopularTrack(1)
            end
        end)

        musicUI.Buttons.Play.MouseButton1Click:Connect(togglePlayback)
        musicUI.Buttons.BottomPlay.MouseButton1Click:Connect(togglePlayback)
        musicUI.Buttons.Heart.MouseButton1Click:Connect(toggleCurrentFavorite)
        musicUI.Buttons.BottomHeart.MouseButton1Click:Connect(toggleCurrentFavorite)

        local function playPrevious()
            local state = strikeMusicClient.GetRobloxAudioState()

            if state.status ~= "idle" and (state.position_seconds or 0) > 3 then
                strikeMusicClient.SetRobloxAudioTimePosition(0)
                return
            end

            if currentPlaybackKind == "local" then
                playAdjacentLocalDownload(-1)
                return
            end

            playAdjacentPopularTrack(-1)
        end

        local function playNext()
            if currentPlaybackKind == "local" then
                playAdjacentLocalDownload(1)
                return
            end

            playAdjacentPopularTrack(1)
        end

        musicUI.Buttons.Previous.MouseButton1Click:Connect(playPrevious)
        musicUI.Buttons.BottomPrevious.MouseButton1Click:Connect(playPrevious)
        musicUI.Buttons.Next.MouseButton1Click:Connect(playNext)
        musicUI.Buttons.BottomNext.MouseButton1Click:Connect(playNext)
        musicUI.Buttons.Shuffle.MouseButton1Click:Connect(function()
            shuffleEnabled = not shuffleEnabled
        end)
        musicUI.Buttons.BottomShuffle.MouseButton1Click:Connect(function()
            shuffleEnabled = not shuffleEnabled
        end)
        musicUI.Buttons.Repeat.MouseButton1Click:Connect(function()
            repeatEnabled = not repeatEnabled
        end)
        musicUI.Buttons.BottomRepeat.MouseButton1Click:Connect(function()
            repeatEnabled = not repeatEnabled
        end)
        musicUI.VolumeSlider.Changed:Connect(function(value)
            strikeMusicClient.SetRobloxAudioVolume(value)
        end)

        if musicUI.ProgressSeeked then
            musicUI.ProgressSeeked:Connect(function(value)
                local state = strikeMusicClient.GetRobloxAudioState()
                local duration = tonumber(state.duration_seconds) or 0

                if duration <= 0 then
                    return
                end

                local nextPosition = math.clamp(tonumber(value) or 0, 0, 1) * duration
                strikeMusicClient.SetRobloxAudioTimePosition(nextPosition)
            end)
        end

        if musicUI.NavButtons.Downloads then
            musicUI.NavButtons.Downloads.MouseButton1Click:Connect(function()
                musicUI.SetContentView("downloads")
                refreshMusicDownloads()
            end)
        end

        if musicUI.NavButtons.Home then
            musicUI.NavButtons.Home.MouseButton1Click:Connect(function()
                musicUI.SetContentView("home")
            end)
        end

        if musicUI.NavButtons.LikedSongs then
            musicUI.NavButtons.LikedSongs.MouseButton1Click:Connect(function()
                refreshMusicFavorites(true)
            end)
        end

        if musicUI.NavButtons.MyFavorites then
            musicUI.NavButtons.MyFavorites.MouseButton1Click:Connect(function()
                refreshMusicFavorites(true)
            end)
        end

        if musicUI.NavButtons.NewPlaylist then
            musicUI.NavButtons.NewPlaylist.MouseButton1Click:Connect(function()
                musicUI.OpenCreatePlaylistModal(function(name)
                    local cleanName = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")

                    if cleanName == "" then
                        return
                    end

                    local result = strikeMusicClient.CreatePlaylist(player, cleanName)

                    if result and result.status == "created" and result.item then
                        refreshMusicPlaylists()
                        openPlaylist(result.item)
                    end
                end)
            end)
        end

        if musicUI.DeletePlaylistButton then
            musicUI.DeletePlaylistButton.MouseButton1Click:Connect(function()
                if not currentPlaylist then
                    return
                end

                local playlistToDelete = currentPlaylist

                musicUI.OpenDeletePlaylistConfirm(playlistToDelete, function()
                    strikeMusicClient.DeletePlaylist(player, playlistToDelete.playlist_id)
                    currentPlaylist = nil
                    refreshMusicPlaylists()
                    musicUI.SetContentView("home")
                end)
            end)
        end

        refreshMusicPlaylists()

        task.spawn(function()
            while activeStrikeMusicUI == musicUI and musicUI.Gui.Parent do
                local state = strikeMusicClient.GetRobloxAudioState()
                local currentTrack = currentPlaybackKind == "local"
                    and currentLocalDownload
                    or currentPopularTrack

                if currentTrack and state.status ~= "idle" then
                    local duration = state.duration_seconds or 0
                    local progress = duration > 0
                        and (state.position_seconds or 0) / duration
                        or 0

                    musicUI.SetNowPlaying(
                        currentTrack,
                        progress,
                        formatMusicTime(state.position_seconds),
                        formatMusicTime(duration)
                    )
                    musicUI.SetPlaybackState(state.status == "playing")
                end

                task.wait(0.25)
            end
        end)

        task.spawn(function()
            strikeMusicClient.Open(player)
            refreshMusicFavorites(false)

            local popularResult = strikeMusicClient.GetPopular(6)

            if popularResult
                and popularResult.status == "ok"
                and popularResult.items
                and activeStrikeMusicUI == musicUI
            then
                popularTracks = popularResult.items
                musicUI.RenderPopular(popularTracks, playPopularRobloxTrack)
            end
        end)
        activeStrikeMusicUI.MinimizeButton.MouseButton1Click:Connect(function()
            task.spawn(function()
                strikeMusicClient.Minimize(player)
            end)
        end)

        if activeStrikeMusicUI.MinimizedButton then
            activeStrikeMusicUI.MinimizedButton.MouseButton1Click:Connect(function()
                task.spawn(function()
                    strikeMusicClient.Restore(player)
                end)
            end)
        end

        activeStrikeMusicUI.CloseButton.MouseButton1Click:Connect(function()
            strikeMusicClient.StopRobloxAudio()

            task.spawn(function()
                strikeMusicClient.Close(player)
            end)

            activeStrikeMusicUI.Destroy()
            activeStrikeMusicUI = nil
            window.Gui.Enabled = true
        end)
    end)
end


leftPanel.Buttons.TablaClanes.MouseButton1Click:Connect(function()
    window.Gui.Enabled = false

    local clansResult = Api.GetClans()
    local clans = {}
    local myProfile = heartbeatResult.profile
    local profileResult = Api.GetMyProfile(player)

    if profileResult and profileResult.status == "ok" and profileResult.profile then
        myProfile = profileResult.profile
    end

    if clansResult and clansResult.clans then
        clans = clansResult.clans
    end

    local ownedClan = findOwnedClan(myProfile, clans)

    local clanUI = ClanTableUI.Create(CoreGui, Theme, clans)
    activeClanTableUI = clanUI
    I18n.RegisterRoot(clanUI.Gui)

    if clanUI.SetCurrentClanId then
        clanUI.SetCurrentClanId(myProfile and myProfile.clan_id)
    end

    if clanUI.SetOwnedClanId then
        clanUI.SetOwnedClanId(ownedClan and ownedClan.clan_id)
    end

    if clanUI.SetJoinActionHandler then
        clanUI.SetJoinActionHandler(function(clan)
            if not clan or not clan.clan_id then
                return
            end

            local currentClanId = myProfile and myProfile.clan_id

            if currentClanId and tostring(currentClanId) == tostring(clan.clan_id) then
                if tostring(clan.owner_user_id) == tostring(player.UserId) then
                    confirmAction = function()
                        ensureClanRequestModal().OpenInfo("Eliminando clan...")

                        local deleteResult = Api.DeleteClan(player, clan.clan_id)

                        if deleteResult and deleteResult.status == "deleted" then
                            myProfile = applyLatestProfile(nil) or myProfile
                            ownedClan = nil

                            if clanUI.SetCurrentClanId then
                                clanUI.SetCurrentClanId(nil)
                            end

                            if clanUI.SetOwnedClanId then
                                clanUI.SetOwnedClanId(nil)
                            end

                            ensureClanRequestModal().OpenInfo("Clan eliminado correctamente.")
                            refreshOnlineUsers()
                            refreshChat()
                        else
                            ensureClanRequestModal().OpenInfo("No se pudo eliminar el clan.")
                        end
                    end

                    confirmSecondaryAction = function()
                        ensureClanRequestModal().OpenInfo("Eliminacion cancelada.")
                    end

                    confirmModal.Open(
                        "Estas seguro/a que quieres eliminar este clan? Se expulsara a todos los integrantes.",
                        "Si",
                        "No"
                    )

                    confirmModal.SecondaryButton.Visible = true
                    return
                end

                local leaveResult = Api.LeaveClan(player)

                if leaveResult and leaveResult.status == "left" then
                    myProfile = leaveResult.profile or myProfile
                    clanUI.SetCurrentClanId(nil)
                    ensureClanRequestModal().OpenInfo("Saliste del clan.")
                    refreshOnlineUsers()
                    refreshChat()
                else
                    ensureClanRequestModal().OpenInfo("No se pudo salir del clan.")
                end

                return
            end

            if pendingClanJoinRequest
                and pendingClanJoinRequest.clan_id
                and tostring(pendingClanJoinRequest.clan_id) == tostring(clan.clan_id)
            then
                ensureClanRequestModal().OpenInfo("Solicitud enviada")
                return
            end

            local requestResult = Api.RequestJoinClan(player, clan.clan_id)

            if requestResult and requestResult.status == "sent" and requestResult.request then
                pendingClanJoinRequest = requestResult.request

                if clanUI.SetPendingRequestClanId then
                    clanUI.SetPendingRequestClanId(clan.clan_id)
                end

                ensureClanRequestModal().OpenInfo("Solicitud enviada")
            elseif requestResult and requestResult.reason == "leader_offline" then
                ensureClanRequestModal().OpenInfo("Envia la solicitud cuando el Lider se encuentre En Linea")
            elseif requestResult and requestResult.reason == "user_already_in_clan" then
                local latestProfileResult = Api.GetMyProfile(player)

                if latestProfileResult and latestProfileResult.status == "ok" and latestProfileResult.profile then
                    myProfile = latestProfileResult.profile
                    clanUI.SetCurrentClanId(myProfile.clan_id)

                    if clanUI.SetPendingRequestClanId then
                        clanUI.SetPendingRequestClanId(nil)
                    end
                end
            else
                ensureClanRequestModal().OpenInfo("No se pudo enviar la solicitud.")
            end
        end)
    end

    clanUI.CloseButton.MouseButton1Click:Connect(function()
        clanUI.Destroy()
        activeClanTableUI = nil
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

    local profileUI = ProfileUI.Create(CoreGui, Theme, profile, player, AvatarRenderer, currentGameActivity)
    local inventoryUI = InventoryUI.Create(profileUI.Gui, Theme)
    I18n.RegisterRoot(profileUI.Gui)
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
            item_not_usable = "Este item aun no se puede usar desde inventario.",
            item_delete_not_allowed = "Este item no se puede eliminar.",
            invalid_username_color = "Ese color de nombre no esta disponible.",
            invalid_chat_style = "Ese estilo de chat no esta disponible.",
            invalid_profile_banner = "Ese diseño de fondo no esta disponible."
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

    local function getProfileSaveErrorMessage(reason)
        local messages = {
            invalid_profile_avatar = "El ID de imagen de perfil no es valido."
        }

        return messages[reason] or "No se pudo guardar el perfil."
    end

    if profileUI.SetAvatarApplyHandler then
        profileUI.SetAvatarApplyHandler(function(profileAvatarId)
            if saveLocked then
                return {
                    status = "blocked",
                    reason = "save_locked"
                }
            end

            saveLocked = true

            local ok, result = pcall(function()
                return Api.SaveMyProfile(
                    player,
                    {
                        profile_avatar_id = profileAvatarId
                    }
                )
            end)

            if not ok then
                saveLocked = false
                return nil
            end

            if result and result.status == "ok" and result.profile then
                profileUI.ApplyProfile(result.profile)

                if leftPanel.DisplayName then
                    leftPanel.DisplayName.Text = tostring(result.profile.display_name or player.DisplayName)
                end

                if leftPanel.PointsValue then
                    leftPanel.PointsValue.Text = tostring(result.profile.personal_points or 0)
                end

                refreshOnlineUsers()
                refreshChat()
            end

            saveLocked = false

            return result
        end)
    end

    local function refreshInventory()
        local inventoryResult = Api.GetMyInventory(player)

        if inventoryResult and inventoryResult.status == "ok" then
            inventoryUI.Render(inventoryResult.items or {}, function(itemId, styleValue)
                if inventoryLocked then
                    return
                end

                inventoryLocked = true
                inventoryUI.ShowStatus("Aplicando item...", false)

                local useResult = Api.UseInventoryItem(player, itemId, styleValue)

                if useResult and useResult.status == "ok" then
                    if useResult.action == "create_clan" then
                        inventoryUI.ShowClanForm()
                        inventoryLocked = false
                        return
                    end

                    if useResult.profile then
                        profileUI.ApplyProfile(useResult.profile)

                        if window.SetBackgroundDesign then
                            window.SetBackgroundDesign(useResult.profile.profile_banner_id)
                        end
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
            end, function(itemId)
                local ownedClanForDeletion = nil

                if itemId == "clan_ticket" then
                    ownedClanForDeletion = getOwnedClan(profile)
                end

                confirmAction = function()
                    if inventoryLocked then
                        return
                    end

                    inventoryLocked = true

                    if ownedClanForDeletion then
                        inventoryUI.ShowStatus("Eliminando clan...", false)

                        local deleteClanResult = Api.DeleteClan(player, ownedClanForDeletion.clan_id)

                        if deleteClanResult and deleteClanResult.status == "deleted" then
                            Api.DeleteInventoryItem(player, itemId)

                            local latestProfile = applyLatestProfile(function(updatedProfile)
                                profileUI.ApplyProfile(updatedProfile)
                            end)

                            if latestProfile then
                                profile = latestProfile
                            end

                            refreshInventory()
                            inventoryUI.ShowStatus("Clan eliminado correctamente.", false)
                            refreshOnlineUsers()
                            refreshChat()
                        else
                            inventoryUI.ShowStatus("No se pudo eliminar el clan.", true)
                        end

                        inventoryLocked = false
                        return
                    end

                    inventoryUI.ShowStatus("Eliminando item...", false)

                    local deleteResult = Api.DeleteInventoryItem(player, itemId)

                    if deleteResult and deleteResult.status == "deleted" then
                        if deleteResult.profile then
                            profileUI.ApplyProfile(deleteResult.profile)
                        end

                        refreshInventory()
                        inventoryUI.ShowStatus("Item eliminado correctamente.", false)
                        refreshOnlineUsers()
                    else
                        inventoryUI.ShowStatus(
                            getInventoryErrorMessage(deleteResult and deleteResult.reason),
                            true
                        )
                    end

                    inventoryLocked = false
                end

                confirmSecondaryAction = function()
                    inventoryUI.ShowStatus("Eliminacion cancelada.", false)
                end

                if ownedClanForDeletion then
                    confirmModal.Open(
                        "Estas seguro/a que quieres eliminar este clan? Se expulsara a todos los integrantes.",
                        "Si",
                        "No"
                    )
                else
                    confirmModal.Open(
                        "Estas seguro/a que quieres eliminar este item de tu inventario?",
                        "Si",
                        "No"
                    )
                end

                confirmModal.SecondaryButton.Visible = true
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
                profile = clanResult.profile
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
                player,
                AvatarRenderer
            )
            I18n.Apply(profileUI.Gui)

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

            refreshOnlineUsers()
            refreshChat()
        else
            profileUI.ShowStatus(getProfileSaveErrorMessage(result and result.reason), true)
        end

        saveLocked = false
    end)
end)


leftPanel.Buttons.Tienda.MouseButton1Click:Connect(function()
    window.Gui.Enabled = false

    local currentPoints = tonumber(leftPanel.PointsValue and leftPanel.PointsValue.Text) or 0
    local latestProfileResult = Api.GetMyProfile(player)

    if latestProfileResult
        and latestProfileResult.status == "ok"
        and latestProfileResult.profile
    then
        currentPoints = tonumber(latestProfileResult.profile.personal_points) or currentPoints

        if leftPanel.PointsValue then
            leftPanel.PointsValue.Text = tostring(currentPoints)
        end
    end

    local shopUI = ShopUI.Create(CoreGui, Theme, currentPoints)
    local rewardModal = RewardModal.Create(shopUI.Gui, Theme)
    I18n.RegisterRoot(shopUI.Gui)
    local rewardPurchaseLocked = false
    local shopPurchaseLocked = false

    local function updateDisplayedPoints(profile)
        if not profile then
            return
        end

        local points = tostring(profile.personal_points or 0)

        if leftPanel.PointsValue then
            leftPanel.PointsValue.Text = points
        end

        if shopUI.SetPoints then
            shopUI.SetPoints(points)
        elseif shopUI.PointsValue then
            shopUI.PointsValue.Text = points
        end
    end

    local function applyLimitedStock(key, remaining)
        local label = shopUI.LimitedStockLabels[key]
        local button = shopUI.LimitedButtons[key]

        if not label or not button then
            return
        end

        label.Text = tr("Restante " .. tostring(remaining))

        if remaining <= 0 then
            button.Text = tr("AGOTADO")
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
            updateDisplayedPoints(result.profile)
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
            button.Text = tr("Comprando...")
        end

        local result = Api.BuyShopItem(player, itemId)

        if result and result.status == "ok" and result.inventory_item then
            if button then
                button.Text = tr("COMPRADO")
                button.AutoButtonColor = false
                button.Active = false
            end

            updateDisplayedPoints(result.profile)
        else
            if button and result and result.reason == "item_already_owned" then
                button.Text = tr("YA LO TIENES")
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
        buyInventoryItem("chat_personalizado", shopUI.ItemButtons.CustomChat)
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
    confirmAction = nil
    confirmSecondaryAction = nil
    confirmModal.Close()
end)

confirmModal.PrimaryButton.MouseButton1Click:Connect(function()

    if confirmAction then
        confirmAction()
    end

    confirmAction = nil
    confirmSecondaryAction = nil
    confirmModal.Close()

end)

confirmModal.SecondaryButton.MouseButton1Click:Connect(function()

    if confirmSecondaryAction then
        confirmSecondaryAction()
    end

    confirmAction = nil
    confirmSecondaryAction = nil
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

    if adminNoticeGui then
        adminNoticeGui:Destroy()
    end

    if confirmModal and confirmModal.Destroy then
        confirmModal.Destroy()
    end

    if clanRequestModal and clanRequestModal.Destroy then
        clanRequestModal.Destroy()
    end

    if activeStrikeMusicUI then
        strikeMusicClient.StopRobloxAudio()
        activeStrikeMusicUI.Destroy()
        activeStrikeMusicUI = nil
    end

    window.Gui:Destroy()
end)

task.spawn(function()
    while running do
        local result = Api.GetClanJoinRequests(player)

        if result and result.status == "ok" and result.requests and not clanRequestModalBusy then
            for _, joinRequest in ipairs(result.requests) do
                local requestId = joinRequest.request_id

                if requestId and not shownClanJoinRequests[requestId] then
                    shownClanJoinRequests[requestId] = true
                    clanRequestModalBusy = true

                    ensureClanRequestModal().OpenJoinRequest(
                        joinRequest,
                        function()
                            Api.RespondClanJoinRequest(player, requestId, "accept")
                            clanRequestModalBusy = false
                        end,
                        function()
                            Api.RespondClanJoinRequest(player, requestId, "reject")
                            clanRequestModalBusy = false
                        end
                    )

                    break
                end
            end
        end

        task.wait(5)
    end
end)

task.spawn(function()
    while running do
        if pendingClanJoinRequest and pendingClanJoinRequest.request_id then
            local result = Api.GetClanJoinRequestStatus(player, pendingClanJoinRequest.request_id)
            local requestStatus = result and result.request and result.request.status

            if requestStatus == "accepted" then
                local joinedResult = result.result

                if joinedResult and joinedResult.profile then
                    heartbeatResult.profile = joinedResult.profile

                    if leftPanel.DisplayName then
                        leftPanel.DisplayName.Text = tostring(joinedResult.profile.display_name or player.DisplayName)
                    end

                    if activeClanTableUI and activeClanTableUI.SetCurrentClanId then
                        activeClanTableUI.SetCurrentClanId(joinedResult.profile.clan_id)
                    end

                    if activeClanTableUI and activeClanTableUI.SetPendingRequestClanId then
                        activeClanTableUI.SetPendingRequestClanId(nil)
                    end

                    refreshOnlineUsers()
                    refreshChat()
                end

                pendingClanJoinRequest = nil
                ensureClanRequestModal().OpenInfo("Solicitud aceptada.")
            elseif requestStatus == "rejected" or requestStatus == "blocked" then
                pendingClanJoinRequest = nil

                if activeClanTableUI and activeClanTableUI.SetPendingRequestClanId then
                    activeClanTableUI.SetPendingRequestClanId(nil)
                end

                ensureClanRequestModal().OpenInfo("Solicitud rechazada.")
            elseif result and result.status == "blocked" then
                pendingClanJoinRequest = nil

                if activeClanTableUI and activeClanTableUI.SetPendingRequestClanId then
                    activeClanTableUI.SetPendingRequestClanId(nil)
                end
            end
        end

        task.wait(4)
    end
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
