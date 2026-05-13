-- Register the NPC immediately so the engine recognizes it
if minetest.get_modpath("folks") and folks and folks.register_npc then
    folks.register_npc("mmo_banking:banker", {
        description = "Banker NPC",
        mesh = "character.b3d", -- This REQUIRES the file in mmo_banking/models/
        textures = {"banker_skin.png"}, -- This REQUIRES the file in mmo_banking/textures/
        groups = {immortal = 1},
        on_rightclick = function(self, clicker)
            local name = clicker:get_player_name()
            -- Check security then show UI
            if mmo_banking.security.check_cooldown(name) then
                mmo_banking.process_interest(name)
                mmo_banking.show_ui(name)
            end
        end,
    })
else
    minetest.log("error", "[mmo_banking] Folks mod not found! Banker NPC will not work.")
end

-- Fixed Spawn Command
minetest.register_chatcommand("spawn_banker", {
    description = "Spawn a Banker NPC",
    privs = {server = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            -- Add 0.5 to Y so he doesn't spawn inside the floor
            pos.y = pos.y + 0.5
            minetest.add_entity(pos, "mmo_banking:banker")
            return true, "Banker spawned!"
        end
    end,
})
