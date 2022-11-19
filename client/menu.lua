local title = "AntiCheat Menu"
local pedid = PlayerId(-1)
local name = GetPlayerName(pedid)
local showblip = false
local showsprite = false
local nameabove = true
local Enabled = true


RegisterNetEvent("AC:adminmenuenabley")
AddEventHandler("AC:adminmenuenabley", function()
	Enabled = false
	showblip = false
	showsprite = false
	nameabove = false
	esp = true
end)

local GH = {}
GH.debug = false

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 2000
	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

local menus = {}
local keys = {up = 172, down = 173, left = 174, right = 175, select = 176, back = 177}
local optionCount = 0

local currentKey = nil
local currentMenu = nil

local menuWidth = 0.21
local titleHeight = 0.10
local titleYOffset = 0.03
local titleScale = 0.9
local buttonHeight = 0.040
local buttonFont = 0
local buttonScale = 0.370
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005
local bytexd = "gatas-AntiCheat"
local function debugPrint(text)
	if GH.debug then
		Citizen.Trace("[GH] "..tostring(text))
	end
end

local function setMenuProperty(id, property, value)
	if id and menus[id] then
		menus[id][property] = value
		debugPrint(id.." menu property changed: { "..tostring(property)..", "..tostring(value).." }")
	end
end

local function isMenuVisible(id)
	if id and menus[id] then
		return menus[id].visible
	else
		return false
	end
end

local function setMenuVisible(id, visible, holdCurrent)
	if id and menus[id] then
		setMenuProperty(id, "visible", visible)
		if not holdCurrent and menus[id] then
			setMenuProperty(id, "currentOption", 1)
		end
		if visible then
			if id ~= currentMenu and isMenuVisible(currentMenu) then
				setMenuVisible(currentMenu, false)
			end
			currentMenu = id
		end
	end
end

local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	if shadow then
		SetTextDropShadow(2, 2, 0, 0, 0)
	end
	if menus[currentMenu] then
		if center then
			SetTextCentre(center)
		elseif alignRight then
			SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
			SetTextRightJustify(true)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

local function drawRect(x, y, width, height, color)
	DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end

local function drawTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight / 2
		if menus[currentMenu].titleBackgroundSprite then
			DrawSprite(
				menus[currentMenu].titleBackgroundSprite.dict,
				menus[currentMenu].titleBackgroundSprite.name,
				x,
				y,
				menuWidth,
				titleHeight,
				0.,
				255,
				255,
				255,
				255
			)
		else
			drawRect(x, y, menuWidth, titleHeight, menus[currentMenu].titleBackgroundColor)
		end
		drawText(
			menus[currentMenu].title,
			x,
			y - titleHeight / 2 + titleYOffset,
			menus[currentMenu].titleFont,
			menus[currentMenu].titleColor,
			titleScale,
			true
		)
	end
end

local function drawSubTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight + buttonHeight / 2
		local subTitleColor = {
			r = menus[currentMenu].titleBackgroundColor.r,
			g = menus[currentMenu].titleBackgroundColor.g,
			b = menus[currentMenu].titleBackgroundColor.b,
			a = 255
		}
		drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
		drawText(
			menus[currentMenu].subTitle,
			menus[currentMenu].x + buttonTextXOffset,
			y - buttonHeight / 2 + buttonTextYOffset,
			buttonFont,
			subTitleColor,
			buttonScale,
			false
		)
		if optionCount > menus[currentMenu].maxOptionCount then
			drawText(
				tostring(menus[currentMenu].currentOption) .. " / " .. tostring(optionCount),
				menus[currentMenu].x + menuWidth,
				y - buttonHeight / 2 + buttonTextYOffset,
				buttonFont,
				subTitleColor,
				buttonScale,
				false,
				false,
				true
			)
		end
	end
end

local function drawButton(text, subText)
	local x = menus[currentMenu].x + menuWidth / 2
	local multiplier = nil
	if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
		multiplier = optionCount
	elseif
		optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and
			optionCount <= menus[currentMenu].currentOption
	 then
		multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
	end
	if multiplier then
		local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false
		if menus[currentMenu].currentOption == optionCount then
			backgroundColor = menus[currentMenu].menuFocusBackgroundColor
			textColor = menus[currentMenu].menuFocusTextColor
			subTextColor = menus[currentMenu].menuFocusTextColor
		else
			backgroundColor = menus[currentMenu].menuBackgroundColor
			textColor = menus[currentMenu].menuTextColor
			subTextColor = menus[currentMenu].menuSubTextColor
			shadow = true
		end
		drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
		drawText(
			text,
			menus[currentMenu].x + buttonTextXOffset,
			y - (buttonHeight / 2) + buttonTextYOffset,
			buttonFont,
			textColor,
			buttonScale,
			false,
			shadow
		)	
		if subText then
			drawText(
				subText,
				menus[currentMenu].x + buttonTextXOffset,
				y - buttonHeight / 2 + buttonTextYOffset,
				buttonFont,
				subTextColor,
				buttonScale,
				false,
				shadow,
				true
			)
		end
	end
end

function GH.CrateMenu(id, title)
	-- Default settings
	menus[id] = {}
	menus[id].title = title
	menus[id].subTitle = bytexd
	menus[id].visible = false
	menus[id].previousMenu = nil
	menus[id].aboutToBeClosed = false
	menus[id].x = 0.75
	menus[id].y = 0.19
	menus[id].currentOption = 1
	menus[id].maxOptionCount = 10
	menus[id].titleFont = 1
	menus[id].titleColor = {r = 255, g = 255, b = 255, a = 255}
	Citizen.CreateThread(
		function()
			while true do
				Citizen.Wait(0)
				local ra = RGBRainbow(1.0)
				menus[id].titleBackgroundColor = {r = ra.r, g = ra.g, b = ra.b, a = 105}
				menus[id].menuFocusBackgroundColor = {r = ra.r, g = ra.g, b = ra.b, a = 100} 
			end
		end)
	menus[id].titleBackgroundSprite = nil
	menus[id].menuTextColor = {r = 255, g = 255, b = 255, a = 255}
	menus[id].menuSubTextColor = {r = 189, g = 189, b = 189, a = 255}
	menus[id].menuFocusTextColor = {r = 255, g = 255, b = 255, a = 255}
	menus[id].menuBackgroundColor = {r = 0, g = 0, b = 0, a = 100}
	menus[id].subTitleBackgroundColor = {
		r = menus[id].menuBackgroundColor.r,
		g = menus[id].menuBackgroundColor.g,
		b = menus[id].menuBackgroundColor.b,
		a = 255
	}
	menus[id].buttonPressedSound = {name = "~h~~r~> ~s~SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}
	debugPrint(tostring(id) .. " menu created")
end

function GH.CreateSubMenu(id, parent, subTitle)
	if menus[parent] then
		GH.CrateMenu(id, menus[parent].title)
		if subTitle then
			setMenuProperty(id, "subTitle", (subTitle))
		else
			setMenuProperty(id, "subTitle", (menus[parent].subTitle))
		end
		setMenuProperty(id, "previousMenu", parent)
		setMenuProperty(id, "x", menus[parent].x)
		setMenuProperty(id, "y", menus[parent].y)
		setMenuProperty(id, "maxOptionCount", menus[parent].maxOptionCount)
		setMenuProperty(id, "titleFont", menus[parent].titleFont)
		setMenuProperty(id, "titleColor", menus[parent].titleColor)
		setMenuProperty(id, "titleBackgroundColor", menus[parent].titleBackgroundColor)
		setMenuProperty(id, "titleBackgroundSprite", menus[parent].titleBackgroundSprite)
		setMenuProperty(id, "menuTextColor", menus[parent].menuTextColor)
		setMenuProperty(id, "menuSubTextColor", menus[parent].menuSubTextColor)
		setMenuProperty(id, "menuFocusTextColor", menus[parent].menuFocusTextColor)
		setMenuProperty(id, "menuFocusBackgroundColor", menus[parent].menuFocusBackgroundColor)
		setMenuProperty(id, "menuBackgroundColor", menus[parent].menuBackgroundColor)
		setMenuProperty(id, "subTitleBackgroundColor", menus[parent].subTitleBackgroundColor)
	else
		debugPrint("Failed to create " .. tostring(id) .. " submenu: " .. tostring(parent) .. " parent menu doesn't exist")
	end
end

function GH.CurrentMenu()
	return currentMenu
end

function GH.OpenMenu(id)
	if id and menus[id] then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		setMenuVisible(id, true)
		if menus[id].titleBackgroundSprite then
			RequestStreamedTextureDict(menus[id].titleBackgroundSprite.dict, false)
			while not HasStreamedTextureDictLoaded(menus[id].titleBackgroundSprite.dict) do
				Citizen.Wait(0)
			end
		end
		debugPrint(tostring(id) .. " menu opened")
	else
		debugPrint("Failed to open "..tostring(id).." menu: it doesn't exist")
	end
end

function GH.IsMenuOpened(id)
	return isMenuVisible(id)
end

function GH.IsAnyMenuOpened()
	for id, _ in pairs(menus) do
		if isMenuVisible(id) then
			return true
		end
	end

	return false
end

function GH.IsMenuAboutToBeClosed()
	if menus[currentMenu] then
		return menus[currentMenu].aboutToBeClosed
	else
		return false
	end
end

function GH.CloseMenu()
	if menus[currentMenu] then
		if menus[currentMenu].aboutToBeClosed then
			menus[currentMenu].aboutToBeClosed = false
			setMenuVisible(currentMenu, false)
			debugPrint(tostring(currentMenu) .. " menu closed")
			PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			optionCount = 0
			currentMenu = nil
			currentKey = nil
		else
			menus[currentMenu].aboutToBeClosed = true
			debugPrint(tostring(currentMenu) .. " menu about to be closed")
		end
	end
end

function GH.Button(text, subText)
	local buttonText = text
	if subText then
		buttonText = "{ " .. tostring(buttonText) .. ", " .. tostring(subText) .. " }"
	end
	if menus[currentMenu] then
		optionCount = optionCount + 1
		local isCurrent = menus[currentMenu].currentOption == optionCount
		drawButton(text, subText)
		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
				debugPrint(buttonText .. " button pressed")
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end
		return false
	else
		debugPrint("Failed to create " .. buttonText .. " button: " .. tostring(currentMenu) .. " menu doesn't exist")
		return false
	end
end

function GH.MenuButton(text, id)
	if menus[id] then
		if GH.Button(text) then
			setMenuVisible(currentMenu, false)
			setMenuVisible(id, true, true)

			return true
		end
	else
		debugPrint("Failed to create " .. tostring(text) .. " menu button: " .. tostring(id) .. " submenu doesn't exist")
	end
	return false
end

function GH.CheckBox(text, bool, callback)
	local checked = "~r~~h~OFF"
	if bool then
		checked = "~g~~h~ON"
	end
	if GH.Button(text, checked) then
		bool = not bool
		debugPrint(tostring(text) .. " checkbox changed to " .. tostring(bool))
		callback(bool)
		return true
	end
	return false
end

function GH.ComboBox(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)
	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end
	if GH.Button(text, selectedItem) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then
				currentIndex = currentIndex - 1
			else
				currentIndex = itemsCount
			end
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then
				currentIndex = currentIndex + 1
			else
				currentIndex = 1
			end
		end
	else
		currentIndex = selectedIndex
	end
	callback(currentIndex, selectedIndex)
	return false
end

function ServerEvent(a,b,c,d,e,f,g,h,i,m)
	TriggerServerEvent(a,b,c,d,e,f,g,h,i,m)
end

function TE(a,b,c,d,e,f,g,h,i,m)
	TriggerEvent(a,b,c,d,e,f,g,h,i,m)
end

function GH.Display()
	if isMenuVisible(currentMenu) then
		if menus[currentMenu].aboutToBeClosed then
			GH.CloseMenu()
		else
			ClearAllHelpMessages()
			drawTitle()
			drawSubTitle()
			currentKey = nil
			if IsDisabledControlJustPressed(0, keys.down) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption < optionCount then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
				else
					menus[currentMenu].currentOption = 1
				end
			elseif IsDisabledControlJustPressed(0, keys.up) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption > 1 then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
				else
					menus[currentMenu].currentOption = optionCount
				end
			elseif IsDisabledControlJustPressed(0, keys.left) then
				currentKey = keys.left
			elseif IsDisabledControlJustPressed(0, keys.right) then
				currentKey = keys.right
			elseif IsDisabledControlJustPressed(0, keys.select) then
				currentKey = keys.select
			elseif IsDisabledControlJustPressed(0, keys.back) then
				if menus[menus[currentMenu].previousMenu] then
					PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					setMenuVisible(menus[currentMenu].previousMenu, true)
				else
					GH.CloseMenu()
				end
			end
			optionCount = 0
		end
	end
end

function GH.SetMenuWidth(id, width)
	setMenuProperty(id, "width", width)
end

function GH.SetMenuX(id, x)
	setMenuProperty(id, "x", x)
end

function GH.SetMenuY(id, y)
	setMenuProperty(id, "y", y)
end

function GH.SetMenuMaxOptionCountOnScreen(id, count)
	setMenuProperty(id, "maxOptionCount", count)
end

function GH.SetTitleColor(id, r, g, b, a)
	setMenuProperty(id, "titleColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleColor.a})
end

function GH.SetTitleBackgroundColor(id, r, g, b, a)
	setMenuProperty(
		id,
		"titleBackgroundColor",
		{["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleBackgroundColor.a}
	)
end

function GH.SetTitleBackgroundSprite(id, textureDict, textureName)
	setMenuProperty(id, "titleBackgroundSprite", {dict = textureDict, name = textureName})
end

function GH.SetSubTitle(id, text)
	setMenuProperty(id, "subTitle", (text))
end


function GH.SetMenuBackgroundColor(id, r, g, b, a)
	setMenuProperty(
		id,
		"menuBackgroundColor",
		{["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuBackgroundColor.a}
	)
end

function GH.SetMenuTextColor(id, r, g, b, a)
	setMenuProperty(id, "menuTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuTextColor.a})
end

function GH.SetMenuSubTextColor(id, r, g, b, a)
	setMenuProperty(id, "menuSubTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuSubTextColor.a})
end

function GH.SetMenuFocusColor(id, r, g, b, a)
	setMenuProperty(id, "menuFocusColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuFocusColor.a})
end

function GH.SetMenuButtonPressedSound(id, name, set)
	setMenuProperty(id, "buttonPressedSound", {["name"] = name, ["set"] = set})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		AddTextEntry("FMMC_KEY_TIP1", "")
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		AddTextEntry("FMMC_KEY_TIP1", "")
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000
	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)
	return result
end

local function notify(text, param)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(param, false)
end

local SpartanIcS = "AceG"
local MenuTitle = title
local sMX = "SelfMenu"
local sMXS = "Self Menu"
local TRPM = "Developer Tools"
local advm = "AdvM"
local VMS = "VehicleMenu"
local OPMS = "OnlinePlayerMenu"
local poms = "PlayerOptionsMenu"
local crds = "Credits"
local MSTC = "MiscTriggers"

local function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.4)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

local function teleporttocoords()
	local pizdax = KeyboardInput("Enter X pos", "", 100)
	local pizday = KeyboardInput("Enter Y pos", "", 100)
	local pizdaz = KeyboardInput("Enter Z pos", "", 100)
	if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
			if	IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
					entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
					entity = GetPlayerPed(-1)
			end
			if entity then
				SetEntityCoords(entity, pizdax + 0.5, pizday + 0.5, pizdaz + 0.5, 1, 0, 0, 1)
				notify("~g~Teleported to coords!", false)
			end
	else
		notify("~b~Invalid coords!", true)
	end
end

local function TeleportToWaypoint()
	if DoesBlipExist(GetFirstBlipInfoId(8)) then
		local blipIterator = GetBlipInfoIdIterator(8)
		local blip = GetFirstBlipInfoId(8, blipIterator)
		WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
		wp = true
	else
		notify("~b~No waypoint!", true)
	end

	local zHeigt = 0.0
	height = 1000.0
	while wp do
		Citizen.Wait(0)
		if wp then
			if IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
				entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
				entity = GetPlayerPed(-1)
			end
			SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
			FreezeEntityPosition(entity, true)
			local Pos = GetEntityCoords(entity, true)

			if zHeigt == 0.0 then
				height = height - 25.0
				SetEntityCoords(entity, Pos.x, Pos.y, height)
				bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
			else
				SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
				FreezeEntityPosition(entity, false)
				wp = false
				height = 1000.0
				zHeigt = 0.0
				notify("~g~Teleported to waypoint!", false)
				break
			end
		end
	end
end

local function repairvehicle()
	SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0)
	SetVehicleLights(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleBurnout(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
	Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleUndriveable(vehicle,false)
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function RequestControl(entity)
	local Waiting = 0
	NetworkRequestControlOfEntity(entity)
	while not NetworkHasControlOfEntity(entity) do
		Waiting = Waiting + 100
		Citizen.Wait(100)
		if Waiting > 5000 then
			notify("Hung for 5 seconds, killing to prevent issues...", true)
		end
	end
end

function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player, Citizen.ReturnResultAnyway())
	return entity
end

RegisterNetEvent("AC:cleanareavehy")
AddEventHandler("AC:cleanareavehy", function()
	for vehicle in EnumerateVehicles() do
		SetEntityAsMissionEntity(GetVehiclePedIsIn(vehicle, true), 1, 1)
		DeleteEntity(GetVehiclePedIsIn(vehicle, true))
	    SetEntityAsMissionEntity(vehicle, 1, 1)
		DeleteEntity(vehicle)
	end
end)

RegisterNetEvent("AC:cleanareapedsy")
AddEventHandler("AC:cleanareapedsy", function()
	PedStatus = 0
	for ped in EnumeratePeds() do
		PedStatus = PedStatus + 1
		if not (IsPedAPlayer(ped))then
			RemoveAllPedWeapons(ped, true)
			DeleteEntity(ped)
		end
	end
end)

RegisterNetEvent("AC:cleanareaentityy")
AddEventHandler("AC:cleanareaentityy", function()
	objst = 0
	for obj in EnumerateObjects() do
		objst = objst + 1
		DeleteEntity(obj)
	end
end)

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

Citizen.CreateThread(function()
	while Enabled do
		Citizen.Wait(0)
		if showCoords then
			x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			roundx = tonumber(string.format("%.2f", x))
			roundy = tonumber(string.format("%.2f", y))
			roundz = tonumber(string.format("%.2f", z))
			DrawTxt("~r~X:~s~ "..roundx, 0.05, 0.00)
			DrawTxt("~r~Y:~s~ "..roundy, 0.11, 0.00)
			DrawTxt("~r~Z:~s~ "..roundz, 0.17, 0.00)
		end
	end
end)

Citizen.CreateThread(function()
	FreezeEntityPosition(entity, false)
	local playerIdxWeapon = 1;
	local showblip = false
	local WeaponTypeSelect = nil
	local WeaponSelected = nil
	local ModSelected = nil
	local currentItemIndex = 1
	local selectedItemIndex = 1
	local powerboost = { 1.0, 2.0, 4.0, 10.0, 512.0, 9999.0 }
	local spawninside = false
	GH.CrateMenu(SpartanIcS, MenuTitle)
	GH.CreateSubMenu(sMX, SpartanIcS, bytexd)
	GH.CreateSubMenu(TRPM, SpartanIcS, bytexd)
	GH.CreateSubMenu(advm, SpartanIcS, bytexd)
	GH.CreateSubMenu(VMS, SpartanIcS, bytexd)
	GH.CreateSubMenu(OPMS, SpartanIcS, bytexd)
	GH.CreateSubMenu(poms, OPMS, bytexd)
	GH.CreateSubMenu(crds, SpartanIcS, bytexd)
	while Enabled do
		if GH.IsMenuOpened(SpartanIcS) then
			ServerEvent('AC:checkup')
			if GH.MenuButton("~h~~p~#~s~ Admin Tools", sMX) then
			elseif GH.MenuButton("~h~~p~#~s~ Teleport Options", TRPM) then
			elseif GH.MenuButton("~h~~p~#~s~ Vehicle Options", VMS) then
			elseif GH.MenuButton("~h~~p~#~s~ Server Settings", advm) then
			end
			GH.Display()
		elseif GH.IsMenuOpened(sMX) then
			if GH.Button("~y~Screenshot") then
				local id = KeyboardInput("Id", "", 3)
				if id ~= nil then
					TriggerServerEvent("screenshot:req", id)
				end
			elseif GH.Button("~h~~b~ClearLoadout") then
				local loadout = KeyboardInput("ID","",3)
				ExecuteCommand('clearloadout '..loadout)
			elseif GH.Button("~h~~b~ClearInventory") then
				local inventory = KeyboardInput("ID","",3)
				ExecuteCommand('clearinventory '..inventory)
			elseif GH.Button("~h~~b~NLR") then
                local nlr = KeyboardInput("ID","",3)
                print(nlr)
				ExecuteCommand('clearloadout '..nlr)
				ExecuteCommand('clearinventory '..nlr)
			end
			GH.Display()
		elseif IsControlJustPressed(0, 178)  then
			ServerEvent('AC:openmenu')
			GH.Display()
		elseif GH.IsMenuOpened(TRPM) then
			if GH.Button("~h~Teleport to ~g~waypoint") then
				TeleportToWaypoint()
			elseif GH.Button("~h~Teleport to ~r~coords") then
				teleporttocoords()
			elseif GH.CheckBox("~h~Show ~g~Coords", showCoords, function (enabled) showCoords = enabled end) then
			end
			GH.Display()
    	elseif GH.IsMenuOpened(VMS) then
    		if GH.Button("~r~SetMe ~w~Driver") then
    			local vehicle = ESX.Game.GetClosestVehicle()
				if IsVehicleSeatFree(vehicle,-1) then
					SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    	    		notify("~g~You are Driving the Closest Car~g~")
    			end
    		elseif GH.Button("~h~~r~Delete ~s~Vehicle") then
				DeleteEntity(GetVehiclePedIsUsing(PlayerPedId(-1)))
			elseif GH.Button("~h~~g~Repair ~s~Vehicle") then
				repairvehicle()
			elseif GH.CheckBox("~h~Vehicle Godmode", VehGod, function(enabled) VehGod = enabled end) then
			end
			GH.Display()
		elseif GH.IsMenuOpened(advm) then
			if GH.Button("Clean Area","~g~Vehicles") then
				TE("AC:cleanareavehy")
			elseif GH.Button("Clean Area","~r~Peds") then
				TE("AC:cleanareapedsy")
			elseif GH.Button("Clean Area","~y~Entity") then
				TE("AC:cleanareaentityy")
			elseif GH.Button("Clean Area","~p~BlackListed Props") then
				notify("~r~Wait while executing..")
				TriggerServerEvent("gatas:prop:ll")
				Wait(10000)
				notify("~r~Executed")
			end
			GH.Display()
    	end
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("AC:openmenuy")
AddEventHandler("AC:openmenuy", function()
	GH.OpenMenu(SpartanIcS)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

RegisterNetEvent("gatas:antiprop")
AddEventHandler("gatas:antiprop", function()
    local ped = PlayerPedId()
    local handle,object = FindFirstObject()
    local finished = false;
	notify("~r~Checking For BlackListed Props")
    repeat;
        Citizen.Wait(1)
        if IsEntityAttached(object) and DoesEntityExist(object) then;
            if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") or GetEntityModel(object) == GetHashKey("prop_weed_pallet") then
                ReqAndDelete(object,true)
            end
        end
        for i=1,#Config.blackObjects do;
            if GetEntityModel(object) == GetHashKey(Config.blackObjects[i]) then;
                Citizen.Wait(1000)
                ReqAndDelete(object,false)
            end
        end
        finished,object = FindNextObject(handle)
    until not finished;
    EndFindObject(handle)
    notify("~r~Deleting BlackListed Objects..")
end)
