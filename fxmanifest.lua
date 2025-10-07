fx_version 'cerulean'
game 'gta5'
lua54 'yes'
dependencies {
  'qbx_core',
  'ox_inventory',
  'ox_lib',
  'ox_target'
}

author 'Trippler Hub'

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

escrow_ignore {
  'config/*.lua'
}