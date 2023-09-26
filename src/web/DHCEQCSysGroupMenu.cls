Class web.DHCEQCSysGroupMenu Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modefied by zc 2015-07-08 zc 0026
/// 描述：安全组菜单分配
/// Modefied by zc 2015-07-28 zc 0026
/// 描述：修改安全组菜单分配的输出列及传参
/// d ##class(%ResultSet).RunQuery("web.DHCEQCSysGroupMenu","GetGroupmenu","","","","","","","","","")
/// Add memucode by HHM Modified by HHM 2016-04-06
Query GetGroupmenu(Group As %String = "") As %Query(ROWSPEC = "rowid:%String,groupdr:%String,group:%String,menudr:%String,menu:%String,opt:%String,menucode:%String")
{
}

ClassMethod GetGroupmenuExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s srowid=0
	f  s srowid=$o(^DHCEQCCode("DHCEQCSysMenus",srowid))  quit:srowid=""  d
	.d ResetVariablesGetGroupmenu
	.s menudr=srowid
	.s groupdr=Group
	.s menucode=$p($g(^DHCEQCCode("DHCEQCSysMenus",srowid)),"^",3)
	.s menu=$p($g(^DHCEQCCode("DHCEQCSysMenus",srowid)),"^",4)   //modified by HHM 2016-04-06
	.s group=$p(^SSU("SSGRP",groupdr),"^",1)
	.s growid=0
	.f  s growid=$o(^DHCEQCCode("DHCEQCSysGroupMenu",0,"GMMenuDR",srowid,growid))  quit:growid=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCSysGroupMenu",growid)),"^",1)'=Group)
	..s rowid=growid
	.i rowid'="" d
	..s opt="Y"
	.e  d
	..s opt="N"
	.d OutputRowGroupmenu
	Quit $$$OK
OutputRowGroupmenu
	set Data=$lb(rowid,groupdr,group,menudr,menu,opt,menucode)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupmenu
	Set (rowid,groupdr,group,menudr,menu,opt,menucode)=""
	Quit
}

ClassMethod GetGroupmenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupmenuExecute ]
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

ClassMethod GetGroupmenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupmenuExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##Class(web.DHCEQCSysGroupMenu).SaveGroupmenu("","设备","入库") 

ClassMethod SaveGroupmenu(RowId As %String, Group As %String, Menu As %String)
{
	k PLIST,rowid
	s rowid=RowId
	s PLIST(2)=Group
	s PLIST(3)=Menu
	s tmpid=""
	&SQL(select GM_RowID into :tmpid from sqluser.DHC_EQCSysGroupMenu where GM_GroupDR=:Group and GM_MenuDR=:Menu)
	if ((tmpid'="")&&(tmpid'=rowid)) q "数据有重复"	;重复记录
	i (rowid="")
	{
		&SQL(Insert into sqluser.DHC_EQCSysGroupMenu Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCSysGroupMenu Values :PLIST() where GM_RowID = :rowid)
	}
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod DeleteGroupmenu(Rowid As %String)
{
	i (Rowid'="")
	{
		&SQL(delete from  sqluser.DHC_EQCSysGroupMenu where GM_RowID = :Rowid)
	}
	q 0
}

/// Modefied by zc 2015-07-28 zc 0026
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
			&SQL(insert into sqluser.DHC_EQCSysGroupMenu values :PLIST())
		}
	}
	else
	{
		i (PLIST(4)="N") 
		{
			s growid=PLIST(1)
			&SQL(delete from SQLUser.DHC_EQCSysGroupMenu  where GM_RowID=:growid)
		}
		else 
		{
			s growid=PLIST(1)
			&SQL(update  SQLUser.DHC_EQCSysGroupMenu Values :PLIST() where GM_RowID=:growid)
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

/// Modefied by zx 2016-11-09 ZX0036
/// 描述：获取安全组微信端可操作菜单
/// d ##class(%ResultSet).RunQuery("web.DHCEQCSysGroupMenu","GetGroupMenus","85","5313","WeChat","409")
/// Modify by zx 2020-09-16 增加参数传递处理session值获取不到问题
Query GetGroupMenus(GroupID As %String = "", UserID As %String = "", MenusType As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TMenusID:%String,TMenusType:%String,TMenuCode:%String,TMenuName:%String,TWaitNum:%String,TParams:%String,TShowWindows:%String")
{
}

ClassMethod GetGroupMenusExecute(ByRef qHandle As %Binary, GroupID As %String = "", UserID As %String = "", MenusType As %String = "", LocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i GroupID="" Quit $$$OK
	
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	i RoleIDs'="" s RoleIDs=","_RoleIDs_","
	
	s TSysGroupMenuID=0
	f  s TSysGroupMenuID=$o(^DHCEQCCode("DHCEQCSysGroupMenu",0,"GMGroupDR",GroupID,TSysGroupMenuID))  quit:TSysGroupMenuID=""  d
	.d ResetVariablesGetGroupMenus
	.s TMenusID=$p($g(^DHCEQCCode("DHCEQCSysGroupMenu",TSysGroupMenuID)),"^",2)
	.s TParams=$p($g(^DHCEQCCode("DHCEQCSysGroupMenu",TSysGroupMenuID)),"^",3)  // Modefied by zx 2020-12-17 BUG ZX0124
	.i TMenusID'="" d
	..s TMenusType=$p($g(^DHCEQCCode("DHCEQCSysMenus",TMenusID)),"^",5)
	..q:(MenusType'="")&&(MenusType'=TMenusType)
	..s TMenuCode=$p($g(^DHCEQCCode("DHCEQCSysMenus",TMenusID)),"^",3)
	..s TMenuName=$p($g(^DHCEQCCode("DHCEQCSysMenus",TMenusID)),"^",4)
	..s TShowWindows=$p($g(^DHCEQCCode("DHCEQCSysMenus",TMenusID)),"^",12) // Modefied by zx 2022-04-13
	..i TParams="" s TParams=$p($g(^DHCEQCCode("DHCEQCSysMenus",TMenusID)),"^",9) // Modefied by zx 2020-09-16
	..i TMenuCode["approve" d
	...s TBussCode=$CASE(TMenuCode,"maint_approve":"31","rent_approve":"64","check_approve":"11","storemove_approve":"22","disuse_approve":"34","invoice_approve":"66","move_approve":"65","inventory_approve":"53") //Modify by zx 2020-09-16
	...i TBussCode'="" d
	....s TWaitNum=+##Class(web.DHCEQMessages).GetBussAertNum(TBussCode,GroupID,UserID,RoleIDs,LocID)
	..i TMenuCode="buss_submit" d  //add by zx 2016-11-29 维修待办单独取数量 ZX0036
	...s TWaitNum=+##Class(web.DHCEQCSysGroupMenu).GetUpdataNums(UserID,"",RoleIDs)  // Modefied by zx 2020-09-16
	..i TMenuCode="inventory_approve" d  //add by zx 2021-12-20 盘点待办数量 ZX0142
	...s TWaitNum=+##Class(web.DHCEQCSysGroupMenu).GetInventoryNums(LocID,TParams)
	..d OutPutRowGroupMenus
	Quit $$$OK
OutPutRowGroupMenus
	set Data=$lb(TMenusID,TMenusType,TMenuCode,TMenuName,TWaitNum,TParams,TShowWindows)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupMenus
	Set (TMenusID,TMenusType,TMenuCode,TMenuName,TWaitNum,TParams,TShowWindows)=""
	Quit
}

ClassMethod GetGroupMenusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupMenusExecute ]
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

ClassMethod GetGroupMenusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupMenusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2016-11-29 ZX0036
/// 获取新增单据数量,暂时处理维修
/// w ##Class(web.DHCEQCSysGroupMenu).GetUpdataNums(5313,31,"")
/// // Modefied by zx 2020-09-16 调整获取方式
ClassMethod GetUpdataNums(UserID, BussCode As %String = "", RoleIDs As %String = "")
{
	n UpdataNums,BussCodes,BRowID,RRowID
	s UpdataNums=0
	s BussCodes=""
	s BRowID=0
	f  s BRowID=$o(^DHCEQCCode("DHCEQCBussType",BRowID))  quit:BRowID=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",4)="Y")
	.s BussCode=$p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",1)
	.s RRowID=0
	.f  s RRowID=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",BRowID,RRowID))  quit:RRowID=""  d
	..q:(RoleIDs'="")&&(RoleIDs'[(","_$p($g(^DHCEQCCode("DHCEQCRoleBuss",RRowID)),"^",1)_","))
	..//Modify by zx 2020-09-17 BUG ZX0111
	..i (","_BussCodes_",")'[(","_BussCode_",") d
	...i BussCodes'="" s BussCodes=BussCodes_","
	...s BussCodes=BussCodes_BussCode
	
	i (","_BussCodes_",")[(",11,")
	{
		//验收暂不处理
	}
	
	i (","_BussCodes_",")[(",22,")
	{
		s UnSubmitNum=0
		&SQL(SELECT count(1) into :UnSubmitNum FROM SQLUSER.DHC_EQStoreMove WHERE SM_Status=0 and SM_MakerDR=:UserID and SM_InvalidFlag='N')
		s UpdataNums=UpdataNums+UnSubmitNum
	}
	
	i (","_BussCodes_",")[(",31,")
	{
		s UnSubmitNum=0
		&SQL(SELECT count(1) into :UnSubmitNum FROM SQLUSER.DHC_EQMMaintRequest WHERE MR_Status=0 and MR_RequestUserDR=:UserID and MR_InvalidFlag='N')
		s UpdataNums=UpdataNums+UnSubmitNum
	}
	
	i (","_BussCodes_",")[(",34,")
	{
		s UnSubmitNum=0
		&SQL(SELECT count(1) into :UnSubmitNum FROM SQLUSER.DHC_EQDisuseRequest WHERE DR_Status=0 and DR_AddUserDR=:UserID and DR_InvalidFlag='N')
		s UpdataNums=UpdataNums+UnSubmitNum
	}
	
	i (","_BussCodes_",")[(",64,")
	{
		s UnSubmitNum=0
		&SQL(SELECT count(1) into :UnSubmitNum FROM SQLUSER.DHC_EQSRent WHERE R_Status=0 and R_RequestUserDR=:UserID)
		s UpdataNums=UpdataNums+UnSubmitNum
	}
	
	q UpdataNums
}

/// author Add by zx 2021-12-20
/// desc 移动端获取盘点待办数量
/// input InLocID:登录科室id; InParams:菜单参数
/// output 待处理盘点单数量
/// w ##Class(web.DHCEQCSysGroupMenu).GetInventoryNums("202","QXType=0,Status=1,IAStatus=1")
ClassMethod GetInventoryNums(InLocID As %String = "", InParams As %String = "")
{
	i (InLocID="")||(InParams="") q 0
	s (InQXType,InStatus,InIAStatus)=""
	s InParamsLen=$l(InParams,",")
	f InNum=1:1:InParamsLen d
	.s CurInParams=$p(InParams,",",InNum)
	.i $p(CurInParams,"=",1)="QXType" d
	..s InQXType=$p(CurInParams,"=",2)
	.else  if $p(CurInParams,"=",1)="Status" d
	..s InStatus=$p(CurInParams,"=",2)
	.else  if $p(CurInParams,"=",1)="IAStatus" d
	..s InIAStatus=$p(CurInParams,"=",2) 
	s (InStoreLocDR, InManageLocDR)=""
	i InQXType="0" s InManageLocDR=InLocID
	i InQXType="2" s InStoreLocDR=InLocID
	
	s ResInventoryNum=0
	s rowid=0
	f  s rowid=$o(^DHCEQInventory(rowid))  quit:rowid=""  d
	.s data=$g(^DHCEQInventory(rowid))
	.s IRowID=rowid
	.
	.s IStoreLocDR=$p(data,"^",2)
	.q:(InStoreLocDR'="")&&(IStoreLocDR'="")&&(InStoreLocDR'=IStoreLocDR)  //临床科室查看时根据库房过来
	.s IUseLocDR=$p(data,"^",3)
	.s IEquipTypeDR=$p(data,"^",4)
	.
	.s IStatus=$p(data,"^",10)
	.q:IStatus'="1" //状态过滤
	.s IManageLocDR=$p(data,"^",14)
	.q:(InManageLocDR'="")&&(InManageLocDR'=IManageLocDR)  //管理部门查看时管理部门过滤
	.s ISelfFlag=$p(data,"^",20)
	.s ILocIncludeFlag=$p(data,"^",21)
	.q:(InQXType="2")&&(ISelfFlag'="Y")
	.s (IARowID,vIARowID)=""
	.s AuditIncludeFlag=0
	.s vStoreLocID=0
	.;获取到审核表id后不退出,还需要获取子科室
	.f  s vStoreLocID=$o(^DHCEQInventoryAudit(0,"Inventory",IRowID,vStoreLocID)) q:vStoreLocID=""  d
	..s vIARowID=$o(^DHCEQInventoryAudit(0,"Inventory",IRowID,vStoreLocID,0))
	..q:vIARowID=""
	..q:InQXType'="2"  //需登录科室为临床
	..q:$p($g(^DHCEQInventoryAudit(vIARowID)),"^",8)'="0"
	..;modified by wy 20230301 需求3300617 临床科室登录数据异常
	..i (ILocIncludeFlag'="Y")&&(InStoreLocDR=vStoreLocID) d
	...s AuditIncludeFlag=AuditIncludeFlag+1
	..i (ILocIncludeFlag="Y")&&(InStoreLocDR'=vStoreLocID) d
	...i (##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(InStoreLocDR,vStoreLocID,"1")="1") d
	....s AuditIncludeFlag=AuditIncludeFlag+1
	.q:(InQXType="2")&&(AuditIncludeFlag=0)
	.s ResInventoryNum=ResInventoryNum+1
	
	q ResInventoryNum
}

}
