--ゴーストリック・オア・トリート
--
--Script by Trishula9
function c101107076.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101107076+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c101107076.condition)
	e1:SetTarget(c101107076.target)
	e1:SetOperation(c101107076.operation)
	c:RegisterEffect(e1)
end
function c101107076.confilter(c)
	return c:IsSetCard(0x8d) and c:IsType(TYPE_LINK)
end
function c101107076.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_FZONE,0,1,nil,0x8d)
		or Duel.IsExistingMatchingCard(c101107076.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101107076.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101107076.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		local sel=1
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101107076,0))
		if Duel.CheckLPCost(1-tp,2000) then
			sel=Duel.SelectOption(1-tp,1213,1214)
		end
		if sel==0 then
			Duel.PayLPCost(1-tp,2000)
			if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
				Duel.BreakEffect()
				c:CancelToGrave()
				Duel.ChangePosition(c,POS_FACEDOWN)
				Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			end
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			if not c:IsDisabled() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetValue(RESET_TURN_SET)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(101107076,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_PHASE+PHASE_END)
			e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetCountLimit(1)
			e4:SetLabel(fid)
			e4:SetLabelObject(tc)
			e4:SetCondition(c101107076.flipcon)
			e4:SetOperation(c101107076.flipop)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function c101107076.flipcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(101107076)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c101107076.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetLabelObject(),POS_FACEDOWN_DEFENSE)
end