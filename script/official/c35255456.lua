--ミラクル・コンタクト
--Pulse Contact
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	c:RegisterEffect(Fusion.CreateSummonEff(c,s.spfilter,Card.IsAbleToDeck,s.fextra,Fusion.ShuffleMaterial,nil,nil,nil,0,nil,FUSPROC_NOTFUSION|FUSPROC_LISTEDMATS))
end
s.listed_series={0x3008}
s.listed_names={CARD_NEOS}
function s.spfilter(c)
	return c:IsSetCard(0x3008) and c:ListsCodeAsMaterial(CARD_NEOS)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(aux.RestValleyFilter(Fusion.IsMonsterFilter(Card.IsAbleToDeck)),tp,LOCATION_REST,0,nil)
end