/// 名称: DHCHAI.DPS.OROperDxSrv
/// 描述: 手术切口标准化相关服务
/// 编写者：chenjb
/// 编写日期: 2017-03-20
Class DHCHAI.DPS.OROperDxSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-05-04
/// Description:  查询列表
/// Table：       DHCHAI.DP.OROperDx
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OROperDxSrv","QryOROperDx")
Query QryOROperDx() As %Query(ROWSPEC = "ID:%String,BTOperCode:%String,BTOperDesc:%String,IncDr:%String,IncDesc:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryOROperDxExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OROperDxD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OROperDx).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTOperCode=obj.BTOperCode
	 	Set BTOperDesc=obj.BTOperDesc
	 	Set IncDr="",IncCode="",IncDesc=""
		If $IsObject(obj.BTOperIncDr) {
			Set IncDr 	= obj.BTOperIncDr.%Id()
			Set IncCode	= obj.BTOperIncDr.BTCode
			Set IncDesc	= obj.BTOperIncDr.BTDesc	
		}
			
		Set BTIsActive=obj.BTIsActive
		
		set Data=$lb(xID,BTOperCode,BTOperDesc,IncDr,IncDesc,BTIsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOROperDxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOROperDxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOROperDxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOROperDxExecute ]
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
/// Table：       DHCHAI.DP.OROperDx
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OROperDxSrv","QryOROperDxByInput","")
Query QryOROperDxByInput(InputStr As %String) As %Query(ROWSPEC = "id:%String,BTOperCode:%String,BTOperDesc:%String,BTIsActive:%String,IncDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOROperDxByInputExecute(ByRef qHandle As %Binary, InputStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	//转大写
	Set InputStrU =$zcvt(InputStr,"U")
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OROperDxD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OROperDx).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTOperCode=obj.BTOperCode
	 	Set BTOperDesc=obj.BTOperDesc
	 	Continue:(InputStr'="")&&(BTOperCode'[InputStr)&&(BTOperDesc'[InputStr)&&(BTOperCode'[InputStrU)&&(BTOperDesc'[InputStrU)
		Set BTIsActive=obj.BTIsActive
		Set:$IsObject(obj.BTOperIncDr) IncDesc = obj.BTOperIncDr.BTDesc
		set Data=$lb(xID,BTOperCode,BTOperDesc,BTIsActive,IncDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOROperDxByInputClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOROperDxByInputExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOROperDxByInputFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOROperDxByInputExecute ]
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
