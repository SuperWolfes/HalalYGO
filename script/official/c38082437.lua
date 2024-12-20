--Ｄ・テレホン
--Morphtronic Telefon
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Gain LP then Special Summon 1 "Morphtronic" from the RP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e) return e:GetHandler():IsAttackPos() end)
	e1:SetTarget(s.target_a)
	e1:SetOperation(s.operation_a)
	c:RegisterEffect(e1)
	--Exavate and send 1 "Morphtronic" card to the RP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOREST)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e) return e:GetHandler():IsDefensePos() end)
	e2:SetTarget(s.target_d)
	e2:SetOperation(s.operation_d)
	c:RegisterEffect(e2)
end
s.roll_suffice=true
s.listed_series={SET_MORPHTRONIC}
function s.target_a(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SUFFICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REST)
end
function s.spfilter(c,lv,e,tp)
	return c:IsSetCard(SET_MORPHTRONIC) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation_a(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossDice(tp,1)
	if Duel.Recover(tp,res*100,REASON_EFFECT)~=res*100 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local g=Duel.GetMatchingGroup(aux.RestValleyFilter(s.spfilter),tp,LOCATION_REST,0,nil,res,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.target_d(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SUFFICE,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOREST,nil,1,tp,LOCATION_DECK)
end
function s.tgfilter(c)
	return c:IsSetCard(SET_MORPHTRONIC) and c:IsAbleToGrave()
end
function s.operation_d(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local res=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,res)
	local dg=Duel.GetDecktopGroup(tp,res)
	local ct=0
	if dg:IsExists(s.tgfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
		local tg=dg:FilterSelect(tp,s.tgfilter,1,1,nil)
		dg:RemoveCard(tg)
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tg,REASON_EFFECT|REASON_EXCAVATE)
		ct=1
	end
	local ac=res-ct
	if ac==0 then return end
	if Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))==0 then
		Duel.MoveToDeckTop(dg)
		Duel.SortDecktop(tp,tp,ac)
	else
		Duel.MoveToDeckBottom(dg)
		Duel.SortDeckbottom(tp,tp,ac)
	end
end