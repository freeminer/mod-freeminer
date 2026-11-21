-- Freeminer additions to the fire mod.
for _, name in ipairs({"fire:basic_flame", "fire:permanent_flame"}) do
	local groups = table.copy(minetest.registered_nodes[name].groups)
	groups.hot = 200
	groups.wield_light = 13
	groups.drop_by_liquid = 1
	minetest.override_item(name, {groups = groups, waving = 1})
end

local fm_fire = {}
function fm_fire.register_stale_flame()
	minetest.register_abm({
		label = "Remove stale flame",
		nodenames = {"fire:basic_flame"},
		neighbors = "air",
		interval = 600,
		chance = 10,
		catch_up = false,
		action = function(pos, node, active_object_count, active_object_count_wider)
			minetest.remove_node(pos)
		end
	})
end

function fm_fire.register_hot_ignition()
-- too hot
if default.weather then
minetest.register_abm({
	nodenames = {"group:flammable"},
	interval = 5,
	chance = 5,
	action = function(p0, node, _, _)
		-- If there is water or stuff like that around flame, don't ignite
		if core.get_heat(p0) < 500 then return end

		if default.weather then
			local humidity = core.get_humidity(p0)
			if humidity > 55 and math.random(55, humidity) >= 60 then
				return
			end
		end

		if minetest.find_node_near(p0, 1, {"group:puts_out_fire"}) then
			return
		end

		--local p = fire.find_pos_for_flame_around(p0)
		local p = minetest.find_node_near(p0, 1, {"air"})
		if p then
			minetest.set_node(p, {name="fire:basic_flame"})
			fire.update_sounds_around(p)
		end
	end,
})
end


end

return fm_fire
