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

---Keep one entry per message with a counter, drop the oldest past the limit.
---Print each new message once, repeats only bump the counter.
---@param errors DebugError[]
---@param entry DebugError
local function Insert(errors, entry)
  for _, known in ipairs(errors) do
    if known.message == entry.message then
      known.count = known.count + 1
      known.time = entry.time
      return
    end
  end
  print(("(%s) New error: %s"):format(NAME, entry.message))
  table.insert(errors, entry)
  if #errors > LIMIT then
    table.remove(errors, 1)
  end
end

---Record an entry, or hold it until the saved variable exists
---@param entry DebugError
local function Record(entry)
  if SquiErrors then
    Insert(SquiErrors, entry)
  else
    table.insert(pending, entry)
  end
end

---Record the actions the client blocked, they are events and not errors
local function ConfigureBlocked()
  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("ADDON_ACTION_BLOCKED")
  watcher:RegisterEvent("ADDON_ACTION_FORBIDDEN")
  watcher:SetScript("OnEvent", function(_, event, name, action)
    if name ~= NAME then
      return
    end
    Record({
      count = 1,
      message = ("%s %s%s"):format(
        event == "ADDON_ACTION_FORBIDDEN" and "Forbidden:" or "Blocked:",
        canaccessvalue(action) and tostring(action) or "SECRET",
        InCombatLockdown() and " (combat)" or ""
      ),
      stack = debugstack(2),
      time = date("%Y-%m-%d %H:%M:%S"),
    })
  end)
end

local function ConfigureHandler()
  local previous = geterrorhandler()
  seterrorhandler(function(message)
    -- NOTE Secret values can't be turned into strings, and an error in an error
    --      handler is worse than a placeholder.
    Record({
      count = 1,
      message = canaccessvalue(message) and tostring(message) or "<secret>",
      stack = debugstack(2),
      time = date("%Y-%m-%d %H:%M:%S"),
    })
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
      Insert(SquiErrors, entry)
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

---Log every taint with its stack by default directory
local function ConfigureTaint()
  SetCVar("taintLog", "2")
end

ConfigureBlocked()
ConfigureHandler()
ConfigureLoad()
ConfigureSlash()
ConfigureTaint()

---@class Debug
local Debug = {
  ---Number of distinct errors saved so far
  ---@return number
  Count = function()
    return #(SquiErrors or {})
  end,
}

S.Debug = Debug
