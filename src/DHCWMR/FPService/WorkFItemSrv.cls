/// 名称: DHCWMR.FPService.WorkFItemSrv
/// 描述: 编目操作项定义服务
/// 编写者：zhufei
/// 编写日期: 2014-09-16
Class DHCWMR.FPService.WorkFItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-09-17
/// Description:  查询系统操作为FP的工作流操作项目，用于下拉列表
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       
/// output:       所有符合要求的操作项目    
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.WorkFItemSrv","QryWItemToCbo",1)
Query QryWItemToCbo(aWorkFlowID As %String) As %Query(ROWSPEC = "WFItemID:%String,WFItemDesc:%String")
{
}

ClassMethod QryWItemToCboExecute(ByRef qHandle As %Binary, aWorkFlowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aWorkFlowID="" $$$OK
 	
 	Set xSubId = ""
 	For {
	 	Set xSubId = $O(^DHCWMR.SS.WorkFlowD(aWorkFlowID,"I",xSubId))
	 	Quit:xSubId=""
	 	
 		Set WFItemID=aWorkFlowID_"||"_xSubId
 		Set objWFItem = ##class(DHCWMR.SS.WorkFItem).GetObjById(WFItemID)
 		Continue:'$IsObject(objWFItem)
		Continue:'$IsObject(objWFItem.WFIItem)
		Continue:objWFItem.WFIIsActive'=1
 		
 		Set WFItemDesc  = objWFItem.WFIItem.WIDesc
 		Set ItemAlias = objWFItem.WFIAlias
 		Set:ItemAlias'="" WFItemDesc=ItemAlias
 		
 		Set Data = $LB(WFItemID,WFItemDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryWItemToCboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWItemToCboExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWItemToCboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWItemToCboExecute ]
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
