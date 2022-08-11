--天御巫の闔
--
--Script by Trishula9
function c100419028.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c100419028.atkcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(c100419028.atklimit)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c100419028.actcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--extra attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(c100419028.excon)
	e5:SetCost(c100419028.excost)
	e5:SetOperation(c100419028.exop)
	c:RegisterEffect(e5)
end
function c100419028.atkfilter(c)
	return c:GetEquipCount()>0
end
function c100419028.atkcon(e)
	return Duel.IsExistingMatchingCard(c100419028.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c100419028.atklimit(e,c)
	return c:GetEquipCount()>0
end
function c100419028.actfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x28d) and c:IsControler(tp)
end
function c100419028.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a,d=Duel.GetBattleMonster()
	return (a and c100419028.actfilter(a,tp)) or (d and c100419028.actfilter(d,tp))
end
function c100419028.excon(e,tp,eg,ep,ev,re,r,rp)
	local ec=Duel.GetAttacker()
	e:SetLabelObject(ec)
	return ec:IsControler(tp) and ec:IsSetCard(0x28d) and ec:IsChainAttackable(0,true)
end
function c100419028.exfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c100419028.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100419028.exfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100419028.exfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100419028.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	if not ec or not ec:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	ec:RegisterEffect(e1)
end