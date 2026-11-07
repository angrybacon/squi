---@type string, Squi
local _, S = ...

local VOLUME_HIGH = 1.0
local VOLUME_LOW = 0.1
local VOLUME_MASTER = 0.9
local VOLUME_MEDIUM = 0.5

table.insert(S.Modules, function()
  SetCVar("ShowAllSpellRanks", "1")
  SetCVar("Sound_AmbienceVolume", VOLUME_MEDIUM)
  SetCVar("Sound_DialogVolume", VOLUME_HIGH)
  SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
  SetCVar("Sound_MasterVolume", VOLUME_MASTER)
  SetCVar("Sound_MusicVolume", VOLUME_LOW)
  SetCVar("Sound_SFXVolume", VOLUME_HIGH)
  SetCVar("autoLootDefault", "1")
  SetCVar("cursorSizePreferred", 0)
  SetCVar("damageMeterEnabled", "1")
  SetCVar("deselectOnClick", "1")
  SetCVar("enableMouseoverCast", "1")
end)
