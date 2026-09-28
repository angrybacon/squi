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


  ---Get the region's unit's class color, or nil if it isn't a player
  ---@param region { GetUnit: fun(self: table): string?, string? }
  ---@return colorRGB?
  GetClassColor = function(region)
    local _, unit = region:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return nil end
    local _, class = UnitClass(unit)
    return C_ClassColor.GetClassColor(class)
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

  ---@param color ColorRGBData
  Pastelize = function(color)
    return CreateColor(
      (color.r + 1) / 2,
      (color.g + 1) / 2,
      (color.b + 1) / 2
    )
  end,
}

Colors.Background = CreateColor(.13, .13, .15)
Colors.BackgroundDisabled = Colors.Darken(Colors.Background, .3)
Colors.BackgroundHover = Colors.Lighten(Colors.Background, .1)
Colors.BackgroundPushed = Colors.Darken(Colors.Background, .3)
Colors.Outline = Colors.Lighten(Colors.Background, .6)
Colors.TextDisabled = CreateColor(.2, .2, .2)

S.Colors = Colors
