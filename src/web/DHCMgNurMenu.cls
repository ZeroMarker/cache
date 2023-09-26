Class web.DHCMgNurMenu Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod getmould(ssgrp = "") As %String
{
  //s a=##class(web.DHCMgNurMenu).getmould()
  ;s ^TMP("g1212192501")=ssgrp
    s ret=""
    if ssgrp'=""
    {
      s mouldid="" f  s mouldid=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp,mouldid)) q:mouldid=""  d
       .s rw="" f  s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp,mouldid,rw)) q:rw=""  d
   	   ..s a=##class(DHCMGNUR.GSSGRPLAYOUT).%OpenId(rw)
   	   ..s m=##class(DHCMGNUR.Mould).%OpenId(a.laytitle)
   	   ..s code=m.Code
       ..if ret'="" s ret=ret_"^"
       ..s ret=ret_code_"|"_a.laytitle


    }else{
	    s mould=""  f  s mould=$O(^DHCMGNUR.MenuSystemI("Product",mould)) q:mould=""  d
	    .s a=##class(DHCMGNUR.Mould).%OpenId(mould)
	    .q:a=""
	    .s code=a.Code
	    .if ret'="" s ret=ret_"^"
	    .s ret=ret_code_"|"_mould
    }
   q ret
}

ClassMethod ifdsp(ssgrp, mouldid, menuid) As %String
{
       s flag=0
       s rw="" f  s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp," "_mouldid,rw)) q:(rw="")!(flag=1)  d
   	   .s a=##class(DHCMGNUR.GSSGRPLAYOUT).%OpenId(rw)
   	   .s m=##class(DHCMGNUR.Mould).%OpenId(a.laytitle)
   	   .s chl=""  f  s chl=$O(^DHCMGNUR.GSSGRPLAYOUTD(rw,"ChildSub",chl)) q:(chl="")!(flag=1)  d
   	   ..s bb=##class(DHCMGNUR.GSSGRPLAYOUTSUB).%OpenId(rw_"||"_chl)
   	   ..if (menuid'="")&(menuid=bb.laysubmoud.%Id()) s flag=1
   	   ..//s itms=bb.laysubitem
   	   ..//if (itms'="")&(itmid'="") d
   	   ..//.s flag=..compareitm(itms,itmid)
   q flag
}

ClassMethod compareitm(itms, it) As %String
{
    s l=$L(itms,"^")
    s flag=0
    f i=1:1:l
    {
	   s v=$P(itms,"^",i)
	   if (v=it) s flag=1
	   if flag=1 q
	}
	q flag
}

ClassMethod OnPage() As %Status
{
	//i $D(%session) s Loc=$G(%session.Data("LOGON.CTLOCID"))
	s mould=%request.Data("mouldid",1)
	s SSGRP=$G(%request.Data("SSGRP",1))
	//s ^TMP("SSGRP")=SSGRP
	//s Loc=%request.Data("Loc",1)
	//s LayGrp=%request.Data("LayGrp",1)
	//s SSGRP=218
	if mould=""  Quit $$$OK
	w "["
	s flag=0
	s dsp=1
	s temp="",maxorder=1000
    s rw=""  f  s rw=$O(^DHCMGNUR.MenuSystemI("Product",mould,rw)) q:rw=""  d
    .if SSGRP'="" s dsp=..ifdsp(SSGRP,mould,rw)
    .//w !,flag
    .q:dsp=0
    .s a=##class(DHCMGNUR.MenuSystem).%OpenId(rw)
    .s title=a.MenuTitle
    .s code=a.MenuCode
    .s icon=a.MenuIcon
    .s link=a.MenuLink
    .s menupar=a.ParentMenuNod
    .q:menupar'=""
    .s component=a.MenuRelComponent
    .s sortno=a.MenuSort
    .i (sortno="")||($d(temp(sortno))) s sortno=maxorder,maxorder=maxorder+1
    .s temp(sortno)=title_"^"_code_"^"_icon_"^"_link_"^"_rw
    s order="" f  s order=$O(temp(order)) q:order=""  d
    .s title=$P(temp(order),"^",1)
    .s code=$P(temp(order),"^",2)
    .s icon=$P(temp(order),"^",3)
    .s link=$P(temp(order),"^",4)
    .s rw=$P(temp(order),"^",5)
    .if flag=1 w ","
    .w "{text:"""_title_""","
    .;w "id:'"_code_"',iconCls:'"_icon_"'"
    .w "id:'"_code_"',icon:'"_icon_"'"
    .//e  w "id:'"_component_"'"
    .if $D(^DHCMGNUR.MenuSystemI("parmenu"," "_rw)) d
    ..w ",children:"
    ..d ..PrintChild(rw,SSGRP,mould)
    ..w "}"
    .;e  w ",leaf:true,iconCls:'"_icon_"'}"
    .e  w ",leaf:true,icon:'"_icon_"'}"
    .s flag=1
	w "]"
	Quit $$$OK
}

ClassMethod OnPagebak() As %Status
{
	//i $D(%session) s Loc=$G(%session.Data("LOGON.CTLOCID"))
	s mould=%request.Data("mouldid",1)
	//w "{text:'"_$P(DepModel,"|",2)_"',id:'"_$P(DepModel,"|",1)_"',leaf:true}"
	//%request.Data(parameterName,1)
	if mould=""  Quit $$$OK
	w "["
	s flag=0
    s rw=""  f  s rw=$O(^DHCMGNUR.MenuSystemI("Product",mould,rw)) q:rw=""  d
    .s a=##class(DHCMGNUR.MenuSystem).%OpenId(rw)
    .s title=a.MenuTitle
    .s code=a.MenuCode
    .s icon=a.MenuIcon
    .s link=a.MenuLink
    .s menupar=a.ParentMenuNod
    .s component=a.MenuRelComponent
    .s sortno=a.MenuSort
    .if flag=1 w ","
    .w "{text:"""_title_""","
    .w "id:'"_code_"'"  //iconCls:'woman'
    .//e  w "id:'"_component_"'"
    .if (menupar'="") d
    ..w ",children:"
    ..d ..PrintChild(menupar)
    ..w "}"
    .e  w ",leaf:true,iconCls:'"_icon_"'}"
    .s flag=1
	w "]"
	Quit $$$OK
}

ClassMethod PrintChild(par, SSGRP, mould)
{
    w "["
    s flag=0
   	s dsp=1
   	s temp="",maxorder=1000
    s rw=""  f  s rw=$O(^DHCMGNUR.MenuSystemI("parmenu"," "_par,rw)) q:rw=""  d
    .s a=##class(DHCMGNUR.MenuSystem).%OpenId(rw)
    .if SSGRP'="" s dsp=..ifdsp(SSGRP,mould,rw)
    .//w !,flag
    .q:dsp=0

    .s title=a.MenuTitle
    .s code=a.MenuCode
    .s icon=a.MenuIcon
    .s link=a.MenuLink
    .s menupar=a.ParentMenuNod
    .s component=a.MenuRelComponent
    .s sortno=a.MenuSort
    .i (sortno="")||($d(temp(sortno))) s sortno=maxorder,maxorder=maxorder+1
    .s temp(sortno)=title_"^"_code_"^"_icon_"^"_link_"^"_rw
    s order="" f  s order=$O(temp(order)) q:order=""  d
    .s title=$P(temp(order),"^",1)
    .s code=$P(temp(order),"^",2)
    .s icon=$P(temp(order),"^",3)
    .s link=$P(temp(order),"^",4)
    .s rw=$P(temp(order),"^",5)
    .if flag=1 w ","
    .w "{text:"""_title_""","
    .//if link'="" w "id:'"_link_"'"
    .w "id:'"_code_"'"
    .w ",leaf:true,iconCls:'"_icon_"'}"
    .s flag=1

    w "]"
}

}
