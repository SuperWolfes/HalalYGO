--電影の騎士ガイアセイバー
--Biasaber, the Video Knight
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,2)
	c:EnableAwakeLimit()
end
