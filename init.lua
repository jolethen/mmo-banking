local path = minetest.get_modpath("mmo_banking")

dofile(path .. "/config.lua")
dofile(path .. "/logging.lua")
dofile(path .. "/storage.lua")
dofile(path .. "/api.lua")
dofile(path .. "/interest.lua")
dofile(path .. "/ui.lua")
dofile(path .. "/npc.lua")

minetest.log("action", "[mmo_banking] System Initialized.")
