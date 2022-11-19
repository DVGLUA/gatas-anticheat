AntiCheat = { }

AntiCheat.Lang              = 'en'
AntiCheat.permission        = "admin" 
AntiCheat.MultiServerSync   = false   

AntiCheat.EnableDiscordLink = false 
AntiCheat.webhookban        = ""  -- You don't need them
AntiCheat.webhookunban      = ""  -- You don't need them
AntiCheat.green             = 56108
AntiCheat.grey              = 8421504
AntiCheat.red               = 16711680
AntiCheat.orange            = 16744192
AntiCheat.blue              = 2061822
AntiCheat.purple            = 11750815

AntiCheat.TextEn = {
	start         = "^2[gatas-AntiCheat]-^3The BanList and history has been loaded successfully.^0",
	starterror    = "ERROR: The BanList and history has not been loaded new try.",
	banlistloaded = "^2[gatas-AntiCheat]-^1The BanList has been loaded successfully.^0",
	historyloaded = "^2[gatas-AntiCheat]-^1The BanListHistory has been loaded successfully.^0",
	loaderror     = "ERROR: The BanList was not loaded.",
	forcontinu    = " days. To continue entering /sqlreason (Ban reason)",
	noreason      = "unknown reason",
	during        = " during : ",
	noresult      = "There are not as many results!",
	isban         = " was ban",
	isunban       = " was unban",
	invalidsteam  =  "You should open steam",
	invalidid     = "Player ID incorrect",
	invalidname   = "The name is not valid",
	invalidtime   = "Bad ban duration",
	yourban       = "You have been ban for : ",
	yourpermban   = "You have been ban from AntiCheat for : ",
	youban        = "You have ban : ",
	forr          = " days. For : ",
	permban       = " permanently for : ",
	timeleft      = ". Time remains : ",
	toomanyresult = "Too many results, be sure to be more precise.",
	day           = " Days ",
	hour          = " Hours ",
	minute        = " Minutes ",
	by            = "by",
	ban           = "Ban one online player",
	banoff        = "Ban one offline player",
	dayhelp       = "Number of day",
	reason        = "Reason of ban",
	history       = "Show all ban of a player",
	reload        = "Reload BanList and BanListHistory",
	unban         = "Remove one ban from the list",
	steamname     = "(Steam Name)",
}

local Text               = {}
local lastduree          = ""
local lasttarget         = ""
local BanList            = {}
local BanListLoad        = false
local BanListHistory     = {}
local BanListHistoryLoad = false

if AntiCheat.Lang == "en" then 
	Text = AntiCheat.TextEn
elseif AntiCheat.Lang == "fr" then 
	Text = AntiCheat.TextEn 
else 
	print("FIveM-BanSql : Invalid AntiCheat.Lang") 
end

CreateThread(function()
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				print(Text.banlistloaded)
				BanListLoad = true
			else
				print(Text.starterror)
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				print(Text.historyloaded)
				BanListHistoryLoad = true
			else
				print(Text.starterror)
			end
		end
	end
end)

CreateThread(function()
	while AntiCheat.MultiServerSync do
		Wait(30000)
		MySQL.Async.fetchAll(
		'SELECT * FROM acbanlist',{},
		function (data)
			if #data ~= #BanList then
			  BanList = {}

			  for i=1, #data, 1 do
				table.insert(BanList, {
					identifier = data[i].identifier,
					license    = data[i].license,
					liveid     = data[i].liveid,
					xblid      = data[i].xblid,
					discord    = data[i].discord,
					playerip   = data[i].playerip,
					reason     = data[i].reason,
					added      = data[i].added,
					expiration = data[i].expiration,
					permanent  = data[i].permanent
				  })
			  end
			loadBanListHistory()
			end
		end
		)
	end
end)

TriggerEvent('es:addGroupCommand', 'databasereload', AntiCheat.permission, function (source)
  BanListLoad        = false
  BanListHistoryLoad = false
  Wait(5000)
  if BanListLoad == true then
	TriggerEvent('bansql:sendMessage', source, Text.banlistloaded)
	if BanListHistoryLoad == true then
		TriggerEvent('bansql:sendMessage', source, Text.historyloaded)
	end
  else
	TriggerEvent('bansql:sendMessage', source, Text.loaderror)
  end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.reload})

TriggerEvent('es:addGroupCommand', 'acsqlbanhistory', AntiCheat.permission, function (source, args, user)
 if args[1] and BanListHistory then
	local nombre = (tonumber(args[1]))
	local name   = table.concat(args, " ",1)
	if name ~= "" then
		if nombre and nombre > 0 then
			local expiration = BanListHistory[nombre].expiration
			local timeat     = BanListHistory[nombre].timeat
			local calcul1    = expiration - timeat
			local calcul2    = calcul1 / 86400
			local calcul2 	 = math.ceil(calcul2)
			local resultat   = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)
			TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
		else
			for i = 1, #BanListHistory, 1 do
				if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
					local expiration = BanListHistory[i].expiration
					local timeat     = BanListHistory[i].timeat
					local calcul1    = expiration - timeat
					local calcul2    = calcul1 / 86400
					local calcul2 	 = math.ceil(calcul2)					
					local resultat   = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)
					TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
				end
			end
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.invalidname)
	end
  else
	TriggerEvent('bansql:sendMessage', source, Text.cmdhistory)
  end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.history, params = {{name = "name", help = Text.steamname}, }})

TriggerEvent('es:addGroupCommand', 'acunban', AntiCheat.permission, function (source, args, user)
  if args[1] then
    local target = table.concat(args, " ")
	MySQL.Async.fetchAll('SELECT * FROM acbanlist WHERE targetplayername like @playername', 
	{
		['@playername'] = ("%"..target.."%")
	}, function(data)
		if data[1] then
			if #data > 1 then
				TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
				for i=1, #data, 1 do
					TriggerEvent('bansql:sendMessage', source, data[i].targetplayername)
				end
			else
				MySQL.Async.execute(
				'DELETE FROM acbanlist WHERE targetplayername = @name',
				{
				  ['@name']  = data[1].targetplayername
				},
					function ()
					loadBanList()
					if AntiCheat.EnableDiscordLink then
						local sourceplayername = GetPlayerName(source)
						local message = (data[1].targetplayername .. Text.isunban .." ".. Text.by .." ".. sourceplayername)
						sendToDiscord(AntiCheat.webhookunban, "BanSql", message, AntiCheat.green)
					end
					TriggerEvent('bansql:sendMessage', source, data[1].targetplayername .. Text.isunban)
				end)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
		end

    end)
  else
	TriggerEvent('bansql:sendMessage', source, Text.cmdunban)
  end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.unban, params = {{name = "name", help = Text.steamname}}})

TriggerEvent('es:addGroupCommand', 'acban', AntiCheat.permission, function (source, args, user)
	local identifier
	local license
	local liveid    = "no info"
	local xblid     = "no info"
	local discord   = "no info"
	local playerip
	local target    = tonumber(args[1])
	local duree     = tonumber(args[2])
	local reason    = table.concat(args, " ",3)
	local permanent = 0

	if args[1] then		
		if reason == "" then
			reason = Text.noreason
		end
		if target and target > 0 then
			local ping = GetPlayerPing(target)
        
			if ping and ping > 0 then
				if duree and duree < 365 then
					local sourceplayername = GetPlayerName(source)
					local targetplayername = GetPlayerName(target)
						for k,v in ipairs(GetPlayerIdentifiers(target))do
							if string.sub(v, 1, string.len("steam:")) == "steam:" then
								identifier = v
							elseif string.sub(v, 1, string.len("license:")) == "license:" then
								license = v
							elseif string.sub(v, 1, string.len("live:")) == "live:" then
								liveid = v
							elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
								xblid  = v
							elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
								discord = v
							elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
								playerip = v
							end
						end
				
					if duree > 0 then
						ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
						DropPlayer(target, Text.yourban .. reason)
					else
						local permanent = 1
						ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
						DropPlayer(target, Text.yourpermban .. reason)
					end
				
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
				end	
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidid)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidid)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdban)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.ban, params = {{name = "id"}, {name = "day", help = Text.dayhelp}, {name = "reason", help = Text.reason}}})

TriggerEvent('es:addGroupCommand', 'acbanoffline', AntiCheat.permission, function (source, args, user)
	if args ~= "" then
		lastduree  = tonumber(args[1])
		target     = table.concat(args, " ",2)
		if lastduree ~= "" then
			if target ~= "" then
				MySQL.Async.fetchAll('SELECT * FROM acbaninfo WHERE playername like @playername', 
				{
					['@playername'] = ("%"..target.."%")
				}, function(data)
					if data[1] then
						if #data > 1 then
							TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
							for i=1, #data, 1 do
								TriggerEvent('bansql:sendMessage', source, data[i].playername)
							end
						else
							lasttarget = data[1].playername
							TriggerEvent('bansql:sendMessage', source, (lasttarget .. Text.during .. lastduree .. Text.forcontinu))
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidname)
					end
				end)
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidname)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
			TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.banoff, params = {{name = "day", help = Text.dayhelp}, {name = "name", help = Text.steamname}}})

TriggerEvent('es:addGroupCommand', 'acreason', AntiCheat.permission, function (source, args, user)
	local duree            = lastduree
	local name             = lasttarget
	local reason           = table.concat(args, " ",1)
	local permanent        = 0
	local playerip         = "0.0.0.0"
	local liveid           = "no info"
	local xblid            = "no info"
	local discord          = "no info"
	local sourceplayername = GetPlayerName(source)
	if name ~= "" then
		if duree and duree < 365 then
			if reason == "" then
				reason = Text.noreason
			end
			MySQL.Async.fetchAll('SELECT * FROM acbaninfo WHERE playername = @playername', 
			{
				['@playername'] = name
			}, function(data)

				if data[1] then
					if duree > 0 then
						ban(source,data[1].identifier,data[1].license,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,name,sourceplayername,duree,reason,permanent)
						lastduree  = ""
						lasttarget = ""
					else
						local permanent = 1
						ban(source,data[1].identifier,data[1].license,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,name,sourceplayername,duree,reason,permanent)
						lastduree  = ""
						lasttarget = ""
					end
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidid)
				end
			end)
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
		end	
	else
		TriggerEvent('bansql:sendMessage', source, Text.invalidid)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', 'Insufficient Permissions.' } })
end, {help = Text.banoff, params = {{name = "reason", help = Text.reason}}})

-- console / rcon can also utilize es:command events, but breaks since the source isn't a connected player, ending up in error messages
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist ', message } } )
	else
		print('SqlBan: '..message)
	end
end)

function sendToDiscord (canal, name, message, color)
	local DiscordWebHook = canal
	local embeds = {
	    {
	        ["title"]= message,
	        ["type"]= "rich",
	        ["color"] = color,
	        ["footer"]=  {
	        ["text"]= "BanSql_logs",
	       },
	    }
	}
	if message == nil or message == '' then 
		return FALSE 
	end 
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
--calcul total expiration (en secondes)
	local expiration = duree * 86400
	local timeat     = os.time()
	local added      = os.date()
	local message
	if expiration < os.time() then
		expiration = os.time()+expiration
	end
		table.insert(BanList, {
			identifier = identifier,
			license    = license,
			liveid     = liveid,
			xblid      = xblid,
			discord    = discord,
			playerip   = playerip,
			reason     = reason,
			expiration = expiration,
			permanent  = permanent
          })
		MySQL.Async.execute(
            'INSERT INTO acbanlist (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
            { 
			['@identifier']       = identifier,
			['@license']          = license,
			['@liveid']           = liveid,
			['@xblid']            = xblid,
			['@discord']          = discord,
			['@playerip']         = playerip,
			['@targetplayername'] = targetplayername,
			['@sourceplayername'] = sourceplayername,
			['@reason']           = reason,
			['@expiration']       = expiration,
			['@timeat']           = timeat,
			['@permanent']        = permanent,
			},
			function ()
		end)
		if permanent == 0 then
			TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
			message = (identifier .." ".. license .." ".. liveid .." ".. xblid .." ".. discord .." ".. playerip .." ".. targetplayername .. Text.isban .." ".. duree .. Text.forr .. reason .." ".. Text.by .." ".. sourceplayername)
		else
			TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.permban .. reason))
			message = (identifier .." ".. license .." ".. liveid .." ".. xblid .." ".. discord .." ".. playerip .." ".. targetplayername .. Text.isban .." ".. Text.permban .. reason .." ".. Text.by .." ".. sourceplayername)
		end
		if AntiCheat.EnableDiscordLink then
			sendToDiscord(AntiCheat.webhookban, "BanSql", message, AntiCheat.red)
		end
		MySQL.Async.execute(
                'INSERT INTO acbanlisthistory (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@added']            = added,
				['@expiration']       = expiration,
				['@timeat']           = timeat,
				['@permanent']        = permanent,
				},
				function ()
		end)
	BanListHistoryLoad = false
end

function loadBanList()
	MySQL.Async.fetchAll(
		'SELECT * FROM acbanlist',
		{},
		function (data)
		  BanList = {}
		  for i=1, #data, 1 do
			table.insert(BanList, {
				identifier = data[i].identifier,
				license    = data[i].license,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				expiration = data[i].expiration,
				permanent  = data[i].permanent
			  })
		  end
    end)
end

function loadBanListHistory()
	MySQL.Async.fetchAll(
		'SELECT * FROM acbanlisthistory',
		{},
		function (data)
		  BanListHistory = {}

		  for i=1, #data, 1 do
			table.insert(BanListHistory, {
				identifier       = data[i].identifier,
				license          = data[i].license,
				liveid           = data[i].liveid,
				xblid            = data[i].xblid,
				discord          = data[i].discord,
				playerip         = data[i].playerip,
				targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
				reason           = data[i].reason,
				added            = data[i].added,
				expiration       = data[i].expiration,
				permanent        = data[i].permanent,
				timeat           = data[i].timeat
			  })
		  end
    end)
end

function deletebanned(identifier) 
	MySQL.Async.execute(
		'DELETE FROM acbanlist WHERE identifier=@identifier',
		{
		  ['@identifier']  = identifier
		},
		function ()
			loadBanList()
	end)
end

AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local steamID  = "empty"
	local license  = "empty"
	local liveid   = "empty"
	local xblid    = "empty"
	local discord  = "empty"
	local playerip = "empty"
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	--Si Banlist pas chargée
	if (BanList == {}) then
		Citizen.Wait(1000)
	end
    if steamID == false then
		setKickReason(Text.invalidsteam)
		CancelEvent()
    end
	for i = 1, #BanList, 1 do
		if 
			((tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord) 
			or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		then
			if (tonumber(BanList[i].permanent)) == 1 then
				setKickReason(Text.yourpermban .. BanList[i].reason)
				CancelEvent()
				break
			elseif (tonumber(BanList[i].expiration)) > os.time() then
				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				end
			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then
				deletebanned(steamID)
				break
			end
		end
	end
end)
AddEventHandler('es:playerLoaded',function(source)
  CreateThread(function()
  Wait(5000)
	local steamID  = "no info"
	local license  = "no info"
	local liveid   = "no info"
	local xblid    = "no info"
	local discord  = "no info"
	local playerip = "no info"
	local playername = GetPlayerName(source)
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
		MySQL.Async.fetchAll('SELECT * FROM `acbaninfo` WHERE `identifier` = @identifier', {
			['@identifier'] = steamID
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].identifier == steamID then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO acbaninfo (identifier,license,liveid,xblid,discord,playerip,playername) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@playername)', 
					{ 
					['@identifier'] = steamID,
					['@license']    = license,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `acbaninfo` SET `license` = @license, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `identifier` = @identifier', 
					{ 
					['@identifier'] = steamID,
					['@license']    = license,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			end
		end)
  	end)
end)

_G.SqlBan = function(target, reason)
    local _source = source
    local identifier    = nil
    local license       = nil
    local playerip      = nil
    local playerdiscord = nil
    local liveid        = nil
    local xbl           = nil
	local sourceplayername = "AntiCheat"
	local targetplayername = GetPlayerName(target)
	local permanent = 1
	local duree = 9999999999
    local timeat     = os.time()
    for k,v in pairs(GetPlayerIdentifiers(target))do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        identifier = v
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        license = v
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        xblid  = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        playerip = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        discord = v
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        liveid = v
      end
    end
    if playerip == nil then
      playerip = GetPlayerEndpoint(target)
      if playerip == nil then
        playerip = 'not found'
      end
    end
    if discord == nil then
      discord = 'not found'
    end
    if liveid == nil then
      liveid = 'not found'
    end
    if xblid == nil then
		xblid = 'not found'
    end
    table.insert(BanList, {
        identifier = identifier,
        license    = license,
        liveid     = liveid,
        xblid      = xblid,
        discord    = discord,
        playerip   = playerip,
        reason     = reason,
        expiration = expiration,
        permanent  = permanent
	})
	ban(target,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
end
