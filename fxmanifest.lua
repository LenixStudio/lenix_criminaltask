fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Trippler Hub'
dependencies {
  'ox_inventory'
}

shared_scripts {
  '@ox_lib/init.lua'
}
server_scripts {
  'server/main.lua',
  'config/server.lua'
}
client_scripts {
  'client/main.lua',
  'config/client.lua'
}