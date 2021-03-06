local mt = minetest

local http = assert(mt.request_http_api(), "http API is unaviable")

local url = "https://discord.com/api/webhooks/"..
assert(mt.settings:get('dwh.id'), "Webhook id has not been set").."/"..
assert(mt.settings:get('dwh.token'), "Webhook token has not been set")

local header = {"Content-Type: application/json", "Accept-Charset: utf-8"}

function send_message(msg, nameoverride)
    local req = {
        url = url, --yeah lua
        method = "POST",
        data = mt.write_json({
            username = nameoverride,
            content = msg
        }),
        extra_headers = header
    }
    http.fetch(req, response_handler)
end

function response_handler(resp)
    if resp.code >= 400
    then mt.log("error", "http error:"..resp.code)
    end
end

--Repports
if mt.settings:get_bool('dwh.joinplayer', true) then
    mt.register_on_joinplayer(function (plr)
        send_message(":arrow_right: "..plr:get_player_name().." connected")
    end)
end

if mt.settings:get_bool('dwh.leaveplayer', true) then
    mt.register_on_leaveplayer(function (plr)
        send_message(":arrow_left: "..plr:get_player_name().." disconnected")
    end)
end

if mt.settings:get_bool('dwh.newplayer', true) then
    mt.register_on_newplayer(function (plr)
        send_message(":new: "..plr:get_player_name().." has joined the server for the first time")
    end)
end

if mt.settings:get_bool('dwh.authfail', false) then
    mt.register_on_auth_fail(function (name)
        send_message(":passport_control: "..name.." tried to connect with the wrong password")
    end)
end

if mt.settings:get_bool('dwh.serverstart', false) then
    send_message(":up: Server is online")
end

if mt.settings:get_bool('dwh.servershutdown', false) then
    mt.register_on_shutdown(function ()
        send_message(":stop_sign: Server is shutting down")
    end)
end

--Command and relay
local imper = mt.settings:get_bool('dwh.impersonate', true)

local function send_message_from(msg, name)
    if imper then
        send_message(msg, name)
    else
        send_message('<'..name..'> ' .. msg)
    end
end

if mt.settings:get_bool('dwh.dwhcommand', true) then
    mt.register_chatcommand("dwh", {
        params = "<message>",
        description = "Send a message to discord",
        privs = {shout = true},
        func = function(name, param)
            if #param == 0 then return false end
            send_message_from(param, name)
            return true, "Message sent..."
        end
    })
end

if mt.settings:get_bool('dwh.chatrelay', false) then
    mt.register_on_chat_message(function(name, message)
        if #message == 0 then return end
        send_message_from(message, name)
    end)
end

if mt.settings:get_bool('dwh.merelay', false) then
    mt.register_on_chatcommand(function(name, command, params)
        if command ~= "me" or #params == 0 then return end
        if imper then
            send_message('*'..params..'*', name)
        else
            send_message("* "..name..' '..params)
        end
    end)
end