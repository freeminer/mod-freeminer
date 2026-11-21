assert(type(tnt.ignite) == "function" and tnt.BOOMTIMER == 4, "native VoxeLibre TNT API was replaced")
assert(core.registered_nodes["mcl_tnt:tnt"] and core.registered_nodes["tnt:tnt"])
assert(core.registered_nodes["tnt:tnt"]._on_ignite and core.registered_nodes["tnt:tnt"]._on_burn)
assert(core.registered_nodes["tnt:gunpowder"]._on_ignite and core.registered_nodes["tnt:gunpowder"]._on_burn)
local result = core.get_craft_result({method = "normal", width = 1, items = {"mcl_core:gravel", "mcl_core:coal_lump"}})
assert(result.item:get_name() == "tnt:gunpowder", "VoxeLibre gunpowder recipe missing")
local native_blast_called = false
local native_on_blast = core.registered_nodes["mcl_tnt:tnt"].on_blast
core.override_item("mcl_tnt:tnt", {on_blast = function(...)
 native_blast_called = true
 core.log("action", "[fm_tnt_probe] native on_blast called")
 return native_on_blast(...)
end})
local fm_blast_called = false
local fm_on_blast = core.registered_nodes["tnt:tnt"].on_blast
core.override_item("tnt:tnt", {on_blast = function(...)
 fm_blast_called = true
 return fm_on_blast(...)
end})
local center = {x = 0, y = 50, z = 0}
core.after(0, function()
 core.emerge_area({x = -16, y = 32, z = -16}, {x = 16, y = 64, z = 16}, function(_, _, left)
  if left ~= 0 then return end
  core.after(0, function()
   local p = {x = 0, y = 50, z = 0}
   core.set_node({x = 0, y = 49, z = 0}, {name = "mcl_core:stone"})
   core.set_node(p, {name = "tnt:tnt"})
   assert(core.registered_nodes["tnt:tnt"]._on_ignite(nil, {under = p}))
   assert(core.get_node(p).name == "tnt:tnt_burning", "flint ignition failed")
   core.set_node(p, {name = "tnt:gunpowder"})
   core.registered_nodes["tnt:gunpowder"]._on_burn(p)
   assert(core.get_node(p).name == "tnt:gunpowder_burning", "fire ignition failed")
   core.set_node(p, {name = "mcl_tnt:tnt"})
   tnt.burn(p)
   assert(core.get_node(p).name == "air", "native TNT ignition failed")
   local found = false
   for _, obj in ipairs(core.get_objects_inside_radius(p, 2)) do
    local ent = obj:get_luaentity()
    if ent and ent.name == "mcl_tnt:tnt" then found = true; obj:remove() end
   end
   assert(found, "native TNT entity did not spawn")
   for x = -2, 2 do for y = -2, 2 do for z = -2, 2 do
    core.set_node({x = center.x+x, y = center.y+y, z = center.z+z}, {name = "air"})
   end end end
   local wall = {x = center.x + 1, y = center.y, z = center.z}
   core.set_node(wall, {name = "mcl_core:stone"})
   tnt.boom(center, {radius = 1, blast_strength = 300, blast_distance_loss = 0.3,
    blast_min_strength = 0, disable_drops = true})
   core.after(1, function()
    assert(core.get_node(wall).name ~= "mcl_core:stone", "Freeminer explosion did not destroy stone")
    for x = -2, 2 do for y = -2, 2 do for z = -2, 2 do
     core.set_node({x = center.x+x, y = center.y+y, z = center.z+z}, {name = "air"})
    end end end
    local neighbor = {x = center.x + 1, y = center.y, z = center.z}
    core.set_node(neighbor, {name = "mcl_tnt:tnt"})
    tnt.boom(center, {radius = 1, blast_strength = 300, blast_distance_loss = 0.3,
     blast_min_strength = 0.15, disable_drops = true})
    core.after(1, function()
     assert(core.get_node(neighbor).name ~= "mcl_tnt:tnt", "native TNT was not reached by Freeminer explosion")
     assert(native_blast_called, "native TNT did not receive the blast callback")
     for x = -2, 2 do for y = -2, 2 do for z = -2, 2 do
      core.set_node({x = center.x+x, y = center.y+y, z = center.z+z}, {name = "air"})
     end end end
     core.set_node(neighbor, {name = "tnt:tnt"})
     mcl_explosions.explode(center, 4, {particles = false, sound = false})
     assert(fm_blast_called, "native explosion did not trigger Freeminer TNT")
     core.after(1, function()
      assert(core.get_node(neighbor).name ~= "tnt:tnt", "triggered Freeminer TNT did not detonate")
      core.log("action", "[fm_tnt_probe] VoxeLibre ignition, explosion and both mixed-chain directions passed")
      core.request_shutdown("TNT compatibility test complete", false, 0)
     end)
    end)
   end)
  end)
 end)
end)
