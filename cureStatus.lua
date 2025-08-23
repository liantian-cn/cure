-- 获取游戏客户端设置的法术队列窗口时间
local SpellQueueWindow = tonumber(GetCVar("SpellQueueWindow"))

-- 检查玩家是否正在施法
-- @return boolean 如果正在施法则返回true，否则返回false。
Cure.Status.playerIsCasting = function()
    local name, _, _, _, endTimeMs, _, _, _, _, _ = UnitChannelInfo("player")
    if name then
        return (GetTime() * 1000 + SpellQueueWindow) < endTimeMs
    end

    name, _, _, _, endTimeMs, _, _, _, _ = UnitCastingInfo("player")
    if name then
        return (GetTime() * 1000 + SpellQueueWindow) < endTimeMs
    end
    return false
end

-- 记录进入战斗的时间点
local entry_combat_time = nil;

-- 记录是否处于战斗状态
local in_combat = false;

-- 获取战斗持续时间
-- @return number 返回当前战斗的持续时间(秒)，如果未在战斗中则返回0
Cure.Status.getCombatTime = function()
    if not UnitAffectingCombat("player") then
        return 0;
    end
    if not entry_combat_time then
        return 0;
    end
    return GetTime() - entry_combat_time;
end

-- 获取战斗时间的本地引用
local getCombatTime = Cure.Status.getCombatTime;

-- 检查战斗持续时间是否少于指定时间
-- @param time 指定的时间(秒)
-- @return boolean 如果在战斗中且战斗时间少于指定时间则返回true，否则返回false
Cure.Status.inCombatForLessThan = function(time)
    if not UnitAffectingCombat("player") then
        return false
    end
    return getCombatTime() < time;
end

-- 检查战斗持续时间是否超过指定时间
-- @param time 指定的时间(秒)
-- @return boolean 如果在战斗中且战斗时间超过指定时间则返回true，否则返回false
Cure.Status.inCombatForMoreThan = function(time)
    if not UnitAffectingCombat("player") then
        return false
    end
    return getCombatTime() > time;
end

-- 创建用于监听战斗状态变化的事件框架
local combatEventFrame = CreateFrame("Frame")

-- 设置框架的更新脚本，用于跟踪战斗状态变化
-- 当玩家进入或离开战斗时更新战斗状态和时间记录
combatEventFrame:SetScript("OnUpdate", function(self, event, ...)
    -- 检查是否从战斗状态转为非战斗状态
    if in_combat and (not UnitAffectingCombat("player")) then
        in_combat = false;
        entry_combat_time = nil;
    end

    -- 检查是否从非战斗状态转为战斗状态
    if (not in_combat) and UnitAffectingCombat("player") then
        in_combat = true;
        entry_combat_time = GetTime();
    end
end)
