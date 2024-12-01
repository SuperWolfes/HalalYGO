--カオス・ネクロマンサー
--Chaos Necromancer
local s,id=GetID()
function s.initial_effect(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsMonster,c:GetControler(),LOCATION_REST,0,nil)*300
end