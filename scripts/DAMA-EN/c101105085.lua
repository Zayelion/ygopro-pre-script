--D.D.D. - Different Dimension Derby
--coded by Lyris
function c101105085.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetCondition(function() return Duel.IsExistingMatchingCard(c101105085.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(c101105085.target)
	e1:SetOperation(c101105085.activate)
	c:RegisterEffect(e1)
	if not c101105085.global_check then
		c101105085.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c101105085.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101105085.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then c:RegisterFlagEffect(101105085,RESET_EVENT+0x4fe0000,0,1) end
end
function c101105085.cfilter(c)
	if c:IsFacedown() or c:GetFlagEffect(101105085)==0 then return false end
	for _,st in ipairs{SUMMON_TYPE_RITUAL,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK} do
		if c:IsSummonType(st) then return true end
	end
	return false
end
function c101105085.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c),1,0,0)
end
function c101105085.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
