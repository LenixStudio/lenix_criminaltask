fx_version 'cerulean'
game 'gta5'
lua54 'yes'
dependencies {
  'qbx_core',
  'ox_inventory',
  'tr_lib',
}

author 'Trippler'
docs 'https://docs.trippler.store'
version '1.0.1'

server_scripts {
  'server/main.lua',
  'config/server.lua'
}
client_scripts {
  'client/main.lua',
  'config/client.lua'
}

escrow_ignore {
  'config/client.lua',
  'config/server.lua',
  'client/bridge.lua',
}