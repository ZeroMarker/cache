/// 名称: DHCHAI.DPS.MROBSItemCatSrv
/// 描述: 护理分类维护相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-05
Class DHCHAI.DPS.MROBSItemCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  查询列表
/// Table：       DHCHAI.DP.MROBSItemCat
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MROBSItemCatSrv","QryMROBSItemCat")
Query QryMROBSItemCat() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMROBSItemCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.MROBSItemCatD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.MROBSItemCat).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
		Set BTDesc=obj.BTDesc
		
		Set Data=$lb(xID,BTCode,BTDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMROBSItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMROBSItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMROBSItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMROBSItemCatExecute ]
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
