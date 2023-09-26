Class DHCMA.CPW.SDS.QCEntityMatchRuleSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2019-03-07
/// Description:  查询质控病种入组规则
/// Table：       DHCMA.CPW.SD.QCEntityMatchRule      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityMatchRuleSrv","QryEntityMatchRule",1,1)
Query QryEntityMatchRule(aParRef As %String, aRuleType As %String = "") As %Query(ROWSPEC = "RowID:%String,EntityID:%String,RuleType:%String,RuleTypeDesc:%String,RuleDesc:%String,RuleMethodID:%String,RuleMethodDesc:%String,RuleParam:%String,IndNo:%String,IsActive:%String,RuleKey:%String")
{
}

ClassMethod QryEntityMatchRuleExecute(ByRef qHandle As %Binary, aParRef As %String, aRuleType As %String = "") As %Status
{
	s ^tmpzgz119=aParRef
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Set xSubDesc = ""
	Set xSubRowID=""	
 	For
 	{	
 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityMatchRuleI("IndexParref",aParRef,xSubRowID))
 		Quit:xSubRowID=""
 		Set xRowID = aParRef_"||"_xSubRowID
 		Set (RuleType,RuleTypeDesc,RuleDesc,RuleMethod,RuleMethodDesc,RuleParam,IndNo,IsActive)=""
 		Set ObjRule = ##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(xRowID)
 		Continue:'$IsObject(ObjRule)
 		Set RuleType          	= ObjRule.RuleType
 		Continue:(aRuleType'="")&&(aRuleType'=RuleType)
 		Set:RuleType=1 RuleTypeDesc="准入"
 		Set:RuleType=2 RuleTypeDesc="排除"
 		Set RuleDesc         	= ObjRule.RuleDesc
 		Set RuleMethod          = ObjRule.RuleMethod
 		Set RuleParam          	= ObjRule.RuleParam
 		Set IndNo          		= ObjRule.IndNo
 		Set IsActive          	= ObjRule.IsActive
 		if ($IsObject(RuleMethod)) {
	 		Set RuleMethodID        = RuleMethod.%Id()
	 		Set RuleMethodDesc	  = RuleMethod.BTDesc
 		}
		Set RuleKey				= ObjRule.RuleKey
 		Set IsActive=$s(IsActive=1:"是",1:"否")
		Set Data=$lb(xRowID,aParRef,RuleType,RuleTypeDesc,RuleDesc,RuleMethodID,RuleMethodDesc,RuleParam,IndNo,IsActive,RuleKey)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryEntityMatchRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEntityMatchRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEntityMatchRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEntityMatchRuleExecute ]
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

/// w ##class(DHCMA.CPW.SDS.QCEntityMatchRuleSrv).ImportQCRules("HF- 心力衰竭^^准入^1.主要诊断疾病编码（ICD-10）为I50.0、I50.1、I50.9的病例^诊断^^1^1")
ClassMethod ImportQCRules(aInputStr As %String, aSeparete As %String = "^") As %String
{
	Set ^tmpzgz123=aInputStr
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set QCAbbrev		 = $p(aInputStr,aSeparete,1)
	Set ID		 		 = $p(aInputStr,aSeparete,2)
	Set RuleTypeDesc     = $p(aInputStr,aSeparete,3)
	Set RuleDesc         = $p(aInputStr,aSeparete,4)
	Set RuleMethodDesc   = $p(aInputStr,aSeparete,5)	
	Set RuleParam        = $p(aInputStr,aSeparete,6)
	Set IndNo            = $p(aInputStr,aSeparete,7)
	Set IsActive         = $p(aInputStr,aSeparete,8)
	Set:IsActive="" IsActive=1
	Set RuleType=1
	Set:RuleTypeDesc["排除" RuleType=2
	Set RuleMethod=##class(DHCMA.CPW.SDS.QCExpressSrv).GetObjByDesc(RuleMethodDesc,"QCRule")
	Set:$IsObject(RuleMethod) RuleMethod=RuleMethod.%Id()
	
	Set Parref=$o(^DHCMA.CPW.SD.QCEntityI("IdxofAbb",QCAbbrev,0))
	Quit:Parref="" return
	Set inputStr=Parref_"^"_ID_"^"_RuleType_"^"_RuleDesc_"^"_RuleMethod_"^"_RuleParam_"^"_IndNo_"^"_IsActive
	Set return=##class(DHCMA.CPW.SD.QCEntityMatchRule).Update(inputStr)
	Set:+return<1 return=""
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCEntityMatchRuleSrv).GetRulesByParref(17,1)
ClassMethod GetRulesByParref(aParRef As %String, aRuleType As %String = "") As %String
{
	new (aParRef,aRuleType)
	Set xSubRowID="",return=""
 	For
 	{	
 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityMatchRuleI("IndexParref",aParRef,xSubRowID))
 		Quit:xSubRowID=""
 		Set xRowID = aParRef_"||"_xSubRowID
 		Set (RuleType,RuleTypeDesc,RuleDesc,RuleMethod,RuleMethodDesc,RuleParam,IndNo,IsActive)=""
 		Set ObjRule = ##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(xRowID)
 		if (ObjRule) {
	 		Set RuleType          	= ObjRule.RuleType
	 		continue:(aRuleType'="")&&(aRuleType'=RuleType)
	 		Set RuleDesc         	= ObjRule.RuleDesc
	 		Set return=return_xRowID_$c(2)_RuleDesc_$c(1)
 		}
 		If ObjRule'="" Do ObjRule.%Close()
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	Quit return
}

}
