-- Compatibility entry point for Default Game registration-time hooks.
local path = minetest.get_modpath("freeminer_nodes")
if path then return dofile(path .. "/fm_crafting.lua") end
return dofile(minetest.get_modpath("default") .. "/crafting.lua")
