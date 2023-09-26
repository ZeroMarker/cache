/// 名称: DHCHAI.DPS.OEItmMastSrv
/// 描述: 医嘱项分类维护相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-05
Class DHCHAI.DPS.OEItmMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  查询列表
/// Table：       DHCHAI.DP.OEItemMast
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEItmMastSrv","QryOEItmMast")
Query QryOEItmMast() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTCatDr:%String,BTCatCode:%String,BTCatDesc:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryOEItmMastExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OEItmMastD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OEItmMast).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTDesc=obj.BTDesc
		
		If $IsObject(obj.BTCatDr) {
			Set BTCatDr=obj.BTCatDr.%Id()
			Set BTCatCode=obj.BTCatDr.BTCode
			Set BTCatDesc=obj.BTCatDr.BTDesc
		} Else {
			Set BTCatDr="",BTCatCode="",BTCatDesc=""
		}
		Set IsActive=obj.BTIsActive
		
		Set Data=$lb(xID,BTCode,BTDesc,BTCatDr,BTCatCode,BTCatDesc,IsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOEItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEItmMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEItmMastExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-07-28
/// Description:  导入医嘱分类字典
/// Table：       DHCHAI.DP.OEItmMast
/// Input：       
/// w ##class("DHCHAI.DPS.OEItmMastSrv").ImportItemMast("1^1^中央血管导管（颈内）^中央血管导管^1","^")
ClassMethod ImportItemMast(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set CatDesc = $p(aInputStr,aSeparate,4)
	Set MastDr=""
	Set objItmMast = ##class(DHCHAI.DP.OEItmCat).GetObjByCodeDesc("",CatDesc)
	Set:$isobject(objItmMast) MastDr = objItmMast.%Id()
	Set $p(aInputStr,aSeparate,4) = MastDr 
	
	Set return=##Class(DHCHAI.DP.OEItmMast).Update(aInputStr,aSeparate)
	Quit return
}

}
