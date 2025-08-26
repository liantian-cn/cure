local gcdRemaining = Cure.Spell.gcdRemaining;                           -- 获取全局冷却时间(GCD)剩余时间
local SpellCoolDown = Cure.Spell.SpellCoolDown;                         -- 检查法术是否已冷却
local SpellCoolDownGCD = Cure.Spell.SpellCoolDownGCD;                   -- 检查法术是否已冷却到GCD水平
local canInterrupt = Cure.Spell.canInterrupt;                           -- 检查目标是否可以被打断
local shouldInterrupt = Cure.Spell.shouldInterrupt;                     -- 检查目标是否应该被打断
local SpellCharges = Cure.Spell.SpellCharges;                           -- 获取法术当前可用的充能次数
local SpellInRange = Cure.Spell.SpellInRange;                           -- 检查法术是否在目标范围内
local SpellUsable = Cure.Spell.SpellUsable;                             -- 检查法术是否可用

local playerBuffRemaining = Cure.Aura.playerBuffRemaining;              -- 获取玩家增益效果剩余时间
local playerDeBuffRemaining = Cure.Aura.playerDeBuffRemaining;          -- 获取玩家减益效果剩余时间
local playerBuffStacks = Cure.Aura.playerBuffStacks;                    -- 获取玩家增益效果层数
local playerDeBuffStacks = Cure.Aura.playerDeBuffStacks;                -- 获取玩家减益效果层数
local playerBuffExists = Cure.Aura.playerBuffExists;                    -- 检查玩家是否拥有指定的增益效果
local playerDeBuffExists = Cure.Aura.playerDeBuffExists;                -- 检查玩家是否拥有指定的减益效果
local unitDebuffRemaining = Cure.Aura.unitDebuffRemaining;              -- 获取目标减益效果剩余时间
local unitDebuffExists = Cure.Aura.unitDebuffExists;                    -- 检查目标是否拥有指定的减益效果
local unitBuffRemaining = Cure.Aura.unitBuffRemaining;                  -- 获取目标增益效果剩余时间
local unitBuffExists = Cure.Aura.unitBuffExists;                        -- 检查目标是否拥有指定的增益效果
local countUnitDamageDebuffs = Cure.Aura.countUnitDamageDebuffs;        -- 统计指定单位身上中高伤害减益效果的数量

local playerIsCasting = Cure.Status.playerIsCasting;                    -- 检查玩家是否正在施法
local getCombatTime = Cure.Status.getCombatTime;                        -- 获取战斗持续时间
local inCombatForLessThan = Cure.Status.inCombatForLessThan;            -- 检查战斗持续时间是否少于指定时间
local inCombatForMoreThan = Cure.Status.inCombatForMoreThan;            -- 检查战斗持续时间是否超过指定时间

local enemyCountInRange = Cure.Plate.enemyCountInRange;                 -- 获取范围内符合条件的敌对目标数量
local targetInMelee = Cure.Plate.targetInMelee;                         -- 检查当前目标是否在近战范围内
local anyEnemyInMelee = Cure.Plate.anyEnemyInMelee;                     -- 检查近战范围内是否有任意敌对目标
local anyEnemyIsCasting = Cure.Plate.anyEnemyIsCasting;                 -- 检查是否有敌对目标正在施放指定的法术
local interruptableCountInRange = Cure.Plate.interruptableCountInRange; -- 获取范围内可打断的敌对目标数量

local playerIsCasting = Cure.Status.playerIsCasting;                    -- 检查玩家是否正在施法
local getCombatTime = Cure.Status.getCombatTime;                        -- 获取战斗持续时间
local inCombatForLessThan = Cure.Status.inCombatForLessThan;            -- 检查战斗持续时间是否少于指定时间
local inCombatForMoreThan = Cure.Status.inCombatForMoreThan;            -- 检查战斗持续时间是否超过指定时间

local slotUsable = Cure.Item.slotUsable;                                -- 检查指定装备槽位的物品是否可以使用
