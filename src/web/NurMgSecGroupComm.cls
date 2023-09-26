/// 
/// 
/// 安全组公共类
Class web.NurMgSecGroupComm Extends %RegisteredObject
{

/// Creator:guozj
/// Description:获取系统安全组
/// Date:2018-08-19
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgSecGroupComm","FindSecGroup")
Query FindSecGroup(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSecGroupExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindSecGroup")=parr
	s RowID=0 f  s RowID=$o(^SSU("SSGRP",RowID)) q:RowID=""  d
	.s GroupDesc=$p($g(^SSU("SSGRP",RowID)),"^",1)
	.s ret="GroupDesc|"_GroupDesc_"^GroupID|"_RowID
	.d OutputSecGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSecGroup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSecGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSecGroupExecute ]
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

ClassMethod FindSecGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSecGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 
/// 获取系统安全组JSON
ClassMethod GetSecGroup() As %String
{
	w "["
	s n=0
	s RowID=0 f  s RowID=$o(^SSU("SSGRP",RowID)) q:RowID=""  d
	.s GroupDesc=$p($g(^SSU("SSGRP",RowID)),"^",1)
	.s n=n+1
	.i n=1 w "{""GroupDesc"":"""_GroupDesc_""",""GroupID"":"""_RowID_"""}"
	.e  w ",{""GroupDesc"":"""_GroupDesc_""",""GroupID"":"""_RowID_"""}"
	w "]"
	q ""
}

/// 
/// 
/// 获取护管角色
ClassMethod GetRole() As %String
{
	w "["
	s n=0
	s sort="" f  s sort=$o(^DHCNMG.Set.MgRolesI("Sort",sort)) q:sort=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.Set.MgRolesI("Sort",sort,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.Set.MgRoles).%OpenId(RowID)
	..s RoleDesc=obj.RoleDesc
	..s RoleCode=obj.RoleCode
	..s n=n+1
	..i n=1 w "{""RoleDesc"":"""_RoleDesc_""",""RoleCode"":"""_RoleCode_""",""RoleID"":"""_RowID_"""}"
	..e  w ",{""RoleDesc"":"""_RoleDesc_""",""RoleCode"":"""_RoleCode_""",""RoleID"":"""_RowID_"""}"
	w "]"
	q ""
}

ClassMethod SaveSecForRole(parr As %String) As %String
{
	s ^tmp("SaveSecForRole")=parr
	q:parr="" ""
	s SecGroup=$p(parr,"^",1)
	s SecRole=$p(parr,"^",2)
	s flag=0
	s flag=..IsExist(SecGroup,SecRole)
	q:flag>0 "此记录已经存在"
	s obj=##class(DHCNMG.Set.MgNurSecLinkRole).%New()
	s obj.SecGroup=SecGroup
	s obj.SecRole=SecRole
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

/// 
/// 
/// 判断记录是否存在
ClassMethod IsExist(secId As %String, roleId As %String) As %String
{
	s RowID=""
	s RowID=$O(^DHCNMG.Set.MgNurSecLinkRoleI("sec"," "_$tr(secId," ","")," "_$tr(roleId," ",""),""))
	q RowID
}

/// 
/// 
/// 删除安全组记录
ClassMethod DelSecRec(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgNurSecLinkRole).%OpenId(id)
	q:'$IsObject(obj) ""
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询数据
/// Date:2018-08-20
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgSecGroupComm","FindSecGroupList")
Query FindSecGroupList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSecGroupListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindSecGroupList")=parr
	s ret=""
	s SecGroup="" f  s SecGroup=$o(^DHCNMG.Set.MgNurSecLinkRoleI("sec",SecGroup)) q:SecGroup=""  d
	.s SecRole="" f  s SecRole=$o(^DHCNMG.Set.MgNurSecLinkRoleI("sec",SecGroup,SecRole)) q:SecRole=""  d
	..s RowID="" f  s RowID=$o(^DHCNMG.Set.MgNurSecLinkRoleI("sec",SecGroup,SecRole,RowID)) q:RowID=""  d
	...s obj=##class(DHCNMG.Set.MgNurSecLinkRole).%OpenId(RowID)
	...s HisGroup=""
	...i obj.SecGroup'="" d
	....s SGroupObj=##class(User.SSGroup).%OpenId(obj.SecGroup)
	....q:'$IsObject(SGroupObj)
	....s HisGroup=SGroupObj.SSGRPDesc
	...s RoleDesc=""
	...i obj.SecRole'="" d
	....s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(obj.SecRole)
	....q:'$IsObject(RoleObj)
	....s RoleDesc=RoleObj.RoleDesc
	...s ret="HisGroup|"_HisGroup_"^RoleDesc|"_RoleDesc_"^RowID|"_RowID
	...d OutputSecGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSecGroup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSecGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSecGroupListExecute ]
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

ClassMethod FindSecGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSecGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 
/// 
/// 根据登录的安全组获取对应的角色串
ClassMethod GetSecRoleCodes() As %String
{
}

ClassMethod GetNurseRoleCodes(userCode As %String) As %String
{
	s ret=""
	q:((userCode="demo")||(userCode="DEMO")) "admin|1|0!0^"
	s userId=$o(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr(userCode," ",""),"U"),""))
	q:userId="" ""
	s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(userId)
	q:'$IsObject(PerObj) ""
	s nurseDep=PerObj.PerDepDR
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("ssid",userId,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
	.;q:(obj.RoleEndDate'="")
	.q:((+$h<obj.RoleStDate)||((+$h>obj.RoleEndDate)&&(obj.RoleEndDate'="")))
	.s roleid=obj.RoleID
	.s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
	.q:'$IsObject(roleObj)
	.s rolecode=roleObj.RoleCode
	.s rolelevel=roleObj.RoleLevel
	.i ret="" s ret=rolecode_"|"_rolelevel_"|"_roleid
	.e  s ret=ret_"^"_rolecode_"|"_rolelevel_"|"_roleid
	s ret=ret_"!"_userId_"^"_nurseDep
	q ret
}

}
