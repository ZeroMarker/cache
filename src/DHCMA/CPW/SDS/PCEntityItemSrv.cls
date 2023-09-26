Class DHCMA.CPW.SDS.PCEntityItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     xuwenjie
/// CreatDate：   2018-08-30
/// Description:  查询质控病种信息
/// Table：       DHCMA.CPW.SD.PCEntityItem      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.PCEntityItemSrv","QryPCEntityItem",31)
Query QryPCEntityItem(aParRef As %String) As %Query(ROWSPEC = "BTRowID:%String,ChildID:%String,BTDesc:%String,BTCatCode:%String,BTCatDesc:%String,BTEpisCode:%String,BTEpisDesc:%String,PriceCode:%String,PriceDesc:%String,BTIsActive:%String,BTIndNo:%Integer")
{
}

ClassMethod QryPCEntityItemExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Set xSubDesc = ""
	Set xSubRowID=""	
 	For
 	{
	 	Set xSubDesc=$o(^DHCMA.CPW.SD.PCEntityI("ITM","IdxofITMDesc",xSubDesc))
	 	Quit:xSubDesc=""
	 	For
	 	{	
	 		Set xSubRowID=$o(^DHCMA.CPW.SD.PCEntityI("ITM","IdxofITMDesc",xSubDesc,aParRef,xSubRowID))
	 		Quit:xSubRowID=""
	 		Set xRowID = aParRef_"||"_xSubRowID
	 		Set ObjEntity = ##class(DHCMA.CPW.SD.PCEntityItem).GetObjById(xRowID)
	 		Set Desc          = ObjEntity.BTDesc
	 		Set CatDr         = ObjEntity.BTCatDr
	 		Set EpisDr        = ObjEntity.BTEpisDr
	 		Set CatCode="",CatDesc=""
	 		If $Isobject(CatDr){
		 		Set CatCode = CatDr.BTCode
	 			Set CatDesc = CatDr.BTDesc
		 	}
		 	Set EpisCode="",EpisDesc=""
	 		If $Isobject(EpisDr){
		 		Set EpisCode = EpisDr.BTCode
				Set EpisDesc = EpisDr.BTDesc
		 	}
			Set IsActive      = ObjEntity.BTIsActive
			Set IsActive = $s(IsActive=1:"是",1:"否")
			Set IndNo         = ObjEntity.BTIndNo	
			Set xPriceDr = ""
			Set PriceCode = ""
			Set PriceDesc = ""
			For
 			{
	 			Set xPriceDr=$o(^DHCMA.CPW.SD.PCEntityI("P","IdxofPPrice",xPriceDr))
	 			Quit:xPriceDr=""
	 			Set xGSRowID=""
	 			For
	 			{
		 			Set xGSRowID =$o(^DHCMA.CPW.SD.PCEntityI("P","IdxofPPrice",xPriceDr,aParRef,xSubRowID,xGSRowID))
		 			Quit:xGSRowID=""	 				 				
	 				Set objPrice = ##class(DHCMA.CPW.SD.PCPriceMast).GetObjById(xPriceDr)
	 				continue:'$Isobject(objPrice)
	 				Set PriceCode =PriceCode_","_objPrice.BTCode
	 				Set PriceDesc =PriceDesc_","_objPrice.BTDesc
	 			}
 			}
 			Set:PriceCode'="" PriceCode=$e(PriceCode,2,$l(PriceCode))
 			Set:PriceDesc'="" PriceDesc=$e(PriceDesc,2,$l(PriceDesc))
			Set Data=$lb(xRowID,xSubRowID,Desc,CatCode,CatDesc,EpisCode,EpisDesc,PriceCode,PriceDesc,IsActive,IndNo,PriceDr)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
 	}	
	Quit $$$OK
}

ClassMethod QryPCEntityItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPCEntityItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPCEntityItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPCEntityItemExecute ]
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

/// Creator：     xuwenjie
/// CreatDate：   2018-09-01
/// Description:  查询所有质控病种信息
/// Table：       DHCMA.CPW.SD.PCEntityItem      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.PCEntityItemSrv","QryAllPCItem")
Query QryAllPCItem() As %Query(ROWSPEC = "BTID:%String,BTDesc:%String,BTCatCode:%String,BTCatDesc:%String,BTEpisCode:%String,BTEpisDesc:%String,BTEntityCode:%String,BTEntityDesc:%String,BTIsActive:%Boolean,BTIndNo:%Integer")
{
}

ClassMethod QryAllPCItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	Set RowID=0
 	Set SubDesc = 0
 	For
 	{
	 	Set SubDesc=$o(^DHCMA.CPW.SD.PCEntityI("ITM","IdxofITMDesc",SubDesc))
	 	Quit:SubDesc=""
	 	Set ParRef = 0
	 	For
	 	{	
	 		Set ParRef=$o(^DHCMA.CPW.SD.PCEntityI("ITM","IdxofITMDesc",SubDesc,ParRef))
	 		Quit:ParRef=""
	 		Set SubRowID=0	
			For
			{	
				Set SubRowID=$o(^DHCMA.CPW.SD.PCEntityI("ITM","IdxofITMDesc",SubDesc,ParRef,SubRowID))
	 			Quit:SubRowID=""
	 			Set RowID = ParRef_"||"_SubRowID
	 			Set objPCEntity = ##class(DHCMA.CPW.SD.PCEntity).GetObjById(ParRef)
	 			Set EntityCode = objPCEntity.BTCode
	 			Set EntityDesc = objPCEntity.BTDesc
	 			Set ObjEntity = ##class(DHCMA.CPW.SD.PCEntityItem).GetObjById(RowID)
	 			Set Desc          = ObjEntity.BTDesc
	 			Set CatDr         = ObjEntity.BTCatDr
	 			Set EpisDr        = ObjEntity.BTEpisDr
	 			Set CatCode="",CatDesc=""
	 			If $Isobject(CatDr){
		 			Set CatCode = CatDr.BTCode
	 				Set CatDesc = CatDr.BTDesc
		 		}
		 		Set EpisCode="",EpisDesc=""
	 			If $Isobject(EpisDr){
		 			Set EpisCode = EpisDr.BTCode
					Set EpisDesc = EpisDr.BTDesc
		 		}
				Set IsActive      = ObjEntity.BTIsActive
				Set IsActive = $s(IsActive=1:"Y",1:"N")
				Set IndNo         = ObjEntity.BTIndNo	
	 			Set Data=$lb(RowID,Desc,CatCode,CatDesc,EpisCode,EpisDesc,EntityCode,EntityDesc,IsActive,IndNo)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1	
			}
			
	 	}
 	}	
	Quit $$$OK
}

ClassMethod QryAllPCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllPCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAllPCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllPCItemExecute ]
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
