local Api = {}

Api.BaseUrl = "https://strikechat-api.onrender.com"

local HttpService = game:GetService("HttpService")

local httpRequest =
    request or
    http_request or
    (syn and syn.request)

function Api.HasRequest()
    return httpRequest ~= nil
end

function Api.Encode(value)
    return HttpService:UrlEncode(tostring(value))
end

function Api.Decode(body)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    if ok then
        return decoded
    end

    return nil
end

function Api.Request(url, method, body)
    if not httpRequest then
        return nil
    end

    local data = {
        Url = url,
        Method = method or "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    }

    if body then
        data.Body = HttpService:JSONEncode(body)
    end

    local ok, response = pcall(function()
        return httpRequest(data)
    end)

    if not ok or not response or not response.Body then
        return nil
    end

    return Api.Decode(response.Body)
end

function Api.Heartbeat(player)
    local url =
        Api.BaseUrl ..
        "/online-users/heartbeat" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&roblox_username=" .. Api.Encode(player.Name) ..
        "&roblox_display_name=" .. Api.Encode(player.DisplayName)

    return Api.Request(url, "POST")
end

function Api.GetOnlineUsers()
    return Api.Request(Api.BaseUrl .. "/online-users", "GET")
end

function Api.GetGlobalMessages()
    return Api.Request(Api.BaseUrl .. "/chat/messages?room_id=global", "GET")
end

function Api.SendGlobalMessage(player, message)
    return Api.Request(
        Api.BaseUrl .. "/chat/send",
        "POST",
        {
            room_id = "global",
            roblox_user_id = player.UserId,
            username = player.DisplayName,
            message = message
        }
    )
end

function Api.GetRoomMessages(roomId)
    return Api.Request(
        Api.BaseUrl .. "/chat/messages?room_id=" .. Api.Encode(roomId),
        "GET"
    )
end

function Api.SendRoomMessage(player, roomId, message)
    return Api.Request(
        Api.BaseUrl .. "/chat/send",
        "POST",
        {
            room_id = roomId,
            roblox_user_id = player.UserId,
            username = player.DisplayName,
            message = message
        }
    )
end

return Api