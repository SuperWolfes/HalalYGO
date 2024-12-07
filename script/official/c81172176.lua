--デビル・コメディアン
--Tainted Comedian
local s,id=GetID()
function s.initial_effect(c)
	--Toss a coin and banish cards from the opponent's RP or send cards from Deck to the RP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_REMOVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.toss_coin=true
function s.rmfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_MZONE|LOCATION_REST,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=Duel.GetFieldGroupCount(tp,0,LOCATION_REST) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_REST)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CallCoin(tp) then
		Duel.Remove(Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_MZONE|LOCATION_REST,nil),POS_FACEUP,REASON_EFFECT)
	else
		Duel.DiscardDeck(tp,Duel.GetFieldGroupCount(tp,0,LOCATION_REST),REASON_EFFECT)
	end
end