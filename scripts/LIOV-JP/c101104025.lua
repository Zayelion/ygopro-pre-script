--天魔神 シドヘルズ
--Sky Scourge Sidherz
--Scripted by Kohana Sonogami
function c101104025.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--option
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104025,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c101104025.opcon)
	e1:SetTarget(c101104025.optg)
	e1:SetOperation(c101104025.opop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c101104025.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c101104025.opcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:GetMaterialCount()>0
end
function c101104025.valfilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101104025.valfilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c101104025.valcheck(e,c)
	local label=0
	local g=c:GetMaterial()
	if g:IsExists(c101104025.valfilter1,1,nil) then
		label=label+1
	end
	if g:IsExists(c101104025.valfilter2,1,nil) then
		label=label+2
	end
	e:GetLabelObject():SetLabel(label)
end
function c101104025.thfilter(c)
	return (c:IsRace(RACE_FAIRY) or c:IsRace(RACE_FIEND)) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsAbleToHand()
end
function c101104025.tgfilter(c)
	return (c:IsRace(RACE_FIEND) or c:IsRace(RACE_FAIRY)) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsAbleToGrave()
end
function c101104025.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=e:GetLabel()
	if chk==0 then
		if label==1 then
			return Duel.IsExistingMatchingCard(c101104025.thfilter,tp,LOCATION_DECK,0,1,nil)
		elseif label==2 then
			return Duel.IsExistingMatchingCard(c101104025.tgfilter,tp,LOCATION_DECK,0,1,nil)
		else
			return true
		end
	end
	e:SetLabel(label)
	if label==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(101104025,1))
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif label==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(101104025,2))
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c101104025.opop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c101104025.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	elseif label==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101104025.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
