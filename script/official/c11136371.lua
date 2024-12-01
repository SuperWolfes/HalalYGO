--カウンター・ジェム
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.plcost)
	e1:SetTarget(s.pltg)
	e1:SetOperation(s.plop)
	c:RegisterEffect(e1)
end
s.listed_series={0x1034}
function s.cfilter(c)
	return c:GetSequence()<5 and c:IsAbleToRestAsCost()
end
function s.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SendtoRest(g,REASON_COST)
end
function s.plfilter(c)
	return c:IsSetCard(0x1034) and not c:IsUnliked()
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_REST,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_REST,nil,1,tp,LOCATION_REST)
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_REST,0,ft,ft,nil)
	if #g>0 then
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_ACTIONAL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		Duel.RaiseEvent(g,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	Duel.RegisterEffect(e1,tp)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x1034),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSetCard,0x1034),tp,LOCATION_ONFIELD,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
