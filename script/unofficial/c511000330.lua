--Infernal Transaction
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and c:IsAttackAbove(2000)
end
function s.filter2(c)
	return c:IsActional() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REST) and chkc:IsControler(1-tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_REST,1,nil,e,tp) 
	and Duel.IsExistingTarget(s.filter2,tp,LOCATION_REST,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_REST,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP) then
			local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_REST,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end