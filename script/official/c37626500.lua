--精霊の祝福
--Rise's Boiling
local s,id=GetID()
function s.initial_effect(c)
	Locked.AddProcEqual(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
end
