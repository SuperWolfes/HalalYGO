--カウンター・バック
--Counter Back
local s,id=GetID()
function s.initial_effect(c)
	--Destroy 1 actional/trap on the field
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_REST)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return c:IsActionalTrap() and c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousControler(tp)
		and (c:GetReason()&(REASON_EFFECT+REASON_DESTROY))==(REASON_EFFECT+REASON_DESTROY)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(s.filter,1,nil,tp)
end
function s.desfilter(c)
	return c:IsMonster() and c:IsType(TYPE_EFFECT) and c:IsAttackAbove(2300) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler()):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Destroy(tc,REASON_EFFECT)
	end
end