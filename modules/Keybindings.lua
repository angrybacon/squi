---@type string, Squi
local _, S = ...

---@param action string
---@param key string
local function SetBindingExclusive(action, key)
  for _, current in ipairs({ GetBindingKey(action) }) do
    SetBinding(current)
  end
  SetBinding(key, action)
end

local function ConfigureBars()
  for index, key in ipairs({
    "1", "2", "3", "4", "Q", "E", "R",
    "MOUSEWHEELUP", "MOUSEWHEELDOWN", "BUTTON3", "BUTTON4", "BUTTON5",
  }) do
    SetBindingExclusive("ACTIONBUTTON" .. index, key)
    SetBindingExclusive("MULTIACTIONBAR1BUTTON" .. index, "CTRL-" .. key)
    SetBindingExclusive("MULTIACTIONBAR2BUTTON" .. index, "ALT-" .. key)
  end
end

local function ConfigureCamera()
  SetBindingExclusive("CAMERAZOOMIN", "PAGEUP")
  SetBindingExclusive("CAMERAZOOMOUT", "PAGEDOWN")
end

table.insert(S.Modules, function()
  ConfigureBars()
  ConfigureCamera()
  SaveBindings(GetCurrentBindingSet())
end)
