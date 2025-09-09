local config = require 'config.client'
local isPlayerFree = true
local waypoint, prop
local export = exports.qbx_core

local function createPed(pedModel, pedCoords, pedScenario)
  RequestModel(GetHashKey(pedModel))
  while not HasModelLoaded(GetHashKey(pedModel)) do
    Wait(10)
  end

  local pedHandle = CreatePed(
    0,
    GetHashKey(pedModel),
    pedCoords.x,
    pedCoords.y,
    pedCoords.z - 0.85,
    pedCoords.w,
    false,
    true
  )

  FreezeEntityPosition(pedHandle, true)
  SetEntityInvincible(pedHandle, true)
  SetBlockingOfNonTemporaryEvents(pedHandle, true)

  if pedScenario then
    TaskStartScenarioInPlace(pedHandle, pedScenario, 0, true)
  end

  SetModelAsNoLongerNeeded(GetHashKey(pedModel))
  return pedHandle
end

local function randomInteractCoords()
  local index = math.random(1, #config.taskCoords)
  local coords = config.taskCoords[index]
  return coords
end

local function createWayPoint()
  local coords = randomInteractCoords()
  assert(type(coords) == 'vector3', 'something went wrong')
  waypoint = AddBlipForCoord(coords.x, coords.y, coords.z)

  SetBlipSprite(waypoint, config.settings.blipWaypoint.sprite)
  SetBlipColour(waypoint, config.settings.blipWaypoint.color.blip)
  SetBlipScale(waypoint, config.settings.blipWaypoint.scale)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(config.settings.blipWaypoint.label)
  EndTextCommandSetBlipName(waypoint)

  SetBlipRoute(waypoint, true)
  SetBlipRouteColour(waypoint, config.settings.blipWaypoint.color.route)
  return coords
end

local function takeThePackage()
  local locale = config.settings.task.notify
  local playerPed = cache.ped
  local dict = "pickup_object"
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do Wait(0) end

  TaskPlayAnim(
    playerPed,
    "pickup_object",
    "pickup_low",
    1.5,
    1.5,
    1000,
    49,
    0,
    false,
    false,
    false
  )
  if lib.progressBar({
    duration = 1000,
    position = 'bottom',
    label = locale.progressBar,
    useWhileDead = false,
    canCancel = true,
    disable = { move = true, car = true, combat = true },
  }) then
    ClearPedTasks(playerPed)
    local callback = lib.callback.await('tr_criminiltasks:server:receiveItem', GetPlayerServerId(playerPed))
    if not callback.success then
      lib.notify({
        title = "Error",
        description = ("Something went wrong, Could not give item: %s, Please contact support"):format(callback.error),
        type = "error"
      })
      return
  end
    assert(callback.success == true, ("Failed to give %s, the reason: %s"):format(callback.selectedItem, callback.response))

    DeleteEntity(prop)

    lib.notify({
      title = locale.title,
      description = locale.success,
      type = 'success'
    })
    isPlayerFree = true
  else
    ClearPedTasks(playerPed)
    lib.notify({
      title = locale.canceled,
      description = locale.description,
      type = 'error'
    })
  end
end

local function createPackage(coords)
  local task = config.settings.task
  local model = task.propModel
  local target = task.target
  RequestModel(model)
  while not HasModelLoaded(model) do
    Wait(0)
  end

  prop = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
  SetEntityHeading(prop, 0.0)
  PlaceObjectOnGroundProperly(prop)

  SetEntityAsMissionEntity(prop, true, true)

  exports.ox_target:addLocalEntity(prop, {
    {
      name = tostring(prop),
      icon = target.icon,
      label = target.label,
      distance = target.distance,
      onSelect = function()
        takeThePackage()
      end
    }
  })
  return prop
end

local function takeTask()
  isPlayerFree = false
  local coords = createWayPoint()
  prop = createPackage(coords)
  export:Notify(config.settings.task.notify.take, 'success', 10000)
end

local function abortTask()
  isPlayerFree = true
  RemoveBlip(waypoint)
  export:Notify(config.settings.task.notify.abort, 'error', 10000)
  DeleteEntity(prop)
  exports.ox_target:removeLocalEntity(prop, tostring(prop))
  prop = nil
end

CreateThread(function()
  for pedIndex, data in pairs(config.peds) do
    local pedCoords = data.Coords
    createPed(data.model, pedCoords, data.scenario)
    exports.ox_target:addBoxZone({
      coords = vec3(pedCoords.x, pedCoords.y, pedCoords.z),
      size = vec3(1, 1, 2),
      debug = false,
      options = {
        {
          label = config.settings.ped.take.targetLabel,
          icon = config.settings.ped.take.targetIcon,
          onSelect = function()
            takeTask()
          end,
          canInteract = function()
            return isPlayerFree
          end,
          distance = config.settings.ped.take.distance,
        },
        {
          label = config.settings.ped.abort.targetLabel,
          icon = config.settings.ped.abort.targetIcon,
          onSelect = function()
            abortTask()
          end,
          canInteract = function()
            return not isPlayerFree
          end,
          distance = config.settings.ped.abort.distance,
        },
      }
    })
  end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if resourceName == GetCurrentResourceName() then
    if not isPlayerFree then
      abortTask()
      isPlayerFree = false
    end
  end
end)