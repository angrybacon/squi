---@type string, Squi
local _, S = ...

local ICON_PADDING = 2

local function ConfigureGeometry()
  for _, bar in ipairs({ MainActionBar, MultiBarBottomLeft }) do
    for _, button in ipairs(bar.actionButtons) do
      S.Commons.Hide(button.Border)
      S.Commons.Hide(button.IconMask)
      S.Commons.Hide(button.SlotArt)
      S.Commons.Hide(button.SlotBackground)
      S.Commons.Hide(button:GetHighlightTexture())
      S.Commons.Hide(button:GetNormalTexture())
      if button.icon then
        local offset = .08
        button.icon:SetTexCoord(offset, 1 - offset, offset, 1 - offset)
      end
      S.Commons.Outline(button, "thin", S.Colors.Outline)
    end
  end
end

local function ConfigurePositions()
  local margin = 20
  MainActionBar:ClearAllPoints()
  MainActionBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, margin)
  EditModeManagerFrame:OnSystemPositionChange(MainActionBar)
  MultiBarBottomLeft:ClearAllPoints()
  MultiBarBottomLeft:SetPoint("BOTTOM", MainActionBar, "TOP", 0, ICON_PADDING)
  EditModeManagerFrame:OnSystemPositionChange(MultiBarBottomLeft)
end

local function ConfigureVisibility()
  SetActionBarToggles(true, false, false, false, false, false, false, "")
  S.Commons.Hide(MainActionBar.EndCaps)
  S.Commons.Hide(MainActionBar.ActionBarPageNumber)
  S.Commons.Hide(MainActionBar.BorderArt)
  MainActionBar.enableDividers = false
  MainActionBar.HorizontalDividersPool:ReleaseAll()
end

local function ConfigureSize()
  local size = 75
  local padding = ICON_PADDING
  local settings = Enum.EditModeActionBarSetting
  for _, bar in ipairs({ MainActionBar, MultiBarBottomLeft }) do
    EditModeManagerFrame:OnSystemSettingChange(bar, settings.IconSize, size)
    EditModeManagerFrame:OnSystemSettingChange(bar, settings.IconPadding, padding)
  end
end

table.insert(S.Modules, function()
  ConfigureGeometry()
  ConfigurePositions()
  ConfigureVisibility()
  ConfigureSize()
end)
