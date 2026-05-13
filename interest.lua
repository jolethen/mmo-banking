function mmo_banking.process_interest(name)
    local acc = mmo_banking.load_account(name)
    local now = os.time()
    
    -- Check if 7 days (604,800 seconds) have passed
    if (now - acc.last_int) >= mmo_banking.config.interest_interval then
        if acc.balance >= mmo_banking.config.interest_min_balance then
            local gain = math.floor(acc.balance * mmo_banking.config.interest_rate)
            
            -- Apply Max Payout Cap
            if gain > mmo_banking.config.interest_max_payout then
                gain = mmo_banking.config.interest_max_payout
            end
            
            acc.balance = acc.balance + gain
            acc.last_int = now -- Reset the 7-day timer
            
            mmo_banking.save_account(name, acc)
            mmo_banking.log("SYSTEM", name, gain, 0, "Weekly Interest Payout")
            
            minetest.chat_send_player(name, "§a[Bank] You earned " .. gain .. " units in interest this week!")
        end
    end
end
