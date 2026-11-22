-- Add Freeminer's heat ignition using VoxeLibre's own fire placement API.
-- VoxeLibre already ages and extinguishes flames, so it needs no stale-fire ABM.
if not core.settings:get_bool("enable_fire", true)
		or not core.settings:get_bool("weather")
		or not core.get_heat or not core.get_humidity
		or not mcl_fire or not mcl_fire.set_fire then
	return
end

local function fire_ticks_enabled()
	local settings = rawget(_G, "vl_tuning") and vl_tuning.registered_settings
	local rule = settings and settings["gamerule:doFireTick"]
	return not rule or not rule.getter or rule.getter()
end

core.register_abm({
	label = "Freeminer heat ignition",
	nodenames = {"group:flammable"},
	interval = 5,
	chance = 5,
	action = function(pos)
		if not fire_ticks_enabled() or core.get_heat(pos) < 500 then return end
		local humidity = core.get_humidity(pos)
		if humidity > 55 and math.random(55, math.floor(humidity)) >= 60 then return end
		if core.find_node_near(pos, 1, {"group:puts_out_fire"}) then return end
		local air = core.find_node_near(pos, 1, {"air"})
		if air then mcl_fire.set_fire({type = "node", under = pos, above = air}) end
	end,
})
