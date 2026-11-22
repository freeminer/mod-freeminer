core.register_on_mods_loaded(function()
 local mode = core.settings:get("fm_split_probe_mode") or "full"
 local game = core.get_game_info().id
 local groups = {"freeminer_nodes", "freeminer_mapgen", "freeminer_trees", "freeminer_aquatic", "freeminer_arnis"}
 if mode == "full" or mode == "standalone" then
  for _, name in ipairs(groups) do assert(core.get_modpath(name), name .. " not enabled") end
  assert((core.get_modpath("freeminer") ~= nil) == (mode == "full"), "unexpected facade state")
 end
 local nodes = core.registered_nodes
 local names = {"plant_ice:ice_tree", "plant_ice:ice_tree_root", "plant_ice:ice_tree_snow", "plant_ice:ice_tree_sapling", "plant_lava:lava_tree", "plant_lava:lava_tree_root", "plant_lava:lava_tree_crown", "plant_lava:lava_tree_bud", "freeminer:arnis_decal_frame", "freeminer:arnis_train_spawn"}
 if mode == "feature_nodes" then
  assert(not core.get_modpath("freeminer"))
  if game == "VoxeLibre" then
   assert(nodes["mcl_core:stone"].groups.melt == 3000)
  else
   assert(nodes["freeminer:lamp_red"] and nodes["default:stone"].groups.melt == 3000)
  end
  assert(not nodes["plant_ice:ice_tree"] and not nodes["freeminer:arnis_decal_frame"])
 elseif mode == "feature_trees" then
  assert(not core.get_modpath("freeminer"))
  assert(nodes["plant_ice:ice_tree"] and nodes["plant_lava:lava_tree"])
  assert(not nodes["freeminer:arnis_decal_frame"] and not nodes["freeminer:lamp_red"])
 elseif mode == "feature_arnis" then
  assert(not core.get_modpath("freeminer"))
  assert(nodes["freeminer:arnis_decal_frame"] and nodes["freeminer:arnis_train_spawn"])
  assert(core.registered_entities["freeminer:arnis_decal_display"])
  local names = {}
  for _, lbm in ipairs(core.registered_lbms) do names[lbm.name] = true end
  assert(names["freeminer_arnis:arnis_trains"] and names["freeminer_arnis:restore_arnis_decal_displays"])
  assert(not nodes["plant_ice:ice_tree"] and not nodes["freeminer:lamp_red"])
 elseif mode == "nodes_only" then
  assert(nodes["freeminer:lamp_red"] and nodes["default:stone"].groups.melt == 3000)
  assert(not nodes["plant_ice:ice_tree"] and not nodes["freeminer:arnis_decal_frame"])
 elseif mode == "mapgen_only" then
  assert(not nodes["freeminer:lamp_red"] and not nodes["plant_ice:ice_tree"])
  local found = false
  for _, def in pairs(core.registered_ores) do
   if def.ore == "default:stone_with_coal" and def.noise_threshold == 0.2 then found = true end
  end
  assert(found, "mapgen ore parameters were not installed")
 elseif mode ~= "disabled" then
  for _, n in ipairs(names) do assert(nodes[n], "missing " .. n) end
  assert(core.registered_entities["freeminer:arnis_decal_display"], "missing Arnis entity")
  local expected_prefix = mode == "standalone" and "freeminer_arnis:" or "freeminer:"
  local lbms = {}
  for _, lbm in ipairs(core.registered_lbms) do lbms[lbm.name] = true end
  assert(lbms[expected_prefix .. "restore_arnis_decal_displays"] and lbms[expected_prefix .. "arnis_trains"], "Arnis LBMs use the wrong storage identity")
  if game == "VoxeLibre" then
   assert(nodes["mcl_core:stone"].groups.melt == 3000)
  else
   assert(nodes["freeminer:lamp_red"] and nodes["default:stone"].groups.melt == 3000)
   if game == "default" then assert(nodes["freeminer:pressure_lantern_kelp"]) end
  end
 else
  assert(not nodes["plant_ice:ice_tree"] and not nodes["freeminer:arnis_decal_frame"], "disabled feature loaded")
  assert(not nodes["freeminer:lamp_red"], "disabled node features loaded")
 end
 if game ~= "VoxeLibre" and (mode == "full" or mode == "standalone" or mode == "baseline" or mode == "nodes_only" or mode == "feature_nodes") then
  local result = core.get_craft_result({method="normal", width=1, items={"default:tree"}})
  assert(result.item:get_name() == "default:wood" and result.item:get_count() == 8, "wood recipe mismatch")
 end
 local saved = {}
 for _, name in ipairs(names) do
  local def = nodes[name]
  if def then saved[name] = {description=def.description, groups=def.groups, drop=def.drop,
   melt=def.melt, freeze=def.freeze, light_source=def.light_source, drawtype=def.drawtype,
   paramtype=def.paramtype, paramtype2=def.paramtype2, tiles=def.tiles} end
 end
 for _, name in ipairs({"default:stone", "default:water_source", "default:water_flowing", "mcl_core:stone", "mcl_core:water_source", "freeminer:lamp_red", "freeminer:pressure_lantern_kelp"}) do
  local def = nodes[name]
  if def then saved[name] = {groups=def.groups, melt=def.melt, freeze=def.freeze, paramtype2=def.paramtype2} end
 end
 assert(core.safe_file_write(core.get_worldpath() .. "/fm-split-snapshot.json", core.write_json(saved)))
 core.log("action", "[fm_split_probe] " .. game .. " " .. mode .. " passed")
 core.after(0, function() core.request_shutdown("split probe complete", false, 0) end)
end)
