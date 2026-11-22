-- Additional Freeminer node properties for the VoxeLibre game.
local function update(name, extra_groups, fields)
	local def = core.registered_nodes[name]
	if not def then return end
	local groups = table.copy(def.groups or {})
	for key, value in pairs(extra_groups or {}) do groups[key] = value end
	local changes = {groups = groups}
	for key, value in pairs(fields or {}) do changes[key] = value end
	core.override_item(name, changes)
end

-- Unlike the sky clouds, this node is the physical steam produced by hot water.
if not core.registered_nodes["freeminer:steam"] then
	local texture = "[fill:16x16:#e1f0ff40"
	core.register_node(":freeminer:steam", {
		description = "Steam", drawtype = "liquid", tiles = {texture},
		special_tiles = {{name = texture, backface_culling = false},
			{name = texture, backface_culling = true}},
		use_texture_alpha = "blend", paramtype = "light", paramtype2 = "leveled",
		walkable = false, pointable = false, diggable = false,
		sunlight_propagates = true, buildable_to = true, floodable = true,
		liquidtype = "source", liquid_alternative_flowing = "freeminer:steam",
		liquid_alternative_source = "freeminer:steam", liquid_viscosity = 1,
		liquid_renewable = false, liquid_range = 8, leveled = 8,
		groups = {cloud = 1, gas = 1, steam = 1, weight = -100,
			float_height = tonumber(core.settings:get("cloud_height")) or 500,
			freeze = -60, melt = 120, not_in_creative_inventory = 1},
		freeze = "air", melt = "air", post_effect_color = {a = 24, r = 225, g = 240, b = 245},
	})
end
if not core.registered_nodes["freeminer:lamp_red"] then
	local sound_api = rawget(_G, "mcl_sounds")
	core.register_node(":freeminer:lamp_red", {
		description = core.get_translator("freeminer_nodes")("Red Lamp"),
		drawtype = "glasslike", tiles = {"mcl_nether_glowstone.png"}, color = "#ff0000",
		paramtype = "light", sunlight_propagates = true, is_ground_content = false,
		groups = {pickaxey = 1, handy = 1},
		sounds = sound_api and sound_api.node_sound_glass_defaults(),
		light_source = core.LIGHT_MAX or 14,
	})
end
for _, name in ipairs({"mcl_core:water_source", "mcl_core:water_flowing"}) do
	update(name, nil, {melt = "freeminer:steam"})
end

for _, name in ipairs({"stone_smooth", "stonebrickcarved", "stonebrickcracked",
	"sandstonesmooth", "sandstonecarved", "sandstonesmooth2", "redsandstone",
	"redsandstonesmooth", "redsandstonecarved", "redsandstonesmooth2"}) do
	update("mcl_core:" .. name, {melt = 3000}, {melt = "mcl_core:lava_source"})
end
update("mcl_core:mossycobble", {melt = 200}, {melt = "mcl_core:cobble"})
update("mcl_core:brick_block", {melt = 3500}, {melt = "mcl_core:lava_source"})
update("mcl_core:clay", {melt = 1500, fall_damage_add_percent = -10}, {melt = "mcl_core:stone"})
local disabled = tonumber(core.settings:get("flowing_sand_disable") or 0) or 0
local dirt_fields = {drowning = 1}
if disabled ~= 1 then
	dirt_fields.leveled = 1
	dirt_fields.liquidtype = "source"
	dirt_fields.paramtype2 = "leveled"
end
update("mcl_core:dirt", {fall_damage_add_percent = -20,
	liquid_drop = disabled >= 1 and 0 or 1}, dirt_fields)
update("mcl_core:dirt_with_grass", {melt = 51, freeze = -5, fall_damage_add_percent = -10},
	{melt = "mcl_core:coarse_dirt", freeze = "mcl_core:dirt_with_grass_snow", drowning = 1})
update("mcl_core:dirt_with_grass_snow", {melt = 2, slippery = 2, fall_damage_add_percent = -10},
	{melt = "mcl_core:dirt", drowning = 1})
for _, name in ipairs({"mcl_core:sand", "mcl_core:redsand"}) do
	update(name, {fall_damage_add_percent = -30})
end
update("mcl_core:gravel", {fall_damage_add_percent = -5})
for i = 1, 8 do
	local name = i == 1 and "mcl_core:snow" or "mcl_core:snow_" .. i
	update(name, {melt = 1, float = 1, slippery = 2, fall_damage_add_percent = -70},
		{melt = "mcl_core:water_flowing"})
end
update("mcl_core:snowblock", {fall_damage_add_percent = -30})
for _, name in ipairs({"mcl_farming:soil", "mcl_farming:soil_wet"}) do
	local disabled = tonumber(core.settings:get("flowing_sand_disable") or 0) or 0
	update(name, {melt = 55, weight = 2000, liquid_drop = disabled >= 1 and 0 or 1},
		{melt = "mcl_core:coarse_dirt"})
end

local tree_groups = {
	jungletree = {tree_water_max = 65, tree_get_water_max_from_humidity = 36,
		tree_grow_heat_min = 19, tree_grow_heat_max = 49, leaves_water_max = 30,
		leaves_grow_heat_min = 19, leaves_grow_heat_max = 49, tree_branch_chance = 20,
		tree_branch_water_min = 30, tree_branch_spacing = 3, tree_branch_cost = 3},
	sprucetree = {tree_water_max = 65, tree_grow_heat_min = 3, leaves_water_max = 10,
		leaves_grow_prefer_top = 1, leaves_die_heat_max = 0},
	acaciatree = {tree_water_max = 40, tree_get_water_from_humidity = 15,
		tree_get_water_max_from_humidity = 12, tree_grow_water_min = 3, tree_grow_heat_min = 18,
		tree_grow_heat_max = 55, tree_grow_light_max = 13, tree_branch_chance = 12,
		tree_branch_water_min = 8, tree_branch_spacing = 2, tree_branch_cost = 2,
		leaves_water_max = 14, leaves_grow_light_min = 10, leaves_grow_water_min_top = 4,
		leaves_grow_water_min_side = 2, leaves_grow_heat_min = 18, leaves_grow_heat_max = 55,
		leaves_die_light_max = 9},
}
for name, groups in pairs(tree_groups) do update("mcl_core:" .. name, groups) end
update("mcl_core:jungleleaves", {leaves_water_max = 30, leaves_grow_heat_min = 19,
	leaves_grow_heat_max = 49, leaves_die_heat_min = 60})
update("mcl_core:spruceleaves", {leaves_water_max = 10, leaves_grow_prefer_top = 1,
	leaves_die_heat_max = 0, fall_damage_add_percent = -20})
update("mcl_core:acacialeaves", {tree_get_water_from_humidity = 15, leaves_water_max = 14,
	leaves_grow_light_min = 10, leaves_grow_water_min_top = 4, leaves_grow_water_min_side = 2,
	leaves_grow_heat_min = 18, leaves_grow_heat_max = 55, leaves_die_light_max = 9,
	fall_damage_add_percent = -30})
update("mcl_core:apple", {fruit = 1})
update("mcl_core:cactus", {grow_tree = 1, tree_liquid_water = 1,
	tree_get_water_from_humidity = 40, leaves_grow_light_min = 13,
	tree_grow_light_max = 15, tree_grow_chance = 30, tree_water_max = 6,
	tree_grow_water_min = 2, tree_grow_heat_min = 20, tree_grow_heat_max = 40,
	tree_grow_bottom = 0, tree_branch_chance = 0, tree_width_to_height = 0})
update("mcl_core:deadbush", {drop_by_liquid = 1, falling_node = 1})

for _, name in ipairs({"mcl_torches:torch", "mcl_torches:torch_wall"}) do
	update(name, {hot = 39, wield_light = (core.LIGHT_MAX or 14) - 1, drop_by_liquid = 1})
end
update("mcl_nether:glowstone", {wield_light = core.LIGHT_MAX or 14, hot = 30})

-- Explicit resistance is used by Freeminer's native TNT blast solver.
local resistance = {
	stone = 6, cobble = 5.5, stonebrick = 6.5, mossycobble = 4.5, sandstone = 4,
	obsidian = 35, dirt = 1.2, dirt_with_grass = 1.2, dirt_with_grass_snow = 1.3,
	sand = 1, redsand = 1.1, gravel = 1.5, clay = 1.7, snow = 0.2, snowblock = 0.8,
	ice = 1.5, tree = 2.6, jungletree = 2.8, sprucetree = 2.6, acaciatree = 3,
	leaves = 0.8, jungleleaves = 0.9, spruceleaves = 0.7, acacialeaves = 0.8,
	stone_with_coal = 6.5, stone_with_iron = 7, stone_with_gold = 8,
	stone_with_diamond = 12, coalblock = 4.5, ironblock = 16, goldblock = 10,
	diamondblock = 24, cactus = 1.2, water_source = 0.25, water_flowing = 0.2,
	lava_source = 1.5, lava_flowing = 1.2, brick_block = 5,
}
for name, value in pairs(resistance) do update("mcl_core:" .. name, nil, {tnt_resistance = value}) end

-- Reeds use param2 for their biome palette, so keep native growth handling.
update("mcl_core:reeds", {drop_by_liquid = 1})
