--征服斗魂 龙帝之枪
--这个卡名的卡在1回合只能发动1张。
--①：自己场上有「征服斗魂」怪兽存在，自己场上的卡为对象的怪兽的效果·魔法·陷阱卡由对方发动时才能发动。那个发动无效并破坏。那之后，可以选自己场上1只「征服斗魂」怪兽给与对方那个攻击力数值的伤害。
function c100420027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c100420027.condition)
	e1:SetTarget(c100420027.target)
	e1:SetOperation(c100420027.activate)
	c:RegisterEffect(e1)
end
function c100420027.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x297)
end
function c100420027.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c100420027.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100420027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100420027.dmgfilter(c)
	return c100420027.cfilter(c) and c:GetAttack()>0
end
function c100420027.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
		and Duel.Destroy(eg,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c100420027.dmgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100420027,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c100420027.dmgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			Duel.Damage(1-tp,g:GetFirst():GetAttack(),REASON_EFFECT)
		end
	end
end