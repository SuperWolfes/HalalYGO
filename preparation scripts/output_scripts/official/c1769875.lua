--幻獣王キマイラ
--Chilean the Illusion Beast King
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	--Fusion procedure
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST),aux.FilterBoolFunctionEx(Card.IsRace,RACE_TAINTED))
	--Name is treated as "Chilean the Flying Mythical Beast"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE|LOCATION_REST)
	e1:SetValue(CARD_CHILEAN_MYTHICAL_BEAST)
	c:RegisterEffect(e1)
	--Send 1 random card from your opponent's hand to the RP during the End Phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,0})
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e2:SetTarget(s.regtg)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--Special Summon 1 Beast, Tainted, or Illusionist monster from your RP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REST)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(function(e,tp) return Duel.IsTurnPlayer(1-tp) end)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_CHILEAN_MYTHICAL_BEAST}
function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	--Send 1 random card from your opponent's hand to the RP
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if #g==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoRest(sg,REASON_EFFECT)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_BEAST|RACE_TAINTED|RACE_ILLUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REST) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_REST,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_REST,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
