---@type string, Squi
local _, S = ...

---Indoor camera distance in yards
local DISTANCE_INDOOR = 12
---Outdoor camera distance in yards
local DISTANCE_OUTDOOR = 24

local function ConfigureZoom()
  S.Commons.OnIndoorsChange(function(indoors)
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
  SetCVar("cameraDistanceMaxZoomFactor", 2.0)
  SetCVar("cameraSmoothStyle", 0)
  SetCVar("cameraWaterCollision", "1")
  ConfigureZoom()
end)
