
--------------------------------------------------------------
--  0x4A4A78 - สคริปต์ Painkiller | Aed
-- 🚫 0x4A4A78 - ห้ามนำไปขายต่อหรือแจกโดยไม่ได้รับอนุญาต
-- 🌐 0x4A4A78 - Discord: https://discord.gg/pmDTcbB5ym
--------------------------------------------------------------


fx_version 'adamant'
game 'gta5'
author 'JJx'
version '1.5'
exports { 'CheckIsAnimate' }

client_script 'code/client.lua'
shared_script 'code/config.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
}
