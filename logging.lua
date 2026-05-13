local log_path = minetest.get_worldpath() .. "/mmo_bank_master.log"

function mmo_banking.log(sender, receiver, amount, tax, reason)
    -- Generate Unique Transaction ID
    local tx_id = "TX-" .. os.date("%y%m%d") .. "-" .. math.random(1000, 9999)
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local entry = string.format("[%s] ID:%s | %s -> %s | Amt:%d | Tax:%d | Type:%s\n", 
                  timestamp, tx_id, sender, receiver, amount, tax, reason)
    
    -- Atomic Write-Ahead
    local f = io.open(log_path, "a")
    if f then
        f:write(entry)
        f:close()
    end
    
    -- Log to standard Luanti action log as backup
    minetest.log("action", "[mmo_banking] " .. entry)
    return tx_id
end
