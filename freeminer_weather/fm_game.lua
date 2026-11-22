-- The Default Game and VoxeLibre have different weather and node formats.
local default_api = rawget(_G, "default")
local is_voxelibre = not default_api and core.get_modpath("mcl_core") ~= nil
local native_weather = is_voxelibre and rawget(_G, "mcl_weather") ~= nil
local enabled
if is_voxelibre then
	enabled = core.settings:get_bool("weather") and core.settings:get_bool("enable_weather") ~= false
else
	enabled = default_api and default_api.weather
end
return {
	voxelibre = is_voxelibre,
	native_weather = native_weather,
	enabled = enabled,
	light_sun = default_api and default_api.LIGHT_SUN or (core.LIGHT_MAX or 14) + 1,
}
