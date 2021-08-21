local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local vocation = {}
local town = {}
local config = {
	towns = {
		["venore"] = TOWNS_LIST.VENORE,
		["thais"] = TOWNS_LIST.THAIS,
		["carlin"] = TOWNS_LIST.CARLIN
	},

	vocations = {
		["sorcerer"] = {
			text = "A SORCERER! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
			vocationId = 1,
			--equipment spellbook, wand of vortex, magician's robe, mage hat, studded legs, leather boots, scarf
			{{2175, 1}, {2190, 1}, {8819, 1}, {8820, 1}, {2468, 1}, {2643, 1}, {2661, 1}},
			--container rope, shovel, mana potion, adventurer's stone
			{{2120, 1}, {2554, 1}, {7620, 1}, {18559, 1}}
		},

		["druid"] = {
			text = "A DRUID! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
			vocationId = 2,
			--equipment spellbook, snakebite rod, magician's robe, mage hat, studded legs, leather boots scarf
			{{2175, 1}, {2182, 1}, {8819, 1}, {8820, 1}, {2468, 1}, {2643, 1}, {2661, 1}},
			--container rope, shovel, mana potion, adventurer's stone
			{{2120, 1}, {2554, 1}, {7620, 1}, {18559, 1}}
		},

		["paladin"] = {
			text = "A PALADIN! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
			vocationId = 3,
			--equipment dwrven shield, 5 spear, ranger's cloak, ranger legs scarf, legion helmet
			{{2525, 1}, {2389, 5}, {2660, 1}, {8923, 1}, {2643, 1}, {2661, 1}, {2480, 1}},
			--container rope, shovel, health potion, bow, 50 arrow, adventurer's stone
			{{2120, 1}, {2554, 1}, {7618, 1}, {2456, 1}, {2544, 50}, {18559, 1}}
		},

		["knight"] = {
			text = "A KNIGHT! ARE YOU SURE? THIS DECISION IS IRREVERSIBLE!",
			vocationId = 4,
			--equipment dwarven shield, steel axe, brass armor, brass helmet, brass legs scarf
			{{2525, 1}, {8601, 1}, {2465, 1}, {2460, 1}, {2478, 1}, {2643, 1}, {2661, 1}},
			--container jagged sword, daramian mace, rope, shovel, health potion, adventurer's stone
			{{8602, 1}, {2439, 1}, {2120, 1}, {2554, 1}, {7618, 1}, {18559, 1}}
		}
	}
}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	local player = Player(cid)
	local level = player:getLevel()
	if level < 8 then
		npcHandler:say("CHILD! COME BACK WHEN YOU HAVE GROWN UP!", cid)
		npcHandler:resetNpc(cid)
		return false
	elseif level > 10 then
		npcHandler:say(player:getName() ..", I CAN'T LET YOU LEAVE - YOU ARE TOO STRONG ALREADY! YOU CAN ONLY LEAVE WITH LEVEL 9 OR LOWER.", cid)
		npcHandler:resetNpc(cid)
		return false
	elseif player:getVocation():getId() > 0 then
		npcHandler:say("YOU ALREADY HAVE A VOCATION!", cid)
		npcHandler:resetNpc(cid)
		return false
	else
		npcHandler:setMessage(MESSAGE_GREET, player:getName() ..", ARE YOU PREPARED TO FACE YOUR DESTINY?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if npcHandler.topic[cid] == 0 then
		if msgcontains(msg, "yes") then
			npcHandler:say("IN WHICH TOWN DO YOU WANT TO LIVE: {CARLIN}, {THAIS}, OR {VENORE}?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 1 then
		local cityTable = config.towns[msg:lower()]
		if cityTable then
			town[cid] = cityTable
			npcHandler:say("IN ".. string.upper(msg) .."! AND WHAT PROFESSION HAVE YOU CHOSEN: {KNIGHT}, {PALADIN}, {SORCERER}, OR {DRUID}?", cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say("IN WHICH TOWN DO YOU WANT TO LIVE: {CARLIN}, {THAIS}, OR {VENORE}?", cid)
		end
	elseif npcHandler.topic[cid] == 2 then
		local vocationTable = config.vocations[msg:lower()]
		if vocationTable then
			npcHandler:say(vocationTable.text, cid)
			npcHandler.topic[cid] = 3
			vocation[cid] = vocationTable.vocationId
		else
			npcHandler:say("{KNIGHT}, {PALADIN}, {SORCERER}, OR {DRUID}?", cid)
		end
	elseif npcHandler.topic[cid] == 3 then
		if msgcontains(msg, "yes") then
			npcHandler:say("SO BE IT!", cid)
			player:setVocation(Vocation(vocation[cid]))
			player:setTown(Town(town[cid]))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(Town(town[cid]):getTemplePosition())
			
			-- Liquid Black
			player:setStorageValue(Storage.LiquidBlackQuest.QuestLine, 1)
			player:setStorageValue(Storage.LiquidBlackQuest.Visitor, 5)
				
			-- Bigfoot's Burden
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 2)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 4)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 7)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 9)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 12)
			player:setStorageValue(Storage.BigfootBurden.Shooting, 5)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 16)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 20)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 23)
			player:setStorageValue(Storage.BigfootBurden.QuestLineComplete, 2)
			player:setStorageValue(Storage.BigfootBurden.Rank, 1440)
			player:setStorageValue(Storage.BigfootBurden.Warzone1Access, 2)
			player:setStorageValue(Storage.BigfootBurden.Warzone2Access, 2)
			player:setStorageValue(Storage.BigfootBurden.Warzone3Access, 2)

			-- WZ 4, 5 e 6
			player:setStorageValue(Storage.DangerousDepths.Questline, 10)
			player:setStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneVI, 10)
			player:setStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneV, 10)
			player:setStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneIV, 30)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Status, 10)
			player:setStorageValue(Storage.DangerousDepths.Scouts.Status, 10)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Status, 10)	

			--In Service of Yalahar 
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 51)
			player:setStorageValue(Storage.InServiceofYalahar.Mission01, 6)
			player:setStorageValue(Storage.InServiceofYalahar.Mission02, 8)
			player:setStorageValue(Storage.InServiceofYalahar.Mission03, 6)
			player:setStorageValue(Storage.InServiceofYalahar.Mission04, 6)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 8)
			player:setStorageValue(Storage.InServiceofYalahar.Mission06, 5)
			player:setStorageValue(Storage.InServiceofYalahar.Mission07, 5)
			player:setStorageValue(Storage.InServiceofYalahar.Mission08, 4)
			player:setStorageValue(Storage.InServiceofYalahar.Mission09, 2)
			player:setStorageValue(Storage.InServiceofYalahar.Mission10, 1)
			-- part 2
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe01, 1)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe02, 1)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe03, 1)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe04, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DiseasedDan, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DiseasedBill, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DiseasedFred, 1)
			player:setStorageValue(Storage.InServiceofYalahar.AlchemistFormula, 1)
			player:setStorageValue(Storage.InServiceofYalahar.BadSide, 1)
			player:setStorageValue(Storage.InServiceofYalahar.GoodSide , 1)
			player:setStorageValue(Storage.InServiceofYalahar.MrWestDoor, 1)
			player:setStorageValue(Storage.InServiceofYalahar.MrWestStatus, 1)
			player:setStorageValue(Storage.InServiceofYalahar.TamerinStatus, 1)
			player:setStorageValue(Storage.InServiceofYalahar.MorikSummon, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraSplasher, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraSharptooth, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraInky, 1)
			player:setStorageValue(Storage.InServiceofYalahar.MatrixState, 1)
			player:setStorageValue(Storage.InServiceofYalahar.NotesPalimuth, 1)
			player:setStorageValue(Storage.InServiceofYalahar.NotesAzerus, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DoorToAzerus, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DoorToBog, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DoorToLastFight, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DoorToMatrix, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DoorToQuara, 1)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe01, 1)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe02, 1)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe03, 1)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe04, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DiseasedDan, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DiseasedBill, 1)
			player:setStorageValue(Storage.InServiceofYalahar.DiseasedFred, 1)
			player:setStorageValue(Storage.InServiceofYalahar.AlchemistFormula, 1)
			player:setStorageValue(Storage.InServiceofYalahar.BadSide, 1)
			player:setStorageValue(Storage.InServiceofYalahar.GoodSide, 1)
			player:setStorageValue(Storage.InServiceofYalahar.MrWestDoor, 1)
			player:setStorageValue(Storage.InServiceofYalahar.MrWestStatus, 1)
			player:setStorageValue(Storage.InServiceofYalahar.TamerinStatus, 1)
			player:setStorageValue(Storage.InServiceofYalahar.MorikSummon, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraSplasher, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraSharptooth, 1)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraInky, 1)	

			--Cults of Tibia Quest.
			player:setStorageValue(Storage.CultsOfTibia.Questline, 7)
			player:setStorageValue(Storage.CultsOfTibia.Minotaurs.jamesfrancisTask, 1)
			player:setStorageValue(Storage.CultsOfTibia.Minotaurs.Mission, 1)
			player:setStorageValue(Storage.CultsOfTibia.Minotaurs.bossTimer, 1)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, 1)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Pedra1, 1)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Pedra2, 1)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Pedra3, 1)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Respostas, 1)
			player:setStorageValue(Storage.CultsOfTibia.MotA.Perguntaid, 1)
			player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 1)
			player:setStorageValue(Storage.CultsOfTibia.Barkless.sulphur, 1)
			player:setStorageValue(Storage.CultsOfTibia.Barkless.tar, 1)
			player:setStorageValue(Storage.CultsOfTibia.Barkless.ice, 1)
			player:setStorageValue(Storage.CultsOfTibia.Barkless.Objects, 1)
			player:setStorageValue(Storage.CultsOfTibia.Barkless.Temp, 1)
			player:setStorageValue(Storage.CultsOfTibia.Barkless.bossTimer, 1)
			player:setStorageValue(Storage.CultsOfTibia.Orcs.Mission, 1)
			player:setStorageValue(Storage.CultsOfTibia.Orcs.lookType, 1)
			player:setStorageValue(Storage.CultsOfTibia.Orcs.bossTimer, 1)
			player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 1)
			player:setStorageValue(Storage.CultsOfTibia.Life.bossTimer, 1)
			player:setStorageValue(Storage.CultsOfTibia.Humans.Mission, 1)
			player:setStorageValue(Storage.CultsOfTibia.Humans.Vaporized, 1)
			player:setStorageValue(Storage.CultsOfTibia.Humans.Decaying, 1)
			player:setStorageValue(Storage.CultsOfTibia.Humans.bossTimer, 1)
			player:setStorageValue(Storage.CultsOfTibia.Misguided.Mission, 1)
			player:setStorageValue(Storage.CultsOfTibia.Misguided.Monsters, 1)
			player:setStorageValue(Storage.CultsOfTibia.Misguided.Exorcisms, 1)
			player:setStorageValue(Storage.CultsOfTibia.Misguided.Time, 1)
			player:setStorageValue(Storage.CultsOfTibia.Misguided.bossTimer, 1)

			-- The Explorer Society
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 1) -- Joining the Explorers
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 4)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 7)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 16)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 26)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 29)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 32)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 35)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 38)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 41)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 43)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 46)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 47)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 50)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 55)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 56)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 58)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 61)
			player:setStorageValue(Storage.ExplorerSociety.CalassaQuest, 2)

			-- The Forgotten Knowledge
			player:setStorageValue(Storage.ForgottenKnowledge.Tomes, 1)
			player:setStorageValue(Storage.ForgottenKnowledge.LastLoreKilled, 1)    
			player:setStorageValue(Storage.ForgottenKnowledge.TimeGuardianKilled, 1)
			player:setStorageValue(Storage.ForgottenKnowledge.HorrorKilled, 1)
			player:setStorageValue(Storage.ForgottenKnowledge.DragonkingKilled, 1)
			player:setStorageValue(Storage.ForgottenKnowledge.ThornKnightKilled, 1)
			player:setStorageValue(Storage.ForgottenKnowledge.LloydKilled, 1)
			player:setStorageValue(Storage.ForgottenKnowledge.LadyTenebrisKilled, 1)
			player:setStorageValue(Storage.ForgottenKnowledge.AccessMachine, 1)

			-- Children of the Revolution Quest.
			player:setStorageValue(Storage.ChildrenoftheRevolution.Questline, 21)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Mission00, 2)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Mission01, 3)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Mission02, 5)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Mission03, 3)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Mission04, 6)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Mission05, 3)
			player:setStorageValue(Storage.ChildrenoftheRevolution.SpyBuilding01, 1)
			player:setStorageValue(Storage.ChildrenoftheRevolution.SpyBuilding02, 1)
			player:setStorageValue(Storage.ChildrenoftheRevolution.SpyBuilding03, 1)
			player:setStorageValue(Storage.ChildrenoftheRevolution.StrangeSymbols, 1)

			-- Factions
			player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 2)
			player:setStorageValue(Storage.DjinnWar.Faction.Marid, 2)
			player:setStorageValue(Storage.DjinnWar.Faction.Efreet, 2)
			player:setStorageValue(Storage.DjinnWar.Faction.MaridDoor, 1)
			player:setStorageValue(Storage.DjinnWar.Faction.EfreetDoor, 1)
			-- Efreet
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Start, 1)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 3)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 3)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission03, 3)
			-- Marid
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Start, 1)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 2)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission02, 2)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.RataMari, 2)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission03, 3)

			-- The Way to Yalahar
			player:setStorageValue(Storage.TheWayToYalahar.Questline, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.TownsCounter, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.AbDendriel, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.Darashia, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.Venore, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.Ankrahmun, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.PortHope, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.Thais, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.LibertyBay, 1)
			player:setStorageValue(Storage.SearoutesAroundYalahar.Carlin, 1)

			-- The Hidden City of Beregar
			player:setStorageValue(Storage.HiddenCityOfBeregar.DefaultStart, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.GoingDown, 1)

			-- The Ice Islands Quest
			player:setStorageValue(Storage.TheIceIslands.Questline, 12)
			player:setStorageValue(Storage.TheIceIslands.Mission01, 3)
			player:setStorageValue(Storage.TheIceIslands.Mission02, 5)
			player:setStorageValue(Storage.TheIceIslands.Mission03, 3)
			player:setStorageValue(Storage.TheIceIslands.Mission04, 2)
			player:setStorageValue(Storage.TheIceIslands.Mission05, 6)
			player:setStorageValue(Storage.TheIceIslands.Mission06, 8)
			player:setStorageValue(Storage.TheIceIslands.Mission07, 3)
			player:setStorageValue(Storage.TheIceIslands.Mission08, 4)
			player:setStorageValue(Storage.TheIceIslands.Mission09, 2)
			player:setStorageValue(Storage.TheIceIslands.Mission10, 2)
			player:setStorageValue(Storage.TheIceIslands.Mission11, 2)
			player:setStorageValue(Storage.TheIceIslands.Mission12, 6)

			-- The Inquisition
			player:setStorageValue(Storage.TheInquisition.Questline, 25)
			player:setStorageValue(Storage.TheInquisition.Mission01, 7)
			player:setStorageValue(Storage.TheInquisition.Mission02, 3)
			player:setStorageValue(Storage.TheInquisition.Mission03, 6)
			player:setStorageValue(Storage.TheInquisition.Mission04, 3)
			player:setStorageValue(Storage.TheInquisition.Mission05, 3)
			player:setStorageValue(Storage.TheInquisition.Mission06, 3)
			player:setStorageValue(Storage.TheInquisition.Mission07, 1)
			player:setStorageValue(Storage.TheInquisition.GrofGuard, 1)
			player:setStorageValue(Storage.TheInquisition.KulagGuard, 1)
			player:setStorageValue(Storage.TheInquisition.TimGuard, 1)
			player:setStorageValue(Storage.TheInquisition.WalterGuard, 1)
			player:setStorageValue(Storage.TheInquisition.StorkusVampiredust, 1)

			-- The New Frontier
			player:setStorageValue(Storage.TheNewFrontier.Questline, 28)
			player:setStorageValue(Storage.TheNewFrontier.Mission01, 3)
			player:setStorageValue(Storage.TheNewFrontier.Mission02, 6)
			player:setStorageValue(Storage.TheNewFrontier.Mission03, 3)
			player:setStorageValue(Storage.TheNewFrontier.Mission04, 2)
			player:setStorageValue(Storage.TheNewFrontier.Mission05, 7)
			player:setStorageValue(Storage.TheNewFrontier.Mission06, 3)
			player:setStorageValue(Storage.TheNewFrontier.Mission07, 3)
			player:setStorageValue(Storage.TheNewFrontier.Mission08, 2)
			player:setStorageValue(Storage.TheNewFrontier.Mission09, 3)
			player:setStorageValue(Storage.TheNewFrontier.Mission10, 1)
			player:setStorageValue(Storage.TheNewFrontier.TomeofKnowledge, 12)
			player:setStorageValue(Storage.TheNewFrontier.Beaver1, 1)
			player:setStorageValue(Storage.TheNewFrontier.Beaver2, 1)
			player:setStorageValue(Storage.TheNewFrontier.Beaver3, 1)
			player:setStorageValue(Storage.TheNewFrontier.BribeKing, 1)
			player:setStorageValue(Storage.TheNewFrontier.BribeLeeland, 1)
			player:setStorageValue(Storage.TheNewFrontier.BribeExplorerSociety, 1)
			player:setStorageValue(Storage.TheNewFrontier.BribeWydrin, 1)
			player:setStorageValue(Storage.TheNewFrontier.BribeTelas, 1)

			-- The ice islands
			player:setStorageValue(12200, 1) -- Storage through the Quest
			player:setStorageValue(12201, 3) -- Befriending the Musher
			player:setStorageValue(12202, 5) -- Nibelor 1: Breaking the Ice
			player:setStorageValue(12203, 3) -- Nibelor 2: Ecological Terrorism
			player:setStorageValue(12204, 2) -- Nibelor 3: Artful Sabotage
			player:setStorageValue(12205, 6) -- Nibelor 4: Berserk Brewery
			player:setStorageValue(12206, 8) -- Nibelor 5: Cure the Dogs
			player:setStorageValue(12207, 3) -- The Secret of Helheim
			player:setStorageValue(12208, 4) -- The Contact
			player:setStorageValue(12209, 2) -- Formorgar Mines 1: The Mission
			player:setStorageValue(12210, 2) -- Formorgar Mines 2: Ghostwhisperer
			player:setStorageValue(12211, 2) -- Formorgar Mines 3: The Secret
			player:setStorageValue(12212, 1) -- Formorgar Mines 4: Retaliation

			-- The Shattered Isles
			player:setStorageValue(Storage.TheShatteredIsles.DefaultStart, 3)
			player:setStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter, 3)
			player:setStorageValue(Storage.TheShatteredIsles.TheErrand, 2)
			player:setStorageValue(Storage.TheShatteredIsles.AccessToMeriana, 1)
			player:setStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid, 3)
			player:setStorageValue(Storage.TheShatteredIsles.ADjinnInLove, 5)
			player:setStorageValue(Storage.TheShatteredIsles.AccessToLagunaIsland, 1)
			player:setStorageValue(Storage.TheShatteredIsles.AccessToGoroma, 1)
			player:setStorageValue(Storage.TheShatteredIsles.Shipwrecked, 2)
			player:setStorageValue(Storage.TheShatteredIsles.DragahsSpellbook, 1)
			player:setStorageValue(Storage.TheShatteredIsles.TheCounterspell, 4)

			-- The Thieves Guild.
			player:setStorageValue(Storage.ThievesGuild.Quest, 1)
			player:setStorageValue(Storage.ThievesGuild.Mission01, 2)
			player:setStorageValue(Storage.ThievesGuild.Mission02, 3)
			player:setStorageValue(Storage.ThievesGuild.Mission03, 3)
			player:setStorageValue(Storage.ThievesGuild.Mission04, 8)
			player:setStorageValue(Storage.ThievesGuild.Mission05, 2)
			player:setStorageValue(Storage.ThievesGuild.Mission06, 4)
			player:setStorageValue(Storage.ThievesGuild.Mission07, 2)
			player:setStorageValue(Storage.ThievesGuild.Mission08, 3)

			-- The Travelling Trader Quest
			player:setStorageValue(Storage.TravellingTrader.Mission01, 1)
			player:setStorageValue(Storage.TravellingTrader.Mission01, 2)
			player:setStorageValue(Storage.TravellingTrader.Mission02, 5)
			player:setStorageValue(Storage.TravellingTrader.Mission03, 3)
			player:setStorageValue(Storage.TravellingTrader.Mission04, 3)
			player:setStorageValue(Storage.TravellingTrader.Mission05, 3)
			player:setStorageValue(Storage.TravellingTrader.Mission06, 2)
			player:setStorageValue(Storage.TravellingTrader.Mission07, 1)

			-- The Ultimate Challenges Quest.
			player:setStorageValue(Storage.SvargrondArena.QuestLogGreenhorn, 1)

			-- Tibia Tales.
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest, 1)

			-- The Postman
			player:setStorageValue(12450, 6) -- Mission 1 - Check Postal Routes
			player:setStorageValue(12451, 3) -- Mission 2 - Fix Mailbox
			player:setStorageValue(12452, 3) -- Mission 3 - Bill Delivery
			player:setStorageValue(12453, 2) -- Mission 4 - Aggressive Dogs
			player:setStorageValue(12454, 4) -- Mission 5 - Present Delivery
			player:setStorageValue(12455, 13) -- Mission 6 - New Uniforms
			player:setStorageValue(12456, 8) -- Mission 7 - Measurements
			player:setStorageValue(12457, 3) -- Mission 8 - Missing Courier
			player:setStorageValue(12458, 4) -- Mission 9 - Dear Santa
			player:setStorageValue(12459, 3) -- Mission 10 - Mintwallin
			player:setStorageValue(12460, 5)  -- Postman Rank

			-- Unnatural Selection
			player:setStorageValue(12330, 1) -- Storage through the Quest
			player:setStorageValue(12331, 3) -- Mission 1: Skulled
			player:setStorageValue(12332, 13) -- Mission 2: All Around the World
			player:setStorageValue(12333, 3) -- Mission 3: Dance Dance Evolution
			player:setStorageValue(12334, 2) -- Mission 4: Bits and Pieces
			player:setStorageValue(12335, 3) -- Mission 5: Ray of Light
			player:setStorageValue(12336, 3) -- Mission 6: Firewater Burn

			-- Friends and Traders
			player:setStorageValue(Storage.FriendsandTraders.DefaultStart, 1)
			player:setStorageValue(Storage.FriendsandTraders.TheSweatyCyclops, 2)
			player:setStorageValue(Storage.FriendsandTraders.TheMermaidMarina, 2)
			player:setStorageValue(Storage.FriendsandTraders.TheBlessedStake, 12)			

			-- KilmareshQuest
			player:setStorageValue(22000, 5) -- Town Counter

			-- Wrath of the Emperor
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 1)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission01, 3)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission02, 3)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission03, 3)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission04, 3)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission05, 3)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission06, 4)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission07, 6)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission08, 2)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission09, 2)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 6)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission11, 1)

			-- The Ape City Quest.
			player:setStorageValue(Storage.TheApeCity.Started, 1)
			player:setStorageValue(Storage.TheApeCity.Questline, 18)

			-- Oramond.
			player:setStorageValue(Storage.Oramond.QuestLine, 1)
			player:setStorageValue(Storage.Oramond.MissionToTakeRoots, 3000)

			-- Dangerous Depths.
			player:setStorageValue(Storage.DangerousDepths.Questline, 1)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Home, 2)
			player:setStorageValue(Storage.DangerousDepths.Dwarves.Subterranean, 2)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Measurements, 2)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Ordnance, 3)
			player:setStorageValue(Storage.DangerousDepths.Gnomes.Charting, 2)
			player:setStorageValue(Storage.DangerousDepths.Scouts.Growth, 2)
			player:setStorageValue(Storage.DangerousDepths.Scouts.Diremaw, 2)

			-- Threatened Dreams
			player:setStorageValue(Storage.ThreatenedDreams.Start, 1)
			player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 4)
			player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 17)		
			player:setStorageValue(Storage.ThreatenedDreams.TatteredSwanFeathers, 5)

			-- Adventurers Guild.
			player:setStorageValue(Storage.AdventurersGuild.GreatDragonHunt.WarriorSkeleton, 1)
			player:setStorageValue(Storage.AdventurersGuild.GreatDragonHunt.WarriorSkeleton, 2)

			-- Dawnport
			player:setStorageValue(Storage.Quest.Dawnport.Questline, 1)
			player:setStorageValue(Storage.Quest.Dawnport.GoMain, 1)			
                 
			local targetVocation = config.vocations[Vocation(vocation[cid]):getName():lower()]
			for i = 1, #targetVocation[1] do
				player:addItem(targetVocation[1][i][1], targetVocation[1][i][2])
			end
			local backpack = player:addItem(1988)
			for i = 1, #targetVocation[2] do
				backpack:addItem(targetVocation[2][i][1], targetVocation[2][i][2])
			end
		player:remove()
		else
			npcHandler:say("THEN WHAT? {KNIGHT}, {PALADIN}, {SORCERER}, OR {DRUID}?", cid)
			npcHandler.topic[cid] = 2
		end
	end
	return true
end

local function onAddFocus(cid)
	town[cid] = 0
	vocation[cid] = 0
end

local function onReleaseFocus(cid)
	town[cid] = nil
	vocation[cid] = nil
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "COME BACK WHEN YOU ARE PREPARED TO FACE YOUR DESTINY!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "COME BACK WHEN YOU ARE PREPARED TO FACE YOUR DESTINY!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())