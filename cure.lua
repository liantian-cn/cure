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
Cure.List.AoeSpellList = {};             --  AoE技能列表

-- Cure.Spell 模块
-- 提供各种与法术和技能相关的功能函数
Cure.Spell = {}

-- Cure.Aura 模块
-- 提供各种与debuff和buff相关的功能函数
Cure.Aura = {}
Cure.Aura.InstantDispelMagicDebuffList = {}; -- 秒驱散的魔法减益列表
Cure.Aura.ManualDispelMagicDebuffList = {};  -- 手动驱散魔法减益列表
Cure.Aura.ExplodeDispelMagicDebuffList = {}; -- 会爆炸的魔法减益列表
Cure.Aura.HighDamageDebuffList = {};         -- 高伤害减益效果列表
Cure.Aura.MidDamageDebuffList = {};          -- 中等伤害减益效果列表

-- Cure.Plate 模块
-- 提供与玩家名板相关的功能函数
Cure.Plate = {}

-- Cure.Status 模块
-- 提供与状态相关的功能函数
Cure.Status = {}

-- Cure.Item 模块
-- 提供与物品相关的功能函数
Cure.Item = {}

-- Cure.Class 模块
-- 提供与职业相关的功能函数
Cure.Class = {}

local interruptList = Cure.List.InterruptSpellList;
local interruptBlacklist = Cure.List.InterruptBlacklist;
local manualDispelMagicDebuffList = Cure.Aura.ManualDispelMagicDebuffList;
local explodeDispelMagicDebuffList = Cure.Aura.ExplodeDispelMagicDebuffList;
local highDamageDebuffList = Cure.Aura.HighDamageDebuffList;
local midDamageDebuffList = Cure.Aura.MidDamageDebuffList;
local aoeSpellList = Cure.List.AoeSpellList;
local enemyInterruptsCastsList = Cure.List.EnemyInterruptsCastsList;

-- [赎罪大厅]

interruptList[325701] = true; -- 赎罪大厅 > 堕落的搜集者 > [生命虹吸]
interruptList["生命虹吸"] = true; -- 赎罪大厅 > 堕落的搜集者
interruptList[326450] = true; -- 赎罪大厅 > 堕落的驯犬者 > [忠心的野兽]
interruptList["忠心的野兽"] = true; -- 赎罪大厅 > 堕落的驯犬者
interruptList[328322] = true; -- 赎罪大厅 > 不死石精 > [罪邪箭]
interruptList["罪邪箭"] = true; -- 赎罪大厅 > 不死石精
interruptList[323538] = true; -- 赎罪大厅 > 高阶裁决官阿丽兹 > [心能箭矢]
interruptList["心能箭矢"] = true; -- 赎罪大厅 > 高阶裁决官阿丽兹
-- interruptList["邪恶箭矢"] = true; -- 赎罪大厅 > 堕落的歼灭者
-- interruptList[338003] = true; -- 赎罪大厅 > 堕落的歼灭者
-- interruptList[326829] = true; -- 赎罪大厅 > 堕落的歼灭者
midDamageDebuffList[323414] = true; -- 赎罪大厅 4号 哀伤仪式
midDamageDebuffList["哀伤仪式"] = true; -- 赎罪大厅 4号 哀伤仪式
highDamageDebuffList[1236514] = true; -- 赎罪大厅 3号 [不稳定的心能]
highDamageDebuffList["不稳定的心能"] = true; -- 赎罪大厅 3号 [不稳定的心能]
aoeSpellList["耀武扬威"] = {
    start = 1.7,
    duration = 15
}; -- 赎罪大厅 中怪 耀武扬威
aoeSpellList[1236614] = {
    start = 1.7,
    duration = 15
}; -- 赎罪大厅 中怪 耀武扬威
enemyInterruptsCastsList["瓦解尖叫"] = true; -- 赎罪大厅 石裔切割者
enemyInterruptsCastsList[1235326] = true; -- 赎罪大厅 石裔切割者

-- [奥尔达尼生态圆顶]

interruptList[1229474] = true; -- 生态圆顶 门口爬爬 [啃噬]
interruptList["啃噬"] = true; -- 生态圆顶 门口爬爬
interruptList[1229510] = true; -- 生态圆顶
interruptList["弧光震击"] = true; -- 生态圆顶
-- interruptList[1222815] = true; -- 生态圆顶 废土遗民祭师
highDamageDebuffList[1226444] = true; -- 生态圆顶 尾王 重伤的命运
highDamageDebuffList["重伤的命运"] = true; -- 生态圆顶 尾王
highDamageDebuffList[1219704] = true; -- 生态圆顶 尾王 束缚的标枪
highDamageDebuffList["束缚的标枪"] = true; -- 生态圆顶 老2

-- [天街]

interruptList[355934] = true; -- 支援警官  [强光屏障]
interruptList["强光屏障"] = true; -- 支援警官
interruptList["上古恐慌"] = true; -- 上古熔火恶犬
interruptList[356407] = true; -- 上古熔火恶犬
interruptList[356537] = true; -- 传送门操控师佐·霍恩
interruptList["强化约束雕文"] = true; -- 传送门操控师佐·霍恩
interruptList[355642] = true; -- 老练的火花法师
interruptList["凌光齐射"] = true; -- 老练的火花法师
interruptList[355642] = true; -- 老练的火花法师
interruptList["凌光齐射"] = true; -- 老练的火花法师
interruptList[357029] = true; -- 财团走私者
interruptList["凌光炸弹"] = true; -- 财团走私者
interruptList[357196] = true; -- 财团智囊
-- interruptList["凌光箭"] = true; -- 财团智囊
interruptList[350922] = true; -- 绿洲保安
interruptList["威吓怒吼"] = true; -- 绿洲保安
interruptList[347775] = true; -- 过载的邮件元素
interruptList["垃圾信息过滤"] = true; -- 过载的邮件元素
interruptList[1245669] = true; -- 索·阿兹密
interruptList["双重秘术"] = true; -- 索·阿兹密
interruptList[350922] = true; -- 佐·格伦
interruptList["威吓怒吼"] = true; -- 佐·格伦
interruptList[1241032] = true; -- 佐·格伦
interruptList["最终警告"] = true; -- 佐·格伦

-- [宏图]

interruptList[355057] = true; -- 浊盐碎壳者
interruptList["鱼人战吼"] = true; -- 浊盐碎壳者
interruptList[356843] = true; -- 时沙号海潮贤者
interruptList["盐渍飞弹"] = true; -- 时沙号海潮贤者
interruptList[357260] = true; -- 专心的祭师
interruptList["不稳定的裂隙"] = true; -- 专心的祭师
interruptList[1241032] = true; -- 佐·格伦
interruptList["最终警告"] = true; -- 佐·格伦

-- 破晨
-- interruptList[431309] = true; -- 破晨号 > 夜幕影法师 > [诱捕暗影]
-- interruptList["诱捕暗影"] = true; -- 破晨号 > 夜幕影法师
interruptList[449734] = true; -- 破晨号 > 拉夏南 > [酸蚀喷发]
interruptList["酸蚀喷发"] = true; -- 破晨号 > 拉夏南
interruptList[432520] = true; -- 破晨号 > 夜幕暗法师 > [暗影屏障]
interruptList["暗影屏障"] = true; -- 破晨号 > 夜幕暗法师
interruptList[451113] = true; -- 破晨号
interruptList[428086] = true; -- 破晨号
interruptList[431333] = true; -- 破晨号
interruptList[431303] = true; -- 破晨号

-- 修道院
interruptList[427356] = true; -- 修道院 > 虔诚的牧师 > [强效治疗术]
interruptList["强效治疗术"] = true; -- 修道院 > 虔诚的牧师
interruptList[424419] = true; -- 修道院 > 戴尔克莱上尉 > [战斗狂啸]
interruptList["战斗狂啸"] = true; -- 修道院 > 戴尔克莱上尉
interruptList[444743] = true; -- 修道院 > 亡灵法师 > [连珠火球]
interruptList["连珠火球"] = true; -- 修道院 > 亡灵法师
interruptList[423051] = true; -- 修道院 > 亡灵法师
highDamageDebuffList[446403] = true; -- 圣焰隐修院，牺牲烈焰
highDamageDebuffList[447270] = true; -- 圣焰隐修院，掷矛
highDamageDebuffList[447272] = true; -- 圣焰隐修院，掷矛
highDamageDebuffList[448787] = true; -- 圣焰隐修院，纯净
aoeSpellList[424431] = {
    start = 2,
    duration = 8
}; -- 圣焰隐修院 圣光烁辉 2秒 施法时间 艾蕾娜·安博兰兹引导圣光之怒，每1秒对所有玩家造成589514点神圣伤害，持续8秒。
aoeSpellList[428169] = {
    start = 4,
    duration = 1
}; -- 圣焰隐修院 盲目之光 4秒 施法时间 穆普雷释放出耀眼的光芒，对所有玩家造成1473786点神圣伤害。面向穆普雷的玩家额外受到147379点神圣伤害，并被盲目之光迷惑，持续4秒。
-- aoeSpellList[446368] = { start = 5, duration = 1 }; -- 圣焰隐修院 献祭葬火 5秒 施法时间 布朗派克摆出一个燃烧的葬火柴堆，具有3层效果并持续30秒。每当玩家接触葬火柴堆，都会消耗一层效果，使玩家受到牺牲烈焰影响，并使葬火堆爆发出神圣能量，对所有玩家造成736893点伤害。
aoeSpellList[448492] = {
    start = 1,
    duration = 3
}; -- 圣焰隐修院 雷霆一击 1秒 施法时间 对50码范围内的敌人造成2063301点自然伤害并使其移动速度降低50%，持续6秒。
aoeSpellList[448791] = {
    start = 2.5,
    duration = 1
}; -- 圣焰隐修院 神圣鸣罪 2.5秒 施法时间	对50码内的所有玩家造成2063301点神圣伤害。

-- 水闸
interruptList[462771] = true; -- 水闸 > 风险投资公司勘探员 > [勘测光束]
interruptList["勘测光束"] = true; -- 水闸 > 风险投资公司勘探员
interruptList[468631] = true; -- 水闸 > 风险管理公司潜水员 > [鱼叉]
interruptList["鱼叉"] = true; -- 水闸 > 风险管理公司潜水员
interruptList[471733] = true; -- 水闸 > 被惊扰的海藻 > [回春水藻]
interruptList["回春水藻"] = true; -- 水闸 > 被惊扰的海藻
interruptList[1214468] = true; -- 水闸 > 无人机狙击手 > [特技射击]
interruptList["特技射击"] = true; -- 水闸 > 无人机狙击手
interruptList[1214780] = true; -- 水闸 > 暗索无人机 > [终极失真]
interruptList["终极失真"] = true; -- 水闸 > 暗索无人机
interruptList[465595] = true; -- 水闸 > 风险投资公司电工 > [闪电箭]
-- interruptList["闪电箭"] = true; -- 水闸 > 风险投资公司电工
manualDispelMagicDebuffList[473690] = true; -- 动能胶质炸药， 水闸行动
manualDispelMagicDebuffList[473713] = true; -- 动能胶质炸药， 水闸行动
manualDispelMagicDebuffList["动能胶质炸药"] = true; -- 动能胶质炸药， 水闸行动
highDamageDebuffList[468631] = true; -- 水闸行动，鱼叉
highDamageDebuffList["鱼叉"] = true; -- 水闸
midDamageDebuffList[473690] = true; -- 动能胶质炸药

-- 回响
interruptList[434793] = true; -- 回响之城 > 颤声侍从 > [共振弹幕]
interruptList["共振弹幕"] = true; -- 回响之城 > 颤声侍从
interruptList[434802] = true; -- 回响之城 > 伊克辛 > [惊惧尖鸣]
interruptList["惊惧尖鸣"] = true; -- 回响之城 > 伊克辛
interruptList[448248] = true; -- 回响之城 > 沾血的网法师 > [恶臭齐射]
interruptList["恶臭齐射"] = true; -- 回响之城 > 沾血的网法师
interruptList[442210] = true; -- 回响之城 > 沾血的网法师 > [流丝束缚]
interruptList["流丝束缚"] = true; -- 回响之城 > 沾血的网法师
interruptList[433841] = true; -- 回响之城 > 鲜血监督者 > [毒液箭雨]
interruptList["毒液箭雨"] = true; -- 回响之城 > 鲜血监督者
interruptBlacklist["抓握之血"] = true; -- 回响之城 > 抓握之血
interruptBlacklist[432031] = true; -- 回响之城

midDamageDebuffList[320069] = true; -- 致死打击，T only
midDamageDebuffList[330532] = true; -- 锯齿箭
midDamageDebuffList[424414] = true; -- 贯穿护甲，T only
midDamageDebuffList[424797] = true; -- 驭雷栖巢，混沌脆弱，受到混沌腐蚀的伤害提高300%，持续10秒。此效果可叠加。
midDamageDebuffList[429493] = true; -- 驭雷栖巢，不稳定的腐蚀
midDamageDebuffList[1217821] = true; -- 麦卡贡，灼热巨颚
midDamageDebuffList[1223803] = true; -- 剧场，黑暗之井
midDamageDebuffList[1223804] = true; -- 剧场，黑暗之井

-- 地下堡
interruptList[434740] = true;  -- [暗影屏障]
interruptList[470592] = true;  -- [暗影屏障]
interruptList[470593] = true;  -- [暗影屏障]
interruptList[1243656] = true; -- [暗影屏障]
interruptList[1236354] = true; -- [暗影屏障]
interruptList[1242469] = true; -- [暗影屏障]
interruptList[448399] = true;  -- [暗影屏障]
