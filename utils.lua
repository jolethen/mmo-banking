mmo_banking.utils = {}

-- Formats numbers with commas (e.g., 1,000,000)
function mmo_banking.utils.format_money(amount)
    local formatted = tostring(amount)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then break end
    end
    return formatted
end

-- Simple player check
function mmo_banking.utils.player_exists(name)
    return minetest.player_exists(name)
end
