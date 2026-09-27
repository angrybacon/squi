---@type string, Squi
local _, S = ...

---@class Colors
local Colors = {
  ---@param color ColorRGBData
  ---@param amount number
  Darken = function(color, amount)
    return CreateColor(
      color.r * (1 - amount),
      color.g * (1 - amount),
      color.b * (1 - amount)
    )
  end,

  ---@param color ColorRGBData
  ---@param amount number
  Lighten = function(color, amount)
    return CreateColor(
      color.r + (1 - color.r) * amount,
      color.g + (1 - color.g) * amount,
      color.b + (1 - color.b) * amount
    )
  end,
}

Colors.Background = CreateColor(0.13, 0.13, 0.15)
Colors.BackgroundDisabled = Colors.Darken(Colors.Background, 0.3)
Colors.BackgroundHover = Colors.Lighten(Colors.Background, 0.1)
Colors.BackgroundPushed = Colors.Darken(Colors.Background, 0.3)
Colors.Outline = Colors.Lighten(Colors.Background, 0.4)
Colors.TextDisabled = CreateColor(0.2, 0.2, 0.2)

S.Colors = Colors
