Class web.DHCEQ.Plat.CTGroupRole Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Modified By CSJ 2018-10-23 
/// 描述: 安全组访问角色HISUI改造：按规范修改Query输出列
/// 入参:安全组id
/// 访问表：DHC_EQCGroupRole
/// 输出列：TRowid,TGroupDR,TGroup,TRoleDR,TRole,TOpt
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupRole","GetGroupRole","1")
Query GetGroupRole(Group As %String = "") As %Query(ROWSPEC = "TRowid:%String,TGroupDR:%String,TGroup:%String,TRoleDR:%String,TRole:%String,TOpt:%String")
{
}

ClassMethod GetGroupRoleExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,TRowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s arowid=0
	f  s arowid=$o(^DHCEQCCode("DHCEQCApproveRole",arowid))  quit:arowid=""  d
	.d ResetVariablesGetGroupRole
	.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCApproveRole",arowid)),"^",4)
	.q:invalidFlag="Y"
	.s TRoleDR=arowid
	.s TRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",arowid)),"^",2)
	.s TGroupDR=Group
	.s TGroup=$p(^SSU("SSGRP",TGroupDR),"^",1)
	.s growid=0
	.f  s growid=$o(^DHCEQCCode("DHCEQCGroupRole",0,"Role",TRoleDR,growid))  quit:growid=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCGroupRole",growid)),"^",1)'=TGroupDR)
	..s TRowid=growid
	.i TRowid'="" d
	..s TOpt="Y"
	.e  d
	..s TOpt="N"
	.d OutputRowGetGroupRole
	Quit $$$OK
OutputRowGetGroupRole
	set Data=$lb(TRowid,TGroupDR,TGroup,TRoleDR,TRole,TOpt)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupRole
	Set (TRowid,TGroupDR,TGroup,TRoleDR,TRole,TOpt)=""
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

}
