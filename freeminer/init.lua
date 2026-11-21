local modpath = minetest.get_modpath("freeminer")
local game = minetest.get_game_info and minetest.get_game_info() or {}
local has_default = minetest.get_modpath("default") and default
	and default.register_leafdecay and default.node_sound_stone_defaults
local has_mcl = minetest.get_modpath("mcl_core") and mcl_core

if has_default then
	if game.id ~= "default" then
		if default.weather == nil then
			default.weather = core.settings:get_bool("weather")
		end
		default.LIGHT_SUN = default.LIGHT_SUN or (default.LIGHT_MAX + 1)
	end
	if stairs then
		dofile(modpath .. "/fm_melt.lua")
	end
	if default.register_mgv6_ores and default.register_biomes and default.register_ores then
		dofile(modpath .. "/mapgen_edges.lua")
	end
	dofile(modpath .. "/nodes.lua")
	dofile(modpath .. "/ice_tree.lua")
	dofile(modpath .. "/lava_tree.lua")
	dofile(modpath .. "/deep_aquatic_plants.lua")
	dofile(modpath .. "/aquatic_plants.lua")
	if game.id ~= "default" then
		dofile(modpath .. "/fm_minetest_game.lua")
	end
elseif has_mcl then
	dofile(modpath .. "/fm_voxelibre.lua")
	dofile(modpath .. "/ice_tree.lua")
	dofile(modpath .. "/lava_tree.lua")
else
	minetest.log("warning", "[freeminer] No supported game adapter found; game-specific features are disabled")
end

dofile(modpath .. "/arnis_decals.lua")
dofile(modpath .. "/arnis_rails.lua")
dofile(modpath .. "/arnis_trains.lua")
