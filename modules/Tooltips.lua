---@type string, Squi
local _, S = ...

local BACKGROUND = S.Colors.Background
local BACKGROUND_ALPHA = 0.8
local FONT_FACE = S.Fonts.Sans
local FONT_SIZE = 16
local OFFSET = 16

---@param tooltips GameTooltip[]
local function ConfigureBackground(tooltips)
  for _, tooltip in ipairs(tooltips) do
    S.Commons.Hide(tooltip.NineSlice)
    local background = tooltip:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(tooltip)
    background:SetColorTexture(BACKGROUND:GetRGB())
    background:SetAlpha(BACKGROUND_ALPHA)
    -- NOTE Prevent leakage into other reused tooltips
    local edges = S.Commons.Outline(tooltip, "thin", S.Colors.Outline)
    tooltip:HookScript("OnTooltipCleared", function()
      background:SetColorTexture(BACKGROUND:GetRGB())
      for _, edge in ipairs(edges) do
        edge:SetColorTexture(S.Colors.Outline:GetRGBA())
      end
    end)
    TooltipDataProcessor.AddTooltipPostCall(
      Enum.TooltipDataType.Unit,
      function(unitTooltip)
        if unitTooltip ~= tooltip then
          return
        end
        local color = S.Colors.GetClassColor(unitTooltip)
        if not color then
          return
        end
        background:SetColorTexture(S.Colors.Darken(color, 0.8):GetRGB())
        for _, edge in ipairs(edges) do
          edge:SetColorTexture(color:GetRGBA())
        end
      end
    )
  end
end

local function ConfigureFont()
  S.Fonts.Set(GameTooltipHeaderText, {
    font = S.Fonts.Blackletter,
    outline = true,
    size = FONT_SIZE + 2,
  })
  for _, name in ipairs({
    "GameTooltipText",
    "GameTooltipTextSmall",
  }) do
    S.Fonts.Set(
      _G[name],
      { font = FONT_FACE, outline = true, size = FONT_SIZE }
    )
  end
end

local function ConfigureIdentifiers()
  ---@param tooltip GameTooltip
  ---@return string? id
  local function GetItem(tooltip)
    if not tooltip.GetItem then
      return nil
    end
    local _, link = tooltip:GetItem()
    return link and link:match("item:(%d+)")
  end

  ---@param tooltip GameTooltip
  ---@return string? id
  local function GetNpc(tooltip)
    if not tooltip.GetUnit then
      return nil
    end
    local _, unit = tooltip:GetUnit()
    if not unit then
      return nil
    end
    local guid = UnitGUID(unit)
    local id = guid and guid:match("-(%d+)-%x+$")
    if not id or guid:match("^%a+") == "Player" then
      return nil
    end
    return id
  end

  ---@param tooltip GameTooltip
  ---@return string? id
  local function GetSpell(tooltip)
    if not tooltip.GetSpell then
      return nil
    end
    local _, id = tooltip:GetSpell()
    return id and tostring(id)
  end

  for _, it in ipairs({
    { get = GetItem, parameter = "item", type = Enum.TooltipDataType.Item },
    { get = GetNpc, parameter = "npc", type = Enum.TooltipDataType.Unit },
    { get = GetSpell, parameter = "spell", type = Enum.TooltipDataType.Spell },
  }) do
    TooltipDataProcessor.AddTooltipPostCall(it.type, function(tooltip)
      local id = it.get(tooltip)
      if not id then
        return
      end
      tooltip:AddLine(" ")
      tooltip:AddLine(id, COMMON_GRAY_COLOR:GetRGB())
      local url = "https://www.wowhead.com/%s=%s"
      -- NOTE Save the forged link for further reference
      tooltip.__Squi_Tooltips_link = url:format(it.parameter, id)
    end)
  end
  GameTooltip:HookScript("OnTooltipCleared", function(tooltip)
    tooltip.__Squi_Tooltips_link = nil
  end)
end

local function ConfigureLink()
  local dialog = S.Commons.Dialog("SquiDialogTooltipsLink", 400, 80)
  local listener = CreateFrame("Frame")
  listener:EnableKeyboard(true)
  listener:SetPropagateKeyboardInput(true)
  listener:SetScript("OnKeyDown", function(_, key)
    if key == "C" and IsControlKeyDown() and IsShiftKeyDown() then
      if not GameTooltip:IsShown() or not GameTooltip.__Squi_Tooltips_link then
        return
      end
      dialog:Show()
      dialog.ScrollFrame.EditBox:SetText(GameTooltip.__Squi_Tooltips_link)
      dialog.ScrollFrame.EditBox:HighlightText()
      dialog.ScrollFrame.EditBox:SetFocus()
    end
  end)
end

local function ConfigureName()
  TooltipDataProcessor.AddTooltipPostCall(
    Enum.TooltipDataType.Unit,
    function(tooltip)
      local color = S.Colors.GetClassColor(tooltip)
      if not color then
        return
      end
      GameTooltipTextLeft1:SetTextColor(color:GetRGB())
    end
  )
end

local function ConfigurePosition()
  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    if not parent.IsForbidden or not parent:IsForbidden() then
      tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT", OFFSET, 0)
    end
  end)
end

table.insert(S.Modules, function()
  S.Commons.Hide(GameTooltip.StatusBar)
  S.Commons.Hide(ShoppingTooltip1.CompareHeader)
  S.Commons.Hide(ShoppingTooltip2.CompareHeader)
  ConfigureBackground({ GameTooltip, ShoppingTooltip1, ShoppingTooltip2 })
  ConfigureFont()
  ConfigureIdentifiers()
  ConfigureLink()
  ConfigureName()
  ConfigurePosition()
end)
