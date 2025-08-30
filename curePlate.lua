-- 获取游戏客户端设置的法术队列窗口时间
-- 部分已迁移到 https://github.com/liantian-cn/RotationLib/tree/dev
local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"))
local LibRangeCheck = LibStub:GetLibrary("LibRangeCheck-3.0", true)



-- 检查当前目标是否在近战范围内
--- @return boolean 如果当前目标在近战范围内且可攻击则返回true，否则返回nil
Cure.Plate.targetInMelee = function()
    local _, maxRange = LibRangeCheck:GetRange("target")
    if UnitCanAttack("player", "target") and (maxRange <= 5) and (not UnitIsDeadOrGhost("target")) then
        return true
    end
end



-- 检查是否有敌对目标正在施放指定的法术
--- @param spell_list table 法术列表，可以是法术ID或法术名称作为键的表
--- @return boolean 如果有任何敌对目标正在施放spell_list中的法术则返回true，否则返回false
Cure.Plate.anyEnemyIsCasting = function(spell_list)
    local unitID = nil
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        local name1, _, _, _, _, _, _, _, spellId1 = UnitCastingInfo(unitID)
        local name2, _, _, _, _, _, _, spellId2, _, _ = UnitChannelInfo(unitID)
        if name1 and (spell_list[spellId1] or spell_list[name1]) then
            return true
        end
        if name2 and (spell_list[spellId2] or spell_list[name2]) then
            return true
        end
    end
    return false
end


-- 获取范围内可打断的敌对目标数量
--- @param mobRange number 检查范围，默认10码
--- @return number 返回范围内可打断的敌对目标数量
Cure.Plate.interruptableCountInRange = function(mobRange)
    mobRange = mobRange or 10
    local inRange, unitID = 0, nil
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        local _, maxRange = LibRangeCheck:GetRange(unitID)
        if UnitCanAttack("player", unitID) and (not UnitIsDeadOrGhost(unitID)) and (maxRange <= mobRange) then
            local name1, _, _, _, _, _, _, notIncorruptible1, _ = UnitCastingInfo(unitID)
            local name2, _, _, _, _, _, notIncorruptible2, _, _, _ = UnitChannelInfo(unitID)
            if name1 and (not notIncorruptible1) then
                inRange = inRange + 1
            elseif name2 and (not notIncorruptible2) then
                inRange = inRange + 1
            end
        end
    end
    return inRange
end
