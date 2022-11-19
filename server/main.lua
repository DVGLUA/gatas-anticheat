ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
    Config_file = LoadResourceFile(GetCurrentResourceName(), "Config.lua")
    while Config_file == nil do
        Config_file = LoadResourceFile(GetCurrentResourceName(), "Config.lua")
        Wait(100)
    end
    load(Config_file)()
    print("^2[gatas-AntiCheat]-^1Config Loaded Succesfully^0")
end)

CreateThread(function()
    while Config_file == nil do
        Wait(100)
    end
RegisterServerEvent("gatas:ban")
AddEventHandler("gatas:ban", function(reason, ban, kick)
	local _source = source
    local name = GetPlayerName(_source)
    local license = GetPlayerIdentifiers(_source)[2]
    local xPlayer = ESX.GetPlayerFromId(_source)
    local group = xPlayer.getGroup()
    if group == "user" then  -----------Prevent Admins to get Ban here-----------
	    Wait(1000)
        if ban == true then
            Wait(500)
            SqlBan(_source, reason)
            loadBanList()
            sendToDisc("[gatas-AntiCheat]", "**[Player-Banned]**\nName: "..name.."\n"..GetPlayerIdentifiers(_source)[1].."\n Ip: "..GetPlayerEndpoint(_source).."\n"..license.."\nReason: "..reason, "gatas Anti Cheat")
	    	DropPlayer(_source, reason)
	    elseif kick == true and ban == false then
            sendToDisc("[gatas-AntiCheat]", "**[Player-Kicked]**\nName: "..name.."\n"..GetPlayerIdentifiers(_source)[1].."\n Ip: "..GetPlayerEndpoint(_source).."\n"..license.."\nReason: "..reason, "gatas Anti Cheat")
	    	DropPlayer(_source, "[gatas-AntiCheat]-"..reason)
	    else
	    	print("[gatas-AntiCheat]-Ban Event Error")
        end
    end
end)

RegisterServerEvent('Anticheat:Whitelist')                            -------------------------[Add groups if you want]-------------------------
AddEventHandler('Anticheat:Whitelist', function(playerId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local group = xPlayer.getGroup()
	if group == "superadmin" or group == "mod" or group == "admin" then
		TriggerClientEvent('Anticheat:Return', _source, true)
        TriggerClientEvent("Config_", _source, Config_file)
	elseif group == "user" then
		TriggerClientEvent('Anticheat:Return', _source, false)
        TriggerClientEvent("Config_", _source, Config_file)
	end
end)

function sendToDisc(title, message, footer)
    local embed = {}
    embed = {
        {
            ["color"] = math.random(111111,999999), 
            ["title"] = "**".. title .."**",
            ["description"] = "" .. message ..  "",
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }
    PerformHttpRequest(Config.Bans, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, avatar_url = Config.image}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("gatas:log")                         ------------------------------General Logs Coming with player screenshot's------------------------------
AddEventHandler("gatas:log", function(reason)
    local steamID  = "empty"
	local license  = "empty"
	local discord  = "empty"
	local playerip = "empty"
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	local id = source;
    local _source = source
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local job
	if discord == "nil" or discord == "" then
		discord = "No Discord Found"
	end
	if xPlayer ~= nil then
		if xPlayer.job.label == xPlayer.job.grade_label then
			job = xPlayer.job.grade_label
		else
			job = xPlayer.job.label .. ': ' .. xPlayer.job.grade_label
		end
		local info = {
			job = job,
			money = xPlayer.getMoney(),
			bankMoney = xPlayer.getAccount('bank').money,
			blackMoney = xPlayer.getAccount('black_money').money
		}
	end
    local connect = {
        {
            ["color"] = math.random(111111,999999),
            ["title"] = reason,
            ["description"] = "Name: "..GetPlayerName(_source).. " \n "  ..steamID.."\nIP: "..GetPlayerEndpoint(_source).."\nID: "..source.."\nJOB: "..job.."\nPlayer's Money: "..xPlayer.getAccount('bank').money.."\n Player's Black Money:"..xPlayer.getAccount('black_money').money.."\n Gta key: "..license.."",
            ["footer"] = {
            ["text"] = "Screenshot-Logs",
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Limited AC", embeds = connect, avatar_url = Config.image}), { ['Content-Type'] = 'application/json' })  --'Discord Tag: **<@' .. discord:gsub('discord:', '') .. '>**\n'
end)

AddEventHandler('chatMessage', function(source, n, message)
	for k,n in pairs(Config.words) do
		if string.match(message:lower(),n:lower()) then
			sendToDisc('[BLACKLISTED WORD DETECTED]', "Player "..GetPlayerName(source).." sent: "..n.."", "gatas-Anti Cheat")
			DropPlayer(source,"tried to say: "..n,true)
	    end
	end
end)

AddEventHandler('chatMessage', function(source, name, msg)
    local _source = source
    local realname = GetPlayerName(_source)
    local ids = GetPlayerIdentifiers(_source)
    local discord = ids.discord
    local steam = ids.steam
    local gameLicense = ids.license
    if name ~= realname then
        if Config.AntiFakeMessage then
            sendToDisc("[gatas-AntiCheat]", "[Player-Kicked]\nPlayer: "..realname.." tried to say: "..msg.. " under name: "..name.."\n "..GetPlayerIdentifiers(_source)[1], "gatas Anti Cheat")
            DropPlayer(_source, "Fake Message Detected")
        end
    end
end)

if Config.AntiExplosion then
    AddEventHandler("explosionEvent",function()
        CancelEvent()
    end)
end

AddEventHandler("playerConnecting", function(reason)------------ log who doesn't have discord linked with fivem ------------
	local steamID  = "empty"
	local license  = "empty"
	local discord  = "empty"
	local playerip = "empty"
	for k,v in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		end
	end
	if discord == nil or discord == "empty" then
		local reason = "NO DISCORD ALERT"
		local name = GetPlayerName(source)
		local connect = {
            {
                ["color"] = 56719,
                ["title"] = reason,
                ["description"] = "Name: "..name.."\n " ..GetPlayerIdentifiers(source)[1].."",
                ["footer"] = {
                ["text"] = "gatas Is Watching",
                },
            }
        }
		PerformHttpRequest(Config.Bans, function(err, text, headers) end, 'POST', json.encode({username = "gatas AC", embeds = connect, avatar_url = Config.image}), { ['Content-Type'] = 'application/json' })
	end
end)

if Config.AntiCommunity then
    RegisterServerEvent(Config.ComservEvent)
    AddEventHandler(Config.ComservEvent, function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local group = xPlayer.getGroup()
        local job = xPlayer.getJob()
        local ids = ExtractIdentifiers(_source)
        local discord = ids.discord
        if job ~= "police" or group ~= "superadmin" or group ~= "admin" or group ~= "mod" then
            sendToDisc("[Trigger Detected]", "**[Player Banned]**\nTried to send everyone to community service\nName: "..name.."\n"..GetPlayerIdentifiers(_source)[1].."\n Discord : <@"..discord:gsub('discord:', '')..">","gatas Anti Cheat")
            Wait(500)
            DropPlayer(_source, "[gatas-AntiCheat]-Tried to send everyone to community service?!")
            CancelEvent()
        end
    end)
end

if Config.AntiJail then
    RegisterServerEvent(Config.jailevent)
    AddEventHandler(Config.jailevent, function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local group = xPlayer.getGroup()
        local job = xPlayer.getJob()
        local ids = ExtractIdentifiers(_source)
        local discord = ids.discord
        if job ~= "police" or group ~= "superadmin" or group ~= "admin" or group ~= "mod" then
            sendToDisc("[Trigger Detected]", "**[Player Banned]**\nTried to send everyone to jail\nName: "..name.."\n"..GetPlayerIdentifiers(_source)[1].."\n Discord : <@"..discord:gsub('discord:', '')..">","gatas Anti Cheat")
            Wait(500)
            DropPlayer(_source, "[gatas-AntiCheat]-Tried to send everyone to jail ?!")
            CancelEvent()
        end
    end)
end

RegisterServerEvent("AC:openmenu")
AddEventHandler("AC:openmenu", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local group = xPlayer.getGroup()
    if xPlayer ~= nil then
        for g, gr in pairs(Config.menugroups) do
            if gr == group then
                TriggerClientEvent("AC:openmenuy", _source)
            end
        end
    end
end)

RegisterServerEvent("screenshot:req")
AddEventHandler("screenshot:req", function(target)
    local _source = source
    local admin = GetPlayerName(_source)
    local user = GetPlayerName(target)
    local discord = GetPlayerIdentifiers(target)[3]
    if target ~= nil then
        sendToDisc("[Screenshot Request]", "Admin: "..admin.. " Requsted Screenshot for Player: "..user.."\n Name: "..user.."\n"..GetPlayerIdentifiers(target)[1].."\nIp: "..GetPlayerEndpoint(target).."\nDiscord: <@"..discord:gsub("discord:", "")..">", "gatas Anti Cheat")
        TriggerClientEvent("screen", target)
        TriggerClientEvent("esx:showNotification", _source, "~g~Check Screenshot-Logs")
    else
        TriggerClientEvent("esx:showNotification", _source,"~r~Wrong ID" )
    end
end)

for i=1, #Config.BlacklistedEvents, 1 do
	RegisterServerEvent(Config.BlacklistedEvents[i])
	AddEventHandler(Config.BlacklistedEvents[i], function()
		local id = source;
		local ids = ExtractIdentifiers(id)
		local steam = ids.steam
		local License = ids.license
		local discord = ids.discord
		if Config.AntiBlacklistedEvent then
			sendToDisc("Hacker Banned [Tried executing Event: "..Config.BlacklistedEvents[i].."]:[ID: "..source.."]\n Cheater's Name: "..GetPlayerName(id).."",'Steam: **'..steam..'**\n'..'License: **'..License..'**\n'..'Discord Tag: **<@'..discord:gsub('discord:', '')..'>**\n');
			SqlBan(id, reason)
  			Wait(1000)
			loadBanList()
			DropPlayer(id, "[BANNED]-[gatas-AntiCheat]-Triggered Event:"..Config.BlacklistedEvents[i].."")
		else
			print("BlackListed Event Triggered But AntiCheat Is Setted To Ignore Them!")
		end
	end)
end

RegisterServerEvent("gatas:prop:ll")
AddEventHandler("gatas:prop:ll", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local group = xPlayer.getGroup()
    if group ~= "user" then
        TriggerClientEvent("gatas:antiprop", -1)
    else
        DropPlayer("Tried to Trigger BlackListed Event")
    end
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end

CreateThread(function()
    Wait(3000)
    for resource, b in pairs(Config.ResourcesToCheck) do
        if GetResourceState(b) == "started" then
            print("^2[gatas-AntiCheat]-^3Resource "..b.." is running^0")
        else
            print("^2[gatas-AntiCheat]-^1Resource "..b.." is not running^0")
            Wait(1000)
            StartResource(b)
            print("^2[gatas-AntiCheat]-^3Trying to start "..b.."^0")
            if GetResourceState(b) == "started" then
                print("^2[gatas-AntiCheat]-^3Resource "..b.." started^0")
            else
                print("^2[gatas-AntiCheat]-^1Resource "..b.." failed to start^0")
            end
        end
    end
end)

AddEventHandler("playerConnecting", function(name, setKickReason)   ------------------------Prevent Skids who want to troll in your Server------------------------
    local _source = source
    local identifiers = GetPlayerIdentifiers(_source)
    if string.find(name, "<script src") then
        sendToDisc("[gatas-AntiCheat]", "Player tried to connect with name: "..name.."\n"..GetPlayerIdentifiers(_source)[1].."\nIp: "..GetPlayerEndpoint(_source), "gatas Anti Cheat")
        setKickReason('[gatas-AntiCheat]-Unauthorized name')
        CancelEvent()
    end
end)
end)