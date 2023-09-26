Class DHCMA.CPW.SD.StandSrv.OrderSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.StandSrv.OrderSrv","QryHisOrder","1","42","76||236","","Y")
Query QryHisOrder(aSYSDr As %String = "1", aSourceID As %String, aDicID As %String, aOrderAlias As %String, aMatchFlg As %String = "") As %Query(ROWSPEC = "RowID,Code,Desc,CatDesc,IsActive,checked")
{
}

ClassMethod QryHisOrderExecute(ByRef qHandle As %Binary, aSYSDr As %String = "1", aSourceID As %String, aDicID As %String, aOrderAlias As %String, aMatchFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^tmpzgz421=$lb(aSYSDr,aSourceID,aDicID,aOrderAlias,aMatchFlg)
 	Quit:(aSourceID="")||(aDicID="") $$$OK
 	Set objSource=##class(DHCMA.Util.BT.Dictionary).GetObjById(aSourceID)
 	Set SourceDec=objSource.BTDesc
 	Set aOrderType=$S(SourceDec["药":"R",SourceDec["检验":"L",SourceDec["检查":"NX",SourceDec["处置":"N",1:"")
 	//非限定类型的医嘱，必须要有医嘱关键词才进行检索
 	Quit:(aOrderType="")&&(aOrderAlias="")&&(aMatchFlg'="Y") $$$OK
 	Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(aDicID)
 	Set OrderType=""
 	For {
 		Set OrderType=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfType",aSYSDr,OrderType))
 		Quit:OrderType=""
 		Continue:(aOrderType'="")&&(aOrderType'[OrderType)
	 	Set xRowID=0
	 	For
	 	{
		 	Set xRowID     = $o(^DHCMA.Util.EPx.OrdMastI("IdxOfType",aSYSDr,OrderType,xRowID))
		 	Quit:xRowID=""
		 	Set obj        = ##class(DHCMA.Util.EPx.OrdMast).GetObjById(xRowID)
		 	//取对照医嘱
		 	Continue:(aMatchFlg="Y")&&(("^"_LinkOrder_"^")'[("^"_xRowID_"^"))
		 	//取未对照医嘱
		 	Continue:(aMatchFlg="N")&&(("^"_LinkOrder_"^")[("^"_xRowID_"^"))
		 	Set checked=""
		 	Set:("^"_LinkOrder_"^")[("^"_xRowID_"^") checked=1
		 	Set Code       = obj.BTCode
		 	Set Desc       = obj.BTDesc 
		 	Continue:(aOrderAlias'="")&&(Desc'[aOrderAlias) 
		 	Set CatDesc    = obj.BTCatDesc
		 	Continue:(SourceDec["检查")&&(CatDesc'["检查")&&(CatDesc'["X线")
		 	Continue:(SourceDec["处置")&&(CatDesc'["处置")
		 	Set IsActive   = obj.BTIsActive
		 	Continue:IsActive=0
			Set Data=$lb(xRowID,Code,Desc,CatDesc,IsActive,checked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}	
 	}
	Quit $$$OK
}

ClassMethod QryHisOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHisOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHisOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHisOrderExecute ]
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
