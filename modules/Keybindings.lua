---@type string, Squi
local _, S = ...

---Raid target markers
local Markers = {
  Circle = 2,
  Cross = 7,
  Diamond = 3,
  Moon = 5,
  Skull = 8,
  Square = 6,
  Star = 1,
  Triangle = 4,
}

---@param action string
---@param key string
local function SetBindingExclusive(action, key)
  for _, current in ipairs({ GetBindingKey(action) }) do
    SetBinding(current)
  end
  SetBinding(key, action)
end

local function ConfigureBags()
  SetBindingExclusive("OPENALLBAGS", "B")
end

local function ConfigureBars()
  local function AssignKeys(specifications, keys)
    for _, specification in ipairs(specifications) do
      for index, key in ipairs(keys) do
        SetBindingExclusive(
          specification.prefix .. index,
          specification.modifier .. key
        )
      end
    end
  end
  AssignKeys({
    { modifier = "", prefix = "ACTIONBUTTON" },
    { modifier = "CTRL-", prefix = "MULTIACTIONBAR2BUTTON" },
  }, { "1", "2", "3", "4", "Q", "E", "R", "F", "Z", "X", "C", "V" })
  AssignKeys({
    { modifier = "", prefix = "MULTIACTIONBAR1BUTTON" },
    { modifier = "CTRL-", prefix = "MULTIACTIONBAR3BUTTON" },
  }, {
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
    "MOUSEWHEELDOWN",
    "MOUSEWHEELUP",
    "BUTTON3",
    "BUTTON4",
    "BUTTON5",
    "`",
  })
end

local function ConfigureCamera()
  SetBindingExclusive("CAMERAZOOMIN", "PAGEUP")
  SetBindingExclusive("CAMERAZOOMOUT", "PAGEDOWN")
end

local function ConfigureMouseWheel()
  for key, macro in pairs({
    BUTTON3 = "/focus [@mouseover,exists][]",
    MOUSEWHEELDOWN = "/tm [@mouseover,exists][] " .. Markers.Cross,
    MOUSEWHEELUP = "/tm [@mouseover,exists][] " .. Markers.Skull,
  }) do
    local name = "SquiMouseWheel" .. key
    -- NOTE Setting a raid target is restricted, a secure macro button isn't
    local button =
      CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
    -- NOTE With ActionButtonUseKeyDown, the action only fires on key down
    button:RegisterForClicks("AnyDown", "AnyUp")
    button:SetAttribute("type", "macro")
    button:SetAttribute("macrotext", macro)
    SetBindingClick(key, name)
  end
end

local function ConfigureMovement()
  SetBindingExclusive("TOGGLEAUTORUN", "DELETE")
end

local function ConfigurePanels()
  SetBindingExclusive("TOGGLECHARACTER0", "U")
end

table.insert(S.Modules, function()
  SetCVar("enableMouseoverCast", "1")
  ConfigureBags()
  ConfigureBars()
  ConfigureCamera()
  -- ConfigureMouseWheel()
  ConfigureMovement()
  ConfigurePanels()
  SaveBindings(GetCurrentBindingSet())
end)
