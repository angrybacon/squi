---@type string, Squi
local _, S = ...

local DISTANCE_INDOOR = 10
local DISTANCE_OUTDOOR = 20

local function ConfigureZoom()
  local previous = IsIndoors()
  C_Timer.NewTicker(1, function()
    local indoors = IsIndoors()
    if indoors == previous then
      return
    end
    previous = indoors
    if InCombatLockdown() then
      return
    end
    local target = indoors and DISTANCE_INDOOR or DISTANCE_OUTDOOR
    local delta = target - GetCameraZoom()
    if delta > 0 then
      -- NOTE Delay the zoom out since we're likely leaving a building with a
      --      roof that would cover the user camera otherwise.
      C_Timer.After(1, function()
        CameraZoomOut(delta)
      end)
    elseif delta < 0 then
      CameraZoomIn(-delta)
    end
  end)
end

table.insert(S.Modules, function()
  ConfigureZoom()
end)
