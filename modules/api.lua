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

function Api.CreateRoom(player, displayName, isPrivate, password)
    return Api.Request(
        Api.BaseUrl .. "/rooms/create?owner_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            display_name = displayName,
            is_private = isPrivate,
            password = password
        }
    )
end

function Api.GetPublicRooms()
    return Api.Request(Api.BaseUrl .. "/rooms/public", "GET")
end

function Api.GetPrivateRooms()
    return Api.Request(Api.BaseUrl .. "/rooms/private", "GET")
end

function Api.JoinRoom(player, roomId, password)
    return Api.Request(
        Api.BaseUrl ..
        "/rooms/join" ..
        "?room_id=" .. Api.Encode(roomId) ..
        "&roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            password = password
        }
    )
end

function Api.LeaveRoom(player, roomId)
    return Api.Request(
        Api.BaseUrl ..
        "/rooms/leave" ..
        "?room_id=" .. Api.Encode(roomId) ..
        "&roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

function Api.GetRoomMembers(roomId)
    return Api.Request(
        Api.BaseUrl .. "/rooms/members?room_id=" .. Api.Encode(roomId),
        "GET"
    )
end

function Api.LeaveAnyRoom(player)
    return Api.Request(
        Api.BaseUrl ..
        "/rooms/leave-any" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

function Api.GetClans()
    return Api.Request(
        Api.BaseUrl .. "/clans",
        "GET"
    )
end

function Api.GetAdminNotices()
    return Api.Request(
        Api.BaseUrl .. "/admin-notices?platform=external",
        "GET"
    )
end


function Api.GetPublicProfile(robloxUserId)
    return Api.Request(
        Api.BaseUrl ..
        "/user-profiles/public" ..
        "?roblox_user_id=" .. Api.Encode(robloxUserId),
        "GET"
    )
end


function Api.GetMyInventory(player)
    return Api.Request(
        Api.BaseUrl ..
        "/inventory/my-items" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.GetLimitedRewardStock()
    return Api.Request(
        Api.BaseUrl .. "/shop/limited-stock",
        "GET"
    )
end


function Api.BuyShopItem(player, itemId)
    return Api.Request(
        Api.BaseUrl ..
        "/shop/buy" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&item_id=" .. Api.Encode(itemId),
        "POST"
    )
end


function Api.ClaimReward(
    player,
    code
)
    return Api.Request(
        Api.BaseUrl ..
        "/shop/redeems/claim" ..
        "?code=" .. Api.Encode(code) ..
        "&roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

return Api
