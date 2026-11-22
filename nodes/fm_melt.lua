-- Preserve Freeminer's extra melt argument for subsequently registered stairs.
local shapes = {stair = 8, slab = 8, stair_inner = 9, stair_outer = 9}
for shape, melt_arg in pairs(shapes) do
	local key = "register_" .. shape
	local original = stairs[key]
	stairs[key] = function(...)
		local args = {...}
		local result = original(...)
		if args[melt_arg] then
			minetest.override_item("stairs:" .. shape .. "_" .. args[1], {melt = args[melt_arg]})
		end
		return result
	end
end
local original_combined = stairs.register_stair_and_slab
stairs.register_stair_and_slab = function(...)
	local args = {...}
	local result = original_combined(...)
	local melt = args[11]
	if melt then
		for shape in pairs(shapes) do
			minetest.override_item("stairs:" .. shape .. "_" .. args[1], {melt = melt})
		end
	end
	return result
end

local materials = {
	stone = 3000, cobble = 3000, mossycobble = 3000, stonebrick = 3000,
	stone_block = 3000, desert_stone = 3000, desert_cobble = 3000,
	desert_stonebrick = 3000, desert_stone_block = 3000, sandstone = 3000,
	sandstonebrick = 3000, sandstone_block = 3000, obsidian = 5000,
	obsidianbrick = 5000, obsidian_block = 5000, brick = 4000,
	steelblock = 1400, copperblock = 1084, bronzeblock = 1000,
	goldblock = 1063, ice = 3, snowblock = 3,
}
for material, temperature in pairs(materials) do
	for shape in pairs(shapes) do
		local name = "stairs:" .. shape .. "_" .. material
		local def = minetest.registered_nodes[name]
		if def then
			local groups = table.copy(def.groups)
			groups.melt = temperature
			if material == "snowblock" then groups.slippery = 2 end
			minetest.override_item(name, {groups = groups,
				melt = temperature == 3 and "default:water_source" or "default:lava_flowing"})
		end
	end
end
