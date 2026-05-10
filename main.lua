local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local BASE_RAW = "https://raw.githubusercontent.com/clayyy333/StrikeChat-lua/main/"

local Theme = loadstring(game:HttpGet(BASE_RAW .. "modules/theme.lua"))()
local Api = loadstring(game:HttpGet(BASE_RAW .. "modules/api.lua"))()
local MainWindow = loadstring(game:HttpGet(BASE_RAW .. "modules/main_window.lua"))()

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

window.CloseButton.MouseButton1Click:Connect(function()
    window.Gui:Destroy()
end)