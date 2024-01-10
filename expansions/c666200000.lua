--Cheat Code Kurai
--Scripted by Imp
local s,id=GetID()
function s.initial_effect(c)
    --Cyberse monsters become "Cheat Code" monsters
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ADD_SETCODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e0:SetTargetRange(LOCATION_EXTRA,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE))
	e0:SetValue(0x352)
	c:RegisterEffect(e0)
	--Copy "Cheat Code" Spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.copcost)
	e1:SetTarget(s.coptg)
	e1:SetOperation(s.copop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
--Copy "Cheat Code" Spell
function s.copfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x352)
		and c:IsSpell() and c:CheckActivateEffect(true,true,false)~=nil
end
function s.copcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.copfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.coptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.copfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.copfilter,tp,LOCATION_DECK,0,1,1,nil)
	if not Duel.SendtoGrave(g,REASON_COST) then return end
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.copop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
end