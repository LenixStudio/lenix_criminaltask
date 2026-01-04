fx_version 'cerulean'
game 'gta5'
lua54 'yes'
dependencies {
  'qbx_core',
  'tr_lib',
}

author 'https://github.com/LenixDev'
version '1.0.4'

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