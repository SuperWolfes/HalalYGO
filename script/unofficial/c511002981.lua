--Pendulum Fusion (anime)
--rescripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,nil,aux.FALSE,s.fextra)
	c:RegisterEffect(e1)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsAbleToRest,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
end
