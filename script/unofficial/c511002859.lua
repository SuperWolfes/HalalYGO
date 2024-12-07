--究極竜騎士 (Anime)
--Dragon Master Knight (Anime)
--updated by ClaireStanfield
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableAwakeLimit()
	Fusion.AddProcMix(c,true,true,5405694,23995346)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
end
s.material_setcode={0xdd,0x10cf,0xcf}
s.listed_names={5405694,23995346}
function s.filter(c)
	return (c:IsLocation(LOCATION_REST) or c:IsFaceup()) and c:IsRace(RACE_DRAGON)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_MZONE+LOCATION_REST,LOCATION_MZONE+LOCATION_REST,c)*500
end