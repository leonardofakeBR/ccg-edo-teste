--Cheat Code Kuraish
--Scripted by Imp
local s,id=GetID()
function s.initial_effect(c)
    c:SetSPSummonOnce(id)
   	--Link Summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_CYBERSE),2,2,s.lcheck)
	c:EnableReviveLimit()
	--Extra Material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e0:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e0:SetTargetRange(LOCATION_GRAVE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsAbleToRemove))
	e0:SetOperation(Fusion.BanishMaterial)
	e0:SetValue(s.mtval)
	c:RegisterEffect(e0)
	--Search/Send
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--Link Summon
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x352,lc,sumtype,tp)
end
--Extra Material
function s.mtval(e,c)
	if not c then return false end
	return c:IsRace(RACE_CYBERSE) and c:IsControler(e:GetHandlerPlayer())
end
--Send to GY
function s.exmfilter(c)
	return c:GetSequence()>=5
end
function s.cfilter(c)
	return c:IsSetCard(0x352) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.thfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	aux.ToHandOrElse(tc,tp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #g>0 and Duel.IsExistingMatchingCard(s.exmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		end
end