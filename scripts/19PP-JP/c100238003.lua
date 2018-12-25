--决斗龙 决斗连接龙
--scripted by Djeeta
function c100238003.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,4,c100238003.lcheck)
    c:EnableReviveLimit()  
    --duel dragon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100238003,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,100238003)
    e1:SetCondition(c100238003.spcon)
    e1:SetTarget(c100238003.sptg)
    e1:SetOperation(c100238003.spop)
    c:RegisterEffect(e1)  
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c100238003.tgcon)
    e2:SetValue(aux.imval1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
end
function c100238003.lcheck(g,lc)
    return g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function c100238003.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c100238003.costfilter(c)
    return c:IsSetCard(0xc2) or (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and (c:IsLevel(7) or c:IsLevel(8))) and c:IsAbleToRemoveAsCost() 
end
function c100238003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if chk==0 then return Duel.IsExistingMatchingCard(c100238003.costfilter,tp,LOCATION_EXTRA,0,1,nil,g) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and zone~=0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=Duel.SelectMatchingCard(tp,c100238003.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,g)
    Duel.Remove(sg,POS_FACEUP,REASON_COST)
    Duel.SetTargetCard(sg)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c100238003.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=bit.band(c:GetLinkedZone(tp),0x1f)
    local tc=Duel.GetFirstTarget()
    local atk=tc:GetTextAttack()
    local def=tc:GetTextDefense()
    local lv=tc:GetOriginalLevel()
    local race=tc:GetOriginalRace()
    local att=tc:GetOriginalAttribute() 
    if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,100238103,0,0x4011,atk,def,lv,race,att) then return end
    local token=Duel.CreateToken(tp,100238103)
    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
    token:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(def)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
    token:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e3:SetValue(att)
    token:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CHANGE_LEVEL)
    e4:SetValue(lv)
    token:RegisterEffect(e4) 
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CHANGE_RACE)
    e5:SetValue(race)
    token:RegisterEffect(e5)       
    Duel.SpecialSummonComplete()
end
function c100238003.tgfilter(c)
    return c:GetOriginalCode()==100238103
end
function c100238003.tgcon(e)
    return Duel.IsExistingMatchingCard(c100238003.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
