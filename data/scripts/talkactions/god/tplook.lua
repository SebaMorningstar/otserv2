local tpLook = TalkAction("/look")

function tpLook(player, destination)
    if player:getAccountType() >= ACCOUNT_TYPE_GOD and player:getStorageValue(storage) == 1 then
        player:teleportTo(destination)
    end
end

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    if player:getStorageValue(storage) < 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Look teleport enabled.")
        player:setStorageValue(storage, 1)
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Look teleport disabled.")
        player:setStorageValue(storage, 0)
    end
    return false
end