--Cheat Code Talker
--Scripted by Imp
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Summon
	Fusion.AddProcMix(c,true,true,s.matfilter,s.matfilter2)
	c:EnableReviveLimit()
    --Extra Link Material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EFFECT_EXTRA_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetOperation(s.extracon)
	e0:SetValue(s.extraval)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_EXTRA,0)
	e1:SetTarget(s.eftg)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--Link Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	aux.GlobalCheck(s,function()
		s.flagmap={}
	end)
end
--Fusion Summon
function s.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x352,fc,sumtype,tp) and c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end
function s.matfilter2(c,fc,sumtype,tp)
	return c:IsRace(RACE_CYBERSE,fc,sumtype,tp) and c:IsLink(2)
end
 --Extra Link Material
function s.eftg(e,c)
	return c:IsRace(RACE_CYBERSE) and c:IsLinkMonster() and c:IsLinkBelow(3) and c:IsCanBeLinkMaterial()
end
function s.extrafilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.extracon(c,e,tp,sg,mg,lc,og,chk)
	local ct=sg:FilterCount(Card.HasFlagEffect,nil,id)
	return ct==0 or ((sg+mg):Filter(s.extrafilter,nil,e:GetHandlerPlayer()):IsExists(Card.IsCode,1,og,id) and ct<2)
end
function s.extraval(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not (sc:IsSetCard(0x352) and sc:IsLinkMonster() and sc:IsLinkAbove(4)) or Duel.GetFlagEffect(tp,id)>0 then
			return Group.CreateGroup()
		else
			s.flagmap[c]=c:RegisterFlagEffect(id,0,0,1)
			return Group.FromCards(c)
		end
	elseif chk==1 then
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK and #sg>0 and Duel.GetFlagEffect(tp,id)==0 then
			Duel.Hint(HINT_CARD,tp,id)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
		end
	elseif chk==2 then
		if s.flagmap[c] then
			s.flagmap[c]:Reset()
			s.flagmap[c]=nil
		end
	end
end
--Link Summon
function s.lkfilter(c)
	return c:IsSetCard(0x352) and c:IsLinkSummonable()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsMainPhase()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local g=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),c)
	end
end