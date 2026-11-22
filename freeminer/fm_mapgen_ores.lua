-- Compatibility entry point for Default Game registration-time hooks.
local path = minetest.get_modpath("freeminer_mapgen")
if path then return dofile(path .. "/fm_mapgen_ores.lua") end
return
