local WebHook = ''

RegisterCommand('feedback', function(source, args, msg)
    local name = GetPlayerName(source)
    local identifier	= GetPlayerIdentifiers(source)[1]
    local message       = msg
    sendToDiscord(16753920, "Feedback sent by : "..name, "Message : "..message, "Identifier: "..identifier)
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