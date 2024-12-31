data:extend(
{
  {
    type = "technology",
    name = "planet-discovery-doomsgate",
    icons = util.technology_icon_constant_planet("__space-age__/graphics/technology/vulcanus.png"),
    icon_size = 256,
    essential = true,
    effects =
    {
      {
        type = "unlock-space-location",
        space_location = "doomsgate",
        use_icon_overlay_constant = true
      },
    },
    unit =
    {
      count = 1500,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"military-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"space-science-pack", 1},
        {"promethium-science-pack", 1},
      },
      time = 60
    }
  },
})