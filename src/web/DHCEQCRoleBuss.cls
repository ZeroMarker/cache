Class web.DHCEQCRoleBuss Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modefied by zc 2015-07-08 zc 0026
/// 描述：角色业务分配
/// Modefied by zc 2015-07-28 zc 0026
/// 描述：添加输出列opt
/// d ##class(%ResultSet).RunQuery("web.DHCEQCRoleBuss","GetRoleBuss","","","","","","","","","")
Query GetRoleBuss(Role As %String = "") As %Query(ROWSPEC = "rowid:%String,roledr:%String,role:%String,busstypedr:%String,busstype:%String,modletypedr:%String,modletype:%String,opt:%String")
{
}

ClassMethod GetRoleBussExecute(ByRef qHandle As %Binary, Role As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s browid=0
	f  s browid=$o(^DHCEQCCode("DHCEQCBussType",browid))  quit:browid=""  d
	.d ResetVariablesGetRoleBuss
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",4)="Y")
	.s busstypedr=browid
	.s busstype=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",2)
	.s modletypedr=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",3)
	.s modletype=$Case(modletypedr,"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修","6":"移动验收","7":"移动报废") //Modify by zx 2020-03-03 BUG 1213713
	.s roledr=Role
	.s role=$p($g(^DHCEQCCode("DHCEQCApproveRole",Role)),"^",2)
	.s rrowid=0
	.f  s rrowid=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",browid,rrowid))  quit:rrowid=""  d
	..q:($p($g(^DHCEQCCode("DHCEQCRoleBuss",rrowid)),"^",1)'=Role)
	..s rowid=rrowid
	.i rowid'="" d
	..s opt="Y"
	.e  d
	..s opt="N"
	.d OutputRowRoleBuss
	Quit $$$OK
OutputRowRoleBuss
	set Data=$lb(rowid,roledr,role,busstypedr,busstype,modletypedr,modletype,opt)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRoleBuss
	Set (rowid,roledr,role,busstypedr,busstype,modletypedr,modletype,opt)=""
	Quit
}

ClassMethod GetRoleBussFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleBussExecute ]
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

ClassMethod GetRoleBussClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleBussExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##Class(web.DHCEQCRoleBuss).SaveRoleBuss("","","") 

ClassMethod SaveRoleBuss(Role As %String, BussType As %String)
{
	k PLIST
	s PLIST(2)=Role
	s PLIST(3)=BussType
	//&SQL(delete from  sqluser.DHC_EQCRoleBuss where RB_RoleDR=:Role and RB_BussTypeDR=:BussType)
	&SQL(Insert into sqluser.DHC_EQCRoleBuss Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

/// Modefied by zc 2015-07-28 zc 0026
/// 描述:新增保存方法
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
			&SQL(insert into sqluser.DHC_EQCRoleBuss values :PLIST())
		}
	}
	else
	{
		i (PLIST(4)="N") 
		{
			s rbrowid=PLIST(1)
			&SQL(delete from SQLUser.DHC_EQCRoleBuss  where RB_RowID=:rbrowid)
		}
		else 
		{
			s rbrowid=PLIST(1)
			&SQL(update  SQLUser.DHC_EQCRoleBuss Values :PLIST() where RB_RowID=:rbrowid)
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

ClassMethod DeleteRoleBuss(Role As %String)
{
	i Role'=""
	{
	&SQL(delete from  sqluser.DHC_EQCRoleBuss where RB_RoleDR=:Role)
	}
	q 0
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取业务
/// 参数： MeunType：0，1，2  业务，预警，监控
/// d ##class(%ResultSet).RunQuery("web.DHCEQCRoleBuss","GetBussByRole","Buss")
Query GetBussByRole(MeunType As %String = "", GroupID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "busstypedr:%String,busscode:%String,busstype:%String,waitnum:%String")
{
}

ClassMethod GetBussByRoleExecute(ByRef qHandle As %Binary, MeunType As %String = "", GroupID As %String = "", UserID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")  //移动端消息 add by zx 2016-04-19
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))  //add by zx 2016-03-03 Bug ZX0035
	i GroupID="" Quit $$$OK
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	i RoleIDs'="" s RoleIDs=","_RoleIDs_","
	s browid=0
	f  s browid=$o(^DHCEQCCode("DHCEQCBussType",browid))  quit:browid=""  d
	.s (busstypedr,busscode,busstype)=""
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",4)="Y")
	.s busstypedr=browid
	.s busscode=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",1)
	.s preBussCode=$e(busscode,1)
	.q:(MeunType="Buss")&&(",1,2,3,4,9,A,"'[preBussCode)&&(busscode'="64") //add by zx Bug ZX0035 增加配件业务 2016-12-09 增加租赁待办 ZX0036
	.q:(MeunType="Warning")&&((",6,7,"'[preBussCode)||(busscode="64")) //add by zx 2016-12-09 租赁预警改为 74
	.q:(MeunType="Monitor")&&(preBussCode'="8")
	.s busstype=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",2)
	.//s modletypedr=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",3)
	.//s modletype=$Case(modletypedr,"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修")
	.s (rrowid,flag,waitnum)=0
	.f  s rrowid=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",browid,rrowid))  quit:rrowid=""  d
	..i (RoleIDs'="")&&(RoleIDs[(","_$p($g(^DHCEQCCode("DHCEQCRoleBuss",rrowid)),"^",1)_",")) s flag=1
	.q:flag=0
	.i (busscode'="64")&&((preBussCode="6")||(preBussCode="7"))  d  //add by zx 2016-12-09 租赁业务取消息数量
	..i (busscode="71")||(busscode="72-1")||(busscode="72-2")  d		//Add By DJ 2015-12-28
	...s waitnum=+##Class(web.DHCEQMessages).GetMaintAlertNum(+$j,busscode)
	..e  i (busscode="63-1")||(busscode="63-2")||(busscode="63-3")  d
	...s waitnum=+##Class(web.DHCEQMessages).GetCertificateAlertNum(busscode,+$H)
	..e  i (busscode="73")  d
	...s waitnum=+##Class(web.DHCEQMessages).GetGuaranteeAlertNum(GroupID,+$H)
	..e  i (busscode="74")  d
	...s waitnum=+##Class(web.DHCEQMessages).GetRentAlertNum(GroupID,+$H)
	.e  i preBussCode="8"  d
	..s waitnum=+##Class(web.DHCEQMessages).GetMaintMonitorNum(GroupID,busscode,UserID)			//Add By DJ 2016-05-26
	.e  d
	..s waitnum=+##Class(web.DHCEQMessages).GetBussAertNum(busscode,GroupID,UserID,RoleIDs)  //add by zx 2016-03-03 Bug ZX0035
	.d OutputRowBuss
	Quit $$$OK
OutputRowBuss
	set Data=$lb(busstypedr,busscode,busstype,waitnum)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBussByRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussByRoleExecute ]
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

ClassMethod GetBussByRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussByRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
