Class DHCMGNUR.DHCMgMenuSSGRPSet Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
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
    .q:menupar'=""
    .s component=a.MenuRelComponent
    .s sortno=a.MenuSort
    .s nodid=""
    .//if link'="" s nodid=link
    .//if (nodid="") s nodid=component
    .if (nodid="") s nodid=code
    .if flag=1 w ","
    .w "{text:"""_title_""","
    .w "id:'"_nodid_"'"  //iconCls:'woman'
    .if $D(^DHCMGNUR.MenuSystemI("parmenu"," "_rw)) d
    ..w ",checked:false,children:"
    ..d ..PrintChild(rw)
    ..w "}"
    .e  d
    ..if $D(^DHCMGNUR.MenuSystemSubD(rw)) d
    ...w ",checked:false,children:"
    ...d ..PrintChildSub(rw)
    ...w "}"
    ..e  w ",checked:false,leaf:true,iconCls:'"_icon_"'}"
    .s flag=1
	w "]"
	Quit $$$OK
}

ClassMethod PrintChild(par)
{
   w "["
   s flag=0
   s rw=""  f  s rw=$O(^DHCMGNUR.MenuSystemI("parmenu"," "_par,rw)) q:rw=""  d
    .s a=##class(DHCMGNUR.MenuSystem).%OpenId(rw)
    .s title=a.MenuTitle
    .s code=a.MenuCode
    .s icon=a.MenuIcon
    .s link=a.MenuLink
    .s menupar=a.ParentMenuNod
    .s component=a.MenuRelComponent
    .s sortno=a.MenuSort
    .s nodid=""
    .//if link'="" s nodid=link
    .//if (nodid="") s nodid=component
    .if (nodid="") s nodid=code
    .if flag=1 w ","
    .w "{text:"""_title_""","
    .w "id:'"_nodid_"'"
    .if $D(^DHCMGNUR.MenuSystemSubD(rw)) d
    ..w ",checked:false,children:"
    ..d ..PrintChildSub(rw)
    ..w "}"
    .e  w ",checked:false,leaf:true,iconCls:'"_icon_"'}"
    .s flag=1

  w "]"
}

ClassMethod PrintChildSub(Par)
{
   w "["
   s flag=0
    s rw="" f  s rw=$O(^DHCMGNUR.MenuSystemSubD(Par,rw)) q:rw=""  d
 	.s a=##class(DHCMGNUR.MenuSystemSub).%OpenId(Par_"||"_rw)
 	.s b=##class(DHCMGNUR.MenuSystem).%OpenId(Par)
    .s itmcode=a.ItemCode
    .s itmdesc=a.ItemDesc
    .if flag=1 w ","
    .w "{text:"""_itmdesc_""","
    .w "id:'"_b.MenuCode_"^"_itmcode_"'"
    .w ",checked:false,leaf:true,iconCls:'icon'}"
    .s flag=1

  w "]"
}

}
