--[[
动作条与按键绑定映射关系说明
Action Bar	Action slots	Used for/Edit Mode
1	1-12	Action Bar 1
2	13-24	Action Bar 1 - Page 2   翻页不支持
4	25-36	Action Bar 4
5	37-48	Action Bar 5
3	49-60	Action Bar 3
2	61-72	Action Bar 2
b1	73-84	Bonus Bar 1 (德鲁伊猎豹形态/潜行者潜行状态)
b2	85-96	Bonus Bar 2 (德鲁伊猎豹形态潜行)
b3	97-108	Bonus Bar 3 (德鲁伊熊形态)
b4	109-120	Bonus Bar 4 (德鲁伊枭兽形态)
b5	121-132	Bonus Bar 5 (驭龙术)
b6	133-144	Bonus Bar 6 (未知)
6	145-156	Action Bar 6
7	157-168	Action Bar 7
8	169-180	Action Bar 8
]]

--- 存储动作条格子与按键绑定的映射关系表
local slot2bind = {}

--- 初始化所有动作条按键绑定映射表
--- 遍历所有动作条格子，获取并存储对应的按键绑定信息
local function dump_slot2bind()
    local key1, key2

    -- 初始化主动作条1 (栏位1-12)
    for i = 1, 12 do
        key1, key2 = GetBindingKey("ACTIONBUTTON" .. i)
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化动作条4 (栏位25-36)
    for i = 25, 36 do
        key1, key2 = GetBindingKey("MULTIACTIONBAR3BUTTON" .. (i - 24))
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化动作条5 (栏位37-48)
    for i = 37, 48 do
        key1, key2 = GetBindingKey("MULTIACTIONBAR4BUTTON" .. (i - 36))
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化动作条3 (栏位49-60)
    for i = 49, 60 do
        key1, key2 = GetBindingKey("MULTIACTIONBAR2BUTTON" .. (i - 48))
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化动作条2 (栏位61-72)
    for i = 61, 72 do
        key1, key2 = GetBindingKey("MULTIACTIONBAR1BUTTON" .. (i - 60))
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化奖励动作条1-4 (栏位73-144)
    -- 包括德鲁伊各种形态和潜行者潜行状态等特殊形态的按键绑定
    for i = 73, 144 do
        key1, key2 = GetBindingKey("ACTIONBUTTON" .. ((i - 72) % 12))
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化动作条6 (栏位145-156)
    for i = 145, 156 do
        key1, key2 = GetBindingKey("MULTIACTIONBAR5BUTTON" .. (i - 144))
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化动作条7 (栏位157-168)
    for i = 157, 168 do
        key1, key2 = GetBindingKey("MULTIACTIONBAR6BUTTON" .. (i - 156))
        if key1 then
            slot2bind[i] = key1
        end
    end

    -- 初始化动作条8 (栏位169-180)
    for i = 169, 180 do
        key1, key2 = GetBindingKey("MULTIACTIONBAR7BUTTON" .. (i - 168))
        if key1 then
            slot2bind[i] = key1
        end
    end
end

--- 获取一键辅助功能推荐施放的技能所绑定的按键
--- 该函数通过C_AssistedCombat.GetNextCastSpell获取推荐施放的技能ID
--- 然后查找该技能在动作条中的位置，并返回对应的按键绑定
--- @return string 返回技能绑定的按键名称或提示信息
Cure.AssistedCombat.getAssistedCombatBind = function()
    local spellID = C_AssistedCombat.GetNextCastSpell()
    if not spellID then
        return "一键辅助无反馈"
    end
    local slots = C_ActionBar.FindSpellActionButtons(spellID)
    for _, slot in ipairs(slots) do
        if slot2bind[slot] then
            return slot2bind[slot]
        end
    end
    local spellInfo = C_Spell.GetSpellInfo(spellID)
    return spellInfo.name .. " > 未绑定按键"
end

-- 创建用于显示推荐按键的框架
local info_frame = CreateFrame("Frame", nil, UIParent)
info_frame:SetSize(240, 16)
info_frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 400, 0)
info_frame:EnableMouse(true)
info_frame:SetMovable(true)
info_frame:RegisterForDrag("LeftButton")

-- 为框架添加黑色背景
local tex = info_frame:CreateTexture()
tex:SetAllPoints()
tex:SetColorTexture(0, 0, 0, 1)

-- 创建用于显示文本的字体字符串
local font_string = info_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
font_string:SetSize(320, 12)
font_string:SetPoint("LEFT", info_frame, "LEFT", 0, 0)
font_string:SetFont("Fonts\\ARIALN.TTF", 14, nil)
font_string:SetTextColor(1, 1, 1)
font_string:SetJustifyH("LEFT") -- 左对齐
font_string:SetJustifyV("MIDDLE")
font_string:SetText("一键辅助推荐按键")

-- 处理框架拖动开始事件
info_frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)

-- 处理框架拖动结束事件
info_frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

-- 注册需要监听的游戏事件
info_frame:RegisterEvent("PLAYER_LOGIN")
info_frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")

-- 处理游戏事件的回调函数
info_frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_LOGIN") or (event == "ACTIONBAR_SLOT_CHANGED") then
        -- 玩家登录或动作条槽位改变时重新初始化按键绑定映射表
        dump_slot2bind()
    end
end)

-- 每帧更新显示推荐的按键
info_frame:SetScript("OnUpdate", function(self, event, ...)
    font_string:SetText(Cure.AssistedCombat.getAssistedCombatBind())
end)
