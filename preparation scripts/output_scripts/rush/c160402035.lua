--ジェスペル・ウィザード
--Jeactional Chemist
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--Shuffle 2 Actionals from your RP to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsActional,tp,LOCATION_REST,0,10,nil)
end
function s.tdfilter(c)
	return c:IsActional() and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_REST,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_REST)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.RestValleyFilter(s.tdfilter),tp,LOCATION_REST,0,2,2,nil)
	Duel.HintSelection(g,true)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_PHASE|PHASE_END,2)
	c:RegisterEffect(e1)
end