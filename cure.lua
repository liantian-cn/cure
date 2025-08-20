SetCVar("scriptErrors", 1);
SetCVar("doNotFlashLowHealthWarning", 1);
SetCVar("cameraIndirectVisibility", 1);
SetCVar("cameraIndirectOffset", 10);
SetCVar("SpellQueueWindow", 150);
SetCVar("targetNearestDistance", 5)
SetCVar("cameraDistanceMaxZoomFactor", 2.6)
SetCVar("CameraReduceUnexpectedMovement", 1)

Cure = {}

-- Cure.List 模块
-- 保存特定的列表
Cure.List = {}
Cure.List.InterruptSpellList = {};       -- 打断技能清单
Cure.List.InterruptBlacklist = {};       -- 打断技能黑名单
Cure.List.EnemyInterruptsCastsList = {}; -- 怪物打断玩家的技能列表

-- Cure.Spell 模块
-- 提供各种与法术和技能相关的功能函数
Cure.Spell = {}

-- Cure.Aura 模块
-- 提供各种与debuff和buff相关的功能函数
Cure.Aura = {}
