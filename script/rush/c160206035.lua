--ローグ・オブ・デーモン－デーモンの使役者
--Rogue of Archtainted
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--Make up to 2 of your Tainted monsters unable to be destroyed by opponent's Trap card effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.costfilter(c,tp)
	return c:IsRace(RACE_TAINTED) and c:IsFaceup() and c:IsAbleToRestAsCost() and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_TAINTED),tp,LOCATION_MZONE,0,1,c)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Requirement
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if Duel.SendtoRest(g,REASON_COST)<1 then return end
	--Effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_APPLYTO)
	local g=Duel.SelectMatchingCard(tp,aux.FaceupFilter(Card.IsRace,RACE_TAINTED),tp,LOCATION_MZONE,0,1,2,nil)
	Duel.HintSelection(g)
	for tc in g:Iter() do
		--Cannot be destroyed by opponent's trap
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3012)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.efilter(e,re,rp)
	return re:IsTrapEffect() and re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
