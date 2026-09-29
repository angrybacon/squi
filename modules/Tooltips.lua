---@type string, Squi
local _, S = ...

local BACKGROUND = S.Colors.Background
local BACKGROUND_ALPHA = .9
local FONT_FACE = S.Fonts.SansRegular
local FONT_SIZE = 12
local OFFSET = 20

local function ConfigureBackground()
  local background = GameTooltip:CreateTexture(nil, "BACKGROUND")
  background:SetAllPoints(GameTooltip)
  background:SetColorTexture(BACKGROUND:GetRGB())
  background:SetAlpha(BACKGROUND_ALPHA)
  -- NOTE Prevent leakage into other reused tooltips
  GameTooltip:HookScript("OnTooltipCleared", function()
    background:SetColorTexture(BACKGROUND:GetRGB())
  end)
  TooltipDataProcessor.AddTooltipPostCall(
    Enum.TooltipDataType.Unit,
    function(tooltip)
      local color = S.Colors.GetClassColor(tooltip)
      if not color then return end
      background:SetColorTexture(S.Colors.Darken(color, .8):GetRGB())
    end
  )
end

local function ConfigureFont()
  for _, name in ipairs({
    "GameTooltipHeaderText",
    "GameTooltipText",
    "GameTooltipTextSmall",
  }) do
    S.Fonts.Set(_G[name], { font = FONT_FACE, size = FONT_SIZE })
  end
end

local function ConfigureName()
  TooltipDataProcessor.AddTooltipPostCall(
    Enum.TooltipDataType.Unit,
    function(tooltip)
      S.Fonts.Set(GameTooltipTextLeft1, {
        font = S.Fonts.BlackletterRegular,
        outline = true,
        size = FONT_SIZE + 2,
      })
      local color = S.Colors.GetClassColor(tooltip)
      if not color then return end
      GameTooltipTextLeft1:SetTextColor(color:GetRGB())
    end
  )
end

local function ConfigureOutline()
  S.Commons.Hide(GameTooltip.NineSlice)
  local edges = S.Commons.Outline(GameTooltip, "thin", S.Colors.Outline)
  -- NOTE Prevent leakage into other reused tooltips
  GameTooltip:HookScript("OnTooltipCleared", function()
    for _, edge in ipairs(edges) do
      edge:SetColorTexture(S.Colors.Outline:GetRGBA())
    end
  end)
  TooltipDataProcessor.AddTooltipPostCall(
    Enum.TooltipDataType.Unit,
    function(tooltip)
      local color = S.Colors.GetClassColor(tooltip)
      if not color then return end
      for _, edge in ipairs(edges) do
        edge:SetColorTexture(color:GetRGBA())
      end
    end
  )
end

local function ConfigurePosition()
  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    if not parent.IsForbidden or not parent:IsForbidden() then
      tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT", OFFSET, OFFSET)
    end
  end)
end

table.insert(S.Modules, function()
  S.Commons.Hide(GameTooltip.StatusBar)
  ConfigureBackground()
  ConfigureFont()
  ConfigureName()
  ConfigureOutline()
  ConfigurePosition()
end)
