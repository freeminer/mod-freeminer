-- Load enabled feature modules here when the compatibility facade is present.
-- Default Game requires this mod last, which preserves legacy namespaces,
-- mapgen registration order and the freeminer mod-storage database.
local function feature(name, file)
	local path = minetest.get_modpath(name)
	if path then return dofile(path .. "/" .. file) end
end

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
	if stairs then feature("freeminer_nodes", "fm_melt.lua") end
	if default.register_mgv6_ores and default.register_biomes and default.register_ores then
		feature("freeminer_mapgen", "mapgen_edges.lua")
	end
	feature("freeminer_nodes", "nodes.lua")
	feature("freeminer_trees", "ice_tree.lua")
	feature("freeminer_trees", "lava_tree.lua")
	feature("freeminer_aquatic", "deep_aquatic_plants.lua")
	feature("freeminer_aquatic", "aquatic_plants.lua")
	if game.id ~= "default" then
		feature("freeminer_nodes", "fm_minetest_game.lua")
	end
elseif has_mcl then
	feature("freeminer_mapgen", "fm_voxelibre.lua")
	feature("freeminer_nodes", "fm_voxelibre.lua")
	feature("freeminer_trees", "ice_tree.lua")
	feature("freeminer_trees", "lava_tree.lua")
else
	minetest.log("warning", "[freeminer] No supported game adapter found; game-specific features are disabled")
end

feature("freeminer_arnis", "arnis_decals.lua")
feature("freeminer_arnis", "arnis_rails.lua")
feature("freeminer_arnis", "arnis_trains.lua")
