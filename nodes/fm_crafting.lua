-- Intercept only the default mod's recipes, before other mods register theirs.
local register_craft = minetest.register_craft
local outputs = {
	["default:wood 4"] = "default:wood 8",
	["default:junglewood 4"] = "default:junglewood 8",
	["default:pine_wood 4"] = "default:pine_wood 8",
	["default:acacia_wood 4"] = "default:acacia_wood 8",
	["default:aspen_wood 4"] = "default:aspen_wood 8",
	["default:sandstone"] = "default:sandstone 2",
	["default:sand 4"] = "default:sand 2",
}
minetest.register_craft = function(def)
	if outputs[def.output] then def.output = outputs[def.output] end
	return register_craft(def)
end
local ok, err = pcall(dofile, minetest.get_modpath("default") .. "/crafting.lua")
minetest.register_craft = register_craft
if not ok then error(err) end
