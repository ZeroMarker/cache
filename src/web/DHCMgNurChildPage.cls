Class web.DHCMgNurChildPage Extends %RegisteredObject
{

/// 
/// 

ClassMethod getssgrpcheck(ssgrp As %String, mouldcode As %String) As %String
{
    s mouldcode=$ZConvert(mouldcode,"U")
    s mouldid=$O(^DHCMGNUR.MgChildPagEleI("Code"," "_mouldcode,""))
    i mouldid="" q ""
    s ret=""
    s rw="" f  s rw=$O(^DHCMGNUR.MgNurSecLayOutI("secGrp"," "_ssgrp," "_mouldid,rw)) q:rw=""  d
    .s obj=##class(DHCMGNUR.MgNurSecLayOut).%OpenId(rw)
    .s m=##class(DHCMGNUR.MgChildPagEle).%OpenId(obj.laytitle)
    .s chl="" f  s chl=$O(^DHCMGNUR.MgNurSecLayOutD(rw,"ChildSub",chl)) q:chl=""  d
    ..s bb=##class(DHCMGNUR.MgNurSecLayOutSub).%OpenId(rw_"||"_chl)
    ..i ret'="" s ret=ret_"|"
    ..i ret="" s ret=bb.laysubmoud.MenuCode
    ..e  s ret=ret_bb.laysubmoud.MenuCode
    ..s itm=..getitm(bb.laysubitem,bb.laysubmoud.MenuCode)
    ..i itm'="" s ret=ret_"|"_itm
    q ret
}

ClassMethod getitm(itms, menucode) As %String
{
	s l=$L(itms,"^")
  	s ret=""
  	f i=1:1:l 
  	{
	  s parw=$P(itms,"^",i)
	  if parw="" continue
	  s a=##class(DHCMGNUR.MgChildPagEleSub).%OpenId(parw)
	  if a="" continue
	  if ret'="" s ret=ret_"|"_menucode_"^"_a.ItemCode
	  e  s ret=menucode_"^"_a.ItemCode
	}
	q ret
}

/// 
/// 

ClassMethod getmould(ssgrp = "") As %String
{
    s ret=""
    if ssgrp'=""
    {
      ;s mouldid="" f  s mouldid=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp,mouldid)) q:mouldid=""  d
      ; .s rw="" f  s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp,mouldid,rw)) q:rw=""  d
   	  ; ..s a=##class(DHCMGNUR.GSSGRPLAYOUT).%OpenId(rw)
   	  ; ..s m=##class(DHCMGNUR.Mould).%OpenId(a.laytitle)
   	  ; ..s code=m.Code
      ; ..if ret'="" s ret=ret_"^"
      ; ..s ret=ret_code_"|"_a.laytitle


    }else{
	    s mould="" f  s mould=$O(^DHCMGNUR.MgChildPagEleI("Code",mould)) q:mould=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MgChildPagEleI("Code",mould,rw)) q:rw=""  d
	    ..s obj=##class(DHCMGNUR.MgChildPagEle).%OpenId(rw)
	    ..q:obj=""
	    ..s code=obj.MenuCode
	    ..i ret'="" s ret=ret_"^"
	    ..s ret=ret_code_"|"_rw 
    }
   q ret
}

/// 
/// 

ClassMethod getmouldext(ssgrp = "") As %String
{
	
 //w ##class(web.DHCMgNurSysComm).getmouldext()
   	s ret=""
   	if ssgrp'=""
   	{
	   	;s maxorder=1000
		;s mouldid="" f  s mouldid=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp,mouldid)) q:mouldid=""  d
   		;.s a=##class(DHCMGNUR.Mould).%OpenId($TR(mouldid," ",""))
		;.s order=a.MSort
		;.i order="" s order=maxorder,maxorder=maxorder-1
		;.s temp(order)=a
		;s ord="" f  s ord=$O(temp(ord)) q:ord=""  d
		;.s b=temp(ord)
		;.s mouldname=b.MouldName
    	;.s mouldcode=b.Code
    	;.q:mouldcode=""
    	;.s ico=b.Icon
    	;.if ret'="" s ret=ret_","
    	;.s ret=ret_"{iconCls:'"_ico_"',title:'"_mouldname_"',html:'<div id="""_mouldcode_""" autoScroll:true></div>'}"
   		;s ret="["_ret_"]"
  	}else{
   		s code=""  f  s code=$O(^DHCMGNUR.MgChildPagEleI("Code",code)) q:code=""  d
   		.s rw="" f  s rw=$O(^DHCMGNUR.MgChildPagEleI("Code",code,rw)) q:rw=""  d
   		..s obj=##class(DHCMGNUR.MgChildPagEle).%OpenId(rw)
   		..q:obj=""
   		..s mouldname=obj.MenuTitle
   		..s mouldcode=obj.MenuCode
   		..q:mouldcode=""
   		..i ret'="" s ret=ret_","
   		..s ret=ret_"{title:'"_mouldname_"',html:'<div id="""_mouldcode_""" autoScroll:true></div>'}"
   		s ret="["_ret_"]"
  	}
   	q ret
}

/// 
/// MethodDescription:查找护管安全组
/// Date:2015-02-12
Query SSGROUP(desc As %String) As %Query(ROWSPEC = "Group:%String,ID:%String")
{
}

ClassMethod SSGROUPExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s sec="" f  s sec=$O(^DHCMGNUR.MgNurSecGrpI("SCode",sec)) q:sec=""  d
 	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurSecGrpI("SCode",sec,rw)) q:rw=""  d
 	..s obj=##class(DHCMGNUR.MgNurSecGrp).%OpenId(rw)
 	..s secGrpDesc=obj.SecGrpDesc
 	..q:((secGrpDesc'[desc)&(desc'=""))
 	..d Output4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Output4
	s Data=$lb(secGrpDesc,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod SSGROUPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SSGROUPExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SSGROUPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SSGROUPExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 
/// MethodDescripition:查找子集页面列表信息
/// Date:2015-02-11
Query FindChildPage(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindChildPageExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s code="" f  s code=$O(^DHCMGNUR.MgChildPagEleI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^DHCMGNUR.MgChildPagEleI("Code",code,id)) q:id=""  d
	..s obj=##class(DHCMGNUR.MgChildPagEle).%OpenId(id)
	..s MenuCode=obj.MenuCode
	..s MenuTitle=obj.MenuTitle
	..s ret="MenuCode|"_MenuCode_"^MenuTitle|"_MenuTitle_"^rw|"_id
	..s ret=ret 
	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindChildPageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChildPageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindChildPageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChildPageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// MethodDescription:查找子页面控制元素
/// Date:2015-02-11
Query FindChildSubCtl(par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindChildSubCtlExecute(ByRef qHandle As %Binary, par As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
 	s ^TEMPPARR("parr1842001")=par
 	s code="" f  s code=$O(^DHCMGNUR.MgChildPagEleSubI("ItemCode",code)) q:code=""  d
 	.s rw="" f  s rw=$O(^DHCMGNUR.MgChildPagEleSubI("ItemCode",code,par,rw)) q:rw=""  d
 	..b ;002
 	..s obj=##class(DHCMGNUR.MgChildPagEleSub).%OpenId(par_"||"_rw)
 	..s ItemCode=obj.ItemCode
 	..s ItemTyp=obj.ItemTyp
 	..s ItemDesc=obj.ItemDesc
 	..b ;01
	..s ret="ItemCode|"_ItemCode_"^ItemTyp|"_ItemTyp_"^ItemDesc|"_ItemDesc_"^raw|"_par_"__"_rw
	..s ret=ret 
	..d OutRowtyp
	 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindChildSubCtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChildSubCtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindChildSubCtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChildSubCtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

}
