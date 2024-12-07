-- 事件です！
-- It's an Accident!
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Burn
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.damcon)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
end
s.listed_names={160007007}
function s.damconfilter(c,tp)
	return c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousRaceOnField()&RACE_MACHINE==RACE_MACHINE
		and (c:IsReason(REASON_EFFECT) or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)))
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.damconfilter,1,nil,tp)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
	Duel.SetChainLimit(function(e)return not e:IsHasType(EFFECT_TYPE_ACTIVATE)end)
end
function s.spfilter(c,e,tp)
	return c:IsCode(160007007) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=300 then return end
	local ft=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_REST,0,nil,e,tp)
	if ft<1 or #g<1 or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	local sg=g:Select(tp,1,ft,nil)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end