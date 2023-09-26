/// Creator:
/// Desctiptions:
/// Date:2017-06-21
Class web.NurMgSetComm Extends %RegisteredObject
{

/// creator:xbl
/// createdate:20170711
/// description:保存模块
/// input:parr
/// output:
/// other:d ##class(web.NurMgSetComm).SaveModule("")
ClassMethod SaveModule(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Set.MgModule).%OpenId(tmp("rw"))
	e  s obj=##class(DHCNMG.Set.MgModule).%New()
	s obj.ModuleCode=$g(tmp("ModuleCode"))
	s obj.ModuleDesc=$g(tmp("ModuleDesc"))
	i $g(tmp("ModuleMenuDR"))'="" d
	.s obj.ModuleMenuDR=##class(DHCNMG.Set.MgMenu).%OpenId(tmp("ModuleMenuDR"))
	e  s obj.ModuleMenuDR=""
	i $g(tmp("ModuleSort"))'="" s obj.ModuleSort=tmp("ModuleSort")
	e  s obj.ModuleSort=..GetMaxModuleSort()
	i $g(tmp("ModuleStDate"))'="" s obj.ModuleStDate=$zdh(tmp("ModuleStDate"),3)
	e  s obj.ModuleStDate=""
	i $g(tmp("ModuleEndDate"))'="" s obj.ModuleEndDate=$zdh(tmp("ModuleEndDate"),3)
	e  s obj.ModuleEndDate=""
	s obj.ModulePath=$g(tmp("ModulePath"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod IsExistModule(parr As %String) As %String
{
	q:parr="" 0
	k tmp
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s RowID=$o(^DHCNMG.Set.MgModuleI("Code"," "_$zcvt($tr($g(tmp("ModuleCode"))," ",""),"U"),""))
	s flag=0
	i id="" d
	.i RowID'="" s flag=-1
	e  d
	.i RowID'=id s flag=-1
	q flag
}

/// creator:xbl
/// createdate:20170724
/// description:获取模块
/// input:parr
/// output:
/// other:
ClassMethod GetModule(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^ModuleCode|"_obj.ModuleCode
	s ret=ret_"^ModuleDesc|"_obj.ModuleDesc
	i obj.ModuleMenuDR'="" d
	.s ret=ret_"^ModuleMenuDR|"_obj.ModuleMenuDR.%Id()
	.s ret=ret_"^MenuDesc|"_obj.ModuleMenuDR.MenuDesc
	s ret=ret_"^ModuleSort|"_obj.ModuleSort
	i obj.ModuleStDate'="" s ret=ret_"^ModuleStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ModuleStDate)
	i obj.ModuleEndDate'="" s ret=ret_"^ModuleEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ModuleEndDate)
	s ret=ret_"^ModulePath|"_obj.ModulePath
	q ret
}

/// creator:xbl
/// createdate:20170724
/// description:删除模块
/// input:id
/// ouput:
/// other:
ClassMethod DeleteModule(id As %String) As %String
{
	q:id="" ""
	s menu=$O(^DHCNMG.Set.MgMenuI("ModuleSort",id,""))
	q:menu'="" "该模块下有菜单，不可以删除！"
	s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20170724
/// description:获取模块最大显示顺序
/// input:id
/// ouput:
/// other: w ##class(web.NurMgSetComm).GetMaxSort()
ClassMethod GetMaxModuleSort() As %Integer
{
	s order=1
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.i sort>order d 
	.s order=sort
	q order+1
}

/// creator:xbl
/// createdate:20170724
/// description:查询模块列表
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindModuleList","")
Query FindModuleList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindModuleListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code=$P(parr,"^",1)
	s desc=$P(parr,"^",2)
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d 
	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	..s modulecode=obj.ModuleCode
	..q:(code'="")&&($zcvt(modulecode,"U")'[$zcvt(code,"U"))
	..s moduledesc=obj.ModuleDesc
	..q:(desc'="")&&($zcvt(moduledesc,"U")'[$zcvt(desc,"U"))
	..s ret=..GetModule(id)
	..d OutModule
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutModule
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindModuleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindModuleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindModuleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindModuleListExecute ]
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

/// creator:xbl
/// createdate:20170711
/// description:保存菜单
/// input:parr
/// output:
/// other:d ##class(web.NurMgSetComm).SaveMenu("")
ClassMethod SaveMenu(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Set.MgMenu).%OpenId(tmp("rw"))
	e  s obj=##class(DHCNMG.Set.MgMenu).%New()
	s obj.MenuCode=$g(tmp("MenuCode"))
	s obj.MenuDesc=$g(tmp("MenuDesc"))
	i $g(tmp("MenuModuleDR"))'="" d
	.s obj.MenuModuleDR=##class(DHCNMG.Set.MgModule).%OpenId(tmp("MenuModuleDR"))
	.s obj.MenuSort=..GetMaxMenuSort(tmp("MenuModuleDR"))
	e  s obj.MenuModuleDR=""
	s obj.MenuComponent=$g(tmp("MenuComponent"))
	s obj.MenuRouter=$g(tmp("MenuRouter"))
	i $g(tmp("MenuParentDR"))'="" d
	.s obj.MenuParentDR=##class(DHCNMG.Set.MgMenu).%OpenId(tmp("MenuParentDR"))
	e  s obj.MenuParentDR=""
	s obj.MenuComponent=$g(tmp("MenuComponent"))
	s obj.MenuRouter=$g(tmp("MenuRouter"))
	s obj.MenuLink=$g(tmp("MenuLink"))
	s obj.MenuParams=$g(tmp("MenuParams"))
	s obj.MenuIcon=$g(tmp("MenuIcon"))
	i $g(tmp("MenuSort"))'="" s obj.MenuSort=$g(tmp("MenuSort"))
	i $g(tmp("MenuStDate"))'="" s obj.MenuStDate=$zdh($g(tmp("MenuStDate")),3)
	e  s obj.MenuStDate=""
	i $g(tmp("MenuEndDate"))'="" s obj.MenuEndDate=$zdh($g(tmp("MenuEndDate")),3)
	e  s obj.MenuEndDate=""
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

ClassMethod IsExistMenu(parr As %String) As %String
{
	q:parr="" 0
	k tmp
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s RowID=$o(^DHCNMG.Set.MgMenuI("Code"," "_$zcvt($tr($g(tmp("MenuCode"))," ",""),"U"),""))
	s flag=0
	i id="" d
	.i RowID'="" s flag=-1
	e  d
	.i RowID'=id s flag=-1
	q flag
}

/// creator:xbl
/// createdate:20170711
/// description:查询菜单列表
/// input:id
/// output:
/// other:w ##class(web.NurMgSetComm).GetMenu(2)
ClassMethod GetMenu(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgMenu).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^MenuCode|"_obj.MenuCode
	s ret=ret_"^MenuDesc|"_obj.MenuDesc
	i obj.MenuModuleDR'="" d
	.s ret=ret_"^MenuModuleDR|"_obj.MenuModuleDR.%Id()
	.s ret=ret_"^ModuleDesc|"_obj.MenuModuleDR.ModuleDesc
	i obj.MenuParentDR'="" d
	.s ret=ret_"^MenuParentDR|"_obj.MenuParentDR.%Id()
	.s ret=ret_"^ParentDesc|"_obj.MenuParentDR.MenuDesc
	s ret=ret_"^MenuComponent|"_obj.MenuComponent
	s ret=ret_"^MenuRouter|"_obj.MenuRouter
	s ret=ret_"^MenuLink|"_obj.MenuLink
	s ret=ret_"^MenuParams|"_obj.MenuParams
	s ret=ret_"^MenuIcon|"_obj.MenuIcon
	s ret=ret_"^MenuSort|"_obj.MenuSort
	s ret=ret_"^MenuStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.MenuStDate)
	s ret=ret_"^MenuEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.MenuEndDate)
	q ret
}

/// creator:xbl
/// createdate:20170711
/// description:删除菜单
/// input:parr
/// output:
/// other:d ##class(web.NurMgSetComm).DeleteMenu(id)
ClassMethod DeleteMenu(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgMenu).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20170711
/// description:获取菜单最大显示顺序
/// input:parr
/// output:
/// other:d ##class(web.NurMgSetComm).GetMaxMenuSort(9)
ClassMethod GetMaxMenuSort(module As %String) As %String
{
	;s ^tmpXBL("MenuSort")=module
	q:module="" ""
	s order=0
	s sort="" f  s sort=$O(^DHCNMG.Set.MgMenuI("ModuleSort",module,sort)) q:sort=""  d
	.i sort>order s order=sort
	q order+1
}

/// creator:xbl
/// createdate:20170711
/// description:查询菜单列表
/// input:parr
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindMenuList","^^9")
Query FindMenuList(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMenuListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code=$P(parr,"^",1)
	s desc=$P(parr,"^",2)
	s module=$P(parr,"^",3)
	s sort1="" f  s sort1=$O(^DHCNMG.Set.MgModuleI("Sort",sort1)) q:sort1=""  d
	.s moduledr="" f  s moduledr=$O(^DHCNMG.Set.MgModuleI("Sort",sort1,moduledr)) q:moduledr=""  d
	..q:(module'="")&&(module'=moduledr)
	..s sort2="" f  s sort2=$O(^DHCNMG.Set.MgMenuI("ModuleSort",moduledr,sort2)) q:sort2=""  d
	...s id="" f  s id=$O(^DHCNMG.Set.MgMenuI("ModuleSort",moduledr,sort2,id)) q:id=""  d
	....s obj=##class(DHCNMG.Set.MgMenu).%OpenId(id)
	....s menucode=obj.MenuCode
	....q:(code'="")&&($zcvt(menucode,"U")'[$zcvt(code,"U"))
	....s menudesc=obj.MenuDesc
	....q:(desc'="")&&($zcvt(menudesc,"U")'[$zcvt(desc,"U"))
	....s ret=..GetMenu(id)
	....d OutMenu
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMenu
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMenuListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMenuListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuListExecute ]
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

/// w ##class(web.NurMgSetComm).GetMenuItem()
ClassMethod GetMenuItem()
{
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))!((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..i ret'="" s ret=ret_",",active="false"
	..e  s active="true"
	..s title=obj.ModuleDesc,Code=obj.ModuleCode
	..s ret=ret_"{""label"":"""_title_""",""code"":"""_Code_""",""active"":"_active_",""id"":"""_id_""""
	..s ret1=..GetMenuSub("ModuleSort",id)
	..i ret1'="" s ret=ret_",""children"":"_ret1
	..s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
}

/// w ##class(web.NurMgSetComm).GetMenuItemNew()
ClassMethod GetMenuItemNew()
{
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))!((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..i ret'="" s ret=ret_",",active="false"
	..e  s active="true"
	..s title=obj.ModuleDesc,Code=obj.ModuleCode
	..s ret=ret_"{""label"":"""_title_""",""code"":"""_Code_""",""active"":"_active_",""id"":"""_id_""""
	..s ret1=..GetMenuSub("ModuleSort",id)
	..i ret1'="" s ret=ret_",""children"":"_ret1
	..s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
}

/// w ##class(web.NurMgSetComm).GetMenuSub("ModuleSort",1)
ClassMethod GetMenuSub(index As %String, parid As %String) As %String
{
	q:(index="")!(parid="") ""
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgMenuI(index,parid,sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgMenuI(index,parid,sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgMenu).%OpenId(id)
	..q:((obj.MenuStDate'="")&&(obj.MenuStDate>+$h))!((obj.MenuEndDate'="")&&(obj.MenuEndDate<+$h))
	..q:(obj.MenuParentDR'="")
	..i ret'="" s ret=ret_",",active="false"
	..e  s active="true"
	..i (index="ModuleSort")&&(obj.MenuModuleDR.ModuleMenuDR'="") d
	...i obj.MenuModuleDR.ModuleMenuDR.%Id()=id s active="true"
	...e  s active="false"
	..s title=obj.MenuDesc,code=obj.MenuCode,route=obj.MenuRouter,icon=obj.MenuIcon,params=obj.MenuParams
	..s ret=ret_"{""label"":"""_title_""",""code"":"""_code_""",""route"":"""_route_""",""active"":"_active_",""id"":"""_parid_"-"_id_""",""icon"":"""_icon_""",""params"":"""_params_""""
	..s ret1=..GetMenuSub("ParentSort",id)
	..i ret1'="" s ret=ret_",""children"":"_ret1
	..s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

/// 
/// Creator:gzj
/// Description:根据角色获取对应的菜单
/// Date:2017-11-21
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetRoleMenuItem1(role As %String) As %String
{
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))!((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..s title=obj.ModuleDesc,Code=obj.ModuleCode
	..;i ret'="" s ret=ret_",",active="false"
	..;e  s active="true"
	..s flag=..GetRoleMenuFlag(role,id)
	..s flag2=..IsHasChild(role,id)
	..i $P(flag,"^",1)=1 d
	...i flag2=1 d
	....i ret'="" s ret=ret_",",active="false"
	....e  s active="true"
	....s ret=ret_"{""label"":"""_title_""",""code"":"""_Code_""",""active"":"_active_",""id"":"""_id_""""
	....i $p(flag,"^",2)'="" d
	.....s substr=..GetRoleMenuSub("ModuleSort",id,$p(flag,"^",2))
	.....i substr'="" s ret=ret_",""children"":"_substr
	.....s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
}

/// Creator:gzj
/// Description:获取登录人所有角色对应的菜单
/// Date:2018-07-02
ClassMethod GetAllRoleMenuItems(roles) As %String
{
	//nurhead^teacher
#;	s len=$l(roles,"^")
#;	s ret=""
#;	s tmp=""
#;	f i=1:1:len
#;	{
#;		s role=$p(roles,"^",i)
#;		i role="" continue
#;		s mouldid="" f  s mouldid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,mouldid)) q:mouldid=""  d
#;		.s rowid="" f  s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,mouldid,rowid)) q:rowid=""  d
#;		..s menu="" f  s menu=$O(^DHCNMG.Set.MgLimitSetSubI("Menu",rowid,menu)) q:menu=""  d
#;		...s tmp($tr(mouldid," ",""),$tr(menu," ",""))=$tr(mouldid," ","")_"^"_$tr(menu," ","")
#;	} //tmp(1,"1-3")="1^1-3" //tmp(8,"8-20")="8^8-20"
#;	s mouldnum=0
#;	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
#;	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
#;	..q:$d(tmp(id))=0
#;	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
#;	..q:'$IsObject(obj)
#;	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))!((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
#;	..s title=obj.ModuleDesc,Code=obj.ModuleCode
#;	..i mouldnum=0 s ret="{""label"":"""_title_""",""code"":"""_Code_""",""actived"":""false"",""id"":"""_id_""""
#;	..e  s ret=ret_",{""label"":"""_title_""",""code"":"""_Code_""",""actived"":""false"",""id"":"""_id_""""
#;	..s childmax=0
#;	..s msort="" f  s msort=$O(tmp(id,msort)) q:msort=""  d
#;	...s childmax=childmax+1
#;	..s childnum=0
#;	..s ret=ret_",""children"":["
#;	..s menusort="" f  s menusort=$O(^DHCNMG.Set.MgMenuI("ModuleSort",id,menusort)) q:menusort=""  d
#;	...s menuid="" f  s menuid=$O(^DHCNMG.Set.MgMenuI("ModuleSort",id,menusort,menuid)) q:menuid=""  d
#;	....s menuobj=##class(DHCNMG.Set.MgMenu).%OpenId(menuid)
#;	....s parid=id_"-"_menuid
#;	....q:$d(tmp(id,parid))=0
#;	....s menutitle=menuobj.MenuDesc,menucode=menuobj.MenuCode,menuroute=menuobj.MenuRouter,menuicon=menuobj.MenuIcon,menuparams=menuobj.MenuParams
#;	....i childnum=0 s ret=ret_"{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":""false"_""",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_"""}"
#;	....e  i childnum<=childmax s ret=ret_",{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":""false"_""",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_"""}"
#;	....s childnum=childnum+1
#;	..s ret=ret_"]"
#;	..s mouldnum=mouldnum+1
#;	..s ret=ret_"}"
#;	s ret="["_ret_"]"
#;	q ret
	s len=$l(roles,"^")
	s ret=""
	s tmp=""
	f i=1:1:len
	{
		s role=$p(roles,"^",i)
		i role="" continue
		s mouldid="" f  s mouldid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,mouldid)) q:mouldid=""  d
		.s rowid="" f  s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,mouldid,rowid)) q:rowid=""  d
		..s menu="" f  s menu=$O(^DHCNMG.Set.MgLimitSetSubI("Menu",rowid,menu)) q:menu=""  d
		...s tmp($tr(mouldid," ",""),$tr(menu," ",""))=$tr(mouldid," ","")_"^"_$tr(menu," ","")
	} //tmp(1,"1-3")="1^1-3" //tmp(8,"8-20")="8^8-20"
	w "["
	s mouldnum=0
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..q:$d(tmp(id))=0
	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))!((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..s title=obj.ModuleDesc,Code=obj.ModuleCode
	..i mouldnum=0 w "{""label"":"""_title_""",""code"":"""_Code_""",""active"":true,""id"":"""_id_""""
	..e  w ",{""label"":"""_title_""",""code"":"""_Code_""",""active"":false,""id"":"""_id_""""
	..s childmax=0
	..s msort="" f  s msort=$O(tmp(id,msort)) q:msort=""  d
	...s childmax=childmax+1
	..s childnum=0
	..w ",""children"":["
	..s menusort="" f  s menusort=$O(^DHCNMG.Set.MgMenuI("ModuleSort",id,menusort)) q:menusort=""  d
	...s menuid="" f  s menuid=$O(^DHCNMG.Set.MgMenuI("ModuleSort",id,menusort,menuid)) q:menuid=""  d
	....s menuobj=##class(DHCNMG.Set.MgMenu).%OpenId(menuid)
	....q:'$IsObject(menuobj)
	....q:((menuobj.MenuStDate'="")&&(menuobj.MenuStDate>+$h))!((menuobj.MenuEndDate'="")&&(menuobj.MenuEndDate<+$h))
	....q:menuobj.MenuParentDR'=""
	....s parid=id_"-"_menuid
	....q:$d(tmp(id,parid))=0
	....s menutitle=menuobj.MenuDesc,menucode=menuobj.MenuCode,menuroute=menuobj.MenuRouter,menuicon=menuobj.MenuIcon,menuparams=menuobj.MenuParams
	....i childnum=0 w "{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":true"_",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_"""}"
	....e  i childnum<=childmax w ",{""label"":"""_menutitle_""",""code"":"""_menucode_""",""route"":"""_menuroute_""",""active"":false"_",""id"":"""_parid_""",""icon"":"""_menuicon_""",""params"":"""_menuparams_"""}"
	....s childnum=childnum+1
	..w "]"
	..s mouldnum=mouldnum+1
	..w "}"
	w "]"
	q ""
}

ClassMethod IsHasChild(role As %String, id As %String) As %String
{
	s ret=0
	s rw=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role," "_id,""))
	i rw'="" d
	.s rowid=$O(^DHCNMG.Set.MgLimitSetSubI("Sort",rw,""))
	.i rowid'="" s ret=1
	q ret
}

ClassMethod GetRoleMenuFlag(role As %String, id As %String) As %String
{
	s ret=0
	s rw=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role," "_id,""))
	i rw'="" s ret=1
	e  s ret=0
	q ret_"^"_rw
}

/// Creator:gzj
/// Description:根据角色获取对应的菜单
/// Date:2017-11-21
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetRoleMenuSub(index As %String, parid As %String, par As %String) As %String
{
	q:(index="")!(parid="") ""
	s ret=""
	s substr=..GetRoleMenuSubFlag(par)
	s sort="" f  s sort=$O(^DHCNMG.Set.MgMenuI(index,parid,sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgMenuI(index,parid,sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgMenu).%OpenId(id)
	..q:((obj.MenuStDate'="")&&(obj.MenuStDate>+$h))!((obj.MenuEndDate'="")&&(obj.MenuEndDate<+$h))
	..s flag=parid_"-"_id
	..q:(substr'[flag)
	..q:(obj.MenuParentDR'="")
	..i ret'="" s ret=ret_",",active="false"
	..e  s active="true"
	..i (index="ModuleSort")&&(obj.MenuModuleDR.ModuleMenuDR'="") d
	...i obj.MenuModuleDR.ModuleMenuDR.%Id()=id s active="true"
	...e  s active="false"
	..s title=obj.MenuDesc,code=obj.MenuCode,route=obj.MenuRouter,icon=obj.MenuIcon,params=obj.MenuParams
	..s ret=ret_"{""label"":"""_title_""",""code"":"""_code_""",""route"":"""_route_""",""active"":"_active_",""id"":"""_parid_"-"_id_""",""icon"":"""_icon_""",""params"":"""_params_""""
	..s ret1=..GetRoleMenuSub("ParentSort",id,par)
	..i ret1'="" s ret=ret_",""children"":"_ret1
	..s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

ClassMethod GetRoleMenuSubFlag(par As %String) As %String
{
	s ret=""
	s rowid="" f  s rowid=$O(^DHCNMG.Set.MgLimitSetSubI("Sort",par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(par_"||"_rowid)
	.s ret=ret_"^"_obj.MenuID
	q ret
}

/// creator:xbl
/// createdate:20170727
/// description:获取路由
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindRouter")
Query FindRouter() As %Query(ROWSPEC = "path:%String,name:%String,component:%String,code:%String")
{
}

ClassMethod FindRouterExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id="" f  s id=$O(^DHCNMG.Set.MgMenuD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Set.MgMenu).%OpenId(id)
	.s name=obj.MenuDesc
	.s code=obj.MenuCode
	.s path=obj.MenuRouter
	.s component=obj.MenuModuleDR.ModulePath_"/"_obj.MenuComponent
	.d OutRouter
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRouter
	set Data=$lb(path,name,component,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRouterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRouterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRouterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRouterExecute ]
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

/// creator:xbl
/// createdate:20170711
/// description:保存用户角色
/// input:parr
/// output:
/// other:d ##class(web.NurMgSetComm).SaveRole("")
ClassMethod SaveRole(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistRole(parr)
	q:flag=-1 "此记录已经存在，保存失败"
	i $g(tmp("rw"))'="" s obj=##class(DHCNMG.Set.MgRoles).%OpenId(tmp("rw"))
	e  s obj=##class(DHCNMG.Set.MgRoles).%New()
	s obj.RoleCode=$g(tmp("RoleCode"))
	s obj.RoleDesc=$g(tmp("RoleDesc"))
	s obj.RoleRemark=$g(tmp("RoleRemark"))
	s obj.RoleStatus=$g(tmp("RoleStatus"))
	s obj.RoleLevel=$g(tmp("RoleLevel"))
	s obj.RoleSort=$g(tmp("RoleSort"))
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

ClassMethod IsExistRole(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s id=$o(^DHCNMG.Set.MgRolesI("code"," Y"," "_$zcvt($tr($g(tmp("RoleCode"))," ",""),"U"),""))
	i rw="" d
	.i id'="" s flag=-1
	e  d
	.i ((id'="")&&(id'=rw)) s flag=-1
	q flag
}

/// Creator:gzj
/// Description:获取角色序号
/// Date:2018-07-03
/// Table:DHCNMG.Set.MgRoles
/// Input:
/// Output：
/// Return:
ClassMethod ComRoleSort() As %String
{
	s n=1
	s sort="" f  s sort=$O(^DHCNMG.Set.MgRolesI("Sort",sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^DHCNMG.Set.MgRolesI("Sort",sort,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.Set.MgRoles).%OpenId(rw)
	..i obj.RoleSort'="" s n=n+1
	q n
}

ClassMethod SetRoleSort(rowid As %String, type As %String) As %String
{
	q:rowid="" ""
	s ret=0
	s obj=##class(DHCNMG.Set.MgRoles).%OpenId(rowid)
	s sort=obj.RoleSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.RoleSort=sort-1
		.s row=$O(^DHCNMG.Set.MgRolesI("Sort",sort-1,""))
		.s bobj=##class(DHCNMG.Set.MgRoles).%OpenId(row)
		.s bobj.RoleSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^DHCNMG.Set.MgRolesI("Sort",""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.RoleSort=sort+1
		.s row=$O(^DHCNMG.Set.MgRolesI("Sort",sort+1,""))
		.s bobj=##class(DHCNMG.Set.MgRoles).%OpenId(row)
		.s bobj.RoleSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// creator:xbl
/// date:20170801
/// desc:获取用户角色
/// input:
/// output:
/// other: w ##class(web.NurMgSetComm).GetRole("")
ClassMethod GetRole(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgRoles).%OpenId(id)
	q:'$IsObject(obj)
	s ret="rw|"_id
	s ret=ret_"^RoleCode|"_obj.RoleCode
	s ret=ret_"^RoleDesc|"_obj.RoleDesc
	;s ret=ret_"^RoleLevel|"_$case(obj.RoleLevel,"1":"一级","2":"二级","3":"三级","4":"四级","5":"五级","6":"六级","7":"七级","8":"八级","9":"九级","10":"十级",:"")
	s ret=ret_"^RoleLevel|"_obj.RoleLevel
	s ret=ret_"^RoleRemark|"_obj.RoleRemark
	s ret=ret_"^RoleStatus|"_obj.RoleStatus
	s ret=ret_"^StatusDesc|"_$Case(obj.RoleStatus,"Y":"启用","N":"停用",:"")
	q ret
}

/// creator:xbl
/// date:20170801
/// desc:删除用户角色
/// input:
/// output:
/// other: w ##class(web.NurMgSetComm).DeleteRole("")
ClassMethod DeleteRole(id As %String) As %String
{
	q:id="" ""
	s sort=0
	s obj=##class(DHCNMG.Set.MgRoles).%OpenId(id)
	s sort=obj.RoleSort
	s sc=obj.%DeleteId(id)
	s roleid="" f  s roleid=$O(^DHCNMG.Set.MgRolesI("Sort",sort+1,roleid)) q:roleid=""  d
	.s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
	.s RoleObj.RoleSort=sort
	.s sort=sort+1
	.d RoleObj.%Save()
	q $$$ISOK(sc)
}

/// creator:xbl
/// date:20170801
/// desc:获取角色列表
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindRoleList","")
Query FindRoleList(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s sort="" f  s sort=$O(^DHCNMG.Set.MgRolesI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgRolesI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgRoles).%OpenId(id)
	..s code=obj.RoleCode
	..s desc=obj.RoleDesc
	..s ret=..GetRole(id)
	..d OutRole
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRole
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleListExecute ]
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

/// creator:xbl
/// date:20170809
/// desc:保存系统参数
/// table:DHCNMG.Set.MgSystemParam
/// input:
/// output:
/// other: w ##class(web.NurMgSetComm).SaveParam("ParamCode|WardType^ParamDesc|科室类型^ParamRemark|^ParamStatus|Y")
ClassMethod SaveParam(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Set.MgSysParam).%OpenId(tmp("rw"))
	e  s obj=##class(DHCNMG.Set.MgSysParam).%New()
	s obj.ParamCode=$g(tmp("ParamCode"))
	s obj.ParamDesc=$g(tmp("ParamDesc"))
	s obj.ParamRemark=$g(tmp("ParamRemark"))
	s obj.ParamStatus=$g(tmp("ParamStatus"))
	i $g(tmp("ParamLink"))'="" d
	.s obj.ParamLink=##class(DHCNMG.Set.MgSysParamSub).%OpenId(tmp("ParamLink"))
	e  s obj.ParamLink=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Date:2020-03-17
/// Description:判断记录是否存在
/// Table:
/// Input:
/// Output:
ClassMethod IsExistParam(parr As %String) As %String
{
	//ParamCode|AssessType^ParamDesc|360评估维度^ParamRemark|^ParamStatus|Y^rw|^
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	//tmp("ParamCode")="AssessType"
	//tmp("ParamDesc")="360评估维度"
	//tmp("ParamRemark")=""
	//tmp("ParamStatus")="Y"
	//tmp("rw")=""
	s id=$g(tmp("rw"))
	s RowID=$o(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr($g(tmp("ParamCode"))," ",""),"U"),""))
	s flag=0
	i id="" d
	.i RowID'="" s flag=-1
	e  d
	.i RowID'=id s flag=-1
	
	q flag
}

/// creator:xbl
/// date:20170809
/// desc:获取系统参数
/// table:DHCNMG.Set.MgSystemParam
/// input:
/// output:
/// other:
ClassMethod GetParam(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgSysParam).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^ParamCode|"_obj.ParamCode
	s ret=ret_"^ParamDesc|"_obj.ParamDesc
	s ret=ret_"^ParamRemark|"_obj.ParamRemark
	s ret=ret_"^ParamStatus|"_obj.ParamStatus
	i obj.ParamLink'="" d
	.s ret=ret_"^ParamLink|"_$P(obj.ParamLink.%Id(),"||",1)_","_$tr(obj.ParamLink.%Id(),"||","__")
	.s ret=ret_"^LinkDesc|"_obj.ParamLink.Parref.ParamDesc_"/"_obj.ParamLink.SubDesc
	s ret=ret_"^StatusDesc|"_$case(obj.ParamStatus,"Y":"启用","N":"停用",:"")
	q ret
}

/// creator:xbl
/// date:20170809
/// desc:删除系统参数
/// table:DHCNMG.Set.MgSystemParam
/// input:
/// output:
/// other:
ClassMethod DeleteParam(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgSysParam).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator:xbl
/// date:20170809
/// desc:获取系统参数列表
/// input:
/// output:
/// other:
Query FindParamList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindParamListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id="" f  s id=$O(^DHCNMG.Set.MgSysParamD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Set.MgSysParam).%OpenId(id)
	.s code=obj.ParamCode
	.s desc=obj.ParamDesc
	.s ret=..GetParam(id)
	.d OutParamList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutParamList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindParamListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindParamListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindParamListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindParamListExecute ]
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

/// creator:xbl
/// createdate:20170814
/// description:系统参数明细
/// table:DHCNMG.Set.MgSysParamSub
/// input:
/// output:
/// other: w ##class(web.NurMgSetComm).SaveParamSub("SubCode|W^SubDesc|病区^SubValue|^SubSymbol|^SubColor|#B43535^SubRemark|^SubStDate|2017-08-14^SubEndDate|^rw|^^parid|1")
ClassMethod SaveParamSub(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:$g(tmp("parid"))=""
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Set.MgSysParamSub).%New()
	.s obj.Parref=##class(DHCNMG.Set.MgSysParam).%OpenId(tmp("parid"))
	s obj.SubCode=$g(tmp("SubCode"))
	s obj.SubDesc=$g(tmp("SubDesc"))
	s obj.SubValue=$g(tmp("SubValue"))
	s obj.SubSymbol=$g(tmp("SubSymbol"))
	s obj.SubColor=$g(tmp("SubColor"))
	s obj.SubRemark=$g(tmp("SubRemark"))
	s obj.SubSort=$g(tmp("SubSort"))
	i $g(tmp("SubStDate"))'="" s obj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s obj.SubStDate=""
	i $g(tmp("SubEndDate"))'="" s obj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s obj.SubEndDate=""
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20170814
/// description:系统参数明细
/// table:DHCNMG.Set.MgSysParamSub
/// input:
/// output:
/// other:
ClassMethod GetParamSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^parid|"_obj.Parref.%Id()
	s ret=ret_"^ParamDesc|"_obj.Parref.ParamDesc
	s ret=ret_"^SubCode|"_obj.SubCode
	s ret=ret_"^SubDesc|"_obj.SubDesc
	s ret=ret_"^SubValue|"_obj.SubValue
	s ret=ret_"^SubSymbol|"_obj.SubSymbol
	s ret=ret_"^SubColor|"_obj.SubColor
	s ret=ret_"^SubRemark|"_obj.SubRemark
	s ret=ret_"^SubStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)
	s ret=ret_"^SubEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)
	s ret=ret_"^SubSort|"_obj.SubSort
	q ret
}

/// creator:xbl
/// createdate:20170814
/// description:系统参数明细
/// table:DHCNMG.Set.MgSysParamSub
/// input:
/// output:
/// other:
ClassMethod GetParamSubByCode(parcode As %String, subcode As %String, itm As %String) As %String
{
	q:(parcode="")!(subcode="")!(itm="") ""
	s parid=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt(parcode,"U"),""))
	q:parid="" ""
	s subid=$O(^DHCNMG.Set.MgSysParamSubI("Code"," "_$zcvt(subcode,"U"),parid,""))
	q:subid=""
	s id=parid_"||"_subid
	s ret=..GetParamSub(id)
	d ##class(web.NurMgVueComm).SplitStr(ret,"^","|",.tmp)
	s val=$g(tmp(itm))
	q val
}

/// creator:xbl
/// createdate:20170814
/// description:系统参数明细
/// table:DHCNMG.Set.MgSysParamSub
/// input:
/// output:
/// other:
ClassMethod DeleteParamSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20170814
/// description:系统参数明细
/// table:DHCNMG.Set.MgSysParamSub
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindParamSubList","^QUALTYPE^QUAL")
Query FindParamSubList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindParamSubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	s parcode=$P(parr,"^",2)
	s type=$p(parr,"^",3)
	i parid="" s parid=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt(parcode,"U"),""))
	s par="" f  s par=$O(^DHCNMG.Set.MgSysParamSubD(par)) q:par=""  d
	.q:((parid="")||((parid'="")&&(parid'=par)))
	.s child="" f  s child=$O(^DHCNMG.Set.MgSysParamSubD(par,child)) q:child=""  d
	..s id=par_"||"_child
	..s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(id)
	..s code=obj.SubCode
	..s desc=obj.SubDesc
	..s ZCODE=$ZCVT(code,"U")
	..q:((parcode="QUALTYPE")&&(type="QUAL")&&((ZCODE="NIGHTCHECK")!(ZCODE="WEEKCHECK")!(ZCODE="HOLIDAYCHECK")))
	..s ret=..GetParamSub(id)
	..d OutParamSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutParamSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindParamSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindParamSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindParamSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindParamSubListExecute ]
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

/// creator:gzj
/// createdate:20180628
/// description:系统参数子表明细
/// table:DHCNMG.Set.MgSysParamSub
/// input:
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindSetParSubList","^WardType")
Query FindSetParSubList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSetParSubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	s parcode=$P(parr,"^",2)
	
	i parid="" s parid=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt(parcode,"U"),""))
	s par=parid
	q:(parid'="")&&(parid'=par)
	s sort="" f  s sort=$O(^DHCNMG.Set.MgSysParamSubI("Sort",par,sort)) q:sort=""  d
	.;s par="" f  s par=$O(^DHCNMG.Set.MgSysParamSubI("Sort",sort,par)) q:par=""  d
	.s raw="" f  s raw=$O(^DHCNMG.Set.MgSysParamSubI("Sort",par,sort,raw)) q:raw=""  d
	..s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(par_"||"_raw)
	..s ret=..GetParamSub(par_"||"_raw)
	..d OutSetParamSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSetParamSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSetParSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSetParSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSetParSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSetParSubListExecute ]
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

/// creator:xbl
/// createdate:20170823
/// description:保存排班参数设置
/// table:DHCNMG.Set.MgArgParamSet
/// input:
/// output:
/// other:w ##class(web.NurMgSetComm).SaveArgParam("ArgPeriod|Week^ArgCountUnit|Hour^ArgCrossDay|N^NightStTime1|08:00^NightEndTime1|18:00^DayHour1|8^AMHour1|4^PMHour1|4^NightStTime2|07:30^NightEndTime2|17:30^DayHour2|8^AMHour2|4^PMHour2|4^")
ClassMethod SaveArgParam(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $d(^DHCNMG.Set.MgArgParamSetD(1)) d
	.s obj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	e  s obj=##class(DHCNMG.Set.MgArgParamSet).%New()
	s obj.ArgPeriod=$g(tmp("ArgPeriod"))
#;	s obj.ArgCountUnit=$g(tmp("ArgCountUnit"))
#;	s obj.ArgCrossDay=$g(tmp("ArgCrossDay"))
	i $g(tmp("NightStTime1"))'="" s obj.NightStTime1=$zth(tmp("NightStTime1"),1)
	e  s obj.NightStTime1=""
	i $g(tmp("NightEndTime1"))'="" s obj.NightEndTime1=$zth(tmp("NightEndTime1"),1)
	e  s obj.NightEndTime1=""
	s obj.NightEndTime2=obj.NightEndTime1
	s obj.NightStTime2=obj.NightStTime1
#;	s obj.DayHour1=$g(tmp("DayHour1"))
#;	s obj.AMHour1=$g(tmp("AMHour1"))
#;	s obj.PMHour1=$g(tmp("PMHour1"))
#;	i $g(tmp("NightStTime2"))'="" s obj.NightStTime2=$zth(tmp("NightStTime2"),1)
#;	e  s obj.NightStTime2=""
#;	i $g(tmp("NightEndTime2"))'="" s obj.NightEndTime2=$zth(tmp("NightEndTime2"),1)
#;	e  s obj.NightEndTime2=""
#;	s obj.DayHour2=$g(tmp("DayHour2"))
#;	s obj.AMHour2=$g(tmp("AMHour2"))
#;	s obj.PMHour2=$g(tmp("PMHour2"))
	s obj.ArgUpdateDay=$g(tmp("ArgUpdateDay"))
	s obj.BedBR=$g(tmp("BedBR"))
	s obj.ArgStandardTime=$g(tmp("ArgStandardTime"))
	s obj.ArgTimeSlot=$g(tmp("ArgTimeSlot"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20170823
/// description:获取排班参数信息
/// table:DHCNMG.Set.MgArgParamSet
/// input:
/// output:
/// other: w ##class(web.NurMgSetComm).GetArgParam("1")
ClassMethod GetArgParam(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret="rw|"_id
	s ret=ret_"^ArgPeriod|"_obj.ArgPeriod
	s ret=ret_"^ArgCountUnit|"_obj.ArgCountUnit
	s ret=ret_"^ArgCrossDay|"_obj.ArgCrossDay
	i obj.NightStTime1'="" s ret=ret_"^NightStTime1|"_$zt(obj.NightStTime1,2)
	i obj.NightEndTime1'="" s ret=ret_"^NightEndTime1|"_$zt(obj.NightEndTime1,2)
	s ret=ret_"^DayHour1|"_obj.DayHour1
	s ret=ret_"^AMHour1|"_obj.AMHour1
	s ret=ret_"^PMHour1|"_obj.PMHour1
	i obj.NightStTime2'="" s ret=ret_"^NightStTime2|"_$zt(obj.NightStTime2,2)
	i obj.NightEndTime2'="" s ret=ret_"^NightEndTime2|"_$zt(obj.NightEndTime2,2)
	s ret=ret_"^DayHour2|"_obj.DayHour2
	s ret=ret_"^AMHour2|"_obj.AMHour2
	s ret=ret_"^PMHour2|"_obj.PMHour2
	s ret=ret_"^ArgUpdateDay|"_obj.ArgUpdateDay
	s ret=ret_"^BedBR|"_obj.BedBR_"^ArgStandardTime|"_obj.ArgStandardTime_"^ArgTimeSlot|"_obj.ArgTimeSlot
	q ret
}

/// creator:xbl
/// createdate:20170823
/// description:重置排班参数信息
/// table:DHCNMG.Set.MgArgParamSet
/// input:
/// output:
/// other:
ClassMethod ResetArgParam(id As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	s obj.ArgPeriod=$g(tmp("ArgPeriod"))
	s obj.ArgCountUnit=$g(tmp("ArgCountUnit"))
	s obj.ArgCrossDay=$g(tmp("ArgCrossDay"))
	i $g(tmp("NightStTime1"))'="" s obj.NightStTime1=$zth(tmp("NightStTime1"),1)
	e  s obj.NightStTime1=""
	i $g(tmp("NightEndTime1"))'="" s obj.NightEndTime1=$zth(tmp("NightEndTime1"),1)
	e  s obj.NightEndTime1=""
	s obj.DayHour1=$g(tmp("DayHour1"))
	s obj.AMHour1=$g(tmp("AMHour1"))
	s obj.PMHour1=$g(tmp("PMHour1"))
	i $g(tmp("NightStTime2"))'="" s obj.NightStTime2=$zth(tmp("NightStTime2"),1)
	e  s obj.NightStTime2=""
	i $g(tmp("NightEndTime2"))'="" s obj.NightEndTime2=$zth(tmp("NightEndTime2"),1)
	e  s obj.NightEndTime2=""
	s obj.DayHour2=$g(tmp("DayHour2"))
	s obj.AMHour2=$g(tmp("AMHour2"))
	s obj.PMHour2=$g(tmp("PMHour2"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170904
/// description: 计算小时数
/// input:
/// output:
/// other: w ##class(web.NurMgSetComm).calculateHour("00:00","08:00")
ClassMethod calculateHour(sttime As %String, endtime As %String) As %Float
{
	q:(sttime="")||(endtime="") 0
	q:(sttime>endtime) 0
	s:sttime[":" sttime=$zth(sttime,1)
	s:endtime[":" endtime=$zth(endtime,1)
	s hour=0
	s obj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	s monthday=$P($zd(+$h,3),"-",2)_$P($zd(+$h,3),"-",3)
	i (monthday<"1001")&&((monthday>"0501")||(monthday="0501")) d
	.s nsttime=obj.NightStTime1,nendtime=obj.NightEndTime1
	e  s nsttime=obj.NightStTime2,nendtime=obj.NightEndTime2 
	i nsttime="" s nsttime=$zth("18:00:00",1)
	i nendtime="" s nendtime=$zth("08:00:00",1)
	i (sttime<=nsttime)&&(endtime>=nsttime) d
	.s hour=$fn((endtime-nsttime)/3600,"",2)
	i (sttime>=nsttime)!(endtime<=nendtime) d
	.s hour=$fn((endtime-sttime)/3600,"",2)
	i (sttime<=nendtime)&(endtime>=nendtime) d
	.s hour=$fn((nendtime-sttime)/3600,"",2)
	i (sttime<=nendtime)&(endtime>=nsttime) d
	.s hour=$fn((nendtime-sttime+endtime-nsttime)/3600,"",2)
	q hour
}

/// creator: xbl
/// createdate: 20170904
/// description: 计算分钟
/// input:
/// output:
/// other: w ##class(web.NurMgSetComm).calculateMinute("00:00","08:00")
ClassMethod calculateMinute(sttime As %String, endtime As %String, type As %String = "d") As %Float
{
	q:(sttime="")||(endtime="") 0
	q:(sttime>endtime) 0
	s minute=0
	s obj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	s monthday=$P($zd(+$h,3),"-",2)_$P($zd(+$h,3),"-",3)
	i (monthday<"1001")&&((monthday>"0501")||(monthday="0501")) d
	.s nsttime=obj.NightStTime1,nendtime=obj.NightEndTime1
	e  s nsttime=obj.NightStTime2,nendtime=obj.NightEndTime2 
	i nsttime="" s nsttime=$zth("18:00:00",1)
	i nendtime="" s nendtime=$zth("08:00:00",1)
	i type="d" d
	.s:sttime[":" sttime=$zth(sttime,1)
	.s:endtime[":" endtime=$zth(endtime,1)
	.i (sttime<=nsttime)&&(endtime>=nsttime) d
	..s minute=(endtime-nsttime)/60
	.i (sttime>=nsttime)!(endtime<=nendtime) d
	..s minute=(endtime-sttime)/60
	.i (sttime<=nendtime)&(endtime>=nendtime) d
	..s minute=(nendtime-sttime)/60
	.i (sttime<=nendtime)&(endtime>=nsttime) d
	..s minute=(nendtime-sttime+endtime-nsttime)/60
	i type="s"
	.i (sttime["次日")&&(endtime["次日") d
	..s sttime=$zth($E(sttime,3,$L(sttime)),1)
	..s endtime=$zth($E(endtime,3,$L(endtime)),1)
	..s minute=..calculateMinute(sttime,endtime,"d")
	.i (sttime'["次日")&&(endtime["次日") d
	..s minute1=..calculateMinute(sttime,"23:59","d")
	..s minute2=..calculateMinute("00:00",endtime,"d")
	..s minute=minute1+minute2
	.i (sttime'["次日")&&(endtime'["次日") d
	..s minute=..calculateMinute(sttime,endtime,"d")
	q minute
}

/// Creator:lulin
/// CreatDate: 2018年3月22日 09:18:22
/// UpdateDate:2018-05-23
/// Description: 检测质控标准父表或者检查项是否被使用
/// Table：
/// Input：id:质控父表ID/子表ID
/// Return：1：使用；0未使用  
ClassMethod CheckQualItemUsed(id As %String = "") As %String
{
	
	s result=0
	q:id="" 0
	i $l(id,"||")=2 d
	.s result=$d(^DHCNMG.DB.MgQualModelSubI("qual",id)) ;质控检查
	.i result=0 s result=$d(^DHCNMG.CHK.MgNurNightCheckSubI("qualId"," "_id)) ;夜查房
	.i result=0 s result=$d(^DHCNMG.CHK.MgCheckRoomSubI("model",1," "_id))
	e  i $l(id,"||")=1 d ;质控检查
	.s subid="" f subid=$o(^DHCNMG.DB.MgQualItemSub(id,subid)) q:(subid="")||(result'=0)  d
	..s result=$d(^DHCNMG.DB.MgQualModelSubI("qual",id_"||"_subid))
	.i result=0 d ;夜查房
	..s result=$D(^DHCNMG.CHK.MgNurCheckPlanSubI("qual"," "_id))
	.i result=0 d 
	..s result=$d(^DHCNMG.CHK.MgCheckRoomI("Qual"," "_id))
	q result
}

/// Creator:gzj
/// CreatDate: 2017-09-07
/// Description: 保存质控项目
/// Table：DHCNMG.DB.MgQualItem
/// Input：
/// Return：成功返回 id
ClassMethod SaveQualItem(parr As %String) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=0
	s flag=..IsQualExist(.tmp)
	q:flag=-1 flag 
	s id=$g(tmp("RowID"))
	s isUsed=0,isupdate=0
	i id'="" d 
	.s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(id)
	.s isupdate=(tmp("QualYear")'=obj.QualYear)
	.s:isupdate=0 isupdate=(tmp("QualType")'=obj.QualType)
	.s:isupdate=0 isupdate=(tmp("QualScoreType")'=obj.QualScoreType)
	.s isUsed=..CheckQualItemUsed(id)
	e  s obj=##class(DHCNMG.DB.MgQualItem).%New()
	q:(isupdate&&isUsed) "已被使用，年限、类型、打分不可修改！"
	s p="" f  s p=$O(^oddCOM("DHCNMG.DB.MgQualItem","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="QualCode" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s ptype=^oddCOM("DHCNMG.DB.MgQualItem","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$replace(tmp(p),"/","-")
	...s:$L(tmp(p),"-")=3 tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q obj.%Id()
	;q $$$ISOK(sc)
}

/// Creator: 
/// CreatDate: 
/// Update:lulin 2018-05-23
/// Description: 删除质控标准条目
/// Table：DHCNMG.DB.MgQualItem
/// Input：
/// Return：1:成功。2：已使用。0：失败
ClassMethod DeleteQualItms(id As %String) As %String
{
	q:id="" 0
	
	s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id)
	s isUsed=..CheckQualItemUsed(id)
	if isUsed
	{
		q 2	
	}
	TS
	s fatherid=obj.SubPar
	s sort=obj.SubSort
	s flag=obj.%DeleteId(id)
	if $d(^DHCNMG.DB.MgQualItemSubI("par"," "_id)) 
	{
		s rw="" f  s rw=$o(^DHCNMG.DB.MgQualItemSubD(+id,rw)) q:rw=""  d
		.s childobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(+id_"||"_rw)
		.s childsort=childobj.SubSort
		.q:$l(childsort)<=$l(sort)
		.i $e(childsort,0,$l(sort))=sort  d childobj.%DeleteId(+id_"||"_rw)
	}
	s flag=..CalcuScore(+id,fatherid)
	if flag=1{
		TC	
	}else{
		Tro
	}
	q flag
}

/// Creator: 
/// CreatDate: 
/// Update:lulin 2018-05-23
/// Description: 删除质控标准父表
/// Table：DHCNMG.DB.MgQualItem
/// Input：
/// Return：1:成功。2：已使用。0：失败
/// Other:w ##class(web.NurMgSetComm).DeleteQual(1)
ClassMethod DeleteQual(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(id)
	s isUsed=..CheckQualItemUsed(id)
	if isUsed{
		q 2	
	}
	s flag=obj.%DeleteId(id)
	q flag
}

/// Creator:gzj 
/// CreatDate: 2017-09-07
/// Description: 判断质控项目唯一性
/// Table：DHCNMG.DB.MgQualItem
/// Input：
/// Return： 记录存在返回-1 否则0
ClassMethod IsQualExist(tmp) As %String
{
	s flag=0
	s id=$g(tmp("RowID"))
	s code=$g(tmp("QualCode"))
	s type=$g(tmp("QualType"))
	q:code="" flag
	
	s rw=$O(^DHCNMG.DB.MgQualItemI("year",tmp("QualYear")," "_$zcvt($tr(code," ",""),"U")," "_$tr(type,"__","||"),""))
	i id=""
	{
		i rw'="" s flag=-1
	}elseif id'=""
	{
		i ((rw'="")&&(rw'=id)) s flag=-1
	}
	
	q flag
}

Query FindQualItemsList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualItemsListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s yearParam=$tr($p(parr,"^",1)," ","")
	s typeParam=$tr($p(parr,"^",2),"__","||")
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualItemD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:((yearParam'="")&&(obj.QualYear'=yearParam))
	.q:((typeParam'="")&&(obj.QualType'[typeParam))
	.s QualCode=$zcvt(obj.QualCode,"U")
	.s QualDesc=obj.QualDesc
	.s QualType=""
	.i obj.QualType'="" d
	..s len=$l(obj.QualType,",")
	..f i=1:1:len d
	...s itm=$p(obj.QualType,",",i)
	...q:itm=""
	...s QualTypeObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(itm)
	...i QualType="" s QualType=QualTypeObj.SubDesc
	...e  s QualType=QualType_","_QualTypeObj.SubDesc
	.s QualYear=obj.QualYear
	.s QualScore=obj.QualScore
	.s:QualScore="" QualScore=0
	.s QualScoreType="按比例"
	.s:obj.QualScoreType=2 QualScoreType="按分值"
	.s ret="qualYear|"_QualYear_"^qualDesc|"_QualDesc_"^qualType|"_QualType_"^qualCode|"_QualCode_"^rowid|"_rowid_"^qualScore|"_QualScore_"^qualScoreType|"_QualScoreType_"^qualTyperw|"_obj.QualType
	.do OutQualData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualItemsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualItemsListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualItemsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualItemsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取质控项目记录
/// Date:2017-09-07
/// Table: DHCNMG.DB.MgQualItem
/// Input:
/// Output：
/// Return:
ClassMethod GetQualItem(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(id)
	q:'$IsObject(obj)
	s QualYear=obj.QualYear
	s QualCode=obj.QualCode
	s QualDesc=obj.QualDesc
	s QualType=obj.QualType
	s QualScore=obj.QualScore
	s:QualScore="" QualScore=0
	s QualScoreType=1
	s:obj.QualScoreType=2 QualScoreType=2
	s ret="RowID|"_id_"^QualYear|"_QualYear_"^QualCode|"_QualCode_"^QualDesc|"_QualDesc_"^QualType|"_QualType_"^QualScoreType|"_QualScoreType_"^QualScore|"_QualScore

	q ret
}

/// Creator:gzj
/// Description:保存质控项目明细
/// Date:2017-09-09
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
ClassMethod SaveQualSub(parr As %String) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s id=$g(tmp("RowID"))
	s IsScore=1
	i id'="" d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id)
	.s IsScore='$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj.%Id()))  //无子节点需计算分数
	.s:(IsScore)&&(obj.SubScore=tmp("SubScore")) IsScore=0
	e  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgQualItem).%OpenId(+tmp("SubPar"))
	.s obj.SubSort=..ComputeNodeSort(tmp("SubPar"))
	.i tmp("SubSort")'="1" s obj.SubPar=tmp("SubPar")
	.s IsScore=1
	.;s:(tmp("SubScore")=0) IsScore=0
	s obj.SubDesc=$g(tmp("SubDesc"))
	s obj.SubStandard=$g(tmp("SubStandard"))
	s:IsScore obj.SubScore=+$g(tmp("SubScore"))
	i $g(tmp("SubStDate")) s obj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s obj.SubStDate=""
	i $g(tmp("SubEndDate")) s obj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s obj.SubEndDate=""
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i ($$$ISOK(sc)=1)&&(IsScore) d
	.s flag=..CalcuScore(+tmp("SubPar"),obj.SubPar)
	if flag
	{
		TC
	}
	else
	{
		Tro
	}
	d $System.Status.DisplayError(sc)
	q flag
}

/// Creator:王聪聪
/// Description:保存质控项目明细-包钢
/// Date:2019-09-04
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
ClassMethod SaveQualSub1(parr As %String) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s id=$g(tmp("RowID"))
	s IsScore=1
	i id'="" d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id)
	.s IsScore=1 //无子节点需计算分数
	.s:(IsScore)&&(obj.SubScore=tmp("SubScore")) IsScore=0
	e  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgQualItem).%OpenId(+tmp("SubPar"))
	.s obj.SubSort=..ComputeNodeSort(tmp("SubPar"))
	.i tmp("SubSort")'="1" s obj.SubPar=tmp("SubPar")
	.s IsScore=1
	.;s:(tmp("SubScore")=0) IsScore=0
	s obj.SubDesc=$g(tmp("SubDesc"))
	s obj.SubStandard=$g(tmp("SubStandard"))
	s:IsScore obj.SubScore=+$g(tmp("SubScore"))
	i $g(tmp("SubStDate")) s obj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s obj.SubStDate=""
	i $g(tmp("SubEndDate")) s obj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s obj.SubEndDate=""
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i (($$$ISOK(sc)=1)&&(IsScore)&&(obj.SubPar="")) d
	.s flag=..CalcuScore(+tmp("SubPar"),obj.SubPar)
	if flag
	{
		TC
	}
	else
	{
		Tro
	}
	d $System.Status.DisplayError(sc)
	q flag
}

/// 
/// Creator:lulin
/// Description:计算质控分数并修改
/// Date:2018年2月3日 09:55:09
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:添加、修改节点的父节点id
/// Output：
/// Return:
ClassMethod CalcuScore(par, id As %String) As %String
{
	s total=0
	if id="" 
	{
		s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubD(par,rw)) q:rw=""  d
		.s subobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(subobj)
		.q:subobj.SubPar'=""
		.s subscore=subobj.SubScore
		.s:subscore="" subscore=0
		.s total=total+subscore
		s parobj=##class(DHCNMG.DB.MgQualItem).%OpenId(par)
		q:'$IsObject(parobj) 2
		s parobj.QualScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
	}
	else
	{
		s parobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id)
		q:'$IsObject(parobj) 2
		s total=..GetItemScore(id)
		s parobj.SubScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
		s:flag flag=..CalcuScore(par,parobj.SubPar)
	}
	q flag
}

/// Creator:lulin
/// Description:获取质控检查项子节点分数之和
/// Date:2018年2月3日 09:55:09
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:父节点id
/// Output：
/// Return:
ClassMethod GetItemScore(parid) As %String
{
	s score=0
	s par=+$g(parid)
	s rw="" f  s rw=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_parid,par,rw)) q:rw=""  d
	.s subobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(subobj)
	.s subscore=subobj.SubScore
	.s:subscore="" subscore=0
	.s score=score+subscore
	q score
}

/// Creator:gzj
/// Updater:lulin
/// Description:新增质控标准计算质控sort
/// Date:2018年2月8日
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
/// Others:二级：i.0；三级：i.0.j;四级：i.0.j.z。一级为父类（大标题****质控）
ClassMethod ComputeNodeSort(parid) As %String
{
	s NodeSort=""
	i parid[".0" d //计算二级质控排序
	.s par=$p(parid,".",1)
	.s n=1 //n个二级质控
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rw)
	..q:obj.SubPar'=""
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".")+1
	..s:nextsort>n n=nextsort
	.s NodeSort=n_".0"
	e  d //计算非二级质控排序
	.s par=$P(parid,"||",1)
	.s sort="",NodeSort="",n=1 //获取要要排的序号
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rw)
	..q:(obj.SubPar'=parid) //父节点不对应的q
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".",$l(sort,"."))+1
	..s:nextsort>n n=nextsort
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parid)
	.s NodeSort=obj.SubSort_"."_n
	q NodeSort
}

/// 获取三层指标的排序【已弃用】
ClassMethod SortThird(parid, level) As %String
{
	s NodeSort=""
	s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parid)
	s par=$P(parid,"||",1)
	s sort="",n=0
	s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubD(par,rw)) q:rw=""  d
	.s subobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rw)
	.q:subobj.SubPar'=parid
	.s sort=subobj.SubSort
	.s n=$P(sort,".",$l(sort,"."))+1
	i sort="" d
	.s sort=obj.SubSort
	.s n=1
	s NodeSort=..AddStr(sort,n)
	q NodeSort
}

/// 【已弃用】
ClassMethod AddStr(sort, n) As %String
{
	s ret=""
	s l=$l(sort,".")
	for i=1:1:l
	{
		s ret=ret_$P(sort,".",i)_"."
	}
	i n=0 s ret=ret_"1"
	e  s ret=ret_n
	q ret
}

/// 【已弃用】
ClassMethod AttrSort(sort, n) As %String
{
	s ret=""
	s l=$l(sort,".")
	for i=1:1:l-1
	{
		s ret=ret_$P(sort,".",i)_"."
	}
	q ret_n
}

/// 【已弃用】
/// Creator:gzj
/// Description:计算质控明细的subsort值
/// Date:2017-09-11
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
ClassMethod ComputeSort(subpar, par, sort) As %String
{
	s n=0,m=0
	//计算sort值
	i subpar[".0" d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubD($p(par,".",1),rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId($p(par,".",1)_"||"_rw)
	..q:obj.SubPar'=""
	..s n=(n+1)
	.s n=n_".0"
	e  d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubD($p(par,"||",1),rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId($P(par,"||",1)_"||"_rw)
	..q:(obj.SubPar'=subpar)
	..s n=$P(obj.SubSort,".",$l(obj.SubSort,"."))+1
	..s m=$e(obj.SubSort,".",$l(obj.SubSort)-2)
	.s n=m_"."_n
	q n
}

/// Creator:gzj
/// Date:2018-12-13
/// Description:插入节点 在原有节点上方插入  禁止在树的根节点上插入
/// 
/// d ##class(web.NurMgSetComm).InsertQualNode("SubDesc|测试2^SubStandard|测试2^SubScore|2^SubStDate|^SubEndDate|^SubPar|8||6^SubSort|3")
ClassMethod InsertQualNode(parr As %String) As %String
{
	s parr=$replace(parr,"\","\\")
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId($tr(tmp("SubPar")," ",""))
	q:'$IsObject(obj) ""
	s oldSort=obj.SubSort
	s Par=+$g(tmp("SubPar"))
	s oldPar=obj.SubPar
	TS
	s flag=1
	s level=$g(tmp("SubSort"))
	i level=2
	{
		//查找根节点下有多少二级节点 循环二级节点进行sort数据的修改
		//在循环内部执行该节点下的子节点的数据
		 s rw="" f  s rw=$o(^DHCNMG.DB.MgQualItemSubI("par"," ",Par,rw))  q:rw=""  d
		 .s parObj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(Par_"||"_rw)
		 .q:'$IsObject(parObj)
		 .s parSort=parObj.SubSort
		 .q:(+parSort)<(+oldSort)
		 .s parObj.SubSort=(+parSort+1)_".0"
		 .s flag=..UpdateChild(Par_"||"_rw,level,((+parSort)+1))
		 .s parSc=parObj.%Save()
		 .s flag=($$$ISOK(parSc)&&flag)
	}
	elseif(level>2)
	{
		//首先要取到对应节点的父节点
		//找到要修改的记录 然后判断该节点是否有子节点 如有 则计算子节点的sort
		s rw="" f  s rw=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_oldPar,Par,rw))  q:rw=""  d
		.s parObj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(Par_"||"_rw)
		.q:'$IsObject(parObj)
		.s parSort=parObj.SubSort
		.s currentNum=$p(parObj.SubSort,".",level,level)
		.q:currentNum<$p(oldSort,".",level)
		.s newLevel=$l(parObj.SubSort,".")
		.s parObj.SubSort=$p(oldSort,".",1,level-1)_"."_($p(parSort,".",level)+1)_$case($p(parSort,".",(level+1),$l(parSort))>0,$p(parSort,".",(level+1),$l(parSort)):("."_$p(parSort,".",(level+1),$l(parSort))),:"")
		.i $o(^DHCNMG.DB.MgQualItemSubI("par"," "_(Par_"||"_rw),""))'="" d
		..s flag=..UpdateChild(Par_"||"_rw,newLevel,$p(parSort,".",level)+1)
		.s parSc=parObj.%Save()
		.s flag=($$$ISOK(parObj)&&flag)
	}
	s newObj=##class(DHCNMG.DB.MgQualItemSub).%New()
	s newObj.Parref=##class(DHCNMG.DB.MgQualItem).%OpenId(+$tr(tmp("SubPar")," ",""))
	s newObj.SubDesc=$tr($g(tmp("SubDesc"))," ","")
	s newObj.SubStandard=$g(tmp("SubStandard"))
	s newObj.SubScore=+$g(tmp("SubScore"))
	s newObj.SubPar=oldPar
	
	i $g(tmp("SubStDate")) s newObj.SubStDate=$zdh(tmp("SubStDate"),3)
	i $g(tmp("SubEndDate")) s newObj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	s newObj.SubSort=oldSort
	s sc=newObj.%Save()
	s flag=($$$ISOK(sc)&&flag)
	i (flag=1)&&(+$g(tmp("SubScore"))>0) d
	.s flag=((..CalcuScore(+tmp("SubPar"),newObj.SubPar))&&(flag))
	i flag=1
	{
		tc
	}
	else
	{
		tro
	}
	q flag
}

/// Creator:gzj
/// Date:2018-12-13
/// Description:修改节点的sort
/// 
ClassMethod UpdateChild(par As %String, level As %String, sort As %String) As %String
{
	//UpdateChild("父节点",level)
	s flag=1
	s subRw="" f  s subRw=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_par,+par,subRw)) q:subRw=""  d
	.s subObj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(+par_"||"_subRw)
	.s oldSubSort=subObj.SubSort
	.s newLevel=$l(subObj.SubSort,".")
	.i level=2 d
	..s currentNum=$p(subObj.SubSort,".",level-1,level-1)
	..;q:currentNum<sort
	..i $o(^DHCNMG.DB.MgQualItemSubI("par"," "_(+par_"||"_subRw),""))'="" d ..UpdateChild(+par_"||"_subRw,level,sort)
	..s subObj.SubSort=sort_"."_$p(oldSubSort,".",2,$l(oldSubSort))
	..s sc=subObj.%Save()
	..s flag=($$$ISOK(sc)&&flag)
	.e  i level>2 d
	..s currentNum=$p(subObj.SubSort,".",level,level)
	..;q:((flag=1)&&(currentNum<sort))
	..i $o(^DHCNMG.DB.MgQualItemSubI("par"," "_(+par_"||"_subRw),""))'="" d
	...d ..UpdateChild(+par_"||"_subRw,level,sort)
	..s subObj.SubSort=$p(oldSubSort,".",1,level-1)_"."_($p(oldSubSort,".",level,level)+1)_$case(+($p(oldSubSort,".",(level+1),$l(oldSubSort)))>0,$p(oldSubSort,".",(level+1),$l(oldSubSort)):("."_$p(oldSubSort,".",(level+1),$l(oldSubSort))))
	..s sc=subObj.%Save()
	..s flag=($$$ISOK(sc)&&flag)
	q flag
}

/// Creator:gzj
/// Updater:lulin
/// Description:获取质控管理树的数组。
/// others:字符串超长处理，将返回值分开使用w，最后返回""
ClassMethod GetQualTree(par) As %Text
{
	;s ret=""
	w "["
	s tmp=""
	;s now=+$now()
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualItemSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rowid)
	.;q:(obj.SubStDate>now)||((obj.SubEndDate'="")&&(obj.SubEndDate<now))
	.;s subStandard=obj.SubStandard
	.s subScore=$fn(obj.SubScore,"",1)
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.;仅获取第一层（一级质控），SubPar为空的。根据此节点依次获取子节点。
	.q:subPar'=""
	.s tmp(1,$p(obj.SubSort,"."))=rowid_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(1,sort)) q:sort=""  d
	.i IsExist w ","
	.s rowid=$p(tmp(1,sort),"^")
	.s subDesc=$p(tmp(1,sort),"^",2)
	.w "{"_"""id"""_":"""_par_"||"_rowid_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetSubItems(par,rowid,2)
	.w "}"
	.s IsExist=1
	w "]"
	q ""
}

/// Creator:gzj
/// Updater:lulin
/// Description:获取质控管理树的数组。
/// others:字符串超长处理，将返回值分开使用w，最后返回""
ClassMethod GetQualTree1(par) As %Text
{
	;s ret=""
	w "["
	s tmp=""
	;s now=+$now()
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualItemSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(par_"||"_rowid)
	.;q:(obj.SubStDate>now)||((obj.SubEndDate'="")&&(obj.SubEndDate<now))
	.;s subStandard=obj.SubStandard
	.s subScore=obj.SubScore
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.;仅获取第一层（一级质控），SubPar为空的。根据此节点依次获取子节点。
	.q:subPar'=""
	.s tmp(1,$p(obj.SubSort,"."))=rowid_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(1,sort)) q:sort=""  d
	.i IsExist w ","
	.s rowid=$p(tmp(1,sort),"^")
	.s subDesc=$p(tmp(1,sort),"^",2)
	.w "{"_"""id"""_":"""_par_"||"_rowid_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetSubItems1(par,rowid,2)
	.w "}"
	.s IsExist=1
	w "]"
	q ""
}

/// 回调函数获取子节点
ClassMethod GetSubItems1(parid, rowid, level) As %Text
{
	w "["
	k tmp(level)
	;s now=+$now()
	s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubI("par"," "_parid_"||"_rowid,parid,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parid_"||"_rw)
	.q:(obj.SubPar'=(parid_"||"_rowid))
	.;q:(obj.SubStDate>now)||((obj.SubEndDate'="")&&(obj.SubEndDate<now))
	.s subStandard=obj.SubStandard
	.s subScore=obj.SubScore
	.s subDesc=obj.SubDesc
	.s subPar=obj.SubPar
	.s tmp(level,$p(obj.SubSort,".",$l(obj.SubSort,".")))=rw_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(level,sort)) q:sort=""  d
	.i IsExist w ","
	.s rw=$p(tmp(level,sort),"^")
	.s subDesc=$p(tmp(level,sort),"^",2)
	.w "{"_"""id"""_":"""_parid_"||"_rw_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetSubItems1(parid,rw,level+1)
	.w "}"
	.s IsExist=1
	w "]"
}

/// 回调函数获取子节点
ClassMethod GetSubItems(parid, rowid, level) As %Text
{
	w "["
	k tmp(level)
	;s now=+$now()
	s rw="" f  s rw=$O(^DHCNMG.DB.MgQualItemSubI("par"," "_parid_"||"_rowid,parid,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parid_"||"_rw)
	.q:(obj.SubPar'=(parid_"||"_rowid))
	.;q:(obj.SubStDate>now)||((obj.SubEndDate'="")&&(obj.SubEndDate<now))
	.s subStandard=obj.SubStandard
	.s subScore=$fn(obj.SubScore,"",1)
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.s tmp(level,$p(obj.SubSort,".",$l(obj.SubSort,".")))=rw_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(level,sort)) q:sort=""  d
	.i IsExist w ","
	.s rw=$p(tmp(level,sort),"^")
	.s subDesc=$p(tmp(level,sort),"^",2)
	.w "{"_"""id"""_":"""_parid_"||"_rw_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetSubItems(parid,rw,level+1)
	.w "}"
	.s IsExist=1
	w "]"
}

/// 
/// Creator:gzj
/// Description:根据key(id)查找Tree的节点信息
/// Date:2017-09-12
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
ClassMethod GetTreeData(id As %String) As %String
{
	s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id)
	q:'$IsObject(obj) ""
	s SubDesc=obj.SubDesc
	s SubStandard=obj.SubStandard
	s SubScore=$fn(obj.SubScore,"",1)
	i obj.SubStDate'="" s SubStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)
	e  s SubStDate=""
	i obj.SubEndDate'="" s SubEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)
	e  s SubEndDate=""
	s ret="RowID|"_id_"^SubDesc|"_SubDesc_"^SubStandard|"_SubStandard_"^SubScore|"_SubScore_"^SubStDate|"_SubStDate_"^SubEndDate|"_SubEndDate
	q ret
}

/// Creator:lulin
/// CreatDate: 2018-05-23
/// Description: 检测质控重组父表或者检查项是否被重组使用
/// Table：
/// Input：id:质控重组父表ID/子表ID
/// Return：1：使用；0未使用 
ClassMethod CheckModelIsUsed(id As %String = "") As %String
{
	s result=0
	s:$l(id,"||")=1 result=$d(^DHCNMG.CHK.MgCheckRoomI("stat",2,id))
	s:$l(id,"||")=2 result=$d(^DHCNMG.CHK.MgCheckRoomSubI("model",2,id))
	q result
}

/// Creator:lulin
/// Description:保存质控重组表单
/// Date:2017-09-12
/// UpDate:2018-05-22
/// Table: DHCNMG.DB.MgQualModel
/// Input:
/// RestructYear|2017^RestructCode|测试^RestructDesc|测试^RestructType|8__1^RestructGroup|1^RowID|
/// ^loginID|0^loginRoleCode|admin^loginDep|
/// Output：成功：1;失败：错误信息
/// other:w ##class(web.NurMgSetComm).SaveRestructModel("RestructYear|2018^RestructCode|cs^RestructDesc|cs^RestructType|8__1^RestructScoreType|1^RestructGroup|1^RowID|^loginID|0^loginRoleCode|admin^loginDep|")
ClassMethod SaveRestructModel(parr As %String) As %String
{
	s parr=$replace(parr,"\","\\")
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s level="",levelid="",loginRoleCode=$zcvt($tr(tmp("loginRoleCode")," ",""),"U")
	;护士长
	i loginRoleCode="NURHEAD" d
	.s level="W"
	.s levelid=tmp("loginDep")
	;大科护士长
	i loginRoleCode="ZNURHEAD" d
	.s level="L"
	.s objWard=##class(DHCNMG.DB.MgWard).%OpenId(tmp("loginDep"))
	.s:($IsObject(objWard))&&($d(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id()))) levelid=$O(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id(),""))
	;护理部
	i (loginRoleCode="HLB")||(loginRoleCode="HLBZR")||(loginRoleCode="MANAGER")||(loginRoleCode="ADMIN") d
	.s level="H"
	q:level="" "无相关权限"
	s id=$g(tmp("RowID"))
	s flag=..IsExistModel(.tmp) 
	q:flag=2 "存在同年同代码记录，不可重复添加"
	s isUsed=0,isupdate=0
	i id'="" d
	.s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(id)
	.s isupdate=(tmp("RestructYear")'=obj.RestructYear)
	.s:isupdate=0 isupdate=(tmp("RestructType")'=obj.RestructType)
	.s:isupdate=0 isupdate=(tmp("RestructScoreType")'=obj.RestructScoreType)
	.s isUsed=..CheckModelIsUsed(id)
	e  d
	.s obj=##class(DHCNMG.DB.MgQualModel).%New()
	q:(isupdate&&isUsed) "已被使用，年限、类型、打分不可修改！"
	s obj.RestructCode=$zcvt($tr($g(tmp("RestructCode"))," ",""),"U")
	s obj.RestructDesc=$zcvt($tr($g(tmp("RestructDesc"))," ",""),"U")
	s obj.RestructType=tmp("RestructType")
	s obj.RestructScoreType=tmp("RestructScoreType")
	i $g(tmp("RestructYear")) s obj.RestructYear=tmp("RestructYear")
	i $g(tmp("RestructGroup")) s obj.RestructGroup=##class(DHCNMG.DB.MgQualGroup).%OpenId(tmp("RestructGroup"))
	i $g(tmp("loginID")) s obj.RestructPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("loginID"))
	s obj.RestructLevel=level
	s obj.RestructLevelId=levelid
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	s ret=""
	i $$$ISOK(sc){
		s ret=1
	}else{
		s ret="保存失败"
	}
	q ret
}

/// 判断质控重组是否重复存在
/// Input：添加/修改重组内容
ClassMethod IsExistModel(tmp) As %String
{
	s flag=0
	s id=$g(tmp("RowID"))
	s code=$g(tmp("RestructCode"))
	s type=$g(tmp("RestructType"))
	i code'="" d
	.s rw=$O(^DHCNMG.DB.MgQualModelI("Flag",tmp("RestructYear")," "_$zcvt($tr(code," ",""),"U")," "_type,""))
	.i (rw'="")&&((id="")||((id'="")&&(rw'=id))) s flag=2
	q flag
}

/// Creator:lulin
/// Description:删除质控重组模板
/// Date:2018-05-25
/// Table:DHCNMG.DB.MgQualModel
/// Input:id
/// Output：
/// Return:
/// Others:
ClassMethod DeleteRestructModel(id As %String = "") As %String
{
	q:id="" "传入ID为空"
	s isUsed=..CheckModelIsUsed(id)
	q:isUsed'=0 "已被使用不可删除"
	s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q sc
}

/// Creator:gzj
/// Description:查询质控重组模板
/// Date:2017-09-14
/// Table:DHCNMG.DB.MgQualModel
/// Input:检索条件,登录人id，登录权限，登录病区，是否是检查显示:1.是。""：不是
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindRestructModel","^^0^^admin^")
Query FindRestructModel(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRestructModelExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s year=$tr($p(parr,"^",1)," ","")
	s type=$tr($p(parr,"^",2),"__","||")
	s:type["_" type=$tr(type,"_","|")
	s loginID=$tr($p(parr,"^",3)," ","")
	s loginDep=$tr($p(parr,"^",4)," ","")
	s loginRoleCode=$zcvt($tr($p(parr,"^",5)," ",""),"U")
	s Level="",LevelId=""
	;护理部
	i (loginRoleCode="HLB")||(loginRoleCode="HLBZR")||(loginRoleCode="MANAGER")||(loginRoleCode="ADMIN") d
	.s Level="H"
	;护士长
	i loginRoleCode="NURHEAD" d
	.s Level="W"
	.s LevelId=loginDep
	;大科护士长
	i loginRoleCode="ZNURHEAD" d
	.s Level="L"
	.s objWard=##class(DHCNMG.DB.MgWard).%OpenId(loginDep)
	.s:($IsObject(objWard))&&($d(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id()))) LevelId=$O(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id(),""))
	.;s:($IsObject(objWard))&&($IsObject(objWard.WardLocDR)) LevelId=objWard.WardLocDR.%Id()
	i Level="" {set qHandle=$lb(0,repid,0) Quit $$$OK}
	;配置显示
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualModelD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s objLevel=$zcvt(obj.RestructLevel,"U")
	.q:(objLevel'="")&&(objLevel'=Level)
	.q:(objLevel="")&&(Level'="H")
	.q:(obj.RestructLevelId'="")&&(obj.RestructLevelId'=LevelId)
	.q:(year'="")&&(year'=obj.RestructYear)
	.q:(type'="")&&(type'=obj.RestructType)
	.s restructCode=$zcvt(obj.RestructCode,"U")
	.s restructDesc=obj.RestructDesc
	.s restructType=""
	.s restructTyperw=$tr(obj.RestructType,"|","_")
	.i obj.RestructType'="" d
	..s TypeObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.RestructType)
	..s restructType=TypeObj.SubDesc
	.e  s restructType=""
	.s restructScore=obj.RestructScore
	.s:restructScore="" restructScore=0
	.s restructscoretype="按比例"
	.s:obj.RestructScoreType="2" restructscoretype="按分值"
	.s GroupDesc="",GroupDR=""
	.s:$IsObject(obj.RestructGroup) GroupDesc=obj.RestructGroup.GroupDesc,GroupDR=obj.RestructGroup.%Id()
	.s QualLevel=obj.RestructLevel
	.s QualLevelDesc=""
	.s:QualLevel="H" QualLevelDesc="护理部"
	.s:QualLevel="L" QualLevelDesc="大科"
	.s:QualLevel="N" QualLevelDesc="病区"
	.s ret="qualYear|"_obj.RestructYear_"^qualDesc|"_restructDesc_"^qualType|"_restructType_"^qualCode|"_restructCode_"^rowid|"_rowid_"^qualScore|"_restructScore_"^qualScoreType|"_restructscoretype_"^qualTyperw|"_restructTyperw
	.s ret=ret_"^GroupDesc|"_GroupDesc_"^GroupDR|"_GroupDR_"^QualLevel|"_QualLevel_"^QualLevelDesc|"_QualLevelDesc
	.;s ret="restructCode|"_restructCode_"^restructDesc|"_restructDesc_"^restructType|"_restructType_"^restructYear|"_restructYear_"^rowid|"_rowid_"^restructScore|"_restructScore_"^restructscoretype|"_restructscoretype_"^restructTyperw|"_restructTyperw
	.do OutputQualData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRestructModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRestructModelExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRestructModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRestructModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:根据id获取质控模板记录信息
/// Date:2017-09-15
/// Table: DHCNMG.DB.MgQualModel
/// Input:
/// Output：
/// Return:
ClassMethod GetRestructModel(id As %String = "") As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(id)
	q:'$IsObject(obj) ""
	s RestructYear=obj.RestructYear
	s RestructCode=obj.RestructCode
	s RestructDesc=obj.RestructDesc
	s RestructType=$tr(obj.RestructType,"|","_")
	s RestructScoreType=obj.RestructScoreType
	s RestructScore=obj.RestructScore
	s:RestructScore="" RestructScore=0
	s RestructGroup=""
	s:($IsObject(obj.RestructGroup)) RestructGroup=obj.RestructGroup.%Id()
	s:RestructScoreType="" RestructScoreType="1"
	s ret="RestructGroup|"_RestructGroup_"^RestructYear|"_RestructYear_"^RestructCode|"_RestructCode_"^RestructDesc|"_RestructDesc_"^RestructType|"_RestructType_"^RestructScoreType|"_RestructScoreType_"^RestructScore|"_RestructScore_"^RowID|"_id
	q ret
}

/// Creator:gzj
/// Description:保存重组模板项目明细
/// Date:2017-09-15
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:RestructItem|测试2^RestructStand|^RestructScore|0^RestructStDate|2018-02-08^RestructEndDate|^RowID|^SubPar|1.0^SubSort|1
/// Output：
/// Return:
ClassMethod SaveRestructItems(parr As %String) As %String
{
	//RestructItem|测试^RowID|^Par|1
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	Ts
	s id=$g(tmp("RowID"))
	s IsScore=1
	i id'="" d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(id)
	.s IsScore='$d(^DHCNMG.DB.MgQualModelSubI("par"," "_obj.%Id()))  //无子节点操作分数
	e  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgQualModel).%OpenId(+tmp("SubPar"))
	.s obj.RestructSort=..ComputeQualItemSubSort(tmp("SubPar"))
	.i tmp("SubSort")'="1" s obj.RestructPar=tmp("SubPar")
	.s IsScore=1
	s obj.RestructItem=$g(tmp("RestructItem"))
	s obj.RestructStand=$g(tmp("RestructStand"))
	s:IsScore obj.RestructScore=+$g(tmp("RestructScore"))
	s obj.RestructStDate=tmp("RestructStDate")
	s obj.RestructEndDate=tmp("RestructEndDate")
	i $g(tmp("RestructStDate")) s obj.RestructStDate=$zdh(tmp("RestructStDate"),3)
	i $g(tmp("RestructEndDate")) s obj.RestructEndDate=$zdh(tmp("RestructEndDate"),3)
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i ($$$ISOK(sc)=1)&&(IsScore) d 
	.s flag=..CalcuResItemScore(+tmp("SubPar"),obj.RestructPar)
	if flag=1{
		TC	
	}else{
		Tro	
	}
	d $System.Status.DisplayError(sc)
	q flag
}

/// Creator:lulin
/// Description:新增质控重组明细时,计算质控重组sort
/// Date:2017-09-11
/// Table: DHCNMG.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:w ##class(web.NurMgSetComm).ComputeQualItemSubSort("7||4")
/// Others:二级：i.0；三级：i.0.j;四级：i.0.j.z。一级为父类（大标题****质控）
ClassMethod ComputeQualItemSubSort(parid) As %String
{
	s NodeSort=""
	i parid[".0" d  //计算二级排序
	.s par=$p(parid,".",1)
	.s n=1 //n个二级质控
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rw)
	..q:obj.RestructPar'=""
	..s sort=obj.RestructSort
	..s nextsort=$P(sort,".")+1
	..s:nextsort>n n=nextsort
	.s NodeSort=n_".0"
	e  d  //计算非二级排序
	.s par=$P(parid,"||",1)
	.s sort="",NodeSort="",n=1  //获取要要排的序号
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rw)
	..q:(obj.RestructPar'=parid) //父节点不对应的q
	..s sort=obj.RestructSort
	..s nextsort=$P(sort,".",$l(sort,"."))+1
	..s:nextsort>n n=nextsort
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parid)
	.s NodeSort=obj.RestructSort_"."_n
	q NodeSort
}

/// Creator:lulin
/// Description:计算重组质控分数并修改
/// Date:2018年2月3日 09:55:09
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:添加、修改节点的父节点id
/// Output：
/// Return:
ClassMethod CalcuResItemScore(par, id) As %String
{
	//重组质控执行分数计算
	s total=0
	if id="" {
		s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubD(par,rw)) q:rw=""  d
		.s subobj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(subobj)
		.q:subobj.RestructPar'=""
		.s subscore=subobj.RestructScore
		.s:subscore="" subscore=0
		.s total=total+subscore
		s parobj=##class(DHCNMG.DB.MgQualModel).%OpenId(par)
		q:'$IsObject(parobj) 2
		s parobj.RestructScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
	}else{
		s subobj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(id)
		q:'$IsObject(subobj) 2
		s total=..GetResItemScore(id)
		s subobj.RestructScore=total
		s sc=subobj.%Save()
		s flag=$$$ISOK(sc)
		s:flag=1 flag=..CalcuResItemScore(par,subobj.RestructPar)
	}
	q flag
}

/// 
/// Creator:lulin
/// Description:获取某节点子节点所有分数和
/// Date:2018年2月8日
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod GetResItemScore(parid) As %String
{
	s score=0
	s par=+$g(parid)
	s rw="" f  s rw=$o(^DHCNMG.DB.MgQualModelSubI("par"," "_parid,par,rw)) q:rw=""  d
	.s subobj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(subobj)
	.s subscore=subobj.RestructScore
	.s:subscore="" subscore=0
	.s score=score+subscore
	q score
}

ClassMethod DeleteRestructItms(id As %String) As %String
{
	q:id="" 0
	TS
	s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(id)
	s isUsed=..CheckModelIsUsed(id)
	if isUsed{
		Tro
		q 2	
	}
	s fatherid=obj.RestructPar
	s sort=obj.RestructSort
	s status=obj.%DeleteId(id)
	if $d(^DHCNMG.DB.MgQualModelSubI("par"," "_id)) {
		s rw="" f  s rw=$o(^DHCNMG.DB.MgQualModelSubD(+id,rw)) q:rw=""  d
		.s childobj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(+id_"||"_rw)
		.s childsort=childobj.RestructSort
		.q:$l(childsort)<=$l(sort)
		.i $e(childsort,0,$l(sort))=sort  d childobj.%DeleteId(+id_"||"_rw)
	}
	s flag=..CalcuResItemScore(+id,fatherid)
	if flag=1{
		TC	
	}else{
		Tro
	}
	q flag
}

ClassMethod ComputeResSort(par) As %String
{
	s ret=""
	i par'["||" d
	.s n="1.0"
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rw)
	..q:obj.RestructPar'=""
	..s sort=obj.RestructSort
	..s n=sort+1
	.s ret=n
	e  d
	.
	q ret
}

/// Creator:gzj
/// Updater:lulin
/// Description:查询重组树
/// Date:2017-09-16
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod GetRestructTree(par) As %Text
{
	w "["
	
	;s now=+$now()
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualModelSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rowid)
	.;q:(obj.RestructStDate>now)||((obj.RestructEndDate'="")&&(obj.RestructEndDate<now))
	.s restructDesc=obj.RestructItem_"("_obj.RestructScore_")"
	.s restructPar=obj.RestructPar
	.q:restructPar'=""
	.s tmp(1,$p(obj.RestructSort,"."))=rowid_"^"_restructDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(1,sort)) q:sort=""  d
	.i IsExist w ","
	.s rowid=$p(tmp(1,sort),"^")
	.s restructDesc=$p(tmp(1,sort),"^",2)
	.w "{"_"""id"""_":"""_par_"||"_rowid_""",""label"":"""_restructDesc_""",""children"":"
	.d ..GetRestructItems(par,rowid,2)
	.w "}"
	.s IsExist=1
	w "]"
	q ""
}

ClassMethod GetRestructItems(parid, rowid, level) As %Text
{
	;s retval="["
	w "["
	k tmp(level)
	;s now=+$now()
	s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubI("par"," "_parid_"||"_rowid,parid,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parid_"||"_rw)
	.;q:(obj.RestructStDate>now)||((obj.RestructEndDate'="")&&(obj.RestructEndDate<now))
	.s restructDesc=obj.RestructItem_"("_obj.RestructScore_")"
	.s restructPar=obj.RestructPar
	.s tmp(level,$p(obj.RestructSort,".",$l(obj.RestructSort,".")))=rw_"^"_restructDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(level,sort)) q:sort=""  d
	.i IsExist w ","
	.s id=$p(tmp(level,sort),"^")
	.s subDesc=$p(tmp(level,sort),"^",2)
	.w "{"_"""id"""_":"""_parid_"||"_id_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetRestructItems(parid,id,level+1)
	.w "}"
	.s IsExist=1
	w "]"
}

/// 
/// Creator:gzj
/// Updater:lulin
/// Description:保存重组模板项目明细(重组和标准匹配保存)
/// Date:2018.02.09
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod ForSaveTree(parr As %String, parrow As %String, level As %String) As %String
{
	s tmp=""
	;s sortlength=1
	;i parrow'[".0" d
	;.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parrow)
	;.s sortlength=$l(obj.RestructSort,".")
	;得到所有标准中所选重组节点以下的子节点
	;d getQualNotExist
	s flag=1
	Ts
	s par=$o(tmp("id",""))
	f i=1:1:$l(parr,"^") q:flag'=1  d
	.s parID=parrow
	.q:$p(parr,"^",i)=""
	.q:$d(^DHCNMG.DB.MgQualModelSubI("qual",$p(parr,"^",i),+parrow))
	.s qualobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId($p(parr,"^",i))
	.q:'$IsObject(qualobj)
	.s leafLevel=$l(qualobj.SubSort,".")
	.i (leafLevel>(level+1)) d
	..s parID=+parrow_"||"_$o(^DHCNMG.DB.MgQualModelSubI("qual",qualobj.SubPar,+parrow,""))
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgQualModel).%OpenId(+parrow)
	.s obj.RestructSort=..ComputeQualItemSubSort(parID)
	.i parID'[".0" s obj.RestructPar=parID
	.s obj.QualItemID=qualobj
	.s obj.RestructItem=qualobj.SubDesc
	.s obj.RestructStand=qualobj.SubStandard
	.s obj.RestructScore=qualobj.SubScore
	.s obj.RestructStDate=qualobj.SubStDate
	.s:qualobj.SubStDate="" obj.RestructStDate=+$h
	.s obj.RestructEndDate=qualobj.SubEndDate
	.s sc=obj.%Save()
	.s flag=$$$ISOK(sc)
	i flag d 
	.s parID=""
	.s:parrow'[".0" parID=parrow
	.s flag=..CalcuResItemScore(+parrow,parID)
	if flag=1{
		TC	
	}else{
		Tro	
	}
	d $System.Status.DisplayError(sc)
	q flag
	
#;getQualNotExist
#;	s len=$l(parr,"^")
#;	s i=0
#;	d{	
#;		s i=i+1
#;		s id=$p(parr,"^",i)
#;		continue:id=""
#;		continue:$d(tmp("id",$p(id,"||"),$p(id,"||",2)))
#;		s qualobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id)
#;		continue:'$IsObject(qualobj)
#;		;如果所添加子节点的父节点还未添加则添加上
#;		i ($l(qualobj.SubSort,".")>(level+1))&&('$d(tmp("par"," "_qualobj.SubPar))) d
#;		.s parr=parr_"^"_qualobj.SubPar
#;		.s len=$l(parr,"^")
#;		s tmp("id",qualobj.Parref.%Id(),$p(qualobj.%Id(),"||",2))=qualobj.%Id()_"^"_qualobj.SubScore_"^"_qualobj.SubPar_"^"_qualobj.SubDesc_"^"_qualobj.SubStandard_"^"_qualobj.SubScore_"^"_qualobj.SubStDate_"^"_qualobj.SubEndDate
#;		s tmp("par"," "_id)=id
#;	}while i<=len
}

/// 检测所选质控标准项在相应重组项里面是否已添加
/// Return:第一个重复项名称
ClassMethod CheckQualIsExist(parr As %String, parrow As %String)
{
	s len=$l(parr,"^")
	s result=""
	f i=1:1:len q:result'=""  d
	.q:$p(parr,"^",i)=""
	.i $d(^DHCNMG.DB.MgQualModelSubI("qual",$p(parr,"^",i),+parrow))  d
	..s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId($p(parr,"^",i))
	..q:'$IsObject(obj)
	..s result=obj.SubDesc
	q result
}

/// 获取所有未添加项的的tmp
/// 
ClassMethod getQualNotExist(parr As %String, parrow As %String, tmp)
{
	s len=$l(parr,"^")
	s result=""
	s parobj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parrow)
	f i=1:1:len  d
	.q:$p(parr,"^",i)=""
	.i '$d(^DHCNMG.DB.MgQualModelSubI("qual",$p(parr,"^",i),+parrow))  d
	..s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId($p(parr,"^",i))
	..q:'$IsObject(obj)
	..i ($l(parobj.RestructSort,".")+1)<$l(obj.SubSort) d
	...s subparobj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(obj.SubPar)
	...i ($l(parobj.RestructSort,".")+1)<$l(subparobj.SubSort) d
	...s parr=parr_"^"_subparobj.%Id()
	...s len=len+1
	..s tmp(obj.SubSort)=obj.%Id()_"^"_obj.SubDesc_"^"_obj.SubStandard_"^"_obj.SubScore_"^"_obj.SubPar_"^"_obj.SubStDate_"^"_obj.SubEndDate
}

/// 
/// Creator:gzj
/// Description:计算重组模板分数
/// Date:2017-09-19
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod CalcuResScore(par) As %String
{
	s total=0
	s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubD(par,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rw)
	.q:obj.RestructPar'=""
	.s total=total+..GetResItemScore(par,rw)
	q total
}

/// 
/// Creator:gzj
/// Description:计算层数为1的树的sort
/// Date:2017-09-18
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod ComputeRestructSort(par) As %String
{
	s num="1.0"
	s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubD(par,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rw)
	.q:obj.RestructPar'=""
	.s num=($P(obj.RestructSort,".",1)+1)_".0"
	q num
}

ClassMethod GetResSort(str) As %String
{
	s ret=""
	s len=$L(str,".")
	for i=1:1:len-1
	{
		s itm=$P(str,".",i)
		i ret="" s ret=itm
		e  s ret=ret_"."_itm
	}
	q ret
}

/// Creator:gzj
/// Description:计算层数为2的树的sort
/// Date:2017-09-19
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod ComputeResSubSort(parrow, qualPar, sort) As %String
{
	s n=0,count="",m=""
	s rw="" f  s rw=$O(^DHCNMG.DB.MgQualModelSubD(parrow,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parrow_"||"_rw)
	.q:(obj.RestructPar'=qualPar)
	.s count=obj.RestructSort
	.;s n=$P(count,".",$l(count,"."))+1
	.s n=..GetResSort(obj.RestructSort)_"."_($P(obj.RestructSort,".",$L(obj.RestructSort,"."))+1)
	i n=0 s n=sort+(0_"."_1)
	q n
}

/// Creator:gzj
/// Description:获取重组明细内容
/// Date:2017-09-19
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod GetResRecData(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(id)
	q:'$IsObject(obj)
	s RestructItem=obj.RestructItem
	s RestructStand=obj.RestructStand
	s RestructScore=obj.RestructScore
	i obj.RestructStDate'="" s RestructStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RestructStDate)
	e  s RestructStDate=""
	i obj.RestructEndDate'="" s RestructEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.RestructEndDate)
	e  s RestructEndDate=""
	s ret="RestructItem|"_RestructItem_"^RestructStand|"_RestructStand_"^RestructScore|"_RestructScore_"^RestructStDate|"_RestructStDate_"^RestructEndDate|"_RestructEndDate_"^RowID|"_id
	q ret
}

ClassMethod UpdateResRecData(parr As %String) As %String
{
	//RestructItem|护士站不清洁^RestructStand|^RestructScore|1
	//^RestructStDate|2017-09-19^RestructEndDate|^RowID|1||2
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(id)
	s obj.RestructItem=tmp("RestructItem")
	s obj.RestructStand=tmp("RestructStand")
	s obj.RestructScore=tmp("RestructScore")
	i $g(tmp("RestructStDate"))'="" s obj.RestructStDate=$zdh(tmp("RestructStDate"),3)
	e  s obj.RestructStDate=""
	i $g(tmp("RestructEndDate"))'="" s obj.RestructEndDate=$zdh(tmp("RestructEndDate"),3)
	e  s obj.RestructEndDate=""
	s sc=obj.%Save()
	i $$$ISOK(sc)=1 d
	.s ParID=$P(id,"||",1)
	.s total=..CalcuResScore(ParID)
	.s parobj=##class(DHCNMG.DB.MgQualModel).%OpenId(ParID)
	.s parobj.RestructScore=total
	.d parobj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:保存列表字段配置数据
/// Date:2017-10-30
/// Table: DHCNMG.Set.MgFieldSet
/// Input:
/// Output：
/// Return:
ClassMethod SaveFieldSet(parr As %String) As %String
{
	//FieldDesc|工号^FieldCode|PerID^FieldSort|1^FieldDisplay|true^FieldLock|false^FieldLockPos|-1
	//^RowID|^FieldTable|3
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" d
	.s obj=##class(DHCNMG.Set.MgFieldSet).%New()
	e  s obj=##class(DHCNMG.Set.MgFieldSet).%OpenId(id)
	s obj.FieldCode=$tr(tmp("FieldCode")," ","")
	s obj.FieldDesc=$tr(tmp("FieldDesc")," ","")
	s obj.FieldDisplay=$tr(tmp("FieldDisplay")," ","")
	s obj.FieldLock=$tr(tmp("FieldLock")," ","")
	s obj.FieldLockPos=$tr(tmp("FieldLockPos")," ","")
	s obj.FieldSort=$tr(tmp("FieldSort")," ","")
	s obj.FieldTable=$tr(tmp("FieldTable")," ","")
	s obj.FieldWidth=$tr(tmp("FieldWidth")," ","")
	s obj.FieldType=$tr(tmp("FieldType")," ","")
	;i id'="" d ..UpDateFieldSort(tmp("FieldTable"),id,tmp("FieldSort"))
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:更新列表字段配置顺序号
/// Date:2017-10-31
/// Table: DHCNMG.Set.MgFieldSet
/// Input:
/// Output：
/// Return:
ClassMethod UpDateFieldSort(par As %String, id As %String, sort As %String) As %String
{
	s maxSort=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_par,""),-1)
	s rowid="" f  s rowid=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_par,sort,rowid)) q:rowid=""  d
	.q:(rowid=id)
	.s obj=##class(DHCNMG.Set.MgFieldSet).%OpenId(rowid)
	/*
	i sort=(maxSort+1) d
	.
	e  i (sort<maxSort) d
	.for k=sort:1:maxSort d
	..s rowid=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_par,k,""))
	..q:(rowid=id)
	..s obj=##class(DHCNMG.Set.MgFieldSet).%OpenId(rowid)
	..s obj.FieldSort=obj.FieldSort+1
	..d obj.%Save()
	*/
	q 0
}

/// Creator:gzj
/// Description:查询列表字段配置列表
/// Date:2017-10-30
/// Table:DHCNMG.Set.MgFieldSet
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindFieldSetList","")
Query FindFieldSetList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindFieldSetListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_parr,sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_parr,sort,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.Set.MgFieldSet).%OpenId(rowid)
	..s fieldCode=obj.FieldCode
	..s fieldDesc=obj.FieldDesc
	..s fieldSort=obj.FieldSort
	..i obj.FieldDisplay="true" s fieldDisplay="是"
	..e  i obj.FieldDisplay="false" s fieldDisplay="否"
	..i obj.FieldLock="true" s fieldLock="是"
	..e  i obj.FieldLock="false" s fieldLock="否"
	..i obj.FieldLockPos="-1" s fieldLockPos=""
	..e  i obj.FieldLockPos="0" s fieldLockPos="表头"
	..e  i obj.FieldLockPos="1" s fieldLockPos="表尾"
	..s fieldWidth=obj.FieldWidth
	..s fieldType=""
	..i obj.FieldType="input" s fieldType="文本框"
	..e  i obj.FieldType="select" s fieldType="下拉框"
	..e  i obj.FieldType="date" s fieldType="日期选择器"
	..s ret="fieldCode|"_fieldCode_"^fieldDesc|"_fieldDesc_"^fieldSort|"_fieldSort_"^fieldDisplay|"_fieldDisplay_"^fieldLock|"_fieldLock_"^fieldLockPos|"_fieldLockPos_"^rowID|"_rowid_"^fieldWidth|"_fieldWidth_"^fieldType|"_fieldType
	..do OutputFieldData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputFieldData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindFieldSetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFieldSetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindFieldSetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFieldSetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:计算列表字段配置序号
/// Date:2017-10-30
/// Table: DHCNMG.Set.MgFieldSet
/// Input:
/// Output：
/// Return:
ClassMethod GetFieldSort(par) As %String
{
	s ret=""
	s sort=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_par,""),-1)
	i sort="" s ret=1
	e  s ret=sort+1
	q ret
}

/// Creator:gzj
/// Description:获取列表字段配置数据
/// Date:2017-10-30
/// Table: DHCNMG.Set.MgFieldSet
/// Input:
/// Output：
/// Return:
ClassMethod GetFieldsData(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCNMG.Set.MgFieldSet).%OpenId(id)
	s FieldDesc=obj.FieldDesc
	s FieldCode=obj.FieldCode
	s FieldSort=obj.FieldSort
	s FieldDisplay=obj.FieldDisplay
	s FieldLock=obj.FieldLock
	s FieldLockPos=obj.FieldLockPos
	s FieldTable=obj.FieldTable
	s FieldWidth=obj.FieldWidth
	s FieldType=obj.FieldType
	s RowID=id
	s ret="FieldDesc|"_FieldDesc_"^FieldCode|"_FieldCode_"^FieldSort|"_FieldSort_"^FieldDisplay|"_FieldDisplay_"^FieldLock|"_FieldLock_"^FieldLockPos|"_FieldLockPos_"^FieldTable|"_FieldTable_"^RowID|"_RowID_"^FieldWidth|"_FieldWidth_"^FieldType|"_FieldType
	q ret
}

/// Creator:gzj
/// Description:获取列表字段配置顺序号
/// Date:2017-10-31
/// Table: DHCNMG.Set.MgFieldSet
/// Input:
/// Output：
/// Return:返回0 为最顶 返回1 为最底
ClassMethod GetFieldSetSort(par As %String, id As %String, para As %String) As %String
{
	q:id="" ""
	s ret=0
	s obj=##class(DHCNMG.Set.MgFieldSet).%OpenId(id)
	s sort=obj.FieldSort
	;q:sort=1 "已经置顶了！"
	
	i para="up" d
	.i sort="1" s ret=0
	.e  d
	..s ret=sort-1
	..s obj.FieldSort=sort-1
	..s rowid=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_par,sort-1,""))
	..s bobj=##class(DHCNMG.Set.MgFieldSet).%OpenId(rowid)
	..s bobj.FieldSort=sort
	..d bobj.%Save()
	..d obj.%Save()
	e  i para="down" d
	.s maxSort=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_par,""),-1)
	.i sort=maxSort s ret=1
	.e  d
	..s ret=sort+1
	..s obj.FieldSort=sort+1
	..s rowid=$O(^DHCNMG.Set.MgFieldSetI("sort"," "_par,sort+1,""))
	..s bobj=##class(DHCNMG.Set.MgFieldSet).%OpenId(rowid)
	..s bobj.FieldSort=sort
	..d bobj.%Save()
	..d obj.%Save()
	q ret
}

/// Creator:gzj
/// Description:保存界面元素
/// Date:2017-11-08
/// Table: DHCNMG.Set.MgMenuElement
/// Input:
/// Output：
/// Return:
ClassMethod SaveElementData(parr As %String)
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s par=$g(tmp("par"))
	s rw=$g(tmp("RowID"))
	s flag=..IsExistElement(tmp("par"),tmp("RowID"),tmp("elementid"))
	q:flag=2 flag
	i rw'="" s obj=##class(DHCNMG.Set.MgMenuElement).%OpenId(par_"||"_rw)
	e  d
	.s obj=##class(DHCNMG.Set.MgMenuElement).%New()
	.s obj.Parref=##class(DHCNMG.Set.MgMenu).%OpenId(par)
	s obj.ElementCode=$tr($g(tmp("elementid"))," ","")
	s obj.ElementDesc=$tr($g(tmp("elementdesc"))," ","")
	s obj.ElementType=$tr($g(tmp("elementtype"))," ","")
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:查询界面元素
/// Date:2017-11-09
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindMenuElement")
Query FindMenuElement(par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindMenuElementExecute(ByRef qHandle As %Binary, par As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rw="" f  s rw=$O(^DHCNMG.Set.MgMenuElementD(par,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.Set.MgMenuElement).%OpenId(par_"||"_rw)
	.s elementId=obj.ElementCode
	.s elementDesc=obj.ElementDesc
	.s elementType=obj.ElementType
	.s ret="elementId|"_elementId_"^elementDesc|"_elementDesc_"^elementType|"_elementType_"^rowid|"_rw_"^par|"_par
	.do OutputElement
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElement
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMenuElementFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuElementExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMenuElementClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuElementExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取界面元素行数据
/// Date:2017-11-09
/// Table:DHCNMG.Set.MgMenuElement
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetElementData(par As %String, rw As %String) As %String
{
	s ret=""
	q:((par="")!(rw="")) ""
	s obj=##class(DHCNMG.Set.MgMenuElement).%OpenId(par_"||"_rw)
	s elementid=obj.ElementCode
	s elementdesc=obj.ElementDesc
	s elementtype=obj.ElementType
	s ret="elementid|"_elementid_"^elementdesc|"_elementdesc_"^elementtype|"_elementtype_"^RowID|"_rw
	q ret
}

/// Creator:gzj
/// Description:检查界面元素记录的重复性
/// Date:2017-11-09
/// Table:DHCNMG.Set.MgMenuElement
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod IsExistElement(par As %String, rw As %String, code As %String) As %String
{
	s flag=-1
	s rowid=$O(^DHCNMG.Set.MgMenuElementI("Code",par," "_$zcvt($tr(code," ",""),"U"),""))
	i rw="" d
	.i rowid="" s flag=-1
	.e  i rowid'="" s flag=2
	e  i rw'="" d
	.i rowid'="" d
	..i rowid=rw s flag=-1
	..e  i rowid'=rw s flag=2
	
	q flag
}

/// Creator:gzj
/// Description:获取权限设置菜单
/// Date:2017-11-11
/// Table:DHCNMG.Set.MgMenuElement
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetLimitMenu() As %String
{
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))!((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..s title=obj.ModuleDesc,code=obj.ModuleCode
	..i ret'="" s ret=ret_",{"_"""lbl"":"""_title_""",""id"":"""_id_"""" //""",""code"":"""_code_
	..e  s ret="{"_"""lbl"":"""_title_""",""id"":"""_id_"""" //""",""code"":"""_code_
	..s ret1=..GetLimitMenuSub("ModuleSort",id)
	..i ret1'="" s ret=ret_",""chd"":"_ret1
	..s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

/// Creator:gzj
/// Description:获取权限设置菜单列表及界面元素
/// Date:2017-11-11
/// Table:DHCNMG.Set.MgMenuElement
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetLimitMenuSub(index As %String, parid As %String) As %String
{
	q:(index="")!(parid="") ""
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgMenuI(index,parid,sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgMenuI(index,parid,sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgMenu).%OpenId(id)
	..q:((obj.MenuStDate'="")&&(obj.MenuStDate>+$h))
	..q:((obj.MenuEndDate'="")&&(obj.MenuEndDate<+$h))
	..s title=obj.MenuDesc,code=obj.MenuCode
	..q:(index="ParentSort")&&(obj.MenuParentDR'="")
	..i ret'="" s ret=ret_",{""lbl"":"""_title_""",""id"":"""_parid_"-"_id_""",""checkAll"":false,""inCheckAll"":false,""chk"":""false"",""ckall"":""[]"""
	..e  s ret="{""lbl"":"""_title_""",""id"":"""_parid_"-"_id_""",""checkAll"":false,""inCheckAll"":false,""chk"":""false"",""ckall"":""[]"""
	..s ret3="["
	..s rowid="" f  s rowid=$O(^DHCNMG.Set.MgMenuElementD(id,rowid)) q:rowid=""  d
	...s obj1=##class(DHCNMG.Set.MgMenuElement).%OpenId(id_"||"_rowid)
	...s desc=obj1.ElementDesc
	...i ret3'="[" s ret3=ret3_",{""lbl"":"""_desc_""",""id"":"""_parid_"-"_id_"-"_rowid_""""
	...e  s ret3=ret3_"{""lbl"":"""_desc_""",""id"":"""_parid_"-"_id_"-"_rowid_""""
	...s ret3=ret3_"}"
	..s ret3=ret3_"]"
	..i ret3'="[]" s ret=ret_",""chd"":"_ret3
	..s ret1=..GetLimitMenuSub("ParentSort",id)
	..i ret1'="" s ret=ret_",""chd"":"_ret1
	..s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

/// Creator:gzj
/// Description:保存角色模块
/// Date:2017-11-14
/// Table:DHCNMG.Set.MgLimitSetSub
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveLimitMoud(parr As %String, str As %String, index As %String = "") As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_$tr($g(tmp("RoleID"))," ","")," "_$tr($g(tmp("MoudID"))," ",""),""))
	i rowid'="" s id=rowid
	i id'="" s obj=##class(DHCNMG.Set.MgLimitSet).%OpenId(id)
	e  s obj=##class(DHCNMG.Set.MgLimitSet).%New()
	s obj.RoleID=$tr($g(tmp("RoleID"))," ","")
	s obj.MoudID=$tr($g(tmp("MoudID"))," ","")
	d obj.%Save()
	i obj.%Id()'="" d
	.d ..SaveLimitMenu(obj.%Id(),str)
	;.i str'="" d
	;..d ..SaveLimitMenu(obj.%Id(),str)
	;q obj.%Id()
	q index
}

/// Creator:gzj
/// Description:保存界面菜单及元素
/// Date:2017-11-14
/// Table:DHCNMG.Set.MgLimitSetSub
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveLimitMenu(par As %String, str As %String) As %String
{
	d ..ClearLimitSubData(par)
	q:str="" ""
	s len=$L(str,"@")
	f i=1:1:len
	{
		s para=$P(str,"@",i) //MenuID|1-3^Elements|1-3-2^rw|
		s l=$l(para,"^")
		s rowid=$P($P(para,"^",3),"|",2)
		s menuid=$P($P(para,"^",1),"|",2)
		s elements=$P($P(para,"^",2),"|",2)
		i rowid="" d
		.s obj=##class(DHCNMG.Set.MgLimitSetSub).%New()
		.s obj.parref=##class(DHCNMG.Set.MgLimitSet).%OpenId(par)
		e  s obj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(par_"||"_rowid)
		s obj.MenuID=menuid
		d obj.Elements.Clear()
		s elen=$l(elements,"~")
		for k=1:1:elen
		{
			s itm=$P(elements,"~",k)
			i itm'="" d
			.s sc=obj.Elements.Insert(itm)
		}
		d obj.%Save()
	}
	q 0
}

/// Creator:gzj
/// Description:根据主表id清除权限设置界面元素
/// Date:2017-11-14
/// Table:DHCNMG.Set.MgLimitSetSub
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ClearLimitSubData(par As %String) As %String
{
	s rowid="" f  s rowid=$O(^DHCNMG.Set.MgLimitSetSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(par_"||"_rowid)
	.d obj.%DeleteId(par_"||"_rowid)
	q 0
}

/// Creator:gzj
/// Description:根据安全组获取对应的模块和菜单及界面元素
/// Date:2017-11-14
/// Table:DHCNMG.Set.MgLimitSet、DHCNMG.Set.MgLimitSetSub
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetRoleMenuData1(role As %String) As %String
{
	s ret=""
	//^DHCNMG.Set.MgLimitSetI("sort"," 4"," 1",1) " 角色"," 模块" id
	//^DHCNMG.Set.MgModuleI("Sort",1,1) moudlesort,id
	s moud="" f  s moud=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,moud)) q:moud=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,moud,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.Set.MgLimitSet).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s moudid=obj.MoudID
	..s moudobj=##class(DHCNMG.Set.MgModule).%OpenId(moudid)
	..s title=moudobj.ModuleDesc
	..;i ret'="" s ret=ret_",{""lbl"":"""_title_""",""id"":"""_moudid_""""
	..;e  s ret="{""lbl"":"""_title_""",""id"":"""_moudid_""""
	..i ret'="" s ret=ret_",{""id"":"""_moudid_""""
	..e  s ret="{""id"":"""_moudid_""""
	..s ret1=..GetRoleMenu1(rowid)
	..i ret1'="" s ret=ret_",""child"":"_ret1
	..s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

/// Creator:gzj
/// Description:根据角色对应的模块记录id获取菜单及界面元素
/// Date:2017-11-14
/// Table:DHCNMG.Set.MgLimitSet、DHCNMG.Set.MgLimitSetSub
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetRoleMenu1(par As %String) As %String
{
	s ret=""
	s rowid="" f  s rowid=$O(^DHCNMG.Set.MgLimitSetSubI("Sort",par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(par_"||"_rowid)
	.i ret'="" s ret=ret_",{""id"":"""_obj.MenuID_""""
	.e  s ret=ret_"{""id"":"""_obj.MenuID_""""
	.s element=obj.Elements
	.s len=obj.Elements.Count()
	.s ret1=""
	.for i=1:1:len d
	..s itm=obj.Elements.GetAt(i)
	..i ret1'="" s ret1=ret1_",{""id"":"""_itm_""""
	..e  s ret1="{""id"":"""_itm_""""
	..i ret'="" s ret1=ret1_"}"
	.i ret1'="" s ret=ret_",""child"":["_ret1_"]"
	.s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

ClassMethod GetRoleMenuData(role As %String) As %String
{
	s tmp=""
	s ret=""
	s moud="" f  s moud=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,moud)) q:moud=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role,moud,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.Set.MgLimitSet).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s moudid=obj.MoudID
	..s moudobj=##class(DHCNMG.Set.MgModule).%OpenId(moudid)
	..q:'$IsObject(moudobj)
	..s tmp(moudid)=moudid
	..q:(moudobj.ModuleEndDate'="")&&(moudobj.ModuleEndDate<+$H)
	..s title=moudobj.ModuleDesc
	..i ret'="" s ret=ret_",{""lbl"":"""_title_""",""id"":"""_moudid_""""
	..e  s ret="{""lbl"":"""_title_""",""id"":"""_moudid_""""
	..s ret1=..GetRoleMenu(moudid,rowid)
	..i ret1'="" s ret=ret_",""chd"":"_ret1
	..s ret=ret_"}"
	
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..q:$d(tmp(id))
	..s obj=##class(DHCNMG.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))!((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..s title=obj.ModuleDesc,code=obj.ModuleCode
	..i ret'="" s ret=ret_",{"_"""lbl"":"""_title_""",""id"":"""_id_"""" //""",""code"":"""_code_
	..e  s ret="{"_"""lbl"":"""_title_""",""id"":"""_id_"""" //""",""code"":"""_code_
	..s ret1=..GetLimitMenuSub("ModuleSort",id)
	..i ret1'="" s ret=ret_",""chd"":"_ret1
	..s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

ClassMethod GetRoleMenu(moud As %String, par As %String) As %String
{
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.Set.MgModuleI("Sort",sort,rowid)) q:rowid=""  d
	..s mourobj=##class(DHCNMG.Set.MgModule).%OpenId(rowid)
	..q:'$IsObject(mourobj)
	..q:((moud'="")&&(rowid'=moud))
	..s menusort="" f  s menusort=$O(^DHCNMG.Set.MgMenuI("ModuleSort",rowid,menusort)) q:menusort=""  d
	...s menurw="" f  s menurw=$O(^DHCNMG.Set.MgMenuI("ModuleSort",rowid,menusort,menurw)) q:menurw=""  d
	....s obj=##class(DHCNMG.Set.MgMenu).%OpenId(menurw)
	....q:'$IsObject(obj)
	....q:(obj.MenuEndDate'="")&&(obj.MenuEndDate<+$H)
	....s title=obj.MenuDesc,rw=rowid_"-"_menurw
	....s check=..IsMenuChecked(par,rw)
	....s ret1="",ret2="",ret3=""
	....s elemtrw="" f  s elemtrw=$O(^DHCNMG.Set.MgMenuElementD(menurw,elemtrw)) q:elemtrw=""  d
	.....s elementobj=##class(DHCNMG.Set.MgMenuElement).%OpenId(menurw_"||"_elemtrw)
	.....q:'$IsObject(elementobj)
	.....s btndesc=elementobj.ElementDesc,btnid=rowid_"-"_menurw_"-"_elemtrw
	.....i ret3'="" s ret3=ret3_",{""lbl"":"""_btndesc_""",""id"":"""_btnid_""""
	.....e  s ret3="{""lbl"":"""_btndesc_""",""id"":"""_btnid_""""
	.....s ret3=ret3_"}"
	.....s ret2=..GetMenuElement(par,rw,rowid_"-"_menurw_"-"_elemtrw)
	.....i ret1="" s ret1="{""lbl"":"""_elementobj.ElementDesc_""",""id"":"""_rowid_"-"_menurw_"-"_elemtrw_""""
	.....e  s ret1=ret1_",{""lbl"":"""_elementobj.ElementDesc_""",""id"":"""_rowid_"-"_menurw_"-"_elemtrw_""""
	....i ret3'="" s ret3="["_ret3_"]"
	....i ret'="" s ret=ret_",{""lbl"":"""_title_""",""id"":"""_rw_""",""checkAll"":false,""inCheckAll"":false,""chk"":"""_check_""",""ckall"":""["_ret2_"]"""
	....e  s ret="{""lbl"":"""_title_""",""id"":"""_rw_""",""checkAll"":false,""inCheckAll"":false,""chk"":"""_check_""",""ckall"":""["_ret2_"]"""
	....i ret3'="" d
	.....i ret'="" s ret=ret_",""chd"":"_ret3
	....s ret=ret_"}"
	i ret'="" s ret="["_ret_"]"
	q ret
}

/// 判断菜单是否选中
ClassMethod IsMenuChecked(par As %String, rw As %String) As %String
{
	s ret=""
	s rowid=$O(^DHCNMG.Set.MgLimitSetSubI("Menu",par," "_rw,"")) 
	q:rowid="" "false"
	s ret="true"
	q ret
}

ClassMethod GetMenuElement(par As %String, rw As %String, btnrw As %String) As %String
{
	s ret=""
	s rowid=$O(^DHCNMG.Set.MgLimitSetSubI("Menu",par," "_rw,""))
	q:rowid="" ""
	s obj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(par_"||"_rowid)
	q:'$IsObject(obj)
	;s elements=obj.Elements
	s len=obj.Elements.Count()
	for i=1:1:len
	{
		s itm=obj.Elements.GetAt(i)
		i itm'="" d
		.s row=$p(itm,"-",2)_"||"_$p(itm,"-",3)
		.s btnobj=##class(DHCNMG.Set.MgMenuElement).%OpenId(row)
		.q:'$IsObject(btnobj)
		.i ret'="" s ret=ret_",'"_btnobj.ElementDesc_"'"
		.e  s ret="'"_btnobj.ElementDesc_"'"
	}
	q ret
}

/// Creator:gzj
/// Description:查询角色关联人员列表
/// Date:2017-11-16
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindRoleNurseList","","")
Query FindRoleNurseList(parr As %String = "", input As %String = "", par As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindRoleNurseListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", par As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s level=$p(parr,"^",1)
	s jobduty=$p(parr,"^",2)
	if par=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsD(rowid)) q:rowid=""  d
	.q:($d(^DHCNMG.Set.MgRoleNurseI("nurse",par," "_rowid)))
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	.q:obj.PerCareType'="N"
	.q:obj.PerTypeDR'="N"
	.s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")) ;只统计在职
	.s NurseName=obj.PerName
	.s NurseID=obj.PerID
	.s shell=##class(web.NurMgVueComm).ToChineseSpell(NurseName)
	.q:(input'="")&&((NurseName_NurseID_shell)'[$zcvt($tr(input," ",""),"U"))
	.;层级
	.s maxdate=0,NurseLevelId="",NurseLevel=""
	.s levelId="" f  s levelId=$O(^DHCNMG.HR.MgLevelI("ssid",rowid,levelId)) q:levelId=""  d
	..s levelObj=##class(DHCNMG.HR.MgLevel).%OpenId(levelId)
	..q:'$IsObject(levelObj)
	..;q:((levelObj.LevelStatus'="Y")&&(levelObj.LevelStatus'="A"))
	..q:(levelObj.LevelStatus'="A") //测试组要求没有审核的不能显示
	..q:((levelObj.LevelDate>+$h)!(maxdate>levelObj.LevelDate)!(levelObj.NurLevel=""))
	..s CodeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(levelObj.NurLevel)
	..q:('$IsObject(CodeObj))
	..s maxdate=levelObj.LevelDate,NurseLevelId=levelObj.NurLevel,NurseLevel=CodeObj.SubDesc
	.q:((level'="")&&(level'=NurseLevelId))
	.;职称
	.s maxdate=0,NurseDutyId="",NurseDuty=""
	.s dutyId="" f  s dutyId=$O(^DHCNMG.HR.MgHireDutyI("ssid",rowid,dutyId)) q:dutyId=""  d
	..s dutyObj=##class(DHCNMG.HR.MgHireDuty).%OpenId(dutyId)
	..q:'$IsObject(dutyObj)
	..q:(dutyObj.HireStatus'="A")
	..q:((dutyObj.HireStDate="")||(dutyObj.HireStDate>+$H)||((dutyObj.HireEndDate'="")&&(dutyObj.HireEndDate<+$H)))
	..q:dutyObj.HireDuty=""
	..q:(maxdate>dutyObj.HireStDate)
	..s CodeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(dutyObj.HireDuty)
	..q:'$IsObject(CodeObj)
	..s NurseDuty=CodeObj.SubDesc,maxdate=dutyObj.HireStDate,NurseDutyId=dutyObj.HireDuty
	.q:((jobduty'="")&&(jobduty'=NurseDutyId))
	.s NurseWard=""
	.s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
	.s:$IsObject(WardObj) NurseWard=WardObj.WardDesc
	.s NurseId=obj.PerID
	.s ret="NurseId|"_NurseId_"^NurseName|"_NurseName_"^NurseWard|"_NurseWard_"^NurseLevel|"_NurseLevel_"^NurseDuty|"_NurseDuty_"^rw|"_rowid
	.do OutputRoleNurseList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleNurseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRoleNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:查询管理员列表
/// Date:2018-01-11
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindManagerList","M")
Query FindManagerList(Type As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindManagerListExecute(ByRef qHandle As %Binary, Type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s type="" f  s type=$O(^DHCNMG.HR.MgPersonsI("type",type)) q:type=""  d
	.q:((Type'="")&&($tr(type," ","")'=Type))
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("type",type,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	..s rolenurse=obj.PerName
	..s roleperid=rowid
	..s rolenurseid=obj.PerID
	..s ret="label|"_rolenurse_" "_rolenurseid_"^key|"_rowid
	..do OutputManagerList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputManagerList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindManagerListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindManagerListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindManagerListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindManagerListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleNurse(parr As %String, params As %String) As %String
{
	s ret=""
	i parr="" 
	{
		s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("type"," N",rowid)) q:rowid=""  d
		.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
		.s rolenurse=obj.PerName
		.s rolelevel=""
		.s roleduty=""
		.
		.
		.i ret="" s ret="{lb:"_rolenurse_",ky:"_rowid
		.e  s ret=ret_",{lb:"_rolenurse_",ky:"_rowid
		.i ret'="" s ret=ret_"}"
		s ret="["_ret_"]"
	}
	else
	{
		
	}
	q ret
}

/// Creator:gzj
/// Description:保存角色关联人员
/// Date:2017-11-17
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveRoleNurse(parr As %String) As %String
{
	s len=$L(parr,"@")
#;	s userstr=""
#;	s rolestr=""
	s flag=1
	TS
	f i=1:1:len q:flag'=1  d
	.s itm=$P(parr,"@",i)
	.q:itm=""
	.s roleId=$P(itm,"^",1) //角色ID
	.s perid=$P(itm,"^",2) //人员ID
	.;i userstr="" s userstr=perid
	.;e  s userstr=userstr_"^"_perid
	.;s rolestr=roleId
	.s obj=##class(DHCNMG.Set.MgRoleNurse).%New()
	.s obj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
	.s obj.RoleNurse=perid
	.s obj.RoleStDate=+$h
	.s flag=flag&&$$$ISOK(obj.%Save())
	.q:flag'=1
	.;判断人员角色表中是否存在此角色的记录，如果存在则填写结束日期并在循环外重新生成一条新的记录，开始日期为当前日期
	.s date="" f  s date=$O(^DHCNMG.HR.MgNurRoleI("date",perid,date)) q:((date="")||(flag'=1))  d
	..s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("date",perid,date," "_roleId,rowid)) q:((rowid="")||(flag'=1))  d
	...s roleobj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
	...q:roleobj.RoleEndDate'=""
	...s roleobj.RoleEndDate=+$h
	...s flag=flag&&$$$ISOK(roleobj.%Save())
	.s nurobj=##class(DHCNMG.HR.MgNurRole).%New()
	.s nurobj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.s nurobj.RoleID=roleId
	.s nurobj.RoleStDate=+$h
	.s flag=flag&&$$$ISOK(nurobj.%Save())
	if flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
	//清除数据权限中不存在的人员数据权限
#;	s nurserw="" f  s nurserw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_rolestr,nurserw)) q:nurserw=""  d
#;	.;q:(userstr[$tr(nurserw," ",""))
#;	.s flag=0
#;	.s flag=..IsExistFlag(userstr,$tr(nurserw," ",""))
#;	.q:flag=1
#;	.s limitrowid="" f  s limitrowid=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_rolestr,nurserw,limitrowid)) q:limitrowid=""  d
#;	..s limitobj=##class(DHCNMG.DB.MgDataLimit).%OpenId(limitrowid)
#;	..d limitobj.%DeleteId(limitrowid)
	
	q 0
}

ClassMethod IsExistFlag(str, nurserw) As %String
{
	s flag=0
	s len=$l(str,"^")
	f i=1:1:len
	{
		i nurserw=$p(str,"^",i) s flag=1
	}
	q flag
}

ClassMethod DeleteRoleNurseData(parr As %String) As %String
{
	q:parr="" 0
	s len=$L(parr,"@")
	s flag=1,rolestr="",tmpNurse=""
	TS
	f i=1:1:len q:flag'=1  d
	.s itm=$P(parr,"@",i)
	.q:itm=""
	.s roleId=$P(itm,"^",1) //角色ID
	.s nurRoleId=$tr($P(itm,"^",2),"_","|") //人员关联角色ID
	.s obj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(nurRoleId)
	.q:'$IsObject(obj)
	.s perid=obj.RoleNurse
	.q:perid=""
	.;判断人员角色表中是否存在此角色的记录，如果存在则填写结束日期
	.s date="" f  s date=$O(^DHCNMG.HR.MgNurRoleI("date",perid,date)) q:((date="")||(flag'=1))  d
	..s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("date",perid,date," "_roleId,rowid)) q:((rowid="")||(flag'=1))  d
	...s roleobj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
	...q:roleobj.RoleEndDate'=""
	...s roleobj.RoleEndDate=+$h
	...s flag=flag&&$$$ISOK(roleobj.%Save())
	.q:flag'=1
	.s flag=flag&&$$$ISOK(obj.%DeleteId(nurRoleId))
	.q:flag'=1
	.s rolestr=roleId,tmpNurse(perid)=perid
	//清除数据权限中删除的人员数据权限
	s nurserw="" f  s nurserw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_rolestr,nurserw)) q:((nurserw="")||(flag'=1))  d
	.q:('$d(tmpNurse($tr(nurserw," ",""))))
	.s limitrowid="" f  s limitrowid=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_rolestr,nurserw,limitrowid)) q:((limitrowid="")||(flag'=1))  d
	..s limitobj=##class(DHCNMG.DB.MgDataLimit).%OpenId(limitrowid)
	..s flag=flag&&$$$ISOK(limitobj.%DeleteId(limitrowid))
	
	if flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
}

/// Creator:gzj
/// Description:查询角色已关联人员数据
/// Date:2017-11-17
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindAssRoleNurse")
Query FindAssRoleNurse(id As %String) As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindAssRoleNurseExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rowid="" f  s rowid=$O(^DHCNMG.Set.MgRoleNurseI("par",id,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(id_"||"_rowid)
	.s rw=id_"__"_rowid
	.q:'$IsObject(obj)
	.s perid=obj.RoleNurse
	.s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.q:'$IsObject(perObj)
	.s NurseName=perObj.PerName
	.s NurseWard=""
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(perObj.PerDepDR)
	.s:$IsObject(wardObj) NurseWard=wardObj.WardDesc
	.s NurseLevel=##class(web.NurMgHRComm).GetLevelDesc(perid,+$h,+$h)
	.s NurseDuty=##class(web.NurMgHRComm).GetTitleDesc(perid,+$h,+$h)
	.s NurseId=perObj.PerID
	.s ret="NurseId|"_NurseId_"^NurseName|"_NurseName_"^NurseWard|"_NurseWard_"^NurseLevel|"_NurseLevel_"^NurseDuty|"_NurseDuty_"^rw|"_rw
	.do OutputRoleNurseData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleNurseData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssRoleNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssRoleNurseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAssRoleNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssRoleNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:查询角色下的人员列表
/// Date:2017-11-18
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindRoleNurses")
Query FindRoleNurses(parr As %String = "", id As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRoleNursesExecute(ByRef qHandle As %Binary, parr As %String = "", id As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i id="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s rowid="" f  s rowid=$O(^DHCNMG.Set.MgRoleNurseI("par",id,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(id_"||"_rowid)
	.q:(obj.RoleStDate>+$H)!((obj.RoleEndDate'="")&&(obj.RoleEndDate<+$H))
	.s perid=obj.RoleNurse
	.s nursename="",nurseid=""
	.;i perid'="" d
	.s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.q:'$IsObject(PerObj)
	.s NameShell=##class(web.NurMgVueComm).ToChineseSpell(PerObj.PerName)
	.q:(parr'="")&&((PerObj.PerName_PerObj.PerID_NameShell)'[($zcvt(parr,"U")))
	.s nursename=PerObj.PerName
	.s nurseid=PerObj.PerID
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(perid,+$H)
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(curward)
	.s wardDesc=""
	.s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	.s ret="nursename|"_nursename_"^nurseid|"_nurseid_"^rw|"_perid_"^wardDesc|"_wardDesc
	.do OutputRoleNurses
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleNurses
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleNursesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleNursesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRoleNursesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleNursesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:按照类型查询护士长、科护士长等列表
/// Date:2017-12-04
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindLocHeader")
Query FindLocHeader(type As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLocHeaderExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s typ="" f  s typ=$O(^DHCNMG.Set.MgRolesI("code"," Y",typ)) q:typ=""  d
	.s id="" f  s id=$O(^DHCNMG.Set.MgRolesI("code"," Y",typ,id)) q:id=""  d
	..q:((type'="")&&(typ'=(" "_$zcvt(type,"U"))))
	..s rowid="" f  s rowid=$O(^DHCNMG.Set.MgRoleNurseI("par",id,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(id_"||"_rowid)
	...q:(((obj.RoleStDate'="")&&(obj.RoleStDate>+$h))||((obj.RoleEndDate'="")&&(obj.RoleEndDate<+$h)))
	...s nurseid=obj.RoleNurse
	...s nursename=""
	...i obj.RoleNurse'="" d
	....s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.RoleNurse)
	....q:'$IsObject(perobj)
	....s nursename=perobj.PerName
	...s ret="NurseName|"_nursename_"^rowid|"_nurseid
	...do OutputHeadList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputHeadList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocHeaderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocHeaderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocHeaderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocHeaderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 2018/01/02
/// description: 获取系统参数配置
/// table: DHCNMG.Set.MgSysParam, DHCNMG.Set.MgSysParamSub
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgSetComm).GetSysParamData()
ClassMethod GetSysParamData(parr As %String = "", input As %String = "") As %String
{
	s ret=""
	s id="" f  s id=$O(^DHCNMG.Set.MgSysParamD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Set.MgSysParam).%OpenId(id)
	.q:obj.ParamStatus="N"
	.i ret'="" s ret=ret_","
	.s ret=ret_"{""label"":"""_obj.ParamDesc_""",""value"":"""_id_""""
	.s ret1=""
	.s subid="" f  s subid=$O(^DHCNMG.Set.MgSysParamSubD(id,subid)) q:subid=""  d
	..s subobj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(id_"||"_subid)
	..q:((subobj.SubStDate'="")&&(subobj.SubStDate>+$h))||((subobj.SubEndDate'="")&&(subobj.SubEndDate<+$h))
	..i ret1'="" s ret1=ret1_","
	..s ret1=ret1_"{""label"":"""_subobj.SubDesc_""",""value"":"""_id_"__"_subid_"""}"
	.i ret1'="" s ret=ret_",""children"":["_ret1_"]}" 
	i ret'="" s ret="["_ret_"]"
	q ret
}

/// creator: xbl
/// createdate: 20180117
/// description: 保存夜查房排班信息
/// table: DHCNMG.Set.MgNHChkArrange
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveNHCArrange(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Set.MgNHChkArrange).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Set.MgNHChkArrange).%New()
	i $g(tmp("ArgDate")) s obj.ArgDate=$zdh(tmp("ArgDate"),3)
	e  s obj.ArgDate=""
	s obj.ArgType=$g(tmp("ArgType"))
	s obj.ArgPost=$g(tmp("ArgPost"))
	s obj.ArgRemark=$g(tmp("ArgRemark"))
	d obj.ArgCheckUser.Clear()
	f i=1:1:$L($g(tmp("ArgCheckUser")),",") d
	.s perdr=$P($g(tmp("ArgCheckUser")),",",i)
	.q:perdr=""
	.d obj.ArgCheckUser.Insert(perdr)
	i $g(tmp("ArgCrtUser"))'="" d
	.s obj.ArgCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ArgCrtUser"))
	e  s obj.ArgCrtUser=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod SaveNHCArranges(parr As %String) As %String
{
	q:parr="" 0
	TStart
	s flag=1
	f i=1:1:$L(parr,"@")
	{
		s parm=$P(parr,"@",i)
		continue:parm=""
		s flag=..SaveNHCArrange(parm)
		q:flag=0
	}
	i flag=0
	{
		Trollback
		q 0
	}
	TCommit
	q 1
}

/// 获取夜查房排班
ClassMethod GetNHCArrange(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgNHChkArrange).%OpenId(id)
	s ret="rw|"_id
	i obj.ArgDate'="" s ret=ret_"^ArgDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgDate)
	s ret=ret_"^ArgType|"_obj.ArgType
	s ret=ret_"^ArgWeek|"_$Case($zd(obj.ArgType,10),1:"星期一",2:"星期二",3:"星期三",4:"星期四",5:"星期五",6:"星期六",0:"星期日")
	s ret=ret_"^ArgTypeDesc|"_$case(obj.ArgType,"C":"检查表","T":"追踪表",:"")
	s ret=ret_"^ArgPost|"_obj.ArgPost
	s ret=ret_"^ArgPostDesc|"_$case(obj.ArgPost,"L":"小夜","B":"大夜")
	s ret=ret_"^ArgRemark|"_obj.ArgRemark
	s chkuser="", chkusername="", chkuserid=""
	f i=1:1:obj.ArgCheckUser.Count() d
	.s perdr=obj.ArgCheckUser.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i chkuser="" s chkuser=perdr,chkusername=perobj.PerName,chkuserid=perobj.PerID
	.e  s chkuser=chkuser_","_perdr,chkusername=chkusername_","_perobj.PerName,chkuserid=chkuserid_","_perobj.PerID
	s ret=ret_"^ArgCheckUser|"_chkuser
	s ret=ret_"^CheckUserID|"_chkuserid
	s ret=ret_"^CheckUserName|"_chkusername
	i obj.ArgCrtUser'="" d
	.s ret=ret_"^ArgCrtUser|"_obj.ArgCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.ArgCrtUser.PerName
	i obj.ArgCrtDate'="" d
	.s ret=ret_"^ArgCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgCrtDate)
	i obj.ArgCrtTime'="" d
	.s ret=ret_"^ArgCrtTime|"_$zt(obj.ArgCrtTime,2)
	q ret
}

/// 删除夜查房排班记录
ClassMethod DeleteNHCArrange(id As %String) As %String
{
	q:id="" 0
	s sc=##class(DHCNMG.Set.MgNHChkArrange).%DeleteId(id)
	q $$$ISOK(sc)
}

///  获取夜查房排班列表
/// d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindNHCArg","","")
Query FindNHCArg(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNHCArgExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$P(parr,"^",1)
	s date=$P(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s argdate="" f  s argdate=$O(^DHCNMG.Set.MgNHChkArrangeI("Date",argdate),-1) q:argdate=""  d
	.q:(date'="")&&(date'=argdate)
	.s id="" f  s id=$O(^DHCNMG.Set.MgNHChkArrangeI("Date",argdate,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Set.MgNHChkArrange).%OpenId(id)
	..q:(type'="")&&(obj.ArgType'=type)
	..s ret=..GetNHCArrange(id)
	..d OutNHKArg
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNHKArg
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNHCArgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNHCArgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNHCArgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNHCArgExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:lulin
/// createdate:2018-05-15
/// description:获取tomcat服务器配置参数
/// input:parr:获取参数
/// output:
/// other:d ##class(web.NurMgSetComm).getTomcatSet("SubDesc")
ClassMethod getTomcatSet(parr As %String = "") As %String
{
	s fId=$o(^DHCNMG.Set.MgSysParamI("Code"," TOMCATSERVICE",""))
	q:fId="" 0
	s tmp=""
	s nowDate=+$h
	s subId="" f  s subId=$o(^DHCNMG.Set.MgSysParamSubD(fId,subId)) q:subId=""  d
	.s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(fId_"||"_subId)
	.q:(obj.SubStDate'="")&&(obj.SubStDate>nowDate)
	.q:(obj.SubEndDate'="")&&(obj.SubEndDate<nowDate)
	.s p="" f  s p=$O(^oddCOM("DHCNMG.Set.MgSysParamSub","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..s value=$tr($ZOBJPROPERTY(obj,p)," ","")
	..i p["Code" s tmp(p)=$zcvt($tr(value," ",""),"U")
	..s ptype=^oddCOM("DHCNMG.Set.MgSysParamSub","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(value'="")) d
	...s tmp(p)=##class(web.NurMgHISComm).DateLogicalToHtml(value)
	..s tmp(p)=value
	s ret=0
	s:$d(tmp("SubDesc")) ret=tmp("SubDesc")
	s:(parr'="")&&($d(tmp(parr))) ret=tmp(parr)
	q ret
}

/// creator:lulin
/// createdate:2018-05-24
/// description:保存质控检查组
/// input:名称^成员^备注^rw^登录ID^登录病区^登录角色
/// output:
/// other:w ##class(web.NurMgSetComm).SaveCheckGroup("GroupDesc|测试^GroupMember|2,8,11,16^GroupRemark|测试用途^rw|^loginID|0^loginDep|^loginRoleCode|admin");
ClassMethod SaveCheckGroup(parr As %String = "") As %String
{
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:(tmp("loginID")="")||(tmp("GroupLevel")="") 0
	s level=tmp("GroupLevel")
	s levelId=""
	i (level="W")||(level="L") d
	.s objWard=##class(DHCNMG.DB.MgWard).%OpenId(tmp("loginDep"))
	.s:($IsObject(objWard))&&($IsObject(objWard.WardLocDR)) levelId=objWard.WardLocDR.%Id()
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.DB.MgQualGroup).%OpenId(tmp("rw"))
	e  s obj=##class(DHCNMG.DB.MgQualGroup).%New()
	s obj.GroupDesc=tmp("GroupDesc")
	s obj.GroupLevel=level
	s obj.GroupLevelID=levelId
	s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("loginID"))
	s obj.GroupCreater=perObj
	s obj.GroupDate=+$h
	s obj.GroupTime=$tr(+$h,",",2)
	s obj.GroupRemark=tmp("GroupRemark")
	d obj.GroupMember.Clear()
	f i=1:1:$L($g(tmp("GroupMember")),",") d
	.s perdr=$P($g(tmp("GroupMember")),",",i)
	.q:perdr=""
	.d obj.GroupMember.Insert(perdr)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator:王鹏飞
/// createdate:2019-08-27
/// description:获取角色拥有的质控检查组级别
/// input:角色ID
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindCheckGroupLevels","0")
Query FindCheckGroupLevels(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckGroupLevelsExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	k tmp
	s tmp=""
	s roleids=parr
	i roleids="" {Set qHandle=$lb(0,repid,0) Quit $$$OK}
	s len=$l(roleids,"^")
	f i=1:1:len d
	.s roleid=$p(roleids,"^",i)
	.q:roleid=""
	.s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
	.q:('$IsObject(roleObj))&&(roleid'=0)
	.i roleid=0 s roleCode="ADMIN"
	.e  s roleCode=$zcvt(roleObj.RoleCode,"U")
	.;如果登录角色为管理员、超级管理员，则返回所有检查组
	.s:(roleCode="ADMIN")||(roleCode="MANAGER") tmp("W")="病区自查",tmp("L")="科室督查",tmp("H")="护理部"
	.;如果登录角色为护士长，则返回护士长级别检查组
	.s:roleCode="NURHEAD" tmp("W")="病区自查"
	.;如果登录角色为科护士长，则返回科护士长级别检查组
	.s:(roleCode="ZNURHEAD") tmp("L")="科室督查"
	.;如果登录角色为护理部、护理部主任，则返回护理部级别检查组
	.s:(roleCode="HLB")||(roleCode="HLBZR") tmp("H")="护理部"
	s i="" f  s i=$o(tmp(i)) q:i=""  d
	.s roleDesc=tmp(i)
	.s rowId=$case(i,"W":$o(^DHCNMG.Set.MgRolesI("code"," Y"," NURHEAD","")),"L":$o(^DHCNMG.Set.MgRolesI("code"," Y"," ZNURHEAD","")),"H":$o(^DHCNMG.Set.MgRolesI("code"," Y"," HLB","")))
	.s ret="LevelCode|"_i_"^LevelName|"_roleDesc
	.d OutCheckGroupLevelsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckGroupLevelsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckGroupLevelsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckGroupLevelsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:lulin
/// createdate:2018-05-25
/// description:删除质控检查组列表
/// input:id
/// output:
/// other: w ##class(web.NurMgSetComm).deleteQualGroup(1)
ClassMethod deleteQualGroup(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.DB.MgQualGroup).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q sc
}

/// creator:lulin
/// createdate:2018-05-25
/// description:获取质控检查组
/// input:id
/// output:
/// other: w ##class(web.NurMgSetComm).getQualGroup(1)
ClassMethod getQualGroup(id As %String = "", forEdit As %String = "N") As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgQualGroup).%OpenId(id)
	q:'$IsObject(obj) ""
	s GroupDesc=obj.GroupDesc
	s GroupRemark=obj.GroupRemark
	//王鹏飞 增加检查组级别
	s GroupLevel=$case(obj.GroupLevel,"W":"病区自查","L":"科室督查","H":"护理部","":"护理部")
	s GroupMember="",MemberDesc=""
	f i=1:1:obj.GroupMember.Count() d
	.s perdr=obj.GroupMember.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.i GroupMember="" s GroupMember=perdr,MemberDesc=perobj.PerName
	.e  s GroupMember=GroupMember_","_perdr,MemberDesc=MemberDesc_","_perobj.PerName
	i forEdit="Y" s ret="GroupLevel|"_obj.GroupLevel
	e  s ret="GroupLevel|"_GroupLevel
	s ret=ret_"^GroupMember|"_GroupMember_"^MemberDesc|"_MemberDesc_"^GroupDesc|"_GroupDesc_"^GroupRemark|"_GroupRemark_"^rw|"_id

	q ret
}

/// creator:lulin
/// createdate:2018-05-25
/// description:获取质控检查组列表
/// input:登录ID^登录病区^登录角色
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindQualGroup","0^^admin","")
Query FindQualGroup(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualGroupExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s loginID=$tr($p(parr,"^",1)," ","")
	s loginDep=$tr($p(parr,"^",2)," ","")
	s loginRoleCodes=$tr($p(parr,"^",3)," ","")
	k tmp
	s tmp=""
	//王鹏飞
	q:(loginRoleCodes="")
	s len=$l(loginRoleCodes,"|")
	f i=1:1:len d
	.s roleid=$p(loginRoleCodes,"|",i)
	.q:roleid=""
	.s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
	.q:('$IsObject(roleObj))&&(roleid'=0)
	.i roleid=0 s roleCode="ADMIN"
	.e  s roleCode=$zcvt(roleObj.RoleCode,"U")
	.;如果登录角色为管理员、超级管理员，则返回所有检查组
	.i (roleCode="ADMIN")||(roleCode="MANAGER") d
	..s groupid="" f  s groupid=$o(^DHCNMG.DB.MgQualGroupD(groupid)) q:groupid=""  d
	...s tmp(groupid)=..getQualGroup(groupid)
	.;如果登录角色为护士长，则返回护士长级别检查组
	.e  i roleCode="NURHEAD"  d
	..s groupid="" f  s groupid=$o(^DHCNMG.DB.MgQualGroupI("level"," W",groupid)) q:groupid=""  d
	...s tmp(groupid)=..getQualGroup(groupid)
	.;如果登录角色为科护士长，则返回科护士长级别检查组
	.e  i (roleCode="ZNURHEAD") d
	..s groupid="" f  s groupid=$o(^DHCNMG.DB.MgQualGroupI("level"," L",groupid)) q:groupid=""  d
	...s tmp(groupid)=..getQualGroup(groupid)
	.;如果登录角色为护理部、护理部主任，则返回护理部级别检查组
	.e  i (roleCode="HLB")||(roleCode="HLBZR") d
	..s groupid="" f  s groupid=$o(^DHCNMG.DB.MgQualGroupI("level"," H",groupid)) q:groupid=""  d
	...s tmp(groupid)=..getQualGroup(groupid)
	s i="" f  s i=$o(tmp(i)) q:i=""  d
	.s ret=tmp(i)
	.d OutCheckGroupData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckGroupData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:lulin
/// createdate:2018-05-24
/// description:获取所辖可分质控检查组成员的人员信息
/// input:登录ID^登录病区^登录角色
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm",FindCheckPersons,"");
Query FindCheckPersons(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPersonsExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s loginID=$P(parr,"^",1)
	s loginDep=$P(parr,"^",2)
	//王鹏飞
	s groupLevel=$p(parr,"^",3)
	s loginRoleCodes=$p(parr,"^",4)
	if ((loginID="")||(groupLevel="")||(loginRoleCodes="")) {Set qHandle=$lb(0,repid,0) Quit $$$OK}
	k tmp
	s tmp="",ret=""
	d ..GetCheckPersons(loginID,groupLevel,loginRoleCodes,.tmp)
	s i="" f  s i=$o(tmp(i)) q:i=""  d
	.s ret=tmp(i)
	.d OutCheckPerson
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckPerson
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPersonsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPersonsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:王鹏飞
/// createdate:2019-08-24
/// description:获取所辖病区可分质控检查组成员信息
/// input:登录ID^登录角色^临时数组
/// output:
/// other:d ##class(web.NurMgSetComm).GetCheckPersons(2,"5",.tmp)
ClassMethod GetCheckPersons(perid, groupLevel, loginRoleCodes, tmp)
{
	q:(groupLevel="")||(perid="")
	s nowDate=+$h
	s nurHeadId=$o(^DHCNMG.Set.MgRolesI("code"," Y"," NURHEAD",""))
	s znurHeadId=$o(^DHCNMG.Set.MgRolesI("code"," Y"," ZNURHEAD",""))
	s codeList=$lb(nurHeadId,znurHeadId)
	s flag=0
	;如果登录ID为demo，则返回对应级别的检查人员
	i perid=0 d
	.i groupLevel="W" d
	..s persid="" f  s persid=$o(^DHCNMG.HR.MgPersonsD(persid)) q:persid=""  d
	...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(persid)
	...q:('$IsObject(perObj))||(perObj.PerID="")
	...s tmp(persid)="rw|"_persid_"^PerName|"_perObj.PerName_"("_perObj.PerID_")"
	.e  i (groupLevel="L")||(groupLevel="H") d
	..f i=1:1:$ll(codeList) d
	...s persid="" f  s persid=$o(^DHCNMG.HR.MgNurRoleI("role2"," "_$lg(codeList,i),persid)) q:persid=""  d
	....s nurRoleId="" f  s nurRoleId=$o(^DHCNMG.HR.MgNurRoleI("role2"," "_$lg(codeList,i),nurRoleId)) q:nurRoleId=""  d
	.....s nurRoleObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRoleId)
	.....q:('$IsObject(nurRoleObj))
	.....q:(nurRoleObj.RoleStDate>nowDate)
	.....q:(nurRoleObj.RoleEndDate'="")&&(nurRoleObj.RoleEndDate<nowDate)
	.....s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(persid)
	.....q:('$IsObject(perObj))||(perObj.PerID="")
	.....s tmp(persid)="rw|"_persid_"^PerName|"_perObj.PerName_"("_perObj.PerID_")"
	;如果登录ID不是demo，则返回根据检查组类型和角色返回对应级别的检查人员
	e  d
	.f i=1:1:$l(loginRoleCodes,"@") d
	..s roleid=$p(loginRoleCodes,"@",i)
	..;如果检查组类型为W，则返回角色所辖病区所有人
	..i groupLevel="W"  d
	...s limitId="" f  s limitId=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleid," "_perid,limitId)) q:limitId=""  d
	....s limitSubId="" f  s limitSubId=$O(^DHCNMG.DB.MgDataLimitSubD(limitId,limitSubId)) q:limitSubId=""  d
	.....s limitSubObj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(limitId_"||"_limitSubId)
	.....q:('$IsObject(limitSubObj))
	.....s persid="" f  s persid=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_limitSubObj.SubWard,persid)) q:persid=""  d
	......s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(persid)
	......q:('$IsObject(perObj))||(perObj.PerID="")
	......s tmp(persid)="rw|"_persid_"^PerName|"_perObj.PerName_"("_perObj.PerID_")"
	..;如果检查组类型为L、H，则返回角色所辖病区护士长、科护士长
	..e  i (groupLevel="L")||(groupLevel="H") d
	...s limitId="" f  s limitId=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleid," "_perid,limitId)) q:limitId=""  d
	....s limitSubId="" f  s limitSubId=$O(^DHCNMG.DB.MgDataLimitSubD(limitId,limitSubId)) q:limitSubId=""  d
	.....s limitSubObj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(limitId_"||"_limitSubId)
	.....q:('$IsObject(limitSubObj))
	.....s persid="" f  s persid=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_limitSubObj.SubWard,persid)) q:persid=""  d
	......s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(persid)
	......q:('$IsObject(perObj))
	......f j=1:1:$ll(codeList) d
	.......s nurRoleId2="" f  s nurRoleId2=$O(^DHCNMG.HR.MgNurRoleI("role",persid," "_$lg(codeList,j),nurRoleId2)) q:nurRoleId2=""  d
	........s nurRoleObj2=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRoleId2)
	........q:('$IsObject(nurRoleObj2))
	........q:(nurRoleObj2.RoleStDate>nowDate)
	........q:(nurRoleObj2.RoleEndDate'="")&&(nurRoleObj2.RoleEndDate<nowDate)
	........s limitId2="" f  s limitId2=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_$lg(codeList,j)," "_persid,limitId2)) q:limitId2=""  d
	.........s limitSubId2="" f  s limitSubId2=$O(^DHCNMG.DB.MgDataLimitSubD(limitId2,limitSubId2)) q:limitSubId2=""  d
	..........i $list(^DHCNMG.DB.MgDataLimitSubD(limitId2,limitSubId2),2)=limitSubObj.SubWard  d
	...........q:(perObj.PerID="")
	...........s tmp(persid)="rw|"_persid_"^PerName|"_perObj.PerName_"("_perObj.PerID_")"
}

/// creator:lulin
/// createdate:2018-05-24
/// description:获取大科所辖可分质控检查组的人员ID临时数组
/// input:登录ID,登录角色Code,tmp
/// output:
/// other:
ClassMethod getCheckPersonTmp(loginID, loginRoleCode, tmp) As %String
{
	
	q:(loginID="")||(loginRoleCode="") 0	
	s tmpWard=""
	i loginRoleCode="ZNURHEAD" d
	.s roleid="" f  s roleid=$o(^DHCNMG.DB.MgDataLimitI("Role",roleid)) q:roleid=""  d
	..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId($tr(roleid," ",""))
	..q:'$IsObject(roleObj)
	..q:($zcvt($tr(roleObj.RoleCode," ",""),"U")'="ZNURHEAD")
	..s limitId="" f  s limitId=$O(^DHCNMG.DB.MgDataLimitI("Role",roleid," "_loginID,limitId)) q:limitId=""  d
	...s limitSubId="" f  s limitSubId=$O(^DHCNMG.DB.MgDataLimitSubD(limitId,limitSubId)) q:limitSubId=""  d
	....s limitSubObj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(limitId_"||"_limitSubId)
	....q:'$IsObject(limitSubObj)
	....s tmpWard(limitSubObj.SubWard)=limitSubObj.SubWard
	.s limitId="" f  s limitId=$O(^DHCNMG.DB.MgDataLimitD(limitId)) q:limitId=""  d
	..s limitObj=##class(DHCNMG.DB.MgDataLimit).%OpenId(limitId)
	..q:('$IsObject(limitObj))&&(limitObj.LimitRole'="")
	..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(limitObj.LimitRole)
	..q:'$IsObject(roleObj)
	..s RoleCode=$zcvt($tr(roleObj.RoleCode," ",""),"U")
	..q:((RoleCode'="ZNURHEAD")&&(RoleCode'="NURHEAD"))
	..s limitSubId="" f  s limitSubId=$O(^DHCNMG.DB.MgDataLimitSubD(limitId,limitSubId)) q:limitSubId=""  d
	...s limitSubObj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(limitId_"||"_limitSubId)
	...q:'$IsObject(limitSubObj)
	...q:'$d(tmpWard(limitSubObj.SubWard))
	...s tmp(limitObj.LimitNurse)=limitObj.LimitNurse
	q 1
}

/// creator:lulin
/// createdate:2018-05-28
/// description:检查某人是否在某质控检查组
/// input:用户id，安全组id
/// output:
/// other:
ClassMethod IsPerInCheckGroup(perid As %String = "", groupid As %String = "") As %String
{
	q:(groupid="")||(perid="") 0
	s obj=##class(DHCNMG.DB.MgQualGroup).%OpenId(groupid)
	q:'$IsObject(obj) 0
	s ret=0
	f i=1:1:obj.GroupMember.Count() q:ret=1  d
	.s:obj.GroupMember.GetAt(i)=perid ret=1
	q ret
}

/// creator:lulin
/// createdate:2018-06-19
/// description:获取质控标准导出数据
/// table:DHCNMG.DB.MgQualItem,DHCNMG.DB.MgQualItemSub
/// input:质控标准ID
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindExportQualData","1")
Query FindExportQualData(id As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindExportQualDataExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if id="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k tmp
	s sortLength=0,sortTimes=10
	s subid="" f  s subid=$O(^DHCNMG.DB.MgQualItemSubD(id,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id_"||"_subid)
	.q:'$IsObject(obj)
	.q:obj.SubSort=""
	.s tSortLength=$l(obj.SubSort,".")
	.s:tSortLength>sortLength sortLength=tSortLength
	.i tSortLength'=1 d
	..s:$p(obj.SubSort,".",tSortLength)>sortTimes sortTimes=$p(obj.SubSort,".",tSortLength)
	s subid="" f  s subid=$O(^DHCNMG.DB.MgQualItemSubD(id,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(id_"||"_subid)
	.q:'$IsObject(obj)
	.q:obj.SubSort=""
	.s sort=0
	.f i=1:1:$l(obj.SubSort,".") d
	..s multiple=((sortLength-i)*sortTimes)
	..s:multiple=0 multiple=1
	..s sort=sort+(($p(obj.SubSort,".",i))*multiple)
	.s tmp(sort)=id_"||"_subid
	if '$d(tmp) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ret=""
	s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
	.s subid=tmp(sort)
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(subid)
	.s stdate=obj.SubStDate
	.s:stdate'="" stdate=##class(web.NurMgHISComm).DateLogicalToHtml(stdate)
	.s enddate=obj.SubEndDate
	.s:enddate'="" enddate=##class(web.NurMgHISComm).DateLogicalToHtml(enddate)
	.s score=obj.SubScore
	.s:$d(^DHCNMG.DB.MgQualItemSubI("par"," "_subid)) score=""
	.s ret="sort|"_obj.SubSort_"^desc|"_obj.SubDesc_"^standard|"_obj.SubStandard_"^stdate|"_stdate_"^enddate|"_enddate_"^score|"_score
	.d OutExportQualData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutExportQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExportQualDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExportQualDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindExportQualDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExportQualDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:lulin
/// createdate:2018-06-21
/// description:保存导入质控标准子项
/// table:DHCNMG.DB.MgQualItem,DHCNMG.DB.MgQualItemSub
/// input:
/// output:
/// other:w ##class(web.NurMgSetComm).SaveImporQualSubData("sort|1.0.1^desc|抢救车清洁无尘土^standard|^stdate|^enddate|^score|2^parsort|1.0^rw|26")
ClassMethod SaveImporQualSubData(parr) As %String
{
	//sort|1.0^desc|急救车管理要求^standard|^stdate|^enddate|^score|^parsort|1^rw|21
	//sort|5.0.5^desc|5.5护理人员对跌倒坠床发生后上报处理流程知晓率^standard|^stdate|2019-01-01^enddate|^score|4^parsort|5.0^rw|16^index|25
	//sort|1.0^desc|急救车管理要求^standard|^stdate|^enddate|^score|^parsort|1^rw|21
	//sort|1.0.4^desc|责任护士掌握患者主要阳性体征^standard|^stdate|^enddate|^score|3^parsort|1.0^rw|1^index|4
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s parObj=##class(DHCNMG.DB.MgQualItem).%OpenId(tmp("rw"))
	TS
	s isExist=0,parid="",tId=""
	//查看是否已存在即其父节点id
	s id="" f  s id=$O(^DHCNMG.DB.MgQualItemSubD(tmp("rw"),id)) q:((id="")||(isExist=1))  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(tmp("rw")_"||"_id)
	.i (obj.SubSort=$g(tmp("parsort")))&&(obj.SubSort'=tmp("sort")) s parid=tmp("rw")_"||"_id
	.q:obj.SubSort'=tmp("sort")
	.s isExist=1,tId=tmp("rw")_"||"_id
	s flag=1
	i isExist=0 d
	.i (parid="")&&($L($g(tmp("parsort")),".")>1)  d
	..s upObj=##class(DHCNMG.DB.MgQualItemSub).%New()
	..s upObj.Parref=parObj
	..s upObj.SubSort=$g(tmp("parsort"))
	..s sc=upObj.%Save()
	..s flag=(flag&&$$$ISOK(sc))
	..i flag s parid=upObj.%Id()
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%New()
	.s obj.SubSort=tmp("sort")
	.s obj.Parref=parObj
	.s obj.SubPar=parid
	e  d
	.s obj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(tId)
	s IsScore=1
	s obj.SubDesc=$g(tmp("desc"))
	s obj.SubStandard=$g(tmp("standard"))
	if flag'=1{
		tro
		 d parObj.%DeleteId(tmp("rw"))
		q 1	
	}
	s:$g(tmp("score")) obj.SubScore=+$g(tmp("score"))
	s stdate=$g(tmp("stdate"))
	i stdate d 
	.s:stdate["/" stdate=$replace(parr,"/","-")
	.s obj.SubStDate=$zdh(stdate,3)
	s enddate=$g(tmp("enddate"))
	i enddate d 
	.s:enddate["/" enddate=$replace(parr,"/","-")
	.s obj.SubEndDate=$zdh(tmp("enddate"),3)
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i (flag)&&($g(tmp("score"))) d
	.s flag=..CalcuScore(tmp("rw"),obj.SubPar)
	if flag
	{
		TC
		q tmp("index")
	}else{
		Tro
		d parObj.%DeleteId(tmp("rw"))
		q "-1"
	}
}

/// Date:2018-06-28
/// Table:DHCNMG.Set.MgSysParamSub
/// Input:
/// Output：
/// Return:
ClassMethod SysParamSubSort(rowid As %String, type As %String) As %String
{
	q:rowid="" ""
	s ret=0
	s par=$p(rowid,"__",1)
	s rw=$p(rowid,"__",2)
	
	s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(par_"||"_rw)
	s sort=obj.SubSort
	
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.SubSort=sort-1
		.s row=$O(^DHCNMG.Set.MgSysParamSubI("Sort",par,sort-1,""))
		.s bobj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^DHCNMG.Set.MgSysParamSubI("Sort",par,""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.SubSort=sort+1
		.s row=$O(^DHCNMG.Set.MgSysParamSubI("Sort",par,sort+1,""))
		.s bobj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:gzj
/// Description:获取系统参数子项序号
/// Date:2018-06-28
/// Table:DHCNMG.Set.MgSysParamSub
/// Input:
/// Output：
/// Return:
ClassMethod SetParamSubSort(par As %String) As %String
{
	s n=1
	s sort="" f  s sort=$O(^DHCNMG.Set.MgSysParamSubI("Sort",par,sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^DHCNMG.Set.MgSysParamSubI("Sort",par,sort,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(par_"||"_rw)
	..i obj.SubSort'="" s n=n+1
	q n
}

/// creator: lulin
/// createDate: 2018-07-09
/// description: 获取辖区
/// table: 
/// input:登录角色、登录用户名、护理部人辖区是否考虑（0:护理部/管理拥有所有病区,1:算护理部人辖区），临时数组
/// output:是否是大于护理部权限，辖区病区
/// other:
ClassMethod setLoginWard(role, nurseid, type, tmpWard) As %String
{
	k tmpWard
	s roleflag=0
	f i=1:1:$l(role,"^") q:roleflag=1  d
	.s trole=$p(role,"^",i)
	.q:trole=""
	.i trole'=0 d
	..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(trole)
	..i $IsObject(roleObj) d
	...s code=$zcvt(roleObj.RoleCode,"U")
	...;超级管理员，管理员，护理部主任
	...i code="ADMIN" d
	....s roleflag=1
	....;护理部人员
	...i (((code="MANAGER")||(code="HLBZR")||(code="HLB"))&&(type=0)) d
	....s roleflag=1
	.e  s roleflag=1
	.q:roleflag=1
	.s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_trole," "_nurseid,rolerw)) q:rolerw=""  d
	..s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
	...s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
	...s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	....s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
	.....q:(id'=roledepobj.SubWard)
	.....s tmpWard(id)=id	
	s curward=##class(web.NurMgHRComm).GetCurrentWard(nurseid,+$h)
	s:(curward'="")&&('$d(tmpWard(curward))) tmpWard(curward)=curward	
	q roleflag
}

/// creator: lulin
/// createDate: 2018-12-10
/// description: 某人是否具有某角色
/// table: 
/// input:
/// output:
/// other:
ClassMethod IsNurInRole(id, parr) As %String
{
	q:(id="")!(parr="") 0
	q:id=0 1
	s parr=","_$ZCVT(parr,"U")_","
	s flag=0
	s roleId="" f  s roleId=$O(^DHCNMG.Set.MgRoleNurseI("Record"," "_id,roleId)) q:(roleId="")||(flag=1)  d
	.s obj=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
	.q:'$IsObject(obj)
	.i parr[(","_$zcvt(obj.RoleCode,"U")_",")  s flag=1
	q flag
}

/// creator: lulin
/// createDate: 2018-12-10
/// description: 获取登陆者所在院区id，如果没有则为空
/// table: 
/// input:
/// output:
/// other:
ClassMethod loginHospitalId(loginId) As %String
{
	q:loginId=0 "2"
	s curward=##class(web.NurMgHRComm).GetCurrentWard(loginId,+$H)
	q:curward="" ""
	s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(curward)
	q:'$IsObject(wardObj) ""
	q:'$IsObject(wardObj.CTHospitalDR) ""
	q wardObj.CTHospitalDR.%Id()
}

/// Creator:gzj
/// CreateDate:2019-02-18
/// Description:保存夜班系数及夜班费单价
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod SaveNightFeeData(parr As %String) As %String
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistNightFee(parr)
	q:flag=1 "记录已经存在"
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.Set.MgNightFeeFactor).%New()
	e  s obj=##class(DHCNMG.Set.MgNightFeeFactor).%OpenId(id)
	s obj.Ward=$g(tmp("Ward"))
	s obj.Post=$g(tmp("Post"))
	s obj.Factor=$g(tmp("Factor"))
	s obj.Price=$g(tmp("Price"))
	s obj.Type=$g(tmp("Type"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// CreateDate:2019-02-18
/// Description:判断记录是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistNightFee(parr As %String) As %String
{
	s flag=0
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s type=$g(tmp("Type"))
	s ward=$g(tmp("Ward"))
	s post=$g(tmp("Post"))
	
	s rw=$o(^DHCNMG.Set.MgNightFeeFactorI("flag"," "_type," "_ward," "_post,""))
	i id="" d
	.i rw'="" s flag=1
	.e  i rw="" s flag=0
	e  i id'=""  d
	.i rw="" s flag=0
	.e  i rw'="" d
	..i id=rw s flag=0
	..e  i id'=rw s flag=1
	
	q flag
}

/// Creator:gzj
/// CreateDate:2019-02-19
/// Description:
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindNightFactor","")
Query FindNightFactor(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNightFactorExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s postid=$p(parr,"^",1),wardid=$p(parr,"^",2)
	s NurType="" f  s NurType=$o(^DHCNMG.Set.MgNightFeeFactorI("flag",NurType)) q:NurType=""  d
	.s NurWard="" f  s NurWard=$o(^DHCNMG.Set.MgNightFeeFactorI("flag",NurType,NurWard)) q:NurWard=""  d
	..s NurPost="" f  s NurPost=$o(^DHCNMG.Set.MgNightFeeFactorI("flag",NurType,NurWard,NurPost)) q:NurPost=""  d
	...s RowID="" f  s RowID=$o(^DHCNMG.Set.MgNightFeeFactorI("flag",NurType,NurWard,NurPost,RowID)) q:RowID=""  d
	....s obj=##class(DHCNMG.Set.MgNightFeeFactor).%OpenId(RowID)
	....q:'$IsObject(obj)
	....q:((wardid'="")&&(wardid'=obj.Ward))
	....s Ward=""
	....i obj.Ward'="" d
	.....s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.Ward)
	.....q:'$IsObject(WardObj)
	.....s Ward=WardObj.WardDesc
	....q:((postid'="")&&(postid'=obj.Post))
	....s Post=""
	....i obj.Post="P" s Post="P班"
	....e  i obj.Post="N" s Post="N班"
	....e  i obj.Post="K" s Post="K班"
	....e  i obj.Post="LN" s Post="上夜班"
	....e  i obj.Post="RN" s Post="下夜班"
	....e  i obj.Post="AN" s Post="全夜班"
	....e  i obj.Post="" s Post=""
	....s Factor=$fn(obj.Factor,"",2)
	....s Price=$fn(obj.Price,"",2)
	....s Type=""
	....i obj.Type="N" s Type="正式"
	....e  i obj.Type="S" s Type="进修"
	....e  i obj.Type="P" s Type="实习"
	....e  i obj.Type="W" s Type="护理员"
	....e  i obj.Type="G" s Type="工人"
	....e  i obj.Type="A" s Type="助理护士"
	....e  i obj.Type="T" s Type="护理学员"
	....s ret="Ward|"_Ward_"^Post|"_Post_"^Factor|"_Factor_"^Price|"_Price_"^Type|"_Type_"^RowID|"_RowID
	....d OutNightFee
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNightFee
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNightFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNightFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNightFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNightFactorExecute ]
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

/// Creator:gzj
/// CreateDate:2019-02-19
/// Description:获取夜班费数据
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetNightFee(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgNightFeeFactor).%OpenId(id)
	q:'$IsObject(obj) ""
	s Post=obj.Post
    s Ward=obj.Ward
    i obj.Factor'="" s Factor=$fn(obj.Factor,"",2)
    e  s Factor="0.00"
    i obj.Price'="" s Price=$fn(obj.Price,"",2)
    e  s Price="0.00"
    s Type=obj.Type
    s ret="Post|"_Post_"^Ward|"_Ward_"^Factor|"_Factor_"^Price|"_Price_"^Type|"_Type_"^RowID|"_id
    q ret
}

/// Creator:gzj
/// CreateDate:2019-02-19
/// Description:删除夜班费数据
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod DelNightFee(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Set.MgNightFeeFactor).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

ClassMethod GetArgTimeSlot() As %String
{
	s flag="false"
	s rw=$o(^DHCNMG.Set.MgArgParamSetD(""))
	q:rw="" flag
	s obj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(rw)
	q:'$IsObject(obj) flag
	s flag=obj.ArgTimeSlot
	q flag
}

/// Creator: 王聪聪
/// Date: 2019-09-06
/// Desc: 新建或保存考核项目父表
/// debug：w ##class(web.NurMgSetComm).SaveAssessItem("AssessCode|ontrainAssess^AssessDesc|试用期护士考核评分表^AssessType|OnTrialNur^RowID|")
ClassMethod SaveAssessItem(parr)
{
	s res=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:(tmp("RowID")="")&&(..AssessDescIsExist(tmp("AssessType"),tmp("AssessDesc"))) 3
	i tmp("RowID")=""  d
	.s obj=##class(DHCNMG.DB.MgAssessItem).%New()
	e  d
	.s obj=##class(DHCNMG.DB.MgAssessItem).%OpenId(tmp("RowID"))
	.q:'$IsObject(obj)
	s obj.AssessCode=tmp("AssessCode")
	s obj.AssessDesc=tmp("AssessDesc")
	i tmp("AssessScore")'="" s obj.AssessScore=tmp("AssessScore")
	e  s obj.AssessScore=0
	d obj.AssessTypeSetObjectId($tr(tmp("AssessType"),"__","||"))
	s obj.AssessYear=+$zd($h,3)
	s res=obj.%Save()
	q obj.%Id()
}

/// Creator: 王聪聪
/// Date: 2019-09-06
/// Desc: 查询考核项目父表
/// Input：parr(年份^考核类型^)
/// Debug: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindAssessItemsList","^^")
Query FindAssessItemsList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssessItemsListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s yearParam=$tr($p(parr,"^",1)," ","")
	s typeParam=$tr($p(parr,"^",2),"__","||")
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgAssessItemD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgAssessItem).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:((yearParam'="")&&(obj.AssessYear'=yearParam))
	.q:((typeParam'="")&&(obj.AssessType.%Id()'=typeParam))
	.s AssessCode=$zcvt(obj.AssessCode,"U")
	.s AssessDesc=obj.AssessDesc
	.s AssessType=obj.AssessType.SubDesc
	.s AssessYear=obj.AssessYear
	.s AssessScore=obj.AssessScore
	.s:AssessScore="" AssessScore=0
	.s ret="AssessYear|"_AssessYear_"^AssessDesc|"_AssessDesc_"^AssessType|"_AssessType_"^AssessCode|"_AssessCode_"^rowid|"_rowid_"^AssessScore|"_AssessScore_"^AssessTyperw|"_obj.AssessType
	.do OutQualData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssessItemsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssessItemsListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAssessItemsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssessItemsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 王聪聪
/// Date: 2019-09-09
/// Desc: 通过ID获取考核项目父表信息
/// Debug：w ##class(web.NurMgSetComm).GetAssessItem(1)
ClassMethod GetAssessItem(id)
{
	s obj=##class(DHCNMG.DB.MgAssessItem).%OpenId(id)
	s assesscode=obj.AssessCode
	s assessdesc=obj.AssessDesc
	s assesstype=$tr(obj.AssessType.%Id(),"||","__")
	s assessscore=obj.AssessScore
	s:assessscore="" assessscore=0
	s ret="AssessCode|"_assesscode_"^AssessScore|"_assessscore_"^AssessDesc|"_assessdesc_"^AssessType|"_assesstype_"^RowID|"_obj.%Id()
	q ret
}

/// Creator: 王聪聪
/// Date: 2019-09-09
/// Desc: 删除考核项目父表信息
/// Output：1：删除成功  2：项目已被使用  0：删除失败
/// Debug：w ##class(web.NurMgSetComm).DeleteAssess(1)
ClassMethod DeleteAssess(id)
{
	s obj=##class(DHCNMG.DB.MgAssessItem).%OpenId(id)
	q:'$IsObject(obj)
	s flag=..CheckAssessItemUsed(id)
	i 'flag d
	.s flag=obj.%DeleteId(id)
	q flag
}

/// Creator: 王聪聪
/// Date: 2019-09-09
/// Desc: 检查考核项目是否使用过
/// Input：id：考核项目id
/// Output: 2：使用过  0：未使用
/// Debug：w ##class(web.NurMgSetComm).CheckAssessItemUsed(1)
ClassMethod CheckAssessItemUsed(id)
{
	s used=$O(^DHCNMG.DB.MgAssessModelI("type",id,""))
	
	i used'=""
	{
		q 2	
	} 
	else
	{
		q 0
	}
}

/// Creator:王聪聪
/// Description:获取考核子表树的数组。
/// others:字符串超长处理，将返回值分开使用w，最后返回""
ClassMethod GetAssessTree(par) As %Text
{
	w "["
	s tmp=""
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgAssessItemSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(par_"||"_rowid)
	.s subScore=obj.SubScore
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.;仅获取第一层（一级质控），SubPar为空的。根据此节点依次获取子节点。
	.q:subPar'=""
	.s tmp(1,$p(obj.SubSort,"."))=rowid_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(1,sort)) q:sort=""  d
	.i IsExist w ","
	.s rowid=$p(tmp(1,sort),"^")
	.s subDesc=$p(tmp(1,sort),"^",2)
	.w "{"_"""id"""_":"""_par_"||"_rowid_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetAssessSubItems(par,rowid,2)
	.w "}"
	.s IsExist=1
	w "]"
	q ""
}

/// 回调函数获取子节点
ClassMethod GetAssessSubItems(parid, rowid, level) As %Text
{
	w "["
	k tmp(level)
	;s now=+$now()
	s rw="" f  s rw=$O(^DHCNMG.DB.MgAssessItemSubI("par"," "_parid_"||"_rowid,parid,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parid_"||"_rw)
	.q:(obj.SubPar'=(parid_"||"_rowid))
	.;q:(obj.SubStDate>now)||((obj.SubEndDate'="")&&(obj.SubEndDate<now))
	.s subStandard=obj.SubStandard
	.s subScore=obj.SubScore
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.s tmp(level,$p(obj.SubSort,".",$l(obj.SubSort,".")))=rw_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(level,sort)) q:sort=""  d
	.i IsExist w ","
	.s rw=$p(tmp(level,sort),"^")
	.s subDesc=$p(tmp(level,sort),"^",2)
	.w "{"_"""id"""_":"""_parid_"||"_rw_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetAssessSubItems(parid,rw,level+1)
	.w "}"
	.s IsExist=1
	w "]"
}

/// Creator:王聪聪
/// Date:2019-09-10
/// Description:插入节点 在原有节点上方插入  禁止在树的根节点上插入
/// 
/// d ##class(web.NurMgSetComm).InsertAssessNode("SubDesc|测试2^SubStandard|测试2^SubScore|2^SubStDate|^SubEndDate|^SubPar|8||6^SubSort|3")
ClassMethod InsertAssessNode(parr As %String) As %String
{
	s parr=$replace(parr,"\","\\")
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId($tr(tmp("SubPar")," ",""))
	q:'$IsObject(obj) ""
	s oldSort=obj.SubSort
	s Par=+$g(tmp("SubPar"))
	s oldPar=obj.SubPar
	TS
	s flag=1
	s level=$g(tmp("SubSort"))
	i level=2
	{
		
		//查找根节点下有多少二级节点 循环二级节点进行sort数据的修改
		//在循环内部执行该节点下的子节点的数据
		 s rw="" f  s rw=$o(^DHCNMG.DB.MgAssessItemSubI("par"," ",Par,rw))  q:rw=""  d
		 .s parObj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(Par_"||"_rw)
		 .q:'$IsObject(parObj)
		 .s parSort=parObj.SubSort
		 .q:(+parSort)<(+oldSort)
		 .s parObj.SubSort=(+parSort+1)_".0"
		 .s flag=..UpdateAssessChild(Par_"||"_rw,level,((+parSort)+1))
		 .s parSc=parObj.%Save()
		 .d $System.Status.DisplayError(parSc)
		 .s flag=($$$ISOK(parSc)&&flag)
		
	}
	elseif(level>2)
	{
		//首先要取到对应节点的父节点
		//找到要修改的记录 然后判断该节点是否有子节点 如有 则计算子节点的sort
		
		 s rw="" f  s rw=$o(^DHCNMG.DB.MgAssessItemSubI("par"," "_oldPar,Par,rw))  q:rw=""  d
		 .s parObj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(Par_"||"_rw)
		 .q:'$IsObject(parObj)
		 .s parSort=parObj.SubSort
		 .s currentNum=$p(parObj.SubSort,".",level,level)
		 .q:currentNum<$p(oldSort,".",level)
		 .s newLevel=$l(parObj.SubSort,".")
		 .s parObj.SubSort=$p(oldSort,".",1,level-1)_"."_($p(parSort,".",level)+1)_$case($p(parSort,".",(level+1),$l(parSort))>0,$p(parSort,".",(level+1),$l(parSort)):("."_$p(parSort,".",(level+1),$l(parSort))),:"")
		 .i $o(^DHCNMG.DB.MgAssessItemSubI("par"," "_(Par_"||"_rw),""))'="" d
		 ..s flag=..UpdateAssessChild(Par_"||"_rw,newLevel,$p(parSort,".",level)+1)
		 .s parSc=parObj.%Save()
		 .s flag=($$$ISOK(parObj)&&flag)
		
	}
	s newObj=##class(DHCNMG.DB.MgAssessItemSub).%New()
	s newObj.Parref=##class(DHCNMG.DB.MgAssessItem).%OpenId(+$tr(tmp("SubPar")," ",""))
	s newObj.SubDesc=$tr($g(tmp("SubDesc"))," ","")
	s newObj.SubStandard=$g(tmp("SubStandard"))
	s newObj.SubScore=+$g(tmp("SubScore"))
	s newObj.SubPar=oldPar
	
	i $g(tmp("SubStDate")) s newObj.SubStDate=$zdh(tmp("SubStDate"),3)
	i $g(tmp("SubEndDate")) s newObj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	s newObj.SubSort=oldSort
	s sc=newObj.%Save()
	d $System.Status.DisplayError(sc)
	s flag=($$$ISOK(sc)&&flag)
	i (flag=1)&&(+$g(tmp("SubScore"))>0) d
	.s flag=((..CalcuAssessScore(+tmp("SubPar"),newObj.SubPar))&&(flag))
	i flag=1
	{
		tc
	}
	else
	{
		tro
	}
	q flag
}

/// Creator:王聪聪
/// Date:2019-09-10
/// Description:修改节点的sort
/// 
ClassMethod UpdateAssessChild(par As %String, level As %String, sort As %String) As %String
{
	//UpdateAssessChild("父节点",level)
	s flag=1
	s subRw="" f  s subRw=$o(^DHCNMG.DB.MgAssessItemSubI("par"," "_par,+par,subRw)) q:subRw=""  d
	.s subObj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(+par_"||"_subRw)
	.s oldSubSort=subObj.SubSort
	.s newLevel=$l(subObj.SubSort,".")
	.i level=2 d
	..s currentNum=$p(subObj.SubSort,".",level-1,level-1)
	..;q:currentNum<sort
	..i $o(^DHCNMG.DB.MgAssessItemSubI("par"," "_(+par_"||"_subRw),""))'="" d ..UpdateAssessChild(+par_"||"_subRw,level,sort)
	..s subObj.SubSort=sort_"."_$p(oldSubSort,".",2,$l(oldSubSort))
	..s sc=subObj.%Save()
	..s flag=($$$ISOK(sc)&&flag)
	.e  i level>2 d
	..s currentNum=$p(subObj.SubSort,".",level,level)
	..;q:((flag=1)&&(currentNum<sort))
	..i $o(^DHCNMG.DB.MgAssessItemSubI("par"," "_(+par_"||"_subRw),""))'="" d
	...d ..UpdateChild(+par_"||"_subRw,level,sort)
	..s subObj.SubSort=$p(oldSubSort,".",1,level-1)_"."_($p(oldSubSort,".",level,level)+1)_$case(+($p(oldSubSort,".",(level+1),$l(oldSubSort)))>0,$p(oldSubSort,".",(level+1),$l(oldSubSort)):("."_$p(oldSubSort,".",(level+1),$l(oldSubSort))))
	..s sc=subObj.%Save()
	..s flag=($$$ISOK(sc)&&flag)
	q flag
}

/// Creator:王聪聪
/// Description:计算考核分数并修改
/// Date:2019-09-10
/// Table: DHCNMG.DB.MgAssessItemSub
/// Input:添加、修改节点的父节点id
/// Output：
/// Return:
ClassMethod CalcuAssessScore(par, id As %String) As %String
{
	s total=0
	if id="" 
	{
		s rw="" f  s rw=$O(^DHCNMG.DB.MgAssessItemSubD(par,rw)) q:rw=""  d
		.s subobj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(subobj)
		.q:subobj.SubPar'=""
		.s subscore=subobj.SubScore
		.s:subscore="" subscore=0
		.s total=total+subscore
		s parobj=##class(DHCNMG.DB.MgAssessItem).%OpenId(par)
		q:'$IsObject(parobj) 2
		s parobj.AssessScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
	}
	else
	{
		s parobj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(id)
		q:'$IsObject(parobj) 2
		s total=..GetAssessItemScore(id)
		s parobj.SubScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
		s:flag flag=..CalcuAssessScore(par,parobj.SubPar)
	}
	q flag
}

/// Creator:王聪聪
/// Description:获取质控检查项子节点分数之和
/// Date:2019-09-10
/// Table: DHCNMG.DB.MgAssessItemSub
/// Input:父节点id
/// Output：
/// Return:
ClassMethod GetAssessItemScore(parid) As %String
{
	s score=0
	s par=+$g(parid)
	s rw="" f  s rw=$o(^DHCNMG.DB.MgAssessItemSubI("par"," "_parid,par,rw)) q:rw=""  d
	.s subobj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(subobj)
	.s subscore=subobj.SubScore
	.s:subscore="" subscore=0
	.s score=score+subscore
	q score
}

/// Creator:王聪聪
/// Description:保存考核项目明细
/// Date:2019-09-10
/// Table: DHCNMG.DB.MgAssessItemSub
/// Input:
/// Output：
/// Return:
ClassMethod SaveAssessSub(parr As %String) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s id=$g(tmp("RowID"))
	s IsScore=1
	i id'="" d
	.s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(id)
	.s IsScore='$d(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj.%Id()))  //无子节点需计算分数
	.s:(IsScore)&&(obj.SubScore=tmp("SubScore")) IsScore=0
	e  d
	.s obj=##class(DHCNMG.DB.MgAssessItemSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgAssessItem).%OpenId(+tmp("SubPar"))
	.s obj.SubSort=..ComputeAssessNodeSort((tmp("SubPar")))
	.i tmp("SubSort")'="1" s obj.SubPar=tmp("SubPar")
	.s IsScore=1
	.;s:(tmp("SubScore")=0) IsScore=0
	s obj.SubDesc=$g(tmp("SubDesc"))
	s obj.SubStandard=$g(tmp("SubStandard"))
	s:IsScore obj.SubScore=+$g(tmp("SubScore"))
	i $g(tmp("SubStDate")) s obj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s obj.SubStDate=""
	i $g(tmp("SubEndDate")) s obj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s obj.SubEndDate=""
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i ($$$ISOK(sc)=1)&&(IsScore) d
	.s flag=..CalcuAssessScore(+tmp("SubPar"),obj.SubPar)
	if flag
	{
		TC
	}
	else
	{
		Tro
	}
	d $System.Status.DisplayError(sc)
	q flag
}

/// Creator: 王聪聪
/// CreatDate: 2019-09-10
/// Description: 删除考核标准条目
/// Table：DHCNMG.DB.MgAssessItem
/// Input：
/// Return：1:成功。2：已使用。0：失败
/// Other: w ##class(web.NurMgSetComm).DeleteAssessItms("3")
ClassMethod DeleteAssessItms(id As %String) As %String
{
	q:id="" 0
	
	s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(id)
	s isUsed=..CheckAssessItemUsed(id)
	if isUsed
	{
		q 2	
	}
	TS
	s fatherid=obj.SubPar
	s sort=obj.SubSort
	s flag=obj.%DeleteId(id)
	if $d(^DHCNMG.DB.MgAssessItemSubI("par"," "_id)) 
	{
		s rw="" f  s rw=$o(^DHCNMG.DB.MgAssessItemSubD(+id,rw)) q:rw=""  d
		.s childobj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(+id_"||"_rw)
		.s childsort=childobj.SubSort
		.q:$l(childsort)<=$l(sort)
		.i $e(childsort,0,$l(sort))=sort  d childobj.%DeleteId(+id_"||"_rw)
	}
	s flag=..CalcuAssessScore(+id,fatherid)
	if flag=1{
		TC	
	}else{
		Tro
	}
	q flag
}

/// Creator:王聪聪
/// Description:新增考核标准计算考核sort
/// Date:2019-09-10
/// Table: DHCNMG.DB.MgAssessItemSub
/// Input:
/// Output：
/// Return:
/// Others:二级：i.0；三级：i.0.j;四级：i.0.j.z。一级为父类（大标题****质控）
ClassMethod ComputeAssessNodeSort(parid) As %String
{
	s NodeSort=""
	i parid[".0" d //计算二级质控排序
	.s par=$p(parid,".",1)
	.s n=1 //n个二级质控
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgAssessItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(par_"||"_rw)
	..q:obj.SubPar'=""
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".")+1
	..s:nextsort>n n=nextsort
	.s NodeSort=n_".0"
	e  d //计算非二级质控排序
	.s par=$P(parid,"||",1)
	.s sort="",NodeSort="",n=1 //获取要要排的序号
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgAssessItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(par_"||"_rw)
	..q:(obj.SubPar'=parid) //父节点不对应的q
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".",$l(sort,"."))+1
	..s:nextsort>n n=nextsort
	.s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parid)
	.s NodeSort=obj.SubSort_"."_n
	q NodeSort
}

/// Creator:王聪聪
/// Description:根据key(id)查找Tree的节点信息
/// Date:2019-09-10
/// Table: DHCNMG.DB.MgAssessItemSub
/// Input:
/// Output：
/// Return:
ClassMethod GetAssessTreeData(id As %String) As %String
{
	s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(id)
	q:'$IsObject(obj) ""
	s SubDesc=obj.SubDesc
	s SubStandard=obj.SubStandard
	s SubScore=obj.SubScore
	i obj.SubStDate'="" s SubStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)
	e  s SubStDate=""
	i obj.SubEndDate'="" s SubEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)
	e  s SubEndDate=""
	s ret="RowID|"_id_"^SubDesc|"_SubDesc_"^SubStandard|"_SubStandard_"^SubScore|"_SubScore_"^SubStDate|"_SubStDate_"^SubEndDate|"_SubEndDate
	q ret
}

/// Creator:王聪聪
/// Description:通过考核类型查询所有考核标准
/// Date:2019-09-11
/// Table:
/// Input:考核类型
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","GetAssessItemByType","21__1")
Query GetAssessItemByType(type As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetAssessItemByTypeExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$replace(type,"_","|")
	s id=""
	s desc=""
	f  s desc=$o(^DHCNMG.DB.MgAssessItemI("desc",type,desc)) q:desc=""  d
	.s itemdesc=desc
	.s id=$o(^DHCNMG.DB.MgAssessItemI("desc",type,desc,""))
	.s ret="AssessItem|"_itemdesc_"^rid|"_id
	.do OutputQualTask				
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQualTask
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetAssessItemByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssessItemByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAssessItemByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssessItemByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪聪
/// Description:查询所有考核记录
/// Date:2019-09-11
/// Table:
/// Input:检索条件,被考核人的工号，年份，登录权限，登录病区
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindAssessRecordList","^^8^2^4")
Query FindAssessRecordList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssessRecordListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s user=$p($g(parr),"^",1)
	s year=$p($g(parr),"^",2)
	s role=$p($g(parr),"^",3)
	s assessid=$p($g(parr),"^",4)
	s ward=$p($g(parr),"^",5)
	s:ward'="" wardloc=(##class(DHCNMG.DB.MgWard).%OpenId(ward).WardLocDR.%Id())
	s rid=""
	i role=5  d
	.f  s rid=$o(^DHCNMG.DB.MgAssessModelI("wardloc",wardloc,rid)) q:rid=""  d
	..s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(rid)
	..q:'$IsObject(obj)
	..q:(year'="")&&(year'=obj.AssessYear)
	..q:(user'="")&&(user'=obj.AssessedUser.PerName)
	..s ret=..GetAssessRecord(rid)
	..do OutputQualTask
	i role=6  d
	.f  s rid=$o(^DHCNMG.DB.MgAssessModelI("ward",ward,rid)) q:rid=""  d
	..s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(rid)
	..q:'$IsObject(obj)
	..q:(year'="")&&(year'=obj.AssessYear)
	..q:(user'="")&&(user'=obj.AssessedUser.PerName)
	..s ret=..GetAssessRecord(rid)
	..do OutputQualTask
	i role>6 d
	.f  s rid=$o(^DHCNMG.DB.MgAssessModelI("user"," "_assessid,rid)) q:rid=""  d
	..s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(rid)
	..q:'$IsObject(obj)
	..q:(year'="")&&(year'=obj.AssessYear)
	..q:(user'="")&&(user'=obj.AssessedUser.PerName)
	..s ret=..GetAssessRecord(rid)
	..do OutputQualTask
	i role<5 d
	.f  s rid=$o(^DHCNMG.DB.MgAssessModelD(rid)) q:rid=""  d
	..s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(rid)
	..q:'$IsObject(obj)
	..q:(year'="")&&(year'=obj.AssessYear)
	..q:(user'="")&&(user'=obj.AssessedUser.PerName)
	..s ret=..GetAssessRecord(rid)
	..do OutputQualTask				
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQualTask
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssessRecordListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssessRecordListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAssessRecordListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssessRecordListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveAssessRecordData(parr)
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:$d(^DHCNMG.DB.MgAssessModelI("assessed"," "_tmp("AssessYear")," "_tmp("AssessTime"),$replace(tmp("AssessType"),"_","|"),tmp("AssessUser"),tmp("AssessedUser"))) -1
	s id=tmp("RowID")
	i id=""  s obj=##class(DHCNMG.DB.MgAssessModel).%New(),flag=1
	i id'="" s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(id),flag=2
	d obj.AssessedUserSetObjectId(tmp("AssessedUser"))
	d obj.AssessItemSetObjectId(tmp("AssessItem"))
	i tmp("AssessScore")=""  s obj.AssessScore=0
	i tmp("AssessScore")'="" s obj.AssessScore=tmp("AssessScore")
	s obj.AssessTime=tmp("AssessTime")
	d obj.AssessTypeSetObjectId($replace(tmp("AssessType"),"_","|"))
	s obj.AssessUser=tmp("AssessUser")
	d obj.AssessWardSetObjectId(tmp("AssessWards"))
	d obj.AssessWardLocSetObjectId(tmp("AssessWardLoc"))
	s obj.AssessYear=tmp("AssessYear")
	s obj.Status="NA"
	s obj.CreateDate=+$h
	s res=obj.%Save()
	i $$$ISOK(res) q res
	e  q 0
}

/// Creator:王聪聪
/// Description:获取标版评分项
/// Date:2019-09-16
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindAssessItems","17")
Query FindAssessItems(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssessItemsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=##class(DHCNMG.DB.MgAssessModel).%OpenId(parr).AssessType.%Id()
	s parr=$O(^DHCNMG.DB.MgAssessItemI("type",type,""))
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1=0 
	f  s rw1=$o(^DHCNMG.DB.MgAssessItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0 ;一级合并数量，所含二级数量
	.s obj1=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parr_"||"_rw1)
	.q:'$IsObject(obj1)
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj1.%Id(),parr)) d
	..s tmp("colspan,rw1")=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0 ;二级合并数量（二级下三级数量）
	...s obj2=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parr_"||"_rw2)
	...q:'$IsObject(obj2)
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...i '$d(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj2.%Id(),parr)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parr_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	s obj=##class(DHCNMG.DB.MgAssessItem).%OpenId(parr)
	;2、循环输出，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgAssessItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parr_"||"_rw1)
	.q:('$IsObject(obj1))
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj1.%Id(),parr)) d
	..;无子集
	..s realscore=obj1.SubScore
	..s sort=obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|1"_"^onesort|"_obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj1.SubStandard_"^twoRealScore|1^SubRowID|^AssessType|1"_"^AssessItemRemark|"_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parr_"||"_rw2)
	...q:('$IsObject(obj2))
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...s realscore=obj2.SubScore
	...s sort=obj2.SubSort
	...i '$d(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj2.%Id(),parr))  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj2.SubStandard_"^twoRealScore|1^SubRowID|^AssessType|1"_"^AssessItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	...e  d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^twoRealScore|^SubRowID|"_"^AssessType|1"_"^AssessItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgAssessItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s realscore=obj3.SubScore
	.....s sort=obj3.SubSort
	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort_"^threeModelDesc|"_obj3.SubDesc_"^threeModelId|"_$tr(obj3.%Id(),"||","__")_"^threesort|"_obj3.SubSort_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj3.SubStandard_"^twoRealScore|"_tmp("colspan",rw2)_"^SubRowID|^AssessType|1"_"^AssessItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	.....//s isShow1=0,isShow2=0
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..//s:sort2=0 TwoIsShow=0
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2_"^num|"_0
	
	...s isShow1=0,isShow2=0
	...d OutputScoreData
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2_"^num|"_0
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssessItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssessItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAssessItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssessItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪聪
/// Description:获取单条评分记录
/// Date:2019-09-16
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(web.NurMgSetComm).GetAssessRecord()
ClassMethod GetAssessRecord(id)
{
	s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(id)
	q:'$IsObject(obj)
	s status=$case(obj.Status,"YS":"已提交","NS":"未提交","NA":"未评分")
	s assessyear=obj.AssessYear
	s assessuser=obj.AssessUser
	i assessuser=0	s assessuser1="管理员"
	else  s assessuser1=##class(DHCNMG.HR.MgPersons).%OpenId(assessuser).PerName
	s assesseduser=obj.AssessedUser.PerName
	s assessscore=obj.AssessScore
	s assesstype=obj.AssessType.SubDesc
	s assessitem=obj.AssessItem.AssessDesc
	s assesstime=obj.AssessTime
	s assessward=obj.AssessWard.WardDesc
	s assesswardloc=obj.AssessWardLoc.LocDesc
	s remark=obj.Remark
	s createdate=$zd(obj.CreateDate,3)
	s RowId=obj.%Id()
	s ret="RowID|"_RowId_"^Status|"_status_"^AssessYear|"_assessyear_"^AssessUser|"_assessuser1
	_"^AssessedUser|"_assesseduser_"^AssessTime|"_assesstime_"^AssessItem|"_assessitem
	_"^AssessScore|"_assessscore_"^AssessType|"_assesstype_"^AssessWards|"_assessward
	_"^CreateDate|"_createdate_"^AssessWardLoc|"_assesswardloc_"^AssessRemark|"_remark
	q ret
}

ClassMethod GetAssessRecord1(id)
{
	s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(id)
	q:'$IsObject(obj)
	s status=$case(obj.Status,"YS":"已提交","NS":"未提交","NA":"未评分")
	s assessyear=obj.AssessYear
	s assessuser=obj.AssessUser
	s assesseduser=""
	s:obj.AssessedUser'="" assesseduser=obj.AssessedUser.%Id()
	s assessscore=obj.AssessScore
	s assesstype=""
	s:obj.AssessType'="" assesstype=$tr(obj.AssessType.%Id(),"||","__")
	s assessitem=""
	s:obj.AssessItem'="" assessitem=obj.AssessItem.%Id()
	s assesstime=obj.AssessTime
	s assessward=""
	s:obj.AssessWard'="" assessward=obj.AssessWard.%Id()
	s assesswardloc=""
	s:obj.AssessWardLoc'="" assesswardloc=obj.AssessWardLoc.%Id()
	s createdate=$zd(obj.CreateDate,3)
	s RowId=obj.%Id()
	s ret="RowID|"_RowId_"^Status|"_status_"^AssessYear|"_assessyear_"^AssessUser|"_assessuser
	_"^AssessedUser|"_assesseduser_"^AssessTime|"_assesstime_"^AssessScore|"_assessscore_
	"^AssessType|"_assesstype_"^AssessWards|"_assessward_"^AssessItem|"_assessitem
	_"^CreateDate|"_createdate_"^AssessWardLoc|"_assesswardloc
	q ret
}

/// Creator:王聪聪
/// Description:删除单条评分记录
/// Date:2019-09-16
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(web.NurMgSetComm).DeleteAssessRecord()
ClassMethod DeleteAssessRecord(id)
{
	s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(id)
	q:'$IsObject(obj)
	s sc=obj.%DeleteId(id)
	d $System.Status.DisplayError(sc)
}

/// creator:王聪聪
/// createdate:2019-09-19
/// description:获取考核标准导出数据
/// table:DHCNMG.DB.MgAssessItem,DHCNMG.DB.MgAssessItemSub
/// input:质控标准ID
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindExportAssessData","1")
Query FindExportAssessData(id As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindExportAssessDataExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if id="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k tmp
	s sortLength=0,sortTimes=10
	s subid="" f  s subid=$O(^DHCNMG.DB.MgAssessItemSubD(id,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(id_"||"_subid)
	.q:'$IsObject(obj)
	.q:obj.SubSort=""
	.s tmp(obj.SubSort)=id_"||"_subid
	if '$d(tmp) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ret=""
	s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
	.s subid=tmp(sort)
	.s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(subid)
	.s stdate=obj.SubStDate
	.s:stdate'="" stdate=##class(web.NurMgHISComm).DateLogicalToHtml(stdate)
	.s enddate=obj.SubEndDate
	.s:enddate'="" enddate=##class(web.NurMgHISComm).DateLogicalToHtml(enddate)
	.s score=obj.SubScore
	.s:$d(^DHCNMG.DB.MgAssessItemSubI("par"," "_subid)) score=""
	.s ret="sort|"_obj.SubSort_"^desc|"_obj.SubDesc_"^standard|"_obj.SubStandard_"^stdate|"_stdate_"^enddate|"_enddate_"^score|"_score
	.d OutExportAssessData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutExportAssessData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExportAssessDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExportAssessDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindExportAssessDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExportAssessDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:王聪聪
/// createdate:2019-09-19
/// description:保存导入考核模板子项
/// table:DHCNMG.DB.MgAssessItem,DHCNMG.DB.MgAssessItemSub
/// input:
/// output:
/// other:w ##class(web.NurMgSetComm).SaveImporAssessSubData("sort|1.0^desc|举例1^standard|举例1^stdate|2018-01-01^enddate|2018-12-31^parsort|1^rw|1^index|0")
ClassMethod SaveImporAssessSubData(parr) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s parObj=##class(DHCNMG.DB.MgAssessItem).%OpenId(tmp("rw"))
	TS
	s parid=""
	s id=""
	i $l($g(tmp("sort")),".")>=3  d
	.s isExist=0
	.f  s id=$o(^DHCNMG.DB.MgAssessItemSubD(tmp("rw"),id)) q:(id="")||(isExist=1)  d
	..s obj=##class(DHCNMG.DB.MgAssessItemSub).%OpenId(tmp("rw")_"||"_id)
	..q:'$IsObject(obj)
	..s:(obj.SubSort=tmp("parsort")) parid=obj.%Id(),isExist=1
	s upObj=##class(DHCNMG.DB.MgAssessItemSub).%New()
	q:'$IsObject(upObj)
	s upObj.Parref=parObj
	s upObj.SubPar=parid
	s upObj.SubDesc=$g(tmp("desc"))
	s upObj.SubStandard=$g(tmp("standard"))
	s upObj.SubScore=+$g(tmp("score"))
	s upObj.SubSort=$g(tmp("sort"))
	s:$g(tmp("score")) upObj.SubScore=+$g(tmp("score"))
	s stdate=$g(tmp("stdate"))
	i stdate d 
	.s:stdate["/" stdate=$replace(tmp("stdate"),"/","-")
	.s upObj.SubStDate=$zdh(stdate,3)
	s enddate=$g(tmp("enddate"))
	i enddate d 
	.s:enddate["/" enddate=$replace(tmp("endate"),"/","-")
	.s upObj.SubEndDate=$zdh(tmp("enddate"),3)
	s sc=upObj.%Save()
	s flag=$$$ISOK(sc)
	i (flag) d
	.s flag=..CalcuAssessScore(tmp("rw"),upObj.SubPar)
	if flag
	{
		TC
		q tmp("index")
	}else{
		Tro
		d parObj.%DeleteId(tmp("rw"))
		q "-1"
	}
}

/// Creator:王聪聪
/// Description:显示考核汇总记录
/// Date:2019-09-11
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindNurAssessList","^^0^0^")
Query FindNurAssessList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurAssessListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s user=$p($g(parr),"^",1)
	s year=$p($g(parr),"^",2)
	s assessward=$p($g(parr),"^",6)
	s assesswardloc=$p($g(parr),"^",7)
	s aid=""
	s score=0
	f  s aid=$o(^DHCNMG.DB.MgAssessModelD(aid)) q:aid=""  d
	.s obj=	##class(DHCNMG.DB.MgAssessModel).%OpenId(aid)
	.q:'$IsObject(obj)
	.q:(year'="")&&(year'=obj.AssessYear)
	.q:(assessward'="")&&(assessward'=obj.AssessWard.%Id())
	.q:(assesswardloc'="")&&(assesswardloc'=obj.AssessWardLoc.%Id())
	.q:(user'="")&&(user'=obj.AssessedUser.PerName)
	.q:obj.Status'="YS"
	.s score=obj.AssessScore 
	.s award=obj.AssessWard.WardDesc
	.s auser=obj.AssessedUser.PerName
	.s aloc=obj.AssessWardLoc.LocDesc
	.s atype=obj.AssessType.SubDesc
	.i $d(tmp(obj.AssessYear,auser,obj.AssessTime,award,aloc,atype))  d
	..s tmp(obj.AssessYear,auser,obj.AssessTime,award,aloc,atype)=tmp(obj.AssessYear,auser,obj.AssessTime,award,aloc,atype)+score
	.i '$d(tmp(obj.AssessYear,auser,obj.AssessTime,award,aloc,atype)) d
	..s tmp(obj.AssessYear,auser,obj.AssessTime,award,aloc,atype)=score 	
	.s:$d(tmp(obj.AssessYear,auser,obj.AssessTime,atype,"count")) tmp(obj.AssessYear,auser,obj.AssessTime,atype,"count")=tmp(obj.AssessYear,auser,obj.AssessTime,atype,"count")+1
	.s:'$d(tmp(obj.AssessYear,auser,obj.AssessTime,atype,"count")) tmp(obj.AssessYear,auser,obj.AssessTime,atype,"count")=1 	
 	s y=""
 	f  s y=$o(tmp(y)) q:y=""  d
 	.s ret="AssessYear|"_y
 	.s u=" "
 	.f  s u=$o(tmp(y,u)) q:u=""  d
 	..s ret=ret_"^AssessedUser|"_u
 	..s t=" "
 	..f  s t=$o(tmp(y,u,t)) q:t=""  d
 	...s ret=ret_"^AssessTime|"_t
 	...s w=" "
 	...f  s w=$o(tmp(y,u,t,w)) q:w=""  d
 	....s ret=ret_"^AssessWards|"_w
 	....s wl=" "
 	....f  s wl=$o(tmp(y,u,t,w,wl)) q:wl=""  d
 	.....s ret=ret_"^AssessWardLoc|"_wl
 	.....s p=" "
 	.....f  s p=$o(tmp(y,u,t,w,wl,p)) q:p=""  d
 	......s recordscore=tmp(y,u,t,w,wl,p)/tmp(y,u,t,p,"count")
 	......s ret=ret_"^AssessType|"_p_"^AssessScore|"_recordscore
 	......do OutputQualTask	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQualTask
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurAssessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurAssessListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurAssessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurAssessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪聪
/// Description:保存考核记录父表数据
/// Date:2019-09-18
/// Table: DHCNMG.DB.MgAssessModel
/// Input:
/// Output：
/// Return:
/// Other: w ##class(web.NurMgSetComm).SaveAssessModelRec("AssessWards|妇科^AssessUser|demo^AssessedUser|hs04^AssessScore|20.0^RowID|1^CreateDate|2019-09-25^Status|S^AssessRemark|")
ClassMethod SaveAssessModelRec(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(tmp("RowID"))
	s obj.AssessScore=$g(tmp("AssessScore"))
	s obj.AssessDate=+$zdh(tmp("CreateDate"),3)
	s obj.Status=$case($g(tmp("Status")),"S":"YS","N":"NS")
	i $g(tmp("Status"))="S"  d
	.s obj.SubmitDate=+$H
	s obj.Remark=$replace($tr($g(tmp("AssessRemark"))," ",""),$c(10),"")
	s sc=obj.%Save()
	q obj.%Id()
}

/// Creator:王聪聪
/// Description:保存考核记录对应子表数据
/// Date:2019-09-18
/// Table: DHCNMG.DB.MgAssessModelSub
/// Input:
/// Output：
/// Return:
ClassMethod SaveAssessModelSub(parr As %String, par As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s type=tmp("AssessType")
	i $g(tmp("SubRowID"))="" d
	.i $g(tmp("threeModelId"))'="" d
	..s id=$O(^DHCNMG.DB.MgAssessModelSubI("model",type," "_tmp("threeModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id
	.e  i $g(tmp("twoModelId"))'="" d
	..s id=$O(^DHCNMG.DB.MgAssessModelSubI("model",type," "_tmp("twoModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id
	.e  d
	..s id=$O(^DHCNMG.DB.MgAssessModelSubI("model",type," "_tmp("oneModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id

	i $g(tmp("SubRowID"))="" d
	.s type=tmp("AssessType"),parentId=""
	.;检测一级质控是否已存在，不存在则保存。
	.i ($g(tmp("oneModelId"))'="")&&('$d(^DHCNMG.DB.MgAssessModelSubI("model",type," "_tmp("oneModelId"),par))) d
	..s obj=##class(DHCNMG.DB.MgAssessModelSub).%New()
	..s obj.Parref=##class(DHCNMG.DB.MgAssessModel).%OpenId(par)
	..s obj.AssessItem=$g(tmp("oneModelDesc"))
	..s obj.AssessModelDR=tmp("oneModelId")
	..s obj.AssessColSpan=+$g(tmp("oneColSpan"))
	..s obj.ItemFlag="1"
	..s obj.AssessType=type
	..s obj.AssessSort=$g(tmp("onesort"))
	..s sc=obj.%Save()
	.s parentId=$o(^DHCNMG.DB.MgAssessModelSubI("model",type," "_tmp("oneModelId"),par,""))
	.i ($g(tmp("twoModelId"))'="")&&('$d(^DHCNMG.DB.MgAssessModelSubI("model",type," "_tmp("twoModelId"),par))) d
	..s obj=##class(DHCNMG.DB.MgAssessModelSub).%New()
	..s obj.Parref=##class(DHCNMG.DB.MgAssessModel).%OpenId(par)
	..s obj.AssessItem=$g(tmp("twoModelDesc"))
	..s obj.AssessModelDR=tmp("twoModelId")
	..s obj.AssessNum=tmp("num")
	..s:parentId'="" obj.AssessItemParentDR=par_"||"_parentId
	..s obj.AssessColSpan=+$g(tmp("twoColSpan"))
	..s obj.ItemFlag="2"
	..s obj.AssessType=type
	..s obj.AssessSort=$g(tmp("twosort"))
	..s sc=obj.%Save()
	.s parentId=$o(^DHCNMG.DB.MgAssessModelSubI("model",type," "_tmp("twoModelId"),par,""))
	.i $g(tmp("threeModelId"))'="" d
	..s obj=##class(DHCNMG.DB.MgAssessModelSub).%New()
	..s obj.Parref=##class(DHCNMG.DB.MgAssessModel).%OpenId(par)
	..s obj.AssessItem=$g(tmp("threeModelDesc"))
	..s obj.AssessModelDR=tmp("threeModelId")
	..s:parentId'="" obj.AssessItemParentDR=par_"||"_parentId
	..s obj.ItemFlag="3"
	..s obj.AssessType=type
	..s obj.AssessColSpan="1"
	..s obj.AssessSort=$g(tmp("threesort"))
	..s sc=obj.%Save()
	.s obj.AssessItemStand=tmp("StandardScore")
	.s obj.StandardScore=tmp("Score")
	.s obj.AssessType=type
	e  s obj=##class(DHCNMG.DB.MgAssessModelSub).%OpenId(tmp("SubRowID"))
	s obj.AssessItemScore=tmp("realScore")
	s obj.AssessTwoScore=tmp("twoRealScore")
	s obj.AssessNum=tmp("num")
	s obj.AssessItemRemark=tmp("AssessItemRemark")
	s sc=obj.%Save()
	Tc
	 q $$$ISOK(sc)
}

/// Creator:王聪聪
/// Description:获取考核记录(已保存)对应子表数据
/// Date:2019-09-18
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindAssessScoreLists","")
Query FindAssessScoreLists(par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssessScoreListsExecute(ByRef qHandle As %Binary, par As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgAssessModelSubI("par"," ",par,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0
	.s obj1=##class(DHCNMG.DB.MgAssessModelSub).%OpenId(par_"||"_rw1)
	.q:'$IsObject(obj1)
	.i '$d(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj1.%Id(),par)) d
	..s tmp("colspan",rw1)=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj1.%Id(),par,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0
	...s obj2=##class(DHCNMG.DB.MgAssessModelSub).%OpenId(par_"||"_rw2)
	...q:'$IsObject(obj2)
	...i '$d(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj2.%Id(),par)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1,tmp("score",rw2)=0
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj2.%Id(),par,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgAssessModelSub).%OpenId(par_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	.....s tmp("score",rw2)=tmp("score",rw2)+obj3.AssessItemScore
	s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(par)
	;2、存储输出数据临时数组，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgAssessModelSubI("par"," ",par,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.DB.MgAssessModelSub).%OpenId(par_"||"_rw1)
	.q:'$IsObject(obj1)
	.i '$d(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj1.%Id(),par)) d
	..;无子集
	..s realscore=obj1.AssessItemScore
	..s num=obj1.AssessNum
	..;s:obj.QualScoreType'=2 realscore=1
	..s sort=obj1.AssessSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.AssessItem_"^oneModelId|"_$tr(obj1.AssessModelDR,"||","__")_"^oneColSpan|"_obj1.AssessColSpan_"^onesort|"_obj1.AssessSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_obj1.StandardScore_"^realScore|"_realscore_"^num|"_num_"^StandardScore|"_obj1.AssessItemStand_"^twoRealScore|"_realscore_"^SubRowID|"_$tr(obj1.%Id(),"||","__")
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^AssessType|1"_"^AssessItemRemark|"_obj1.AssessItemRemark_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj1.%Id(),par,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.DB.MgAssessModelSub).%OpenId(par_"||"_rw2)
	...q:'$IsObject(obj2)
	...s realscore=obj2.AssessItemScore
	...s num=obj2.AssessNum
	...s sort=obj2.AssessSort
	...//s isShow1=..isItemShow(sort,par)
	...i $d(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj2.%Id(),par)) d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.AssessItem_"^oneModelId|"_$tr(obj1.AssessModelDR,"||","__")_"^oneColSpan|"_obj1.AssessColSpan_"^onesort|"_obj1.AssessSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.AssessItem_"^twoModelId|"_$tr(obj2.AssessModelDR,"||","__")_"^twoColSpan|"_obj2.AssessColSpan_"^twosort|"_obj2.AssessSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"_"^num|"_num
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^SubRowID|"_"^AssessType|1"_"^AssessItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoRealScore|"_tmp("score",rw2)
	...e  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.AssessItem_"^oneModelId|"_$tr(obj1.AssessModelDR,"||","__")_"^oneColSpan|"_obj1.AssessColSpan_"^onesort|"_obj1.AssessSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.AssessItem_"^twoModelId|"_$tr(obj2.AssessModelDR,"||","__")_"^twoColSpan|"_obj2.AssessColSpan_"^twosort|"_obj2.AssessSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"_"^num|"_num
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_obj2.StandardScore_"^realScore|"_realscore_"^StandardScore|"_obj2.AssessItemStand_"^SubRowID|"_$tr(obj2.%Id(),"||","__")_"^AssessType|1"_"^AssessItemRemark|"_obj2.AssessItemRemark_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoRealScore|"_realscore
	...s rw3="" f  s rw3=$o(^DHCNMG.DB.MgAssessModelSubI("par"," "_obj2.%Id(),par,rw3)) q:rw3=""  d
	....s obj3=##class(DHCNMG.DB.MgAssessModelSub).%OpenId(par_"||"_rw3)
	....q:'$IsObject(obj3)
	....s realscore=obj3.AssessItemScore
	....s sort=obj3.AssessSort
	....s num=obj3.AssessNum
	....//s isShow1=..isItemShow(obj2.AssessSort,par)
	....//s isShow2=..isItemShow(sort,par)
	....//s isShow1=((isShow1=1)&&(isShow2=1))
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.AssessItem_"^oneModelId|"_$tr(obj1.AssessModelDR,"||","__")_"^oneColSpan|"_obj1.AssessColSpan_"^onesort|"_obj1.AssessSort_"^twoModelDesc|"_obj2.AssessItem_"^twoModelId|"_$tr(obj2.AssessModelDR,"||","__")_"^twoColSpan|"_obj2.AssessColSpan_"^twosort|"_obj2.AssessSort_"^threeModelDesc|"_obj3.AssessItem_"^threeModelId|"_$tr(obj3.AssessModelDR,"||","__")_"^threesort|"_obj3.AssessSort_"^Score|"_obj3.StandardScore_"^realScore|"_realscore_"^StandardScore|"_obj3.AssessItemStand_"^SubRowID|"_$tr(obj3.%Id(),"||","__")_"^AssessType|1"_"^AssessItemRemark|"_obj3.AssessItemRemark_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree_"^num|"_num
	....//s isShow1=0,isShow2=0
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))=tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))_"^twoRealScore|"_tmp("score",rw2)
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreLists
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreLists
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreLists
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssessScoreListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssessScoreListsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAssessScoreListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssessScoreListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪聪
/// Description:判断考核项目名称是否存在
/// Date:2019-09-29
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.NurMgSetComm).AssessDescIsExist()
ClassMethod AssessDescIsExist(type, desc)
{
	s type=$tr(type,"__","||")
	q:$d(^DHCNMG.DB.MgAssessItemI("desc",type," "_desc)) 1
	q 0
}

/// Description:判断考核项目名称是否存在
/// Date:2019-09-29
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.NurMgSetComm)SubmitAssessRecord()
ClassMethod SubmitAssessRecord(id)
{
	s obj=##class(DHCNMG.DB.MgAssessModel).%OpenId(id)
	q:'$IsObject(obj) -1
	s obj.Status="YS"
	s obj.SubmitDate=+$h
	s sc=obj.%Save()
	q sc
}

/// Creator:wangpf
/// CreatDate: 2019-09-04
/// Description:检查Kpi项目是否在用
/// Table：DHCNMG.DB.Mg
/// Input：
/// Return：0：未使用 1：使用中
/// Other：w ##class(web.NurMgSetComm).CheckKpiItemUsed(1)
ClassMethod CheckKpiItemUsed(id As %String = "") As %String
{
	q:id="" 0
	q:$d(^DHCNMG.CHK.MgKpiCheckI("CheckItem",id)) 1
	q 0
}

/// Creator:wangpf
/// CreatDate: 2019-09-04
/// Description: 保存Kpi项目
/// Table：DHCNMG.DB.MgKpiItem
/// Input：
/// Return：成功返回id
ClassMethod SaveKpiItem(parr As %String) As %String
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("kpiCode"))="")||($g(tmp("kpiDesc"))="")||($g(tmp("kpiGroup"))="") "信息不完整"
	s id=$g(tmp("rowid"))
	s isUsed=0
	s isExist=1
	i id'="" d
	.s obj=##class(DHCNMG.DB.MgKpiItem).%OpenId(id)
	.i '$IsObject(obj) s isExist=0 q
	.s isUsed=..CheckKpiItemUsed(id)
	e  d
	.s obj=##class(DHCNMG.DB.MgKpiItem).%New()
	q:isExist'=1 "项目不存在"
	q:(isUsed'=0)&&(tmp("kpiGroup")'=obj.KpiGroup.%Id()) "项目正在使用中,不能修改所属组别"
	s obj.KpiCode=tmp("kpiCode")
	s obj.KpiDesc=tmp("kpiDesc")
	s groupObj=##class(DHCNMG.DB.MgKpiGroup).%OpenId(tmp("kpiGroup"))
	q:'$IsObject(groupObj) "组别不正确"
	s obj.KpiGroup=groupObj
#;	s obj.KpiType=tmp("kpiType")
#;	i (tmp("kpiRelated")'="")&&(obj.KpiType="L") d
#;	.s locList=##class(%ListOfObjects).%New()
#;	.f i=1:1:$l(tmp("kpiRelated"),",") d
#;	..s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId($p(tmp("kpiRelated"),",",i))
#;	..q:'$IsObject(locObj)
#;	..d locList.Insert(locObj)
#;	.s obj.KpiLocDR=locList
#;	e  i (tmp("kpiRelated")'="")&&(obj.KpiType="W") d
#;	.s wardList=##class(%ListOfObjects).%New()
#;	.f i=1:1:$l(tmp("kpiRelated"),",") d
#;	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId($p(tmp("kpiRelated"),",",i))
#;	..q:'$IsObject(wardObj)
#;	..d wardList.Insert(wardObj)
#;	.s obj.KpiWardDR=wardList
	s sc=obj.%Save()
	i sc=1
	{
		q obj.%Id()
	}
	else
	{
		q "保存失败:"_$System.Status.DisplayError(sc)
	}
}

/// Creator:wangpf
/// CreatDate: 2019-09-05
/// Description: 删除Kpi项目
/// Table：DHCNMG.DB.MgKpiItem
/// Input：
/// Return：1：成功 2：使用中 0：失败
/// Other：w ##class(web.NurMgSetComm).DeleteKpiItem(1)
ClassMethod DeleteKpiItem(id As %String) As %String
{
	q:id="" 0
	s isUsed=..CheckKpiItemUsed(id)
	if isUsed{
		q 2
	}
	ts
	s flag=##class(DHCNMG.DB.MgKpiItem).%DeleteId(id)
	i flag d
	.s subId="" f  s subId=$o(^DHCNMG.DB.MgKpiItemSubI("parr",id,subId)) q:(subId="")||(flag'=1)  d
	..s flag=##class(DHCNMG.DB.MgKpiItemSub).%DeleteId(subId)
	i flag'=1 tro
	e  tc
	q flag
}

/// Creator:wangpf
/// Description:获取Kpi项目记录
/// Date:2019-09-05
/// Table: DHCNMG.DB.MgKpiItem
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.NurMgSetComm).GetKpiItem(1)
ClassMethod GetKpiItem(id As %String, returnGroupById As %Boolean = 0) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgKpiItem).%OpenId(id)
	q:'$IsObject(obj) ""
	s KpiCode=$zcvt(obj.KpiCode,"U")
	s KpiDesc=obj.KpiDesc
	s KpiScore=obj.KpiScore
	i returnGroupById s KpiGroup=obj.KpiGroup.%Id()
	e  s KpiGroup=obj.KpiGroup.GroupDesc
#;	i KpiType="A" d
#;	.i returnLocWardById s KpiRelated=""
#;	.e  s KpiType="全院通用",KpiRelated="全院"
#;	e  i KpiType="L" d
#;	.s KpiRelated=""
#;	.s:'returnLocWardById KpiType="科室"
#;	.f i=1:1:obj.KpiLocDR.Count() d
#;	..i KpiRelated="" d
#;	...i returnLocWardById=0 s KpiRelated=obj.KpiLocDR.GetAt(i).LocDesc
#;	...e  s KpiRelated=obj.KpiLocDR.GetAt(i).%Id()
#;	..e  d
#;	...i returnLocWardById=0 s KpiRelated=KpiRelated_","_obj.KpiLocDR.GetAt(i).LocDesc
#;	...e  s KpiRelated=KpiRelated_","_obj.KpiLocDR.GetAt(i).%Id()
#;	e  i KpiType="W" d
#;	.s KpiRelated=""
#;	.s:'returnLocWardById KpiType="病区"
#;	.s len=obj.KpiWardDR.Count()
#;	.f i=1:1:obj.KpiWardDR.Count() d
#;	..i KpiRelated="" d
#;	...i returnLocWardById=0 s KpiRelated=obj.KpiWardDR.GetAt(i).WardDesc
#;	...e  s KpiRelated=obj.KpiWardDR.GetAt(i).%Id()
#;	..e  d
#;	...i returnLocWardById=0 s KpiRelated=KpiRelated_","_obj.KpiWardDR.GetAt(i).WardDesc
#;	...e  s KpiRelated=KpiRelated_","_obj.KpiWardDR.GetAt(i).%Id()
#;	q "kpiType|"_KpiType_"^kpiCode|"_KpiCode_"^kpiDesc|"_KpiDesc_"^kpiRelated|"_KpiRelated_"^kpiScore|"_KpiScore_"^rowid|"_id
	q "kpiCode|"_KpiCode_"^kpiDesc|"_KpiDesc_"^kpiGroup|"_KpiGroup_"^kpiScore|"_KpiScore_"^rowid|"_id
}

/// creator: wangpf
/// createDate: 2019-09-06
/// description: 获取Kpi项目列表
/// table: DHCNMG.DB.MgKpiItem
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindKpiItemsList","")
Query FindKpiItemsList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindKpiItemsListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s group=$g(tmp("group"))
	s returnGroupById=$g(tmp("returnGroupById"))
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgKpiItemD(rowid)) q:rowid=""  d
	.q:(group'="")&&(group'=$lg(^DHCNMG.DB.MgKpiItemD(rowid),4))
	.s ret=..GetKpiItem(rowid,returnGroupById)
	.q:ret=""
	.do OutKpiData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutKpiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindKpiItemsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKpiItemsListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindKpiItemsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKpiItemsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:添加Kpi组别
/// Date:2019-09-06
/// Table:DHCNMG.DB.MgKpiGroup
/// Input:
/// Output:
/// Return: 0:失败 1:成功 -1:使用中
/// Other: w ##class(web.NurMgSetComm).SaveKpiGroup("GroupDesc|测试1^GroupWardDR|1,2,3^rowid|2^")
ClassMethod SaveKpiGroup(parr As %String = "") As %String
{
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:tmp("GroupDesc")="" 0
	s flag=0
	i $g(tmp("rowid"))'="" d
	.s obj=##class(DHCNMG.DB.MgKpiGroup).%OpenId(tmp("rowid"))
	.q:'$IsObject(obj)
	.s wards=$lg(^DHCNMG.DB.MgKpiGroupD(obj.%Id()),3)
	.s:'$listsame(wards,$listfromstring(tmp("GroupWardDR"),",")) flag=1
	e  s obj=##class(DHCNMG.DB.MgKpiGroup).%New()
	q:'$IsObject(obj) 0
	q:(flag=1)&&($o(^DHCNMG.DB.MgKpiItemI("group",obj.%Id(),""))'="") -1
	s obj.GroupDesc=tmp("GroupDesc")
	d obj.GroupWardDR.Clear()
	s flag=0
	f i=1:1:$l($g(tmp("GroupWardDR")),",") q:flag'=0  d
	.s wardDr=$p($g(tmp("GroupWardDR")),",",i)
	.s:'##class(DHCNMG.DB.MgWard).%ExistsId(wardDr) flag=1
	.q:flag'=0
	.d obj.GroupWardDR.Insert(wardDr)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangpf
/// Description:删除Kpi组别
/// Date:2019-09-06
/// Table:DHCNMG.DB.MgKpiGroup
/// Input:
/// Output:
/// Return: -1:使用中 0:失败 1:成功
/// other: w ##class(web.NurMgSetComm).DeleteKpiGroup(1)
ClassMethod DeleteKpiGroup(id As %String = "") As %String
{
	q:id="" 0
	q:'##class(DHCNMG.DB.MgKpiGroup).%ExistsId(id) 0
	q:$o(^DHCNMG.DB.MgKpiItemI("group",id,"")) -1
	q ##class(DHCNMG.DB.MgKpiGroup).%DeleteId(id)
}

/// Creator:wangpf
/// Description:获取Kpi组别记录
/// Date:2019-09-05
/// Table: DHCNMG.DB.MgKpiGroupItem
/// Input:
/// Output：
/// Return:
ClassMethod GetKpiGroup2(id As %String, forShow As %Boolean = 0) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgKpiGroup).%OpenId(id)
	q:'$IsObject(obj) ""
	s GroupWardDR=""
	f i=1:1:obj.GroupWardDR.Count() d
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.GroupWardDR.GetAt(i))
	.q:'$IsObject(wardObj)
	.i GroupWardDR="" s GroupWardDR=wardObj.%Id(),GroupWardDesc=wardObj.WardDesc
	.e  s GroupWardDR=GroupWardDR_","_wardObj.%Id(),GroupWardDesc=GroupWardDesc_","_wardObj.WardDesc
	q "GroupDesc|"_obj.GroupDesc_"^GroupWardDR|"_GroupWardDR_"^GroupWardDesc|"_GroupWardDesc_"^rowid|"_id
}

/// Creator:wangpf
/// Description:获取Kpi组别记录
/// Date:2019-09-05
/// Table: DHCNMG.DB.MgKpiGroupItem
/// Input:
/// Output：
/// Return:
ClassMethod GetKpiGroup(id As %String, forShow As %Boolean = 0) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgKpiGroup).%OpenId(id)
	q:'$IsObject(obj) ""
	s GroupWardDR=""
	f i=1:1:obj.GroupWardDR.Count() d
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.GroupWardDR.GetAt(i))
	.q:'$IsObject(wardObj)
	.i forShow d
	..i GroupWardDR="" s GroupWardDR=wardObj.WardDesc
	..e  s GroupWardDR=GroupWardDR_","_wardObj.WardDesc
	.e  d
	..i GroupWardDR="" s GroupWardDR=wardObj.%Id()
	..e  s GroupWardDR=GroupWardDR_","_wardObj.%Id()
	q "GroupDesc|"_obj.GroupDesc_"^GroupWardDR|"_GroupWardDR_"^rowid|"_id
}

Query FindKpiGroupsList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindKpiGroupsListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgKpiGroupD(rowid)) q:rowid=""  d
	.s ret=..GetKpiGroup(rowid,$g(tmp("forShow")))
	.q:ret=""
	.do OutKpiData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutKpiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindKpiGroupsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKpiGroupsListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindKpiGroupsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKpiGroupsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:保存Kpi项目子项
/// Date:2019-09-05
/// Table: DHCNMG.DB.MgKpiItemSub
/// Input:
/// Output：
/// Return: 0:失败 1:成功 -1:使用中
ClassMethod SaveKpiSub(parr As %String) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:..CheckKpiItemUsed(+tmp("SubPar")) -1
	TS
	s id=$g(tmp("RowID"))
	s IsScore=1
	i id'="" d
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(id)
	.s IsScore='$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj.%Id()))  //无子节点需计算分数
	.s:(IsScore)&&(obj.SubScore=tmp("SubScore")) IsScore=0
	e  d
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgKpiItem).%OpenId(+tmp("SubPar"))
	.s obj.SubSort=..ComputeKpiNodeSort(tmp("SubPar"))
	.i tmp("SubSort")'="1" s obj.SubPar=tmp("SubPar")
	.s IsScore=1
	.;s:(tmp("SubScore")=0) IsScore=0
	s obj.SubDesc=$g(tmp("SubDesc"))
	s obj.SubStandard=$g(tmp("SubStandard"))
	s:IsScore obj.SubScore=+$g(tmp("SubScore"))
	s obj.SubCanBeNegative=$g(tmp("SubCanBeNegative"))
	i $g(tmp("SubStDate")) s obj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s obj.SubStDate=""
	i $g(tmp("SubEndDate")) s obj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s obj.SubEndDate=""
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i ($$$ISOK(sc)=1)&&(IsScore) d
	.s flag=..CalKpiScore(+tmp("SubPar"),obj.SubPar)
	if flag
	{
		TC
	}
	else
	{
		Tro
	}
	d $System.Status.DisplayError(sc)
	q flag
}

/// Creator:wangpf
/// Description:插入Kpi项目子项
/// Date:2019-09-19
/// Table: DHCNMG.DB.MgKpiItemSub
/// Input:
/// Output：
/// Return: 0:失败 1:成功 -1:使用中
/// Other: w ##class(web.NurMgSetComm).InsertKpiSub("SubDesc|1^SubStandard|1^SubScore|1^SubCanBeNegative|N^SubStDate|2019-09-19^SubEndDate|^RowID|^SubPar|2||1^SubSort|2")
ClassMethod InsertKpiSub(parr As %String) As %String
{
	
	k tmp
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:..CheckKpiItemUsed(+tmp("SubPar")) -1
	s oldKpiSubObj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId($g(tmp("SubPar")))
	q:'$IsObject(oldKpiSubObj) 0
	//获取所有节点
	k tmp2
	s tmp2=""
	s subid="" f  s subid=$O(^DHCNMG.DB.MgKpiItemSubI("parr",+$g(tmp("SubPar")),subid)) q:subid=""  d
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(+$g(tmp("SubPar"))_"||"_subid)
	.q:'$IsObject(obj)
	.s tmp2(obj.SubSort)=obj.%Id()
	//计算待修改的节点的开始节点的前一个节点与结束节点的后一个节点
	s startSort=oldKpiSubObj.SubSort
	s flag2=0,stopSort=""
	i $g(tmp("SubSort"))=2 s stopSort=""
	e  s i=startSort f  s i=$o(tmp2(i)) q:(i="")||(flag2=1)  d
	.i $l(i)<$l(startSort) s stopSort=$e(i,1,*),flag2=1
	s startSort=$o(tmp2(startSort),-1)
	
	TS
	s newKpiSubObj=##class(DHCNMG.DB.MgKpiItemSub).%New()
	q:'$IsObject(newKpiSubObj) 0
	s newKpiSubObj.Parref=oldKpiSubObj.Parref
	s newKpiSubObj.SubSort=oldKpiSubObj.SubSort
	s newKpiSubObj.SubPar=oldKpiSubObj.SubPar
	s newKpiSubObj.SubDesc=$g(tmp("SubDesc"))
	s newKpiSubObj.SubStandard=$g(tmp("SubStandard"))
	s newKpiSubObj.SubScore=+$g(tmp("SubScore"))
	s newKpiSubObj.SubCanBeNegative=$g(tmp("SubCanBeNegative"))
	i $g(tmp("SubStDate")) s newKpiSubObj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s newKpiSubObj.SubStDate=""
	i $g(tmp("SubEndDate")) s newKpiSubObj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s newKpiSubObj.SubEndDate=""
	s flag=newKpiSubObj.%Save()
	i flag=1 d
	.s sort=startSort f  s sort=$O(tmp2(sort)) q:(sort="")||(sort=stopSort)||(flag'=1)  d
	..s kpiSubObj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(tmp2(sort))
	..q:'$IsObject(kpiSubObj)
	..s tmpSort=kpiSubObj.SubSort
	..i $g(tmp("SubSort"))=2 s $e(tmpSort,1)=$p(kpiSubObj.SubSort,".")+1
	..e  s $e(tmpSort,$g(tmp("SubSort"))+$g(tmp("SubSort"))-1)=$p(kpiSubObj.SubSort,".",$g(tmp("SubSort")))+1
	..s kpiSubObj.SubSort=tmpSort
	..s flag=kpiSubObj.%Save()
	.s:flag=1 flag=..CalKpiScore(+$g(tmp("SubPar")),newKpiSubObj.SubPar)
	if flag
	{
		TC
	}
	else
	{
		Tro
		d $System.Status.DisplayError(flag)
	}
	q flag
}

/// Creator:wangpf
/// Description:新增Kpi标准计算质控sort
/// Date:2019年9月5日
/// Table: DHCNMG.DB.MgKpiItemSub
/// Input:
/// Output：
/// Return:
/// Others:二级：i.0；三级：i.0.j;四级：i.0.j.z。一级为父类（大标题****质控）
ClassMethod ComputeKpiNodeSort(parid) As %String
{
	s NodeSort=""
	i parid[".0" d //计算二级质控排序
	.s par=$p(parid,".",1)
	.s n=1 //n个二级质控
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgKpiItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(par_"||"_rw)
	..q:obj.SubPar'=""
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".")+1
	..s:nextsort>n n=nextsort
	.s NodeSort=n_".0"
	e  d //计算非二级质控排序
	.s par=$P(parid,"||",1)
	.s sort="",NodeSort="",n=1 //获取要要排的序号
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgKpiItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(par_"||"_rw)
	..q:(obj.SubPar'=parid) //父节点不对应的q
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".",$l(sort,"."))+1
	..s:nextsort>n n=nextsort
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parid)
	.s NodeSort=obj.SubSort_"."_n
	q NodeSort
}

/// Creator:wangpf
/// Description:计算Kpi分数并修改
/// Date:2019年9月5日
/// Table: DHCNMG.DB.MgKpiItem DHCNMG.DB.MgKpiItemSub
/// Input:父表(DHCNMG.DB.MgKpiItem)ID、父节点(DHCNMG.DB.MgKpiItemSub)ID
/// Output：
/// Return:
ClassMethod CalKpiScore(par, fatherid As %String) As %String
{
	s total=0
	if fatherid="" 
	{
		s rw="" f  s rw=$O(^DHCNMG.DB.MgKpiItemSubI("parr",par,rw)) q:rw=""  d
		.s subobj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(subobj)
		.q:subobj.SubPar'=""
		.s subscore=subobj.SubScore
		.s:subscore="" subscore=0
		.s total=total+subscore

		s parobj=##class(DHCNMG.DB.MgKpiItem).%OpenId(par)
		q:'$IsObject(parobj) 2
		s parobj.KpiScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
	}
	else
	{
		s subobj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(fatherid)
		q:'$IsObject(subobj) 2
		s total=..GetKpiItemSubScore(fatherid)
		s subobj.SubScore=total
		s sc=subobj.%Save()
		s flag=$$$ISOK(sc)
		s:flag=1 flag=..CalKpiScore(par,subobj.SubPar)
	}
	q flag
}

/// Creator:wangpf
/// CreatDate: 2019-09-06
/// Description: 删除Kpi项目子项及其下属节点
/// Table：DHCNMG.DB.MgKpiItemSub
/// Input：
/// Return：1：成功 2：已使用 0：失败
/// Other: w ##class(web.NurMgSetComm).DeleteKpiItemSub("17||65")
ClassMethod DeleteKpiItemSub(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(id)
	q:'$IsObject(obj) 0
	q:..CheckKpiItemUsed(+id) 2
	ts
	s fatherid=obj.SubPar
	s sort=obj.SubSort
	s flag=obj.%DeleteId(id)
	if $d(^DHCNMG.DB.MgKpiItemSubI("par"," "_id)) 
	{
		s rw="" f  s rw=$o(^DHCNMG.DB.MgKpiItemSubI("parr",+id,rw)) q:(rw="")||(flag'=1)  d
		.s childobj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(+id_"||"_rw)
		.s childsort=childobj.SubSort
		.q:$l(childsort)<=$l(sort)
		.i $e(childsort,0,$l(sort))=sort  s flag=childobj.%DeleteId(+id_"||"_rw)
	}
	s:flag=1 flag=..CalKpiScore(+id,fatherid)
	
	if flag=1{
		tc
	}else{
		tro
	}
	q flag
}

/// Creator:wangpf
/// Description:获取kpi子节点分数之和
/// Date:2019年9月5日
/// Table: DHCNMG.DB.MgKpiItemSub
/// Input:父节点id
/// Output：
/// Return:
ClassMethod GetKpiItemSubScore(parid) As %String
{
	s score=0
	s par=+$g(parid)
	s rw="" f  s rw=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_parid,par,rw)) q:rw=""  d
	.s subobj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(subobj)
	.s subscore=subobj.SubScore
	.s:subscore="" subscore=0
	.s score=score+subscore
	q score
}

/// Creator:wangpf
/// CreatDate: 2019-09-22
/// Description: 获取Kpi项目的数组
/// Table：DHCNMG.DB.MgKpiItemSub
/// Input：
/// Return：
/// Other：w ##class(web.NurMgSetComm).GetKpiTree2("2")
ClassMethod GetKpiTree(par As %String) As %Text
{
#;	s tmp=""
#;	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgKpiItemSubI("parr",par,rowid)) q:rowid=""  d
#;	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(par_"||"_rowid)
#;	.q:'$IsObject(obj)
#;	.s subScore=obj.SubScore
#;	.s subDesc=obj.SubDesc
#;	.s tmp(obj.SubSort)=par_"||"_rowid_"^"_subDesc_"("_subScore_")"
#;	
#;	s ret=[]
#;	s tmpParent(1)=ret
#;	s i="" f  s i=$o(tmp(i)) q:i=""  d
#;	.s children=[]
#;	.s tmpParent($l(i,"."))=children
#;	.d tmpParent($l(i,".")-1).%Push({"id":($p(tmp(i),"^")),"label":($p(tmp(i),"^",2)),"children":(children)})
#;	
#;	q ret.%ToJSON()

	w "["
	s tmp=""

	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgKpiItemSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(par_"||"_rowid)
	.q:'$IsObject(obj)
	.s subScore=obj.SubScore
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.q:subPar'=""
	.s tmp(1,$p(obj.SubSort,"."))=rowid_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(1,sort)) q:sort=""  d
	.i IsExist w ","
	.s rowid=$p(tmp(1,sort),"^")
	.s subDesc=$p(tmp(1,sort),"^",2)
	.w "{"_"""id"""_":"""_par_"||"_rowid_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetKpiSubItems(par,rowid,2)
	.w "}"
	.s IsExist=1
	w "]"
	q ""
}

/// 回调函数获取子节点
ClassMethod GetKpiSubItems(parid, rowid, level) As %Text
{
	w "["
	k tmp(level)
	s rw="" f  s rw=$O(^DHCNMG.DB.MgKpiItemSubI("par"," "_parid_"||"_rowid,parid,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parid_"||"_rw)
	.q:(obj.SubPar'=(parid_"||"_rowid))
	.s subStandard=obj.SubStandard
	.s subScore=obj.SubScore
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.s tmp(level,$p(obj.SubSort,".",$l(obj.SubSort,".")))=rw_"^"_subDesc
	s IsExist=0
	s sort="" f  s sort=$o(tmp(level,sort)) q:sort=""  d
	.i IsExist w ","
	.s rw=$p(tmp(level,sort),"^")
	.s subDesc=$p(tmp(level,sort),"^",2)
	.w "{"_"""id"""_":"""_parid_"||"_rw_""",""label"":"""_subDesc_""",""children"":"
	.d ..GetKpiSubItems(parid,rw,level+1)
	.w "}"
	.s IsExist=1
	w "]"
}

/// Creator:wangpf
/// Description:根据key(id)查找Tree的节点信息
/// Date:2019-09-06
/// Table: DHCNMG.DB.MgKpiItemSub
/// Input:
/// Output：
/// Return:
ClassMethod GetKpiTreeData(id As %String) As %String
{
	s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(id)
	q:'$IsObject(obj) ""
	s SubDesc=obj.SubDesc
	s SubStandard=obj.SubStandard
	s SubScore=obj.SubScore
	s SubCanBeNegative=obj.SubCanBeNegative
	i obj.SubStDate'="" s SubStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)
	e  s SubStDate=""
	i obj.SubEndDate'="" s SubEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)
	e  s SubEndDate=""
	s ret="RowID|"_id_"^SubDesc|"_SubDesc_"^SubStandard|"_SubStandard_"^SubScore|"_SubScore_"^SubCanBeNegative|"_SubCanBeNegative_"^SubStDate|"_SubStDate_"^SubEndDate|"_SubEndDate
	q ret
}

/// creator:wangpf
/// createdate:2019-09-10
/// description:保存导入Kpi项目及其子项
/// table:DHCNMG.DB.MgKpiItem,DHCNMG.DB.MgKpiItemSub
/// input:
/// output:
/// other:w ##class(web.NurMgSetComm).SaveImporKpiData()
ClassMethod SaveImporKpiData(parr, parr2) As %String
{
	s parr=$replace(parr,"\","\\"),parr2=$replace(parr2,"\","\\")
	ts
	s kpiItemId=..SaveKpiItem(parr)
	i kpiItemId>0 d
	.s flag=1,lastTwoLevelId="",lastThreeLevelId="",tSubPar=""
	.s kpiItemObj=##class(DHCNMG.DB.MgKpiItem).%OpenId(kpiItemId)
	.f i=1:1:$l(parr2,"@") q:flag'=1  d
	..k tmp
	..s tmp=""
	..d ##class(web.NurMgVueComm).SplitStr($p(parr2,"@",i),"^","|",.tmp)
	..s obj=##class(DHCNMG.DB.MgKpiItemSub).%New()
	..s obj.Parref=kpiItemObj
	..s obj.SubSort=$g(tmp("sort"))
	..s length=$l($g(tmp("sort")),".")
	..i length>4 s flag=-2 q
	..i length=2 s tSubPar=""
	..e  i length=3 s tSubPar=lastTwoLevelId
	..e  i length=4 s tSubPar=lastThreeLevelId
	..s obj.SubPar=tSubPar
	..s obj.SubDesc=$g(tmp("desc"))
	..s obj.SubStandard=$g(tmp("standard"))
	..s obj.SubScore=+$g(tmp("score"))
	..s obj.SubCanBeNegative=$g(tmp("canbenegative"))
	..i $g(tmp("stdate")) s obj.SubStDate=$zdh(tmp("stdate"),3)
	..e  s obj.SubStDate=""
	..i $g(tmp("enddate")) s obj.SubEndDate=$zdh(tmp("enddate"),3)
	..e  s obj.SubEndDate=""
	..s flag=obj.%Save()
	..i ($$$ISOK(flag)=1) d
	...i $l(obj.SubSort,".")=2 s lastTwoLevelId=obj.%Id()
	...e  i $l(obj.SubSort,".")=3 s lastThreeLevelId=obj.%Id()
	...s flag=..CalKpiScore(kpiItemId,obj.SubPar)
	e  s flag=-1
	if (flag=1)&&(kpiItemId>0)
	{
		tc
		q 1
	}else{
		tro
		q flag
	}
}

/// creator:wangpf
/// createdate:2019-09-09
/// description:获取Kpi考核项目导出数据
/// table:DHCNMG.DB.MgKpiItemSub
/// input:质控标准ID
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindExportKpiData","1")
Query FindExportKpiData(id As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindExportKpiDataExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if id="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k tmp
	
	//获取所有节点
	k tmp
	s subid="" f  s subid=$O(^DHCNMG.DB.MgKpiItemSubI("parr",id,subid)) q:subid=""  d
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(id_"||"_subid)
	.q:'$IsObject(obj)
	.q:obj.SubSort=""
	.s tmp(obj.SubSort)=obj.%Id()
	if '$d(tmp) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ret=""
	s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
	.s subid=tmp(sort)
	.s obj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(subid)
	.s stdate=obj.SubStDate
	.s:stdate'="" stdate=##class(web.NurMgHISComm).DateLogicalToHtml(stdate)
	.s enddate=obj.SubEndDate
	.s:enddate'="" enddate=##class(web.NurMgHISComm).DateLogicalToHtml(enddate)
	.s score=obj.SubScore
	.s:$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_subid)) score=""
	.s canbenegative=obj.SubCanBeNegative
	.s ret="sort|"_obj.SubSort_"^desc|"_obj.SubDesc_"^standard|"_obj.SubStandard_"^stdate|"_stdate_"^enddate|"_enddate_"^score|"_score_"^canbenegative|"_canbenegative
	.d OutExportKpiData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutExportKpiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExportKpiDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExportKpiDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindExportKpiDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExportKpiDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:gzj
/// Createdate:2020-04-20
/// Description:获取系统参数明细数据
/// Table:DHCNMG.Set.MgSysParamSub
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindParamSubData","")
Query FindParamSubData(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindParamSubDataExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	s parcode=$P(parr,"^",2)
	s type=$p(parr,"^",3)
	i parid="" s parid=$O(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt(parcode,"U"),""))
	s par="" f  s par=$O(^DHCNMG.Set.MgSysParamSubD(par)) q:par=""  d
	.q:((parid="")||((parid'="")&&(parid'=par)))
	.s child="" f  s child=$O(^DHCNMG.Set.MgSysParamSubD(par,child)) q:child=""  d
	..s id=par_"||"_child
	..s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(id)
	..q:'$IsObject(obj)
	..s code=obj.SubCode
	..s desc=obj.SubDesc
	..s ZCODE=$ZCVT(code,"U")
	..q:((obj.SubEndDate'="")&&(obj.SubEndDate<(+$H)))
	..q:((parcode="QUALTYPE")&&(type="QUAL")&&((ZCODE="NIGHTCHECK")!(ZCODE="WEEKCHECK")!(ZCODE="HOLIDAYCHECK")))
	..s ret="rw|"_$tr(id,"||","__")_"^parid|"_obj.Parref.%Id()_"^ParamDesc|"_obj.Parref.ParamDesc_"^SubCode|"_obj.SubCode_"^SubDesc|"_obj.SubDesc_"^SubValue|"_obj.SubValue_"^SubSymbol|"_obj.SubSymbol_"^SubColor|"_obj.SubColor_"^SubRemark|"_obj.SubRemark_"^SubStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubStDate)_"^SubEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubEndDate)_"^SubSort|"_obj.SubSort
	..d OutParamSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutParamSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindParamSubDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindParamSubDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindParamSubDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindParamSubDataExecute ]
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
