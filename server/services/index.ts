import { config } from "../../shared/constants"
import { addItem } from "../api"

export const receiveItem = async (source: number) => {
  const roll = Math.floor(Math.random() * 100) + 1
  let cumulative = 0
  let selectedItem, selectedAmount

  for (const [itemName, data] of Object.entries(config.items)) {
    cumulative = cumulative + data.percentage
    if (roll <= cumulative) {
      selectedItem = itemName
      selectedAmount = data.amount || 1
      break
    }
  }

  if (!selectedItem) {
    return { success: false, error: "No item rolled (percentages misconfigured)" }
  }
  const [success, response] = await addItem(source, selectedItem, selectedAmount)

  return { item: selectedItem, amount: selectedAmount, success: success, response: response }
}

export type ReceiveItem = ReturnType<typeof receiveItem>