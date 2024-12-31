local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

merge = function(old, new)
    if not old then
        error("Failed to merge: Old prototype is nil", 2)
    end

    old = table.deepcopy(old)
    for k, v in pairs(new) do
        if v == "nil" then
            old[k] = nil
        else
            old[k] = v
        end
    end
    return old
end


data:extend { merge(data.raw.planet.vulcanus, {
    name = "doomsgate",
    order = "g[doomsgate]",
    distance = 5,
    orientation = 0.9,
    asteroid_spawn_influence = 1,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo, 0.9),
    icon = "__space-age__/graphics/icons/vulcanus.png",
    starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
    starmap_icon_size = 512,
}) }

data:extend { {
    type = "space-connection",
    name = "vulcanus-doomsgate",
    subgroup = "planet-connections",
    from = "vulcanus",
    to = "doomsgate",
    order = "f",
    length = 15000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.vulcanus_gleba),
    icon = "__space-age__/graphics/icons/vulcanus.png",
} }
