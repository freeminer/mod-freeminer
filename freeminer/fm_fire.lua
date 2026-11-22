-- Compatibility entry point for Default Game registration-time hooks.
local path = minetest.get_modpath("freeminer_nodes")
if path then return dofile(path .. "/fm_fire.lua") end
return {register_stale_flame = function() end, register_hot_ignition = function() end}
