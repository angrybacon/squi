---@type string, Squi
local _, S = ...

local VOLUME_HIGH = 1.0
local VOLUME_LOW = 0.1
local VOLUME_MEDIUM = 0.5

table.insert(S.Modules, function()
  SetCVar("Sound_AmbienceVolume", VOLUME_MEDIUM)
  SetCVar("Sound_DialogVolume", VOLUME_HIGH)
  SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
  SetCVar("Sound_MasterVolume", 1.0)
  SetCVar("Sound_MusicVolume", VOLUME_LOW)
  SetCVar("Sound_SFXVolume", VOLUME_HIGH)
end)
