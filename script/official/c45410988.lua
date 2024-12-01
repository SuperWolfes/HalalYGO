--レッドアイズ・トランスマイグレーション
--Red-Eyes Transmigration
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	Locked.AddProcGreater{handler=c,filter=s.lockedfil,lv=8,extrafil=s.extrafil,extratg=s.extratg}
end
s.listed_series={0x3b}
s.fit_monster={19025379} --should be removed in hardcode overhaul
s.listed_names={19025379}
function s.lockedfil(c)
	return c:IsCode(19025379) and c:IsLockedMonster()
end
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) and c:HasLevel() and c:IsSetCard(0x3b)
		and c:IsMonster() and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_REST,0,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_REST)
end