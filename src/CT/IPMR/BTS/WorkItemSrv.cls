/// 名称: CT.IPMR.BTS.WorkItemSrv
/// 描述: 操作项目相关服务方法
/// 创建者：zhouyang
/// 创建日期: 2019-10-17
Class CT.IPMR.BTS.WorkItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouyang
/// CreatDate：   2019-10-17
/// Description:  查询操作项目
/// Table：       CT.IPMR.BTS.WorkItemSrv
/// Input：       
/// output:       操作项目列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.WorkItemSrv","QueryWorkItem")
Query QueryWorkItem() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QueryWorkItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.BT.WorkItemD(xID))
		Quit:xID=""
		Set objWorkItem = ##class(CT.IPMR.BT.WorkItem).GetObjById(xID)
		Continue:'$IsObject(objWorkItem)
		
		Set Code = objWorkItem.BWCode
		Set Desc = objWorkItem.BWDesc
		Set Resume = objWorkItem.BWResume
		Set Data=$lb(xID,Code,Desc,Resume)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryWorkItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWorkItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryWorkItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWorkItemExecute ]
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
