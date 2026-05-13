function mmo_banking.show_ui(player_name)
    local acc = mmo_banking.load_account(player_name)
    -- Added color and formatting to the balance
    local form = "size[8,7]bgcolor-[#080808BB;true]" ..
        "label[0.5,0.5;§6§lMMO BANKING SYSTEM]" ..
        "label[0.5,1.2;Balance: §e" .. acc.balance .. " units]" ..
        "field[0.8,2.5;3,1;amt;Amount:;]" ..
        "button[0.5,3.5;3,1;deposit;Deposit (from Inv)]" ..
        "button[4,3.5;3,1;withdraw;Withdraw (to Inv)]" ..
        "label[0.5,4.5;§bTransfer Money]" ..
        "field[0.8,5.5;3,1;target;Recipient:;]" ..
        "button[4,5.2;3,1;transfer;Execute Transfer]"

    minetest.show_formspec(player_name, "mmo_banking:main", form)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "mmo_banking:main" then return end
    local name = player:get_player_name()

    -- 1. Security Check
    if not mmo_banking.security.check_cooldown(name) then return end

    -- 2. Deposit Logic (Calls API)
    if fields.deposit then
        local val = tonumber(fields.amt)
        if val then
            local ok, msg = mmo_banking.deposit_physical(name, val)
            minetest.chat_send_player(name, (ok and "§a" or "§c") .. msg)
        end

    -- 3. Withdraw Logic (Calls API)
    elseif fields.withdraw then
        local val = tonumber(fields.amt)
        if val then
            local ok, msg = mmo_banking.withdraw_physical(name, val)
            minetest.chat_send_player(name, (ok and "§a" or "§c") .. msg)
        end

    -- 4. Transfer Logic (Calls API)
    elseif fields.transfer then
        local val = tonumber(fields.amt)
        if val and fields.target ~= "" then
            local ok, msg = mmo_banking.transfer(name, fields.target, val, "P2P Transfer")
            minetest.chat_send_player(name, (ok and "§a" or "§c") .. msg)
        end
    end

    mmo_banking.show_ui(name) -- Always refresh to show new balance
end)
