local function progress(locale)
    return lib.progressBar({
        duration = 1000,
        position = 'bottom',
        label = locale.progressBar,
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
    })
end

local function addLocalEntity(prop, target)
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
end

local function addBoxZone(pedCoords, config, takeTask, isPlayerFree, abortTask)
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

local function removeLocalEntity(prop)
  exports.ox_target:removeLocalEntity(prop, tostring(prop))
end

return {
    progress = progress,
    target = {
        addBoxZone = addBoxZone,
        addLocalEntity = addLocalEntity,
        removeLocalEntity = removeLocalEntity,
    }
}