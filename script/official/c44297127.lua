--奇跡の穿孔
--Pulse Rupture
--Scripted by Hel
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOREST+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_FOSSIL_FUSION}
function s.tgfilter(c)
	return c:IsMonster() and c:IsRace(RACE_ROCK) and c:IsLevelBelow(4) and c:IsAbleToRest()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and (not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REST,0,1,nil,CARD_FOSSIL_FUSION) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0) end
	Duel.SetOperationInfo(0,CATEGORY_TOREST,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoRest(g,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_REST) and Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REST,0,1,nil,CARD_FOSSIL_FUSION) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end