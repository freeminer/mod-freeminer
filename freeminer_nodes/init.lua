if minetest.get_modpath("freeminer") then return end
local path = minetest.get_modpath("freeminer_nodes")
local default_api = rawget(_G, "default")
if default_api and default_api.node_sound_stone_defaults then
	if default_api.weather == nil then default_api.weather = core.settings:get_bool("weather") end
	default_api.LIGHT_SUN = default_api.LIGHT_SUN or (default_api.LIGHT_MAX + 1)
	if rawget(_G, "stairs") then dofile(path .. "/fm_melt.lua") end
	dofile(path .. "/nodes.lua")
	dofile(path .. "/fm_minetest_game.lua")
elseif minetest.get_modpath("mcl_core") and rawget(_G, "mcl_core") then
	dofile(path .. "/fm_voxelibre.lua")
else
	minetest.log("warning", "[freeminer_nodes] No supported game adapter found")
end
