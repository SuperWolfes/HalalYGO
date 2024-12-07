--粛声の竜賢姫サフィラ
--Saffira, the Wise Silenfcoreer Queen
--Ashaki
local s,id=GetID()
function s.initial_effect(c)
	--Send 1 Locked Actional from your Deck to the RP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOREST+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--Locked Summon 1 LIGHT Warrior or Dragon Locked Monster from your hand
	local e2=Locked.CreateProc(c,RITPROC_GREATER,
		function(rit_c) return rit_c:IsAttribute(ATTRIBUTE_LIGHT) and rit_c:IsRace(RACE_WARRIOR|RACE_DRAGON) end,
		nil,aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REST)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(aux.bfgcost)
	c:RegisterEffect(e2)
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoRest(c,REASON_COST|REASON_DISCARD)
end
function s.tgfilter(c)
	return c:IsLockedActional() and c:IsAbleToRest()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOREST,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_REST)
end
function s.thfilter(c)
	return c:IsLockedMonster() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR|RACE_DRAGON) and c:IsAbleToHand()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoRest(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_REST)
		and Duel.IsExistingMatchingCard(aux.RestValleyFilter(s.thfilter),tp,LOCATION_DECK|LOCATION_REST,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,aux.RestValleyFilter(s.thfilter),tp,LOCATION_DECK|LOCATION_REST,0,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end