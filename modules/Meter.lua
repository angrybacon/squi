---@type string, Squi
local _, S = ...

local MARGIN = 24

local function ConfigureFont()
  -- NOTE The bars use a shared font object, so other widgets might follow
  S.Fonts.Set(NumberFontNormal, { font = S.Fonts.Blackletter })
end

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.DamageMeter] = {
      anchor = {
        anchor = "TOPRIGHT",
        anchored = "TOPLEFT",
        on = "ObjectiveTrackerFrame",
        x = MARGIN,
        y = 0,
      },
      settings = {
        [Enum.EditModeDamageMeterSetting.Numbers] = Enum.DamageMeterNumbers.Complete,
        [Enum.EditModeDamageMeterSetting.Padding] = 0,
        [Enum.EditModeDamageMeterSetting.Visibility] = Enum.DamageMeterVisibility.InGroup,
      },
    },
  })
end

local function ConfigureSession()
  local window = DamageMeter:GetPrimarySessionWindow()
  if window then
    -- NOTE Blizzard saves the choice, so reset it on every load
    DamageMeter:SetSessionWindowSessionID(
      window,
      Enum.DamageMeterSessionType.Current,
      nil
    )
  end
end

table.insert(S.Modules, function()
  ConfigureFont()
  ConfigurePosition()
  ConfigureSession()
end)
