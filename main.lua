local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local BASE_RAW = "https://raw.githubusercontent.com/clayyy333/StrikeChat-lua/main/"

local Theme = loadstring(game:HttpGet(BASE_RAW .. "modules/theme.lua"))()
local Api = loadstring(game:HttpGet(BASE_RAW .. "modules/api.lua"))()
local MainWindow = loadstring(game:HttpGet(BASE_RAW .. "modules/main_window.lua"))()
local ChatPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/chat_panel.lua"))()
local LeftPanel = loadstring(game:HttpGet(BASE_RAW .. "modules/left_panel.lua"))()


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

window.CloseButton.MouseButton1Click:Connect(function()
    window.Gui:Destroy()
end)