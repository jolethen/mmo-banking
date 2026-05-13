-- Physical Deposit (mingeld -> Bank)
function mmo_banking.deposit_physical(player_name, amount_units)
    local player = minetest.get_player_by_name(player_name)
    local inv = player:get_inventory()
    local coins_needed = math.floor(amount_units / mmo_banking.config.unit_value)
    
    if coins_needed <= 0 then return false, "Deposit must be at least 1 coin." end
    
    if inv:contains_item("main", mmo_banking.config.item .. " " .. coins_needed) then
        local acc = mmo_banking.load_account(player_name)
        inv:remove_item("main", mmo_banking.config.item .. " " .. coins_needed)
        acc.balance = acc.balance + (coins_needed * mmo_banking.config.unit_value)
        mmo_banking.save_account(player_name, acc)
        mmo_banking.log(player_name, "BANK", (coins_needed * 100), 0, "Deposit")
        return true, "Deposited " .. coins_needed .. " gold coins."
    end
    return false, "You don't have enough coins."
end

-- Physical Withdrawal (Bank -> mingeld)
function mmo_banking.withdraw_physical(player_name, amount_units)
    local player = minetest.get_player_by_name(player_name)
    local inv = player:get_inventory()
    local coins_to_give = math.floor(amount_units / mmo_banking.config.unit_value)
    local acc = mmo_banking.load_account(player_name)
    local total_cost = coins_to_give * mmo_banking.config.unit_value
    
    if coins_to_give <= 0 then return false, "Min withdrawal is 1 coin." end
    if acc.balance < total_cost then return false, "Insufficient bank balance." end
    
    if inv:room_for_item("main", mmo_banking.config.item .. " " .. coins_to_give) then
        acc.balance = acc.balance - total_cost
        inv:add_item("main", mmo_banking.config.item .. " " .. coins_to_give)
        mmo_banking.save_account(player_name, acc)
        mmo_banking.log("BANK", player_name, total_cost, 0, "Withdrawal")
        return true, "Withdrew " .. coins_to_give .. " gold coins."
    end
    return false, "Inventory full!"
end
