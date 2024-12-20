--Ectoplasmic Fortification!
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.flipconfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_TOXIC)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp) and Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.atkfilter)
		e1:SetValue(s.atkvalue)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(s.atkfilter)
		e2:SetValue(s.defvalue)
		Duel.RegisterEffect(e2,tp)
		--double damage
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(s.damtg)
		e3:SetValue(aux.ChangeBattleDamage(0,DOUBLE_DAMAGE))
		Duel.RegisterEffect(e3,tp)
	end
	--1 flag = 1 counter
	Duel.RegisterFlagEffect(ep,id,0,0,0)
end
function s.atkfilter(e,c)
	return c:IsRace(RACE_TOXIC)
end
function s.atkvalue(e,c)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)*100
end
function s.defvalue(e,c)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)*-100
end
function s.damtg(e,c)
	return c:IsRace(RACE_TOXIC) and c:GetBattleTarget()~=nil
end
