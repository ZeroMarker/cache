/// 名称: web.DHCCPW.MRC.CheckRule
/// 描述: 临床路径监控规则维护
/// 编写者：wuqk
/// 编写日期: 2010-05-11
Class web.DHCCPW.MRC.CheckRule Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-01-18
/// Description:  根据ID取监控规则对象
/// Table：       User.DHCMRCClinPathWaysRule
/// Input：       ID:    User.DHCMRCClinPathWaysRule.ID
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.CheckRule).GetObjById("1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWaysRule
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysRule).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// {%%PARENT}("RULE")
/// Creator：     wuqk
/// CreatDate：   2010-05-13
/// Description:  保存规则
/// Table：       User.DHCMRCClinPathWaysRule
/// Input：       Str
/// Return：      返回Id
/// Others:       
/// w ##class(web.DHCCPW.MRC.CheckRule).SaveRule()
ClassMethod SaveRule(InStr As %String) As %String
{
	
	new (InStr)
	set sep=$c(2)
	set ID=$p(InStr,sep,1)
	set parentId=+$p(InStr,sep,2)
	if ID="" {
		set obj=##class(User.DHCMRCClinPathWaysRule).%New()
		} 
	else {
		set obj=##class(User.DHCMRCClinPathWaysRule).%OpenId(ID)
		}
	set obj.CPWRParRef=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(parentId)
	set obj.CPWRDesc=$p(InStr,sep,3)
	set obj.CPWRExpression=$p(InStr,sep,4)
	set obj.CPWRActiveFlag=$p(InStr,sep,5)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     wuqk
/// CreatDate：   2010-05-13
/// Description:  获取临床路径项目描述
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       Id
/// Return：      项目描述
/// Others:       
/// w ##class(web.DHCCPW.MRC.CheckRule).GetItemDesc()
ClassMethod GetItemDesc(ItemId As %String) As %String
{
	new (ItemId)
	set ret=""
	set obj=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemId)
	If $IsObject(obj){
		set ret=obj.CPWSIDesc
	}
	quit ret
}

/// Creator：     wuqk
/// CreatDate：   2010-05-13
/// Description:  获取临床路径描述
/// Table：       User.DHCMRCClinPathWays
/// Input：       CPWId
/// Return：      临床路径描述
/// Others:       
/// w ##class(web.DHCCPW.MRC.CheckRule).GetCPWDesc(1)
ClassMethod GetCPWDesc(CPWId As %String) As %String
{
	new (CPWId)
	set ret=""
	set obj=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWId)
	if $IsObject(obj){
		set ret=obj.CPWDesc
	}
	quit ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.CheckRule","QueryRule",10)
Query QueryRule(CPWRowId As %String) As %Query(ROWSPEC = "RuleId:%String,RuleDesc:%String,RuleActive:%String,RuleExpression:%String")
{
}

ClassMethod QueryRuleExecute(ByRef qHandle As %Binary, CPWRowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//{%%PARENT}("RULE")
	set CPWRowId=+CPWRowId
	quit:'$d(^DHCMRC("CPW",CPWRowId,"RULE")) $$$OK
	
	set RuleSub=$o(^DHCMRC("CPW",CPWRowId,"RULE",""))
	while RuleSub'="" {
		set RuleId=CPWRowId_"||"_RuleSub
		set objRule=##class(web.DHCCPW.MRC.CheckRule).GetObjById(RuleId)
		set RuleDesc=objRule.CPWRDesc
		set RuleActive=$s(objRule.CPWRActiveFlag="Y":"Yes",1:"No")
		set RuleExp=objRule.CPWRExpression
		set ^CacheTemp(repid,ind)=$lb(RuleId,RuleDesc,RuleActive,RuleExp)
		set ind=ind+1
		set RuleSub=$o(^DHCMRC("CPW",CPWRowId,"RULE",RuleSub))
	}
	
	Quit $$$OK
}

ClassMethod QueryRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
