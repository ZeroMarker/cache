/// Creator:
/// Descriptions:数据限制业务类
/// Date
Class web.INMDataLimit Extends %RegisteredObject
{

/// Creator:
/// Createdate:
/// Description:获取病区树形列表
/// Input:
/// Output:
/// Other:
ClassMethod GetMiniWard() As %String
{
	s ret=""
	s spell="" f  s spell=$O(^CF.DHCINM.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(rowid)
	..;q:(obj.WardLocDR="")||(obj.WardLocDR.%Id()'=id)
	..s desc=obj.WardDesc
	..i ret="" s ret="{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..e  s ret=ret_",{""lb"":"""_desc_""",""id"":"""_rowid_""""
	..i ret'="" s ret=ret_"}"
	s ret="["_ret_"]"
	w ret
	q ""
}

/// Creator:gzj
/// Description:保存数据权限 角色对应人员
/// Date:2017-11-18
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod SaveNurseLimit(role As %String, nurse As %String, wards As %String) As %String
{
	s rowid=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_role," "_nurse,""))
	i rowid="" s obj=##class(CF.DHCINM.Set.MgDataLimit).%New()
	else  s obj=##class(CF.DHCINM.Set.MgDataLimit).%OpenId(rowid)
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
			.s subobj=##class(CF.DHCINM.Set.MgDataLimitSub).%New()
			.s subobj.Parref=##class(CF.DHCINM.Set.MgDataLimit).%OpenId(obj.%Id())
			.s subobj.SubWard=itm
			.d subobj.%Save()
		}
	}
	q 1
}

ClassMethod ClearLimitSub(par As %String) As %String
{
	s rowid="" f  s rowid=$O(^CF.DHCINM.Set.MgDataLimitSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(CF.DHCINM.Set.MgDataLimitSub).%OpenId(par_"||"_rowid)
	.d obj.%DeleteId(par_"||"_rowid)
	q 0
}

ClassMethod GetNurseWard(role As %String, nurse As %String) As %String
{
	s ret=""
	s rowid=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_role," "_nurse,""))
	q:rowid="" ""
	s subrw="" f  s subrw=$O(^CF.DHCINM.Set.MgDataLimitSubD(rowid,subrw)) q:subrw=""  d
	.s obj=##class(CF.DHCINM.Set.MgDataLimitSub).%OpenId(rowid_"||"_subrw)
	.s ret=ret_"^"_obj.SubWard
	q ret
}

ClassMethod GetNurseWards(role As %String, nurse As %String) As %String
{
	s ret=""
	s rowid=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_role," "_nurse,""))
	q:rowid="" ""
	s subrw="" f  s subrw=$O(^CF.DHCINM.Set.MgDataLimitSubD(rowid,subrw)) q:subrw=""  d
	.s obj=##class(CF.DHCINM.Set.MgDataLimitSub).%OpenId(rowid_"||"_subrw)
	.i ret="" s ret="{"_obj.SubWard
	.e  s ret=ret_",{"_obj.SubWard
	.s ret=ret_"}"
	s ret="["_ret_"]"
	q ret
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
	s rowid=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_role," "_nurse,""))
	q:rowid="" ""
	s subrw="" f  s subrw=$O(^CF.DHCINM.Set.MgDataLimitSubD(rowid,subrw)) q:subrw=""  d
	.s obj=##class(CF.DHCINM.Set.MgDataLimitSub).%OpenId(rowid_"||"_subrw)
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

/// creator: gzj
/// createDate: 2017-11-23
/// description: 根据角色获取对应病区列表
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMDataLimit","FindRoleWardList","0","")
Query FindRoleWardList(nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleWardListExecute(ByRef qHandle As %Binary, nurseid As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp="",ret="",rettmp=""
	s tmpWard=""
	s isAll=0,nowDate=+$H
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s Sort="" f  s Sort=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort,id)) q:id=""  d
	..q:(isAll=0)&&('$d(tmpWard(id)))
	..s objLB=$G(^CF.DHCINM.DB.MgWardD(id))
	..q:objLB=""
	..s WardStDate=$LG(objLB,11)
	..s WardEndDate=$LG(objLB,12)
	..q:((WardStDate'="")&&(WardStDate>nowDate))
	..q:((WardEndDate'="")&&(WardEndDate<nowDate))
	..s rettmp=##class(web.INMDBComm).GetWard(id)
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

Query FindRoleNurseList(nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleNurseListExecute(ByRef qHandle As %Binary, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s ward="" f  s ward=$o(^CF.DHCINM.HR.PersonsI("DepID",ward)) q:ward=""  d
	.s wardId=$tr(ward," ","")
	.q:((isAll'=1)&&(wardId=""))
	.q:((isAll'=1)&&('$d(tmpWard(wardId))))
	.s per="" f  s per=$o(^CF.DHCINM.HR.PersonsI("DepID",ward,per)) q:per=""  d
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..s perGlo=^CF.DHCINM.HR.PersonsD(per)
	..s PerStatus=$lg(perGlo,42)
	..s PerStatusDesc=##class(web.INMPersonComm).GetCommCode(PerStatus)
	..q:((PerStatusDesc'["在职")&&(PerStatusDesc'["转岗"))
	..s perWard=##class(web.INMHRComm).GetCurrentWard(per,+$h)
	..q:perWard=""
	..s:perWard'="" perWard=$lg($g(^CF.DHCINM.DB.MgWardD(perWard)),4)
	..s perName=$lg(perGlo,2)
	..s perID=$lg(perGlo,3)
	..s ret="Per|"_per_"^PerName|"_perName_"^PerID|"_perID_"^PerWard|"_perWard
	..d OutWard
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
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

Query FindRoleLocList(nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleLocListExecute(ByRef qHandle As %Binary, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmpLoc
	s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
	.q:(isAll'=1)&&('$d(tmpWard(ward)))
	.s loc=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",ward,""))
	.q:(loc="")||('$d(^CF.DHCINM.DB.MgWardLocD(loc)))
	.q:$d(tmpLoc(loc))
	.s locGlo=^CF.DHCINM.DB.MgWardLocD(loc)
	.s locDesc=$lg(locGlo,3)
	.s tmpLoc(loc)="LocDesc|"_locDesc_"^rw|"_loc
	s id="" f  s id=$o(tmpLoc(id)) q:id=""  d
	.s ret=tmpLoc(id)
	.d OutLoc
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLoc
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoleLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleLocListExecute ]
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

Query FindRoleAreaList(nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleAreaListExecute(ByRef qHandle As %Binary, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmpLoc
	s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
	.q:(isAll'=1)&&('$d(tmpWard(ward)))
	.s loc=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",ward,""))
	.q:(loc="")||('$d(^CF.DHCINM.DB.MgWardLocD(loc)))
	.s locGlo=^CF.DHCINM.DB.MgWardLocD(loc)
	.s locArea=$lg(locGlo,8)
	.q:(locArea="")||('$d(^CF.DHCINM.DB.MgWardAreaD(locArea)))
	.q:$d(tmpArea(locArea))
	.s areaGlo=^CF.DHCINM.DB.MgWardAreaD(locArea)
	.s areaDesc=$lg(areaGlo,3)
	.s stDate=$lg(areaGlo,5)
	.s endDate=$lg(areaGlo,6)
	.q:((stDate'="")&&(stDate>+$H))
	.q:((endDate'="")&&(endDate<+$H))
	.s tmpArea(locArea)="AreaDesc|"_areaDesc_"^rw|"_locArea
	
	s id="" f  s id=$o(tmpArea(id)) q:id=""  d
	.s ret=tmpArea(id)
	.d OutLoc
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLoc
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleAreaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleAreaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoleAreaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleAreaListExecute ]
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

/// 获取所辖病区关联科室的关联病区所有人
Query FindLocNurseList(nurseid As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocNurseListExecute(ByRef qHandle As %Binary, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s wardId="" f  s wardId=$O(tmpWard(wardId)) q:wardId=""  d
	.s locId="" f  s locId=$O(^CF.DHCINM.DB.MgWardLocUnitI("Ward",wardId,locId)) q:locId=""  d
	..s tWardId="" f  s tWardId=$O(^CF.DHCINM.DB.MgWardLocUnitI("Ward",locId,tWardId)) q:tWardId=""  d
	...s tmpWard(tWardId)=tWardId
	s ward="" f  s ward=$o(^CF.DHCINM.HR.PersonsI("DepID",ward)) q:ward=""  d
	.s wardId=$tr(ward," ","")
	.q:(isAll'=1)&&('$d(tmpWard))
	.s per="" f  s per=$o(^CF.DHCINM.HR.PersonsI("DepID",ward,per)) q:per=""  d
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..s perGlo=^CF.DHCINM.HR.PersonsD(per)
	..s perName=$lg(perGlo,2)
	..s perID=$lg(perGlo,3)
	..s ret="Per|"_per_"^PerName|"_perName_"^PerID|"_perID
	..d OutWard
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocNurseListExecute ]
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

/// 获取某角色及以上人员信息
/// d ##class(%ResultSet).RunQuery("web.INMDataLimit","FindOverRoleLevelList","nurhead")
Query FindOverRoleLevelList(roleCode As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindOverRoleLevelListExecute(ByRef qHandle As %Binary, roleCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s roleId=$O(^CT.DHCINM.Set.MgRolesI("code"," Y"," "_$zcvt(roleCode,"U"),""))
	if roleId="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s roleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId(roleId)
	if '$IsObject(roleObj) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s RoleLevel=roleObj.RoleLevel
	s tmpPer=""
	s roleId="" f  s roleId=$O(^CT.DHCINM.Set.MgRolesD(roleId)) q:roleId=""  d
	.s roleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId(roleId)
	.q:'$IsObject(roleObj)
	.q:(roleObj.RoleLevel>RoleLevel)
	.s userId="" f  s userId=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId)) q:userId=""  d
	..s isExist=1
	..s userLB=$G(^CF.DHCINM.DB.MgUserD(userId))
	..q:userLB=""
	..s perID=$LG(userLB,5)
	..q:perID=""
	..s userRoleId="" f  s userRoleId=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId,userRoleId)) q:userRoleId=""  d
	...s dataLB=$G(^CF.DHCINM.DB.MgUserRoleD(userId,userRoleId))
	...q:dataLB=""
	...s stDate=$LG(dataLB,3)
	...s endDate=$LG(dataLB,4)
	...q:((stDate'="")&&(stDate>+$H))
	...q:((endDate'="")&&(endDate<+$H))
	...s isExist=0
	..q:isExist=1
	..s tmpPer(perID)=""
	s per="" f  s per=$o(tmpPer(per)) q:per=""  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.s perGlo=^CF.DHCINM.HR.PersonsD(per)
	.s perName=$lg(perGlo,2)
	.s perID=$lg(perGlo,3)
	.s ret="Per|"_per_"^PerName|"_perName_"^PerID|"_perID
	.d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOverRoleLevelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOverRoleLevelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOverRoleLevelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOverRoleLevelListExecute ]
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
/// description: 获取用户所辖科室
/// table: 
/// input:MgPersonsId 护理部是否拥有所有科室
/// output:科室id数组
/// other: d ##class(web.INMDataLimit).GetRoleWardLoc(0,1)
ClassMethod GetRoleWardLoc(nurseid As %String = "", flag As %Boolean = 1, ByRef ret As %String)
{
	q:nurseid=""
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	i isAll=1
	{
		s locId="" f  s locId=$o(^CF.DHCINM.DB.MgWardLocD(locId)) q:locId=""  d
		.s locObj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(locId)
		.q:'$IsObject(locObj)||(locObj.LocStDate="")||(locObj.LocStDate>+$h)||((locObj.LocEndDate'="")&&(locObj.LocEndDate<+$h))
		.s ret(locId)=locObj.LocDesc
	}
	else
	{
		s wardId="" f  s wardId=$O(tmpWard(wardId)) q:wardId=""  d
		.s locId="" f  s locId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",wardId,locId)) q:locId=""  d
		..s locObj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(locId)
		..q:'$IsObject(locObj)||(locObj.LocStDate="")||(locObj.LocStDate>+$h)||((locObj.LocEndDate'="")&&(locObj.LocEndDate<+$h))
		..s ret(locId)=locObj.LocDesc
	}
}

/// creator: lulin
/// createDate: 2021-04-08
/// description: 获取用户所辖片区
/// table: 
/// input:
/// output:
/// other: d ##class(web.INMDataLimit).GetRoleWardArea(0,.tmpArea)
ClassMethod GetRoleWardArea(nurseid As %String = "", ByRef ret As %String)
{
	q:nurseid="" 0
	q:(nurseid=0) 1
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	q:isAll=1 1
	s wardId="" f  s wardId=$O(^CF.DHCINM.DB.MgWardD(wardId)) q:wardId=""  d
	.q:((isAll'=1)&&('$d(tmpWard(wardId))))
	.s wardLB=$g(^CF.DHCINM.DB.MgWardD(wardId))
	.q:wardLB=""
	.s areaId=$lg(wardLB,9)
	.q:areaId=""
	.s ret(areaId)=areaId
	q isAll
}

}
