import { takeThePackage } from "../modules"
import { config } from "../../shared/constants"

const progress = (label: string) => {
  return exports.ox_lib.progressBar({
    duration: 1000,
    label: label,
    useWhileDead: false,
    canCancel: true,
    disable: { 
      move: true,
      car: true,
      combat: true
    },
  })
}

const addLocalEntity = (prop: number, target: any) => {
  exports.ox_target.addLocalEntity(prop, [
    {
      name: prop,
      icon: target.icon,
      label: target.label,
      distance: target.distance,
      onSelect: takeThePackage
    }
  ])
}

const addBoxZone = (pedCoords: number[], takeTask: Function, isPlayerFree: boolean, abortTask: Function) => {
  exports.ox_target.addBoxZone({
    coords: [pedCoords[0], pedCoords[1], pedCoords[2]],
    size: [1, 1, 2],
    debug: false,
    options: [
      {
        label: config.settings.ped.take.targetLabel,
        icon: config.settings.ped.take.targetIcon,
        onSelect: takeTask,
        canInteract: isPlayerFree,
        distance: config.settings.ped.take.distance,
      },
      {
        label: config.settings.ped.abort.targetLabel,
        icon: config.settings.ped.abort.targetIcon,
        onSelect: abortTask,
        canInteract: !isPlayerFree,
        distance: config.settings.ped.abort.distance,
      },
    ]
  })
}

const removeLocalEntity = (prop: number) => {
  exports.ox_target.removeLocalEntity(prop, prop)
}

const notify = (title: string, subTitle?: string, type?: string, duration?: number) => {
  exports.qbx_core.Notify(title, subTitle, type, duration)
}

export const bridge = { progress, addLocalEntity, addBoxZone, removeLocalEntity, notify }