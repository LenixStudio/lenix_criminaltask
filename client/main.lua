local lib = exports.tr_lib:require '@tr_lib/init'
local require<const> = function(arg) return lib.require(arg) end
local config = require 'config/client'
local isPlayerFree = true
local waypoint, prop
local export = exports.qbx_core
local bridge = require 'client/bridge'
local progress = bridge.progress
local target = bridge.target

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
  if progress(locale) then
    ClearPedTasks(playerPed)
    local callback = lib.callback.await('tr_criminiltasks:server:receiveItem', GetPlayerServerId(playerPed))
    if not callback.success then
      export:Notify({
        text = "Error",
        subTitle = ("Something went wrong, Could not give item: %s, Please contact support"):format(callback.error),
        notifyType = "error"
      })
      return
  end
    assert(callback.success == true, ("Failed to give %s, the reason: %s"):format(callback.selectedItem, callback.response))

    DeleteEntity(prop)

    export:Notify({
      text = locale.title,
      subTitle = locale.success,
      notifyType = 'success'
    })
    isPlayerFree = true
    RemoveBlip(waypoint)
  else
    ClearPedTasks(playerPed)
    export:Notify({
      text = locale.canceled,
      subTitle = locale.description,
      notifyType = 'error'
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

  target.addLocalEntity(prop, target)
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
  target.removeLocalEntity(prop)
  prop = nil
end

CreateThread(function()
  for pedIndex, data in pairs(config.peds) do
    local pedCoords = data.Coords
    createPed(data.model, pedCoords, data.scenario)
    target.addBoxZone(pedCoords, config, takeTask, isPlayerFree, abortTask)
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