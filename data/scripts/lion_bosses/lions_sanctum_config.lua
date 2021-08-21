if not bosses_lions_config then
	bosses_lions_config = {
		[40101] = {
			center = Position(33157, 32251, 12),
			maxRangeX = 7, minRangeX = 8, minRangeY = 9, maxRangeY = 9,
			bossResp = Position(33159, 32255, 12),
			boss = "yirkas blue scales",
			teleportTo = Position(33155, 32245,12),
			locked = false,
			interval = 60 * 60 * 20,-- 4 hours
			storage = Storage.lionsSanctumBosses.lionBoss1,
			exit = Position(33123, 32240, 12),
			tile_exit = Position(33154, 32245, 12)
		},
		[40102] = {
			center = Position(33087, 32245, 12),
			maxRangeX = 4, minRangeX = 4, minRangeY = 8, maxRangeY = 8,
			bossResp = Position(33087, 32250, 12),
			boss = "katex blood tongue",
			teleportTo = Position(33087, 32240, 12),
			locked = false,
			interval = 60 * 60 * 20,-- 4 hours
			storage = Storage.lionsSanctumBosses.lionBoss2,
			exit = Position(33123, 32264, 12),
			tile_exit = Position(33087, 32239, 12)
		},
		[40103] = {
			center = Position(33152, 32287, 12),
			maxRangeX = 8, minRangeX = 8, minRangeY = 8, maxRangeY = 8,
			bossResp = Position(33156, 32291, 12),
			boss = "srezz yellow eyes",
			teleportTo = Position(33149, 32283, 12), --Place where the player will be teleported inside the room
			locked = false,
			interval = 60 * 60 * 20,-- 4 hours
			storage = Storage.lionsSanctumBosses.lionBoss3,
			exit = Position(33115, 32252, 12),
			tile_exit = Position(33148, 32283, 12)
		},
        [40104] = {
			center = Position(33122, 32284, 12),
			maxRangeX = 8, minRangeX = 8, minRangeY = 8, maxRangeY = 8,
			bossResp = Position(33122, 32288, 12),
			boss = "utua stone sting",
			teleportTo = Position(33119, 32279, 12), --Place where the player will be teleported inside the room
			locked = false,
			interval = 60 * 60 * 20,-- 4 hours
			storage = Storage.lionsSanctumBosses.lionBoss4,
			exit = Position(33130, 32252, 12),
			tile_exit = Position(33119, 32278, 12)
		},
	}

	bosses_lions_config.spawnBoss = function (name, pos)
		local boss = Game.createMonster(name, pos, false, true)
		if boss then
			local c = bosses_lions_config.findByName(name)
			c.locked = true
			boss:registerEvent('BossLionsDeath')
		end
	end
	bosses_lions_config.findByName = function(name, last)
		local i, v = next(bosses_lions_config, last)
		if type(v) == 'table' and v.boss == name then
			return v
		elseif not i then
			return nil
		end
		return bosses_lions_config.findByName(name, i)
	end

	bosses_lions_config.getRoomCreatures = function(lionsbossroom)
		if not lionsbossroom then
			return {}
		end
	
		local ret = {}
		local specs = Game.getSpectators(lionsbossroom.center, false, false,
		lionsbossroom.minRangeX, lionsbossroom.maxRangeX, lionsbossroom.minRangeY, lionsbossroom.maxRangeY)
		for i = 1, #specs do
			ret[#ret+1] = specs[i]
		end
	
		return ret
	end
	
	bosses_lions_config.getRoomOccupant = function(lionsbossroom, ignorePlayer)
		local creatures = bosses_lions_config.getRoomCreatures(lionsbossroom)
		for i = 1, #creatures do
			if creatures[i]:isPlayer() and creatures[i]:getId() ~= ignorePlayer:getId() then
				return creatures[i]
			end
		end
	
		return nil
	end

	bosses_lions_config.clearArena = function(lionsbossroom)
		local spectators, spectator = Game.getSpectators(lionsbossroom.center, false, false,
		lionsbossroom.minRangeX, lionsbossroom.maxRangeX, lionsbossroom.minRangeY, lionsbossroom.maxRangeY)
		for i = 1, #spectators do
			spectator = spectators[i]
			if spectator:isPlayer() then
			else
				spectator:remove()
			end
		end
	end

	bosses_lions_config.resetRoom = function(lionsbossroom, msg, releaseRoom)
		if releaseRoom then
			lionsbossroom.locked = false
		end

		local spectators = Game.getSpectators(lionsbossroom.center, false, false,
		lionsbossroom.minRangeX, lionsbossroom.maxRangeX, lionsbossroom.minRangeY, lionsbossroom.maxRangeY)
		for i = 1, #spectators do
			if spectators[i]:isPlayer() then
				spectators[i]:teleportTo(lionsbossroom.exit)
				spectators[i]:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
			else
				spectators[i]:remove()
			end
		end
	end
end