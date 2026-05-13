-- Register the NPC
if minetest.get_modpath("folks") and folks and folks.register_npc then
    folks.register_npc("mmo_banking:banker", {
        description = "Banker NPC",
        mesh = "npc.b3d", -- CHANGED: Matches your model file
        textures = {"folks_default.png"}, -- CHANGED: Matches your texture file
        groups = {immortal = 1},
        on_rightclick = function(self, clicker)
            local name = clicker:get_player_name()
            -- Check security then show UI
            if mmo_banking.security.check_cooldown(name) then
                -- Note: Ensure these functions exist in interest.lua and ui.lua
                if mmo_banking.process_interest then
                    mmo_banking.process_interest(name)
                end
                mmo_banking.show_ui(name)
            end
        end,
    })
else
    minetest.log("error", "[mmo_banking] Folks mod not found or register_npc missing!")
end

-- Fixed Spawn Command
minetest.register_chatcommand("spawn_banker", {
    description = "Spawn a Banker NPC",
    privs = {server = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            pos.y = pos.y + 0.5
            minetest.add_entity(pos, "mmo_banking:banker")
            return true, "Banker spawned at your location."
        end
    end,
})
