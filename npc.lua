-- Wrap in a function and delay it to avoid the crash in 1000350365.jpg
local function register_banker()
    if minetest.get_modpath("folks") and folks and folks.register_npc then
        folks.register_npc("mmo_banking:banker", {
            description = "Banker NPC",
            mesh = "character.b3d",
            textures = {"banker_skin.png"},
            groups = {immortal = 1},
            on_rightclick = function(self, clicker)
                local name = clicker:get_player_name()
                if mmo_banking.security.check_cooldown(name) then
                    mmo_banking.process_interest(name)
                    mmo_banking.show_ui(name)
                end
            end,
        })
        minetest.log("action", "[mmo_banking] Banker NPC registered via Folks.")
    else
        minetest.log("error", "[mmo_banking] folks.register_npc NOT found. Banker NPC registration failed.")
    end
end

-- Delay registration by 0.5s to let other mods initialize
minetest.after(0.5, register_banker)

-- ADD THIS COMMAND: Use /spawn_banker in game
minetest.register_chatcommand("spawn_banker", {
    description = "Spawn a Banker NPC at your position",
    privs = {server = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            -- We use add_entity because folks NPCs are entities
            minetest.add_entity(pos, "mmo_banking:banker")
            return true, "Banker spawned at your location."
        end
        return false, "Player not found."
    end,
})
