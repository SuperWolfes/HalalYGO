--チューンド・マジシャン
--Tuned Mentor
local s,id=GetID()
function s.initial_effect(c)
	Dual.AddProcedure(c)
	--Treated as Tuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Dual.EffectStatusCondition)
	e1:SetValue(TYPE_TUNER)
	c:RegisterEffect(e1)
end