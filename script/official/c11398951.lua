--機械天使の絶対儀式
--Machine Angel Absolute Locked
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	Locked.AddProcEqual{handler=c,filter=s.lockedfil,extrafil=s.extrafil,extraop=s.extraop,extratg=s.extratg}
end
s.listed_series={0x2093}
function s.lockedfil(c)
	return c:IsSetCard(0x2093) and c:IsLockedMonster()
end
function s.mfilter(c)
	return c:HasLevel() and c:IsRace(RACE_WARRIOR+RACE_WANDERER) and c:IsAbleToDeck()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_REST,0,nil)
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_REST):Filter(Card.IsRace,nil,RACE_WARRIOR+RACE_WANDERER)
	mg:Sub(mat2)
	Duel.ReleaseLockedMaterial(mg)
	Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_LOCKED)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REST)
end