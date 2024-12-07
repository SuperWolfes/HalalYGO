--デス・バード
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableAwakeLimit()
	Fusion.AddProcMix(c,true,true,3170832,732302)
end
