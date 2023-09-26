Class DHCMA.CPW.SDS.PCItemCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     xuwenjie
/// CreatDate：   2018-08-28
/// Description:  查询项目分类
/// Table：       DHCMA.CPW.SD.PCItemCat      
/// output:   	  BTCode:%String,BTDesc:%String
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.PCItemCatSrv","QryPCItemCat")
Query QryPCItemCat() As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String")
{
}

ClassMethod QryPCItemCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.PCItemCatD(xRowID))
	 	Quit:xRowID=""
	 	Set objItem        = ##class(DHCMA.CPW.SD.PCItemCat).GetObjById(xRowID)
	 	Set Code         = objItem.BTCode
	 	Set Desc         = objItem.BTDesc    
		Set Data=$lb(xRowID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPCItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPCItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPCItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPCItemCatExecute ]
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
