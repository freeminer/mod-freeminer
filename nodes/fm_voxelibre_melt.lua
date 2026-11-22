-- VoxeLibre's stair API uses different names and does not copy melt targets.
local shapes = {
	stair = {"", "_inner", "_outer"},
	slab = {"", "_top", "_double"},
}

local function apply(shape, subname, temperature, target, slippery)
	for _, suffix in ipairs(shapes[shape]) do
		local name = "mcl_stairs:" .. shape .. "_" .. subname .. suffix
		local def = minetest.registered_nodes[name]
		if def then
			local groups = table.copy(def.groups or {})
			groups.melt = temperature
			if slippery then groups.slippery = slippery end
			minetest.override_item(name, {groups = groups, melt = target})
		end
	end
end

-- These stairs and slabs are registered by VoxeLibre before this adapter loads.
local materials = {
	stone_rough = 3000, stone = 3000, cobble = 3000, mossycobble = 3000,
	stonebrick = 3000, stonebrickmossy = 3000, sandstone = 3000,
	sandstonesmooth2 = 3000, redsandstone = 3000, redsandstonesmooth2 = 3000,
	brick_block = 4000, obsidian = 5000, obsidianbrick = 5000,
	steelblock = 1400, ironblock = 1400, copperblock = 1084, bronzeblock = 1000,
	goldblock = 1063, gold_polished = 1063, ice = 3, snowblock = 3,
}
for subname, temperature in pairs(materials) do
	for shape in pairs(shapes) do
		local frozen = subname == "ice" or subname == "snowblock"
		apply(shape, subname, temperature, frozen and "mcl_core:water_source"
			or "mcl_core:lava_flowing", subname == "snowblock" and 2 or nil)
	end
end

-- Later registrations inherit the melt properties of their actual source node.
-- Combined and simple registrations call these two functions internally.
for shape in pairs(shapes) do
	local key = "register_" .. shape
	local original = mcl_stairs[key]
	if original then
		mcl_stairs[key] = function(subname, source, ...)
			local results = {n = 0}
			local function capture(...) results = {n = select("#", ...), ...} end
			capture(original(subname, source, ...))
			local def = minetest.registered_nodes[source or ""]
			local temperature = def and def.groups and def.groups.melt
			if temperature and temperature ~= 0 and def.melt and def.melt ~= "" then
				apply(shape, subname, temperature, def.melt)
			end
			return unpack(results, 1, results.n)
		end
	end
end
