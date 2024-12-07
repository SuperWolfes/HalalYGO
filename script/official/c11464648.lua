--刻まれし魔レクストレメンデ
--Taintedsmith's Rex Tremendae
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	--Fusion Materials: 1 "Taintedsmith" Fusion Monster + 1 Fusion or Link Monster
	Fusion.AddProcMix(c,true,true,s.matfilter,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION|TYPE_LINK))
	--Unaffected by card effects, except "Taintedsmith" cards, while equipped with a "Taintedsmith" Equip Actional
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.immcon)
	e1:SetValue(s.immval)
	c:RegisterEffect(e1)
	--Send 1 LIGHT Tainted monster from your Deck or Extra Deck to the RP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOREST)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e2:SetCost(s.tgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	--Add 1 other "Taintedsmith" card in your RP or banishment to your hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_REST)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_TAINTEDSMITH}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(SET_TAINTEDSMITH,fc,sumtype,tp) and c:IsType(TYPE_FUSION,fc,sumtype,tp)
end
function s.equipfilter(c)
	return c:IsSetCard(SET_TAINTEDSMITH) and c:IsEquipActional() and c:IsFaceup()
end
function s.immcon(e)
	local eqpg=e:GetHandler():GetEquipGroup()
	return eqpg and eqpg:IsExists(s.equipfilter,1,nil)
end
function s.immval(e,te)
	local tc=te:GetHandler()
	local trig_loc,trig_setcodes=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SETCODES)
	if not Duel.IsChainSolving() or (tc:IsRelateToEffect(te) and tc:IsFaceup() and tc:IsLocation(trig_loc)) then
		return not tc:IsSetCard(SET_TAINTEDSMITH)
	end
	for _,setcode in ipairs(trig_setcodes) do
		if (SET_TAINTEDSMITH&0xfff)==(setcode&0xfff) and (SET_TAINTEDSMITH&setcode)==SET_TAINTEDSMITH then return false end
	end
	return true
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST|REASON_DISCARD)
end
function s.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_TAINTED) and c:IsAbleToRest()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOREST,nil,1,tp,LOCATION_DECK|LOCATION_EXTRA)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREST)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoRest(g,REASON_EFFECT)
	end
end
function s.thfilter(c)
	return c:IsSetCard(SET_TAINTEDSMITH) and c:IsAbleToHand() and c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REST|LOCATION_REMOVED) and chkc:IsControler(tp) and chkc~=c and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_REST|LOCATION_REMOVED,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_REST|LOCATION_REMOVED,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end