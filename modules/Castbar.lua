---@type string, Squi
local _, S = ...

local GAP = 50

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.CastBar] = {
      anchor = {
        anchor = "TOP",
        anchored = "BOTTOM",
        on = "MultiBarBottomLeft",
        x = 0,
        y = GAP,
      },
    },
  })
end

table.insert(S.Modules, function()
  ConfigurePosition()
end)
