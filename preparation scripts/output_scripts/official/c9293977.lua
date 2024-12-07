--メタル・ドラゴン
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableAwakeLimit()
	Fusion.AddProcMix(c,true,true,29172562,55444629)
end
