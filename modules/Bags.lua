---@type string, Squi
local _, S = ...

local function ConfigureSort()
  EventRegistry:RegisterCallback("ContainerFrame.OpenAllBags", function()
    C_Container.SortBags()
  end, S)
end

table.insert(S.Modules, function()
  SetCVar("combinedBags", "0")
  ConfigureSort()
end)
