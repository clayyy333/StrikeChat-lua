local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local Theme = loadstring(readfile("lua/modules/theme.lua"))()
local Api = loadstring(readfile("lua/modules/api.lua"))()
local MainWindow = loadstring(readfile("lua/modules/main_window.lua"))()

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