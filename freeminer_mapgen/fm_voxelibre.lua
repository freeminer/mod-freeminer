-- Register Freeminer's extra material pockets only in the overworld.
local vars = rawget(_G, "mcl_vars")
if not vars then return end
local lower, upper = vars.mg_overworld_min, vars.mg_overworld_max
if not lower or not upper then return end
local original = core.register_ore
local function map_name(name)
	if type(name) == "string" then return name:gsub("^default:", "mcl_core:") end
	return name
end
core.register_ore = function(def)
	def.ore = map_name(def.ore)
	def.wherein = map_name(def.wherein)
	def.y_min = math.max(lower, def.y_min or lower)
	def.y_max = math.min(upper, def.y_max or upper)
	if def.y_min <= def.y_max and core.registered_nodes[def.ore]
			and core.registered_nodes[def.wherein] then
		return original(def)
	end
end
local ok, err = pcall(dofile, core.get_modpath("freeminer_mapgen") .. "/fm_mapgen_ores.lua")
core.register_ore = original
if not ok then error(err) end
