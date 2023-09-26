/// 名称: DHCHAI.IRS.CRuleRBCodeSrv
/// 描述: 影像学-检查项目相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-02
Class DHCHAI.IRS.CRuleRBCodeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  影像学-检查项目列表
/// Table：       DHCHAI.IR.CRuleRBCode
/// Input：       DHCHAI.IR.CRuleRBAb->ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CRuleRBCodeSrv","QryCRuleRBCodeByID","4")
Query QryCRuleRBCodeByID(aRBAbID As %String) As %Query(ROWSPEC = "ID:%String,RBCodeDr:%String,RBCodeDesc:%String,ActDate:%String,ActTime:%String,ActUserDr:%String,ActUserCode:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleRBCodeByIDExecute(ByRef qHandle As %Binary, aRBAbID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRBAbID="" $$$OK
	
	Set xID =""
    For {
		Set xID = $o(^DHCHAI.IR.CRuleRBAbD(aRBAbID,"RBC",xID))
		Quit:xID="" 
		Set ID=aRBAbID_"||"_xID
		Set obj = ##class(DHCHAI.IR.CRuleRBCode).GetObjById(ID)
		Continue:'$Isobject(obj)
		Set BTRBCodeDr   = obj.BTRBCodeDr    	
		Set RBCodeDr="",RBCodeDesc=""
		If $IsObject(obj.BTRBCodeDr) {
			Set RBCodeDr   = obj.BTRBCodeDr.%Id()
			Set RBCodeDesc = obj.BTRBCodeDr.BTMRCHKItem
		}
		Set ActDate		= obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)    	
		Set ActTime		= obj.BTActTime 
		Set:ActTime'="" ActTime=$zt(ActTime,1)  
		If $IsObject(obj.BTActUserDr) {	   
			Set ActUserDr   = obj.BTActUserDr.%Id()
			Set ActUserCode = obj.BTActUserDr.BTCode
			Set ActUser = obj.BTActUserDr.BTDesc
	    } Else {
			Set ActUserDr="", ActUserCode="", ActUser=""  
		}
		
		Set Data = $lb(ID,RBCodeDr,RBCodeDesc,ActDate,ActTime,ActUserDr,ActUserCode,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
	    
	Quit $$$OK
}

ClassMethod QryCRuleRBCodeByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleRBCodeByIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCRuleRBCodeByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleRBCodeByIDExecute ]
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
