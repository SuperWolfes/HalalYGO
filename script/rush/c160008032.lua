--マスター・オブ・セブンスロード
--Master of Sevens Road
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	--Fusion Summon Procedure
	Fusion.AddProcMix(c,true,true,CARD_SEVENS_ROAD_MENTOR,160401001)
	--Gains ATK per each Mentor monster with different name
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Inflict piercing battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetCondition(s.pcon)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_MENTOR)
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_REST,0,nil)
	return g:GetClassCount(Card.GetCode)*300
end
function s.pcon(e)
	return Duel.GetMatchingGroupCount(s.cfilter,e:GetHandler():GetControler(),LOCATION_REST,0,nil)>=7
end