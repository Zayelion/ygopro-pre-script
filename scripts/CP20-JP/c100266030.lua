--Super All-In!
--Scripted by: XGlitchy30
function c100266030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100266030.target)
	e1:SetOperation(c100266030.activate)
	c:RegisterEffect(e1)
	--register GY effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c100266030.regcon)
	e2:SetOperation(c100266030.regop)
	c:RegisterEffect(e2)
end
function c100266030.exfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>=4 or (c:GetSequence()<5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3))
end
function c100266030.spfilter(c,e,tp)
	return c:IsSetCard(0xe6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c100266030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100266030.exfilter,tp,LOCATION_MZONE,0,1,nil,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c100266030.spfilter,tp,LOCATION_GRAVE,0,4,nil,e,tp) and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,LOCATION_GRAVE)
end
function c100266030.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100266030.exfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tg=g:GetFirst()
	if tg and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 and tg:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<4 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100266030.spfilter),tp,LOCATION_GRAVE,0,4,4,nil,e,tp)
		if #sg>0 then 
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
				Duel.BreakEffect()
				local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
				if Duel.Draw(p,d,REASON_EFFECT)~=0 then
					local tc=Duel.GetOperatedGroup():GetFirst()
					Duel.ConfirmCards(1-tp,tc)
					if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xe6) and tc:IsCanBeSpecialSummoned(e,0,tp,true,false)
					and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(100266030,0)) then
						Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
					else
						local rg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
						if #rg>0 and Duel.Destroy(rg,REASON_EFFECT)>0 then
							Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
						end
					end
				end
			end
		end
	end
end
function c100266030.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xe6) and re:GetHandler():IsType(TYPE_MONSTER) and bit.band(r,REASON_EFFECT)>0
end
function c100266030.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100266030,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100266030.thtg)
	e1:SetOperation(c100266030.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c100266030.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100266030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100266030.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100266030.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100266030.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end