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
