--ブルーグラス・スティーラー
--Bluegrass Stealer
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--ATK increase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MENTAL) and c:CanBeDoubleTribute(FLAG_DOUBLE_TRIB_WIND,FLAG_DOUBLE_TRIB_MENTAL)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:GetFirst()
	if ct then
		--If it was a mental, treat 1 monster as double tribute for a WIND Mental
		local dg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
		if ct:IsRace(RACE_MENTAL) and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local tc=dg:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(tc,true)
			tc:AddDoubleTribute(id,s.otfilter,s.eftg,RESETS_STANDARD_PHASE_END,FLAG_DOUBLE_TRIB_WIND+FLAG_DOUBLE_TRIB_MENTAL)
		end
	end
end
function s.otfilter(c,tp)
	return c:IsDoubleTribute(FLAG_DOUBLE_TRIB_WIND+FLAG_DOUBLE_TRIB_MENTAL) and (c:IsControler(tp) or c:IsFaceup())
end
function s.eftg(e,c)
	return c:IsRace(RACE_MENTAL) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelAbove(7) and c:IsSummonableCard()
end