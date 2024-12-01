--リトマスの死儀式 (VG)
--Litmus Doom Locked (VG)
local s,id=GetID()
function s.initial_effect(c)
	Locked.AddProcGreaterCode(c,8,nil,72566043)
end
s.listed_names={72566043}