Guardian={}

FLAG_GUARDIAN_RETURN=2

function Guardian.AddProcedure(c,...)
	--Return in the End Phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1105)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(Guardian.MandatoryReturnCondition)
	e1:SetTarget(Guardian.MandatoryReturnTarget)
	e1:SetOperation(Guardian.ReturnOperation)
	c:RegisterEffect(e1)
	--Optional return in case of "GUARDIAN_MAYNOT_RETURN" effects
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(Guardian.OptionalReturnCondition)
	e2:SetTarget(Guardian.OptionalReturnTarget)
	c:RegisterEffect(e2)
	--Effects that register the flags
	local feffs={}
	for _,event in ipairs{...} do
		local fe1=Effect.CreateEffect(c)
		fe1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		fe1:SetCode(event)
		fe1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		fe1:SetOperation(Guardian.SummmonRegister)
		c:RegisterEffect(fe1)
		table.insert(feffs,fe1)
	end
	return e1,e2,table.unpack(feffs)
end

function Guardian.SummmonRegister(e,tp,eg,ep,ev,re,r,rp)
	local event=e:GetCode()
	local reset=RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END
	if event~=EVENT_FLIP_SUMMON_SUCCESS and event~=EVENT_FLIP then
		reset=reset&~(RESET_TEMP_REMOVE|RESET_LEAVE)
	end
	e:GetHandler():RegisterFlagEffect(FLAG_GUARDIAN_RETURN,reset,0,1)
end

function Guardian.CommonCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(FLAG_GUARDIAN_RETURN)>0 and not c:IsHasEffect(EFFECT_GUARDIAN_DONOT_RETURN)
end

function Guardian.MandatoryReturnCondition(e,tp,eg,ep,ev,re,r,rp)
	return Guardian.CommonCondition(e) and not e:GetHandler():IsHasEffect(EFFECT_GUARDIAN_MAYNOT_RETURN)
end

function Guardian.MandatoryReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function Guardian.OptionalReturnCondition(e,tp,eg,ep,ev,re,r,rp)
	return Guardian.CommonCondition(e) and e:GetHandler():IsHasEffect(EFFECT_GUARDIAN_MAYNOT_RETURN)
end

function Guardian.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function Guardian.ReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
