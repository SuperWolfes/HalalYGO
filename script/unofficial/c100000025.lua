--化石融合－フォッシル・フュージョン (VG)
--Fossil Fusion (VG)
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Fusion.CreateSummonEff({handler=c,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x14c),matfilter=aux.FALSE,extrafil=s.fextra,value=0x20,extraop=Fusion.BanishMaterial,extratg=s.extratg})
	c:RegisterEffect(e1)
end
s.listed_series={0x14c}
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_REST,LOCATION_REST,nil)
	else
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_ONFIELD,0,nil)
	end
	return nil
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_REST)
end