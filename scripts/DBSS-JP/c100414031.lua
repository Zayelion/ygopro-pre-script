--赤红血染的黄金圣药石
function c100414031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100414031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100414031)
	e1:SetTarget(c100414031.target)
	e1:SetOperation(c100414031.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100414031,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100414031)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100414031.settg)
	e2:SetOperation(c100414031.setop)
	c:RegisterEffect(e2)
end
function c100414031.filter(c)
	return c:IsSetCard(0x24a) and c:IsFaceup()
end
function c100414031.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100414031.spfilter1(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsSetCard(0x24a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100414031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local chk1,chk2=Duel.IsExistingMatchingCard(c100414031.filter,tp,LOCATION_MZONE,0,1,nil),false
		if chk1 then
			chk2=Duel.IsExistingMatchingCard(c100414031.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		else
			chk2=Duel.IsExistingMatchingCard(c100414031.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and chk2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100414031.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local chk1=Duel.IsExistingMatchingCard(c100414031.filter,tp,LOCATION_MZONE,0,1,nil)
	if chk1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100414031.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100414031.spfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	end
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c100414031.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c100414031.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function c100414031.stfilter(c)
	return c:IsSetCard(0x24b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c100414031.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100414031.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c100414031.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100414031.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end