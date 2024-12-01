--Breath of Acclamation
local s,id=GetID()
function s.initial_effect(c)
	Locked.AddProcEqual(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
end
