local craftPotionMount = Action()
 
local craft = {
    level = 0, 
    items = { 
        [1] = {item = 40916, count = 4}, -- fiery horseshoe
    },
    craftedItem = {40999, 1}, -- singeing mount
}
 
function craftPotionMount.onUse(player, item, fromPosition, itemEx, toPosition)
 
    if player:getLevel() < craft.level then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You do not have level 1.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end
 
    for k, v in pairs(craft.items) do
        if player:getItemCount(v.item) < v.count then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "You do not have necessary items, items necessary x4 Fiery Horseshoes, in order to obtain Singeing Steed Mount.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end
    end
 
    for k, v in pairs(craft.items) do
        player:removeItem(v.item, v.count)
    end
 
    player:addItem(craft.craftedItem[1], craft.craftedItem[2])
    player:removeItem(item.itemid, 1)
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "You have Crafted: "..craft.craftedItem[2].."x "..ItemType(craft.craftedItem[1]):getName()..".")
    player:getPosition():sendMagicEffect(50)
 
    return true
end
 
craftPotionMount:id(40916)
craftPotionMount:register()