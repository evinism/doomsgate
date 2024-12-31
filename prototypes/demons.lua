require("__base__.prototypes.entity.enemy-constants")
require("__base__.prototypes.entity.biter-animations")
require("__base__.prototypes.entity.spitter-animations")
require("__base__.prototypes.entity.spawner-animation")

local biter_ai_settings = require("__base__.prototypes.entity.biter-ai-settings")
local enemy_autoplace = require("__base__.prototypes.entity.enemy-autoplace-utils")
local sounds = require("__base__.prototypes.entity.sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local simulations = require("__base__.prototypes.factoriopedia-simulations")

local make_unit_melee_ammo_type = function(damage_value)
  return
  {
    target_type = "entity",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "damage",
          damage = { amount = damage_value, type = "physical" }
        }
      }
    }
  }
end

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

-- TODO, see example https://github.com/CybranM/ArmouredBiters/blob/main/animation.lua
function demonrunanimation(scale, tint1, tint2)
  return biterrunanimation(scale, tint1, tint2)
end

function demonattackanimation(scale, tint1, tint2)
  return biterattackanimation(scale, tint1, tint2)
end

function add_demon_die_animation(scale, tint1, tint2, corpse)
  return add_biter_die_animation(scale, tint1, tint2, corpse)
end

local small_demon_scale = 0.5
local small_demon_tint1 = settings.startup["dg-small-demon-color-primary"].value
local small_demon_tint2 = settings.startup["dg-small-demon-color-secondary"].value


-- A copy and slight mod of the small-biter and biter-spawner prototypes from prototypes/entity/enemies.lua
data:extend(
  {
    {
      type = "unit",
      name = "small-demon",
      icon = "__base__/graphics/icons/small-biter.png",
      flags = { "placeable-player", "placeable-enemy", "placeable-off-grid", "not-repairable", "breaths-air" },
      max_health = 10000,
      order = "b-a-a",
      subgroup = "enemies",
      factoriopedia_simulation = simulations.factoriopedia_small_biter,
      resistances = {},
      healing_per_tick = 0.1,
      collision_box = { { -0.2, -0.2 }, { 0.2, 0.2 } },
      selection_box = { { -0.4, -0.7 }, { 0.4, 0.4 } },
      damaged_trigger_effect = hit_effects.biter(),
      attack_parameters =
      {
        type = "projectile",
        range = 0.5,
        cooldown = 2.5,
        cooldown_deviation = 0.15,
        ammo_category = "melee",
        ammo_type = make_unit_melee_ammo_type(50),
        sound = sounds.biter_roars(0.35),
        animation = demonattackanimation(small_demon_scale, small_demon_tint1, small_demon_tint2),
        range_mode = "bounding-box-to-bounding-box"
      },
      impact_category = "organic",
      vision_distance = 60,
      movement_speed = 1.6,
      distance_per_frame = 0.125,
      absorptions_to_join_attack = { pollution = 4 },
      distraction_cooldown = 300,
      min_pursue_time = 10 * 60,
      max_pursue_distance = 50,
      corpse = "small-biter-corpse",
      dying_explosion = "small-biter-die",
      dying_sound = sounds.biter_dying(0.5),
      working_sound = sounds.biter_calls(0.4, 0.75),
      run_animation = demonrunanimation(small_demon_scale, small_demon_tint1, small_demon_tint2),
      running_sound_animation_positions = { 2, },
      walking_sound = sounds.biter_walk(0, 0.3),
      ai_settings = biter_ai_settings,
      water_reflection = biter_water_reflection(small_demon_scale)
    },
    add_demon_die_animation(small_demon_scale, small_demon_tint1, small_demon_tint2,
      {
        type = "corpse",
        name = "small-biter-corpse",
        icon = "__base__/graphics/icons/small-biter-corpse.png",
        selection_box = { { -0.8, -0.8 }, { 0.8, 0.8 } },
        selectable_in_game = false,
        hidden_in_factoriopedia = true,
        subgroup = "corpses",
        order = "c[corpse]-a[biter]-a[small]",
        flags = { "placeable-neutral", "placeable-off-grid", "building-direction-8-way", "not-repairable", "not-on-map" }
      }),
    {
      type = "unit-spawner",
      name = "demon-spawner",
      icon = "__base__/graphics/icons/biter-spawner.png",
      flags = { "placeable-player", "placeable-enemy", "not-repairable" },
      max_health = 10000,
      order = "b-d-a",
      subgroup = "enemies",
      resistances =
      {
        {
          type = "physical",
          decrease = 2,
          percent = 15
        },
        {
          type = "explosion",
          decrease = 5
        },
        {
          type = "fire",
          decrease = 3,
          percent = 60
        }
      },
      working_sound =
      {
        sound = { filename = "__base__/sound/creatures/spawner.ogg", volume = 0.6, modifiers = volume_multiplier("main-menu", 0.7) },
        max_sounds_per_type = 3
      },
      dying_sound =
      {
        variations = sound_variations("__base__/sound/creatures/spawner-death", 5, 0.7,
          volume_multiplier("main-menu", 0.55)),
        aggregation = { max_count = 2, remove = true, count_already_playing = true }
      },
      healing_per_tick = 0.02,
      collision_box = { { -2.2, -2.2 }, { 2.2, 2.2 } },
      map_generator_bounding_box = { { -3.7, -3.2 }, { 3.7, 3.2 } },
      selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } },
      damaged_trigger_effect = hit_effects.biter(),
      impact_category = "organic",
      -- in ticks per 1 pu
      absorptions_per_second = { pollution = { absolute = 20, proportional = 0.01 } },
      corpse = "biter-spawner-corpse",
      dying_explosion = "biter-spawner-die",
      max_count_of_owned_units = 15,
      max_friends_around_to_spawn = 5,
      graphics_set =
      {
        animations =
        {
          spawner_idle_animation(0, biter_spawner_tint),
          spawner_idle_animation(1, biter_spawner_tint),
          spawner_idle_animation(2, biter_spawner_tint),
          spawner_idle_animation(3, biter_spawner_tint)
        }
      },
      result_units = (function()
        local res = {}
        res[1] = { "small-demon", { { 0.0, 0.3 }, { 0.6, 0.0 } } }
        -- -- from evolution_factor 0.3 the weight for medium-biter is linearly rising from 0 to 0.3
        -- -- this means for example that when the evolution_factor is 0.45 the probability of spawning
        -- -- a small biter is 66% while probability for medium biter is 33%.
        -- res[2] = { "medium-demon", { { 0.2, 0.0 }, { 0.6, 0.3 }, { 0.7, 0.1 } } }
        -- -- for evolution factor of 1 the spawning probabilities are: small-biter 0%, medium-biter 1/8, big-biter 4/8, behemoth biter 3/8
        -- res[3] = { "big-demon", { { 0.5, 0.0 }, { 1.0, 0.4 } } }
        -- res[4] = { "behemoth-demon", { { 0.9, 0.0 }, { 1.0, 0.3 } } }
        return res
      end)(),
      -- With zero evolution the spawn rate is 6 seconds, with max evolution it is 2.5 seconds
      spawning_cooldown = { 120, 60 },
      spawning_radius = 10,
      spawning_spacing = 3,
      max_spawn_shift = 0,
      max_richness_for_spawn_shift = 100,
      autoplace = enemy_autoplace.enemy_spawner_autoplace("enemy_autoplace_base(0, 6)"),
      call_for_help_radius = 50,
      time_to_capture = 60 * 20,
      spawn_decorations_on_expansion = true,
      spawn_decoration =
      {
        {
          decorative = "light-mud-decal",
          spawn_min = 0,
          spawn_max = 2,
          spawn_min_radius = 2,
          spawn_max_radius = 5
        },
        {
          decorative = "dark-mud-decal",
          spawn_min = 0,
          spawn_max = 3,
          spawn_min_radius = 2,
          spawn_max_radius = 6
        },
        {
          decorative = "enemy-decal",
          spawn_min = 3,
          spawn_max = 5,
          spawn_min_radius = 2,
          spawn_max_radius = 7
        },
        {
          decorative = "enemy-decal-transparent",
          spawn_min = 4,
          spawn_max = 20,
          spawn_min_radius = 2,
          spawn_max_radius = 14,
          radius_curve = 0.9
        },
        {
          decorative = "muddy-stump",
          spawn_min = 2,
          spawn_max = 5,
          spawn_min_radius = 3,
          spawn_max_radius = 6
        },
        {
          decorative = "red-croton",
          spawn_min = 2,
          spawn_max = 8,
          spawn_min_radius = 3,
          spawn_max_radius = 6
        },
        {
          decorative = "red-pita",
          spawn_min = 1,
          spawn_max = 5,
          spawn_min_radius = 3,
          spawn_max_radius = 6
        }
      }
    }
  })
