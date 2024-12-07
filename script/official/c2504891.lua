--スカルビショップ
--Skull Knight
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableAwakeLimit()
	Fusion.AddProcMix(c,true,true,28725004,42431843)
end
