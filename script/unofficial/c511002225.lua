--爆撃獣ファイヤ・ボンバ (Manga)
--Blazing Bombardment Beast (Manga)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	--Fusion Material
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunctionEx(Card.IsRace,RACE_PYRO))
end
