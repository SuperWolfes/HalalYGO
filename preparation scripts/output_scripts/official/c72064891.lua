--魔道騎竜カース・オブ・ドラゴン
--Curse of Dragon, the Mentoral Knight Dragon
--Scripted by edo9300
local s,id=GetID()
function s.initial_effect(c)
	c:EnableAwakeLimit()
	--Fusion Material
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_WARRIOR),s.matfilter)
	--Can also banish monsters from your RP as Fusion Material for the Fusion Summon of a Level 7 Dragon Fusion Monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_REST,0)
	e1:SetTarget(function(e,c) return c:IsAbleToRemove() and c:IsMonster() end)
	e1:SetOperation(Fusion.BanishMaterial)
	e1:SetValue(function(e,c) return c and c:IsRace(RACE_DRAGON) and c:IsControler(e:GetHandlerPlayer()) and c:IsLevel(7) end)
	c:RegisterEffect(e1)
	--Add 1 Actional/Trap that mentions "Bia the Dragon Champion" from your RP to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_BIA_CHAMPION}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsLevelAbove(5)
end
function s.thfilter(c)
	return c:ListsCode(CARD_BIA_CHAMPION) and c:IsActionalTrap() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REST) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_REST,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_REST,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end