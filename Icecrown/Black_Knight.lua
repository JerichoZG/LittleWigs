﻿----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["The Black Knight"]
local mod = BigWigs:New(boss, tonumber(("$Revision: 550 $"):sub(12, -3)))
if not mod then return end
mod.partycontent = true
mod.otherMenu = "Icecrown"
mod.zonename = BZ["Trial of the Champion"]
mod.enabletrigger = boss
mod.guid = 35451
mod.toggleOptions = {"explode", "explodeBar", "desecration", "bosskill"}

--------------------------------
--       Are you local?       --
--------------------------------

local deaths = 0
local pName = UnitName("player")

--------------------------------
--        Localization        --
--------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

-- Translators: please update the translations on wowace web based
-- translations, these local ones will go away

L:RegisterTranslations("enUS", function() return {
	cmd = "The Black Knight",
	explode = "Ghoul Explode",
	explodeBar = "Ghoul Explode Bar",
	explodeBar_desc = "Display a casting bar for Ghoul Explode.",
	explode_desc = "Warn when The Black Knight is going to shatter his ghouls.",
	explode_message = "Casting Ghoul Explode!",
	death_trigger = "Nein! Ich darf nicht... wieder... versagen...",-- needs the english version 
	desecration = "Desecration",
	desecration_desc = "Warns when you're standing in the desecration",
}
end )

L:RegisterTranslations("deDE", function() return {
	explode = "Ghulexplosion",
	explodeBar = "Ghulexplosion-Anzeige",
	explodeBar_desc = "Eine Zauberleiste für Ghulexplosion anzeigen.",
	explode_desc = "Warnen wenn der Schwarze Ritter seine Ghule zerschmettert.",
	explode_message = "Zaubert Ghoulexplosion!",
	death_trigger = "Nein! Ich darf nicht... wieder... versagen...", -- needs check
	desecration = "Entweihung",
	desecration_desc = "Warnt wenn du auf entweihtem Boden stehst.",
}
end )

L:RegisterTranslations("zhCN", function() return {
	explode = "食尸鬼爆炸",
	explodeBar = "食尸鬼爆炸计时条",
	explodeBar_desc = "当正在施放食尸鬼爆炸时显示计时条。",
	explode_desc = "当黑骑士粉碎他的食尸鬼时发出警报。",
	explode_message = "正在施放 食尸鬼爆炸！",
	death_trigger = "Nein! Ich darf nicht... wieder... versagen...",-- needs the english version 
}
end )

L:RegisterTranslations("zhTW", function() return {
	explode = "食屍鬼爆炸",
	explodeBar = "食屍鬼爆炸計時條",
	explodeBar_desc = "當正在施放食屍鬼爆炸時顯示計時條。",
	explode_desc = "當黑騎士準備粉碎他的食屍鬼時發出警報。",
	explode_message = "正在施放 食屍鬼爆炸！",
	death_trigger = "不!我不能再次…失敗……";
	desecration = "褻瀆",
	desecration_desc = "當你站在褻瀆之地上時發出警報。",
}
end )

L:RegisterTranslations("ruRU", function() return {
	explode = "Взрыв вурдалака",
	explodeBar = "Полоса Взрыва вурдалака",
	explodeBar_desc = "Отображать полосу применения Взрыва вурдалака.",
	explode_desc = "Предупреждать когда Черный рыцарь взрывает приспешника-вурдалака.",
	explode_message = "Применение Взрыва вурдалака!",
	--death_trigger = "Nein! Ich darf nicht... wieder... versagen...",
	desecration = "Осквернение",
	desecration_desc = "Предупреждать когда вы попадаете в Осквернение",
}
end )

L:RegisterTranslations("koKR", function() return {
	explode = "구울 폭발",
	explodeBar = "구울 폭발 바",
	explodeBar_desc = "구울 폭발의 시전 바를 표시합니다.",
	explode_desc = "흑기사의 구울 폭발 사용을 알립니다.",
	explode_message = "구울 폭발 시전!",
	death_trigger = "안 돼! 또 무릎 꿇을 수는... 없는데...",
	desecration = "모독",
	desecration_desc = "모독에 대해 알립니다.",
}
end )

----------------------------------
--        Initialization        --
----------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Explode", 67751)-- other possible ids :  67886, 51874, 47496, 67729,
	self:AddCombatListener("SPELL_AURA_APPLIED", "Desecration", 67781, 67876)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	deaths = 0
end

----------------------------------
--        Event Handlers        --
----------------------------------

function mod:Explode(_, spellId, _, _, spellName)
	if self.db.profile.explode then
		self:IfMessage(L["explode_message"], "Urgent", spellId)
	end
	if self.db.profile.explodeBar then
		self:Bar(spellName, 4, spellId)
	end
end

function mod:Deaths(_, guid)
	if not self.db.profile.bosskill then return end
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid then
		deaths = deaths + 1
	end
	if deaths == 3 then
		self:BossDeath(_, guid)
	end
end

function mod:Desecration(player)
	if player == pName and self.db.profile.desecration then
		self:LocalMessage(L["desecration"], "Personal", 67781, "Alarm")
	end
end	