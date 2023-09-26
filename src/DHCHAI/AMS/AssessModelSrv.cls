/// 名称: DHCHAI.AMS.AssessModelSrv
/// 描述: 疑似病例筛查评估模型相关服务
/// 编写者：zhufei
/// 编写日期: 2019-03-13
Class DHCHAI.AMS.AssessModelSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  查询评估模型定义
/// Table：       DHCHAI.AM.AssessModel
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.AMS.AssessModelSrv","QryAssessModel")
Query QryAssessModel(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,AMCode:%String,AMDesc:%String,IsActive:%String,IsActDesc:%String,AdmStatus:%String,AdmStatusDesc:%String,SttDate:%String,EndDate:%String,ClassName:%String,Note:%String,SuRuleIDs:%String,SuRules:%String") [ SqlProc ]
{
}

ClassMethod QryAssessModelExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.AM.AssessModelD(xID))
		Quit:xID=""
		
		Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(xID)
		Continue:'$Isobject(objModel)
		
		Set AMCode    = objModel.AMCode        
		Set AMDesc    = objModel.AMDesc      
		Set IsActive  = objModel.AMIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc = $s(IsActive=1:"是",1:"否")  
		Set AdmStatus = objModel.AMAdmStatus 
		Set AdmStatusDesc = $s(AdmStatus="A":"在院",AdmStatus="D":"出院",AdmStatus="I":"感染",1:"")  
		Set SttDate   = objModel.AMSttDate
		Set:SttDate'="" SttDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
		Set EndDate   = objModel.AMEndDate 
		Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
		Set ClassName = objModel.AMClassName  
		Set Note      = objModel.AMNote  
		Set SuRuleIDs = objModel.AMSuRule
		Set SuRules=""
		For indR=1:1:$l(SuRuleIDs,",") {
			Set SuRuleID=$p(SuRuleIDs,",",indR)
			Continue:SuRuleID=""
			Set SuRuleData = $g(^DHCHAI.IR.CRuleInfSuRuleD(SuRuleID))
			Set SuRule=$lg(SuRuleData,6)
			Set SuRules=SuRules_","_SuRule
		}
		Set:SuRules'="" SuRules=$e(SuRules,2,$l(SuRules))
		Set Type= objModel.AMType
		Continue:(Type'="")&&(Type'=1)
		
		Set Data = $lb(xID,AMCode,AMDesc,IsActive,IsActDesc,AdmStatus,AdmStatusDesc,SttDate,EndDate,ClassName,Note,SuRuleIDs,SuRules)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAssessModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAssessModelExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAssessModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssessModelExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
