/// 名称: DHCHAI.DPS.RBItmMastSrv
/// 描述: 检查分类标准相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.DPS.RBItmMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-05-04
/// Description:  查询列表
/// Table：       DHCHAI.DP.RBItmMast
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.RBItmMastSrv","QryRBItmMast")
Query QryRBItmMast() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTCName:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryRBItmMastExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.RBItmMastD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.RBItmMast).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTCName=obj.BTCName
		Set BTIsActive=obj.BTIsActive
		
		set Data=$lb(xID,BTCode,BTCName,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryRBItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRBItmMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRBItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRBItmMastExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-05-04
/// Description:  查询列表
/// Table：       DHCHAI.DP.MRICDDx
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.RBItmMastSrv","QryRBItmMastByInput","")
Query QryRBItmMastByInput(InputStr As %String) As %Query(ROWSPEC = "id:%String,BTCode:%String,BTCName:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryRBItmMastByInputExecute(ByRef qHandle As %Binary, InputStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	//转大写
	Set InputStrU =$zcvt(InputStr,"U")
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.RBItmMastD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.RBItmMast).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTCName=obj.BTCName
	 	Continue:(InputStr'="")&&(BTCode'[InputStr)&&(BTCName'[InputStr)&&(BTCode'[InputStrU)&&(BTCName'[InputStrU)
		Set BTIsActive=obj.BTIsActive
		
		set Data=$lb(xID,BTCode,BTCName,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryRBItmMastByInputClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRBItmMastByInputExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRBItmMastByInputFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRBItmMastByInputExecute ]
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
