fx_version 'cerulean'
game 'gta5' -- змінено тут
lua54 'yes'

author 'Marko Scripts'
description 'Car Thief'
version '1.0.0'

client_scripts {  -- виправлено на множину
  "client.lua",
} 
server_scripts {  -- виправлено на множину
  "server.lua",
} 

shared_scripts {
  'config.lua'
}

ui_page 'ui/index.html'

files { 
  'ui/*',
}

server_exports {  -- виправлено на множину
  'getPlayerLevel'
}

escrow_ignore {
  'server.lua',
  'client.lua',
  'config.lua',
  'ui/*'
}