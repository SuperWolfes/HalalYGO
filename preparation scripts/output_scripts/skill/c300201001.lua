--Power of Dark
--Skill activation
--At the start of the Duel, place this card in your Field Actional Zone and flip it over.
--Effect
--All Tainted and Mentor monsters on the field gain 200 ATK/DEF, also all Wanderer monsters on the field lose 200 ATK/DEF.
local s,id=GetID()
function s.initial_effect(c)
	aux.AddFieldSkillProcedure(c,2,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function s.val(e,c)
	local r=c:GetRace()
	if (r&(RACE_TAINTED|RACE_MENTOR))>0 then
		return 200
	elseif (r&RACE_WANDERER)>0 then
		return -200
	else
		return 0
	end
end