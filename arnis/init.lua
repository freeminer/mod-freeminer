if minetest.get_modpath("freeminer") then return end
-- Standalone use has its own mod storage; the facade preserves legacy storage.
minetest.log("action", "[freeminer_arnis] Standalone mode uses freeminer_arnis mod storage")
local path = minetest.get_modpath("freeminer_arnis")
dofile(path .. "/arnis_decals.lua")
dofile(path .. "/arnis_rails.lua")
dofile(path .. "/arnis_trains.lua")
