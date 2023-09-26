/// 名称: DHCWMR.MQService.DataItemSrv
/// 描述: 首页数据项分类服务
/// 编写者：liyi
/// 编写日期: 2016-03-31
Class DHCWMR.MQService.DataCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  Creator：     liyi
///  CreatDate：   2016-03-31
///  Description:  查询首页数据项大类
///  Table：       DHCWMR.MQ.DataCat
///  Return：      返回Query
///  d ##class(%ResultSet).RunQuery("DHCWMR.MQService.DataCatSrv","QryDataCat")
Query QryDataCat() As %Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod QryDataCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set xID=""
	For {
		Set xID=$o(^DHCWMR.MQ.DataCatD(xID))
		Quit:xID=""
		
		Set objCat = ##class(DHCWMR.MQ.DataCat).GetObjById(xID)
		Continue:'$isobject(objCat)
		
		Set Desc=objCat.DCDesc
		Set Data = $lb(xID,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Quit $$$OK
}

ClassMethod QryDataCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDataCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDataCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDataCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

///  Creator：     liyi
///  CreatDate：   2016-03-31
///  Description:  查询首页数据项子类
///  Table：       DHCWMR.MQ.DataSubCat
///  Return：      返回Query
///  d ##class(%ResultSet).RunQuery("DHCWMR.MQService.DataCatSrv","QryDataSubCat",2)
Query QryDataSubCat(aDataCatID As %String) As %Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod QryDataSubCatExecute(ByRef qHandle As %Binary, aDataCatID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:aDataCatID="" $$$OK
	Quit:'$d(^DHCWMR.MQ.DataCatD(aDataCatID)) $$$OK

	Set xID=""
	For {
		Set xID=$o(^DHCWMR.MQ.DataCatD(aDataCatID,"Sub",xID))
		Quit:xID=""
		
		Set ID=aDataCatID_"||"_xID
		Set objSubCat=##class(DHCWMR.MQ.DataSubCat).GetObjById(ID)
		Continue:'$isobject(objSubCat)
		
		Set Desc = objSubCat.DSCDesc
		Set Data = $lb(ID,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Quit $$$OK
}

ClassMethod QryDataSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDataSubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDataSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDataSubCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

}
