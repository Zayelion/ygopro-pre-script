--暗黒界の魔神王 レイン
--scripted by JoyJ
function c100313001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100313001,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c100313001.spcon)
	e1:SetOperation(c100313001.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100313001,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c100313001.condition)
	e2:SetTarget(c100313001.target)
	e2:SetOperation(c100313001.operation)
	c:RegisterEffect(e2)
end
function c100313001.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6) and c:IsLevelBelow(7) and c:IsAbleToHandAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function c100313001.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c100313001.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c100313001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c100313001.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c100313001.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(c:GetPreviousControler())
	return c:IsPreviousLocation(LOCATION_HAND) and (r&(REASON_EFFECT+REASON_DISCARD))==REASON_EFFECT+REASON_DISCARD
end
function c100313001.filter1(c)
	return c:IsSetCard(0x6) and c:IsAbleToHand() and c:IsLevelAbove(5) and not c:IsCode(100313001)
end
function c100313001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100313001.filter1,tp,LOCATION_DECK,0,1,nil) end
	if rp==1-tp and tp==e:GetLabel() then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100313001.filter2(c,e,tp,ft,ft2)
	return c:IsSetCard(0x6) and c:IsLevelBelow(4)
		and ((ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
			or (ft2>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP)))
end
function c100313001.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	local ft2=Duel.GetMZoneCount(1-tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100313001.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if rp==1-tp and tp==e:GetLabel()
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100313001.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ft,ft2)
			and Duel.SelectYesNo(tp,aux.Stringid(100313001,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100313001.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,ft,ft2)
			Duel.BreakEffect()
			local tc=tg:GetFirst()
			local o1=ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
			local o2=ft2>0 and tc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP)
			local opt=0
			if o1 and o2 then
				opt=Duel.SelectOption(tp,aux.Stringid(100313001,3),aux.Stringid(100313001,4))
			elseif o1 then
				opt=0
			else
				opt=1
			end
			if opt==1 then tp=1-tp end
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
