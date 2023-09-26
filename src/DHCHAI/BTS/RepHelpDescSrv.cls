/// 名称: DHCHAI.BTS.RepHelpDescSrv
/// 描述: 相关服务
/// 编写者：chenjb
/// 编写日期: 2020-05-07
Class DHCHAI.BTS.RepHelpDescSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2020-05-07
/// Description:  查询
/// Table：       DHCHAI
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.RepHelpDescSrv","QryRepHelp")
Query QryRepHelp(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,RepCode:%String,RepName:%String,RepDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepHelpExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.BT.RepHelpDescD(xID))
		Quit:xID=""
		
		Set objRep=##class(DHCHAI.BT.RepHelpDesc).GetObjById(xID)
		Continue:'$Isobject(objRep)
		
		Set RepCode    = objRep.RepCode 
		Set RepDesc    = objRep.RepDesc      
		Set RepName    = objRep.RepName
		
		Set Data = $lb(xID,RepCode,RepName,RepDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRepHelpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepHelpExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepHelpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepHelpExecute ]
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
