--Ｔｒｉｃｋ ｏｒ Ｔｒｅａｔ！
--Trick or Treat!
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Add 1 "Hallo, the Guardian of Tricks" or "Ween, the Guardian of Treats" from your Deck or RP to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={54611591,81005500} --"Hallo, the Guardian of Tricks", "Ween, the Guardian of Treats"
function s.thfilter(c)
	return c:IsCode(54611591,81005500) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_REST,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_REST)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.RestValleyFilter(s.thfilter),tp,LOCATION_DECK|LOCATION_REST,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end