--Jonjor
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	Fusion.AddProcMix(c,true,true,511018031,511018032,511018033)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,aux.TRUE,1)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToRestAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.SendtoRest(g,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end