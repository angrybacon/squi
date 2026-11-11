SLASH_COLORS1 = "/colors"

---@param input string
SlashCmdList["COLORS"] = function(input)
  local tokens = {}

  for token in input:gmatch("%S+") do
    tokens[#tokens + 1] = token:lower()
  end

  local names = {}

  for name, value in pairs(_G) do
    if
      type(name) == "string"
      and name:find("_COLOR$")
      and type(value) == "table"
      and type(value.r) == "number"
    then
      local matches = true
      for _, token in ipairs(tokens) do
        if not name:lower():find(token, 1, true) then
          matches = false
          break
        end
      end
      if matches then
        names[#names + 1] = name
      end
    end
  end

  table.sort(names)

  for _, name in ipairs(names) do
    local c = _G[name]
    print(CreateColor(c.r, c.g, c.b, c.a or 1):WrapTextInColorCode(name))
  end
end

SLASH_WAY1 = "/way"

---Set a map waypoint from percentages of the current zone's map
---@param input string
SlashCmdList["WAY"] = function(input)
  local x, y = input:match("^%s*([%d%.]+)[%s,]+([%d%.]+)")
  x, y = tonumber(x), tonumber(y)
  if not x or not y then
    print("(Squi) Usage: /way <x> <y>")
    return
  end
  local map = C_Map.GetBestMapForUnit("player")
  if not map or not C_Map.CanSetUserWaypointOnMap(map) then
    print("(Squi) No waypoint can be set on this map")
    return
  end
  -- NOTE Blizzard's coordinates are fractions of the map, from 0 to 1
  C_Map.SetUserWaypoint({
    uiMapID = map,
    position = CreateVector2D(x / 100, y / 100),
  })
  C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end
