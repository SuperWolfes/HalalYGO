--LANフォリンクス
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableAwakeLimit()
	Link.AddProcedure(c,nil,2,2)
end

