fx_version 'cerulean'
game 'gta5'
lua54 'yes'
dependencies {
  'qbx_core',
  'tr_lib',
}

author 'Trippler'
docs 'https://docs.trippler.store'
version '1.0.3'

files {
  'config/server.lua',
  'config/client.lua',
  'client/bridge.lua',
}

server_scripts {
  'server/main.lua',
}
client_scripts {
  'client/main.lua',
}

escrow_ignore {
  'config/client.lua',
  'config/server.lua',
  'client/bridge.lua',

}

