Class web.DHCEQ.Plat.CTSysGroupMenu Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Modified By CSJ 2018-10-23 
/// 描述: 安全组菜单分配HISUI改造：按规范修改Query输出列
/// 入参:安全组id
/// 访问表：DHC_EQCSysMenus,DHC_EQCSysGroupMenus
/// 输出列：TRowid,TGroupDR,TGroup,TMenuDR,TMenu,TOpt,TMenuCode
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTSysGroupMenu","GetGroupmenu","85")
Query GetGroupmenu(Group As %String = "") As %Query(ROWSPEC = "TRowid:%String,TGroupDR:%String,TGroup:%String,TMenuDR:%String,TMenu:%String,TOpt:%String,TMenuCode:%String,TMenuType:%String,TUrlParms:%String")
{
}

ClassMethod GetGroupmenuExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,TRowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s srowid=0
	f  s srowid=$o(^DHCEQCCode("DHCEQCSysMenus",srowid))  quit:srowid=""  d
	.d ResetVariablesGetGroupmenu
	.s TMenuDR=srowid
	.s TGroupDR=Group
	.s TMenuCode=$p($g(^DHCEQCCode("DHCEQCSysMenus",srowid)),"^",3)
	.s TMenu=$p($g(^DHCEQCCode("DHCEQCSysMenus",srowid)),"^",4)   //modified by HHM 2016-04-06
	.s TGroup=$p(^SSU("SSGRP",TGroupDR),"^",1)
	.//Modify by zx 2020-09-16 增加输出显示
	.s TMenuType=$p($g(^DHCEQCCode("DHCEQCSysMenus",srowid)),"^",5)
	.s TUrlParms=$p($g(^DHCEQCCode("DHCEQCSysMenus",srowid)),"^",9)
	.s growid=0
	.f  s growid=$o(^DHCEQCCode("DHCEQCSysGroupMenu",0,"GMMenuDR",srowid,growid))  quit:growid=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCSysGroupMenu",growid)),"^",1)'=Group)
	..s TRowid=growid
	.i TRowid'="" d
	..s TOpt="Y"
	..//Modify by zx 2020-09-16
	..s TUrlParms=$p($g(^DHCEQCCode("DHCEQCSysGroupMenu",TRowid)),"^",3)
	.e  d
	..s TOpt="N"
	.d OutputRowGroupmenu
	Quit $$$OK
OutputRowGroupmenu
	set Data=$lb(TRowid,TGroupDR,TGroup,TMenuDR,TMenu,TOpt,TMenuCode,TMenuType,TUrlParms)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupmenu
	Set (TRowid,TGroupDR,TGroup,TMenuDR,TMenu,TOpt,TMenuCode,TMenuType,TUrlParms)=""
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

/// Modefied by zc 2015-07-28 zc 0026
/// 描述：新增保存方法
ClassMethod SaveData(PTData)
{
	//Modify by zx 2020-09-16 调整字段保存处理
	k PLIST,Flag
	s PLIST(1)=$p($G(PTData),"^",1)
	s PLIST(2)=$p($G(PTData),"^",2)
	s PLIST(3)=$p($G(PTData),"^",3)
	s Flag=$p($G(PTData),"^",4)  //Modify by zx 2020-09-16
	s PLIST(4)=$p($G(PTData),"^",5)  //Modify by zx 2020-09-16
	i (PLIST(1)="")
	{ 
		i (Flag="N") 
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
		i (Flag="N") 
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

}
