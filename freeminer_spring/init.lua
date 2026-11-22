-- Resolve game materials once; actions keep using the engine's pressure encoding.
local prefix = core.get_modpath("mcl_core") and "mcl_core:" or "default:"
local water_tile = prefix == "mcl_core:" and core.registered_nodes[prefix .. "water_source"].tiles[1] or "default_water.png"
local lava_tile = prefix == "mcl_core:" and core.registered_nodes[prefix .. "lava_source"].tiles[1] or "default_lava.png"

core.register_node("spring:water",{
    description = "Water spring",
    tiles = {water_tile},
})

core.register_abm({
    nodenames = {"spring:water"},
    interval = 2,
    chance = 2,
    action = function(pos,node)
        core.set_node(pos,{name = prefix .. "water_source", param2=128})
    end
})

core.register_node("spring:water_compressed",{
    description = "Water spring compressed",
    tiles = {water_tile},
})

core.register_abm({
    nodenames = {"spring:water_compressed"},
    interval = 2,
    chance = 2,
    action = function(pos,node)
        core.set_node(pos,{name = prefix .. "water_source", param2=128+31})
    end
})

core.register_node("spring:lava",{
    description = "Lava spring",
    tiles = {lava_tile},
    light_source = 6,
    groups = { wield_light = 6 },
})

core.register_abm({
    nodenames = {"spring:lava"},
    interval = 2,
    chance = 2,
    action = function(pos,node)
        core.set_node(pos,{name = prefix .. "lava_source", param2=128})
    end
})

core.register_node("spring:lava_compressed",{
    description = "Lava spring compressed",
    tiles = {lava_tile},
    light_source = 7,
    groups = { wield_light = 7 },
})

core.register_abm({
    nodenames = {"spring:lava_compressed"},
    interval = 2,
    chance = 2,
    action = function(pos,node)
        core.set_node(pos,{name = prefix .. "lava_source", param2=128+31})
    end
})

core.register_node("spring:dirt",{
    description = "Dirt spring",
    tiles = {"default_dirt.png"},
})

core.register_abm({
    nodenames = {"spring:dirt"},
    interval = 2,
    chance = 2,
    action = function(pos,node)
        core.set_node(pos,{name = prefix .. "dirt", param2=128})
    end
})

core.register_node("spring:dirt_compressed",{
    description = "Dirt spring compressed",
    tiles = {"default_dirt.png"},
})

core.register_abm({
    nodenames = {"spring:dirt_compressed"},
    interval = 2,
    chance = 2,
    action = function(pos,node)
        core.set_node(pos,{name = prefix .. "dirt", param2=128+31})
    end
})

core.register_node("spring:sand",{
    description = "Sand spring",
    tiles = {"default_sand.png"},
})

core.register_abm({
    nodenames = {"spring:sand"},
    interval = 2,
    chance = 2,
    action = function(pos,node)
        core.set_node(pos,{name = prefix .. "sand", param2=128})
    end
})
