local function filter(list, f, i)
	if i < #list then
		if f(list[i]) then
			return list[i], filter(list, f, i + 1)
		else
			return filter(list, f, i + 1)
		end
	elseif list[i] and f(list[i]) then
		return list[i]
	end
end


local lionBosses = MoveEvent()
function lionBosses.onStepIn(creature, item, pos, fromPosition)
	if not creature:isPlayer() then
		creature:teleportTo(fromPosition)
		return false
	end

	local lions = bosses_lions_config[item:getActionId()]
	if not lions then
		return false
	end

	

	print(pos.x,pos.y,pos.z)
	if Position(pos) == lions.tile_exit then
		creature:say("Try again later.", TALKTYPE_MONSTER_SAY, false, player)
		creature:setStorageValue(lions.storage, os.time() + lions.interval)
		creature:teleportTo(lions.exit)
		return false
	elseif creature:getStorageValue(lions.storage) > os.time() then
		creature:say("You are still exhausted from your last battle.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)		
		creature:teleportTo(fromPosition)
		return false
	elseif bosses_lions_config.getRoomOccupant(lions, Player(creature.uid)) then
		creature:say("There is still someone else in there. Better wait for a few minutes.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)
		creature:teleportTo(fromPosition)
		return true
	elseif Position(pos) ~= lions.tile_exit then
	creature:say("You have ten minutes to kill and loot this boss, else you will lose that chance and will be kicked out.", TALKTYPE_MONSTER_SAY, false, player, lions.teleportTo)
	bosses_lions_config.clearArena(lions)
	creature:teleportTo(lions.teleportTo)
	bosses_lions_config.spawnBoss(lions.boss, lions.bossResp)
	return true
	end

end

lionBosses:type("stepin")
lionBosses:aid(40101, 40102, 40103, 40104)
lionBosses:register()