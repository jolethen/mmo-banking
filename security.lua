mmo_banking.security = {}

-- Validates that a string is a safe, positive integer
function mmo_banking.security.is_valid_amount(val)
    local num = tonumber(val)
    if not num or num <= 0 or num % 1 ~= 0 then
        return false
    end
    return num
end

-- Checks if player has admin privileges
function mmo_banking.security.is_admin(name)
    return minetest.check_player_privs(name, {banker = true}) or minetest.check_player_privs(name, {server = true})
end

-- Prevents spamming bank actions
function mmo_banking.security.check_cooldown(name)
    local acc = mmo_banking.load_account(name)
    local now = os.clock()
    if now - acc.last_act < mmo_banking.config.cooldown then
        return false
    end
    acc.last_act = now -- Update timestamp
    return true
end
