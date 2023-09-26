/// 名称: DHCHAI.DPS.MRICDDxSrv
/// 描述: 诊断字典标准化相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.DPS.MRICDDxSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-05-04
/// Description:  查询列表
/// Table：       DHCHAI.DP.MRICDDx
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MRICDDxSrv","QryMRICDDx")
Query QryMRICDDx() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryMRICDDxExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.MRICDDxD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.MRICDDx).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTDesc=obj.BTDesc
		Set BTIsActive=obj.BTIsActive
		
		set Data=$lb(xID,BTCode,BTDesc,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMRICDDxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRICDDxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRICDDxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRICDDxExecute ]
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
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MRICDDxSrv","QryMRICDDxByInput","糖尿病")
Query QryMRICDDxByInput(InputStr As %String) As %Query(ROWSPEC = "id:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryMRICDDxByInputExecute(ByRef qHandle As %Binary, InputStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.MRICDDxD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.MRICDDx).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTDesc=obj.BTDesc
	 	Continue:(InputStr'="")&&(BTCode'[InputStr)&&(BTDesc'[InputStr)
		Set BTIsActive=obj.BTIsActive
		
		set Data=$lb(xID,BTCode,BTDesc,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMRICDDxByInputClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRICDDxByInputExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRICDDxByInputFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRICDDxByInputExecute ]
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
