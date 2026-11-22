-- The facade loads these after all game mods when it is enabled.
if minetest.get_modpath("freeminer") then return end
local default_api = rawget(_G, "default")
if not ((default_api and default_api.register_leafdecay and default_api.node_sound_stone_defaults)
		or (minetest.get_modpath("mcl_core") and rawget(_G, "mcl_core"))) then
	minetest.log("warning", "[freeminer_trees] No supported game adapter found")
	return
end
local path = minetest.get_modpath("freeminer_trees")
dofile(path .. "/ice_tree.lua")
dofile(path .. "/lava_tree.lua")
