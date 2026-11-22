-- VoxeLibre uses its own node names and gameplay APIs. Only adapt nodes that
-- exist, retaining all game-specific callbacks, groups, and drops.
local function update(name, extra_groups, extra_fields)
	local def = minetest.registered_nodes[name]
	if not def then return end
	local groups = table.copy(def.groups or {})
	for key, value in pairs(extra_groups or {}) do groups[key] = value end
	local fields = {groups = groups}
	for key, value in pairs(extra_fields or {}) do fields[key] = value end
	minetest.override_item(name, fields)
end

for _, name in ipairs({"stone", "cobble", "stonebrick", "sandstone"}) do
	update("mcl_core:" .. name, {melt = 3000}, {melt = "mcl_core:lava_source"})
end
update("mcl_core:obsidian", {melt = 5000}, {melt = "mcl_core:lava_source"})
update("mcl_core:dirt", {melt = 50, liquid_drop = 1, weight = 2000},
	{melt = "mcl_core:coarse_dirt"})
local disabled = tonumber(core.settings:get("flowing_sand_disable") or 0) or 0
for name, weight in pairs({sand = 2000, redsand = 2001, gravel = 2000}) do
	local fields = {drowning = 1}
	if disabled ~= 1 then
		fields.leveled = 1
		fields.liquidtype = "source"
		fields.paramtype2 = "leveled"
	end
	update("mcl_core:" .. name, {liquid_drop = disabled >= 1 and 0 or 1, weight = weight}, fields)
end
update("mcl_core:clay", {melt = 50, weight = 2000}, {melt = "mcl_core:stone"})
update("mcl_core:ice", {melt = 3}, {melt = "mcl_core:water_source"})
update("mcl_core:snowblock", {melt = 2, slippery = 2}, {melt = "mcl_core:water_source"})
update("mcl_core:water_source", {freeze = -1, melt = 105, liquid_drop = 1, weight = 1000,
	pressure = 64, tnt_melt_level_multiplier = 8},
	{freeze = "mcl_core:ice"})
update("mcl_core:water_flowing", {freeze = -5, melt = 100, liquid_drop = 1, weight = 1000,
	pressure = 64, tnt_melt_level_multiplier = 8},
	{freeze = "mcl_core:snow"})
update("mcl_core:lava_source", {hot = 1200, wield_light = 5, liquid_drop = 1,
	weight = 2000, pressure = 24}, {freeze = "mcl_core:obsidian"})
update("mcl_core:lava_flowing", {hot = 700, wield_light = 2, liquid_drop = 1,
	weight = 2000, pressure = 24}, {freeze = "mcl_core:stone"})

if minetest.get_modpath("mcl_stairs") and rawget(_G, "mcl_stairs") then
	dofile(minetest.get_modpath("freeminer_nodes") .. "/fm_voxelibre_melt.lua")
end

for _, pair in ipairs({{"tree", "leaves"}, {"darktree", "darkleaves"},
	{"jungletree", "jungleleaves"}, {"acaciatree", "acacialeaves"},
	{"sprucetree", "spruceleaves"}, {"birchtree", "birchleaves"}}) do
	local trunk, leaves = "mcl_core:" .. pair[1], "mcl_core:" .. pair[2]
	if minetest.registered_nodes[trunk] and minetest.registered_nodes[leaves] then
		update(trunk, {grow_tree = 1, tree_liquid_water = 1}, {liquid_alternative_source = leaves})
		update(leaves, {grow_leaves = 1, leaves_die_under_falling_node = 1,
			leaves_die_under_soil = 1, ["leaves_die_under_mcl_core:water_source"] = 1,
			fall_damage_add_percent = -40})
	end
end
for _, name in ipairs({"mcl_fire:fire", "mcl_fire:eternal_fire"}) do
	update(name, {hot = 200, wield_light = 13, drop_by_liquid = 1}, {waving = 1})
end

if minetest.get_modpath("mcl_fire") and minetest.registered_nodes["mcl_fire:fire"] then
	dofile(minetest.get_modpath("freeminer_nodes") .. "/fm_voxelibre_fire.lua")
end

-- Preserve VoxeLibre's existing plank target while applying Freeminer yields.
for _, trunk in ipairs({"tree", "darktree", "jungletree", "acaciatree", "sprucetree", "birchtree"}) do
	local name = "mcl_core:" .. trunk
	local result = minetest.get_craft_result({method = "normal", width = 1, items = {name}})
	if result and result.item and result.item:get_count() == 4 then
		minetest.register_craft({output = result.item:get_name() .. " 8", recipe = {{name}}})
	end
end
minetest.register_craft({output = "mcl_core:sandstone 2", recipe = {
	{"mcl_core:sand", "mcl_core:sand"}, {"mcl_core:sand", "mcl_core:sand"},
}})
minetest.register_craft({output = "mcl_core:sand 2", recipe = {{"mcl_core:sandstone"}}})

-- Apply the remaining game-specific node properties after the shared overrides.
dofile(minetest.get_modpath("freeminer_nodes") .. "/fm_voxelibre_nodes.lua")
