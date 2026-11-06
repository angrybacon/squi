---@type string, Squi
local NAME, S = ...

local LIMIT = 50

---@class DebugError
---@field count number
---@field message string
---@field stack string
---@field time string

---Errors raised before the saved variable exists
---@type DebugError[]
local pending = {}

---Keep one entry per message with a counter, drop the oldest past the limit
---@param errors DebugError[]
---@param entry DebugError
local function Store(errors, entry)
  for _, known in ipairs(errors) do
    if known.message == entry.message then
      known.count = known.count + 1
      known.time = entry.time
      return
    end
  end
  table.insert(errors, entry)
  if #errors > LIMIT then
    table.remove(errors, 1)
  end
end

local function ConfigureHandler()
  local previous = geterrorhandler()
  seterrorhandler(function(message)
    -- NOTE Secret values can't be turned into strings, and an error in an error
    --      handler is worse than a placeholder
    local entry = {
      count = 1,
      message = canaccessvalue(message) and tostring(message) or "<secret>",
      stack = debugstack(2),
      time = date("%Y-%m-%d %H:%M:%S"),
    }
    if SquiErrors then
      Store(SquiErrors, entry)
    else
      table.insert(pending, entry)
    end
    return previous(message)
  end)
end

local function ConfigureLoad()
  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("ADDON_LOADED")
  watcher:SetScript("OnEvent", function(_, _, name)
    if name ~= NAME then
      return
    end
    SquiErrors = SquiErrors or {}
    for _, entry in ipairs(pending) do
      Store(SquiErrors, entry)
    end
    table.wipe(pending)
    watcher:UnregisterEvent("ADDON_LOADED")
  end)
end

local function ConfigureSlash()
  SLASH_SQUIERRORS1 = "/squierrors"
  ---@param input string
  SlashCmdList["SQUIERRORS"] = function(input)
    local errors = SquiErrors or {}
    if input:lower():find("clear", 1, true) then
      table.wipe(errors)
      print(("(%s) Errors cleared"):format(NAME))
      return
    end
    if #errors == 0 then
      print(("(%s) No errors"):format(NAME))
      return
    end
    for index, entry in ipairs(errors) do
      print(
        ("%d. [%s] x%d %s"):format(
          index,
          entry.time,
          entry.count,
          entry.message
        )
      )
    end
    print(("(%s) Stacks are in SavedVariables/%s.lua"):format(NAME, NAME))
  end
end

---@class Debug
local Debug = {
  ---Number of distinct errors saved so far
  ---@return number
  Count = function()
    return #(SquiErrors or {})
  end,
}

ConfigureHandler()
ConfigureLoad()
ConfigureSlash()

S.Debug = Debug
