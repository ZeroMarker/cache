/// 名称: DHCHAI.DPS.OEItmCatSrv
/// 描述: 医嘱分类维护相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-09
Class DHCHAI.DPS.OEItmCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-09
/// Description:  查询列表
/// Table：       DHCHAI.DP.OEAntiCat
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEItmCatSrv","QryOEItmCat")
Query QryOEItmCat() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOEItmCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OEItmCatD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OEItmCat).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTDesc=obj.BTDesc
	 	Set TypeID="",TypeCode="",TypeDesc=""
	 	If $IsObject(obj.BTTypeDr) {
		 	Set TypeID   = obj.BTTypeDr.%Id()
		 	Set TypeCode = obj.BTTypeDr.BTCode
		 	Set TypeDesc = obj.BTTypeDr.BTDesc
	 	}
		Set Data=$lb(xID,BTCode,BTDesc,TypeID,TypeCode,TypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOEItmCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEItmCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEItmCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEItmCatExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-08-17
/// Description:  查询医嘱项类型
/// Table：       DHCHAI.DP.OEItmType
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEItmCatSrv","QryOEItmType")
Query QryOEItmType() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOEItmTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OEItmTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OEItmType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTDesc=obj.BTDesc
	 	
		Set Data=$lb(xID,BTCode,BTDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOEItmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEItmTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEItmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEItmTypeExecute ]
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
