--儀式魔人デモリッシャー
--Dlilt Demolisher of Lockeds
local s,id=GetID()
function s.initial_effect(c)
	--Can be used for a Locked Summon while it is in the RP
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LOCKED_MATERIAL)
	e1:SetRange(LOCATION_REST)
	e1:SetCondition(s.con)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--A locked monster using this card cannot be targeted by opponent's card effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.con(e)
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),CARD_GUARDIAN_ELIMINATION)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LOCKED
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	for rc in eg:Iter() do
		if rc:GetFlagEffect(id)==0 then
			---Cannot be targeted by opponent's card effects
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3061)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetLabel(ep)
			e1:SetValue(s.tgval)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			rc:RegisterEffect(e1,true)
			rc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1)
		end
	end
end
function s.tgval(e,re,rp)
	return rp==1-e:GetLabel()
end