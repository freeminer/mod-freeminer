# Minetest Game mod: weather

See `license.txt` for license information.
Source code by paramat (MIT).

## VoxeLibre

The mod uses Freeminer's per-block heat, humidity and wind on VoxeLibre. When
`mcl_weather` is installed, that mod continues to control sky, clouds, visible
rain and snow, snow layers, cauldrons, and farmland. Freeminer weather does not
run a competing precipitation display or write its level-based snow/water
nodes over VoxeLibre's different node formats. With `weather = true` and
`liquid_real = true`, Freeminer's erosion runs on VoxeLibre terrain in the
overworld; `erosion_cobble` retains its existing default of false.

Without `mcl_weather`, Freeminer provides its own cloud and precipitation
visuals, and uses VoxeLibre snow-layer nodes for snow accumulation. Liquid
rain accumulation requires `liquid_real = true`. Default Game-specific soil
and plant growth ABMs are not applied to VoxeLibre's different plant system.
Existing mapblocks are not retroactively changed merely by enabling the mod.

From the engine checkout, run the game-independent checks with:

    lua mods/freeminer/freeminer_weather/tests/compat_test.lua mods/freeminer/freeminer_weather

With VoxeLibre installed in `games/VoxeLibre`, run the isolated server probe:

    python3 mods/freeminer/freeminer_weather/tests/run_voxelibre.py build_-20/freeminer
