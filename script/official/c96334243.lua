--Sea Monster of Theseus
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsType,TYPE_TUNER),2)
end
