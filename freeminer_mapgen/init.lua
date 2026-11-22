if minetest.get_modpath("freeminer") then return end
if minetest.get_modpath("mcl_core") and rawget(_G, "mcl_core") then
	dofile(minetest.get_modpath("freeminer_mapgen") .. "/fm_voxelibre.lua")
	return
end
local default_api = rawget(_G, "default")
if not (default_api and default_api.register_mgv6_ores and default_api.register_biomes
		and default_api.register_ores) then return end
local path = minetest.get_modpath("freeminer_mapgen")
dofile(path .. "/mapgen_edges.lua")
-- The node adapter installs these when it is present.
if not minetest.get_modpath("freeminer_nodes") then
	dofile(path .. "/fm_mapgen_layers.lua")
	local mg_name = minetest.get_mapgen_setting("mg_name")
	if mg_name ~= "v6" and mg_name ~= "indev" then
		local original = minetest.register_ore
		local min_edge, max_edge = minetest.get_mapgen_edges()
		minetest.register_ore = function(def)
			if def.y_min == -31000 then def.y_min = min_edge.y end
			if def.y_max == 31000 then def.y_max = max_edge.y end
			return original(def)
		end
		local ok, err = pcall(dofile, path .. "/fm_mapgen_ores.lua")
		minetest.register_ore = original
		if not ok then error(err) end
	end
end
