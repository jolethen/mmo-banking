function mmo_banking.show_ui(player_name)
    local acc = mmo_banking.load_account(player_name)
    
    -- The Formspec string
    local form = "size[8,7]bgcolor-[#080808BB;true]" ..
        "label[0.5,0.5;§6§lMMO BANKING SYSTEM]" ..
        "label[0.5,1.2;Balance: §e" .. acc.balance .. " units]" ..
        
        -- Deposit/Withdraw Section
        "field[0.8,2.5;3,1;amt;Amount:;]" ..
        "button[0.5,3.5;3,1;deposit;Deposit (from Inv)]" ..
        "button[4,3.5;3,1;withdraw;Withdraw (to Inv)]" ..
        
        -- Transfer Section
        "label[0.5,4.5;§bTransfer Money]" ..
        "field[0.8,5.5;3,1;target;Recipient Name:;]" ..
        "field[4.1,5.5;3,1;t_amt;Transfer Amount:;]" .. -- Added a dedicated transfer amount field
        "button[0.5,6.5;7,0.8;transfer;Execute Transfer]" -- Moved down so it doesn't overlap

    minetest.show_formspec(player_name, "mmo_banking:main", form)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "mmo_banking:main" then return end
    local name = player:get_player_name()

    -- 1. Security Check
    if not mmo_banking.security.check_cooldown(name) then 
        minetest.chat_send_player(name, "§cToo fast!")
        return 
    end

    -- 2. Deposit Logic
    if fields.deposit then
        local val = tonumber(fields.amt)
        if val then
            local ok, msg = mmo_banking.deposit_physical(name, val)
            minetest.chat_send_player(name, (ok and "§a" or "§c") .. msg)
        end

    -- 3. Withdraw Logic
    elseif fields.withdraw then
        local val = tonumber(fields.amt)
        if val then
            local ok, msg = mmo_banking.withdraw_physical(name, val)
            minetest.chat_send_player(name, (ok and "§a" or "§c") .. msg)
        end

    -- 4. Transfer Logic (Fixed to use t_amt)
    elseif fields.transfer then
        local val = tonumber(fields.t_amt) -- Match the field name in show_ui
        local target = fields.target
        if val and target ~= "" then
            local ok, msg = mmo_banking.transfer(name, target, val, "P2P Transfer")
            minetest.chat_send_player(name, (ok and "§a" or "§c") .. msg)
        else
            minetest.chat_send_player(name, "§cInvalid target or amount.")
        end
    end

    -- Update the screen to show the new balance immediately
    mmo_banking.show_ui(name) 
end)
