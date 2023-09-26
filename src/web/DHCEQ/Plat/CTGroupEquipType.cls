Class web.DHCEQ.Plat.CTGroupEquipType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Modified By CSJ 2018-10-23 
/// 描述: 安全组访问代码分配HISUI改造：按规范修改Query输出列
/// 入参:安全组id
/// 访问表：SS_Group
/// 输出列：TRowid,TGroup
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupEquipType","Group")
Query Group(Group As %String = "") As %Query(ROWSPEC = "TRowid:%String,TGroup:%String")
{
}

ClassMethod GroupExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s growid=0
	d BuildDataGetGroup
	Quit $$$OK
BuildDataGetGroup 
	f  s growid=$o(^SSU("SSGRP",growid))  quit:growid=""  d
	.d ResetVariablesGetGroup
	.s TRowid=growid	//rowid
	.s TGroup=$p(^SSU("SSGRP",growid),"^",1)
	.q:(Group'="")&&(TGroup'[Group)
	.d OutputGroup
	quit
OutputGroup
   s Data=$lb(TRowid,TGroup)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroup
	s (TRowid,TGroup)=""
	quit
}

ClassMethod GroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupExecute ]
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

ClassMethod GroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modified By CSJ 2018-10-23 
/// 描述: 安全组访问类组HISUI改造：按规范修改Query输出列
/// 入参:安全组id
/// 访问表：DHC_EQCGroupEquipType
/// 输出列：TRowid,TGroupDR,TGroup,TEquipTypeDR,TEquipType,TDefaultFlag,TAccessFlag
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupEquipType","GetGroupEquipType","1")
Query GetGroupEquipType(Group As %String = "") As %Query(ROWSPEC = "TRowid:%String,TGroupDR:%String,TGroup:%String,TEquipTypeDR:%String,TEquipType:%String,TDefaultFlag:%String,TAccessFlag:%String")
{
}

ClassMethod GetGroupEquipTypeExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,TRowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s erowid=0
	f  s erowid=$o(^DHCEQCCode("DHCEQCEquipType",erowid))  quit:erowid=""  d
	.d ResetVariablesGroupEquipType
	.q:($p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",4)="Y")
	.s TGroupDR=Group
	.s TGroup=$p(^SSU("SSGRP",Group),"^",1)
	.s TEquipTypeDR=erowid
	.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",2)
	.i $D(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",Group,erowid)) d
	..s TRowid=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",Group,erowid,0))
	.i TRowid="" d
	..s TDefaultFlag="N"
	..s TAccessFlag="N"
	.e  d
	..s TDefaultFlag=$p($g(^DHCEQCCode("DHCEQCGroupEquipType",TRowid)),"^",3) 
	..s TAccessFlag="Y"
	.d OutputRowGetGroupEquipType
	Quit $$$OK
OutputRowGetGroupEquipType
	set Data=$lb(TRowid,TGroupDR,TGroup,TEquipTypeDR,TEquipType,TDefaultFlag,TAccessFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGroupEquipType
	Set (TRowid,TGroupDR,TGroup,TEquipTypeDR,TEquipType,TDefaultFlag,TAccessFlag)=""
	Quit
}

ClassMethod GetGroupEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupEquipTypeExecute ]
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

ClassMethod GetGroupEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modefied by zc 2015-07-30 zc0027
/// 描述：修改保存方法
ClassMethod SaveGroupEquipType(PTData)
{
	k PLIST
	s PLIST(1)=$p($G(PTData),"^",1)
	s PLIST(2)=$p($G(PTData),"^",2)
	s PLIST(3)=$p($G(PTData),"^",3)
	s PLIST(4)=$p($G(PTData),"^",4)
	s PLIST(5)=$p($G(PTData),"^",5)
	i (PLIST(5)'="Y")	//Y：安全组允许访问类组
	{
		i (PLIST(1)'="") 
		{
			&SQL(delete from SQLUser.DHC_EQCGroupEquipType  where GET_RowID=:PLIST(1))
		}
		else
		{
			q ""
		}
	}
	else
	{
		i (PLIST(1)'="") 
		{	
			s GETRowID=PLIST(1)
			k PLIST(1)
			&SQL(update  SQLUser.DHC_EQCGroupEquipType Values :PLIST() where GET_RowID=:GETRowID)
		}
		else  
		{	
			k PLIST(1)
			&SQL(insert into sqluser.DHC_EQCGroupEquipType values :PLIST())
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

}
