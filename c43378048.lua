--混沌幻魔アーミタイル
function c43378048.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,6007213,32491822,69890967,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c43378048.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c43378048.spcon)
	e2:SetOperation(c43378048.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c43378048.atkcon)
	e4:SetValue(10000)
	c:RegisterEffect(e4)
end
function c43378048.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c43378048.cfilter(c)
	return c:IsFaceup() and c:IsFusionCode(6007213,32491822,69890967) and c:IsAbleToRemoveAsCost()
end
function c43378048.fcheck(c,sg,g,code,...)
	if not c:IsFusionCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c43378048.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c43378048.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c43378048.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c43378048.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c43378048.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c43378048.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c43378048.fselect,1,nil,tp,mg,sg,6007213,32491822,69890967)
end
function c43378048.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c43378048.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c43378048.fselect,1,1,sg,tp,mg,sg,6007213,32491822,69890967)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c43378048.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
