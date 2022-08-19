_G.discordia = require("discordia")
_G.client = discordia.Client()
discordia.extensions()
_G.spawn = require("coro-spawn")
_G.split = require("coro-split")
_G.parse = require("url").parse
_G.settings = require("settings")
_G.functions = require("functions")
_G.queue = {}

client:on(
    "ready",
    function()
        print("Logado com sucesso")
    end
)

client:on(
    "messageCreate",
    function(message)
        if message.author.bot or message.author == client.user then
            return
        end
        local args = message.content:split(" ")

        if args[1] == settings.Prefix .. "tocar" then
            local author = message.guild:getMember(message.author.id)
            local vc
            if not author.voiceChannel and not client.user.voiceChannel then
                functions.reply("Entre em um canal de voz.", message)
            elseif client.user.voiceChannel then
                vc = client.user.voiceChannel
            else
                table.remove(args, 1)
                local vid = table.concat(args, " ")
                vc = author.voiceChannel
                _G.connection = vc:join()
                local youtubeEmbed =
                    message.channel:send {
                    embed = {
                        fields = {
                            {name = "Por favor espere...", value = "Isso pode demorar alguns segundos.", inline = true}
                        },
                        title = "Baixando musica",
                    },
                    reference = {
                        message = message,
                        mention = false
                    }
                }
                _G.stream = functions.getYoutube(vid)
                coroutine.wrap(
                    function()
                        connection:playFFmpeg(stream)
                    end
                )()
            end
        elseif args[1] == settings.Prefix .. "sair" then
            connection:stopStream()
            connection:close()
        end
    end
)

client:run("Bot " .. settings.Token)