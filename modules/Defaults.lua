---@type string, Squi
local _, S = ...

local SCALE = .8
local VOLUME_HIGH = 1.0
local VOLUME_LOW = .1
local VOLUME_MEDIUM = .5

table.insert(S.Modules, function()
  SetCVar("RenderScale", 1.0)
  SetCVar("Sound_AmbienceVolume", VOLUME_MEDIUM)
  SetCVar("Sound_DialogVolume", VOLUME_HIGH)
  SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
  SetCVar("Sound_MasterVolume", 1.0)
  SetCVar("Sound_MusicVolume", VOLUME_LOW)
  SetCVar("Sound_SFXVolume", VOLUME_HIGH)
  SetCVar("autoLootDefault", "1")
  SetCVar("cameraSmoothStyle", 1) -- NOTE Horizontal only
  SetCVar("combinedBags", "1")
  SetCVar("countdownForCooldowns", "1")
  SetCVar("cursorSizePreferred", 1)
  SetCVar("deselectOnClick", "1")
  SetCVar("uiScale", SCALE)
  SetCVar("useUiScale", "1")
end)
