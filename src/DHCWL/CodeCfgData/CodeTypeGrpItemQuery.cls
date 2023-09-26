Class DHCWL.CodeCfgData.CodeTypeGrpItemQuery Extends %RegisteredObject
{

/// 取到大组维护下面的明细项目
/// d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.CodeTypeGrpItemQuery","CodeTypeItemQuery","1")
Query CodeTypeItemQuery(grpId As %Text) As %Query(ROWSPEC = "ID:%String,itemDesc:%String,ItmGrpDetSort:%String") [ SqlProc ]
{
}

ClassMethod CodeTypeItemQueryExecute(ByRef qHandle As %Binary, grpId As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpId="" ""
	s count=0
	//s typeId=$list(^DHCWL.CodeCfg.ItemGroupD(grpId),4)
	s typeId=$list(^DHCWL.CodeCfg.ItemGroupD(grpId),8)    //取维度ID
	s ItmGrpDetSort=0 f  s ItmGrpDetSort=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,ItmGrpDetSort)) q:ItmGrpDetSort=""  d
	.s itmDr=0 f  s itmDr=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,ItmGrpDetSort,itmDr)) q:itmDr=""  d
	..s itemGrpID=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,ItmGrpDetSort,itmDr,""))
	..s itemGrpDetailID=$lg(^DHCWL.CodeCfg.ItemGroupDetailsD(itemGrpID),3)
	..s ID=$tr(itemGrpDetailID," ")
	..//s itemDesc=$p(##class(DHCWL.CodeCfg.Type).GetValueDeseById(typeId,ID),"@")
	..s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeId,ID) 
	..s itemDesc=##class(DHCWL.CodeCfgData.FunctionModule).DePecialChar(itemDesc) 
	..s ^CacheTemp(repid,ind)=$lb(ID,itemDesc,ItmGrpDetSort)
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod CodeTypeItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodeTypeItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod CodeTypeItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodeTypeItemQueryExecute ]
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
