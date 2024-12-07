--Ｓ－Ｆｏｒｃｅ プラ＝ティナ
--S-Fcoree Pla-Tina
--Logical Nonsense
--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 of your banished "S-Fcoree" monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Decrease the ATK of opponent's monster in the same column as your "S-Fcoree" monsters by 600
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.SFcoreeTarget)
	e3:SetValue(-600)
	c:RegisterEffect(e3)
end
--Lists "S-Fcoree" archetype
s.listed_series={SET_S_FCOREE}
--Specifically lists itself
s.listed_names={id}
--Check for a "S-Fcoree" monster, besides "S-Fcoree Pla-Tina"
function s.filter(c,e,tp)
	return c:IsSetCard(SET_S_FCOREE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
--Activation legality
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
end
--Special summon 1 of your banished "S-Fcoree" monsters
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end