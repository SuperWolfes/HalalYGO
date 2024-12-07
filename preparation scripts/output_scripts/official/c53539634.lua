--クリッチー
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableAwakeLimit()
	Fusion.AddProcMix(c,true,true,78010363,26202165)
end
