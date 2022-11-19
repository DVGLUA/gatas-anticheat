_G._inject = function(peee)
    print("[gatas-AntiCheat]-"..peee)
end

whiteCheck = true
PedStatus = 0
whitelisted = false

ESX = nil;
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

CreateThread(function()
    while whiteCheck == true do
        if ESX.IsPlayerLoaded(PlayerId) then;
            Wait(2000)
            TriggerServerEvent('Anticheat:Whitelist', GetPlayerServerId(PlayerId()))
            whiteCheck = false
        end 
        Wait(10000)
    end 
end)

RegisterNetEvent("Config_")
AddEventHandler("Config_", function(Conf)
    if Conf ~= nil then
        load(Conf)()
    end
    if Config ~= nil then
        _inject("Config Loaded")
    else
        _inject("Config failed to Load")
    end
end)

RegisterNetEvent('Anticheat:Return')
AddEventHandler('Anticheat:Return', function(wlstatus)
    whitelisted = wlstatus
    if whitelisted == true then 
        _inject('whitelisted.')
    else
        _inject('not whitelisted')
    end
end)

CreateThread(function()
    while Config == nil do
        Wait(100)
    end
if Config.Screenshots then
    CreateThread(function()
        while true do
            local sleep = false
            Wait(1)
            if Config.insert then
                if IsControlJustPressed(0, 121) and not whitelisted then 
                    TriggerServerEvent("gatas:log", "[INSERT PRESSED]-Resources Loaded:"..GetNumResources().."")
                    Citizen.Wait(1000)
                    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, "files[]", function(data)
                    end)
                    Citizen.Wait(2000)
                    local sleep = true
                end
            end
            if Config.F10 then
                if IsControlJustPressed(0, 57) and not whitelisted then
                    TriggerServerEvent("gatas:log", "[F10 PRESSED]-Resources Loaded:"..GetNumResources().."")
                    Citizen.Wait(1000)
                    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, "files[]", function(data)
                    end)
                    Citizen.Wait(2000)
                    local sleep = true
                end
            end
            if Config.EnterKey then
                if IsControlJustPressed(0, 191) and not whitelisted then 
                    TriggerServerEvent("gatas:log", "[ENTER PRESSED]-Resources Loaded:"..GetNumResources().."")
                    Citizen.Wait(1000)
                    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, "files[]", function(data)end)
                    Citizen.Wait(2000)
                    local sleep = true
                end
            end
            if Config.F11 then
                if IsControlJustReleased(0, 344) and not whitelisted then 
                    TriggerServerEvent("gatas:log","[F11 PRESSED]-Resources Loaded:"..GetNumResources().."")
                    Citizen.Wait(2000)
                    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, "files[]", function(data)end)
                    Citizen.Wait(1000)
                    local sleep = true
                end
            end
            if Config.F9 then
                if IsControlJustReleased(0, 56) and not whitelisted then 
                    TriggerServerEvent("gatas:log","[F9 PRESSED]-Resources Loaded:"..GetNumResources().."")
                    Citizen.Wait(1000)
                    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, "files[]", function(data)end)
                    Citizen.Wait(2000)
                    local sleep = true
                end
            end
            if Config.F8 then
                if IsControlJustReleased(0, 169) and not whitelisted then
                    TriggerServerEvent("gatas:log","[F8 PRESSED]-Resources Loaded:"..GetNumResources().."")
                    Citizen.Wait(1000)
                    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, "files[]", function(data)end)
                    Citizen.Wait(2000)
                    local sleep = true
                end
            end
        end
        if sleep == true then
            Wait(15000)
        end 
    end)
end

Citizen.CreateThread(function()
    while true do;
        Citizen.Wait(15000)
        if Config.Godmode then;
            local curPed = PlayerPedId()
            local curHealth = GetEntityHealth(curPed)
            SetEntityHealth(curPed, curHealth-2)
            local curWait = math.random(10,150)
            Citizen.Wait(curWait)
            if not IsPlayerDead(PlayerId()) then;
                if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then;
                    TriggerServerEvent("gatas:ban", "[Godmode found]", true, true)
                elseif GetEntityHealth(curPed) == curHealth-2 then;
                    SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
                end
                if GetEntityHealth(PlayerPedId()) > 200 then;
                    TriggerServerEvent("gatas:ban", "[Health Over 200hp]", true, true)
                end
                if GetPedArmour(PlayerPedId()) < 200 then;
                    Wait(50)
                    if GetPedArmour(PlayerPedId()) == 200 then;
                        TriggerServerEvent("gatas:ban", "[Armour Over 200hp]", true, true)
                    end
                end
            end
        end
        if Config.damageMultiplierCheck then
            if GetPlayerWeaponDamageModifier(PlayerId()) > 1.0 then;
                TriggerServerEvent('gatas:ban', '[Damage Multiplier]-('..GetPlayerWeaponDamageModifier(PlayerId())..')', true, true)
            end
        end
    end
end)

if Config.SuperJump then
    _Wait(810)
     if IsPedJumping(PlayerPedId()) then
         TriggerServerEvent('8jWpZudyvjkDXQ2RVXf9', "superjump")
     end

     AddEventHandler("onClientResourceStop", function(resourceName)
        local _src = source
        kickorbancheater(_src,"Stop Resource Detected", "This Player tried to stop resource: "..resourceName,true,true)
    end)
    
    AddEventHandler('onResourceStop', function(resourceName)
        local _src = source
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        kickorbancheater(_src,"Stop Resource Detected", "This Player tried to stop resource: "..resourceName,true,true)
    end)

    
    RegisterNetEvent("gatas:DeleteEntity")
AddEventHandler('gatas:DeleteEntity', function(Entity)
    local object = NetworkGetEntityFromNetworkId(Entity)
        if DoesEntityExist(object) then
            DeleteObject(object)
        end   
end)

if Config.BlacklistedWeapon then
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(10000)
            for _,theWeapon in ipairs(Config.BlacklistedWeapons) do 
                Wait(3000)
                if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 and not whitelisted then
                    RemoveAllPedWeapons(PlayerPedId(),false)
                    TriggerServerEvent("gatas:ban", "[BlackListed Weapon Found]-Weapon:"..theWeapon..".(Player Banned)", true, true)
                end
            end
        end
    end)
end

if Config.AntiFreeCam then
    if not IsPedInAnyVehicle(_ped) or IsPedInAnyTaxi(_ped) or IsPedInAnyPoliceVehicle(_ped) or IsPedOnAnyBike(_ped) or IsPedInAnyBoat(_ped) or IsPedInAnyHeli(_ped) or IsPedInAnyPlane(_ped) then
        local camcoords = (GetEntityCoords(_ped) - GetFinalRenderedCamCoord())
        if (camcoords.x > 9) or (camcoords.y > 9) or (camcoords.z > 9) or (camcoords.x < -9) or (camcoords.y < -9) or (camcoords.z < -9) then
            TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "freecam") 
        end
    end
    _Wait(300)
end

if Config.AntiMenyoo then
    if IsPlayerCamControlDisabled() ~= false then
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "menyoo") 
    end
    _Wait(300)
end



RegisterNetEvent("screen")
AddEventHandler("screen", function()
    exports['screenshot-basic']:requestScreenshotUpload(Config.Bans, "files[]", function(data)
    end)
end)

AddEventHandler("playerSpawned",function(info)
    Citizen.Wait(5000)
    if not whitelisted then
        _inject("Client Side AntiCheat Is Running")
        TriggerServerEvent("gatas:log", "[Player Spawned]--Resources Number:"..GetNumResources().."")
        exports['screenshot-basic']:requestScreenshotUpload(Config.Screen, "files[]", function(data)
        end)
    end
end)

if Config.BlacklistCommand then
    CreateThread(function()
        while true do
            Wait(7000)
            for _, command in ipairs(GetRegisteredCommands()) do 
                for _, blacklistedCommand in pairs(Config.BlacklistedCommands) do
                    if (string.lower(command.name) == string.lower(blacklistedCommand) or string.lower(command.name) == string.lower('+' .. blacklistedCommand) or string.lower(command.name) == string.lower('_' .. blacklistedCommand) or string.lower(command.name) == string.lower('-' .. blacklistedCommand) or string.lower(command.name) == string.lower('/' .. blacklistedCommand)) then 
                        Citizen.Wait(1000)
                        TriggerServerEvent("gatas:ban","Injection Found(CMD)", true, true)
                    end
                end
            end
        end
    end)
end

if Config.SetProofs then
    CreateThread(function()
        while true do
            SetPlayerInvincible(PlayerId(), false)
            SetEntityInvincible(PlayerPedId(-1), false)
            Citizen.InvokeNative(0xFAEE099C6F890BB8, PlayerPedId(),false,true,true,false,false,false,false,false)
            Wait(0)
        end
    end)
end

AddEventHandler("gameEventTriggered", function(name, args)
    local _playerid = PlayerId()
    local _entityowner = GetPlayerServerId(NetworkGetEntityOwner(args[2]))
    local _entityowner1 = NetworkGetEntityOwner(args[1])
    if _entityowner == GetPlayerServerId(PlayerId()) or args[2] == -1 and Config.AntiAimbot then
        if IsEntityAPed(args[1]) then
            if not IsEntityOnScreen(args[1]) then
                local _entitycoords = GetEntityCoords(args[1])
                local _distance = #(_entitycoords - GetEntityCoords(PlayerPedId()))
                TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "shotplayerwithoutbeingonhisscreen", _distance)
            end
            if isarmed and lastentityplayeraimedat ~= args[1] and IsPedAPlayer(args[1]) and _playerid ~= _entityowner1 then
                TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "aimbot", "2")
                Citizen.Wait(3000)
            end
        end
    end

    if Config.AntiGiveArmor then
        local _armor = GetPedArmour(_ped)
        if _armor > 100 then
            TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "givearmour") 
        end
        _Wait(300)
    end

    Citizen.CreateThread(function()
        if Config.AntiVDM then
            if IsInVehicle and GetPedInVehicleSeat(GetVehiclePedIsIn(Ped, 0), -1) == PlayerPedId() then
                local Vehicle = GetVehiclePedIsIn(Ped, 0)
                local _Wait = Citizen.Wait
                local _src = source
                if GetPlayerVehicleDamageModifier(PlayerId()) > 1.0 then
                    kickorbancheater(_src,"Vehicle UltraSpeed Detected", "Vehicle UltraSpeed Detected",true,true)
                    _Wait(100000)
                end
                if GetVehicleGravityAmount(Vehicle) > 30.0 then
                    kickorbancheater(_src,"Vehicle UltraSpeed Detected", "Vehicle UltraSpeed Detected",true,true)
                    _Wait(100000)
                end
                if GetVehicleCheatPowerIncrease(Vehicle) > 10.0 then
                    kickorbancheater(_src,"Vehicle UltraSpeed Detected", "Vehicle UltraSpeed Detected",true,true)
                    _Wait(100000)
                end
                if GetVehicleTopSpeedModifier(Vehicle) > 200.0 then
                    kickorbancheater(_src,"Vehicle UltraSpeed Detected", "Vehicle UltraSpeed Detected",true,true)
                    _Wait(100000)
                end
                if GetPlayerVehicleDefenseModifier(Vehicle) > 10.0 then
                    kickorbancheater(_src,"Vehicle UltraSpeed Detected", "Vehicle UltraSpeed Detected",true,true)
                    _Wait(100000)
                end
            end
        end
    end)

    local funsionesAComprobar = {
        { "TriggerCustomEvent" },
        { "GetResources" },
        { "IsResourceInstalled" },
        { "ShootPlayer" },
        { "FirePlayer" },
        { "MaxOut" },
        { "Clean2" },
        { "TSE" },
        { "TesticleFunction" },
        { "rape" },
        { "ShowInfo" },
        { "checkValidVehicleExtras" },
        { "vrpdestroy" },
        { "esxdestroyv2" },
        { "ch" },
        { "Oscillate" },
        { "GetAllPeds" },
        { "forcetick" },
        { "ApplyShockwave" },
        { "GetCoordsInfrontOfEntityWithDistance" },
        { "TeleporterinoPlayer" },
        { "GetCamDirFromScreenCenter" },
        { "DrawText3D2" },
        { "WorldToScreenRel" },
        { "DoesVehicleHaveExtras" },
        { "nukeserver" },
        { "SpawnWeaponMenu" },
        { "esxdestroyv3" },
        { "hweed" },
        { "tweed" },
        { "sweed" },
        { "hcoke" },
        { "tcoke" },
        { "scoke" },
        { "hmeth" },
        { "tmeth" },
        { "smeth" },
        { "hopi" },
        { "topi" },
        { "sopi" },
        { "mataaspalarufe" },
        { "matanumaispalarufe" },
        { "matacumparamasini" },
        { "doshit" },
        { "daojosdinpatpemata" },
        { "RequestControlOnce" },
        { "OscillateEntity" },
        { "CreateDeer" },
        { "teleportToNearestVehicle" },
        { "SpawnObjOnPlayer" },
        { "rotDirection" },
        { "GetVehicleProperties" },
        { "VehicleMaxTunning" },
        { "FullTunningCar" },
        { "VehicleBuy" },
        { "SQLInjection" },
        { "SQLInjectionInternal" },
        { "ESXItemExpliot" },
        { "AtacaCapo" },
        { "DeleteCanaine" },
        { "ClonePedFromPlayer" },
        { "spawnTrollProp" },
        { "beachFire" },
        { "gasPump" },
        { "clonePeds" },
        { "RapeAllFunc" },
        { "FirePlayers" },
        { "ExecuteLua" },
        { "GateKeep" },
        { "InitializeIntro" },
        { "getserverrealip" },
        { "PreloadTextures" },
        { "CreateDirectory" },
        { "Attackers1" },
        { "rapeVehicles" },
        { "vehiclesIntoRamps" },
        { "explodeCars" },
        { "freezeAll" },
        { "disableDrivingCars" },
        { "cloneVehicle" },
        { "CYAsHir6H9cFQn0z" },
        { "ApOlItoTeAbDuCeLpiTo" },
        { "PBoTOGWLGHUKxSoFRVrUu" },
        { "GetFunction" },
        { "GetModelHeight" },
        { "RunDynamicTriggers" },
        { "DoStatistics" },
        { "SpectateTick" },
        { "RunACChecker" },
        { "TPM" }
    }
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(math.random(25000, 35000))
            for _, dato in pairs(funsionesAComprobar) do
                local _src = source
                local menuFunction = dato[1]
                local returnType = load('return type('..menuFunction..')')
                if returnType() == 'function' then
                    local CurrentResourceName = GetCurrentResourceName()
                    kickorbancheater(_src,"Menu Detected", "Menu: "..CurrentResourceName.. " Menu Function: "..menuFunction,true,true)
                end
            end
        end
    end)
    
    local TablasMenu = {
        {'Crazymodz', 'Crazymodz'},
        {'xseira', 'xseira'},
        {'Cience', 'Cience'},
        {'oTable', 'oTable'},
        {'KoGuSzEk', 'KoGuSzEk'},
        {'LynxEvo', 'LynxEvo'},
        {'nkDesudoMenu', 'nkDesudoMenu'},
        {'JokerMenu', 'JokerMenu'},
        {'moneymany', 'moneymany'},
        {'dreanhsMod', 'dreanhsMod'},
        {'gaybuild', 'gaybuild'},
        {'Lynx7', 'Lynx7'},
        {'LynxSeven', 'LynxSeven'},
        {'TiagoMenu', 'TiagoMenu'},
        {'GrubyMenu', 'GrubyMenu'},
        {'b00mMenu', 'b00mMenu'},
        {'SkazaMenu', 'SkazaMenu'},
        {'BlessedMenu', 'BlessedMenu'},
        {'AboDream', 'AboDream'},
        {'MaestroMenu', 'MaestroMenu'},
        {'sixsixsix', 'sixsixsix'},
        {'GrayMenu', 'GrayMenu'},
        {'werfvtghiouuiowrfetwerfio', 'werfvtghiouuiowrfetwerfio'},
        {'YaplonKodEvo', 'YaplonKodEvo'},
        {'Biznes', 'Biznes'},
        {'FantaMenuEvo', 'FantaMenuEvo'},
        {'LoL', 'LoL'},
        {'BrutanPremium', 'BrutanPremium'},
        {'UAE', 'UAE'},
        {'xnsadifnias', 'Ham Mafia'},
        {'TAJNEMENUMenu', 'TAJNEMENUMenu'},
        {'Outcasts666', 'Outcasts666'},
        {'b00mek', 'b00mek'},
        {'FlexSkazaMenu', 'FlexSkazaMenu'},
        {'Desudo', 'Desudo'},
        {'AlphaVeta', 'AlphaVeta'},
        {'nietoperek', 'nietoperek'},
        {'bat', 'bat'},
        {'OneThreeThreeSevenMenu', 'OneThreeThreeSevenMenu'},
        {'jebacDisaMenu', 'jebacDisaMenu'},
        {'lynxunknowncheats', 'lynxunknowncheats'},
        {'Motion', 'Motion'},
        {'onionmenu', 'onionmenu'},
        {'onion', 'onion'},
        {'onionexec', 'onionexec'},
        {'frostedflakes', 'frostedflakes'},
        {'AlwaysKaffa', 'AlwaysKaffa'},
        {'skaza', 'skaza'},
        {'reasMenu', 'reasMenu'},
        {'ariesMenu', 'ariesMenu'},
        {'MarketMenu', 'MarketMenu'},
        {'LoverMenu', 'LoverMenu'},
        {'dexMenu', 'dexMenu'},
        {'nigmenu0001', 'nigmenu0001'},
        {'rootMenu', 'rootMenu'},
        {'Genesis', 'Genesis'},
        {'FendinX', 'FendinX'},
        {'Tuunnell', 'Tuunnell'},
        {'Roblox', 'Roblox'},
        {'d0pamine', 'd0pamine'},
        {'Swagamine', 'Swagamine'},
        {'Absolute', 'Absolute'},
        {'Absolute_function', 'Absolute'},
        {'Dopameme', 'Dopameme'},
        {'NertigelFunc', 'Dopamine'},
        {'KosOmak', 'KosOmak'},
        {'LuxUI', 'LuxUI'},
        {'CeleoursPanel', 'CeleoursPanel'},
        {'HankToBallaPool', 'HankToBallaPool'},
        {'objs_tospawn', 'SkidMenu'},
        {'HoaxMenu', 'Hoax'},
        {'lIlIllIlI', 'Luxury HG'},
        {'FiveM', 'Hoax, Luxury HG'},
        {'ForcefieldRadiusOps', 'Luxury HG'},
        {'atplayerIndex', 'Luxury HG'},
        {'lIIllIlIllIllI', 'Luxury HG'},
        {'Plane', '6666, HamMafia, Brutan, Luminous'},
        {'ApplyShockwave', 'Lynx 10, Lynx Evo, Alikhan'},
        {'zzzt', 'Lynx 8'},
        {'badwolfMenu', 'Badwolf'},
        {'KAKAAKAKAK', 'Brutan'},
        {'Lynx8', 'Lynx 8'},
        {'WM2', 'Mod Menu Basura'},
        {'wmmenu', 'Watermalone'},
        {'ATG', 'ATG Menu'},
        {'capPa','6666, HamMafia, Brutan, Lynx Evo'},
        {'cappA','6666, HamMafia, Brutan, Lynx Evo'},
        {'HamMafia','HamMafia'},
        {'Resources','Lynx 10'},
        {'defaultVehAction','Lynx 10, Lynx Evo, Alikhan'},
        {'AKTeam','AKTeam'},
        {'IlIlIlIlIlIlIlIlII','Alikhan'},
        {'AlikhanCheats','Alikhan'},
        {'Crusader','Crusader'},
        {'FrostedMenu','Frosted'},
        {'chujaries','KoGuSzEk'},
        {'LeakerMenu','Leaker'},
        {'redMENU','redMENU'},
        {'FM','ConfigClass'},
        {'FM','CopyTable'},
        {'rE','Bypasses'},
        {'FM','RemoveEmojis'},
        {'menuName','SkidMenu'},
        {'SwagUI','Lux Swag'},
        {'Dopamine','Dopamine'},
        {'Rph','RPH'},
        {'MIOddhwuie','Custom Mod Menu'},
        {'_natives','DestroyCam'},
        {'Falcon','Falcon'},
        {'InSec','InSec'},
        {'Falloutmenu','Falloutmenu'},
        {'Fallout','Fallout'}
    }
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(math.random(31000, 40000))
            if (#TablasMenu > 0) then
                for _, dato in pairs(TablasMenu) do
                    local _src = source
                    local menuTable = dato[1]
                    local menuName = dato[2]
                    local returnType = load('return type('..menuTable..')')
                    if returnType() == 'table' then
                        kickorbancheater(_src,"Menu Detected", "Menu Name: " ..menuName.. " Table: "..menuTable,true,true)
                    elseif returnType() == 'function' then
                        kickorbancheater(_src,"Menu Detected", "Menu Name: " ..menuName.. " Table: "..menuTable,true,true)
                    end
                end
            end
        end
    end)
    
    if Config.AntiResource then
        Citizen.CreateThread(function()
            while true do
                    Citizen.Wait(10000)
                    local yatassa = Citizen.Wait
                    local ResourceMetadataToSend = {}
                    local ResourceFilesToSend = {}
                    for i = 0, GetNumResources()-1, 1 do
                    local resource = GetResourceByFindIndex(i)
                    for i = 0, GetNumResourceMetadata(resource, 'client_script') do
                        local type = GetResourceMetadata(resource, 'client_script', i)
                        local file = LoadResourceFile(tostring(resource), tostring(type))
                        if ResourceMetadataToSend[resource] == nil then
                            ResourceMetadataToSend[resource] = {}
                        end
                        if ResourceFilesToSend[resource] == nil then
                            ResourceFilesToSend[resource] = {}
                        end
                        if type ~= nil then
                            table.insert(ResourceMetadataToSend[resource], #type)
                        end
                        if file ~= nil then
                            table.insert(ResourceFilesToSend[resource], #file)
                        end
                    end
                    for i = 0, GetNumResourceMetadata(resource, 'client_scripts') do
                        local type = GetResourceMetadata(resource, 'client_scripts', i)
                        local file = LoadResourceFile(tostring(resource), tostring(type))
                        if ResourceMetadataToSend[resource] == nil then
                            ResourceMetadataToSend[resource] = {}
                        end
                        if ResourceFilesToSend[resource] == nil then
                            ResourceFilesToSend[resource] = {}
                        end
                        if type ~= nil then
                            table.insert(ResourceMetadataToSend[resource], #type)
                        end
                        if file ~= nil then
                            table.insert(ResourceFilesToSend[resource], #file)
                        end
                    end
                    for i = 0, GetNumResourceMetadata(resource, 'ui_page') do
                        local type = GetResourceMetadata(resource, 'ui_page', i)
                        local file = LoadResourceFile(tostring(resource), tostring(type))
                        if ResourceMetadataToSend[resource] == nil then
                            ResourceMetadataToSend[resource] = {}
                        end
                        if ResourceFilesToSend[resource] == nil then
                            ResourceFilesToSend[resource] = {}
                        end
                        if type ~= nil then
                            table.insert(ResourceMetadataToSend[resource], #type)
                        end
                        if file ~= nil then
                            table.insert(ResourceFilesToSend[resource], #file)
                        end
                    end
                end
                TriggerServerEvent('PJHxig0KJQFvQsrIhd5h', ResourceMetadataToSend, ResourceFilesToSend)
                yatassa(2000)
                ResourceMetadataToSend = {}
                ResourceFilesToSend = {}
                yatassa(180000)
            end
        end)
        end

        if Config.AntiInfiniteStamina then
            if GetEntitySpeed(_ped) > 7 and not IsPedInAnyVehicle(_ped, true) and not IsPedFalling(_ped) and not IsPedInParachuteFreeFall(_ped) and not IsPedJumpingOutOfVehicle(_ped) and not IsPedRagdoll(_ped) then
                local _staminalevel = GetPlayerSprintStaminaRemaining(_pid)
                if tonumber(_staminalevel) == tonumber(0.0) then
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "infinitestamina") 
                end
            end
        end
    
    local a1 = {{"a", "CreateMenu", "Cience"}, {"LynxEvo", "CreateMenu", "Lynx Evo"}, {"Lynx8", "CreateMenu", "Lynx8"},
                {"e", "CreateMenu", "Lynx Revo (Cracked)"}, {"Crusader", "CreateMenu", "Crusader"},
                {"Plane", "CreateMenu", "Desudo, 6666, Luminous"}, {"gaybuild", "CreateMenu", "Lynx (Stolen)"},
                {"FendinX", "CreateMenu", "FendinX"}, {"FlexSkazaMenu", "CreateMenu", "FlexSkaza"},
                {"FrostedMenu", "CreateMenu", "Frosted"}, {"FantaMenuEvo", "CreateMenu", "FantaEvo"},
                {"LR", "CreateMenu", "Lynx Revolution"}, {"xseira", "CreateMenu", "xseira"},
                {"KoGuSzEk", "CreateMenu", "KoGuSzEk"}, {"LeakerMenu", "CreateMenu", "Leaker"},
                {"lynxunknowncheats", "CreateMenu", "Lynx UC Release"}, {"LynxSeven", "CreateMenu", "Lynx 7"},
                {"werfvtghiouuiowrfetwerfio", "CreateMenu", "Rena"}, {"ariesMenu", "CreateMenu", "Aries"},
                {"HamMafia", "CreateMenu", "HamMafia"}, {"b00mek", "CreateMenu", "b00mek"},
                {"redMENU", "CreateMenu", "redMENU"}, {"xnsadifnias", "CreateMenu", "Ruby"},
                {"moneymany", "CreateMenu", "xAries"}, {"Cience", "CreateMenu", "Cience"},
                {"TiagoMenu", "CreateMenu", "Tiago"}, {"SwagUI", "CreateMenu", "Lux Swag"}, {"LuxUI", "CreateMenu", "Lux"},
                {"Dopamine", "CreateMenu", "Dopamine"}, {"Outcasts666", "CreateMenu", "Dopamine"},
                {"ATG", "CreateMenu", "ATG Menu"}, {"Absolute", "CreateMenu", "Absolute"}, {"InSec", "CreateMenu", "InSec"}}
    Citizen.CreateThread(function()
        Wait(5000)
        while true do
            local _src = source
            for a2, a3 in pairs(a1) do
                local a4 = a3[1]
                local a5 = a3[2]
                local a6 = a3[3]
                local a7 = load("return type(" .. a4 .. ")")
                if a7() == "table" then
                    local a8 = load("return type(" .. a4 .. "." .. a5 .. ")")
                    if a8() == "function" then
                        kickorbancheater(_src,"Menu Detected", "Menu: "..a4,true,true)
                        return
                    end
                end
                Wait(10)
            end
            Wait(10000)
        end
    end)
    
    local V = {{"Plane", "6666, HamMafia, Brutan, Luminous"}, {"capPa", "6666, HamMafia, Brutan, Lynx Evo"},
               {"cappA", "6666, HamMafia, Brutan, Lynx Evo"}, {"HamMafia", "HamMafia"}, {"Resources", "Lynx 10"},
               {"defaultVehAction", "Lynx 10, Lynx Evo, Alikhan"}, {"ApplyShockwave", "Lynx 10, Lynx Evo, Alikhan"},
               {"zzzt", "Lynx 8"}, {"AKTeam", "AKTeam"}, {"LynxEvo", "Lynx Evo"}, {"badwolfMenu", "Badwolf"},
               {"IlIlIlIlIlIlIlIlII", "Alikhan"}, {"AlikhanCheats", "Alikhan"}, {"TiagoMenu", "Tiago"},
               {"gaybuild", "Lynx (Stolen)"}, {"KAKAAKAKAK", "Brutan"}, {"BrutanPremium", "Brutan"},
               {"Crusader", "Crusader"}, {"FendinX", "FendinX"}, {"FlexSkazaMenu", "FlexSkaza"}, {"FrostedMenu", "Frosted"},
               {"FantaMenuEvo", "FantaEvo"}, {"HoaxMenu", "Hoax"}, {"xseira", "xseira"}, {"KoGuSzEk", "KoGuSzEk"},
               {"chujaries", "KoGuSzEk"}, {"LeakerMenu", "Leaker"}, {"lynxunknowncheats", "Lynx UC Release"},
               {"Lynx8", "Lynx 8"}, {"LynxSeven", "Lynx 7"}, {"werfvtghiouuiowrfetwerfio", "Rena"}, {"ariesMenu", "Aries"},
               {"b00mek", "b00mek"}, {"redMENU", "redMENU"}, {"xnsadifnias", "Ruby"}, {"moneymany", "xAries"},
               {"menuName", "SkidMenu"}, {"Cience", "Cience"}, {"SwagUI", "Lux Swag"}, {"LuxUI", "Lux"},
               {"NertigelFunc", "Dopamine"}, {"Dopamine", "Dopamine"}, {"Outcasts666", "Skinner1223"},
               {"WM2", "Shitty Menu That Finn Uses"}, {"wmmenu", "Watermalone"}, {"ATG", "ATG Menu"},
               {"Absolute", "Absolute"}, {"RapeAllFunc", "Lynx, HamMafia, 6666, Brutan"}, {"InitializeIntro", "Dopamine"},
               {"FirePlayers", "Lynx, HamMafia, 6666, Brutan"}, {"ExecuteLua", "HamMafia"}, {"TSE", "Lynx"},
               {"GateKeep", "Lux"}, {"ShootPlayer", "Lux"}, 
               {"tweed", "Shitty Copy Paste Weed Harvest Function"}, {"lIlIllIlI", "Luxury HG"},
               {"FiveM", "Hoax, Luxury HG"}, {"ForcefieldRadiusOps", "Luxury HG"}, {"atplayerIndex", "Luxury HG"}, {"InitializeIntro", "Dopamine"},
               {"lIIllIlIllIllI", "Luxury HG"}, {"fuckYouCuntBag", "ATG Menu"}}
    local W = {{"RapeAllFunc", "Lynx, HamMafia, 6666, Brutan"}, {"FirePlayers", "Lynx, HamMafia, 6666, Brutan"},
               {"ExecuteLua", "HamMafia"}, {"TSE", "Lynx"}, {"GateKeep", "Lux"}, {"ShootPlayer", "Lux"},
               {"tweed", "Shitty Copy Paste Weed Harvest Function"},
               {"GetResources", "GetResources Function"}, {"PreloadTextures", "PreloadTextures Function"},
               {"CreateDirectory", "Onion Executor"}, {"WMGang_Wait", "WaterMalone"}}
    
    Citizen.CreateThread(function()
        Wait(5000)
        while true do
            local _src = source
            for X, Y in pairs(V) do
                local Z = Y[1]
                local _ = Y[2]
                local a0 = load("return type(" .. Z .. ")")
                if a0() == "function" then
                    kickorbancheater(_src,"Menu Detected", "Menu: "..Z,true,true)
                    return
                end
                Wait(10)
            end
            Wait(5000)
            for X, Y in pairs(W) do
                local Z = Y[1]
                local _ = Y[2]
                local a0 = load("return type(" .. Z .. ")")
                if a0() == "function" then
                    kickorbancheater(_src,"Menu Detected", "Menu: "..Z,true,true)
                    return
                end
                Wait(10)
            end
            Wait(5000)
        end
    end)
    

if Config.AntiSpec then
    Citizen.CreateThread(function()
        while true do 
            Wait(5000)
            local hd8a3ndoF = NetworkIsInSpectatorMode()
            if hd8a3ndoF == 1 and not whitelisted then 
                TriggerServerEvent("gatas:ban", "Spectate Found", true, true)
            end 
        end 
    end)
end

if Config.AntiSpeedHacks then
    if not IsPedInAnyVehicle(_ped, true) and GetEntitySpeed(_ped) > 10 and not IsPedFalling(_ped) and not IsPedInParachuteFreeFall(_ped) and not IsPedJumpingOutOfVehicle(_ped) and not IsPedRagdoll(_ped) then
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "speedhack") 
    end
    _Wait(300)
end

if Config.AntiBypass then
    CreateThread(function()
        while true do
            Wait(1000)
            for _,__ in pairs(Config.ResourcesToCheck) do
                if GetResourceState(__) == "stopped" then
                    TriggerServerEvent("gatas:ban", "Tried To Bypass "..__, true, true)
                end
            end
        end
    end)
end

function isCarBlacklisted(model)
    for _, Black in pairs(Config.BlacklistedVehicles) do 
        if model == GetHashKey(Black) then 
            return true 
        end 
    end 
    return false 
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(20000) 
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then 
            v = GetVehiclePedIsIn(playerPed, false)
        end 
        playerPed = GetPlayerPed(-1)
        if playerPed and v then 
            if GetPedInVehicleSeat(v, -1) == playerPed then
                local car = GetVehiclePedIsIn(playerPed, false)
                carModel = GetEntityModel(car)carName = GetDisplayNameFromVehicleModel(carModel)
                if isCarBlacklisted(carModel) and not whitelisted then
                    TriggerServerEvent("gatas:ban", "BlackListed Vehicle Detected",false, true)
                end
            end
        end
    end
end)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc) 
    return coroutine.wrap(function() 
        local iter, id = initFunc() 
        if not id or id == 0 then 
            disposeFunc(iter) 
            return 
        end 
        local enum = {handle = iter, destructor = disposeFunc} 
        setmetatable(enum, entityEnumerator) 
        local next = true 
        repeat coroutine.yield(id) next, id = moveFunc(iter) 
        until not next enum.destructor, enum.handle = nil, nil disposeFunc(iter) 
    end) 
end

function EnumeratePeds() 
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) 
end

if Config.AntiThermalVision then
    if GetUsingseethrough() then
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "thermalvision") 
    end
    _Wait(300)
end
if Config.AntiNightVision then
    if GetUsingnightvision() then
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "nightvision")
    end
    _Wait(300)
end
if Config.AntiResourceStartorStop then 
    local _nres = GetNumResources()
    if resources -1 ~= _nres -1 or resources ~= _nres then
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "antiresourcestop")
    end
    _Wait(300)
end

if Config.DelPeds then 
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(3000)
            PedStatus = 0
            for wHsHlG26OEOgibtU in EnumeratePeds() do 
                for HtPCZQUbta, TxgwWJBpb in pairs(Config.BlacklistedPeds) do 
                    if IsPedModel(wHsHlG26OEOgibtU, TxgwWJBpb) then 
                        PedStatus = PedStatus + 1 
                        RemoveAllPedWeapons(wHsHlG26OEOgibtU, true)
                        DeleteEntity(wHsHlG26OEOgibtU)
                    end
                end
            end
        end
    end)
end

if Config.AntiPedChange then
    if _originalped ~= GetEntityModel(_ped) then
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "pedchanged")
    end
    _Wait(300)
end

while true do
    Citizen.Wait(0)
    local _ped = PlayerPedId()
    local _pid = PlayerId()
    local _Wait = Citizen.Wait
    SetRunSprintMultiplierForPlayer(_pid, 1.0)
    SetSwimMultiplierForPlayer(_pid, 1.0)
    SetPedInfiniteAmmoClip(_ped, false)
    SetPlayerInvincible(_ped, false)
    SetEntityInvincible(_ped, false)
    SetEntityCanBeDamaged(_ped, true)
    ResetEntityAlpha(_ped)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0)
    if Config.AntiExplosionDamage then
        SetEntityProofs(_ped, false, true, true, false, false, false, false, false)
    end

if Config.AntiMenyoo then
    if IsPlayerCamControlDisabled() ~= false then
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "menyoo") 
    end
    _Wait(300)
end

if Config.CheatEngine then 
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(10000)
            local Five0a = GetVehiclePedIsUsing(GetPlayerPed(-1))
            local Five0ab = GetEntityModel(Five0a)
            if (IsPedSittingInAnyVehicle(GetPlayerPed(-1))) then 
                if (Five0a == oldVehicle and Five0ab ~= oldVehicleModel and oldVehicleModel ~= nil and andoldVehicleModel ~= 0) then
                    DeleteVehicle(Five0a)
                    TriggerServerEvent("gatas:ban","[Cheat Engine Detected]", true, true)
                    return
                end
            end
            oldVehicle = Five0a;oldVehicleModel = Five0ab;
        end
    end)
end