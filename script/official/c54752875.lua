--双頭の雷龍
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableAwakeLimit()
	Fusion.AddProcMixN(c,true,true,31786629,2)
end
