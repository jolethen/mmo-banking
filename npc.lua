if minetest.get_modpath("folks") then
    folks.register_npc("mmo_banking:banker", {
        description = "Banker NPC",
        mesh = "character.b3d",
        textures = {"banker_skin.png"},
        inventory_image = "banker_spawn_egg.png",
        groups = {immortal = 1}, -- Indestructible
        
        on_rightclick = function(self, clicker)
            local name = clicker:get_player_name()
            
            -- 1. Security Check
            if not mmo_banking.security.check_cooldown(name) then
                minetest.chat_send_player(name, "§c[Bank] Please wait a moment...")
                return
            end
            
            -- 2. Process Interest first
            mmo_banking.process_interest(name)
            
            -- 3. Open UI
            mmo_banking.show_ui(name)
        end,
    })
end
