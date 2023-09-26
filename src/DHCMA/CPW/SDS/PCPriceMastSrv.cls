Class DHCMA.CPW.SDS.PCPriceMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     xuwenjie
/// CreatDate：   2018-08-28
/// Description:  查询服务价格
/// Table：       DHCMA.CPW.SD.PCPriceMast      
/// output:   	  BTCode:%String,BTDesc:%String
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.PCPriceMastSrv","QryPriceMast")
Query QryPriceMast() As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTNote:%String,BTException:%String,BTChargeUnit:%String,BTChargeNote:%String")
{
}

ClassMethod QryPriceMastExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.PCPriceMastD(xRowID))
	 	Quit:xRowID=""
	 	Set objPrice              = ##class(DHCMA.CPW.SD.PCPriceMast).GetObjById(xRowID)
	 	Set Code               = objPrice.BTCode
	 	Set Desc               = objPrice.BTDesc  
	 	Set Note               = objPrice.BTNote
	 	Set Exception          = objPrice.BTException
	 	Set ChargeUnit         = objPrice.BTChargeUnit
	 	Set ChargeNote         = objPrice.BTChargeNote 
		Set Data=$lb(xRowID,Code,Desc,Note,Exception,ChargeUnit,ChargeNote)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPriceMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPriceMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPriceMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPriceMastExecute ]
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
