local path = minetest.get_worldpath() .. "/bank_journal.log"

function mmo_banking.log(s, r, amt, tax, reason)
    local id = "TXN-" .. os.time() .. "-" .. math.random(100, 999)
    local entry = string.format("[%s] %s | %s -> %s | %d (Tax: %d) | %s\n",
        os.date("%Y-%m-%d %H:%M"), id, s, r, amt, tax, reason)
    
    local f = io.open(path, "a")
    if f then f:write(entry) f:close() end
    minetest.log("action", "[mmo_banking] " .. entry)
    return id
end
