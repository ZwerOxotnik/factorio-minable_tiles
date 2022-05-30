minable_tiles_core = require("lib")
minable_tiles_core.targets = {["electric-mining-drill"] = function(fake_prototype)
  if fake_prototype == nil then return end
  fake_prototype.animations = { -- TODO: recheck, change
    {
      priority = "high",
      filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-N.png",
      line_length = 1,
      width = 96,
      height = 104,
      frame_count = 1,
      animation_speed = electric_drill_animation_speed,
      direction_count = 1,
      shift = util.by_pixel(0, -4),
      repeat_count = 1,
      hr_version =
      {
        priority = "high",
        filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-N.png",
        line_length = 1,
        width = 190,
        height = 208,
        frame_count = 1,
        animation_speed = electric_drill_animation_speed,
        direction_count = 1,
        shift = util.by_pixel(0, -4),
        repeat_count = 1,
        scale = 0.5
      }
    }, {
      priority = "high",
      filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-N-output.png",
      line_length = 5,
      width = 32,
      height = 34,
      frame_count = 5,
      animation_speed = electric_drill_animation_speed,
      direction_count = 1,
      shift = util.by_pixel(-4, -44),
      hr_version =
      {
        priority = "high",
        filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-N-output.png",
        line_length = 5,
        width = 60,
        height = 66,
        frame_count = 5,
        animation_speed = electric_drill_animation_speed,
        direction_count = 1,
        shift = util.by_pixel(-3, -44),
        scale = 0.5
      }
    }, {
      priority = "high",
      filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-N-shadow.png",
      line_length = 1,
      width = 106,
      height = 104,
      frame_count = 1,
      animation_speed = electric_drill_animation_speed,
      draw_as_shadow = true,
      shift = util.by_pixel(6, -4),
      repeat_count = 1,
      hr_version =
      {
        priority = "high",
        filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-N-shadow.png",
        line_length = 1,
        width = 212,
        height = 204,
        frame_count = 1,
        animation_speed = electric_drill_animation_speed,
        draw_as_shadow = true,
        shift = util.by_pixel(6, -3),
        repeat_count = 1,
        scale = 0.5
      }
    }
  }
end}