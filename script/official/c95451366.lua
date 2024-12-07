--魔力枯渇
--Exhausting Actional
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.counter_list={COUNTER_ACTIONAL}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,COUNTER_ACTIONAL,1,REASON_EFFECT) end
end
function s.filter(c)
	return c:IsFaceup() and c:GetCounter(COUNTER_ACTIONAL)~=0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do 
		local cc=tc:GetCounter(COUNTER_ACTIONAL)
		tc:RemoveCounter(tp,COUNTER_ACTIONAL,cc,REASON_EFFECT)
	end
end
