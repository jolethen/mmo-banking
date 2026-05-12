local S = minetest.get_mod_storage()
mmo_banking.cache = {}

function mmo_banking.load_account(name)
    if mmo_banking.cache[name] then return mmo_banking.cache[name] end
    local data = S:get_string(name)
    local acc = (data ~= "") and minetest.deserialize(data) or {
        balance = 0, status = "active", last_int = os.time(), last_act = 0
    }
    mmo_banking.cache[name] = acc
    return acc
end

function mmo_banking.save_account(name, data)
    mmo_banking.cache[name] = data
    S:set_string(name, minetest.serialize(data))
end
