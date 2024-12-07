--儀式の供物
--Locked Raven
local s,id=GetID()
function s.initial_effect(c)
	--locked level
	Locked.AddWholeLevelTribute(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
end
