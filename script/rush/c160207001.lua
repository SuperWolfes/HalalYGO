--超魔軌道マグナム・オーバーロード [L]
--Supreme Fullsteam Magnum Overwatcher [L]
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--Shuffle 3 monsters from the RPs to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	c:AddSideMaximumHandler(e1)
end
s.MaximumSide="Left"
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 and Duel.GetFieldGroupCountRush(tp,LOCATION_MZONE,0)==1
end
function s.tdfilter(c)
	return c:IsMonster() and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_REST,LOCATION_REST,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,PLAYER_ALL,LOCATION_REST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg1=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_REST,LOCATION_REST,3,3,nil)
	if #dg1==0 then return end
	Duel.HintSelection(dg1,true)
	local c=e:GetHandler()
	if Duel.SendtoDeck(dg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsMaximumMode() and c:IsAbleToDeck()
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=Group.CreateGroup()
		g:AddCard(c)
		g=g:AddMaximumCheck()
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end