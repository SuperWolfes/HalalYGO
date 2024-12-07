--霊魂の降神
--Shinobird's Calling
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	Locked.AddProcGreater{handler=c,filter=s.lockedfil,extrafil=s.extrafil,extratg=s.extratg}
end
s.fit_monster={25415052,52900000} --should be removed in hardcode overhaul
s.listed_names={25415052,52900000}
s.listed_card_types={TYPE_GUARDIAN}
function s.lockedfil(c)
	return c:IsCode(25415052,52900000) and c:IsLockedMonster()
end
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),CARD_GUARDIAN_ELIMINATION)
		and c:HasLevel() and c:IsType(TYPE_GUARDIAN) and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_REST,0,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_REST)
end