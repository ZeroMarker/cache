Class DHCMA.CPW.SDS.PCEntityPriceSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     xuwenjie
/// CreatDate：   2018-09-03
/// Description:  查询服务价格信息
/// Table：       DHCMA.CPW.SD.PCEntityPrice      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.PCEntityPriceSrv","QryPCEntityPrice","32||1")
Query QryPCEntityPrice(aParRef As %String) As %Query(ROWSPEC = "ID:%String,ChildID:%String,PriceDr:%String,BTPriceCode:%String,BTPriceDesc:%String")
{
}

ClassMethod QryPCEntityPriceExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Quit:aParRef="" return
 	Set ind=1
 	Set xPriceDr = ""
	Set xRowID=$p(aParRef,"||",1)
	Set xSubRowID=$p(aParRef,"||",2)	
 	For
 	{
	 	Set xPriceDr=$o(^DHCMA.CPW.SD.PCEntityI("P","IdxofPPrice",xPriceDr))
	 	Quit:xPriceDr=""
	 	Set xGSRowID=""
	 	For
	 	{
		 	Set xGSRowID =$o(^DHCMA.CPW.SD.PCEntityI("P","IdxofPPrice",xPriceDr,xRowID,xSubRowID,xGSRowID))
		 	Quit:xGSRowID=""	 				 				
	 		Set objPrice = ##class(DHCMA.CPW.SD.PCPriceMast).GetObjById(xPriceDr)
	 		Set ID = aParRef_"||"_xGSRowID
	 		continue:'$Isobject(objPrice)
	 		Set PriceCode = objPrice.BTCode
	 		Set PriceDesc = objPrice.BTDesc
	 		Set Data=$lb(ID,xGSRowID,xPriceDr,PriceCode,PriceDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		 }
 	}	
	Quit $$$OK
}

ClassMethod QryPCEntityPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPCEntityPriceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPCEntityPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPCEntityPriceExecute ]
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
