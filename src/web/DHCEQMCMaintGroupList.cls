/// ----------------------------------------
/// ****** add by jy  2015-12-18  JY0008
/// 编写DHC_EQMCMaintGroupList表的增、改、删、找方法
/// ----------------------------------------
Class web.DHCEQMCMaintGroupList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveMaintGroupList(MaintGroupListInfo)
{
       
	k PLIST,rowid
	s RowID=$P(MaintGroupListInfo,"^",1)
	s PLIST(1)=$P(MaintGroupListInfo,"^",1)  ;RowID
	s PLIST(2)=$P(MaintGroupListInfo,"^",2)  ;MaintGroupDR
	s PLIST(3)=$P(MaintGroupListInfo,"^",3)  ;MemberUserDR
	s PLIST(6)=$P(MaintGroupListInfo,"^",4)  ;ManagerFlag
    s PLIST(7)="N"          ;无效标志	
	s tmpid=""
	&SQL(select MGL_RowID into :tmpid from sqluser.DHC_EQMCMaintGroupList where MGL_MaintGroupDR=:PLIST(2) and MGL_MemberUserDR=:PLIST(3) and MGL_ManagerFlag=:PLIST(6) and MGL_InvalidFlag='N')
	if ((tmpid'="")&&(tmpid'=RowID)) q "数据有重复"	;重复记录
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQMCMaintGroupList values :PLIST())
		q SQLCODE
	}
	else
	{
		&SQL(update sqluser.DHC_EQMCMaintGroupList values :PLIST() where MGL_RowID=:RowID)
		q SQLCODE
	}
}

ClassMethod DeleteMaintGroupList(RowID As %String)
{
	s InvalidFlag="Y"  ;无效标记
	i (RowID'="")
	{
		&SQL(Update sqluser.DHC_EQMCMaintGroupList set MGL_InvalidFlag='Y' where MGL_RowID = :RowID)
	}
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQMCMaintGroupList","MemberUser")
Query MemberUser(Name As %String = "") As %Query(ROWSPEC = "rowid:%String,name:%String,initials:%String") [ SqlProc ]
{
}

ClassMethod MemberUserExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s srowid=0
	s Name=$ZCONVERT(Name,"U")
	f  s srowid=$o(^DHCEQCCode("DHCEQCUser",srowid)) q:srowid=""  d
	.d ResetVariablesMemberUser
	.s rowid=srowid
	.s initials=$p(^DHCEQCCode("DHCEQCUser",srowid),"^",1)
	.s name=##Class(web.DHCEQCommon).GetTrakNameByID("user", srowid)
	.q:(Name'="")&&($ZCONVERT(name,"U")'[Name)&&($ZCONVERT(initials,"U")'[Name)		//modified by czf 416785
 	.d OutputRowMemberUser	 	
	Quit $$$OK
    
OutputRowMemberUser
	set Data=$lb(rowid,name,initials)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
ResetVariablesMemberUser
	Set (rowid,name,initials)=""
	Quit
}

ClassMethod MemberUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MemberUserExecute ]
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

ClassMethod MemberUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQMemberUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 
 	Quit $$$OK
}

/// 描述：添加输出项
/// d ##class(%ResultSet).RunQuery("web.DHCEQMCMaintGroupList","GetMaintGroupList","",6,"on")
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
/// modified by wy 2021-5-6 1890455，1889755输出列标题修改,系统配置中已有匹配的输出列优先采用系统匹配的
Query GetMaintGroupList(MemberUser As %String = "", MGroupDR As %String = "", MFlag As %String = "", CurUserID As %String = "", DistinctFlag As %String = "") As %Query(ROWSPEC = "Hidden:%String,userdr:%String:用户ID,User:%String:受理人,MaintGroupDR:%String:机组,ManagerFlag:%String:管理权限,InvalidFlag:%String:无效标志,Initials:%String:登录名,MaintGroup:%String:所属机组")
{
}

ClassMethod GetMaintGroupListExecute(ByRef qHandle As %Binary, MemberUser As %String = "", MGroupDR As %String = "", MFlag As %String = "", CurUserID As %String = "", DistinctFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	k ^Temp("MaintGroupList",+$H)
 	s MemberUser=$ZCONVERT(MemberUser,"U")
 	//add by zx 2016-11-28 根据当前人员取维修组 begin ZX0036
	i (CurUserID'="")&&(MGroupDR="") d
	.s curRowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",CurUserID,0))
	.i curRowid'="" d
	..s MGroupDR=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",curRowid)),"^",1)
	//add by zx 2016-11-28 根据当前人员取维修组 end
 	
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintGroupList
    .s RowID=rowid
	.s InvalidFlag =$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",6) //无效判断
	.q:InvalidFlag="Y"
    .s userdr=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)
	.i userdr'="" d
	..s Initials=$P($G(^DHCEQCCode("DHCEQCUser",userdr)),"^",1) 
	..s User=##Class(web.DHCEQCommon).GetTrakNameByID("user", userdr)
	.s MaintGroupDR=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",1)
	.q:(MemberUser'="")&($ZCONVERT(User,"U")'[MemberUser)
	.q:(MGroupDR'="")&&(MaintGroupDR'=MGroupDR)
	.s MGInvalidFlag="N"
	.i MaintGroupDR'=""  d
	..s MaintGroup=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MaintGroupDR)),"^",2)
	..s MGInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MaintGroupDR)),"^",9)
	.q:MGInvalidFlag="Y"
    .s ManagerFlag=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",5)
    .q:(MFlag="true")&&(ManagerFlag'="Y")	;//需求号:264283		Mozy	2016-10-13
	.i DistinctFlag=""  d
	..d OutputRowGetMaintGroupList
	.e  d
	..i '$D(^Temp("MaintGroupList",+$H,userdr))  d
	...s ^Temp("MaintGroupList",+$H,userdr)=""
	...d OutputRowGetMaintGroupList
	
	k ^Temp("MaintGroupList",+$H)
	quit $$$OK
OutputRowGetMaintGroupList
	s Data=$lb(RowID,userdr,User,MaintGroupDR,ManagerFlag,InvalidFlag,Initials,MaintGroup)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintGroupList
	s (RowID,userdr,User,MaintGroupDR,ManagerFlag,InvalidFlag,Initials,MaintGroup)=""
	quit
}

ClassMethod GetMaintGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintGroupListExecute ]
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

ClassMethod GetMaintGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0152	3203598		2023-02-06	获取维修组信息
/// w ##Class(web.DHCEQMCMaintGroupList).GetMaintGroupByUser(3828)
ClassMethod GetMaintGroupByUser(UserID As %String = "")
{
	n MGLRowID,MGRowID,Global
	i UserID="" q ""
	s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList","0","MaintMember","N",UserID,""))
	i MGLRowID="" q ""
	s MGRowID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",1)
	s Global=$g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID))
	i $p(Global,"^",9)="Y" q ""
	q MGRowID_"^"_$p(Global,"^",2,3)
}

}
