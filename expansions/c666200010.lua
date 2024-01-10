--Cheat Code Kuraishita
--Scripted by Imp
local s,id=GetID()
function s.initial_effect(c)
    c:SetSPSummonOnce(id)
	--Link Summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_CYBERSE),2,nil,s.lcheck)
	c:EnableReviveLimit()
	--Cyberse monsters become "Cheat Code" monsters
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ADD_SETCODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e0:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE))
	e0:SetValue(0x352)
	c:RegisterEffect(e0)
	--Change Control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
--Link Summon
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x352,lc,sumtype,tp)
end
--Change Control
function s.exmfilter(c)
	return c:GetSequence()>=5
end
function s.ctfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,tp,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetControl(tc,tp) and Duel.IsExistingMatchingCard(s.exmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		    local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_CYBERSE)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_CONTROL)
			tc:RegisterEffect(e2)
	end
end