--ゼノ・メテオロス
--Script by 奥克斯
function c100420001.initial_effect(c)
	--special summon of hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100420001)
	e1:SetCondition(c100420001.spcon)
	e1:SetTarget(c100420001.sptg)
	e1:SetOperation(c100420001.spop)
	c:RegisterEffect(e1)
	--destroy and special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100420001+100)
	e2:SetTarget(c100420001.dsptg)
	e2:SetOperation(c100420001.dspop)
	c:RegisterEffect(e2)
end
function c100420001.cfilter(c)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c100420001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100420001.cfilter,1,nil)
end
function c100420001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100420001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420001.desfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsRace(RACE_DINOSAUR) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c100420001.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c100420001.spfilter(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100420001.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100420001.dspop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100420001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(c100420001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c100420001.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg==0 then return end
	Duel.BreakEffect()
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c100420001.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_DRAGON+RACE_DINOSAUR+RACE_SEASERPENT+RACE_WYRM)
end
