-- Keep native game node names and sounds at the boundary of the TNT mod.
local default_api = rawget(_G, "default")
local mcl_sounds_api = rawget(_G, "mcl_sounds")
local voxelibre = minetest.get_modpath("mcl_core") ~= nil and not default_api
local sounds = voxelibre and mcl_sounds_api or default_api
local function node_sound(kind)
	local fn = sounds and sounds["node_sound_" .. kind .. "_defaults"]
	return fn and fn() or {}
end
local function log_player_action(player, ...)
	if default_api and default_api.log_player_action then
		return default_api.log_player_action(player, ...)
	end
	local parts = {...}
	for i, value in ipairs(parts) do
		parts[i] = type(value) == "table" and minetest.pos_to_string(value) or tostring(value)
	end
	minetest.log("action", player:get_player_name() .. " " .. table.concat(parts, " "))
end
return {
	voxelibre = voxelibre,
	light_max = default_api and default_api.LIGHT_MAX or minetest.LIGHT_MAX or 14,
	fire = voxelibre and "mcl_fire:fire" or "fire:basic_flame",
	lava_source = voxelibre and "mcl_core:lava_source" or "default:lava_source",
	lava_flowing = voxelibre and "mcl_core:lava_flowing" or "default:lava_flowing",
	coal = voxelibre and "mcl_core:coal_lump" or "default:coal_lump",
	gravel = voxelibre and "mcl_core:gravel" or "default:gravel",
	paper = voxelibre and "mcl_core:paper" or "default:paper",
	diamondblock = voxelibre and "mcl_core:diamondblock" or "default:diamondblock",
	leaves_sounds = node_sound("leaves"), wood_sounds = node_sound("wood"),
	is_torch = function(name)
		return name == "default:torch" or voxelibre and minetest.get_item_group(name, "torch") > 0
	end,
	log_player_action = log_player_action,
}
