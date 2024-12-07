--黒魔術の秘儀
--Dark Ment Secrets
--Scripted by edo9300
local s,id=GetID()
function s.initial_effect(c)
	--Fusion
	local e1=Fusion.CreateSummonEff({handler=c,desc=aux.Stringid(id,0),extrafil=function()return nil,s.matcheck end})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCost(s.costhint)
	c:RegisterEffect(e1)
	--Locked
	local e2=Locked.CreateProc({handler=c,lvtype=RITPROC_GREATER,desc=aux.Stringid(id,1),fcoreedselection=s.fcoreedselection})
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCost(s.costhint)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_DARK_MENTOR,CARD_DARK_MENTOR_GIRL}
function s.costhint(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.matcheck(tp,sg,fc)
	return sg:IsExists(Card.IsSummonCode,1,nil,fc,SUMMON_TYPE_FUSION,tp,CARD_DARK_MENTOR,CARD_DARK_MENTOR_GIRL)
end
function s.fcoreedselection(e,tp,sg,sc)
	return sg:IsExists(Card.IsCode,1,nil,CARD_DARK_MENTOR,CARD_DARK_MENTOR_GIRL)
end