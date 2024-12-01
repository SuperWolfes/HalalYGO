--氷結界の封魔団
--Actionalbreaker of the Ice Barrier
local s,id=GetID()
function s.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(aux.IceBarrierDiscardCost(s.cfilter,false))
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x2f}
function s.cfilter(c)
	return c:IsSetCard(0x2f) and c:IsMonster() and c:IsAbleToRestAsCost()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.tgval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,3)
	c:RegisterEffect(e1)
end
function s.tgval(e,re,rp)
	return re:IsActiveType(TYPE_ACTIONAL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end