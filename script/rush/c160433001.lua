--竜騎士ガイア (Rush)
--Bia he Dragon Champion (Rush)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	--fusion material
	Fusion.AddProcMix(c,true,true,6368038,28279543)
end
s.material_setcode=SET_BIA_THE_FIERCE_KNIGHT