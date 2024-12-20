--死霊の束縛
--Illusion Bind
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.ctfilter(c,race)
	return c:IsMonster() and c:IsRace(race)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return tc and Duel.IsExistingMatchingCard(s.ctfilter,tp,0,LOCATION_REST,1,nil,tc:GetRace()) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not (tc and tc:IsRelateToBattle()) then return end
	local ct=Duel.GetMatchingGroupCount(s.ctfilter,tp,0,LOCATION_REST,nil,tc:GetRace())
	if ct>0 and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		e1:SetValue(-ct*100)
		tc:RegisterEffect(e1)
	end
end