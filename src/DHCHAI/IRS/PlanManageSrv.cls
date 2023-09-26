/// 名称: DHCHAI.IRS.PlanManageSrv
/// 描述: 预案管理相关服务
/// 编写者：zhoubo
/// 编写日期: 2019-04-28
Class DHCHAI.IRS.PlanManageSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-04-28
/// Description:  查询预案管理信息
/// Table：       DHCHAI.IR.PlanManage
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PlanManageSrv","QryPlanManage")
Query QryPlanManage() As %Query(ROWSPEC = "ID:%String,IRPlanName:%String,PlanTypeDr:%String,PlanTypeDesc:%String,IRKeys:%String,IRContent:%String,IRIsActive:%String")
{
}

ClassMethod QryPlanManageExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xTypeDr = ""
	For {
		Set xTypeDr = $o(^DHCHAI.IR.PlanManageI("IndexPlanTypeDr",xTypeDr))
		Quit:xTypeDr=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.IR.PlanManageI("IndexPlanTypeDr",xTypeDr,xID))
			Quit:xID=""
			Set obj = ##class(DHCHAI.IR.PlanManage).GetObjById(xID)
			Continue:'$isobject(obj)
			
			Set IRPlanName = obj.IRPlanName
			Set PlanTypeDr="",PlanTypeDesc=""
			If $IsObject(obj.IRPlanTypeDr) {
				Set PlanTypeDr 	 = obj.IRPlanTypeDr.%Id()
				Set PlanTypeDesc = obj.IRPlanTypeDr.BTDesc	
			}
			Set IRKeys     = obj.IRKeys
			Set IRContent  = obj.IRContent
			Set IRIsActive = obj.IRIsActive
			
			Set Data = $lb(xID,IRPlanName,PlanTypeDr,PlanTypeDesc,IRKeys,IRContent,IRIsActive)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPlanManageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPlanManageExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPlanManageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPlanManageExecute ]
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
