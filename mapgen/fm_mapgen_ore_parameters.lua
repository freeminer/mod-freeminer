-- Apply only to the ores registered by default.register_ores.
local register_ore = minetest.register_ore
local parameters = {
	["default:stone_with_coal"] = {42, 0.2},
	["default:stone_with_iron"] = {43, 0.4},
	["default:stone_with_mese"] = {44, 0.7},
	["default:mese"] = {44, 0.7},
	["default:stone_with_gold"] = {45, 0.6},
	["default:stone_with_diamond"] = {46, 0.8},
	["default:stone_with_copper"] = {47, 0.5},
	["default:stone_with_tin"] = {48, 0.5},
}
minetest.register_ore = function(def)
	local param = parameters[def.ore]
	if param and def.ore_type == "scatter" and def.wherein == "default:stone" and
			(def.ore ~= "default:mese" or def.y_max ~= -2048) then
		def.noise_params = {offset = 0, scale = 1, spread = {x = 100, y = 100, z = 100},
			seed = param[1], octaves = 3, persist = 0.7}
		def.noise_threshold = def.ore == "default:stone_with_mese" and def.y_min == 1025
			and 1.0 or param[2]
		if (def.ore == "default:stone_with_gold" or def.ore == "default:stone_with_mese")
				and def.y_max < 0 then
			def.flags = "absheight"
		end
		if def.ore == "default:stone_with_diamond" and def.y_max == -2048 then
			def.clust_scarcity = 8 * 8 * 8
		end
	end
	return register_ore(def)
end
return function() minetest.register_ore = register_ore end
