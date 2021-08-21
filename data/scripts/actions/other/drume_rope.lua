local goPos = {x = 32453, y = 32509, z = 7}

local drumeAcces = Action()
function drumeAcces.onUse(creature, item, position, fromPosition, pos, target, toPosition)
    local player = creature:getPlayer()
    if not player then
        return
    end

    if player:getLevel() >= 0 then
        position:sendMagicEffect(CONST_ME_TELEPORT)
        player:teleportTo(goPos)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    else
        player:sendCancelMessage('')
    end
end

drumeAcces:aid(61039)
drumeAcces:register()