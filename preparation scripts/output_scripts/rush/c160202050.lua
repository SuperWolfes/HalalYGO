--天の加護
--Spectrumly Protection

--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Send any number of monsters from hand to RP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOREST+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
	--Check for a monster
function s.tgfilter(c)
	return c:IsMonster() and c:IsAbleToRest()
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOREST,nil,1,tp,LOCATION_HAND)
end
	--Send any number of monsters from hand to RP
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,99,nil)
	if #g>0 then
		Duel.SendtoRest(g,REASON_EFFECT)
		local tg=g:GetSum(Card.GetOriginalLevel)
		if tg>=10 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end