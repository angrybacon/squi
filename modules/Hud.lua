---@type string, Squi
local _, S = ...

---@param frame table
local function Hide(frame)
  frame:Hide()
  frame:HookScript("OnShow", frame.Hide)
end

table.insert(S.Modules, function()
  Hide(BagsBar)
  Hide(MicroMenuContainer)
end)
