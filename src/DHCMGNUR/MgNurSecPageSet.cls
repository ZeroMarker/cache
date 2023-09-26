Class DHCMGNUR.MgNurSecPageSet Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s mould=%request.Data("mouldid",1)
	if mould=""  Quit $$$OK
	w "["
	s flag=0
    ;s code="" f  s code=$O(^DHCMGNUR.MgChildPagEleI("Code",code)) q:code=""  d
    ;s rw="" f  s rw=$O(^DHCMGNUR.MgChildPagEleI("Code",code,rw)) q:rw=""  d
    s obj=##class(DHCMGNUR.MgChildPagEle).%OpenId(mould)
    s title=obj.MenuTitle
    s code=obj.MenuCode
    s nodid=""
    if (nodid="") s nodid=code
    if flag=1 w ","
    w "{text:"""_title_""","
    w "id:'"_nodid_"'"
    i $D(^DHCMGNUR.MgChildPagEleD(mould,"ChildSub")) d
    .w ",checked:false,children:"
    .d ..PrintChild(mould)
    .w "}"
    e  d
    .w ",checked:false,leaf:true}"
    w "]"
	Quit $$$OK
}

ClassMethod PrintChild(par)
{
	w "["
   	s flag=0
   	s code=""  f  s code=$O(^DHCMGNUR.MgChildPagEleSubI("ItemCode",code)) q:code=""  d
   	.s rw="" f  s rw=$O(^DHCMGNUR.MgChildPagEleSubI("ItemCode",code,par,rw)) q:rw=""  d
   	..s obj=##class(DHCMGNUR.MgChildPagEleSub).%OpenId(par_"||"_rw)
   	..s b=##class(DHCMGNUR.MgChildPagEle).%OpenId(par)
   	..s itemCode=obj.ItemCode
   	..s itemDesc=obj.ItemDesc
   	..if flag=1 w ","
   	..w "{text:"""_itemDesc_""","
   	..w "id:'"_b.MenuCode_"^"_itemCode_"'"
   	..w ",checked:false,leaf:true,iconCls:'icon'}"
   	..s flag=1
  	w "]"
}

}
