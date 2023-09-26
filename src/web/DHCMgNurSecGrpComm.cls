Class web.DHCMgNurSecGrpComm Extends %RegisteredObject
{

/// 
/// Method Description:查询护理管理安全组
/// Date:2015-01-05
Query SearchNurSecGrp() As %Query(ROWSPEC = "SecGrpCode,SecGrpDesc,Par")
{
}

ClassMethod SearchNurSecGrpExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s typ="" f  s typ=$O(^DHCMGNUR.MgNurSecGrpI("SCode",typ)) q:typ=""  d
	.s id="" f  s id=$O(^DHCMGNUR.MgNurSecGrpI("SCode",typ,id)) q:id=""  d
	..s a=##class(DHCMGNUR.MgNurSecGrp).%OpenId(id)
	..s SecGrpCode=a.SecGrpCode
	..s SecGrpDesc=a.SecGrpDesc
	..s Par=id
	..d OutRowtyp
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(SecGrpCode,SecGrpDesc,Par)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchNurSecGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNurSecGrpExecute ]
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

ClassMethod SearchNurSecGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNurSecGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// Method Decription:查询HIS安全组
/// Date：2015-01-05
Query SchSecGrpForHIS(typ = "") As %Query(ROWSPEC = "HISSGrpCode,HISSGrpDesc")
{
}

ClassMethod SchSecGrpForHISExecute(ByRef qHandle As %Binary, typ = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s ^TMP("typg")=typ
	s typ=$ZConvert(typ,"U")
	s id="" f  s id=$O(^SSU("SSGRP",id)) q:id=""  d
	.s a=##class(User.SSGroup).%OpenId(id)
	.q:'$IsObject(a)
	.s HISSGrpDesc=a.SSGRPDesc
	.q:(HISSGrpDesc'[typ)&&(typ'="")
	.s HISSGrpCode=id
	.d OutRowtyp
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(HISSGrpCode,HISSGrpDesc)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchSecGrpForHISFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchSecGrpForHISExecute ]
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

ClassMethod SchSecGrpForHISClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchSecGrpForHISExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// Hospital:标准库
/// Method Description:查询护理管理关联HIS匹配的安全组
/// Date:2015-01-26
Query SchMgSGrpforHIS(typ = "") As %Query(ROWSPEC = "HISSGrpDesc,SecGrpDesc,rw")
{
}

ClassMethod SchMgSGrpforHISExecute(ByRef qHandle As %Binary, typ = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s hisgrp="" f  s hisgrp=$O(^DHCMGNUR.MgNurSecGrpForHISI("Typ",hisgrp)) q:hisgrp=""  d
	.s id="" f  s id=$O(^DHCMGNUR.MgNurSecGrpForHISI("Typ",hisgrp,id)) q:id=""  d
	..s a=##class(DHCMGNUR.MgNurSecGrpForHIS).%OpenId(id)
	..s HISSGrpDesc=a.HisSecGrpDesc
	..s SecGrpDesc=a.MgSecGrpDesc
	..s rw=id
	..d OutRowtyp
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(HISSGrpDesc,SecGrpDesc,rw)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchMgSGrpforHISFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchMgSGrpforHISExecute ]
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

ClassMethod SchMgSGrpforHISClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchMgSGrpforHISExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// ClassMethod Description:获取护理系统安全组并返回
/// Date:2015-02-04
ClassMethod getMgSecGrp(grpid) As %String
{
	s ^TEMP("g2015secgrp001")=grpid
	s ret=0
	s id=$O(^DHCMGNUR.MgNurSecGrpForHISI("Typ"," "_grpid,""))
	i id'="" d
	.s grpObj=##class(DHCMGNUR.MgNurSecGrpForHIS).%OpenId(id)
	.s mgGrp=grpObj.MgSecGrpCode
	.s ret=mgGrp
	q ret
}

/// 
/// ClassMethod Description:获取HIS安全组对应页面的元素
/// Date:2015-02-07
/// params:ssGrpId--HIS安全组id mouldId--模块id menucode--菜单代码
ClassMethod getPageElement(ssGrpId, menucode) As %String
{
	s ^TEMP("g201502090944001")=ssGrpId_"%"_menucode
	s ret=""
	s parr=..getMenuCodeId(menucode)
	s mouldId=$P(parr,"^",1)
	s JsId=$P(parr,"^",2)
	s rw="" f  s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssGrpId," "_mouldId,rw)) q:rw=""  d
	.s id="" f  s id=$O(^DHCMGNUR.GSSGRPLAYOUTSUBI("menu",JsId,rw,id)) q:id=""  d
	..s obj=##class(DHCMGNUR.GSSGRPLAYOUTSUB).%OpenId(rw_"||"_id)
	..;b ;01
	..s laysubitem=obj.laysubitem
	..i laysubitem'="" d
	...s itemElement=$E(laysubitem,2,$L(laysubitem))
	...s len=$L(itemElement,"^")
	...for i=1:1:len d
	....s a=##class(DHCMGNUR.MenuSystemSub).%OpenId($P(itemElement,"^",i))
	....s ItemCode=a.ItemCode
	....s ret=ret_ItemCode_"^"
	..s ret=$E(ret,1,$L(ret)-1)
	q ret
}

/// 
/// MethodDescription:获取护管安全组对应子页面控件元素
/// Date:2015-02-13
ClassMethod getPageSubElement(secGrp, EmrCode)
{
	s ret=""
	s ^TEMP("g201502131631001")=secGrp_"@"_EmrCode
	//"demo@DHCNURPerResearch"
	i secGrp'=""&& EmrCode'="" d
	.s secGrp=$ZConvert(secGrp,"U")
	.s EmrCode=$ZConvert(EmrCode,"U")
	.s secGrpId=$O(^DHCMGNUR.MgNurSecGrpI("SCode"," "_secGrp,""))
	.q:secGrpId=""
	.s EmrCodeId=$O(^DHCMGNUR.MgChildPagEleI("Code"," "_EmrCode,""))
	.q:EmrCodeId=""
	.s raw=$O(^DHCMGNUR.MgNurSecLayOutI("secGrp"," "_secGrpId," "_EmrCodeId,""))
	.i raw'="" d
	..s id=$O(^DHCMGNUR.MgNurSecLayOutSubI("menu",EmrCodeId,raw,""))
	..s obj=##class(DHCMGNUR.MgNurSecLayOutSub).%OpenId(raw_"||"_id)
	..s itemElement=obj.laysubitem
	..i itemElement'="" d
	...s itemElement=$E(itemElement,1,$L(itemElement))
	...s len=$L(itemElement,"^")
	...for i=1:1:len d
	....i $P(itemElement,"^",i)'="" d
	.....s a=##class(DHCMGNUR.MgChildPagEleSub).%OpenId($P(itemElement,"^",i))
	.....s ItemCode=a.ItemCode
	.....s ret=ret_ItemCode_"^"
	...s ret=$E(ret,1,$L(ret)-1)
	q ret
}

/// 
/// ClassMethod Descripition:通过js名字获取对应id
/// Date:2015-02-07
ClassMethod getMenuCodeId(menucode) As %String
{
	s menucode=$ZConvert(menucode,"U")
	s ret=""
	s id="" f  s id=$O(^DHCMGNUR.MenuSystemI("MenuCode"," "_menucode,id)) q:id=""  d
	.s obj=##class(DHCMGNUR.MenuSystem).%OpenId(id)
	.s Product=obj.NurProduct.%Id()
	.s ret=Product_"^"_id
	q ret
}

}
