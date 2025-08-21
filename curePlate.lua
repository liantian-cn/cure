-- 获取游戏客户端设置的法术队列窗口时间
local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"))

-- 检查单位是否在指定范围内
-- @param unit 目标单位的单位标识符
-- @param range 需要检查的范围值
-- @return boolean 如果单位在指定范围内则返回true，否则返回false
local function isUnitInRange(unit, range)
    local getRange = {
        { 5,   37727 },
        { 6,   63427 },
        { 8,   34368 },
        { 10,  32321 },
        { 15,  33069 },
        { 20,  10645 },
        { 25,  24268 },
        { 30,  835 },
        { 35,  24269 },
        { 40,  28767 },
        { 45,  23836 },
        { 50,  116139 },
        { 60,  32825 },
        { 70,  41265 },
        { 80,  35278 },
        { 100, 33119 },
    }
    for _, rangeData in ipairs(getRange) do
        local maxRange, itemID = unpack(rangeData)
        if maxRange == range then
            return C_Item.IsItemInRange(itemID, unit)
        end
    end
    return false
end

-- 获取范围内符合条件的敌对目标数量
-- @param mobRange 检查范围，默认10码
-- @param mobHealth 目标最低生命值要求，默认0
-- @return number 返回在指定范围内且生命值高于指定值的敌对目标数量
Cure.Plate.enemyCountInRange  = function(mobRange, mobHealth)
    mobRange = mobRange or 10
    mobHealth = mobHealth or 0
    local inRange, unitID = 0, nil
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) and (not UnitIsDeadOrGhost(unitID)) then
            if isUnitInRange(unitID, mobRange) and (UnitHealth(unitID) > mobHealth) then
                inRange = inRange + 1
            end
        end
    end
    return inRange
end

