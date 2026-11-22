-- freeminer layers
local mg_params = {
	layer_default_thickness = 1,
	layer_thickness_multiplier = 1,
	layers= {
		{ name = "default:stone",              thickness  = 25, },
		{ name = "default:stone_with_coal",    y_max = -1000, },
		{ name = "default:water_source",       y_min = -3000, y_max = -70, thickness  = 3},
		{ name = "default:stone",              y_min = -3000, y_max = -70, }, -- stone after water
		{ name = "default:dirt",               y_min = -50,   y_max = 50, },
		{ name = "default:desert_stone",       thickness  = 3, },
		{ name = "default:stone_with_iron",    y_max = -2000, },
		{ name = "default:gravel",             y_max = -1, },
		{ name = "default:stone_with_copper",  y_max = -3000, },
		{ name = "default:clay",               thickness  = 4, },
		{ name = "default:stone_with_gold",    y_max = -5000, },
		{ name = "default:lava_source",        y_max = -3000, },
		{ name = "default:stone_with_diamond", y_max = -7000, },
		{ name = "default:obsidian",           y_max = -5000, thickness  = 5 },
		{ name = "default:stone",              thickness  = 20, },
		{ name = "default:stone_with_mese",    y_max = -10000, },
		{ name = "air",                        thickness  = 20, y_max = -500, y_min = -20000, }, --caves
		{ name = "default:lava_source",        y_max = -20000, thickness  = 15,},
		{ name = "default:mese",               y_max = -15000, },
		{ name = "air",                        thickness  = 2 },
	}
}

if core.settings:get("mg_params") == "" then
	core.settings:set("mg_params", core.write_json(mg_params))
end


