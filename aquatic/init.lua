if minetest.get_modpath("freeminer") then return end
local default_api = rawget(_G, "default")
if not (default_api and default_api.node_sound_stone_defaults) then
	minetest.log("warning", "[freeminer_aquatic] Requires a Default-compatible game")
	return
end
local path = minetest.get_modpath("freeminer_aquatic")
dofile(path .. "/deep_aquatic_plants.lua")
dofile(path .. "/aquatic_plants.lua")
