dofile(core.get_modpath("weather") .. "/fm_voxelibre_ecology.lua")
-- VoxeLibre has its own node names, layered snow, and weather controller.
if core.settings:get_bool("liquid_real") then
	dofile(core.get_modpath("weather") .. "/erosion.lua")
end

-- The native controller supplies particles, snow, cauldrons and farmland
-- hydration. Do not run a second independent precipitation system over it.
if weather.game.native_weather then return end

local bounds = rawget(_G, "mcl_vars") or {}
local function above(pos)
	return {x = pos.x, y = pos.y + 1, z = pos.z}
end

-- VoxeLibre snow uses separate node names for each layer, not param2 levels.
core.register_abm({
	label = "Freeminer weather snow accumulation",
	nodenames = {"group:opaque", "group:leaves", "group:snow_cover", "group:top_snow"},
	neighbors = {"air"},
	interval = 10,
	chance = 50,
	catch_up = true,
	min_y = bounds.mg_overworld_min,
	max_y = bounds.mg_overworld_max,
	action = function(pos, node)
		local top = above(pos)
		if not weather.exposed_to_sky(top, 1) then return end
		local strength = get_snow(pos, 1)
		if strength <= 0 or math.random() >= math.min(1, strength) then return end
		local layer = core.get_item_group(node.name, "top_snow")
		if layer > 0 then
			local next_name = layer >= 8 and "mcl_core:snowblock" or "mcl_core:snow_" .. (layer + 1)
			if core.registered_nodes[next_name] then core.set_node(pos, {name = next_name}) end
		elseif node.name ~= "mcl_core:snowblock" then
			core.set_node(top, {name = "mcl_core:snow"})
		end
	end,
})

if core.settings:get_bool("liquid_real") then
	core.register_abm({
		label = "Freeminer weather rain accumulation",
		nodenames = {"group:opaque", "group:leaves"},
		neighbors = {"air"},
		interval = 15,
		chance = 50,
		catch_up = true,
		min_y = bounds.mg_overworld_min,
		max_y = bounds.mg_overworld_max,
		action = function(pos)
			local top = above(pos)
			if not weather.exposed_to_sky(top) then return end
			local strength = get_rain(pos, 1)
			if strength > 0 and math.random() < math.min(1, strength) then
				core.set_node(top, {name = "mcl_core:water_flowing", param2 = 1})
			end
		end,
	})
end
