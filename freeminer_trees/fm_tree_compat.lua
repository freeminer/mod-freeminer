-- Game-specific materials used by Freeminer's ice and lava trees.
local default = rawget(_G, "default")
if default then
	return {
		snow = "default:snow", snowblock = "default:snowblock", ice = "default:ice",
		cave_ice = "default:cave_ice", water_source = "default:water_source",
		water_flowing = "default:water_flowing", stone = "default:stone",
		obsidian = "default:obsidian", desert_stone = "default:desert_stone",
		sandstone = "default:sandstone", ore_pattern = "^default:stone_with_",
		crystal_texture = "default_mese_crystal.png",
		lava_texture = "default_lava_source_animated.png",
		sounds = default, register_leafdecay = default.register_leafdecay,
	}
end

local function register_leafdecay(def)
	for _, trunk in ipairs(def.trunks) do
		local old = minetest.registered_nodes[trunk].after_destruct
		minetest.override_item(trunk, {after_destruct = function(pos, node)
			if old then old(pos, node) end
			local radius = def.radius
			local leaves = minetest.find_nodes_in_area(vector.subtract(pos, radius),
				vector.add(pos, radius), def.leaves)
			for _, leafpos in ipairs(leaves) do
				if minetest.get_node(leafpos).param2 ~= 1 then
					local timer = minetest.get_node_timer(leafpos)
					if not timer:is_started() then timer:start(math.random(20, 120) / 10) end
				end
			end
		end})
	end
	for _, leaf in ipairs(def.leaves) do
		minetest.override_item(leaf, {on_timer = function(pos)
			if minetest.find_node_near(pos, def.radius, def.trunks) then return false end
			local node = minetest.get_node(pos)
			for _, item in ipairs(minetest.get_node_drops(node.name)) do
				if item ~= node.name or minetest.get_item_group(item, "leafdecay_drop") ~= 0 then
					minetest.add_item(pos, item)
				end
			end
			minetest.remove_node(pos)
			minetest.check_for_falling(pos)
			return false
		end})
	end
end
return {
	lava_min_y = mcl_vars.mg_overworld_min, lava_max_y = mcl_vars.mg_overworld_min + 32,
	snow = "mcl_core:snow", snowblock = "mcl_core:snowblock", ice = "mcl_core:ice",
	cave_ice = "mcl_core:packed_ice", water_source = "mcl_core:water_source",
	water_flowing = "mcl_core:water_flowing", stone = "mcl_core:stone",
	obsidian = "mcl_core:obsidian", desert_stone = "mcl_core:redsandstone",
	sandstone = "mcl_core:sandstone", ore_pattern = "^mcl_core:stone_with_",
	crystal_texture = "default_diamond.png", lava_texture = "mcl_core_lava_source_animation.png",
	sounds = mcl_sounds, register_leafdecay = register_leafdecay,
}
