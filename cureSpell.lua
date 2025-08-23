-- 获取游戏客户端设置的法术队列窗口时间
local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"))

--- 获取全局冷却时间(GCD)剩余时间
--- @return number GCD剩余时间(秒)，如果不在冷却中则返回0
Cure.Spell.gcdRemaining = function()
    local spellCooldownInfo = C_Spell.GetSpellCooldown(61304)
    if spellCooldownInfo.duration == 0 then
        return 0
    else
        return spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime()
    end
end

--- 获取法术ID
--- @param spellIdentifier string|number 法术标识符(名称或ID)
--- @return number 法术ID，如果法术不存在则返回0
local getSpellId = function(spellIdentifier)
    local spellInfo = C_Spell.GetSpellInfo(spellIdentifier)
    if not spellInfo then
        print("技能: " .. tostring(spellIdentifier) .. "不存在")
        return 0
    end
    return spellInfo.spellID
end

--- 获取玩家拥有的法术ID
--- @param spellIdentifier string|number 法术标识符(名称或ID)
--- @return number 法术ID，如果法术不存在或不是玩家技能则返回0
local getPlayerSpellId = function(spellIdentifier)
    local spellId = getSpellId(spellIdentifier)
    if not C_SpellBook.IsSpellInSpellBook(spellId) then
        print("技能: " .. tostring(spellIdentifier) .. "不是玩家的技能")
        return 0
    end
    return spellId
end

--- 检查法术是否已冷却
--- @param spellIdentifier string|number 法术标识符(名称或ID)
--- @param cooldownLimit number|nil 可选的冷却限制时间(毫秒)，默认使用SpellQueueWindow
--- @return boolean 如果法术已冷却或即将冷却完成则返回true，否则返回false
Cure.Spell.SpellCoolDown = function(spellIdentifier, cooldownLimit)
    local spellId = getPlayerSpellId(spellIdentifier)
    if spellId == 0 then
        return false
    end
    cooldownLimit = cooldownLimit or SpellQueueWindow
    cooldownLimit = cooldownLimit / 1000

    local spellCooldownInfo = C_Spell.GetSpellCooldown(spellId)
    if spellCooldownInfo.duration == 0 then
        return true
    else
        local remaining = spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime()
        return remaining < cooldownLimit
    end
end

--- 检查法术是否已冷却到GCD水平
--- @param spellIdentifier string|number 法术标识符(名称或ID)
--- @return boolean 如果法术冷却时间不超过GCD则返回true，否则返回false
Cure.Spell.SpellCoolDownGCD = function(spellIdentifier)
    local spellId = getPlayerSpellId(spellIdentifier)
    if spellId == 0 then
        return false
    end

    local gcdCooldownInfo = C_Spell.GetSpellCooldown(61304)
    local spellCooldownInfo = C_Spell.GetSpellCooldown(spellId)
    if spellCooldownInfo.duration == 0 then
        return true
    else
        return spellCooldownInfo.startTime + spellCooldownInfo.duration <= gcdCooldownInfo.startTime +
            gcdCooldownInfo.duration
    end
end

--- 检查目标是否正在施法且可以被打断
--- @param target UnitToken 目标单位
--- @return number 0=不可打断, 1=可打断但不在黑名单中, 2=应在打断列表中打断
local function interruptCast(target)
    if not UnitExists(target) then
        return 0
    end
    local name, _, _, _, _, _, _, notIncorruptible, spellId = UnitCastingInfo(target)
    if name == nil then
        return 0
    end
    if notIncorruptible then
        return 0
    end
    if Cure.List.InterruptBlacklist[spellId] then
        return 0
    end
    if Cure.List.InterruptBlacklist[name] then
        print("匹配到技能名称而不是技能id: " .. tostring(spellId) .. "技能名称: " .. name)
        return 0
    end
    if Cure.List.InterruptSpellList[spellId] then
        return 2
    end

    if Cure.List.InterruptSpellList[name] then
        print("匹配到技能名称而不是技能id: " .. tostring(spellId) .. "技能名称: " .. name)
        return 2
    end

    return 1
end

--- 检查目标是否正在引导法术且可以被打断
--- @param target UnitToken 目标单位
--- @return number 0=不可打断, 1=可打断但不在黑名单中, 2=应在打断列表中打断
local function interruptChannel(target)
    if not UnitExists(target) then
        return 0
    end
    local name, _, _, _, _, _, notIncorruptible, spellId, _, _ = UnitChannelInfo(target)
    if name == nil then
        return 0
    end
    if notIncorruptible then
        return 0
    end
    if Cure.List.InterruptBlacklist[spellId] then
        return 0
    end
    if Cure.List.InterruptBlacklist[name] then
        print("匹配到技能名称而不是技能id: " .. tostring(spellId) .. "技能名称: " .. name)
        return 0
    end
    if Cure.List.InterruptSpellList[spellId] then
        return 2
    end

    if Cure.List.InterruptSpellList[name] then
        print("匹配到技能名称而不是技能id: " .. tostring(spellId) .. "技能名称: " .. name)
        return 2
    end
    return 1
end

--- 检查是否可以打断目标的施法/引导
--- @param target UnitToken 目标单位
--- @return boolean 如果可以打断则返回true，否则返回false
Cure.Spell.canInterrupt = function(target)
    return (interruptCast(target) > 0) or (interruptChannel(target) > 0)
end

--- 检查是否应该打断目标的施法/引导(基于打断列表)
--- @param target UnitToken 目标单位
--- @return boolean 如果应该打断则返回true，否则返回false
Cure.Spell.shouldInterrupt = function(target)
    return (interruptCast(target) > 1) or (interruptChannel(target) > 1)
end

--- 获取法术当前可用的充能次数
--- @param spellIdentifier number|string 法术标识符(名称或ID)
--- @param cooldownLimit number 可选的冷却限制时间(毫秒)，默认使用SpellQueueWindow
--- @return number 可用的充能次数
Cure.Spell.SpellCharges = function(spellIdentifier, cooldownLimit)
    local spellId = getPlayerSpellId(spellIdentifier)
    if spellId == 0 then
        return 0
    end
    local chargeInfo = C_Spell.GetSpellCharges(spellId)

    if chargeInfo.currentCharges == chargeInfo.maxCharges then
        return chargeInfo.currentCharges
    else
        cooldownLimit = cooldownLimit or SpellQueueWindow
        cooldownLimit = cooldownLimit / 1000

        local cooldown = chargeInfo.cooldownStartTime + chargeInfo.cooldownDuration - GetTime()
        if (cooldown > cooldownLimit) then
            return chargeInfo.currentCharges
        else
            return chargeInfo.currentCharges + 1
        end
    end
end

-- 检查法术是否在目标范围内
--- @param spellIdentifier  number|string 法术标识符(名称或ID)
--- @param targetUnit UnitToken 目标单位
--- @return boolean 如果法术在范围内则返回true，否则返回false
Cure.Spell.SpellInRange = function(spellIdentifier, targetUnit)
    local spellId = getPlayerSpellId(spellIdentifier)
    if spellId == 0 then
        return false
    end
    if not UnitExists(targetUnit) then
        return false
    end
    return C_Spell.IsSpellInRange(spellId, targetUnit) or false
end

-- 检查法术是否可用（包括是否有足够资源施放）
--- @param spellIdentifier  number|string 法术标识符(名称或ID)
--- @return boolean 如果法术可用或仅因资源不足而不可用则返回true，否则返回false
-- 注意：此函数返回true表示法术本身是可用的，只是可能因为缺乏资源（如法力值）而无法施放
Cure.Spell.SpellUsable = function(spellIdentifier)
    local spellId = getPlayerSpellId(spellIdentifier)
    if spellId == 0 then
        return false
    end
    local isUsable, insufficientPower = C_Spell.IsSpellUsable(spellId)
    return isUsable or insufficientPower
end
