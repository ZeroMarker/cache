/// 名称: DHCHAI.IRS.CCKeyWordSrv
/// 描述: 关键词定义服务
/// 编写者：pylian
/// 编写日期: 2017-08-02
Class DHCHAI.IRS.CCKeyWordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-08-02
/// Description:  查询关键词
/// Table：       DHCHAI.IR.CCKeyWord
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCKeyWordSrv","QryKeyWordSrv")
Query QryKeyWordSrv() As %Query(ROWSPEC = "ID:%String,Desc:%String,Note:%String") [ SqlProc ]
{
}

ClassMethod QryKeyWordSrvExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCKeyWordD(xID))
		Quit:xID=""
		
		Set objKey = ##class(DHCHAI.IR.CCKeyWord).GetObjById(xID)
		Continue:'$isobject(objKey)
		
	 	Set Desc  = objKey.CCDesc
		Set Note  = objKey.CCNote
		Set Data = $lb(xID,Desc,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryKeyWordSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKeyWordSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryKeyWordSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKeyWordSrvExecute ]
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
