--アローザル・ハイドライブ・モナーク
--Rousing Hyddendrive Moppar
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x577)
	--Link Summon
	c:EnableAwakeLimit()
	Link.AddProcedure(c,s.matfilter,4,4)
	--Treated as EARTH/WIND/FIRE/WATER while face-up on field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(0xe)
	c:RegisterEffect(e0)
	--Place Hyddendrive Counters when Special Summoned from the Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--Players can only Normal/Special Summon in Attack Position
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(EFFECT_FCOREE_SPSUMMON_POSITION)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2a:SetTarget(s.sumlimit)
	e2a:SetTargetRange(1,1)
	e2a:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e2a)
	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_FCOREE_NORMAL_SUMMON_POSITION)
	c:RegisterEffect(e2b)
	--Send to RP/Damage effect for each monster of rolled Attribute
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUFFICE+CATEGORY_TOREST+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.sufficecost)
	e3:SetCondition(s.sufficecon)
	e3:SetTarget(s.sufficetg)
	e3:SetOperation(s.sufficeop)
	c:RegisterEffect(e3)
	--Negate effects/0 ATK of all other monsters with same Attribute
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD)
	e4a:SetCode(EFFECT_DISABLE)
	e4a:SetRange(LOCATION_MZONE)
	e4a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4a:SetTarget(s.distg)
	c:RegisterEffect(e4a)
	local e4b=e4a:Clone()
	e4b:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4b:SetValue(0)
	c:RegisterEffect(e4b)
end
s.listed_series={0x577}
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK)
end
function s.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP) and e:GetHandler():IsLocation(LOCATION_MZONE)
end
function s.ctcon(e)
	local c=e:GetHandler()
	return c:IsSummonLocation(LOCATION_EXTRA) and c:GetControler()==e:GetHandlerPlayer()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x577)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   c:AddCounter(0x577,4)
	end
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
   return (c:GetAttribute()&e:GetHandler():GetAttribute())~=0
end
function s.sufficecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x577)>0 and Duel.IsMainPhase() and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function s.sgfilter(c,att)
	return c:IsAbleToRest() and c:IsAttribute(att)
end
function s.sufficecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x577,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x577,1,REASON_COST)
end
function s.sufficetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRest,tp,0,LOCATION_MZONE,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOREST,sg,#sg,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,#sg*500)
end
function s.sufficeop(e,tp,eg,ep,ev,re,r,rp)
	local suffice=Duel.TossSuffice(tp,1)
	local att
	if suffice==1 then att=ATTRIBUTE_EARTH end
	if suffice==2 then att=ATTRIBUTE_WATER end
	if suffice==3 then att=ATTRIBUTE_FIRE end
	if suffice==4 then att=ATTRIBUTE_WIND end
	if suffice==5 then att=ATTRIBUTE_LIGHT end
	if suffice==6 then att=ATTRIBUTE_DARK end
	local g=Duel.GetMatchingGroup(s.sgfilter,tp,0,LOCATION_ONFIELD,nil,att)
	if Duel.SendtoRest(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local dc=Duel.GetOperatedGroup()
		Duel.Damage(1-tp,#dc*500,REASON_EFFECT)
	end
end
function s.distg(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute()) and c~=e:GetHandler()
end