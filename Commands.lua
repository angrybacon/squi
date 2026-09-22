SLASH_COLORS1 = "/colors"

SlashCmdList["COLORS"] = function()
  local labels = {}
  for name, value in pairs(_G) do
    local label = type(name) == "string" and name:match("^(.+)_FONT_COLOR$")
    if label and type(value) == "table" and type(value.r) == "number" then
      labels[#labels + 1] = label
    end
  end
  table.sort(labels)
  for _, label in ipairs(labels) do
    local c = _G[label .. "_FONT_COLOR"]
    print(CreateColor(c.r, c.g, c.b, c.a or 1):WrapTextInColorCode(label))
  end
end
