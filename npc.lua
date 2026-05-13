-- Guard against nil value error from 1000350365.jpg
if minetest.get_modpath("folks") and folks and folks.register_npc then
    folks.register_npc("mmo_banking:banker", {
        description = "Techblox Banker",
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
else
    minetest.log("warning", "[mmo_banking] Folks mod or register_npc missing. Banker disabled.")
end
