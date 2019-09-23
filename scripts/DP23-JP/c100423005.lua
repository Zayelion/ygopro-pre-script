--マジシャンズ・コンビネーション

--Scripted by mallu11
function c100423005.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100423005.spcost)
	e1:SetTarget(c100423005.target)
	e1:SetOperation(c100423005.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100423005.spcon)
	e2:SetCost(c100423005.spcost)
	e2:SetTarget(c100423005.sptg)
	e2:SetOperation(c100423005.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c100423005.descon)
	e3:SetTarget(c100423005.destg)
	e3:SetOperation(c100423005.desop)
	c:RegisterEffect(e3)
end
function c100423005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	local ct=Duel.GetCurrentChain()
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	if ct~=1 and Duel.IsChainNegatable(ct-1) and Duel.IsExistingMatchingCard(c100423005.cfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(100423005,0)) and c:GetFlagEffect(100423005)==0 then
		c:RegisterFlagEffect(100423005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c100423005.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Release(g,REASON_COST)
			g:KeepAlive()
			e:SetLabelObject(g)
			e:SetLabel(0)
		end
		if (Duel.IsExistingMatchingCard(c100423005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return false end
		local g=Duel.GetMatchingGroup(c100423005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,g:GetFirst():GetCode())
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,tc,1,0,0)
	else
		e:SetOperation(nil)
	end
end
function c100423005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=0 then return end
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	local g=e:GetLabelObject()
	local code=g:GetFirst():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100423005.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		Duel.NegateActivation(ct-1)
	end
end
function c100423005.cfilter(c)
	return (c:IsCode(46986414) or c:IsCode(38033121)) and c:IsReleasable()
end
function c100423005.spfilter(c,e,tp,code)
	return not c:IsCode(code) and (c:IsCode(46986414) or c:IsCode(38033121)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100423005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function c100423005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c100423005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100423005.cfilter,tp,LOCATION_MZONE,0,1,nil) and c:GetFlagEffect(100423005)==0
	end
	c:RegisterFlagEffect(100423005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c100423005.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_COST)
		g:KeepAlive()
		e:SetLabelObject(g)
		e:SetLabel(0)
	end
	if not (Duel.IsExistingMatchingCard(c100423005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return false end
	local g=Duel.GetMatchingGroup(c100423005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100423005.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local code=g:GetFirst():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100423005.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		Duel.NegateActivation(ev)
	end
end
function c100423005.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_SZONE)
end
function c100423005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c100423005.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
