fx_version 'adamant'

game 'gta5'

description "FiveM AntiCheat Coded By GreekGamer"

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', 
    '@async/async.lua',
    'server/*.lua',
    "Config.lua"
}

dependencies {
	'es_extended',
    'mysql-async'
}
