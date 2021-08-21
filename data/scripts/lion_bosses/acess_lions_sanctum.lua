statues_teleport = {
    enter_lion_sanctum = {
        position_statue = Position(33137, 32352, 5),
        position_teleport = Position(33117, 32252, 10),
    },
    exit_lion_sanctum = {
        position_statue = Position(33116, 32252, 10),
        position_teleport = Position(33137, 32353, 5),
    },
    lion_sanctum_first_floor = {
        position_statue = Position(33092, 32314, 11),
        position_teleport = Position(33090, 32280, 12),
    },
    lion_sanctum_second_floor = {
        position_statue = Position(33090, 32279, 12),
        position_teleport = Position(33092, 32315, 11),
    },
    
}
local lionsStatuesTeleportEnter = Action()
function lionsStatuesTeleportEnter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
        local statuePos = item:getPosition()
        if statuePos == statues_teleport.enter_lion_sanctum.position_statue then
            player:teleportTo(statues_teleport.enter_lion_sanctum.position_teleport)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)            
            return true
        elseif statuePos == statues_teleport.exit_lion_sanctum.position_statue then
            player:teleportTo(statues_teleport.exit_lion_sanctum.position_teleport)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)            
            return true   
        elseif statuePos == statues_teleport.lion_sanctum_first_floor.position_statue then
            player:teleportTo(statues_teleport.lion_sanctum_first_floor.position_teleport)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)            
            return true      
        elseif statuePos == statues_teleport.lion_sanctum_second_floor.position_statue then
            player:teleportTo(statues_teleport.lion_sanctum_second_floor.position_teleport)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)            
            return true            
        end
end
lionsStatuesTeleportEnter:aid(40100)
lionsStatuesTeleportEnter:register()