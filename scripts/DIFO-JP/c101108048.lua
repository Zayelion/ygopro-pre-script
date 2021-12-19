--軌跡の魔術師
--
--Script by Trishula9
function c101108048.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c101108048.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101108048.thcon)
	e1:SetCost(c101108048.thcost)
	e1:SetTarget(c101108048.thtg)
	e1:SetOperation(c101108048.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101108048)
	e2:SetCondition(c101108048.descon)
	e2:SetTarget(c101108048.destg)
	e2:SetOperation(c101108048.desop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101108048,ACTIVITY_SPSUMMON,c101108048.penfilter)
end
function c101108048.penfilter(c)
	return not (c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c101108048.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c101108048.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSequence()>4
end
function c101108048.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c101108048.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101108048.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108048.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101108048.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101108048.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c101108048.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetCondition(c101108048.discon)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c101108048.discon)
	e3:SetOperation(c101108048.disop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c101108048.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.GetCustomActivityCount(101108048,tp,ACTIVITY_SPSUMMON)==0
end
function c101108048.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101108048,tp,ACTIVITY_SPSUMMON)==0
end
function c101108048.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and p==tp and bit.band(loc,LOCATION_PZONE)~=0 then
		Duel.NegateEffect(ev)
	end
end
function c101108048.cfilter1(c,g)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM) and g:IsContains(c) and g:IsExists(c101108048.cfilter2,1,c,c)
end
function c101108048.cfilter2(c,lc)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:GetLevel()~=lc:GetLevel()
end
function c101108048.descon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c101108048.cfilter1,1,nil,lg) and not eg:IsContains(e:GetHandler())
end
function c101108048.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c101108048.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end