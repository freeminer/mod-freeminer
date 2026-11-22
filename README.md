# Freeminer modpack

This modpack adds Freeminer gameplay, world generation, weather and node
physics features to supported games. It targets the **Freeminer engine**:
several features use engine-specific Lua APIs, node properties and liquid or
climate simulation. Running the pack on unmodified Luanti is not guaranteed.

## Installation

Place this directory in the engine's `mods` directory or in a world's
`worldmods` directory, then enable the desired mods in the world configuration.
The directory names below are the directories in this pack; the **mod names**
are the names to enable in the game UI or with `load_mod_<name> = true` in
`world.mt`. Enable the features you need as well as the optional `freeminer`
facade: enabling the facade alone does not enable the feature mods.

Avoid loading two mods with the same mod name. Games may already provide mods
named `tnt`, `weather`, `sponge`, `spring`, `moonflower` or `portals`; choose
which implementation to enable. The `mod.conf` files list optional integration
dependencies. Features can be used separately where their game adapter supports
it.

| Directory | Mod name | Purpose |
| --- | --- | --- |
| `freeminer` | `freeminer` | Compatibility facade; coordinates enabled feature mods and preserves legacy integration and storage. |
| `nodes` | `freeminer_nodes` | Node properties, recipes, fire, stairs and melt behavior. |
| `mapgen` | `freeminer_mapgen` | Game-specific mapgen bounds, layers and additional material pockets. |
| `trees` | `freeminer_trees` | Ice and lava trees. |
| `aquatic` | `freeminer_aquatic` | Aquatic growth and deep-water plants; the deep plants use Marinara. |
| `arnis` | `freeminer_arnis` | Arnis decals, rail integration and train markers; Advtrains is optional. |
| `mob_edges` | `mob_edges` | Adjusts Mobs Redo spawn height defaults and PBJ Pup generation bounds. |
| `moonflower` | `moonflower` | Light-sensitive moonflowers. |
| `portals` | `portals` | Automatically linked obsidian portals to deep caves. |
| `sponge` | `sponge` | Water and liquid-removing sponge nodes. |
| `spring` | `spring` | Water, lava, dirt and sand spring nodes. |
| `tnt` | `tnt` | Freeminer TNT, fuses and explosion behavior. |
| `weather` | `weather` | Climate, precipitation, weather effects and erosion. |

Keep the facade enabled when migrating an existing Arnis world: standalone
`freeminer_arnis` uses a different mod-storage namespace. Disabling a mod that
provided saved nodes or entities can make those objects unavailable until it is
re-enabled. Changes to mapgen do not regenerate existing terrain.

Default Game uses `first_mod = mob_edges` and `last_mod = freeminer` in its game
configuration. When moving the pack out of the game directory, make sure those
mods are available and enabled. The early `mob_edges` load is needed to intercept
Mobs Redo registrations; merely loading it after mobs cannot change registrations
that have already happened.

## Game compatibility

- **Freeminer Default Game:** uses the existing Default integration and its
  first/last mod hooks. Avoid enabling duplicate copies of mods supplied by the
  game.
- **Minetest Game:** the Default-based node, mapgen, tree and other compatible
  features can be enabled. Marinara-based deep aquatic plants require Marinara.
- **VoxeLibre:** adapters cover nodes, fire, stairs, springs, trees, TNT,
  moonflowers, cave portals, weather and overworld material pockets. VoxeLibre's
  native weather controller and dimension bounds are respected. The aquatic
  feature is not adapted, the sponge still uses Default-specific items and
  liquid names, and some Default mapgen layers and vegetation behavior have no
  equivalent. Freeminer TNT and VoxeLibre TNT have separate settings and behavior.

Support varies by feature and engine configuration; startup compatibility does
not imply every in-game interaction has been tested. See each mod's README and
`settingtypes.txt` for details, settings and attribution. For example, the
weather mod uses `weather`, `enable_weather` and `liquid_real`; the TNT mod uses
`enable_tnt`; and portal search settings are described in [portals/README.md](portals/README.md).

Licensing and media credits are provided by the individual mods; check their
license and README files when redistributing them.
