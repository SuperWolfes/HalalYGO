--メガリス・ファレグ
--Megalith Phaleg
--Scripted by ahtelel
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local locked_target_params={handler=c,lvtype=RITPROC_GREATER,filter=function(locked_c) return locked_c:IsSetCard(SET_MEGALITH) and locked_c~=c end,fcoreedselection=s.fcoreedselection}
	local locked_operation_params={handler=c,lvtype=RITPROC_GREATER,filter=function(locked_c) return locked_c:IsSetCard(SET_MEGALITH) end}
	--Locked Summon 1 "Megalith" Locked Monster from your hand, by Tributing monsters from your hand or field whose total Levels equal or exceed its Level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.SelfDiscardCost)
	e1:SetTarget(Locked.Target(locked_target_params))
	e1:SetOperation(Locked.Operation(locked_operation_params))
	c:RegisterEffect(e1)
	--Monsters you control gain 300 ATK/DEF for each Locked Monster in your RP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(function(e,c) return 300*Duel.GetMatchingGroupCount(Card.IsLockedMonster,e:GetHandlerPlayer(),LOCATION_REST,0,nil) end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
s.listed_series={SET_MEGALITH}
function s.fcoreedselection(e,tp,g,sc)
	local c=e:GetHandler()
	return not g:IsContains(c),g:IsContains(c)
end