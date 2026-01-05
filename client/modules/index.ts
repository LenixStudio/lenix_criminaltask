import { requestModel, triggerPromise } from '@trippler/tr_lib/client'
import { createBlip, createSinglePed } from '@trippler/tr_kit/client'
import { assert } from '@trippler/tr_lib/shared'
import { bridge } from '../api'
import { ReceiveItem } from '../../server/services'
import { config } from '../../shared/constants'

export let isPlayerFree = true
export const setPlayerStatus = (state: boolean) => isPlayerFree = state
let waypoint: number, prop: number | null

const randomInteractCoords = () => {
  const index = Math.floor(Math.random() * config.taskCoords.length)
  const coords = config.taskCoords[index]
  return coords
}

const createWayPoint = () => {
  const coords = randomInteractCoords()
  assert(Array.isArray(coords) && coords.length === 3, 'something went wrong')

  waypoint = createBlip([coords[0], coords[1], coords[2]], config.settings.blipWaypoint.sprite)
  SetBlipColour(waypoint, config.settings.blipWaypoint.color.blip)
  SetBlipScale(waypoint, config.settings.blipWaypoint.scale)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(config.settings.blipWaypoint.label)
  EndTextCommandSetBlipName(waypoint)

  SetBlipRoute(waypoint, true)
  SetBlipRouteColour(waypoint, config.settings.blipWaypoint.color.route)
  return coords
}

const createPackage = async (coords: number[]) => {
  const task = config.settings.task
  const model = task.propModel
  const target = task.target
  await requestModel(GetHashKey(model))

  prop = CreateObject(GetHashKey(model), coords[0], coords[1], coords[2], true, true, false)
  SetEntityHeading(prop, 0.0)
  PlaceObjectOnGroundProperly(prop)

  SetEntityAsMissionEntity(prop, true, true)

  bridge.addLocalEntity(prop, target)
  return prop
}

export const takeTask = async () => {
  isPlayerFree = false
  const coords = createWayPoint()
  prop = await createPackage(coords)
  bridge.notify('Success', config.settings.task.notify.take, 'success')
}
  
export const abortTask = () => {
  isPlayerFree = true
  RemoveBlip(waypoint)
  bridge.notify('Error', config.settings.task.notify.abort, 'error')
  DeleteEntity(prop as number)
  bridge.removeLocalEntity(prop as number)
  prop = null
}

export const takeThePackage = async () => {
  const locale = config.settings.task.notify
  const playerPed = PlayerPedId()
  const dict = "pickup_object"

  RequestAnimDict(dict)
  await new Promise((resolve) => {
    const tick = setTick(() => {
      if (HasAnimDictLoaded(dict)) {
        clearTick(tick)
        resolve(true)
      }
    })
  })

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
  if (await bridge.progress(locale.progressBar)) {
    ClearPedTasks(playerPed)
    const callback = await triggerPromise<ReceiveItem>('lenix_criminiltasks:server:receiveItem')
    if (callback?.success) {
      bridge.notify('Error', `Something went wrong, Could not give item: ${callback.error}`, 'error')
      return
    }
    assert(callback?.success == true, `Failed to give ${callback?.item}, the reason: ${callback?.response}`)

    DeleteEntity(prop as number)

    bridge.notify(locale.title, locale.success, 'success')
    isPlayerFree = true
    RemoveBlip(waypoint)
  } else {
    ClearPedTasks(playerPed)
    bridge.notify(locale.canceled, locale.description, 'error')
  }
}

export const createPed = async (pedModel: string, pedCoords: number[], pedScenario: string) => {
  await requestModel(GetHashKey(pedModel))

  const [pedHandle, _pedNetId] = await createSinglePed({
    hash: GetHashKey(pedModel),
    coords: [pedCoords[0], pedCoords[1], pedCoords[2] - 0.85, pedCoords[3]],
    behavior: {
      freeze: true,
      oblivious: true
    },
    scenario: {
      name: pedScenario,
      timeToLeave: 0,
      playIntroClip: true
    }
  })

  return pedHandle
}