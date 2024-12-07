--究極封印神エクゾディオス (Anime)
--Exdudius the Ultimate Unliked Watcher (Anime)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	--Must be Special Summoned with "Ultimate Locked of the Unliked Watcher"
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--Cannot be destroyed by battle or card effects
	local e2=Effect.CreateEffect(c)
    	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
    	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    	e2:SetRange(LOCATION_MZONE)
    	e2:SetValue(1)
    	c:RegisterEffect(e2)
	--Unaffected by your opponent's card effects
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--Send 1 "Unliked One" monster from your hand or Deck to the RP when this card attacks
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOREST)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
	--Gains 1000 ATK for each "Unliked One" card in your RP
	local e5=e2:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(s.atkval)
	c:RegisterEffect(e5)
	--Win the Duel when there are 5 "Unliked One" cards with different names in your RP
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TO_REST)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(s.winop)
	c:RegisterEffect(e6)
end
s.listed_series={SET_UNLIKED_ONE}
s.listed_names={511000244}
function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(511000244) or Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CODE)==511000244
end
function s.tgfilter(c)
	return c:IsSetCard(SET_UNLIKED_ONE) and c:IsMonster() and c:IsAbleToRest()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOREST,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoRest(g,REASON_EFFECT)
	end
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_REST,0,nil,SET_UNLIKED_ONE)*1000
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.check(g)
	g=g:Filter(Card.IsSetCard,nil,SET_UNLIKED_ONE)
	return g:GetClassCount(Card.GetCode)==5
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_REST,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_REST)
	local wtp=s.check(g1)
	local wntp=s.check(g2)
	if wtp and not wntp then
		Duel.Win(tp,WIN_REASON_EXDUDIUS)
	elseif not wtp and wntp then
		Duel.Win(1-tp,WIN_REASON_EXDUDIUS)
	elseif wtp and wntp then
		Duel.Win(PLAYER_NONE,WIN_REASON_EXDUDIUS)
	end
end
