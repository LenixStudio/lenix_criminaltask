import { config } from "../../shared/constants"
import { bridge } from "../api"
import { abortTask, createPed, isPlayerFree, setPlayerStatus, takeTask } from "../modules"

setImmediate(() => {
  for (const data of config.peds) {
    const pedCoords = data.coords
    createPed(data.model, pedCoords as number[], data.scenario)
    bridge.addBoxZone(pedCoords as number[], takeTask, isPlayerFree, abortTask)
  }
})

on('onResourceStop', (resourceName: string) => {
  if (resourceName === GetCurrentResourceName()) {
    if (!isPlayerFree) {
      abortTask()
      setPlayerStatus(false)
    }
  }
})