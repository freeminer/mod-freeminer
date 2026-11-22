-- Fix the upstream mapgen alias after redirecting river water.
minetest.register_alias_force("mapgen_river_water_source", "default:water_source")

-- Features normally installed by the Default Game's registration-time hooks.
-- Later recipes take priority without deleting recipes registered by other mods.
for _, pair in ipairs({
	{"default:tree", "default:wood"},
	{"default:jungletree", "default:junglewood"},
	{"default:pine_tree", "default:pine_wood"},
	{"default:acacia_tree", "default:acacia_wood"},
	{"default:aspen_tree", "default:aspen_wood"},
}) do
	minetest.register_craft({output = pair[2] .. " 8", recipe = {{pair[1]}}})
end
minetest.register_craft({output = "default:sandstone 2", recipe = {
	{"default:sand", "default:sand"}, {"default:sand", "default:sand"},
}})
minetest.register_craft({output = "default:sand 2", recipe = {{"default:sandstone"}}})

local mapgen_path = minetest.get_modpath("freeminer") or minetest.get_modpath("freeminer_mapgen")
if mapgen_path then dofile(mapgen_path .. "/fm_mapgen_layers.lua") end

-- The original game registers these after its regular ores. Respect the
-- current world's bounds when installing them after Minetest Game's mapgen.
local mg_name = minetest.get_mapgen_setting("mg_name")
if mapgen_path and mg_name ~= "v6" and mg_name ~= "indev" then
	local register_ore = minetest.register_ore
	local min_edge, max_edge = minetest.get_mapgen_edges()
	minetest.register_ore = function(def)
		if def.y_min == -31000 then def.y_min = min_edge.y end
		if def.y_max == 31000 then def.y_max = max_edge.y end
		return register_ore(def)
	end
	local ok, err = pcall(dofile, mapgen_path .. "/fm_mapgen_ores.lua")
	minetest.register_ore = register_ore
	if not ok then error(err) end
end

if minetest.get_modpath("fire") and minetest.registered_nodes["fire:basic_flame"] then
	local fm_fire = dofile((minetest.get_modpath("freeminer") or minetest.get_modpath("freeminer_nodes")) .. "/fm_fire.lua")
	local enabled = minetest.settings:get("enable_fire") or "auto"
	if enabled == "auto" then
		enabled = minetest.is_singleplayer() and not minetest.settings:get_bool("disable_fire")
	else
		enabled = minetest.is_yes(enabled)
	end
	if enabled then
		for _, abm in ipairs(minetest.registered_abms) do
			if abm.mod_origin == "fire" and abm.label == "Ignite flame" then
				local action = abm.action
				abm.action = function(pos, ...)
					if default.weather then
						local humidity = core.get_humidity(pos)
						if math.random(0, humidity) >= 5 then return end
					end
					return action(pos, ...)
				end
			end
		end
		fm_fire.register_stale_flame()
	end
	fm_fire.register_hot_ignition()
end
