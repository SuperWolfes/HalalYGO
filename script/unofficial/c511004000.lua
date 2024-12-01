--Destrudic Draw
--Scripted by Edo9300
local s,id=GetID()
if s then
	function s.initial_effect(c)
	end
end
if not id then id=511004000 end
if not DestrudicDraw then
	DestrudicDraw={}
	aux.GlobalCheck(DestrudicDraw,function()
		DestrudicDraw[0]=nil
		DestrudicDraw[1]=nil
	end)
	local function finishsetup()
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetOperation(DestrudicDraw.op)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.GlobalEffect()
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PREDRAW)
		e2:SetCondition(DestrudicDraw.drcon)
		e2:SetOperation(DestrudicDraw.drop)
		Duel.RegisterEffect(e2,0)
		local e3=e2:Clone()
		Duel.RegisterEffect(e3,1)
	end
	function DestrudicDraw.op(e,tp,eg,ep,ev,re,r,rp)
		for p=0,1 do
			local g=Duel.GetFieldGroup(p,LOCATION_DECK+LOCATION_HAND,0)
			if DestrudicDraw[p]==nil and Duel.SelectYesNo(p,aux.Stringid(id,0)) then
				DestrudicDraw[p]=aux.SelectUnselectGroup(g,e,p,1,5,aux.dncheck,1,p)
				DestrudicDraw[p]:KeepAlive()
				Duel.ShuffleDeck(p)
			end
		end
		e:Reset()
	end
	function DestrudicDraw.drcon(e,tp,eg,ep,ev,re,r,rp)
		return DestrudicDraw[tp] and Duel.GetLP(tp)<=Duel.GetLP(1-tp)/2 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
			and	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	end
	function DestrudicDraw.drop(e,tp,eg,ep,ev,re,r,rp)
		local g=DestrudicDraw[tp]:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			DestrudicDraw[tp]:DeleteGroup()
			DestrudicDraw[tp]=nil
			Duel.Hint(HINT_CARD,0,id)
			local tc=g:RandomSelect(tp,1):GetFirst()
			Duel.MoveSequence(tc,0)
		end
	end
	finishsetup()
end
