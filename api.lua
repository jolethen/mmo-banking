function mmo_banking.transfer(sender_name, receiver_name, amount, reason)
    local amount = math.floor(amount)
    if amount < mmo_banking.config.min_trans then return false, "Invalid amount" end

    local s = mmo_banking.load_account(sender_name)
    local r = mmo_banking.load_account(receiver_name)

    if s.status ~= "active" then return false, "Account is " .. s.status end
    
    local tax = math.floor(amount * mmo_banking.config.tax_rate)
    local total = amount + tax

    if s.balance < total then return false, "Insufficient funds (inc. 2% tax)" end
    if (r.balance + amount) > mmo_banking.config.max_balance then return false, "Limit exceeded" end

    -- ATOMIC SWAP
    s.balance = s.balance - total
    r.balance = r.balance + amount
    
    -- Server Fund (Taxes)
    local f = mmo_banking.load_account(mmo_banking.config.server_fund)
    f.balance = f.balance + tax

    mmo_banking.log(sender_name, receiver_name, amount, tax, reason)
    mmo_banking.save_account(sender_name, s)
    mmo_banking.save_account(receiver_name, r)
    mmo_banking.save_account(mmo_banking.config.server_fund, f)
    
    return true
end
