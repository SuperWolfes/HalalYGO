--奈落との契約
local s,id=GetID()
function s.initial_effect(c)
	Locked.AddProcEqual(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
end
