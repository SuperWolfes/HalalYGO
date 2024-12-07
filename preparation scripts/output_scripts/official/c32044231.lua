--ＲＵＭ－マジカル・フォース
--Rank-Up-Ment Mentoral Fcoree
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon 1 Rank 5 Mentor Xyz monster from your Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.matspfilter(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MENTOR)
		and c:IsRank(4) and Duel.IsExistingMatchingCard(s.xyzspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,pg)
end
function s.xyzspfilter(c,e,tp,mc,pg)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(5) and c:IsRace(RACE_MENTOR) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c,tp)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REST) and s.matspfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_GUARDIAN)
		and Duel.IsExistingTarget(s.matspfilter,tp,LOCATION_REST,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.matspfilter,tp,LOCATION_REST,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
	if #pg>1 or (#pg==1 and not pg:IsContains(tc))
		or not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then return end
	local c=e:GetHandler()
	tc:NegateEffects(c)
	if tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.xyzspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,pg):GetFirst()
	if not sc then return end
	sc:SetMaterial(tc)
	Duel.Overlay(sc,tc)
	if Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
		sc:CompleteProcedure()
		if Duel.SpecialSummonComplete()==0 or not (c:IsRelateToEffect(e) and c:IsCanBeXyzMaterial(sc,tp,REASON_EFFECT)) then return end
		c:CancelToRest()
		Duel.Overlay(sc,c)
	end
end