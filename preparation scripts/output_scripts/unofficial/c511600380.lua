--ミラクル・コンタクト (Anime)
--Pulse Contact (Anime)
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,s.spfilter,Fusion.OnFieldMat(Card.IsAbleToDeck),s.fextra,Fusion.ShuffleMaterial,nil,nil,nil,SUMMON_TYPE_FUSION|MATERIAL_FUSION,nil,FUSPROC_NOTFUSION,nil,nil,nil,s.extratg)
	c:RegisterEffect(e1)
end
s.listed_series={0x3008}
s.listed_names={CARD_NEOS}
function s.spfilter(c)
	return c:IsSetCard(0x3008) and c:ListsCodeAsMaterial(CARD_NEOS)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(aux.RestValleyFilter(Fusion.IsMonsterFilter(Card.IsAbleToDeck)),tp,LOCATION_REST,0,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_REST)
end