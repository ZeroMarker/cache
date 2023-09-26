Class web.DHCEQMCMaintGroup Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zy 2015-12-03
/// 判断当前数据是否是领导
/// 入参: GroupType  1,维修组
/// 	  LeaderUserID  用户id
/// 返回值 flag  0  不是领导,否则是领导组id
/// w ##Class(web.DHCEQMCMaintGroup).GetMemberUser("1")
ClassMethod GetMemberUser(LeaderUser, GroupType As %Library.String = "1")
{
	new MaintGroupID,rowid,UserIDs
	i '$Data(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",GroupType,LeaderUser)) quit LeaderUser
	s UserIDs=LeaderUser
	s (Flag,MaintGroupID)=0
	f  s MaintGroupID=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",GroupType,LeaderUser,MaintGroupID)) quit:MaintGroupID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MaintGroupID)),"^",9)="Y"
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",MaintGroupID,rowid))  quit:rowid=""  d
	..q:$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",6)="Y"
	..s MemberUser=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)
	..s ManagerFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",5)
	..i (ManagerFlag="Y")&&(LeaderUser'=MemberUser)  d   //add by jdl 2017-01-12 主表和子表同时维护组长出现死循环
	...s MemberUser=..GetMemberUser(MemberUser,GroupType)
	..i (LeaderUser'=MemberUser) s UserIDs=UserIDs_","_MemberUser
	
	quit UserIDs
}

ClassMethod SaveMaintGroup(MaintGroupInfo)
{
    new rowid
	k PLIST
	s RowID=$P(MaintGroupInfo,"^",1)
	s PLIST(1)=$P(MaintGroupInfo,"^",1)  ;RowID
	s PLIST(2)=1                         ;GroupType    //modified by czf  需求号：370181
	s PLIST(3)=$P(MaintGroupInfo,"^",3)  ;Desc
	s PLIST(4)=$P(MaintGroupInfo,"^",2)  ;Code
    s PLIST(5)=$P(MaintGroupInfo,"^",7)  ;ManageLocDR
	s PLIST(6)=$P(MaintGroupInfo,"^",5)  ;LeaderUserDR
	s PLIST(9)=$P(MaintGroupInfo,"^",4)  ;Remark
	s PLIST(10)="N"          ;无效标志
	i ($P(MaintGroupInfo,"^",7)'="")&&('$D(^DHCEQCCode("DHCEQCDepartment",$P(MaintGroupInfo,"^",7))))	q "管理科室输入有误!"
	i ($P(MaintGroupInfo,"^",5)'="")&&('$D(^DHCEQCCode("DHCEQCUser",$P(MaintGroupInfo,"^",5))))	q "组领导输入有误!"
	s tmpid=""
	&SQL(select MG_RowID into :tmpid from sqluser.DHC_EQMCMaintGroup where MG_Desc=:PLIST(3) and MG_Code=:PLIST(2) and MG_LeaderUserDR=:PLIST(6) and MG_ManageLocDR=:PLIST(5) and MG_Remark=:PLIST(9) and MG_InvalidFlag='N')
	if ((tmpid'="")&&(tmpid'=RowID)) q "数据有重复"	
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQMCMaintGroup values :PLIST())
		q SQLCODE
	}
	else
	{
		&SQL(update sqluser.DHC_EQMCMaintGroup values :PLIST() where MG_RowID=:RowID)
		q SQLCODE
	}
}

ClassMethod DeleteMaintGroup(RowID)
{
	s InvalidFlag="Y"  ;无效标记
	i (RowID'="")
	{
		&SQL(Update sqluser.DHC_EQMCMaintGroup set MG_InvalidFlag='Y' where MG_RowID = :RowID)
	}
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQMCMaintGroup","LeaderUser")
Query LeaderUser(Name As %String = "") As %Query(ROWSPEC = "rowid:%String,name:%String,initials:%String") [ SqlProc ]
{
}

ClassMethod LeaderUserExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s srowid=0
	s Name=$ZCONVERT(Name,"U")
	
	f  s srowid=$o(^DHCEQCCode("DHCEQCUser",srowid)) q:srowid=""  d
	.d ResetVariablesLeaderUser
	.s rowid=srowid
	.s name=##Class(web.DHCEQCommon).GetTrakNameByID("user", srowid)
	.q:(Name'="")&&($ZCONVERT(name,"U")'[Name)
	.s initials=$p(^DHCEQCCode("DHCEQCUser",srowid),"^",1)
 	.d OutputRowLeaderUser
	Quit $$$OK
    
OutputRowLeaderUser
	set Data=$lb(rowid,name,initials)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
ResetVariablesLeaderUser
	Set (rowid,name,initials)=""
	Quit
}

ClassMethod LeaderUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LeaderUserExecute ]
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

ClassMethod LeaderUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQLeaderUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQMCMaintGroup","GetGroup","1")
Query GetGroup(UserDR) As %SQLQuery(ROWSPEC = "groupdr:%String,group:%String")
{
SELECT distinct OTHLL_UserGroup_DR,OTHLL_UserGroup_DR->SSGRP_Desc FROM (
select OTHLL_ParRef, OTHLL_UserGroup_DR  from sqluser.SS_UserOtherLogonLoc
UNION ALL
SELECT SSUSR_RowId,SSUSR_Group FROM sqluser.SS_User
)
WHERE OTHLL_ParRef=:UserDR
ORDER BY OTHLL_ParRef DESC
}

Query GetEQLoc(Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "") As %Query(ROWSPEC = "Desc:%String,Hidden:%String,Code:%String") [ SqlProc ]
{
}

ClassMethod GetEQLocExecute(ByRef qHandle As %Binary, Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	s LocTypeID=""
	if LocType'=""     //科室类型
	{
		s LocTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code",LocType,0))
		if LocTypeID="" Quit $$$OK
	}	
	
	if (Type="0")||(Type="")  //所有科室
	{
		f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:rowid=""  d
		.s locid=rowid
		.d GetOneLoc
	}
	if Type="1"  //安全组科室
	{
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		f  s rowid=$o(^SSU("SSGRP",vgroupid,"ST",0,"Loc",rowid)) q:rowid=""  d
		.s locid=##Class(web.DHCEQCommon).getMapIDBySource("dept",rowid)
		.d GetOneLoc
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",rowid,locid)) q:(locid="")  d
		..d GetOneLoc
	}
	if Type="2" //本科室
	{
		s rowid=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		s locid=rowid
		d GetOneLoc
	}
	
	//add by jdl 2009-9-14 JDL0030
	s locdesc=""
	f  s locdesc=$o(^DHCEQTemp("LocTemp",$j,locdesc)) q:locdesc=""  d
	.s locid=0
	.f  s locid=$o(^DHCEQTemp("LocTemp",$j,locdesc,locid)) q:locid=""  d
	..s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",locid)
	..s code=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",locid)
	..d OutputRowGetEQLoc
	k ^DHCEQTemp("LocTemp",$j)
	
	Quit $$$OK

GetOneLoc	
	//add by zy 2015-04-09 ZY0125 分院区管理,通过科室的医院属性来管理
	quit:##Class(web.DHCEQCommon).HospitalIsInclude(locid)=0
	
	s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",locid)
	s code=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",locid)
	s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",13)
	q:(notUseFlag'="")&&(NotUse="Y")
	s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",18)
	q:((notUseFlag'="")&&(+DATo'=0)&&(+DATo<+$H))
	s LocDesc=$ZCONVERT(LocDesc,"U")
	q:($ZCONVERT(desc,"U")'[LocDesc)&&($ZCONVERT(code,"U")'[LocDesc)
	if LocTypeID'=""     //库房类型
	{
		if '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeID,locid)) q
	}
	
	//modified by jdl 2009-9-14 JDL0030
	s ^DHCEQTemp("LocTemp",$j,$ZCONVERT(desc,"U"),locid)=""
	quit
OutputRowGetEQLoc
	s Data=$lb(desc,locid,code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEQLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEQLocExecute ]
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

ClassMethod GetEQLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEQLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 需求号:264231
/// 描述：添加输出列项
/// d ##class(%ResultSet).RunQuery("web.DHCEQMCMaintGroup","GetMaintGroup","01")
Query GetMaintGroup(vCode As %String = "", vDesc As %String = "", vuser As %String = "", vLocDR As %String = "", vRemark As %String = "") As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String,Remark:%String,userdr:%String,User:%String,ManageLocDR:%String,ManageLoc:%String,InvalidFlag:%String")
{
}

ClassMethod GetMaintGroupExecute(ByRef qHandle As %Binary, vCode As %String = "", vDesc As %String = "", vuser As %String = "", vLocDR As %String = "", vRemark As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
 	s vCode=$ZCONVERT(vCode ,"U")
 	s vDesc=$ZCONVERT(vDesc ,"U")
 	s vRemark=$ZCONVERT(vRemark ,"U")
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroup",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintGroup
    .s RowID=rowid
	.s InvalidFlag =$p($g(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",9) //无效判断
	.q:InvalidFlag="Y"
	.s Code=$P($G(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",3)
	.q:(vCode'="")&&(Code'[vCode)
	.s Desc =$P($G(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",2)	
	.q:(vDesc'="")&&(Desc'[vDesc)
	.s ManageLocDR=$P($G(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",4)
	.q:(vLocDR'="")&&(ManageLocDR'=vLocDR)
	.i ManageLocDR '=""  d
	..s ManageLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", ManageLocDR)
	.s userdr=$P($G(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",5)
	.q:(vuser'="")&&(userdr'=vuser)
	.i userdr'="" d
	..s User=##Class(web.DHCEQCommon).GetTrakNameByID("user",userdr)
    .s FromDate=$P($G(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",6)
	.;s FromDate=$ZD(FromDate,3)
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s MonthStr=##Class(web.DHCEQCommon).TransValueToPage(FromDate,"date")
	.s ToDate=$P($G(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",7)
	.;s ToDate=$ZD(ToDate,3)
	.;日期格式统一调整   modify by jyp  2017-03-02
	.s ToDate=##Class(web.DHCEQCommon).TransValueToPage(ToDate,"date")
	.s Remark=$P($G(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",8)
	.q:(vRemark'="")&&(Remark'[vRemark)
	.d OutputRowGetMaintGroup
	quit $$$OK
OutputRowGetMaintGroup
	s Data=$lb(RowID,Code,Desc,Remark,userdr,User,ManageLocDR,ManageLoc,InvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintGroup
	s (RowID,Code,Desc,Remark,userdr,User,ManageLocDR,ManageLoc,InvalidFlag)=""
	quit
}

ClassMethod GetMaintGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintGroupExecute ]
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

ClassMethod GetMaintGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
