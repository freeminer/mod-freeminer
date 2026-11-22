-- Exercise the same portal behavior with VoxeLibre's frame materials.
local file = assert(io.open("mods/freeminer_portals/tests/portals_test.lua", "r"))
local source = file:read("*a")
file:close()
source = source:gsub("default:obsidian_block", "mcl_core:crying_obsidian")
source = source:gsub("default:obsidian", "mcl_core:obsidian")
source = source:gsub("default:stone", "mcl_core:stone")
-- Let the additional overworld test use the game-specific default offset.
source = source:gsub("if name == 'portals_y_offset' then\n            return '10000'",
    "if name == 'portals_y_offset' and not mcl_vars then\n            return '10000'")
source = source .. [[
mcl_vars = {mg_overworld_min = -62, mg_overworld_max = 30992}
core.find_nodes_in_area = function() return {} end
core.find_nodes_in_area_under_air = function() return {} end
local overworld_range = assert(relative_range(40), 'VoxeLibre default offset cannot find overworld')
assert(overworld_range.a.y >= -62, 'VoxeLibre search escaped below the overworld')
assert(overworld_range.b.y <= 30992, 'VoxeLibre search escaped above the overworld')
print('PASS: VoxeLibre overworld bounds and default vertical offset')
]]
local chunk, err = (loadstring or load)(source, "@voxelibre_portals_test")
assert(chunk, err)()
