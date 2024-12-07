--デュアル・ランサー
--Dual Lancer
local s,id=GetID()
function s.initial_effect(c)
	Dual.AddProcedure(c)
	--Inflict piercing damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(Dual.EffectStatusCondition)
	c:RegisterEffect(e1)
end
