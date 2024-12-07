--紅き血染めのエルドリクシル
--Eldlixir of Scarlet Sanguine
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 Toxic monster from your Deck or RP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Set 1 "Golden Land" Actional/Trap from your Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REST)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.SelfBanishCost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.vetop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_ELDHITCH,SET_GOLDEN_LAND}
function s.spfilter(c,e,tp,eldhitch)
	return (eldhitch or c:IsSetCard(SET_ELDHITCH)) and c:IsRace(RACE_TOXIC) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eldhitch=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_ELDHITCH),tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK|LOCATION_REST,0,1,nil,e,tp,eldhitch) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_REST)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		--Cannot Special Summon monsters, except Toxic monsters
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(function(e,c) return not c:IsRace(RACE_TOXIC) end)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local eldhitch=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_ELDHITCH),tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RestValleyFilter(s.spfilter),tp,LOCATION_DECK|LOCATION_REST,0,1,1,nil,e,tp,eldhitch)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.setfilter(c)
	return c:IsSetCard(SET_GOLDEN_LAND) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.vetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end