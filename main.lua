local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local running = true

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

local lastChatSignature = ""

local function renderMessages(messages)
    local signature = HttpService:JSONEncode(messages or {})

    if signature == lastChatSignature then
        return
    end

    lastChatSignature = signature

    for _, child in ipairs(chatPanel.MessagesBox:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, msg in ipairs(messages or {}) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -8, 0, 34)
        label.BackgroundTransparency = 1
        label.TextColor3 = Theme.Colors.Text
        label.Font = Theme.Font.Regular
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true

        local name = msg.display_name or msg.username or "Usuario"

        if msg.clan_tag then
            if msg.clan_tag_style == "plain" then
                name = name .. msg.clan_tag
            else
                name = name .. "[" .. msg.clan_tag .. "]"
            end
        end

        if msg.type == "system" then
            label.TextColor3 = Theme.Colors.TextMuted
            label.Text = "[SYSTEM] " .. tostring(msg.message)
        else
            label.Text = name .. ": " .. tostring(msg.message)
        end

        label.Parent = chatPanel.MessagesBox
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
    local result = Api.GetGlobalMessages()

    if result and result.messages then
        renderMessages(result.messages)
    end
end

local function refreshOnlineUsers()
    local result = Api.GetOnlineUsers()

    if result and result.users then
        rightPanel.Render(result.users)
    end
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

local function sendCurrentMessage()
    local text = chatPanel.Input.Text

    if not text or text:gsub("%s+", "") == "" then
        return
    end

    chatPanel.Input.Text = ""

    local result = Api.SendGlobalMessage(player, text)

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

window.CloseButton.MouseButton1Click:Connect(function()
    running = false
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