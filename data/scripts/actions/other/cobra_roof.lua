local goPos = {x = 33395, y = 32651, z = 2}

local cobraRoof = Action()
function cobraRoof.onUse(creature, item, position, fromPosition, pos, target, toPosition)
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

cobraRoof:aid(61038)
cobraRoof:register()