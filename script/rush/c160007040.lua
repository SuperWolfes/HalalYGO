-- ティタンの狩人
-- Hunter of Titans
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 1 Descendant of Titan + 1 Babysitter Goat
	Fusion.AddProcMix(c,true,true,160004012,160201022)
	-- Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.descostfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_TAINTED) and c:IsAbleToDeckOrExtraAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.descostfilter,tp,LOCATION_REST,0,1,nil) end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(Card.IsActionalTrap,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #dg>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	-- Requirement
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.descostfilter,tp,LOCATION_REST,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)>0
		and Duel.IsExistingMatchingCard(Card.IsActionalTrap,tp,0,LOCATION_ONFIELD,1,nil) then
		-- Effect
		local dg=Duel.SelectMatchingCard(tp,Card.IsActionalTrap,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #dg>0 then
			Duel.HintSelection(dg,true)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
