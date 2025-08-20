-- 获取游戏客户端设置的法术队列窗口时间
local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"))


-- 获取玩家增益效果(Buff)剩余时间
-- @param spellIdentifier 法术标识符(名称或ID)
-- @return number 增益效果剩余时间(秒)，如果不存在则返回0
Cure.Aura.getPlayerBuffRemaining = function(spellIdentifier)
    local valueType = type(spellIdentifier)
    local aura
    if valueType == "string" then
        aura = C_UnitAuras.GetAuraDataBySpellName("player", spellIdentifier, "HELPFUL")
    else
        aura = C_UnitAuras.GetPlayerAuraBySpellID(spellIdentifier)
    end

    if aura then
        local remaining = aura.expirationTime - GetTime()
        return math.max(remaining, 0)
    end
    return 0
end

-- 获取玩家减益效果(DeBuff)剩余时间
-- @param spellIdentifier 法术标识符(名称或ID)
-- @return number 减益效果剩余时间(秒)，如果不存在则返回0
Cure.Aura.getPlayerDeBuffRemaining = function(spellIdentifier)
    local valueType = type(spellIdentifier)
    local aura
    if valueType == "string" then
        aura = C_UnitAuras.GetAuraDataBySpellName("player", spellIdentifier, "HARMFUL")
    else
        aura = C_UnitAuras.GetPlayerAuraBySpellID(spellIdentifier)
    end

    if aura then
        local remaining = aura.expirationTime - GetTime()
        return math.max(remaining, 0)
    end
    return 0
end

-- 获取玩家增益效果(Buff)层数
-- @param spellIdentifier 法术标识符(名称或ID)
-- @return number 增益效果层数，如果不存在则返回0
Cure.Aura.getPlayerBuffStacks = function(spellIdentifier)
    local valueType = type(spellIdentifier)
    local aura
    if valueType == "string" then
        aura = C_UnitAuras.GetAuraDataBySpellName("player", spellIdentifier, "HELPFUL")
    else
        aura = C_UnitAuras.GetPlayerAuraBySpellID(spellIdentifier)
    end
    if aura then
        return aura.applications
    else
        return 0
    end
end

-- 获取玩家减益效果(DeBuff)层数
-- @param spellIdentifier 法术标识符(名称或ID)
-- @return number 减益效果层数，如果不存在则返回0
Cure.Aura.getPlayerDeBuffStacks = function(spellIdentifier)
    local valueType = type(spellIdentifier)
    local aura
    if valueType == "string" then
        aura = C_UnitAuras.GetAuraDataBySpellName("player", spellIdentifier, "HARMFUL")
    else
        aura = C_UnitAuras.GetPlayerAuraBySpellID(spellIdentifier)
    end
    if aura then
        return aura.applications
    else
        return 0
    end
end

-- 检查玩家是否拥有指定的增益效果(Buff)
-- @param spellIdentifier 法术标识符(名称或ID)
-- @return boolean 如果玩家拥有该增益效果则返回true，否则返回false
Cure.Aura.isPlayerBuffExists = function(spellIdentifier)
    local valueType = type(spellIdentifier)
    local aura
    if valueType == "string" then
        aura = C_UnitAuras.GetAuraDataBySpellName("player", spellIdentifier, "HELPFUL")
    else
        aura = C_UnitAuras.GetPlayerAuraBySpellID(spellIdentifier)
    end
    if aura then
        return true
    end
    return false
end

-- 检查玩家是否拥有指定的减益效果(DeBuff)
-- @param spellIdentifier 法术标识符(名称或ID)
-- @return boolean 如果玩家拥有该减益效果则返回true，否则返回false
Cure.Aura.isPlayerDeBuffExists = function(spellIdentifier)
    local valueType = type(spellIdentifier)
    local aura
    if valueType == "string" then
        aura = C_UnitAuras.GetAuraDataBySpellName("player", spellIdentifier, "HARMFUL")
    else
        aura = C_UnitAuras.GetPlayerAuraBySpellID(spellIdentifier)
    end
    if aura then
        return true
    end
    return false
end



-- 获取指定单位的光环信息
-- @param targetUnit 目标单位
-- @param spellIdentifier 法术标识符(名称或ID)
-- @param filter 光环过滤器
-- @return table 光环信息表，如果未找到则返回nil
local function getAuraInfo(targetUnit, spellIdentifier, filter)
    local i = 1
    while true do
        local auraInfo = C_UnitAuras.GetAuraDataByIndex(targetUnit, i, filter)
        if not auraInfo then
            return nil
        end
        if (auraInfo.spellId == spellIdentifier) or (auraInfo.name == spellIdentifier) then
            return auraInfo
        end
        i = i + 1
    end
end

-- 获取目标减益效果(Debuff)剩余时间
-- @param spellIdentifier 法术标识符(名称或ID)
-- @param targetUnit 目标单位，默认为"target"
-- @param filter 减益效果过滤器，默认为"HARMFUL|PLAYER"
-- @return number 减益效果剩余时间(秒)，如果不存在则返回0
Cure.Aura.getTargetDebuffRemaining = function(spellIdentifier, targetUnit, filter)
    filter = filter or "HARMFUL|PLAYER"
    targetUnit = targetUnit or "target"

    local auraInfo = getAuraInfo(targetUnit, spellIdentifier, filter)
    if auraInfo then
        local remaining = auraInfo.expirationTime - GetTime()
        return math.max(remaining, 0)
    end
    return 0
end

-- 检查目标是否拥有指定的减益效果(Debuff)
-- @param spellIdentifier 法术标识符(名称或ID)
-- @param targetUnit 目标单位，默认为"target"
-- @param filter 减益效果过滤器，默认为"HARMFUL|PLAYER"
-- @return boolean 如果目标拥有该减益效果则返回true，否则返回false
Cure.Aura.isTargetDebuffExists = function(spellIdentifier, targetUnit, filter)
    filter = filter or "HARMFUL|PLAYER"
    targetUnit = targetUnit or "target"
    local auraInfo = getAuraInfo(targetUnit, spellIdentifier, filter)
    if auraInfo then
        return true
    end
    return false
end
