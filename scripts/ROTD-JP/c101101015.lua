--焰圣骑士-莫吉斯
function c101101015.initial_effect(c)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,101101015)
    e1:SetCost(c101101015.drcost)
    e1:SetTarget(c101101015.drtg)
    e1:SetOperation(c101101015.drop)
    c:RegisterEffect(e1)   
    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,101101115)
    e2:SetTarget(c101101015.eqtg)
    e2:SetOperation(c101101015.eqop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3) 
end
function c101101015.cfilter(c)
    return ((c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)) or c:IsSetCard(0x207a)) and c:IsAbleToDeckAsCost()
end
function c101101015.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c101101015.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c101101015.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
    Duel.SendtoDeck(g,nil,3,REASON_COST)
end
function c101101015.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101101015.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c101101015.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_WARRIOR) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsRace,tp,LOCATION_MZONE,0,1,1,nil,RACE_WARRIOR)
end
function c101101015.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.Equip(tp,c,tc)
        --equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(c101101015.eqlimit)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end
function c101101015.eqlimit(e,c)
    local tp=e:GetHandlerPlayer()
    return c:IsControler(tp)
end