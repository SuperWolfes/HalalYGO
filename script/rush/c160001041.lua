--ハンマークラッシュ
--Hammer Crush
local s,id=GetID()
function s.initial_effect(c)
	--Destroy 1 Actional/Trap your opponent controls
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
	--Check for card in hand to send to RP
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
	--Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsActionalTrap,tp,0,LOCATION_ONFIELD,e:GetHandler())>0 end
end
	--Send 1 card from hand to RP to destroy 1 actional/trap your opponent controls
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	--Effect
	if Duel.SendtoGrave(g,REASON_COST)>0 then
		local dg=Duel.GetMatchingGroup(Card.IsActionalTrap,tp,0,LOCATION_ONFIELD,nil)
		if #dg>0 then
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg,true)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end