-- 获取游戏客户端设置的法术队列窗口时间
local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"))
local LibRangeCheck = LibStub:GetLibrary("LibRangeCheck-3.0", true)

-- 获取范围内符合条件的敌对目标数量
-- @param mobRange 检查范围，默认10码
-- @param mobHealth 目标最低生命值要求，默认0
-- @return number 返回在指定范围内且生命值高于指定值的敌对目标数量
Cure.Plate.enemyCountInRange = function(mobRange, mobHealth)
    mobRange = mobRange or 10
    mobHealth = mobHealth or 0
    local inRange, unitID = 0, nil
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        local _, maxRange = LibRangeCheck:GetRange(unitID)
        if UnitCanAttack("player", unitID) and (not UnitIsDeadOrGhost(unitID)) then
            if (maxRange <= mobRange) and (UnitHealth(unitID) > mobHealth) then
                inRange = inRange + 1
            end
        end
    end
    return inRange
end
