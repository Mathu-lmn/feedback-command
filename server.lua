local cooldowns = {}
-- Put your WebHook URL here
local WebHook = ''

RegisterCommand('feedback', function(source, args, message)
    local name = GetPlayerName(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    -- remove the first word from the message string as it is the command 'feedback'
    local message = table.concat(args, ' ', 1)
    -- if the message is empty, return the usage message
    if message == '' then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Feedback", "^7Usage: ^1/feedback <message>"}
          })     
        return
    end
    if not cooldowns[source] or ((os.clock() - cooldowns[source]) > 3600) then
        cooldowns[source] = os.clock()

        sendToDiscord(16753920, "Feedback sent by : "..name, "Content : "..message, "Identifier: "..identifier)
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Feedback", "^7You sent your feedback to the server."}
          })
    -- If the player already sent a feedback in the last hour, don't send another one and notify him.
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Feedback", "^7You can only send one feedback every hour."}
          })
    end
end)

function sendToDiscord(color, name, message, footer)
    local embed = {
        {
            ['color']       = color,
            ['title']       = '**'..name..'**',
            ['description'] = message,
            ['footer']      = {
                ['text']    = footer,
            },
        }
    }
    PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end