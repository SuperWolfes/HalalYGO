--D・ビデオン
local s,id=GetID()
function s.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.cona)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--def
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetCondition(s.cond)
	c:RegisterEffect(e2)
end
function s.cona(e)
	return e:GetHandler():IsAttackPos()
end
function s.cond(e)
	return e:GetHandler():IsDefensePos()
end
function s.val(e,c)
	return c:GetEquipCount()*800
end
