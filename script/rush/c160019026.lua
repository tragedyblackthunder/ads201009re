--ラヴ・アンジュ
--Love Ange
--Scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--Excavate the top 4 cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN)		
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttack(0) and not c:IsLevel(4) and c:IsAbleToHand()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	Duel.PayLPCost(tp,500)
	--Effect
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.DisableShuffleCheck()
	local tg=nil
	if g:IsExists(s.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tg=g:FilterSelect(tp,s.filter,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
			Duel.ShuffleHand(tp)
			g:RemoveCard(tg)
		end
	end
	local ct=#g
	if ct>0 then
		Duel.MoveToDeckBottom(ct,tp)
		Duel.SortDeckbottom(tp,tp,ct)
	end
	if tg and tg:GetFirst():IsAttribute(ATTRIBUTE_LIGHT) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end