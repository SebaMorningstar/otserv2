local mType = Game.createMonsterType("Utua Stone Sting")
local monster = {}

monster.description = "a utua stone sting"
monster.experience = 5100
monster.outfit = {
	lookType = 398,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "blood"
monster.corpse = 13501
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
}

monster.loot = {
	{name = "platinum coin", chance = 35000, maxCount = 9},
	{name = "ultimate health potion", chance = 25000, maxCount = 3},
	{name = "scorpion tail", chance = 25000},
	{name = "spellweaver's robe", chance = 2500},
	{name = "emerald bangle", chance = 2500},
	{name = "green gem", chance = 5000},
	{name = "blue gem", chance = 5000},
	{name = "violet gem", chance=4500},
	{name = "blue crystal shard", chance=4000},
	{name = "black pearl", chance=5200},
	{name = "gemmed figurine", chance = 5000},
	{name = "lightning legs", chance=2500},
	{name = "glacier kilt", chance=2300},
	{name = "mercenary sword", chance = 5000},
	{name = "noble axe", chance = 5000},
	{name = "utua's poison", chance = 5000},
	{name = "gold ingot", chance = 5000},
	{name = "gold nugget", chance = 5000},
	{name = "warrior's axe", chance = 1400},
	{name = "ring of green plasma", chance = 1700},
	{name = "red silk flower", chance = 500},
	{name = "skull helmet", chance=760},
	{name = "chaos mace", chance=760},
	{name = "coral brooch", chance=760},
	{name = "crystal mace", chance=760},
	{name = "demon shield", chance=760},
	{name = "fist on a stick", chance=760},
	{name = "guardian axe", chance=760},
	{name = "magic plate armor", chance=760},
	{name = "raw watermelon tourmaline", chance=760},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -50, maxDamage = -180, range = 7, radius = 3, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true},
}

monster.defenses = {
	defense = 40,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
