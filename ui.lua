function mmo_banking.show_ui(player_name)
    local acc = mmo_banking.load_account(player_name)
    local form = "size[8,6]bgcolor-[#080808BB;true]" ..
        "label[0.5,0.5;MMO BANKING SYSTEM]" ..
        "label[0.5,1.2;Balance: " .. acc.balance .. " units]" ..
        "field[0.8,2.5;3,1;amt;Amount:;]" ..
        "button[0.5,3.5;3,1;deposit;Deposit (from Inv)]" ..
        "button[4,3.5;3,1;withdraw;Withdraw (to Inv)]" ..
        "field[0.8,5;3,1;target;Transfer To:;]" ..
        "button[4,4.7;3,1;transfer;Execute Transfer]"

    minetest.show_formspec(player_name, "mmo_banking:main", form)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "mmo_banking:main" then return end
    local name = player:get_player_name()
    local acc = mmo_banking.load_account(name)

    -- Security: Rate-limiting
    if os.clock() - acc.last_act < mmo_banking.config.cooldown then return end
    acc.last_act = os.clock()

    if fields.deposit then
        -- Insert deposit logic here (from previous response)
    elseif fields.transfer then
        mmo_banking.transfer(name, fields.target, tonumber(fields.amt) or 0, "P2P Transfer")
    end
    mmo_banking.show_ui(name) -- Refresh UI
end)
