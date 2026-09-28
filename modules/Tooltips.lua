---@type string, Squi
local _, S = ...

local FONT_FACE = S.Fonts.SansRegular
local FONT_SIZE = 14
local OFFSET = 20

local function ConfigureFont()
  for _, name in ipairs({
    "GameTooltipHeaderText",
    "GameTooltipText",
    "GameTooltipTextSmall",
  }) do
    S.Fonts.Set(_G[name], { font = FONT_FACE, size = FONT_SIZE })
  end
end

local function ConfigurePosition()
  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    if not parent.IsForbidden or not parent:IsForbidden() then
      tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT", OFFSET, OFFSET)
    end
  end)
end

local function ConfigureUnitColor()
  TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
    local _, unit = tooltip:GetUnit()
    if not unit or not UnitIsPlayer(unit) then return end
    local _, class = UnitClass(unit)
    GameTooltipTextLeft1:SetTextColor(C_ClassColor.GetClassColor(class):GetRGB())
  end)
end

table.insert(S.Modules, function()
  S.Commons.Hide(GameTooltip.StatusBar)
  ConfigureFont()
  ConfigurePosition()
  ConfigureUnitColor()
end)
