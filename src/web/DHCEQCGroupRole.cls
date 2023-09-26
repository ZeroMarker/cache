Class web.DHCEQCGroupRole Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modefied by zc 2015-07-08 zc 0026
/// 描述：安全组角色分配
/// Modefied by zc 2015-07-27 zc 0026
/// 描述：添加输出列opt
/// d ##class(%ResultSet).RunQuery("web.DHCEQCGroupRole","GetGroupRole","","","","","","","","","")
Query GetGroupRole(Group As %String = "") As %Query(ROWSPEC = "rowid:%String,groupdr:%String,group:%String,roledr:%String,role:%String,opt:%String")
{
}

ClassMethod GetGroupRoleExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s arowid=0
	f  s arowid=$o(^DHCEQCCode("DHCEQCApproveRole",arowid))  quit:arowid=""  d
	.d ResetVariablesGetGroupRole
	.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCApproveRole",arowid)),"^",4)
	.q:invalidFlag="Y"
	.s roledr=arowid
	.s role=$p($g(^DHCEQCCode("DHCEQCApproveRole",arowid)),"^",2)
	.s groupdr=Group
	.s group=$p(^SSU("SSGRP",groupdr),"^",1)
	.s growid=0
	.f  s growid=$o(^DHCEQCCode("DHCEQCGroupRole",0,"Role",roledr,growid))  quit:growid=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCGroupRole",growid)),"^",1)'=groupdr)
	..s rowid=growid
	.i rowid'="" d
	..s opt="Y"
	.e  d
	..s opt="N"
	.d OutputRowGetGroupRole
	Quit $$$OK
OutputRowGetGroupRole
	set Data=$lb(rowid,groupdr,group,roledr,role,opt)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupRole
	Set (rowid,groupdr,group,roledr,role,opt)=""
	Quit
}

ClassMethod GetGroupRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupRoleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGroupRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##Class(web.DHCEQCGroupRole).SaveGroupRole("","","") 

ClassMethod SaveGroupRole(Group As %String, Role As %String)
{
	k PLIST,rowid
	s PLIST(2)=Group
	s PLIST(3)=Role
	//&SQL(delete from  sqluser.DHC_EQCGroupRole where UR_GroupDR=:Group and UR_RoleDR=:Role)
	&SQL(Insert into sqluser.DHC_EQCGroupRole Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod DeleteGroupRole(Group As %String)
{
	i (Group'="")
	{ &SQL(delete from  sqluser.DHC_EQCGroupRole where UR_GroupDR=:Group) }
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCGroupRole","GroupRole","")
Query GroupRole(Group As %String = "") As %Query(ROWSPEC = "rowid:%String,groupdr:%String,group:%String,roledr:%String,role:%String")
{
}

ClassMethod GroupRoleExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s growid=0
	f  s growid=$o(^DHCEQCCode("DHCEQCGroupRole",growid))  quit:growid=""  d
	.d ResetVariablesGroupRole
	.s roledr=$p($g(^DHCEQCCode("DHCEQCGroupRole",growid)),"^",2)
	.i roledr'="" d
	..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",4)
	..q:invalidFlag="Y"
	..s role=$p($g(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",2)
	.s groupdr=$p($g(^DHCEQCCode("DHCEQCGroupRole",growid)),"^",1)
	.q:groupdr'=Group
	.i groupdr'="" s group=$p(^SSU("SSGRP",groupdr),"^",1)
	.s rowid=growid
	.d OutputRowGroupRole
	Quit $$$OK
OutputRowGroupRole
	set Data=$lb(rowid,groupdr,group,roledr,role)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGroupRole
	Set (rowid,groupdr,group,roledr,role)=""
	Quit
}

ClassMethod GroupRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupRoleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GroupRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-27 zc 0026
/// 描述：新增保存方法
ClassMethod SaveData(PTData)
{
	k PLIST
	s PLIST(1)=$p($G(PTData),"^",1)
	s PLIST(2)=$p($G(PTData),"^",2)
	s PLIST(3)=$p($G(PTData),"^",3)
	s PLIST(4)=$p($G(PTData),"^",4)
	i (PLIST(1)="")
	{
		i (PLIST(4)="N")
		{ 
			q ""
		}
		else
		{
			//k PList(1)
			//注意提交后要刷新
			&SQL(insert into sqluser.DHC_EQCGroupRole values :PLIST())
		}
	}
	else
	{
		i (PLIST(4)="N") 
		{
			s urowid=PLIST(1)
			&SQL(delete from SQLUser.DHC_EQCGroupRole  where UR_RowID=:urowid)
		}
		else 
		{
			s urowid=PLIST(1)
			&SQL(update  SQLUser.DHC_EQCGroupRole Values :PLIST() where UR_RowID=:urowid)
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

/// add by zy 2015-12-08
/// 根据安全组ID取可访问的角色id
/// w ##Class(web.DHCEQCGroupRole).GetRolebyGroup("217") 
ClassMethod GetRolebyGroup(GroupID)
{
	new rowid,roledr,groupdr,DateList,RoleIDs
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s RoleIDs=""
	s roleid=0
	f  s roleid=$o(^DHCEQCCode("DHCEQCApproveRole",roleid))  quit:roleid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCApproveRole",roleid)),"^",4)="Y"
	.s growid=0
	.f  s growid=$o(^DHCEQCCode("DHCEQCGroupRole",0,"Role",roleid,growid))  quit:growid=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCGroupRole",growid)),"^",1)'=GroupID)
	..i RoleIDs=""  d
	...s RoleIDs=roleid
	..e  d
	...s RoleIDs=RoleIDs_","_roleid
	
	q RoleIDs
}

//

/// add by zy 2015-12-08
/// 根据安全组ID取可访问的角色id
/// w ##Class(web.DHCEQCGroupRole).GetGroupbyRole("18") 
ClassMethod GetGroupbyRole(RoleID)
{
	new rowid,GroupIDs,GroupID
	i RoleID="" q ""
	s GroupIDs=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCGroupRole",0,"Role",RoleID,rowid))  quit:rowid=""  d
	.s GroupID=$p($g(^DHCEQCCode("DHCEQCGroupRole",rowid)),"^",1)
	.q:(GroupIDs'="")&((","_GroupIDs_",")[(","_GroupID_","))
	.i GroupIDs=""  d
	..s GroupIDs=GroupID
	.e  d
	..s GroupIDs=GroupIDs_","_GroupID
	
	q GroupIDs
}

}
