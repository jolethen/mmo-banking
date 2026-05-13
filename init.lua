local path = minetest.get_modpath("mmo_banking")

-- 1. Register Privileges
minetest.register_privilege("banker", {
    description = "Allows access to admin banking controls and global logs.",
    give_to_singleplayer = false,
})

-- 2. Load Core Utilities & Configuration
dofile(path .. "/config.lua")
dofile(path .. "/utils.lua")
dofile(path .. "/security.lua")
dofile(path .. "/logging.lua")

-- 3. Load Data & Logic Engines
dofile(path .. "/storage.lua")
dofile(path .. "/api.lua")
dofile(path .. "/interest.lua")

-- 4. Load Interaction Layers (UI & NPCs)
dofile(path .. "/ui.lua")
dofile(path .. "/npc.lua")

minetest.log("action", "[mmo_banking] Production system initialized successfully.")
