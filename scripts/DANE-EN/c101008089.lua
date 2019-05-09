--Valkyrie's Embrace
--
--Scripted by 龙骑
function c101008089.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101008089+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101008089.rmcost)
	e1:SetCondition(c101008089.rmcon)
	e1:SetTarget(c101008089.rmtg)
	e1:SetOperation(c101008089.rmop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101008089,ACTIVITY_SPSUMMON,c101008089.counterfilter)
end
function c101008089.counterfilter(c)
	return c:IsSetCard(0x122)
end
function c101008089.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101008089,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c101008089.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101008089.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x122)
end
function c101008089.cfilter(c)
	return c:IsSetCard(0x122)
end
function c101008089.cfilter2(c)
	return c:IsFacedown() or not c:IsSetCard(0x122)
end
function c101008089.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101008089.cfilter,tp,LOCATION_MZONE,0,1,nil) and not  Duel.IsExistingMatchingCard(c101008089.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c101008089.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x122) and c:IsPosition(POS_ATTACK)
end
function c101008089.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101008089.rmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c101008089.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function c101008089.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		Duel.Remove(hc,POS_FACEUP,REASON_EFFECT)
	end
end