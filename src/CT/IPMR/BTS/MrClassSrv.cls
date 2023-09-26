/// 名称: CT.IPMR.BTS.MrClassSrv
/// 描述: 病案分类相关服务方法
/// 创建者：zhouyang
/// 创建日期: 2019-10-18
Class CT.IPMR.BTS.MrClassSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouyang
/// CreatDate：   2019-10-18
/// Description:  查询病案类型
/// Table：       
/// Input：       
/// output:       病案类型列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.MrClassSrv","QueryMrClass")
Query QueryMrClass() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QueryMrClassExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.BT.MrClassD(xID))
		Quit:xID=""
		Set objMrClass = ##class(CT.IPMR.BT.MrClass).GetObjById(xID)
		Continue:'$IsObject(objMrClass)
		
		Set Code = objMrClass.BMCode
		Set Desc = objMrClass.BMDesc
		Set Resume = objMrClass.BMResume
		Set Data=$lb(xID,Code,Desc,Resume)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryMrClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMrClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMrClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMrClassExecute ]
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
