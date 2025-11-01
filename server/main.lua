local lib<const> = exports.tr_lib:require '@tr_lib/get'
local require<const> = function(arg) return lib.require(arg) end
local config = require 'config/server'

lib.callback.register('tr_criminiltasks:server:receiveItem', function(source)
  local roll = math.random(1, 100)
  local cumulative = 0
  local selectedItem, selectedAmount

  for itemName, data in pairs(config.items) do
    cumulative = cumulative + data.percentage
    if roll <= cumulative then
      selectedItem = itemName
      selectedAmount = data.amount or 1
      break
    end
  end

  if not selectedItem then
    return { success = false, error = "No item rolled (percentages misconfigured)" }
  end

  local success, response = exports.ox_inventory:AddItem(source, selectedItem, selectedAmount)

  return { item = selectedItem, amount = selectedAmount, success = success, response = response }
end)