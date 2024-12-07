--ささやきの妖精
--Whispering Wanderer

--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Shuffle 2 monsters from opponent's RP to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
	--Check for a monster that can be returned to deck
function s.filter(c)
	return c:IsMonster() and c:IsAbleToDeck()
end
	--Check for card in hand to send to RP
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRestAsCost,tp,LOCATION_HAND,0,1,nil) end
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_REST,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REST)
end
	--Send 1 card from hand to RP to shuffle 2 monsters from opponent's RP to deck
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRestAsCost,tp,LOCATION_HAND,0,1,1,nil)
	--Effect
	Duel.SendtoRest(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.RestValleyFilter(s.filter),tp,0,LOCATION_REST,1,2,nil)
	Duel.HintSelection(g)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end