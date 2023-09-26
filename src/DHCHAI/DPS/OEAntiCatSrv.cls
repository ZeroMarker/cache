/// 名称: DHCHAI.DPS.OEAntiCatSrv
/// 描述: 医嘱-抗菌药物分类维护相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-09
Class DHCHAI.DPS.OEAntiCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-09
/// Description:  查询列表
/// Table：       DHCHAI.DP.OEAntiCat
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEAntiCatSrv","QryOEAntiCat")
Query QryOEAntiCat() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOEAntiCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OEAntiCatD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OEAntiCat).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTDesc=obj.BTDesc
	 	
		Set Data=$lb(xID,BTCode,BTDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOEAntiCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEAntiCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEAntiCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEAntiCatExecute ]
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
