-- 检查指定装备槽位的物品是否可以使用
-- @param slot 装备槽位ID
-- @return boolean 如果物品可以使用返回true，否则返回false
Cure.Item.slotUsable = function(slot)
    local itemId = GetInventoryItemID("player", slot)
    local usable, noMana = C_Item.IsUsableItem(itemId)
    if (not usable) or noMana then
        return false
    end
    local _, duration, enable = C_Container.GetItemCooldown(itemId)
    if (enable ~= 1) or (duration ~= 0) then
        return false
    end
    return true
end
