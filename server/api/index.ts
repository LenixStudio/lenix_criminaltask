import { onPromise } from '@trippler/tr_lib/server'
import { receiveItem } from '../services'

onPromise('lenix_criminiltasks:server:receiveItem', (source) => {
  receiveItem(source)
})

export const addItem = exports.ox_inventory.AddItem