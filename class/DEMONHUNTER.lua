Cure.Class.DEMONHUNTER = {}

local DH = Cure.Class.DEMONHUNTER;



-- 获取玩家当前拥有的灵魂碎片数量
-- @return number 返回玩家身上203981光环的叠加层数，即灵魂碎片的数量，如果没有则返回0
DH.getSoulFragmentsNum = function()
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(203981)
    if aura then
        return aura.applications
    else
        return 0
    end
end
