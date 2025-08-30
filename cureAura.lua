
-- 已迁移到 https://github.com/liantian-cn/RotationLib/tree/dev

--- 获取游戏客户端设置的法术队列窗口时间
local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"))


--- 统计指定单位身上中高伤害减益效果的数量
--- @param unitName UnitToken 目标单位名称
--- @return number,number [unitMidDamageDebuffCount 中等伤害减益效果数量  unitHighDamageDebuffCount 高伤害减益效果数量]
--- 该函数会遍历目标身上的所有减益效果，并根据预定义的减益效果列表进行分类统计
--- 如果在列表中通过名称匹配到减益效果，会打印提示信息用于调试
Cure.Aura.countUnitDamageDebuffs = function(unitName)
    local unitMidDamageDebuffCount, unitHighDamageDebuffCount = 0, 0;
    for i = 1, 40 do
        local debuffData = C_UnitAuras.GetAuraDataByIndex(unitName, i, "HARMFUL")
        if not debuffData then
            break
        end
        if Cure.Aura.HighDamageDebuffList[debuffData.spellId] then
            unitHighDamageDebuffCount = unitHighDamageDebuffCount + 1;
        elseif Cure.Aura.MidDamageDebuffList[debuffData.spellId] then
            unitMidDamageDebuffCount = unitMidDamageDebuffCount + 1;
        elseif Cure.Aura.HighDamageDebuffList[debuffData.name] then
            unitHighDamageDebuffCount = unitHighDamageDebuffCount + 1;
            print("根据名称判断的debuff匹配到了[" .. debuffData.name .. "],技能ID是:" ..
                tostring(debuffData.spellId));
        elseif Cure.Aura.MidDamageDebuffList[debuffData.name] then
            unitMidDamageDebuffCount = unitMidDamageDebuffCount + 1;
            print("根据名称判断的debuff匹配到了[" .. debuffData.name .. "],技能ID是:" ..
                tostring(debuffData.spellId));
        end
    end
    return unitMidDamageDebuffCount, unitHighDamageDebuffCount
end
