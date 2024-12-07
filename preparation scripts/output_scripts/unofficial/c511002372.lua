--Gilti-Gearfried the Mentoral Steel Knight
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableAwakeLimit()
	Fusion.AddProcMix(c,true,true,423705,51828629)
end
