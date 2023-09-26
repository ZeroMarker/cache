Class DHCWL.CodeCfgData.GetItemGrpList Extends %RegisteredObject
{

/// Creator：      yuanxu
/// CreatDate：    2014-06-05
/// Description:： 通过分组大类ID按顺序得到组下面的明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgItemGroup、DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails
/// Input：       
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.GetItemGrpList","GetItemListByGrpIdQuery","1")
Query GetItemListByGrpIdQuery(grpId As %Text) As %Query(ROWSPEC = "itemID:%String,itemDesc:%String") [ SqlProc ]
{
}

ClassMethod GetItemListByGrpIdQueryExecute(ByRef qHandle As %Binary, grpId As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	k ^TEMPDHCWLCode($j)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpId="" 0
	s typeId=$list(^DHCWL.CodeCfg.ItemGroupD(grpId),8)
	s sort=0 f  s sort=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,sort)) q:sort=""  d
	.s itemDr=0 f  s itemDr=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,sort,itemDr)) q:itemDr=""  d
	..s realItemDr=$tr(itemDr," ","")
	..s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeId,realItemDr)
	..s ^CacheTemp(repid,ind)=$lb(realItemDr,itemDesc)
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod GetItemListByGrpIdQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemListByGrpIdQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetItemListByGrpIdQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemListByGrpIdQueryExecute ]
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

/// Creator：      yuanxu
/// CreatDate：    2014-06-05
/// Description:： 通过分组大类CODE按顺序得到组下面的明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgItemGroup、DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails
/// Input：       
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.CodeCfgData.GetItemGrpList","GetItemListByGrpCodeQuery","IPLocGrp")
Query GetItemListByGrpCodeQuery(grpCode As %Text) As %Query(ROWSPEC = "itemID:%String,itemDesc:%String") [ SqlProc ]
{
}

ClassMethod GetItemListByGrpCodeQueryExecute(ByRef qHandle As %Binary, grpCode As %Text) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	k ^TEMPDHCWLCode($j)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:grpCode="" 0
	s code=$zcvt(grpCode,"U")
	s grpId=$o(^DHCWL.CodeCfg.ItemGroupI("Code"," "_code,"")) 
	q:grpId="" 0
	s typeId=$list(^DHCWL.CodeCfg.ItemGroupD(grpId),8)
	s sort=0 f  s sort=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,sort)) q:sort=""  d
	.s itemDr=0 f  s itemDr=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIMSort",grpId,sort,itemDr)) q:itemDr=""  d
	..s realItemDr=$tr(itemDr," ","")
	..s itemDesc=##class(DHCWL.Interface.MkpiData).GetDimPropertyValue(typeId,realItemDr)
	..s ^CacheTemp(repid,ind)=$lb(realItemDr,itemDesc)
	..s ind=ind+1
		
	Quit $$$OK
}

ClassMethod GetItemListByGrpCodeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemListByGrpCodeQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetItemListByGrpCodeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemListByGrpCodeQueryExecute ]
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
