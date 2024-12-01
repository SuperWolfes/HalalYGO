--デステニー・デストロイ
local s,id=GetID()
function s.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOREST+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRest,tp,LOCATION_DECK,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOREST,nil,5,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsLocation(LOCATION_REST) and c:IsActional()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRest,tp,LOCATION_DECK,0,nil)
	if #g>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
		local sg=g:Select(tp,5,5,nil)
		Duel.SendtoRest(sg,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local ct=dg:FilterCount(s.filter,nil)
		if ct>0 then
			Duel.Damage(tp,ct*100,REASON_EFFECT)
		end
	end
end