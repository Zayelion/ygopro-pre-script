--Ghoti Chain
local s,id,o=GetID()
function s.initial_effect(c)
	--Banish 1 face-up Fish monster you control; Special Summon 1 of your "Ghoti" monsters that is banished, or in your hand, Deck, or GY, with a different original name from the monster banished to activate this card, but banish it when it leaves the field. You can only activate 1 "Ghoti Chain" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCost(function() e1:SetLabel(1) return true end)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,0x33,0,1,nil,e,tp,c:GetOriginalCode())
end
function s.filter(c,e,tp,code)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsSetCard(0x28b)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsOriginalCodeRule(code)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local l=e:GetLabel()==1
	if chk==0 then e:SetLabel(0) return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.Remove(tc)
	e:SetLabel(tc:GetOriginalCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x33)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,0x33,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
