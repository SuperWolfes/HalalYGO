--バクハート
--Blasting Bird
local s,id=GetID()
function s.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (not Duel.IsPlayerAffectedByEffect(tp,FLAG_NO_TRIBUTE)) and e:GetHandler():CanBeDoubleTribute(FLAG_DOUBLE_TRIB_WINGEDBEAST)
end
function s.revfilter(c)
	return c:IsActionalTrap() and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_HAND,0,2,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--cost
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	--double tribute
	local c=e:GetHandler()
	c:AddDoubleTribute(id,s.otfilter,s.eftg,RESETS_STANDARD_PHASE_END,FLAG_DOUBLE_TRIB_WINGEDBEAST)
end
function s.otfilter(c,tp)
	return c:IsDoubleTribute(FLAG_DOUBLE_TRIB_WINGEDBEAST) and (c:IsControler(tp) or c:IsFaceup())
end
function s.eftg(e,c)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsLevelAbove(7) and c:IsSummonableCard()
end
