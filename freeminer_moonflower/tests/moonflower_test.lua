local original_random = math.random
local function run(game, sun_override)
	local dirt = game == "default" and "default:dirt_with_grass" or "mcl_core:dirt_with_grass"
	local nodes = {[dirt] = {}}
	local positions = {}
	local generated, abm
	local time, sunlight = 0.5, 15
	local function key(p) return p.x .. "," .. p.y .. "," .. p.z end
	_G.default = game == "default" and {
		LIGHT_MAX = 14, LIGHT_SUN = sun_override,
		node_sound_leaves_defaults = function() return {kind = "default"} end,
	} or nil
	_G.mcl_sounds = game == "mcl" and {
		node_sound_leaves_defaults = function() return {kind = "mcl"} end,
	} or nil
	_G.minetest = {
		LIGHT_MAX = 14, registered_nodes = nodes,
		register_node = function(name, def) nodes[name:gsub("^:", "")] = def end,
		register_abm = function(def) abm = def end,
		register_on_generated = function(fn) generated = fn end,
		get_timeofday = function() return time end,
		get_node_light = function() return sunlight end,
		get_node = function(pos)
			return positions[key(pos)] or {name = pos.y == 0 and dirt or "air"}
		end,
		set_node = function(pos, node) positions[key(pos)] = node end,
		swap_node = function(pos, node) positions[key(pos)] = node end,
	}
	math.random = function(a) if a == nil then return 0 end return a end
	dofile("mods/freeminer_moonflower/init.lua")
	assert(nodes["flowers:moonflower_closed"].sounds.kind == game)
	generated({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0}, 1)
	local pos = {x = 0, y = 1, z = 0}
	assert(minetest.get_node(pos).name == "flowers:moonflower_closed", game .. " generation")
	time = 0.9
	abm.action(pos, minetest.get_node(pos))
	assert(minetest.get_node(pos).name == "flowers:moonflower_open", game .. " open")
	time = 0.5
	abm.action(pos, minetest.get_node(pos))
	assert(minetest.get_node(pos).name == "flowers:moonflower_closed", game .. " close")
	time, sunlight = 0.9, 0
	abm.action(pos, minetest.get_node(pos))
	assert(minetest.get_node(pos).name == "flowers:moonflower_closed", game .. " dark")
	print("PASS: " .. game .. " generation and day/night light behavior")
end
run("default", 15)
run("default", nil)
run("mcl", nil)
math.random = original_random
