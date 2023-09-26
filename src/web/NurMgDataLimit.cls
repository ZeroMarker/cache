/// Descriptions:数据权限
Class web.NurMgDataLimit Extends %RegisteredObject
{

/// Creator:guozj
/// Description:查询科室列表树及其所在病区
/// Date:2017-11-18
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetWardTree() As %String
{
	s ret=""
	s code="" f  s code=$O(^DHCNMG.DB.MgWardAreaI("Code",code)) q:code=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardAreaI("Code",code,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(rowid)
	..;q:((obj.AreaStDate>+$H)||(obj.AreaEndDate<+$H))
	..s desc=obj.AreaDesc
	..i ret="" s ret="{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..e  s ret=ret_",{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..s ret2=..GetLocTree(rowid)
	..i ret2'="" s ret=ret_",""cd"":["_ret2_"]"
	..i ret'="" s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
}

/*
	ClassMethod GetWardTree() As %String
{
	s ret=""
	s code="" f  s code=$O(^DHCNMG.DB.MgWardLocI("Code",code)) q:code=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardLocI("Code",code,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(rowid)
	..s desc=obj.LocDesc
	..i ret="" s ret="{""lbl"":"""_desc_""",""id"":"""_rowid_""""
	..e  s ret=ret_",{""lbl"":"""_desc_""",""id"":"""_rowid_""""
	..s ret2=..GetWard(rowid)
	..i ret2'="" s ret=ret_",""chd"":["_ret2_"]"
	..i ret'="" s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
}
*/
ClassMethod GetLocTree(areaid As %String) As %String
{
	s ret=""
	s code="" f  s code=$O(^DHCNMG.DB.MgWardLocI("Code",code)) q:code=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardLocI("Code",code,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(rowid)
	..s arearw=""
	..i obj.LocAreaDR'="" d
	...s arearw=obj.LocAreaDR.%Id()
	..q:((arearw="")||((arearw'="")&&(arearw'=areaid)))
	..s desc=obj.LocDesc
	..i ret="" s ret="{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..e  s ret=ret_",{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..s ret2=..GetWard(rowid)
	..i ret2'="" s ret=ret_",""cd"":["_ret2_"]"
	..i ret'="" s ret=ret_"}"
	;s ret="["_ret_"]"
	q ret
}

ClassMethod GetWard(id As %String) As %String
{
	s ret=""
	s tmpLocWard=""
	i id'="" d
	.s wardid="" f  s wardid=$O(^DHCNMG.DB.MgWardLocUnit("Loc",$tr(id," ",""),wardid)) q:wardid=""  d
	..q:wardid=""
	..s tmp(wardid)=wardid
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..;q:(obj.WardLocDR="")||(obj.WardLocDR.%Id()'=id)
	..q:((id'="")&&('$d(tmpLocWard(rowid)))) 
	..s desc=obj.WardDesc
	..i ret="" s ret="{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..e  s ret=ret_",{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..i ret'="" s ret=ret_"}"
	q ret
}

ClassMethod GetMiniWard() As %String
{
	s ret=""
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..;q:(obj.WardLocDR="")||(obj.WardLocDR.%Id()'=id)
	..s desc=obj.WardDesc
	..i ret="" s ret="{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..e  s ret=ret_",{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..i ret'="" s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
}

/// Creator:guozj
/// Description:保存数据权限 角色对应人员
/// Date:2017-11-18
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod SaveNurseLimit(role As %String, nurse As %String, wards As %String) As %String
{
	s ^TMP("nurselimit")=role_"$"_nurse_"$"_wards //57,62
	s rowid=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurse,""))
	i rowid="" s obj=##class(DHCNMG.DB.MgDataLimit).%New()
	else  s obj=##class(DHCNMG.DB.MgDataLimit).%OpenId(rowid)
	s obj.LimitRole=role
	s obj.LimitNurse=nurse
	d obj.%Save()
	i obj.%Id()
	{
		s len=$L(wards,",")
		d ..ClearLimitSub(obj.%Id())
		f i=1:1:len
		{
			s itm=$p(wards,",",i)
			i itm'="" d
			.s subobj=##class(DHCNMG.DB.MgDataLimitSub).%New()
			.s subobj.Parref=##class(DHCNMG.DB.MgDataLimit).%OpenId(obj.%Id())
			.s subobj.SubWard=itm
			.d subobj.%Save()
		}
	}
	q 1
}

ClassMethod ClearLimitSub(par As %String) As %String
{
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgDataLimitSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(par_"||"_rowid)
	.d obj.%DeleteId(par_"||"_rowid)
	q 0
}

ClassMethod GetNurseWard(role As %String, nurse As %String) As %String
{
	s ret=""
	s rowid=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurse,""))
	q:rowid="" ""
	s subrw="" f  s subrw=$O(^DHCNMG.DB.MgDataLimitSubD(rowid,subrw)) q:subrw=""  d
	.s obj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rowid_"||"_subrw)
	.s ret=ret_"^"_obj.SubWard
	q ret
}

ClassMethod GetNurseWards(role As %String, nurse As %String) As %String
{
	s ret=""
	s rowid=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurse,""))
	q:rowid="" ""
	s subrw="" f  s subrw=$O(^DHCNMG.DB.MgDataLimitSubD(rowid,subrw)) q:subrw=""  d
	.s obj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rowid_"||"_subrw)
	.i ret="" s ret="{"_obj.SubWard
	.e  s ret=ret_",{"_obj.SubWard
	.s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
}

ClassMethod GetNurseLimit(role As %String, nurse As %String) As %String
{
	s ^TMP("getnurselist")=role_"%"_nurse
	s ret=""
	s ret1=..GetNurseWard(role,nurse)
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..s desc=obj.WardDesc
	..q:(ret1'[rowid)
	..
}

/// Creator:
/// Description:
/// Date:2017-11-21
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindNurseWards(role As %String, nurse As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseWardsExecute(ByRef qHandle As %Binary, role As %String, nurse As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rowid=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurse,""))
	q:rowid="" ""
	s subrw="" f  s subrw=$O(^DHCNMG.DB.MgDataLimitSubD(rowid,subrw)) q:subrw=""  d
	.s obj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rowid_"||"_subrw)
	.;i ret="" s ret="{"_obj.SubWard
	.;e  s ret=ret_",{"_obj.SubWard
	.;s ret=ret_"}"
	.s ret="key|"_obj.SubWard
	.do OutputWardsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWardsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseWardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseWardsExecute ]
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

ClassMethod FindNurseWardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseWardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-07-05
/// Description:根据角色获取用户的按钮组
ClassMethod GetElements(role As %String, router As %String) As %String
{
	s ^TMP("router")=router
	s ret=""
	s rw=$O(^DHCNMG.Set.MgMenuI("route"," "_$zcvt($tr(router," ",""),"U"),""))
	i rw'="" d
	.s obj=##class(DHCNMG.Set.MgMenu).%OpenId(rw)
	.s moudid=obj.MenuModuleDR.%Id()
	.s menuid=moudid_"-"_rw
	.s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role," "_moudid,""))
	.i rowid'="" d
	..s menurw=$O(^DHCNMG.Set.MgLimitSetSubI("Menu",rowid," "_menuid,""))
	..i menurw'="" d
	...s menuobj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(rowid_"||"_menurw)
	...s elements=menuobj.Elements
	...s len=menuobj.Elements.Count()
	...f i=1:1:len d
	....s itm=menuobj.Elements.GetAt(i)
	....i itm'="" d
	.....s elementid=$p(itm,"-",2)_"||"_$p(itm,"-",3)
	.....s elementobj=##class(DHCNMG.Set.MgMenuElement).%OpenId(elementid)
	.....q:'$IsObject(elementobj)
	.....i ret="" s ret=""""_elementobj.ElementCode_""":{""desc"":"""_elementobj.ElementDesc_""",""code"":"""_elementobj.ElementCode_""",""ifshow1"":true"
	.....e  s ret=ret_","""_elementobj.ElementCode_""":{""desc"":"""_elementobj.ElementDesc_""",""code"":"""_elementobj.ElementCode_""",""ifshow1"":true"
	.....s ret=ret_"}"
	s ret="{"_ret_"}"
	q ret
}

/// Creator:gzj
/// Date:2018-07-05
/// Decriptions:获取登录人的该菜单下的所有角色的菜单组
ClassMethod GetAllElements(role As %String, router As %String) As %String
{
	s ret=""
	s tmp=""
	s rw=$O(^DHCNMG.Set.MgMenuI("route"," "_$zcvt($tr(router," ",""),"U"),""))
	i rw'="" d
	.s obj=##class(DHCNMG.Set.MgMenu).%OpenId(rw)
	.s moudid=obj.MenuModuleDR.%Id()
	.s menuid=moudid_"-"_rw
	.f j=1:1:$l(role,"^") d
	..s roleid=$p(role,"^",j)
	..i roleid'="" d
	...s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_roleid," "_moudid,""))
	...i rowid'="" d
	....s menurw=$O(^DHCNMG.Set.MgLimitSetSubI("Menu",rowid," "_menuid,""))
	....i menurw'="" d
	....s menuobj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(rowid_"||"_menurw)
	....q:'$IsObject(menuobj)
	....s elements=menuobj.Elements
	....s len=menuobj.Elements.Count()
	....f i=1:1:len d
	.....s itm=menuobj.Elements.GetAt(i)
	.....i itm'="" d
	......s elementid=$p(itm,"-",2)_"||"_$p(itm,"-",3)
	......s tmp(menuid,elementid)=elementid
	s lmenu="" f  s lmenu=$O(tmp(lmenu)) q:lmenu=""  d
	.s lmenuid="" f  s lmenuid=$O(tmp(lmenu,lmenuid)) q:lmenuid=""  d
	..s elementobj=##class(DHCNMG.Set.MgMenuElement).%OpenId(tmp(lmenu,lmenuid))
	..q:'$IsObject(elementobj)
	..i ret="" s ret=""""_elementobj.ElementCode_""":{""desc"":"""_elementobj.ElementDesc_""",""code"":"""_elementobj.ElementCode_""",""ifshow1"":true"
	..e  s ret=ret_","""_elementobj.ElementCode_""":{""desc"":"""_elementobj.ElementDesc_""",""code"":"""_elementobj.ElementCode_""",""ifshow1"":true"
	..s ret=ret_"}"
	s ret="{"_ret_"}"
	q ret
}

/// Creator:
/// Description:根据角色router查询界面元素
/// Date:2017-11-23
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindElements(role As %String, router As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindElementsExecute(ByRef qHandle As %Binary, role As %String, router As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rw=$O(^DHCNMG.Set.MgMenuI("route"," "_$zcvt($tr(router," ",""),"U"),""))
	i rw'="" d
	.s obj=##class(DHCNMG.Set.MgMenu).%OpenId(rw)
	.s moudid=obj.MenuModuleDR.%Id()
	.s menuid=moudid_"-"_rw
	.b ;01
	.s rowid=$O(^DHCNMG.Set.MgLimitSetI("sort"," "_role," "_moudid,""))
	.i rowid'="" d
	..s menurw=$O(^DHCNMG.Set.MgLimitSetSubI("Menu",rowid," "_menuid,""))
	..i menurw'="" d
	...s menuobj=##class(DHCNMG.Set.MgLimitSetSub).%OpenId(rowid_"||"_menurw)
	...s elements=menuobj.Elements
	...
	...do OutputElementData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElementData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindElementsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindElementsExecute ]
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

ClassMethod FindElementsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindElementsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: guozj
/// createDate: 2017-11-23
/// description: 根据角色获取对应病区列表
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDataLimit","FindRoleWardList","0","0","")
Query FindRoleWardList(role As %String, nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleWardListExecute(ByRef qHandle As %Binary, role As %String, nurseid As %String, parr As %String = "") As %Status
{
	s ^TMP("FindRoleWardList")=role_"%"_nurseid_"%"_parr
	//13^2%483%
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp="",ret="",rettmp=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Sort",Sort,id)) q:id=""  d
	..q:(isAll=0)&&('$d(tmpWard(id)))
	..s rettmp=##class(web.NurMgDBComm).GetWard(id)
	..s tmp(Sort)=rettmp
	s Sort="" f  s Sort=$o(tmp(Sort)) q:Sort=""  d
	.s ret=tmp(Sort)
	.d OutWard
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoleWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleWardListExecute ]
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

/// creator: wangpf
/// createDate: 2019-10-20
/// description: 根据角色获取对应科室列表
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgDataLimit","FindRoleWardLocList","0","0","")
Query FindRoleWardLocList(role As %String, nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleWardLocListExecute(ByRef qHandle As %Binary, role As %String, nurseid As %String, parr As %String = "") As %Status
{
	s ^TMP("FindRoleWardLocList")=role_"%"_nurseid_"%"_parr
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp="",ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	i isAll d
	.s wardlocDR="" f  s wardlocDR=$o(^DHCNMG.DB.MgWardLocD(wardlocDR)) q:wardlocDR=""  d
	..s wardlocObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(wardlocDR)
	..q:('$IsObject(wardlocObj))||(wardlocObj.LocStDate="")||(wardlocObj.LocStDate>+$h)||((wardlocObj.LocEndDate'="")&&(wardlocObj.LocEndDate<+$h))
	..s tmp(wardlocDR)="rw|"_wardlocDR_"^LocDesc|"_wardlocObj.LocDesc
	e  d
	.s wardDR="" f  s wardDR=$O(^DHCNMG.DB.MgWardD(wardDR)) q:wardDR=""  d
	..q:(isAll=0)&&('$d(tmpWard(wardDR)))
	..s wardlocDR="" f  s wardlocDR=$o(^DHCNMG.DB.MgWardLocUnitI("Ward",wardDR,wardlocDR)) q:wardlocDR=""  d
	...s wardlocObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(wardlocDR)
	...q:('$IsObject(wardlocObj))||(wardlocObj.LocStDate="")||(wardlocObj.LocStDate>+$h)||((wardlocObj.LocEndDate'="")&&(wardlocObj.LocEndDate<+$h))
	...s tmp(wardlocDR)="rw|"_wardlocDR_"^LocDesc|"_wardlocObj.LocDesc
	s Sort="" f  s Sort=$o(tmp(Sort)) q:Sort=""  d
	.s ret=tmp(Sort)
	.d OutWard
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleWardLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleWardLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoleWardLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleWardLocListExecute ]
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

/// creator: wangpf
/// createDate: 2019-10-21
/// description: 获取用户所辖病区
/// table: 
/// input:MgPersonsId 护理部是否拥有所有病区
/// output:admin返回排序病区 其他返回未排序病区
/// other: d ##class(web.NurMgDataLimit).GetRoleWard(0,1)
ClassMethod GetRoleWard(nurseid As %String = "", flag As %Boolean = 1, ByRef ret As %String)
{
	q:nurseid=""
	i nurseid=0
	{
		s sort="",counter=1 f  s sort=$o(^DHCNMG.DB.MgWardI("Sort",sort)) q:sort=""  d
		.s wardId="" f  s wardId=$o(^DHCNMG.DB.MgWardI("Sort",sort,wardId)) q:wardId=""  d
		..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
		..q:'$IsObject(wardObj)||(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		..s ret(counter)=wardId,counter=counter+1
	}
	else
	{
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
		q:'$IsObject(perObj)
		s codeSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perObj.PerStatus)
		q:('$IsObject(codeSubObj))||(codeSubObj.SubDesc'["在职")
		s breakFlag=0
		s roleId="" f  s roleId=$o(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleId)) q:(roleId="")||(breakFlag=1)  d
		.s nurRoleId="" f  s nurRoleId=$o(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleId,nurRoleId)) q:(nurRoleId="")||(breakFlag=1)  d
		..s nurRoleObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRoleId)
		..q:'$IsObject(nurRoleObj)||(nurRoleObj.RoleStDate="")||(nurRoleObj.RoleStDate>+$h)||((nurRoleObj.RoleEndDate'="")&&(nurRoleObj.nurRoleObj<+$h))
		..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId($tr(roleId," ",""))
		..q:'$IsObject(roleObj)||(roleObj.RoleStatus'="Y")
		..s roleCode=$zcvt(roleObj.RoleCode,"U")
		..i ((flag=1)&&((roleCode="HLB")||(roleCode="HLBZR")))||(roleCode="ADMIN")||(roleCode="MANAGER") d
		...s wardId="" f  s wardId=$o(^DHCNMG.DB.MgWardD(wardId)) q:wardId=""  d
		....s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
		....q:'$IsObject(wardObj)||(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		....s ret(wardId)=wardId
		...s breakFlag=1
		..e  d
		...s limitId="" f  s limitId=$o(^DHCNMG.DB.MgDataLimitI("Role",roleId," "_nurseid,limitId)) q:limitId=""  d
		....s limitObj=##class(DHCNMG.DB.MgDataLimit).%OpenId(limitId)
		....q:'$IsObject(limitObj)
		....s limitSubId="" f  s limitSubObj=limitObj.ChildSub.GetNext(.limitSubId) q:(limitSubId="")||('$IsObject(limitSubObj))  d
		.....s wardId=limitSubObj.SubWard
		.....s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
		.....q:'$IsObject(wardObj)||(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		.....s ret(wardId)=wardId
		.....d limitObj.ChildSub.%UnSwizzleAt(limitSubId)
	}
}

/// creator: wangpf
/// createDate: 2019-10-21
/// description: 获取用户所辖科室
/// table: 
/// input:MgPersonsId 护理部是否拥有所有科室
/// output:科室id数组
/// other: d ##class(web.NurMgDataLimit).GetRoleWardLoc(0,1)
ClassMethod GetRoleWardLoc(nurseid As %String = "", flag As %Boolean = 1, ByRef ret As %String)
{
	q:nurseid=""
	i nurseid=0
	{
		s locId="" f  s locId=$o(^DHCNMG.DB.MgWardLocD(locId)) q:locId=""  d
		.s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(locId)
		.q:'$IsObject(locObj)||(locObj.LocStDate="")||(locObj.LocStDate>+$h)||((locObj.LocEndDate'="")&&(locObj.LocEndDate<+$h))
		.s ret(locId)=locObj.LocDesc
	}
	else
	{
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
		q:'$IsObject(perObj)
		s codeSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perObj.PerStatus)
		q:('$IsObject(codeSubObj))||(codeSubObj.SubDesc'["在职")
		s breakFlag=0
		s roleId="" f  s roleId=$o(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleId)) q:(roleId="")||(breakFlag=1)  d
		.s nurRoleId="" f  s nurRoleId=$o(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleId,nurRoleId)) q:(nurRoleId="")||(breakFlag=1)  d
		..s nurRoleObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRoleId)
		..q:'$IsObject(nurRoleObj)||(nurRoleObj.RoleStDate="")||(nurRoleObj.RoleStDate>+$h)||((nurRoleObj.RoleEndDate'="")&&(nurRoleObj.nurRoleObj<+$h))
		..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId($tr(roleId," ",""))
		..q:'$IsObject(roleObj)||(roleObj.RoleStatus'="Y")
		..s roleCode=$zcvt(roleObj.RoleCode,"U")
		..i ((flag=1)&&((roleCode="HLB")||(roleCode="HLBZR")))||(roleCode="ADMIN")||(roleCode="MANAGER") d
		...s locId="" f  s locId=$o(^DHCNMG.DB.MgWardLocD(locId)) q:locId=""  d
		....s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(locId)
		....q:'$IsObject(locObj)||(locObj.LocStDate="")||(locObj.LocStDate>+$h)||((locObj.LocEndDate'="")&&(locObj.LocEndDate<+$h))
		....s ret(locId)=locId
		...s breakFlag=1
		..e  d
		...s limitId="" f  s limitId=$o(^DHCNMG.DB.MgDataLimitI("Role",roleId," "_nurseid,limitId)) q:limitId=""  d
		....s limitObj=##class(DHCNMG.DB.MgDataLimit).%OpenId(limitId)
		....q:'$IsObject(limitObj)
		....s limitSubId="" f  s limitSubObj=limitObj.ChildSub.GetNext(.limitSubId) q:(limitSubId="")||('$IsObject(limitSubObj))  d
		.....s wardId=limitSubObj.SubWard
		.....s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
		.....q:'$IsObject(wardObj)||(wardObj.WardStDate="")||(wardObj.WardStDate>+$h)||((wardObj.WardEndDate'="")&&(wardObj.WardEndDate<+$h))
		.....s locId="" f  s locId=$o(^DHCNMG.DB.MgWardLocUnitI("Ward",wardId,locId)) q:locId=""  d
		......s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(locId)
		......q:'$IsObject(locObj)||(locObj.LocStDate="")||(locObj.LocStDate>+$h)||((locObj.LocEndDate'="")&&(locObj.LocEndDate<+$h))
		......s ret(locId)=locObj.LocDesc
		.....d limitObj.ChildSub.%UnSwizzleAt(limitSubId)
	}
}

}
