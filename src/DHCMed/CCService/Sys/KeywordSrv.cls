/// <H3>关键字维护模块</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-08-01</H4>
Class DHCMed.CCService.Sys.KeywordSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     lyh
/// CreatDate：   2010-04-07
/// Description:  通过rowid查询关键字信息和产品信息
/// Table：       DHCMed.CC.KeywordInfo
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.KeywordSrv","QryAll")
Query QryAll() As %Query(ROWSPEC = "rowid:%String,Code:%String:代码,Description:%String,IsActive:%String,Resume:%String,TimeLineCode:%String")
{
}

ClassMethod QryAllExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC("Keyword",RowID))
		Quit:RowID=""
		
		Set obj=##class(DHCMed.CC.KeyWord).GetObjById(RowID)
		Continue:'$IsObject(obj)
		Set Data=""
		Set $li(Data,1)=RowID
		Set $li(Data,2)=obj.Code
		Set $li(Data,3)=obj.Description
		Set $li(Data,4)=obj.IsActive
		Set $li(Data,5)=obj.Resume
		Set $li(Data,6)=obj.TimeLineCode
	    Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
