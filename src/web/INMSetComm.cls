/// Creator:lulin
/// Descriptions:系统设置模块方法类
/// Date:2020-05-25
Class web.INMSetComm Extends %RegisteredObject
{

/// Creator:
/// Createdate:
/// Description:获取系统参数子表列表--各个界面-使用系统参数列表使用
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMSetComm","FindParamSubList","^WardType")
Query FindParamSubList(parr As %String = "", flag As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindParamSubListExecute(ByRef qHandle As %Binary, parr As %String = "", flag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	s parcode=$P(parr,"^",2)
	s type=$p(parr,"^",3)
	i parid="" s parid=$O(^CT.DHCINM.Set.MgSysParamI("Code"," "_$zcvt(parcode,"U"),""))
	s par="" f  s par=$O(^CT.DHCINM.Set.MgSysParamSubD(par)) q:par=""  d
	.q:((parid="")||((parid'="")&&(parid'=par)))
	.s SubSort="" f  s SubSort=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,SubSort)) q:SubSort=""  d
	..s child="" f  s child=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,SubSort,child)) q:child=""  d
	...s id=par_"||"_child
	...s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(id)
	...q:(flag=1)&&((obj.SubStDate="")||(obj.SubStDate>+$h)||((obj.SubEndDate'="")&&(obj.SubEndDate<+$h)))
	...s code=obj.SubCode
	...s desc=obj.SubDesc
	...s ZCODE=$ZCVT(code,"U")
	...q:((parcode="QUALTYPE")&&(type="QUAL")&&((ZCODE="NIGHTCHECK")!(ZCODE="WEEKCHECK")!(ZCODE="HOLIDAYCHECK")))
	...s ret=..GetParamSub(id)
	...d OutParamSub
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

/// Creator:
/// Createdate:
/// Description:根据系统参数代码、子表代码、字段名称获取参数子表某字段值
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).GetParamSubByCode("TOMCATSERVICE","TOMCATURL","SubDesc")
ClassMethod GetParamSubByCode(parcode As %String, subcode As %String, itm As %String) As %String
{
	q:(parcode="")!(subcode="")!(itm="") ""
	s parid=$O(^CT.DHCINM.Set.MgSysParamI("Code"," "_$zcvt(parcode,"U"),""))
	q:parid="" ""
	s subid=$O(^CT.DHCINM.Set.MgSysParamSubI("Code"," "_$zcvt(subcode,"U"),parid,""))
	q:subid="" ""
	s id=parid_"||"_subid
	s ret=..GetParamSub(id)
	d ##class(web.INMVueComm).SplitStr(ret,"^","|",.tmp)
	s val=$g(tmp(itm))
	q val
}

/// Creator:
/// Createdate:
/// Description:获取综合参数时段修改标识
/// Input:
/// Output:
/// Other:
ClassMethod GetArgTimeSlot() As %String
{
	s flag="false"
	s rw=$o(^CT.DHCINM.Set.MgArgParamSetD(""))
	q:rw="" flag
	s obj=##class(CT.DHCINM.Set.MgArgParamSet).%OpenId(rw)
	q:'$IsObject(obj) flag
	s flag=obj.ArgTimeSlot
	q flag
}

/// ------------公共方法分割线-----------------------
/// Creator:
/// Createdate:
/// Description:根据模块数据
/// Input:
/// Output:
/// Other:d ##class(web.INMSetComm).SaveModule("")
ClassMethod SaveModule(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(CT.DHCINM.Set.MgModule).%OpenId(tmp("rw"))
	e  s obj=##class(CT.DHCINM.Set.MgModule).%New()
	s obj.ModuleCode=$g(tmp("ModuleCode"))
	s obj.ModuleDesc=$g(tmp("ModuleDesc"))
	i $g(tmp("ModuleMenuDR"))'="" d
	.s obj.ModuleMenuDR=##class(CT.DHCINM.Set.MgMenu).%OpenId(tmp("ModuleMenuDR"))
	e  s obj.ModuleMenuDR=""
	i $g(tmp("ModuleSort"))'="" s obj.ModuleSort=tmp("ModuleSort")
	e  s obj.ModuleSort=..GetMaxModuleSort()
	i $g(tmp("ModuleStDate"))'="" s obj.ModuleStDate=$zdh(tmp("ModuleStDate"),3)
	e  s obj.ModuleStDate=""
	i $g(tmp("ModuleEndDate"))'="" s obj.ModuleEndDate=$zdh(tmp("ModuleEndDate"),3)
	e  s obj.ModuleEndDate=""
	s obj.IsAdvanced=$g(tmp("IsAdvanced"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:判断模块代码是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistModule(parr As %String) As %String
{
	q:parr="" 0
	k tmp
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s RowID=$o(^CT.DHCINM.Set.MgModuleI("Code"," "_$zcvt($tr($g(tmp("ModuleCode"))," ",""),"U"),""))
	s flag=0
	i id="" d
	.i RowID'="" s flag=-1
	e  d
	.i RowID'=id s flag=-1
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取模块数据
/// Input:
/// Output:
/// Other:
ClassMethod GetModule(id As %String) As %String
{
	q:id="" "入参不能为空"
	s obj=##class(CT.DHCINM.Set.MgModule).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^ModuleCode|"_obj.ModuleCode
	s ret=ret_"^ModuleDesc|"_obj.ModuleDesc
	i obj.ModuleMenuDR'="" d
	.s ret=ret_"^ModuleMenuDR|"_obj.ModuleMenuDR.%Id()
	.s ret=ret_"^MenuDesc|"_obj.ModuleMenuDR.MenuDesc
	s IsAdvanced=obj.IsAdvanced
	s:IsAdvanced="" IsAdvanced="N"
	s ret=ret_"^ModuleSort|"_obj.ModuleSort_"^IsAdvanced|"_IsAdvanced
	i obj.ModuleStDate'="" s ret=ret_"^ModuleStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ModuleStDate)
	i obj.ModuleEndDate'="" s ret=ret_"^ModuleEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.ModuleEndDate)
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取模块最大顺序
/// Input:
/// Output:
/// Other:
ClassMethod GetMaxModuleSort() As %Integer
{
	s order=1
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.i sort>order d 
	.s order=sort
	q order+1
}

/// Creator:
/// Createdate:
/// Description:查询模块数据列表
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMSetComm","FindModuleList","")
Query FindModuleList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindModuleListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code=$P(parr,"^",1)
	s desc=$P(parr,"^",2)
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort)) q:sort=""  d 
	.s id="" f  s id=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..s obj=##class(CT.DHCINM.Set.MgModule).%OpenId(id)
	..s modulecode=obj.ModuleCode
	..q:(code'="")&&($zcvt(modulecode,"U")'[$zcvt(code,"U"))
	..s moduledesc=obj.ModuleDesc
	..q:(desc'="")&&($zcvt(moduledesc,"U")'[$zcvt(desc,"U"))
	..q:(($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N")&&(obj.IsAdvanced="Y"))
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

/// Creator:
/// Createdate:
/// Description:保存菜单数据
/// Input:
/// Output:
/// Other:d ##class(web.INMSetComm).SaveMenu(^TMP("SaveMenu"))
ClassMethod SaveMenu(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
#;	s menuRouter=$g(tmp("MenuRouter"))
#;	s routerRW=$O(^CT.DHCINM.Set.MgMenuI("route"," "_$zcvt(menuRouter,"U"),""))
#;	s rw=$g(tmp("rw"))
#;	q:((menuRouter'="")&&(routerRW'="")&&(routerRW'=rw)) "路由重复"
	i $g(tmp("rw"))'="" d
	.s obj=##class(CT.DHCINM.Set.MgMenu).%OpenId(tmp("rw"))
	e  s obj=##class(CT.DHCINM.Set.MgMenu).%New()
	s obj.MenuCode=$g(tmp("MenuCode"))
	s obj.MenuDesc=$g(tmp("MenuDesc"))
	i $g(tmp("MenuModuleDR"))'="" d
	.s obj.MenuModuleDR=##class(CT.DHCINM.Set.MgModule).%OpenId(tmp("MenuModuleDR"))
	.s obj.MenuSort=..GetMaxMenuSort(tmp("MenuModuleDR"))
	e  s obj.MenuModuleDR=""
	s obj.MenuRouter=$g(tmp("MenuRouter"))
	i $g(tmp("MenuParentDR"))'="" d
	.s obj.MenuParentDR=##class(CT.DHCINM.Set.MgMenu).%OpenId(tmp("MenuParentDR"))
	e  s obj.MenuParentDR=""
	s obj.MenuLink=$g(tmp("MenuLink"))
	s obj.MenuParams=$g(tmp("MenuParams"))
	s obj.MenuIcon=$g(tmp("MenuIcon"))
	i $g(tmp("MenuSort"))'="" s obj.MenuSort=$g(tmp("MenuSort"))
	i $g(tmp("MenuStDate"))'="" s obj.MenuStDate=$zdh($g(tmp("MenuStDate")),3)
	e  s obj.MenuStDate=""
	i $g(tmp("MenuEndDate"))'="" s obj.MenuEndDate=$zdh($g(tmp("MenuEndDate")),3)
	e  s obj.MenuEndDate=""
	;新增path
	s MenuPath=$g(tmp("MenuPath"))
	s obj.MenuPath=MenuPath
	s obj.IsAdvanced=$g(tmp("IsAdvanced"))
	s sc=obj.%Save()
	if $$$ISOK(sc) {
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Creator:
/// Createdate:
/// Description:判断菜单代码是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistMenu(parr As %String) As %String
{
	q:parr="" 0
	k tmp
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s RowID=$o(^CT.DHCINM.Set.MgMenuI("Code"," "_$zcvt($tr($g(tmp("MenuCode"))," ",""),"U"),""))
	s flag=0
	i id="" d
	.i RowID'="" s flag=-1
	e  d
	.i RowID'=id s flag=-1
	q flag
}

/// Creator:
/// Createdate:
/// Description:查询菜单数据
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).GetMenu(2)
ClassMethod GetMenu(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CT.DHCINM.Set.MgMenu).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^MenuCode|"_obj.MenuCode
	s ret=ret_"^MenuDesc|"_obj.MenuDesc
	i obj.MenuModuleDR'="" d
	.s ret=ret_"^MenuModuleDR|"_obj.MenuModuleDR.%Id()
	.s ret=ret_"^ModuleDesc|"_obj.MenuModuleDR.ModuleDesc
	i obj.MenuParentDR'="" d
	.s ret=ret_"^MenuParentDR|"_obj.MenuParentDR.%Id()
	.s ret=ret_"^ParentDesc|"_obj.MenuParentDR.MenuDesc
	s ret=ret_"^MenuRouter|"_obj.MenuRouter
	s ret=ret_"^MenuLink|"_obj.MenuLink
	s ret=ret_"^MenuParams|"_obj.MenuParams
	s ret=ret_"^MenuIcon|"_obj.MenuIcon
	s ret=ret_"^MenuSort|"_obj.MenuSort
	s ret=ret_"^MenuPath|"_obj.MenuPath
	s ret=ret_"^MenuStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.MenuStDate)
	s ret=ret_"^MenuEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.MenuEndDate)
	s IsAdvanced=obj.IsAdvanced
	s:IsAdvanced="" IsAdvanced="N"
	s ret=ret_"^IsAdvanced|"_IsAdvanced
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取菜单最大顺序
/// Input:
/// Output:
/// Other:d ##class(web.INMSetComm).GetMaxMenuSort(9)
ClassMethod GetMaxMenuSort(module As %String) As %String
{
	q:module="" ""
	s order=0
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgMenuI("ModuleSort",module,sort)) q:sort=""  d
	.i sort>order s order=sort
	q order+1
}

/// Creator:
/// Createdate:
/// Description:查询菜单列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMSetComm","FindMenuList","^^^")
Query FindMenuList(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMenuListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TEMP("FindMenuList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s code=$P(parr,"^",1)
	s desc=$P(parr,"^",2)
	s module=$P(parr,"^",3)
	s childFlag=$P(parr,"^",4)
	s isLCDP=$P(parr,"^",5)
	s retTmp=""
	s sort1="" f  s sort1=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort1)) q:sort1=""  d
	.s moduledr="" f  s moduledr=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort1,moduledr)) q:moduledr=""  d
	..q:(module'="")&&(module'=moduledr)
	..s moduleObj=##class(CT.DHCINM.Set.MgModule).%OpenId(moduledr)
	..q:'$IsObject(moduleObj)
	..q:(($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N")&&(moduleObj.IsAdvanced="Y"))
	..s sort2="" f  s sort2=$O(^CT.DHCINM.Set.MgMenuI("ModuleSort",moduledr,sort2)) q:sort2=""  d
	...s id="" f  s id=$O(^CT.DHCINM.Set.MgMenuI("ModuleSort",moduledr,sort2,id)) q:id=""  d
	....s obj=##class(CT.DHCINM.Set.MgMenu).%OpenId(id)
	....s menuGlo=$g(^CT.DHCINM.Set.MgMenuD(id))
	....q:(isLCDP'="")&&(isLCDP'=$lg(menuGlo,15))
	....s menucode=obj.MenuCode
	....q:((childFlag=1)&&(obj.MenuRouter="")) ;默认菜单备选项必须有可跳转的vue界面
	....q:(code'="")&&($zcvt(menucode,"U")'[$zcvt(code,"U"))
	....s menudesc=obj.MenuDesc
	....q:(desc'="")&&($zcvt(menudesc,"U")'[$zcvt(desc,"U"))
	....s notAdvanced=($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N") ;标准版
	....q:(notAdvanced&&((obj.IsAdvanced="Y")||(($IsObject(obj.MenuParentDR))&&(obj.MenuParentDR.IsAdvanced="Y"))))
	....s fatherIsAdvanced=1
	....s fatherId=1
	....s:$IsObject(obj.MenuParentDR) fatherId=obj.MenuParentDR.%Id()
	....s retTmp(sort1,fatherId,sort2,id)=id
#;	....s ret=..GetMenu(id)
#;	....d OutMenu
	s sort1="" f  s sort1=$O(retTmp(sort1)) q:sort1=""  d
	.s fatherId="" f  s fatherId=$O(retTmp(sort1,fatherId)) q:fatherId=""  d
	..s sort2="" f  s sort2=$O(retTmp(sort1,fatherId,sort2)) q:sort2=""  d
	...s id="" f  s id=$O(retTmp(sort1,fatherId,sort2,id)) q:id=""  d
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

/// Creator:
/// Createdate:
/// Description:保存用户角色
/// Input:
/// Output:
/// Other:d ##class(web.INMSetComm).SaveRole("")
ClassMethod SaveRole(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistRole(parr)
	q:flag=-1 "此记录已经存在，保存失败"
	i $g(tmp("rw"))'="" s obj=##class(CT.DHCINM.Set.MgRoles).%OpenId(tmp("rw"))
	e  s obj=##class(CT.DHCINM.Set.MgRoles).%New()
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

/// Creator:
/// Createdate:
/// Description:判断角色代码是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistRole(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s id=$o(^CT.DHCINM.Set.MgRolesI("code"," Y"," "_$zcvt($tr($g(tmp("RoleCode"))," ",""),"U"),""))
	i rw="" d
	.i id'="" s flag=-1
	e  d
	.i ((id'="")&&(id'=rw)) s flag=-1
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取用户角色最大序号
/// Input:
/// Output:
/// Other:
ClassMethod ComRoleSort() As %String
{
	s n=1
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort,rw)) q:rw=""  d
	..s obj=##class(CT.DHCINM.Set.MgRoles).%OpenId(rw)
	..i obj.RoleSort'="" s n=n+1
	q n
}

/// Creator:
/// Createdate:
/// Description:移动角色位置序号
/// Input:
/// Output:
/// Other:
ClassMethod SetRoleSort(rowid As %String, type As %String) As %String
{
	q:rowid="" ""
	s ret=0
	s obj=##class(CT.DHCINM.Set.MgRoles).%OpenId(rowid)
	s sort=obj.RoleSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.RoleSort=sort-1
		.s row=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort-1,""))
		.s bobj=##class(CT.DHCINM.Set.MgRoles).%OpenId(row)
		.s bobj.RoleSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^CT.DHCINM.Set.MgRolesI("Sort",""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.RoleSort=sort+1
		.s row=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort+1,""))
		.s bobj=##class(CT.DHCINM.Set.MgRoles).%OpenId(row)
		.s bobj.RoleSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取用户角色数据
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).GetRole("")
ClassMethod GetRole(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CT.DHCINM.Set.MgRoles).%OpenId(id)
	q:'$IsObject(obj)
	s ret="rw|"_id
	s ret=ret_"^RoleCode|"_obj.RoleCode
	s ret=ret_"^RoleDesc|"_obj.RoleDesc
	;s ret=ret_"^RoleLevel|"_$case(obj.RoleLevel,"1":"一级","2":"二级","3":"三级","4":"四级","5":"五级","6":"六级","7":"七级","8":"八级","9":"九级","10":"十级",:"")
	s ret=ret_"^RoleLevel|"_obj.RoleLevel
	s ret=ret_"^RoleRemark|"_obj.RoleRemark
	s ret=ret_"^RoleStatus|"_obj.RoleStatus
	s ret=ret_"^StatusDesc|"_$Case(obj.RoleStatus,"Y":"启用","N":"停用",:"")
	s ret=ret_"^RoleSort|"_obj.RoleSort
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取用户角色列表
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMSetComm","FindRoleList","")
Query FindRoleList(parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort,id)) q:id=""  d
	..s obj=##class(CT.DHCINM.Set.MgRoles).%OpenId(id)
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

/// Creator:
/// Createdate:
/// Description:保存系统参数
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).SaveParam("ParamCode|WardType^ParamDesc|科室类型^ParamRemark|^ParamStatus|Y")
ClassMethod SaveParam(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(CT.DHCINM.Set.MgSysParam).%OpenId(tmp("rw"))
	e  s obj=##class(CT.DHCINM.Set.MgSysParam).%New()
	s obj.ParamCode=$g(tmp("ParamCode"))
	s obj.ParamDesc=$g(tmp("ParamDesc"))
	s obj.ParamRemark=$g(tmp("ParamRemark"))
	s obj.ParamStatus=$g(tmp("ParamStatus"))
	i $g(tmp("ParamLink"))'="" d
	.s obj.ParamLink=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(tmp("ParamLink"))
	e  s obj.ParamLink=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:判断系统参数代码是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistParam(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	s RowID=$o(^CT.DHCINM.Set.MgSysParamI("Code"," "_$zcvt($tr($g(tmp("ParamCode"))," ",""),"U"),""))
	s flag=0
	i id="" d
	.i RowID'="" s flag=-1
	e  d
	.i RowID'=id s flag=-1
	
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取系统参数数据
/// Input:
/// Output:
/// Other:
ClassMethod GetParam(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CT.DHCINM.Set.MgSysParam).%OpenId(id)
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

/// Creator:
/// Createdate:
/// Description:获取系统参数数据列表
/// Input:
/// Output:
/// Other:
Query FindParamList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindParamListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id="" f  s id=$O(^CT.DHCINM.Set.MgSysParamD(id)) q:id=""  d
	.s obj=##class(CT.DHCINM.Set.MgSysParam).%OpenId(id)
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

/// Creator:
/// Createdate:
/// Description:保存系统参数子表数据
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).SaveParamSub("SubCode|W^SubDesc|病区^SubValue|^SubSymbol|^SubColor|#B43535^SubRemark|^SubStDate|2017-08-14^SubEndDate|^rw|^^parid|1")
ClassMethod SaveParamSub(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:$g(tmp("parid"))=""
	i $g(tmp("rw"))'="" d
	.s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CT.DHCINM.Set.MgSysParamSub).%New()
	.s obj.Parref=##class(CT.DHCINM.Set.MgSysParam).%OpenId(tmp("parid"))
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
	i obj.Parref.ParamCode="NightCheckBasic" d
 	.q:$d(^oddCOM("DHCINM.CHK.MgNurNightBasic","a",obj.SubCode))
 	.s property=##class(%Dictionary.PropertyDefinition).%New("DHCINM.CHK.MgNurNightBasic:"_obj.SubCode)
 	.s property.Type="%String"
 	.s lastSort=$o(^oddCOM("DHCINM.CHK.MgNurNightBasic","s","Default","D","MgNurNightBasicDefaultData","V",""),-1)
 	.s property.SqlColumnNumber=lastSort+1
 	.s sc2=property.%Save()
 	.q:sc2'=1
 	.s sc2=$SYSTEM.OBJ.Compile("DHCINM.CHK.MgNurNightBasic","-d")
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:获取系统参数子表数据
/// Input:
/// Output:
/// Other:
ClassMethod GetParamSub(id As %String) As %String
{
	q:id="" ""
	s id=$tr(id,"__","||")
	s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(id)
	s ret="rw|"_$tr(id,"||","__")
	s ret=ret_"^parid|"_obj.Parref.%Id()
	s ret=ret_"^ParamDesc|"_obj.Parref.ParamDesc
	s ret=ret_"^SubCode|"_obj.SubCode
	s ret=ret_"^SubDesc|"_obj.SubDesc
	s ret=ret_"^SubValue|"_obj.SubValue
	s ret=ret_"^SubSymbol|"_obj.SubSymbol
	s ret=ret_"^SubColor|"_obj.SubColor
	s ret=ret_"^SubRemark|"_obj.SubRemark
	s ret=ret_"^SubStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.SubStDate)
	s ret=ret_"^SubEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.SubEndDate)
	s ret=ret_"^SubSort|"_obj.SubSort
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取系统参数子表列表---系统设置-系统参数界面使用
/// Input:
/// Output:
/// Other:w ##class(%ResultSet).RunQuery("web.INMSetComm","FindSetParSubList","^WardType")
Query FindSetParSubList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSetParSubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parid=$P(parr,"^",1)
	s parcode=$P(parr,"^",2)
	
	i parid="" s parid=$O(^CT.DHCINM.Set.MgSysParamI("Code"," "_$zcvt(parcode,"U"),""))
	s par=parid
	q:(parid'="")&&(parid'=par)
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,sort)) q:sort=""  d
	.;s par="" f  s par=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",sort,par)) q:par=""  d
	.s raw="" f  s raw=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,sort,raw)) q:raw=""  d
	..s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(par_"||"_raw)
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

/// Creator:
/// Createdate:
/// Description:保存综合参数
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).SaveArgParam("ArgPeriod|Week^ArgCountUnit|^ArgCrossDay|^NightStTime1|18:00^NightEndTime1|08:00^DayHour1|^AMHour1|^PMHour1|^NightStTime2|18:00^NightEndTime2|08:00^DayHour2|^AMHour2|^PMHour2|^ArgUpdateDay|14^BedBR|0.4^ArgStandardTime|8^ArgTimeSlot|true^InsertColumn|0^StDate|^Cycle|0^NurMgInter|E^AdvInter|A^")
ClassMethod SaveArgParam(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $d(^CT.DHCINM.Set.MgArgParamSetD(1)) d
	.s obj=##class(CT.DHCINM.Set.MgArgParamSet).%OpenId(1)
	e  s obj=##class(CT.DHCINM.Set.MgArgParamSet).%New()
	s obj.ArgPeriod=$g(tmp("ArgPeriod"))
	s obj.ArgCountUnit=$g(tmp("ArgCountUnit"))
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
	s obj.InsertColumn=$g(tmp("InsertColumn"))
	s obj.RotCycle=$g(tmp("Cycle"))
	i $g(tmp("StDate"))["-" d
	.s obj.RotStDate=$zdh($g(tmp("StDate")),3)
	e  d
	.s obj.RotStDate=""
	s obj.NurMgInter=$g(tmp("NurMgInter"))
	s obj.AdvInter=$g(tmp("AdvInter"))
	s obj.SenFlag=$g(tmp("SenFlag"))
	s obj.IsAdvanced=$g(tmp("IsAdvanced"))
	s obj.NoticeDay=$g(tmp("NoticeDay"))
	s obj.NoticeShowDay=$g(tmp("NoticeShowDay"))
	s obj.NurMgOtherSever=$g(tmp("NurMgOtherSever"))
	s obj.NurMgOtherPort=$g(tmp("NurMgOtherPort"))
	s obj.NurMgOtherUrl=$g(tmp("NurMgOtherUrl"))
	s obj.RegNoLength=$g(tmp("RegNoLength"))
	s obj.PlatFlag=$g(tmp("PlatFlag"))
	s obj.MailFlag=$g(tmp("MailFlag"))
	s obj.ArgPerType=$g(tmp("ArgPerType"))
	s obj.FilePreviewType=$g(tmp("FilePreviewType"))
	s obj.ArgGroupIcon=$g(tmp("ArgGroupIcon"))
	s obj.ArgInternIcon=$g(tmp("ArgInternIcon"))
	s obj.ArgComeIcon=$g(tmp("ArgComeIcon"))
	d obj.ArgIconSort.Clear()
	i $g(tmp("ArgIconSort"))'="" d
	.f i=1:1:$l(tmp("ArgIconSort"),",") d
	..d obj.ArgIconSort.Insert($p(tmp("ArgIconSort"),",",i))
	s obj.IsPostToHR=$g(tmp("IsPostToHR"))
	s obj.HRSever=$g(tmp("HRSever"))
	s obj.HRPort=$g(tmp("HRPort"))
	s obj.HRUrl=$g(tmp("HRUrl"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:获取综合参数
/// Input:
/// Output:
/// Other w ##class(web.INMSetComm).GetArgParam("1")
ClassMethod GetArgParam(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CT.DHCINM.Set.MgArgParamSet).%OpenId(id)
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
	s ret=ret_"^InsertColumn|"_obj.InsertColumn_"^Cycle|"_obj.RotCycle
	s:obj.RotStDate'="" ret=ret_"^StDate|"_$zd(obj.RotStDate,3)
	s:obj.RotStDate="" ret=ret_"^StDate|"
	s IsAdvanced=obj.IsAdvanced
	s:IsAdvanced="" IsAdvanced="Y"
	s PlatFlag=obj.PlatFlag
	s:PlatFlag="" PlatFlag="Y"
	s MailFlag=obj.MailFlag
	s:MailFlag="" MailFlag="Y"
	s FilePreviewType=obj.FilePreviewType
	s:FilePreviewType="" FilePreviewType=1
	s ret=ret_"^NurMgInter|"_obj.NurMgInter_"^AdvInter|"_obj.AdvInter_"^SenFlag|"_obj.SenFlag
	_"^IsAdvanced|"_IsAdvanced_"^NoticeDay|"_obj.NoticeDay_"^NoticeShowDay|"_obj.NoticeShowDay
	_"^NurMgOtherSever|"_obj.NurMgOtherSever_"^NurMgOtherPort|"_obj.NurMgOtherPort_"^NurMgOtherUrl|"_obj.NurMgOtherUrl
	_"^RegNoLength|"_obj.RegNoLength_"^PlatFlag|"_PlatFlag_"^MailFlag|"_MailFlag_"^ArgPerType|"_obj.ArgPerType
	_"^FilePreviewType|"_FilePreviewType_"^IsPostToHR|"_obj.IsPostToHR_"^HRSever|"_obj.HRSever_"^HRPort|"_obj.HRPort_"^HRUrl|"_obj.HRUrl
	s AppVersion="",AppUrl="",AppId="",AppNote="",AppTitle=""
	
	s argIconSort="",argIconSortDesc=""
	f i=1:1:obj.ArgIconSort.Count() d
	.s value=obj.ArgIconSort.GetAt(i)
	.s desc=$case(value,"T":"类型","P":"职务","H":"职称",:"")
	.s argIconSort=argIconSort_$case(i,1:"",:",")_value
	.s argIconSortDesc=argIconSortDesc_$case(i,1:"",:",")_desc
	s ret=ret_"^ArgGroupIcon|"_obj.ArgGroupIcon_"^ArgInternIcon|"_obj.ArgInternIcon_"^ArgComeIcon|"_obj.ArgComeIcon_"^ArgIconSort|"_argIconSort_"^ArgIconSortDesc|"_argIconSortDesc
	
	s appObj=##class(CF.DHCINM.Set.MgVersion).%OpenId(1)
	i $IsObject(appObj) d
	.s AppVersion=appObj.AppVersion
	.s AppUrl=appObj.AppUrl
	.s AppId=appObj.AppId
	.s AppNote=appObj.AppNote
	.s AppTitle=appObj.AppTitle
	s ret=ret_"^AppVersion|"_AppVersion_"^AppUrl|"_AppUrl_"^AppId|"_AppId_"^AppNote|"_AppNote_"^AppTitle|"_AppTitle
	q ret
}

/// Creator:
/// Createdate:
/// Description:重置综合参数
/// Input:
/// Output:
/// Other 
ClassMethod ResetArgParam(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s obj=##class(CT.DHCINM.Set.MgArgParamSet).%OpenId(1)
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
	s obj.FilePreviewType=$g(tmp("FilePreviewType"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:保存列表数据
/// Input:
/// Output:
/// Other:
ClassMethod SaveFieldSet(parr As %String) As %String
{
	//FieldDesc|工号^FieldCode|PerID^FieldSort|1^FieldDisplay|true^FieldLock|false^FieldLockPos|-1
	//^RowID|^FieldTable|3
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" d
	.s obj=##class(CT.DHCINM.Set.MgFieldSet).%New()
	e  s obj=##class(CT.DHCINM.Set.MgFieldSet).%OpenId(id)
	s obj.FieldCode=$tr(tmp("FieldCode")," ","")
	s obj.FieldDesc=$tr(tmp("FieldDesc")," ","")
	s obj.FieldDisplay=$tr(tmp("FieldDisplay")," ","")
	s obj.FieldSelect=$tr(tmp("FieldSelect")," ","")
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

/// Creator:
/// Createdate:
/// Description:查询列表字段
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindFieldSetList","22")
Query FindFieldSetList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindFieldSetListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgFieldSetI("sort"," "_parr,sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^CT.DHCINM.Set.MgFieldSetI("sort"," "_parr,sort,rowid)) q:rowid=""  d
	..s obj=##class(CT.DHCINM.Set.MgFieldSet).%OpenId(rowid)
	..s fieldCode=obj.FieldCode
	..s fieldDesc=obj.FieldDesc
	..s fieldSort=obj.FieldSort
	..i obj.FieldDisplay="true" s fieldDisplay="是"
	..e  i obj.FieldDisplay="false" s fieldDisplay="否"
	..i obj.FieldSelect="true" s fieldSelect="是"
	..e  i obj.FieldSelect="false" s fieldSelect="否"
	..e  s fieldSelect="是"
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
	..s ret="fieldCode|"_fieldCode_"^fieldDesc|"_fieldDesc_"^fieldSort|"_fieldSort_"^fieldSelect|"_fieldSelect_"^fieldDisplay|"_fieldDisplay_"^fieldLock|"_fieldLock_"^fieldLockPos|"_fieldLockPos_"^rowID|"_rowid_"^fieldWidth|"_fieldWidth_"^fieldType|"_fieldType
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

/// Creator:
/// Createdate:
/// Description:获取列表字段下一个顺序
/// Input:
/// Output:
/// Other:
ClassMethod GetFieldSort(par) As %String
{
	s ret=""
	s sort=$O(^CT.DHCINM.Set.MgFieldSetI("sort"," "_par,""),-1)
	i sort="" s ret=1
	e  s ret=sort+1
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取列表字段配置数据
/// Input:
/// Output:
/// Other:
ClassMethod GetFieldsData(id As %String) As %String
{
	s ret=""
	s obj=##class(CT.DHCINM.Set.MgFieldSet).%OpenId(id)
	s FieldDesc=obj.FieldDesc
	s FieldCode=obj.FieldCode
	s FieldSort=obj.FieldSort
	s FieldDisplay=obj.FieldDisplay
	s FieldSelect="true"
	s:obj.FieldSelect'="" FieldSelect=obj.FieldSelect
	s FieldLock=obj.FieldLock
	s FieldLockPos=obj.FieldLockPos
	s FieldTable=obj.FieldTable
	s FieldWidth=obj.FieldWidth
	s FieldType=obj.FieldType
	s RowID=id
	s ret="FieldDesc|"_FieldDesc_"^FieldCode|"_FieldCode_"^FieldSort|"_FieldSort_"^FieldSelect|"_FieldSelect_"^FieldDisplay|"_FieldDisplay_"^FieldLock|"_FieldLock_"^FieldLockPos|"_FieldLockPos_"^FieldTable|"_FieldTable_"^RowID|"_RowID_"^FieldWidth|"_FieldWidth_"^FieldType|"_FieldType
	q ret
}

/// Creator:
/// Createdate:
/// Description:移动列表字段顺序
/// Input:
/// Output:
/// Other:
ClassMethod GetFieldSetSort(par As %String, id As %String, para As %String) As %String
{
	q:id="" ""
	s ret=0
	s obj=##class(CT.DHCINM.Set.MgFieldSet).%OpenId(id)
	s sort=obj.FieldSort
	;q:sort=1 "已经置顶了！"
	
	i para="up" d
	.i sort="1" s ret=0
	.e  d
	..s ret=sort-1
	..s obj.FieldSort=sort-1
	..s rowid=$O(^CT.DHCINM.Set.MgFieldSetI("sort"," "_par,sort-1,""))
	..s bobj=##class(CT.DHCINM.Set.MgFieldSet).%OpenId(rowid)
	..s bobj.FieldSort=sort
	..d bobj.%Save()
	..d obj.%Save()
	e  i para="down" d
	.s maxSort=$O(^CT.DHCINM.Set.MgFieldSetI("sort"," "_par,""),-1)
	.i sort=maxSort s ret=1
	.e  d
	..s ret=sort+1
	..s obj.FieldSort=sort+1
	..s rowid=$O(^CT.DHCINM.Set.MgFieldSetI("sort"," "_par,sort+1,""))
	..s bobj=##class(CT.DHCINM.Set.MgFieldSet).%OpenId(rowid)
	..s bobj.FieldSort=sort
	..d bobj.%Save()
	..d obj.%Save()
	q ret
}

/// Creator:
/// Createdate:
/// Description:保存界面元素数据
/// Input:
/// Output:
/// Other:
ClassMethod SaveElementData(parr As %String)
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s par=$g(tmp("par"))
	s rw=$g(tmp("RowID"))
	s flag=..IsExistElement(tmp("par"),tmp("RowID"),tmp("elementid"))
	q:flag=2 flag
	i rw'="" s obj=##class(CT.DHCINM.Set.MgMenuElement).%OpenId(par_"||"_rw)
	e  d
	.s obj=##class(CT.DHCINM.Set.MgMenuElement).%New()
	.s obj.Parref=##class(CT.DHCINM.Set.MgMenu).%OpenId(par)
	s obj.ElementCode=$tr($g(tmp("elementid"))," ","")
	s obj.ElementDesc=$tr($g(tmp("elementdesc"))," ","")
	s obj.ElementType=$tr($g(tmp("elementtype"))," ","")
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:查询界面元素列表数据
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMSetComm","FindMenuElement")
Query FindMenuElement(par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindMenuElementExecute(ByRef qHandle As %Binary, par As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rw="" f  s rw=$O(^CT.DHCINM.Set.MgMenuElementD(par,rw)) q:rw=""  d
	.s obj=##class(CT.DHCINM.Set.MgMenuElement).%OpenId(par_"||"_rw)
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

/// Creator:
/// Createdate:
/// Description:获取界面元素数据
/// Input:
/// Output:
/// Other:
ClassMethod GetElementData(par As %String, rw As %String) As %String
{
	s ret=""
	q:((par="")!(rw="")) ""
	s obj=##class(CT.DHCINM.Set.MgMenuElement).%OpenId(par_"||"_rw)
	s elementid=obj.ElementCode
	s elementdesc=obj.ElementDesc
	s elementtype=obj.ElementType
	s ret="elementid|"_elementid_"^elementdesc|"_elementdesc_"^elementtype|"_elementtype_"^RowID|"_rw
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取界面元素代码是否重复
/// Input:
/// Output:
/// Other:
ClassMethod IsExistElement(par As %String, rw As %String, code As %String) As %String
{
	s flag=-1
	s rowid=$O(^CT.DHCINM.Set.MgMenuElementI("Code",par," "_$zcvt($tr(code," ",""),"U"),""))
	i rw="" d
	.i rowid="" s flag=-1
	.e  i rowid'="" s flag=2
	e  i rw'="" d
	.i rowid'="" d
	..i rowid=rw s flag=-1
	..e  i rowid'=rw s flag=2
	
	q flag
}

/// Creator:lulin
/// Description:保存角色菜单模块
/// Date:2019-11-22
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveLimitMoud(parr As %String, str As %String, index As %String = "") As %String
{
	s ^TMP("SaveLimitMoud1")=parr,^TMP("SaveLimitMoud2")=str,^TMP("SaveLimitMoud3")=index
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s rowid=$O(^CT.DHCINM.Set.MgLimitSetI("sort"," "_$tr($g(tmp("RoleID"))," ","")," "_$tr($g(tmp("MoudID"))," ",""),""))
	i rowid'="" s id=rowid
	i id'="" s obj=##class(CT.DHCINM.Set.MgLimitSet).%OpenId(id)
	e  s obj=##class(CT.DHCINM.Set.MgLimitSet).%New()
	s obj.RoleID=$tr($g(tmp("RoleID"))," ","")
	s obj.MoudID=$tr($g(tmp("MoudID"))," ","")
	d obj.%Save()
	i obj.%Id()'="" d
	.d ..SaveLimitMenu(obj.%Id(),str)
	q index
}

/// Creator:lulin
/// Description:保存角色菜单及按钮
/// Date:2019-11-22
/// Table:
/// Input:
/// Output：
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
		.s obj=##class(CT.DHCINM.Set.MgLimitSetSub).%New()
		.s obj.parref=##class(CT.DHCINM.Set.MgLimitSet).%OpenId(par)
		e  s obj=##class(CT.DHCINM.Set.MgLimitSetSub).%OpenId(par_"||"_rowid)
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

/// Creator:
/// Createdate:
/// Description:根据主表id清除权限设置界面元素
/// Input:
/// Output:
/// Other:
ClassMethod ClearLimitSubData(par As %String) As %String
{
	s rowid="" f  s rowid=$O(^CT.DHCINM.Set.MgLimitSetSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(CT.DHCINM.Set.MgLimitSetSub).%OpenId(par_"||"_rowid)
	.d obj.%DeleteId(par_"||"_rowid)
	q 0
}

ClassMethod GetRoleMenuDataInfo(id, menurw, role, firstFlag) As %String
{
	s ret=""
	s menuObj=##class(CT.DHCINM.Set.MgMenu).%OpenId(menurw)
	q:'$IsObject(menuObj) ""
	q:(menuObj.MenuEndDate'="")&&(menuObj.MenuEndDate<+$H) ""
	q:(menuObj.MenuStDate'="")&&(menuObj.MenuStDate>+$H) ""
	q:((firstFlag=1)&&($IsObject(menuObj.MenuParentDR))) ""
	q:(($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N")&&(menuObj.IsAdvanced="Y")) ""
	s title=menuObj.MenuDesc,rw=id_"-"_menurw
	s checkedMenuEles=..GetMenuAndEleChecked(id,menurw,role)
	s fatherId=""
	s:$IsObject(menuObj.MenuParentDR) fatherId=id_"-"_menuObj.MenuParentDR.%Id()
	s isFather=0
	s:$d(^CT.DHCINM.Set.MgMenuI("ParentSort",menurw))'=0 isFather=1 ;为父节点
	s check=$P(checkedMenuEles,"^",1)
	s ckall=$P(checkedMenuEles,"^",2)
	s elements=""
	s elemtrw="" f  s elemtrw=$O(^CT.DHCINM.Set.MgMenuElementD(menurw,elemtrw)) q:elemtrw=""  d
	.s elementobj=##class(CT.DHCINM.Set.MgMenuElement).%OpenId(menurw_"||"_elemtrw)
	.q:'$IsObject(elementobj)
	.s btndesc=elementobj.ElementDesc,btnid=id_"-"_menurw_"-"_elemtrw
	.i elements'="" s elements=elements_",{""lbl"":"""_btndesc_""",""id"":"""_btnid_""""
	.e  s elements="{""lbl"":"""_btndesc_""",""id"":"""_btnid_""""
	.s elements=elements_"}"
	s elements="["_elements_"]"
	s ret=ret_"{""lbl"":"""_title_""",""id"":"""_rw_""",""checkAll"":false,""inCheckAll"":false,""chk"":"_check_",""ckall"":["_ckall_"]"
	_",""chd"":"_elements_",""fatherId"":"""_fatherId_""",""isFather"":"""_isFather_""""
	_"}"
	s subSort="" f  s subSort=$O(^CT.DHCINM.Set.MgMenuI("ParentSort",menurw,subSort)) q:subSort=""  d
	.s subId="" f  s subId=$O(^CT.DHCINM.Set.MgMenuI("ParentSort",menurw,subSort,subId)) q:subId=""  d
	..s tRet=..GetRoleMenuDataInfo(id,subId,role,0)
	..q:tRet=""
	..s ret=ret_","_tRet
	q ret
}

ClassMethod GetRoleMenuDataInfoSub(id, menurw, role) As %String
{
}

/// Creator:lulin
/// Description:根据角色获取已配置的菜单
/// Date:2019-11-22
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.INMSetComm).GetRoleMenuData("")
ClassMethod GetRoleMenuData(role As %String = "") As %String
{
	s ret="",flag=0
	//获取未保存的模块数据
	w "["
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^CT.DHCINM.Set.MgModuleI("Sort",sort,id)) q:id=""  d
	..s obj=##class(CT.DHCINM.Set.MgModule).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ModuleStDate'="")&&(obj.ModuleStDate>+$h))
	..q:((obj.ModuleEndDate'="")&&(obj.ModuleEndDate<+$h))
	..q:(($LG($g(^CT.DHCINM.Set.MgArgParamSetD(1)),25)="N")&&(obj.IsAdvanced="Y"))
	..s title=obj.ModuleDesc,code=obj.ModuleCode
	..s ret=""
	..i flag'=0 s ret=ret_",{"_"""lbl"":"""_title_""",""id"":"""_id_""""
	..e  s ret="{"_"""lbl"":"""_title_""",""id"":"""_id_""""
	..s ret=ret_",""chd"":["
	..s isFirstMenu=1 
	..s menusort="" f  s menusort=$O(^CT.DHCINM.Set.MgMenuI("ModuleSort",id,menusort)) q:menusort=""  d
	...s menurw="" f  s menurw=$O(^CT.DHCINM.Set.MgMenuI("ModuleSort",id,menusort,menurw)) q:menurw=""  d
	....s tRet=..GetRoleMenuDataInfo(id,menurw,role,1)
	....q:tRet=""
	....s:isFirstMenu=0 ret=ret_","
	....s ret=ret_tRet
	....s isFirstMenu=0
	..s ret=ret_"]}"
	..w ret
	..s flag=1
	w "]"
	;i ret'="" s ret="["_ret_"]"
	q ""
}

/// Creator:lulin
/// Description:判断菜单是否选中及选中的按钮
/// Date:2019-11-22
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetMenuAndEleChecked(moduleId, menuId, role) As %String
{
	q:(moduleId="")!(menuId="")!(role="") "false^"
	s checked="false"
	s limitId=$O(^CT.DHCINM.Set.MgLimitSetI("sort"," "_role," "_moduleId,""))
	s limitObj=##class(CT.DHCINM.Set.MgLimitSet).%OpenId(limitId)
	q:'$IsObject(limitObj) checked_"^"
	s rowid=$O(^CT.DHCINM.Set.MgLimitSetSubI("Menu",limitId," "_moduleId_"-"_menuId,"")) 
	s limitSubObj=##class(CT.DHCINM.Set.MgLimitSetSub).%OpenId(limitId_"||"_rowid)
	q:'$IsObject(limitSubObj) checked_"^"
	s checked="true"
	s len=limitSubObj.Elements.Count()
	s elements=""
	for i=1:1:len
	{
		s itm=limitSubObj.Elements.GetAt(i)
		i itm'="" d
		.s row=$p(itm,"-",2)_"||"_$p(itm,"-",3)
		.s btnobj=##class(CT.DHCINM.Set.MgMenuElement).%OpenId(row)
		.q:'$IsObject(btnobj)
		.i elements'="" s elements=elements_","""_itm_""""
		.e  s elements=""""_itm_""""
	}
	q checked_"^"_elements
}

/// 角色人员修改分割线---------
/// Creator:
/// Createdate:
/// Description:查询角色添加人员列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMSetComm","FindRoleNurseList","^","",8)
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
	s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgUserD(rowid)) q:rowid=""  d
	.;s isExistRole=##class(web.INMLoginComm).IsNurInRoleForId(rowid,par,+$H)
	.s obj=##class(CF.DHCINM.DB.MgUser).%OpenId(rowid)
	.q:(obj.EndDate'="")&&(obj.EndDate<=+$h)
	.s NurseName=obj.UserName
	.s NurseID=obj.UserID
	.s shell=##class(web.INMVueComm).ToChineseSpell(NurseName)
	.q:(input'="")&&((NurseName_NurseID_shell)'[$zcvt($tr(input," ",""),"U"))
	.s perId=obj.PerDR
	.;层级
	.s maxdate=0,NurseLevelId="",NurseLevel=""
	.s NurseDutyId="",NurseDuty=""
	.s NurseWard=""
	.i perId'="" d
	..s levelId="" f  s levelId=$O(^CF.DHCINM.HR.MgLevelI("ssid",perId,levelId)) q:levelId=""  d
	...s levelObj=##class(CF.DHCINM.HR.MgLevel).%OpenId(levelId)
	...q:'$IsObject(levelObj)
	...q:(levelObj.LevelStatus'="A")
	...q:((levelObj.LevelDate>+$h)!(maxdate>levelObj.LevelDate)!(levelObj.NurLevel=""))
	...s CodeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(levelObj.NurLevel)
	...q:'$IsObject(CodeObj)
	...s maxdate=levelObj.LevelDate,NurseLevelId=levelObj.NurLevel,NurseLevel=CodeObj.SubDesc
	..;职称
	..s maxdate=0
	..s dutyId="" f  s dutyId=$O(^CF.DHCINM.HR.HireDutyI("ssid",perId,dutyId)) q:dutyId=""  d
	...s dutyObj=##class(CF.DHCINM.HR.HireDuty).%OpenId(dutyId)
	...q:dutyObj.HireStatus'="A"
	...q:(dutyObj.HireStDate="")||(dutyObj.HireStDate>+$H)||((dutyObj.HireEndDate'="")&&(dutyObj.HireEndDate<+$H))
	...q:dutyObj.HireDuty=""
	...q:maxdate>dutyObj.HireStDate
	...s CodeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(dutyObj.HireDuty)
	...q:'$IsObject(CodeObj)
	...s NurseDuty=CodeObj.SubDesc,maxdate=dutyObj.HireStDate,NurseDutyId=dutyObj.HireDuty
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	..i $IsObject(perObj) d
	...s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(perObj.PerDepDR)
	...s:$IsObject(WardObj) NurseWard=WardObj.WardDesc
	.q:(level'="")&&(level'=NurseLevelId)
	.q:(jobduty'="")&&(jobduty'=NurseDutyId)
	.s ret="NurseId|"_NurseID_"^NurseName|"_NurseName_"^NurseWard|"_NurseWard_"^NurseLevel|"_NurseLevel_"^NurseDuty|"_NurseDuty_"^rw|"_rowid
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

/// Creator:
/// Createdate:
/// Description:保存角色关联人员
/// Input:
/// Output:
/// Other:
ClassMethod SaveRoleNurse(parr As %String) As %String
{
	s len=$L(parr,"@")
	s flag=1
	TS
	f i=1:1:len q:flag'=1  d
	.s itm=$P(parr,"@",i)
	.q:itm=""
	.s roleId=$P(itm,"^",1) //角色ID
	.s userId=$P(itm,"^",2) //人员ID
	.s isNewFlag=1
	.s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId,rowid)) q:((rowid="")||(isNewFlag'=1))  d
	..s roleobj=##class(CF.DHCINM.DB.MgUserRole).%OpenId(userId_"||"_rowid)
	..q:roleobj.RoleEndDate'=""
	..s isNewFlag=0
	.q:isNewFlag'=1
	.s nurRoleobj=##class(CF.DHCINM.DB.MgUserRole).%New()
	.s nurRoleobj.Parref=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
	.s nurRoleobj.RoleID=roleId
	.s nurRoleobj.RoleStDate=+$h
	.s flag=flag&&$$$ISOK(nurRoleobj.%Save())
	if flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
	//清除数据权限中不存在的人员数据权限
#;	s nurserw="" f  s nurserw=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_rolestr,nurserw)) q:nurserw=""  d
#;	.;q:(userstr[$tr(nurserw," ",""))
#;	.s flag=0
#;	.s flag=..IsExistFlag(userstr,$tr(nurserw," ",""))
#;	.q:flag=1
#;	.s limitrowid="" f  s limitrowid=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_rolestr,nurserw,limitrowid)) q:limitrowid=""  d
#;	..s limitobj=##class(CF.DHCINM.Set.MgDataLimit).%OpenId(limitrowid)
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

/// Creator:
/// Createdate:
/// Description:删除角色关联人员
/// Input:
/// Output:
/// Other:
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
	.s perid=$tr($P(itm,"^",2),"_","|") //人员ID
	.q:perid=""
	.;判断人员角色表中是否存在此角色的记录，如果存在则填写结束日期
	.s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,perid,rowid)) q:((rowid="")||(flag'=1))  d
	..s roleobj=##class(CF.DHCINM.DB.MgUserRole).%OpenId(perid_"||"_rowid)
	..q:roleobj.RoleEndDate'=""
	..s roleobj.RoleEndDate=+$h
	..s flag=flag&&$$$ISOK(roleobj.%Save())
	.q:flag'=1
	.s rolestr=roleId,tmpNurse(perid)=perid
	//清除数据权限中删除的人员数据权限
	s nurserw="" f  s nurserw=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_rolestr,nurserw)) q:((nurserw="")||(flag'=1))  d
	.q:('$d(tmpNurse($tr(nurserw," ",""))))
	.s limitrowid="" f  s limitrowid=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_rolestr,nurserw,limitrowid)) q:((limitrowid="")||(flag'=1))  d
	..s limitobj=##class(CF.DHCINM.Set.MgDataLimit).%OpenId(limitrowid)
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
/// Others: d ##class(%ResultSet).RunQuery("web.INMSetComm","FindAssRoleNurse",1,"")
Query FindAssRoleNurse(id As %String, parr As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindAssRoleNurseExecute(ByRef qHandle As %Binary, id As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	if id="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s nowDate=+$H
	s userId="" f  s userId=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_id,userId)) q:userId=""  d
	.s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_id,userId,rowid)) q:rowid=""  d
	..s obj=##class(CF.DHCINM.DB.MgUserRole).%OpenId(userId_"||"_rowid)
	..s rw=userId_"__"_rowid
	..q:'$IsObject(obj)
	..q:((obj.RoleStDate'="")&&(obj.RoleStDate>nowDate))
	..q:((obj.RoleEndDate'="")&&(obj.RoleEndDate<=nowDate))
	..q:'$IsObject(obj.Parref)
	..q:(obj.Parref.EndDate'="")&&(obj.Parref.EndDate<=+$h)
	..s NurseName=obj.Parref.UserName
	..s NurseId=obj.Parref.UserID
	..s NameShell=##class(web.INMVueComm).ToChineseSpell(NurseName)
	..q:(parr'="")&&((NurseName_NurseId_NameShell)'[($zcvt(parr,"U")))
	..s NurseWard="",NurseLevel="",NurseDuty=""
	..s perId=obj.Parref.PerDR
	..i perId'="" d
	...s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	...i $IsObject(perObj) d
	....s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(perObj.PerDepDR)
	....s:$IsObject(wardObj) NurseWard=wardObj.WardDesc
	...s NurseLevel=$p(##class(web.INMHRComm).GetNurseLevel(perId,+$h),"^",2)
	...s NurseDuty=$p(##class(web.INMHRComm).GetNurseHireDuty(perId,+$h),"^",2)
	..s ret="NurseId|"_NurseId_"^NurseName|"_NurseName_"^NurseWard|"_NurseWard
	..s ret=ret_"^NurseLevel|"_NurseLevel_"^NurseDuty|"_NurseDuty_"^rw|"_rw
	..s ret=ret_"^PerId|"_perId_"^UserId|"_userId
	..do OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
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

/// Creator:
/// Createdate:
/// Description:获取系统参数数据列表。参数数据设置---关联项目
/// Input:
/// Output:
/// Other: w ##class(web.INMSetComm).GetSysParamData()
ClassMethod GetSysParamData(parr As %String = "", input As %String = "") As %String
{
	s ret=""
	s id="" f  s id=$O(^CT.DHCINM.Set.MgSysParamD(id)) q:id=""  d
	.s obj=##class(CT.DHCINM.Set.MgSysParam).%OpenId(id)
	.q:obj.ParamStatus="N"
	.i ret'="" s ret=ret_","
	.s ret=ret_"{""label"":"""_obj.ParamDesc_""",""value"":"""_id_""""
	.s ret1=""
	.s subid="" f  s subid=$O(^CT.DHCINM.Set.MgSysParamSubD(id,subid)) q:subid=""  d
	..s subobj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(id_"||"_subid)
	..q:((subobj.SubStDate'="")&&(subobj.SubStDate>+$h))||((subobj.SubEndDate'="")&&(subobj.SubEndDate<+$h))
	..i ret1'="" s ret1=ret1_","
	..s ret1=ret1_"{""label"":"""_subobj.SubDesc_""",""value"":"""_id_"__"_subid_"""}"
	.i ret1'="" s ret=ret_",""children"":["_ret1_"]}" 
	i ret'="" s ret="["_ret_"]"
	w ret
	q ""
}

/// Creator:
/// Createdate:
/// Description:系统参数数据上下移动
/// Input:
/// Output:
/// Other:
ClassMethod SysParamSubSort(rowid As %String, type As %String) As %String
{
	q:rowid="" ""
	s ret=0
	s par=$p(rowid,"__",1)
	s rw=$p(rowid,"__",2)
	
	s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(par_"||"_rw)
	s sort=obj.SubSort
	
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.SubSort=sort-1
		.s row=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,sort-1,""))
		.s bobj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.SubSort=sort+1
		.s row=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,sort+1,""))
		.s bobj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取系统参数子项序号
/// Input:
/// Output:
/// Other:
ClassMethod SetParamSubSort(par As %String) As %String
{
	s n=1
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^CT.DHCINM.Set.MgSysParamSubI("Sort",par,sort,rw)) q:rw=""  d
	..s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(par_"||"_rw)
	..i obj.SubSort'="" s n=n+1
	q n
}

/// Creator:
/// Createdate:
/// Description:保存夜班系数及夜班费单价
/// Input:
/// Output:
/// Other:
ClassMethod SaveNightFeeData(parr As %String) As %String
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistNightFee(parr)
	q:flag=1 "记录已经存在"
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(CF.DHCINM.Set.NightFeeFactor).%New()
	e  s obj=##class(CF.DHCINM.Set.NightFeeFactor).%OpenId(id)
	s obj.Ward=$g(tmp("Ward"))
	s obj.Post=$g(tmp("Post"))
	s obj.Factor=$g(tmp("Factor"))
	s obj.Price=$g(tmp("Price"))
	s obj.Type=$g(tmp("Type"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:判断夜班系数及夜班费是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistNightFee(parr As %String) As %String
{
	s flag=0
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s type=$g(tmp("Type"))
	s ward=$g(tmp("Ward"))
	s post=$g(tmp("Post"))
	
	s rw=$o(^CF.DHCINM.Set.NightFeeFactorI("flag"," "_type," "_ward," "_post,""))
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

/// Creator:
/// Createdate:
/// Description:查询夜班费及系数列表数据
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMSetComm","FindNightFactor","")
Query FindNightFactor(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNightFactorExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s postid=$p(parr,"^",1),wardid=$p(parr,"^",2)
	s NurType="" f  s NurType=$o(^CF.DHCINM.Set.NightFeeFactorI("flag",NurType)) q:NurType=""  d
	.s NurWard="" f  s NurWard=$o(^CF.DHCINM.Set.NightFeeFactorI("flag",NurType,NurWard)) q:NurWard=""  d
	..s NurPost="" f  s NurPost=$o(^CF.DHCINM.Set.NightFeeFactorI("flag",NurType,NurWard,NurPost)) q:NurPost=""  d
	...s RowID="" f  s RowID=$o(^CF.DHCINM.Set.NightFeeFactorI("flag",NurType,NurWard,NurPost,RowID)) q:RowID=""  d
	....s obj=##class(CF.DHCINM.Set.NightFeeFactor).%OpenId(RowID)
	....q:'$IsObject(obj)
	....q:((wardid'="")&&(wardid'=obj.Ward))
	....s Ward=""
	....i obj.Ward'="" d
	.....s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.Ward)
	.....q:'$IsObject(WardObj)
	.....s Ward=WardObj.WardDesc
	....q:((postid'="")&&(postid'=obj.Post))
	....s Post=""
	....i obj.Post'="" d
	.....s postobj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(obj.Post)
	.....s Post=postobj.PostDesc
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

/// Creator:
/// Createdate:
/// Description:查询夜班费及系数数据
/// Input:
/// Output:
/// Other:
ClassMethod GetNightFee(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.Set.NightFeeFactor).%OpenId(id)
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

/// Creator:
/// Createdate:
/// Description:删除夜班费及系数数据
/// Input:
/// Output:
/// Other:
ClassMethod DelNightFee(id As %String) As %String
{
	q:id="" 0
	s obj=##class(CF.DHCINM.Set.NightFeeFactor).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Description:复制某年质控表单
/// Date:2020-12-30
/// Table:
/// Input:
/// Output：
/// Return:w ##class(web.INMSetComm).CopyQualItem("2020")
ClassMethod CopyQualItem(year) As %String
{
	ts
	s flag=1
	s type="" f  s type=$o(^CT.DHCINM.DB.MgQualItemI("Type",year,type)) q:type=""  d
	.s rw="" f  s rw=$o(^CT.DHCINM.DB.MgQualItemI("Type",year,type,rw)) q:rw=""  d
	..s oldObj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(rw)
	..q:$o(^CT.DHCINM.DB.MgQualItemI("year",(year+1),oldObj.QualCode,type,""))'="" //不复制已存在表单
	..s newObj=##class(CT.DHCINM.DB.MgQualItem).%New()
	..s newObj.QualYear=oldObj.QualYear+1
	..s p="" f  s p=$O(^oddCOM("CT.DHCINM.DB.MgQualItem","a",p)) q:p=""  d
	...q:p["%"
	...q:(p="ChildSub")||(p="QualYear")
	...q:$O(^oddCOM("CT.DHCINM.DB.MgQualItem","a",p,""))=""
	...s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	..s sc=newObj.%Save()
	..s:flag'=0 flag=$$$ISOK(sc)
	..s parr=oldObj.%Id()
	..s SubPar="" f  s SubPar=$o(^CT.DHCINM.DB.MgQualItemSubI("par",SubPar)) q:SubPar=""  d
	...s rw1="" f  s rw1=$o(^CT.DHCINM.DB.MgQualItemSubI("par",SubPar,parr,rw1)) q:rw1=""  d
	....s oldSubObj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(parr_"||"_rw1)
	....s newSubObj=##class(CT.DHCINM.DB.MgQualItemSub).%New()
	....s newSubObj.Parref=##class(CT.DHCINM.DB.MgQualItem).%OpenId(newObj.%Id())
	....s p="" f  s p=$O(^oddCOM("CT.DHCINM.DB.MgQualItemSub","a",p)) q:p=""  d
	.....q:p["%"
	.....q:(p="ChildSub")||(p="Parref")
	.....q:$O(^oddCOM("CT.DHCINM.DB.MgQualItemSub","a",p,""))=""
	.....s $ZOBJPROPERTY(newSubObj,p)=$ZOBJPROPERTY(oldSubObj,p)
	....s sc=newObj.%Save()
	....s ^TMP("LIWENZHENQualDHCINM",oldSubObj.%Id())=newSubObj.%Id()
	....s:flag'=0 flag=$$$ISOK(sc)
	..//更换父节点
	..s rw2="" f  s rw2=$o(^CT.DHCINM.DB.MgQualItemSubD(newObj.%Id(),rw2)) q:rw2=""  d
	...s NewSubObj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(newObj.%Id()_"||"_rw2)
	...q:NewSubObj.SubPar=""
	...s NewSubObj.SubPar=$g(^TMP("LIWENZHENQualDHCINM",NewSubObj.SubPar))
	...s sc=NewSubObj.%Save()
	...s:flag'=0 flag=$$$ISOK(sc)
	if flag
	{
		TC
		q flag
	}else{
		Tro
		q "-1"
	}
	q flag
}

/// Creator:lulin
/// Createdate:2021-06-04
/// Description:保存审批/代办项目
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).SaveApprovalSet(^TMP("SaveApprovalSet"))
ClassMethod SaveApprovalSet(parr As %ArrayOfDataTypes)
{
	;s ^TMP("SaveApprovalSet")=##class(DHCINM.WebService.INMAppCommon).Encode(parr)
	s id=parr.GetAt("rw")
	i id="" s obj=##class(CT.DHCINM.Set.ApprovalSet).%New()
	e  s obj=##class(CT.DHCINM.Set.ApprovalSet).%OpenId(id)
	s filterKeyLB=$LB("ChildSub","Parref","Show","ApprovalParameter")
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.Set.ApprovalSet","a",p)) q:p=""  d
	.q:p["%"
	.q:$LF(filterKeyLB,p)>0
	.i parr.IsDefined(p) d
	..s $ZOBJPROPERTY(obj,p)=$tr(parr.GetAt(p)," ","")
	d obj.ApprovalParameter.Clear()
	s ApprovalParameter=parr.GetAt("ApprovalParameter")
	f i=1:1:ApprovalParameter.Count()  d
	.d obj.ApprovalParameter.Insert(ApprovalParameter.GetAt(i).GetAt("value"))
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Createdate:2021-06-04
/// Description:获取审批/代办项目
/// Input:rw：CT.DHCINM.Set.ApprovalSet ID 、 outType：输出类型 S：String L：ArrayList
/// Output:
/// Other:w ##class(web.INMSetComm).GetApprovalSet(44,"L")
ClassMethod GetApprovalSet(rw As %String, outType As %String = "S") As %String
{
	s tmp=""
	s obj=##class(CT.DHCINM.Set.ApprovalSet).%OpenId(rw)
	q:'$IsObject(obj) ""
	
	s filterKeyLB=$LB("ChildSub","Parref","Show","ApprovalParameter")
	s ret=""
	i outType="S" d
	.s ret="rw|"_rw
	e  d
	.s row=##class(%ArrayOfDataTypes).%New()
	.d row.SetAt(rw,"rw")
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.Set.ApprovalSet","a",p)) q:p=""  d
	.q:p["%"
	.q:$LF(filterKeyLB,p)>0
	.s value=$ZOBJPROPERTY(obj,p)
	.i outType="S" s ret=ret_"^"_p_"|"_value
	.e  d row.SetAt(value,p)
	i outType="L" d
	.s paramList=##class(%ListOfDataTypes).%New()
	.f i=1:1:obj.ApprovalParameter.Count() d
	..s param=##class(%ArrayOfDataTypes).%New()
	..d param.SetAt(obj.ApprovalParameter.GetAt(i),"value")
	..d paramList.Insert(param)
	.d row.SetAt(paramList,"ApprovalParameter")
	w:outType="L" ##class(DHCINM.WebService.INMAppCommon).Encode(row)
	q ret
}

/// Creator:
/// Createdate:
/// Description:查询审批/代办列表数据
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMSetComm","FindApprovalSet","")
Query FindApprovalSet(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindApprovalSetExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rw="" f  s rw=$O(^CT.DHCINM.Set.ApprovalSetD(rw)) q:rw=""  d
	.s obj=$g(^CT.DHCINM.Set.ApprovalSetD(rw))
	.q:obj=""
	.s name=$lg(obj,2)
	.s nameShell=##class(web.INMVueComm).ToChineseSpell(name)
	.q:((parr'="")&&($zcvt(name_nameShell,"U")'[($zcvt(parr,"U"))))
	.s ret=..GetApprovalSet(rw)
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindApprovalSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApprovalSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApprovalSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApprovalSetExecute ]
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

/// Creator:lulin
/// Createdate:2021-06-07
/// Description:保存审批关键字
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).SaveApprovalSetKey(^TMP("SaveApprovalSet"),1)
ClassMethod SaveApprovalSetKey(parr As %String, par As %String = "") As %String
{
	q:par="" "未获取相应父节点数据,请刷新重试"
	s parObj=##class(CT.DHCINM.Set.ApprovalSet).%OpenId(par)
	q:'$IsObject(parObj) "未获取相应父节点数据,请刷新重试"
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	i id="" s obj=##class(CT.DHCINM.Set.ApprovalSetKey).%New()
	e  s obj=##class(CT.DHCINM.Set.ApprovalSetKey).%OpenId(id)
	s filterKeyLB=$LB("ChildSub","Parref","Show")
	s obj.Parref=parObj
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.Set.ApprovalSetKey","a",p)) q:p=""  d
	.q:p["%"
	.q:$LF(filterKeyLB,p)>0
	.i $D(tmp(p)) d
	..s $ZOBJPROPERTY(obj,p)=$tr(tmp(p)," ","")
	
	s sc=obj.%Save()
	if sc{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2021-06-04
/// Description:获取审批关键字
/// Input:
/// Output:
/// Other:
ClassMethod GetApprovalSetKey(rw As %String) As %String
{
	s tmp=""
	s obj=##class(CT.DHCINM.Set.ApprovalSetKey).%OpenId(rw)
	q:'$IsObject(obj) ""
	s filterKeyLB=$LB("ChildSub","Parref","Show")
	s ret="rw|"_rw_"^parRW|"_obj.Parref.%Id()
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.Set.ApprovalSetKey","a",p)) q:p=""  d
	.q:p["%"
	.q:$LF(filterKeyLB,p)>0
	.s value=$ZOBJPROPERTY(obj,p)
	.s ret=ret_"^"_p_"|"_value
	s KeyRolesDesc=""
	f i=1:1:$L(obj.KeyRoles,",") d
	.s roleId=$P(obj.KeyRoles,",",i)
	.q:roleId=""
	.s roleDesc=$LG($g(^CT.DHCINM.Set.MgRolesD(roleId)),3)
	.q:roleDesc=""
	.i KeyRolesDesc="" d
	..s KeyRolesDesc=roleDesc
	.e  d
	..s KeyRolesDesc=KeyRolesDesc_","_roleDesc
	s ret=ret_"^KeyRolesDesc|"_KeyRolesDesc
	q ret
}

/// Creator:
/// Createdate:
/// Description:查询审批关键字
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMSetComm","FindApprovalSetKey","1")
Query FindApprovalSetKey(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindApprovalSetKeyExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	if parr="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s subRW="" f  s subRW=$O(^CT.DHCINM.Set.ApprovalSetKeyD(parr,subRW)) q:subRW=""  d
	.s ret=..GetApprovalSetKey(parr_"||"_subRW)
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindApprovalSetKeyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApprovalSetKeyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApprovalSetKeyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApprovalSetKeyExecute ]
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

/// Creator:lulin
/// Createdate:2021-06-07
/// Description:保存审批列头显示
/// Input:
/// Output:
/// Other:w ##class(web.INMSetComm).SaveApprovalSetKey("",1)
ClassMethod SaveApprovalSetShow(parr As %String, par As %String = "") As %String
{
	q:par="" "未获取相应父节点数据,请刷新重试"
	s parObj=##class(CT.DHCINM.Set.ApprovalSet).%OpenId(par)
	q:'$IsObject(parObj) "未获取相应父节点数据,请刷新重试"
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("rw"))
	i id="" s obj=##class(CT.DHCINM.Set.ApprovalSetShow).%New()
	e  s obj=##class(CT.DHCINM.Set.ApprovalSetShow).%OpenId(id)
	s filterKeyLB=$LB("ChildSub","Parref","Show","Foreignkey")
	s obj.Parref=parObj
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.Set.ApprovalSetShow","a",p)) q:p=""  d
	.q:p["%"
	.q:$LF(filterKeyLB,p)>0
	.i $D(tmp(p)) d
	..s $ZOBJPROPERTY(obj,p)=$tr(tmp(p)," ","")
	d obj.Foreignkey.Clear()
	s Foreignkey=$g(tmp("Foreignkey"))
	f i=1:1:$l(Foreignkey,"「") d
	.s tdata=$P(Foreignkey,"「",i)
	.q:tdata=""
	.d obj.Foreignkey.Insert(tdata)
	s sc=obj.%Save()
	if sc{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2021-06-04
/// Description:获取审批显示字段
/// Input:
/// Output:
/// Other:
ClassMethod GetApprovalSetShow(rw As %String) As %String
{
	s tmp=""
	s obj=##class(CT.DHCINM.Set.ApprovalSetShow).%OpenId(rw)
	q:'$IsObject(obj) ""
	s filterKeyLB=$LB("ChildSub","Parref","Show","Foreignkey")
	s ret="rw|"_rw_"^rwProp|"_$tr(rw,"||","__")_"^parRW|"_obj.Parref.%Id()
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.Set.ApprovalSetShow","a",p)) q:p=""  d
	.q:p["%"
	.q:$LF(filterKeyLB,p)>0
	.s value=$ZOBJPROPERTY(obj,p)
	.s ret=ret_"^"_p_"|"_value
	s Foreignkey=""
	f i=1:1:obj.Foreignkey.Count() d
	.s tdata=obj.Foreignkey.GetAt(i)
	.q:tdata=""
	.i Foreignkey="" d
	..s Foreignkey=tdata
	.e  d
	..s Foreignkey=Foreignkey_"「"_tdata
	s ret=ret_"^Foreignkey|"_Foreignkey
	q ret
}

/// Creator:
/// Createdate:
/// Description:查询审批显示列头
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMSetComm","FindApprovalSetShow","1")
Query FindApprovalSetShow(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindApprovalSetShowExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s par=$P(parr,"^",1)
	s status=$P(parr,"^",2)
	if ((parr="")||(par="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sort="" f  s sort=$O(^CT.DHCINM.Set.ApprovalSetShowI("sort",par,sort)) q:sort=""  d
	.s subRW="" f  s subRW=$O(^CT.DHCINM.Set.ApprovalSetShowI("sort",par,sort,subRW)) q:subRW=""  d
	..s showObj=$g(^CT.DHCINM.Set.ApprovalSetShowD(par,subRW))
	..q:showObj=""
	..s showStatus=$lg(showObj,9)
	..q:((status'="")&&(showStatus'=status))
	..s ret=..GetApprovalSetShow(par_"||"_subRW)
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindApprovalSetShowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApprovalSetShowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApprovalSetShowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApprovalSetShowExecute ]
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

/// Description:获取质控排班配置
/// Date:2022-05-13
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:质控类型id
/// Output：
/// Other:w ##class(web.INMSetComm).SaveQaulTypeSet()
ClassMethod SaveQaulTypeSet(parr As %String = "") As %String
{
 	q:parr="" 0
 	s qual=$tr($p(parr,"^"),"_","|")
 	s holiday=$tr($p(parr,"^",2),"_","|")
 	s holidayList=$lfs(holiday,",")
 	s week=$p(parr,"^",3)
 	s weekList=$lfs(week,",")
 	s sort=$p(parr,"^",4)
 	s exclude=$p(parr,"^",5)
 	s excludeList=$lfs(exclude,",")
 	
 	s id=$o(^CT.DHCINM.Set.MgNightSetI("Type",qual,""))
 	i id'="" s obj=##class(CT.DHCINM.Set.MgNightSet).%OpenId(id)
 	e  s obj=##class(CT.DHCINM.Set.MgNightSet).%New()
 	q:'$IsObject(obj) 0
 	d obj.QualSetObjectId(qual)
 	d obj.Holiday.Clear()
 	i holiday'="" d
 	.s ptr=0 f  s status=$listnext(holidayList,ptr,value) q:status'=1  d
 	..d obj.Holiday.Insert(value)
 	d obj.Week.Clear()
 	i week'="" d
 	.s ptr=0 f  s status=$listnext(weekList,ptr,value) q:status'=1  d
 	..d obj.Week.Insert(value)
 	s obj.Sort=sort
 	d obj.Exclude.Clear()
 	i exclude'="" d
 	.s ptr=0 f  s status=$listnext(excludeList,ptr,value) q:status'=1  d
 	..d obj.Exclude.Insert(value)
 	s sc=obj.%Save()
 	
 	q $$$ISOK(sc)
}

/// Description:获取质控排班配置
/// Date:2022-05-13
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:质控类型id
/// Output：
/// Other:w ##class(web.INMSetComm).GetQaulTypeSet()
ClassMethod GetQaulTypeSet(qual As %String = "") As %String
{
 	s qual=$tr(qual,"_","|")
 	s index=qual
 	s:index="" index=" "
 	s id=$o(^CT.DHCINM.Set.MgNightSetI("Type",index,""))
 	s holidayStr="",weekStr="",sort="",excludeStr=""
 	i id'="" d
 	.q:'$d(^CT.DHCINM.Set.MgNightSetD(id))
 	.s glo=^CT.DHCINM.Set.MgNightSetD(id)
 	.s holiday=$lg(glo,3)
 	.s index=0,ptr=0 f  s status=$listnext(holiday,ptr,value) q:status'=1  d
 	..s:index'=0 holidayStr=holidayStr_","
 	..s holidayStr=holidayStr_""""_value_""""
 	..s index=index+1
 	.s week=$lg(glo,4)
 	.s index=0,ptr=0 f  s status=$listnext(week,ptr,value) q:status'=1  d
 	..s:index'=0 weekStr=weekStr_","
 	..s weekStr=weekStr_""_value_""
 	..s index=index+1
 	.s sort=$lg(glo,5)
 	.s exclude=$lg(glo,6)
 	.s index=0,ptr=0 f  s status=$listnext(exclude,ptr,value) q:status'=1  d
 	..s:index'=0 excludeStr=excludeStr_","
 	..s excludeStr=excludeStr_""""_value_""""
 	..s index=index+1
 	
 	w "{""Qual"":"""_qual_""",""Holiday"":["_holidayStr
 	w "],""Week"":["_weekStr
 	w "],""Sort"":"""_sort_""",""Exclude"":["_excludeStr
 	w "]}"
 	
 	q ""
}

/// Creator:
/// Createdate:
/// Description:保存PadApp版本
/// Input:
/// Output:
/// Other:
ClassMethod SaveAppInfo(parr As %String) As %String
{
	q:parr="" ""
	s tmp=""
	s obj=##class(CF.DHCINM.Set.MgVersion).%OpenId(1)
	s:'$IsObject(obj) obj=##class(CF.DHCINM.Set.MgVersion).%New()
	s obj.AppVersion=$P(parr,"^",1)
	s obj.AppUrl=$P(parr,"^",2)
	s obj.AppId=$P(parr,"^",3)
	s obj.AppTitle=$P(parr,"^",4)
	s obj.AppNote=$P(parr,"^",5)
	s sc=obj.%Save()
	if $$$ISOK(sc){
		q "上传成功"
	}else{
		q "上传失败,请联系开发"	
	}
}

/// Creator:gzj
/// Date:2022-12-03
/// Description:获取用户的系统风格 blue:炫彩  lite:极简
ClassMethod GetUserStyleCode(loginCode As %String) As %String
{
	s ^TMP("GetUserStyleCode")=loginCode
	q:loginCode="" ""
	s StyleCode=""
	s SSuerId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(loginCode,"U"),""))
	b ;310
	q:SSuerId="" ""
	s StyleCodeID=$o(^websys.PreferencesI("Index","User.SSUser",SSuerId,"STANDARD","websys||10",""))
	;q:StyleCodeID="" ""
	b ;210
	i StyleCodeID'=""
	{
		s StyleCode=$lg(^websys.PreferencesD(StyleCodeID),3)
	}
	else
	{
		b ;110
		//查询护理管理中的系统设置风格
		i loginCode="demo" q $g(^hgStyleCode)
		s RowID=$o(^CF.DHCINM.DB.MgUserI("UserID"," "_loginCode,""))
		q:RowID="" ""
		s StyleCode=$lg(^CF.DHCINM.DB.MgUserD(RowID),10)
	}
	s:StyleCode="" StyleCode="blue" //如果系统没有设置 就设置默认值 炫彩
	q StyleCode
}

/// Creator:gzj
/// Date:2022-12-04
/// Description:单独登录时 设置系统风格
ClassMethod SetUserStyleCode(StyleCode As %String, UserID As %String) As %String
{
	s ^TMP("SetUserStyleCode")=StyleCode_"^"_UserID
	q:(StyleCode=""!UserID="") 0
	i UserID="demo" s ^hgStyleCode=StyleCode q 1
	s RowID=$o(^CF.DHCINM.DB.MgUserI("UserID"," "_UserID,""))
	q:RowID="" 0
	s $list(^CF.DHCINM.DB.MgUserD(RowID),10)=StyleCode
	q 1
}

/// Description: 获取多语言配置
/// Date: 2022-11-24
/// Creator: wangpf
/// Table: CT.DHCINM.Set.MgModule CT.DHCINM.Set.MgMenu CT.DHCINM.Set.MgLang
/// Input: 
/// Output: 
/// Other: w ##class(web.INMSetComm).GetLangData()
ClassMethod GetLangData() As %String
{
	s now=+$h
	
	w "{"
	k tmpCommon,tmpModule,tmpMenu
	s langIndex=0
	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code",$zu(28,"LangSet",7),""))
	i parId="" w "}" q ""
	s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubD(parId,subId)) q:subId=""  d
	.s subGlo=^CT.DHCINM.Set.MgSysParamSubD(parId,subId)
	.s subStDate=$lg(subGlo,8)
	.s subEndDate=$lg(subGlo,9)
	.q:((subStDate="")||(subStDate>now))||((subEndDate'="")&&(subEndDate<now))
	.s subCode=$lg(subGlo,2)
	.q:subCode=""
	.w:langIndex>0 ","
	.w """"_subCode_""":{"
	.;common
	.s tmpCommon(subCode)="{"
	.s langTypeList=$lb("B","L")
	.s langTypeLen=$ll(langTypeList)
	.f index=1:1:langTypeLen d
	..s langType=$lg(langTypeList,index)
	..s langTypeDesc=$case(langType,"B":"button","L":"label",:"other")
	..s tmpCommon(subCode)=tmpCommon(subCode)_$case(index,1:"",:",")_""""_langTypeDesc_""":{"
	..s count=0
	..s langId="" f  s langId=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"",7),$zu(28,"",7),parId_"||"_subId,$zu(28,langType,7),langId)) q:langId=""  d
	...q:'$d(^CT.DHCINM.Set.MgLangD(langId))
	...s langGlo=^CT.DHCINM.Set.MgLangD(langId)
	...s langCode=$lg(langGlo,5)
	...q:langCode=""
	...s langDesc=$lg(langGlo,7)
	...s tmpCommon(subCode)=tmpCommon(subCode)_$case(count,0:"",:",")_""""_langCode_""":"""_langDesc_""""
	...s count=count+1
	..s tmpCommon(subCode)=tmpCommon(subCode)_"}"
	.s langId="" f  s langId=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"",7),$zu(28,"",7),parId_"||"_subId,$zu(28,"",7),langId)) q:langId=""  d
	..q:'$d(^CT.DHCINM.Set.MgLangD(langId))
	..s langGlo=^CT.DHCINM.Set.MgLangD(langId)
	..s langCode=$lg(langGlo,5)
	..q:langCode=""
	..s langDesc=$lg(langGlo,7)
	..s tmpCommon(subCode)=tmpCommon(subCode)_","""_langCode_""":"""_langDesc_""""
	.s tmpCommon(subCode)=tmpCommon(subCode)_"}"
	.;module
	.s tmpModule(subCode)="{"
	.s count=0
	.s id="" f  s id=$o(^CT.DHCINM.Set.MgModuleD(id)) q:id=""  d
	..s glo=^CT.DHCINM.Set.MgModuleD(id)
	..q:glo=""
	..s code=$lg(glo,3)
	..s langDesc=$lg(glo,2)
	..s langId=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"D",7),$zu(28,code,7),parId_"||"_subId,$zu(28,"M",7),""))
	..s:langId'="" langDesc=$lg($g(^CT.DHCINM.Set.MgLangD(langId)),7)
	..s tmpModule(subCode)=tmpModule(subCode)_$case(count,0:"",:",")_""""_code_""":"""_langDesc_""""
	..s count=count+1
	.s tmpModule(subCode)=tmpModule(subCode)_"}"
	.;menu
	.s tmpMenu(subCode)="{"
	.s count=0
	.s menuCode="" f  s menuCode=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"M",7),menuCode)) q:menuCode=""  d
	..q:$d(^CT.DHCINM.Set.MgMenuI("Code",menuCode))
	..s menuDescLangId=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"M",7),menuCode,parId_"||"_subId,$zu(28,"M",7),""))
	..s count2=0
	..s langType="" f  s langType=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"M",7),menuCode,parId_"||"_subId,langType)) q:langType=""  d
	...s langId="" f  s langId=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"M",7),menuCode,parId_"||"_subId,langType,langId)) q:langId=""  d
	....q:'$d(^CT.DHCINM.Set.MgLangD(langId))
	....s langGlo=^CT.DHCINM.Set.MgLangD(langId)
	....s langMenuCode=$lg(langGlo,3)
	....s langCode=$lg(langGlo,5)
	....q:langCode=""
	....s langDesc=$lg(langGlo,7)
	....i count2=0 d
	.....i menuDescLangId="" s tmpMenu(subCode)=tmpMenu(subCode)_$case(count,0:"",:",")_""""_langMenuCode_""":{""MenuDesc"":"""_langMenuCode_""""
	.....e  d
	......s menuDescLangGlo=$g(^CT.DHCINM.Set.MgLangD(menuDescLangId))
	......s menuDescLangMenuCode=$lg(menuDescLangGlo,3)
	......s menuDescLangDesc=$lg(menuDescLangGlo,7)
	......s tmpMenu(subCode)=tmpMenu(subCode)_$case(count,0:"",:",")_""""_menuDescLangMenuCode_""":{""MenuDesc"":"""_menuDescLangDesc_""""
	....s:(menuDescLangId="")||($zu(28,"M",7)'=langType) tmpMenu(subCode)=tmpMenu(subCode)_","""_langCode_""":"""_$replace($zcvt(langDesc,"O","JSON"),"\x2F","/")_""""
	....s count2=count2+1
	..s:count2>0 tmpMenu(subCode)=tmpMenu(subCode)_"}",count=count+1
	.s id="" f  s id=$o(^CT.DHCINM.Set.MgMenuD(id)) q:id=""  d
	..s glo=^CT.DHCINM.Set.MgMenuD(id)
	..q:glo=""
	..s code=$lg(glo,2)
	..s langDesc=$lg(glo,3)
	..s langId=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"M",7),$zu(28,code,7),parId_"||"_subId,$zu(28,"M",7),""))
	..s:langId'="" langDesc=$lg($g(^CT.DHCINM.Set.MgLangD(langId)),7)
	..s tmpMenu(subCode)=tmpMenu(subCode)_$case(count,0:"",:",")_""""_code_""":{""MenuDesc"":"""_langDesc_""""
	..s count=count+1
	..s langType="" f  s langType=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"M",7),$zu(28,code,7),parId_"||"_subId,langType)) q:langType=""  d
	...q:$tr(langType," ")="M"
	...s langId="" f  s langId=$o(^CT.DHCINM.Set.MgLangI("MenuSubType",$zu(28,"M",7),$zu(28,code,7),parId_"||"_subId,langType,langId)) q:langId=""  d
	....q:'$d(^CT.DHCINM.Set.MgLangD(langId))
	....s langGlo=^CT.DHCINM.Set.MgLangD(langId)
	....s langCode=$lg(langGlo,5)
	....q:langCode=""
	....s langDesc=$lg(langGlo,7)
	....s tmpMenu(subCode)=tmpMenu(subCode)_","""_langCode_""":"""_$replace($zcvt(langDesc,"O","JSON"),"\x2F","/")_""""
	..s tmpMenu(subCode)=tmpMenu(subCode)_"}"
	.s tmpMenu(subCode)=tmpMenu(subCode)_"}"
	.w """common"":"_"{}" ;tmpCommon(subCode)_""
	.w ",""module"":"_tmpModule(subCode)_""
	.w ",""menu"":"_tmpMenu(subCode)_""
	.w "}"
	.s langIndex=langIndex+1
	w "}"
	q ""
}

/// Description: 保存多语言
/// Date: 2022-11-25
/// Creator: wangpf
/// Table: CT.DHCINM.Set.MgLang
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSetComm).SaveLang("",0)
ClassMethod SaveLang(parr As %String = "", nurseid As %String = "", coverFlag As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s menuType=$p(parr,"^")
	s menuCode=$p(parr,"^",2)
	s:menuType="" menuCode=""
	s type=$p(parr,"^",3)
	s code=$p(parr,"^",4)
	q:(code="") "代码不能为空"
	q:(type="M")&&(code'="MenuDesc") "参数不正确"
	s lang=$tr($p(parr,"^",5),"_","|")
	s langPar=$p(lang,"||")
	s langSub=$p(lang,"||",2)
	q:(langPar="")||(langSub="")||'$d(^CT.DHCINM.Set.MgSysParamSubD(langPar,langSub)) "语言类型不存在"
	s desc=$p(parr,"^",6)
	q:desc="" "描述不能为空"
	s rw=$p(parr,"^",7)
	
	s oldId=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",$zu(28,menuType,7),$zu(28,menuCode,7),$zu(28,type,7),$zu(28,code,7),lang,""))
	s:(coverFlag=1)&&(rw="") rw=oldId
	q:(oldId'="")&&(oldId'=rw) "存在相同记录"
	
	i rw="" d
	.s obj=##class(CT.DHCINM.Set.MgLang).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(CT.DHCINM.Set.MgLang).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.LangMenuType=menuType
	s obj.LangMenuCode=menuCode
	s obj.LangType=type
	s obj.LangCode=code
	d obj.LangSubTypeSetObjectId(lang)
	s obj.LangDesc=desc
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取多语言
/// Date: 2022-11-25
/// Creator: wangpf
/// Table: CT.DHCINM.Set.MgLang
/// Input: id
/// Output: 多语言
/// Other: w ##class(web.INMSetComm).GetLang(1)
ClassMethod GetLang(id As %String = "") As %String
{
	q:(id="")||('$d(^CT.DHCINM.Set.MgLangD(id))) ""
	
	s glo=^CT.DHCINM.Set.MgLangD(id)
	s menuType=$lg(glo,2)
	s menuTypeDesc=$case(menuType,"D":"模块","M":"菜单",:"")
	s menuCode=$lg(glo,3)
	s menuDesc=menuCode
	i menuType="D" d
	.s moduleId=$o(^CT.DHCINM.Set.MgModuleI("Code",$zu(28,menuCode,7),""))
	.s:moduleId'="" menuDesc=$lg($g(^CT.DHCINM.Set.MgModuleD(moduleId)),2)
	e  i menuType="M" d
	.s menuId=$o(^CT.DHCINM.Set.MgMenuI("Code",$zu(28,menuCode,7),""))
	.s:menuId'="" menuDesc=$lg($g(^CT.DHCINM.Set.MgMenuD(menuId)),3)
	s type=$lg(glo,4)
	s typeDesc=$case(type,"M":"菜单描述","B":"按钮","L":"标签",:"")
	s code=$lg(glo,5)
	s lang=$lg(glo,6)
	s langDesc=""
	s langPar=$p(lang,"||"),langSub=$p(lang,"||",2)
	s:(langPar'="")&&(langSub'="") langDesc=$lg($g(^CT.DHCINM.Set.MgSysParamSubD(langPar,langSub)),3)
	s desc=$lg(glo,7)
	s creator=$lg(glo,8)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(glo,9)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(glo,10)
	s:createTime'="" createTime=$zt(createTime,1)
	
	s ret="LangMenuType|"_menuType_"^LangMenuTypeDesc|"_menuTypeDesc_"^LangMenuCode|"_menuCode_"^LangType|"_type
	s ret=ret_"^LangTypeDesc|"_typeDesc_"^LangCode|"_code_"^LangSubType|"_$tr(lang,"|","_")_"^LangSubTypeDesc|"_langDesc_"^LangDesc|"_desc
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	s ret=ret_"^LangMenuDesc|"_menuDesc
	q ret
}

/// Description: 获取多语言列表
/// Date: 2022-11-25
/// Creator: wangpf
/// Table: CT.DHCINM.Set.MgLang
/// Input: id
/// Output: 多语言列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSetComm","FindLangList","",0)
Query FindLangList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLangListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code",$zu(28,"LangSet",7),""))
	s zhSubId=""
	s:parId'="" subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",$zu(28,"zh",7),parId,""))
	s zhId=""
	s:(parId'="")&&(subId'="") zhId=parId_"||"_subId
	
	s menuType=$p(parr,"^")
	s menuCode=$p(parr,"^",2)
	s langCode=$p(parr,"^",3)
	s langDesc=$p(parr,"^",4)
	s chilldFlag=$p(parr,"^",5)
	s langSubTypeIn=$tr($p(parr,"^",6),"_","|")
	
	s mainId=zhId
	s:langSubTypeIn'="" mainId=langSubTypeIn
	
	i mainId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s now=+$h
	s type="" f  s type=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type)) q:type=""  d
	.q:(menuType'="")&&($zu(28,menuType,7)'=type)
	.s menu="" f  s menu=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type,menu)) q:menu=""  d
	..q:(menuCode'="")&&($zu(28,menuCode,7)'=menu)
	..s langType="" f  s langType=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type,menu,langType)) q:langType=""  d
	...s code="" f  s code=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type,menu,langType,code)) q:code=""  d
	....q:($zu(28,"MenuDesc",7)=code)&&($zu(28,"M",7)'=langType)
	....q:(langCode'="")&&(code'[$zu(28,langCode,7))
	....s subType="" f  s subType=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type,menu,langType,code,subType)) q:subType=""  d
	.....s subTypePar=$p(subType,"||")
	.....s subTypeSub=$p(subType,"||",2)
	.....q:(+subTypePar=0)||(+subTypeSub=0)
	.....q:'$d(^CT.DHCINM.Set.MgSysParamSubD(subTypePar,subTypeSub))
	.....s paramGlo=^CT.DHCINM.Set.MgSysParamSubD(subTypePar,subTypeSub)
	.....s paramStDate=$lg(paramGlo,8)
	.....s paramEndDate=$lg(paramGlo,9)
	.....q:(paramStDate="")||(paramStDate>now)||((paramEndDate'="")&&(paramEndDate<now))
	.....q:((chilldFlag'=1)&&(subType'=mainId))||((chilldFlag=1)&&(subType=mainId))
	.....s id="" f  s id=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type,menu,langType,code,subType,id)) q:id=""  d
	......q:'$d(^CT.DHCINM.Set.MgLangD(id))
	......s glo=^CT.DHCINM.Set.MgLangD(id)
	......s desc=$lg(glo,7)
	......s childType="" f  s childType=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type,menu,langType,code,childType)) q:(childType="")||(chilldFlag=1)  d
	.......q:childType=subType
	.......s childId="" f  s childId=$o(^CT.DHCINM.Set.MgLangI("UniqueKey",type,menu,langType,code,childType,childId)) q:childId=""  d
	........q:'$d(^CT.DHCINM.Set.MgLangD(childId))
	........s childGlo=^CT.DHCINM.Set.MgLangD(childId)
	........s desc=desc_$lg(childGlo,7)
	......q:(langDesc'="")&&(desc'[langDesc)
	......s ret=..GetLang(id)_$case(chilldFlag,1:"",:"^hasChildren|true")
	......d OutList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLangListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLangListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLangListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLangListExecute ]
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

/// Description: 导入多语言数据
/// Date: 2022-12-04
/// Creator: wangpf
/// Table: CT.DHCINM.Set.MgLang
/// Input: id
/// Output: 多语言
/// Other: w ##class(web.INMSetComm).ImportLang(1)
ClassMethod ImportLang(zh As %String = "", en As %String = "", nurseid As %String = "") As %String
{
	q:nurseid="" 0
	
	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code",$zu(28,"LangSet",7),""))
	q:parId="" 0
	s zhSubId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",$zu(28,"zh",7),parId,""))
	s enSubId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code",$zu(28,"en",7),parId,""))
	q:(zhSubId="")||(enSubId="") 0
	s zhId=parId_"||"_zhSubId,enId=parId_"||"_enSubId
	
	s ret=""
	s len=$l(zh,"「")
	for i=1:1:len d
	.s menuStrs=$p(zh,"「",i)
	.s len2=$l(menuStrs,"ˇ")
	.f j=1:1:len2 d
	..s menuStr=$p(menuStrs,"ˇ",j)
	..s menuCode=$p(menuStr,"^")
	..s keyValueStr=$p(menuStr,"^",2)
	..s key=$p(keyValueStr,":")
	..s value=$p(keyValueStr,":",2)
	..s parr="M^"_menuCode_"^L^"_key_"^"_zhId_"^"_value
	..s sc=..SaveLang(parr,nurseid)
	..s:sc'=1 ret=ret_$case(ret,"":"",:",")_menuCode_":"_key
	
	s len=$l(en,"「")
	for i=1:1:len d
	.s menuStrs=$p(en,"「",i)
	.s len2=$l(menuStrs,"ˇ")
	.f j=1:1:len2 d
	..s menuStr=$p(menuStrs,"ˇ",j)
	..s menuCode=$p(menuStr,"^")
	..s keyValueStr=$p(menuStr,"^",2)
	..s key=$p(keyValueStr,":")
	..s value=$p(keyValueStr,":",2)
	..s parr="M^"_menuCode_"^L^"_key_"^"_enId_"^"_value
	..s sc=..SaveLang(parr,nurseid,1)
	..s:sc'=1 ret=ret_$case(ret,"":"",:",")_menuCode_":"_key
	
	q:ret'="" ret
	q 1
}

}
