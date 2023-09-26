/// 名称: DHCHAI.RMES.ResultCatSrv
/// 描述: 实体分类相关服务
/// 编写者：pylian
/// 编写日期: 2017-10-17
Class DHCHAI.RMES.ResultCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-10-17
/// Description:  查询实体分类信息
/// Table：       DHCHAI.RME.ResultCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ResultCatSrv","QryResultCat")
Query QryResultCat() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryResultCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.RME.ResultCatI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.RME.ResultCatI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objRltCat = ##class(DHCHAI.RME.ResultCat).GetObjById(xID)
			Continue:'$isobject(objRltCat)
			
			Set Code = objRltCat.BTCode
			Set Desc = objRltCat.BTDesc
			
			Set Data = $lb(xID,Code,Desc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryResultCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryResultCatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryResultCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResultCatExecute ]
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
