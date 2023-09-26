Class web.DHCEQCManageLimit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modefied by zc 2015-07-08 zc0026
/// 描述：限定管理
/// d ##class(%ResultSet).RunQuery("web.DHCEQCManageLimit","GetManageLimit","","","")
Query GetManageLimit(User As %String = "", Group As %String = "", Role As %String = "") As %Query(ROWSPEC = "rowid:%String,userdr:%String,user:%String,groupdr:%String,group:%String,roledr:%String,role:%String,equiptypeflag:%String,statcatflag:%String,equipcatflag:%String,locflag:%String,equipflag:%String,itemflag:%String,TRow:%String")
{
}

ClassMethod GetManageLimitExecute(ByRef qHandle As %Binary, User As %String = "", Group As %String = "", Role As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	Set TRow=0
	k ^DHCEQTemp("GetManageLimit",$j)
	Set userdr=0
	For  Set userdr=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr)) Quit:userdr=""  Do
	.Quit:(User'="")&&(userdr'=User)
	.Set initials=+$Piece($Get(^DHCEQCCode("DHCEQCUser",userdr)),"^",1)
	.Set user=##Class(web.DHCEQCommon).GetTrakNameByID("user",userdr)
	.Set groupdr=0
	.For  Set groupdr=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr,groupdr)) Quit:groupdr=""  Do
	..Quit:(Group'="")&&(groupdr'=Group)
	..Set group=$Piece($Get(^SSU("SSGRP",groupdr)),"^",1)
	..Set roledr=""
	..For  Set roledr=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr,groupdr,roledr)) Quit:roledr=""  Do
	...Quit:(Role'="")&&(roledr'=Role)
	...Set rinvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",4)
	...Quit:rinvalidFlag="Y"
	...Set role=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",2)
	...s ^DHCEQTemp("GetManageLimit",$j,initials,userdr,groupdr,roledr)=""	;按姓名首拼进行排序
	
	///输出
	Set initials=""
	For  Set initials=$Order(^DHCEQTemp("GetManageLimit",$j,initials)) Quit:initials=""  Do
	.Do ResetVariablesGetManageLimit
	.Set userdr=""
	.For  Set userdr=$Order(^DHCEQTemp("GetManageLimit",$j,initials,userdr)) Quit:userdr=""  Do
	..Set user=##Class(web.DHCEQCommon).GetTrakNameByID("user",userdr)
	..Set groupdr=""
	..For  Set groupdr=$Order(^DHCEQTemp("GetManageLimit",$j,initials,userdr,groupdr)) Quit:groupdr=""  Do
	...Set group=$Piece($Get(^SSU("SSGRP",groupdr)),"^",1)
	...Set roledr=""
	...For  Set roledr=$Order(^DHCEQTemp("GetManageLimit",$j,initials,userdr,groupdr,roledr)) Quit:roledr=""  Do
	....Set role=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",2)
	....Set mlrowid=""
	....For  Set mlrowid=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr,groupdr,roledr,mlrowid)) Quit:mlrowid=""  Do
	.....Set equiptypeflag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",4)
	.....Set statcatflag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",5)
	.....Set equipcatflag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",6)
	.....Set locflag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",7)
	.....Set equipflag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",8)
	.....Set itemflag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",9)
	.....Do OutputRowManageLimit
	k ^DHCEQTemp("GetManageLimit",$j)
	Quit $$$OK
OutputRowManageLimit
	Set TRow=TRow+1
	set Data=$lb(mlrowid,userdr,user,groupdr,group,roledr,role,equiptypeflag,statcatflag,equipcatflag,locflag,equipflag,itemflag,TRow)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetManageLimit
	Set (equiptypeflag,statcatflag,equipcatflag,locflag,equipflag,itemflag)=""
	Quit
}

ClassMethod GetManageLimitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManageLimitExecute ]
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

ClassMethod GetManageLimitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManageLimitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-13 zc0027
/// 描述：根据类型来区分不同的控制类型的输出
/// d ##class(%ResultSet).RunQuery("web.DHCEQCManageLimit","GetManageLimitList","1","","")
Query GetManageLimitList(ManageLimitDR As %String = "", Type As %String = "", Value As %String = "") As %Query(ROWSPEC = "rowid:%String,managelimitdr:%String,typedr:%String,type:%String,valuedr:%String,value:%String,accessflag:%String")
{
}

ClassMethod GetManageLimitListExecute(ByRef qHandle As %Binary, ManageLimitDR As %String = "", Type As %String = "", Value As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s mrowid=0
	f  s mrowid=$o(^DHCEQCCode("DHCEQCManageLimitList",mrowid))  quit:mrowid=""  d
	.d ResetVariablesGetManageLimitList
	.s rowid=mrowid
	.s managelimitdr=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",1)
	.q:managelimitdr'=ManageLimitDR
	.s typedr=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",2)
	.q:typedr'=Type
	.s type=$CASE(typedr,"":"","1":"类组","2":"类型","3":"分类","4":"科室","5":"设备","6":"设备项")
	.s accessflag=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",4)
	.s valuedr=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",3)
	.q:(Value'="")&&(valuedr'=Value)
	.i typedr=1 d
	..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipType",valuedr)),"^",4)  //Modefied by zc 2015-07-13 zc0027 begin
	..q:invalidFlag="Y"
	..s value=$p($g(^DHCEQCCode("DHCEQCEquipType",valuedr)),"^",2)
	..d OutputRowManageLimitList
	.e  i typedr=2 d
	..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",valuedr)),"^",4)
	..q:invalidFlag="Y"
	..s value=$p($g(^DHCEQCCode("DHCEQCStatCat",valuedr)),"^",2)
	..d OutputRowManageLimitList
	.e  i typedr=3 d
	..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipeCat",valuedr)),"^",7)
	..q:invalidFlag="Y"
	..s value=$p($g(^DHCEQCCode("DHCEQCEquipeCat",valuedr)),"^",2)
	..d OutputRowManageLimitList
	.e  i typedr=4 d
	..s value=##Class(web.DHCEQCommon).GetTrakNameByID("dept",valuedr) //Modefied by zc 2015-07-13 zc0027 end
	..d OutputRowManageLimitList
	.e  i typedr=5 d
	..s value=$p($g(^DHCEQEquip(valuedr)),"^",71)_","_$p($g(^DHCEQEquip(valuedr)),"^",85)_","_$p($g(^DHCEQEquip(valuedr)),"^",1)
	..s value=value_","_$p($g(^DHCEQEquip(valuedr)),"^",6)
	..s value=value_","_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(valuedr)),"^",19))
	..d OutputRowManageLimitList
	.e  i typedr=6 d
	..s value=$p($g(^DHCEQCCode("DHCEQCMasterItem",valuedr)),"^",1)
	..d OutputRowManageLimitList
	Quit $$$OK
OutputRowManageLimitList
	set Data=$lb(rowid,managelimitdr,typedr,type,valuedr,value,accessflag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetManageLimitList
	Set (rowid,managelimitdr,typedr,type,valuedr,value,accessflag)=""
	Quit
}

ClassMethod GetManageLimitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManageLimitListExecute ]
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

ClassMethod GetManageLimitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManageLimitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-27 zc0026
/// 描述：新增与更新分开，此部分为更新
ClassMethod SaveManageLimit(RowId As %String, User As %String, Group As %String, Role As %String, EquipTypeFlag As %String, StatCatFlag As %String, EquiCatFlag As %String, LocFlag As %String, EquipFlag As %String, ItemFlag As %String)
{
	k PLIST,rowid
	s rowid=RowId
	s PLIST(2)=User
	s PLIST(3)=Group
	s PLIST(4)=Role
	s PLIST(5)=EquipTypeFlag
	s PLIST(6)=StatCatFlag
	s PLIST(7)=EquiCatFlag
	s PLIST(8)=LocFlag
	s PLIST(9)=EquipFlag
	s PLIST(10)=ItemFlag
	
	s tmpid=""
	&SQL(select ML_RowID into :tmpid from sqluser.DHC_EQCManageLimit where ML_UserDR=:User and ML_GroupDR=:Group and ML_RoleDR=:Role)
	if ((tmpid'="")&&(tmpid'=rowid)) q "数据有重复"	;重复记录
	&SQL(Update sqluser.DHC_EQCManageLimit Values :PLIST() where ML_RowID = :rowid)
	q SQLCODE
}

/// Modefied by zc 2015-07-27 zc0026
/// 描述：新增与更新分开，此部分为新增
ClassMethod AddManageLimit(User As %String, Group As %String, Role As %String, EquipTypeFlag As %String, StatCatFlag As %String, EquiCatFlag As %String, LocFlag As %String, EquipFlag As %String, ItemFlag As %String)
{
	k PLIST
	s PLIST(2)=User
	s PLIST(3)=Group
	s PLIST(4)=Role
	s PLIST(5)=EquipTypeFlag
	s PLIST(6)=StatCatFlag
	s PLIST(7)=EquiCatFlag
	s PLIST(8)=LocFlag
	s PLIST(9)=EquipFlag
	s PLIST(10)=ItemFlag
	s tmpid=""
	&SQL(select ML_RowID into :tmpid from sqluser.DHC_EQCManageLimit where ML_UserDR=:User and ML_GroupDR=:Group and ML_RoleDR=:Role)
	if (tmpid'="") q "数据有重复"	;重复记录
	&SQL(Insert into sqluser.DHC_EQCManageLimit Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod DeleteManageLimit(Rowid As %String)
{
	i (Rowid'="") 
	{
		&SQL(delete from  sqluser.DHC_EQCManageLimitList where MLL_ManageLimitDR = :Rowid)
		&SQL(delete from  sqluser.DHC_EQCManageLimit where ML_RowID = :Rowid)
	}
	Q SQLCODE  /// Modefied by zc 2015-07-27 zc0026 将0改SQLCODE
}

// w ##Class(web.DHCEQCManageLimit).SaveManageLimitList("","1","1","345") 

/// Modefied by zc 2015-07-27 zc0027
/// 描述：新增与更新分开，此部分为更新
ClassMethod SaveManageLimitList(RowId As %String, ManageLimitDR As %String, Type As %String, Value As %String, AccessFlag As %String = "")
{
	k PLIST,rowid
	s rowid=RowId
	s PLIST(2)=ManageLimitDR
	s PLIST(3)=Type
	s PLIST(4)=Value
	s PLIST(5)=AccessFlag
	s tmpid=""
	&SQL(select MLL_RowID into :tmpid from sqluser.DHC_EQCManageLimitList where MLL_ManageLimitDR=:ManageLimitDR and MLL_Type=:Type and MLL_Value=:Value)
	if ((tmpid'="")&&(tmpid'=rowid)) q "数据有重复"	;重复记录
	&SQL(Update sqluser.DHC_EQCManageLimitList Values :PLIST() where MLL_RowID = :rowid)
	q SQLCODE
}

/// w ##Class(web.DHCEQCManageLimit).AddManageLimitList("1","4","3") 
/// Modefied by zc 2015-07-27 zc0027
/// 描述：新增与更新分开，此部分为新增
ClassMethod AddManageLimitList(ManageLimitDR As %String, Type As %String, Value As %String, AccessFlag As %String = "")
{
    n (ManageLimitDR , Type, Value, AccessFlag)
	k PLIST
	s PLIST(2)=ManageLimitDR
	s PLIST(3)=Type
	s PLIST(4)=Value
	s PLIST(5)=AccessFlag
	s tmpid=""

	&SQL(select MLL_RowID into :tmpid from sqluser.DHC_EQCManageLimitList where MLL_ManageLimitDR=:ManageLimitDR and MLL_Type=:Type and MLL_Value=:Value)
    i (tmpid'="") q "数据有重复"	
	&SQL(Insert into sqluser.DHC_EQCManageLimitList Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod DeleteManageLimitList(Rowid As %String)
{
	i (Rowid'="") 
	{
		&SQL(delete from  sqluser.DHC_EQCManageLimitList where MLL_RowID = :Rowid)
	}
	Q SQLCODE  /// Modefied by zc 2015-07-27 zc0027 将0改SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCManageLimit","GetType","1")
Query GetType(ManageLimitDR As %String = "") As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

ClassMethod GetTypeExecute(ByRef qHandle As %Binary, ManageLimitDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	d ResetVariablesGetType
	s equiptypeflag=$p($g(^DHCEQCCode("DHCEQCManageLimit",ManageLimitDR)),"^",4)
	i equiptypeflag="Y" d
	.s code=1
	.s desc="类组"
	.d OutputRowType
	s statcatflag=$p($g(^DHCEQCCode("DHCEQCManageLimit",ManageLimitDR)),"^",5)
	i statcatflag="Y" d
	.s code=2
	.s desc="类型"
	.d OutputRowType
	s equipcatflag=$p($g(^DHCEQCCode("DHCEQCManageLimit",ManageLimitDR)),"^",6)
	i equipcatflag="Y" d
	.s code=3
	.s desc="分类"
	.d OutputRowType
	s locflag=$p($g(^DHCEQCCode("DHCEQCManageLimit",ManageLimitDR)),"^",7)
	i locflag="Y" d
	.s code=4
	.s desc="科室"
	.d OutputRowType
	s equipflag=$p($g(^DHCEQCCode("DHCEQCManageLimit",ManageLimitDR)),"^",8)
	i equipflag="Y" d
	.s code=5
	.s desc="设备"
	.d OutputRowType
	s equipflag=$p($g(^DHCEQCCode("DHCEQCManageLimit",ManageLimitDR)),"^",9)
	i equipflag="Y" d
	.s code=6
	.s desc="设备项"
	.d OutputRowType
	Quit $$$OK
OutputRowType
	set Data=$lb(code,desc)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetType
	Set (code,desc)=""
	Quit
}

ClassMethod GetTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeExecute ]
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

ClassMethod GetTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-13 zc0027
/// 描述：根据类型来控制内容的显示
/// d ##class(%ResultSet).RunQuery("web.DHCEQCManageLimit","GetValue","6")
Query GetValue(Type As %String = "", Desc As %String = "") As %Query(ROWSPEC = "rowid:%String,invalidFlag:%String,desc:%String,remark:%String")
{
}

ClassMethod GetValueExecute(ByRef qHandle As %Binary, Type As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s group=%session.Get("LOGON.GROUPID")
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	if Type="1"
	{
		s EquipTypeDR=""
		f  s EquipTypeDR=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",group,EquipTypeDR))  quit:EquipTypeDR=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",4)
		.q:invalidFlag="Y"
		.s desc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
		.q:(Desc'="")&&(desc'[Desc)
		.s remark=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1)
		.s rowid=EquipTypeDR
		.d OutputRowValue
	}
	if Type="2"
	{
		s equipinfo=..Chanage(##Class(web.DHCEQCommon).GetEquipTypesByGroup(group))
		s csrowid=0
		f  s csrowid=$o(^DHCEQCCode("DHCEQCStatCat",csrowid)) q:csrowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",4)
		.q:invalidFlag="Y"
		.s code=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1)
		.s code=$e($p(code,"-",1),2,$l($p(code,"-",1)))
		.q:(0=(##Class(web.DHCEQCommon).Find(equipinfo,code,"N")))
		.s desc=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",2)
		.s remark=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1)
		.q:(Desc'="")&&(desc'[Desc)&&(remark'[Desc)		//Add By DJ 2017-02-17
		.s rowid=csrowid
		.d OutputRowValue
	}
	if Type="3"
	{
		s cerowid=0
		f  s cerowid=$o(^DHCEQCCode("DHCEQCEquipeCat",cerowid)) q:cerowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",7)
		.q:invalidFlag="Y"
		.s desc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",2)
		.s remark=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",1)
		.q:(Desc'="")&&(desc'[Desc)&&(remark'[Desc)			//Add By DJ 2017-02-17
		.s rowid=cerowid
		.d OutputRowValue
	}
	if Type="4"
	{
		s crowid=0
		f  s crowid=$o(^DHCEQCCode("DHCEQCDepartment",crowid)) q:crowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCDepartment",crowid)),"^",13)
		.q:'$d(^DHCEQEquip("0","UseLoc",crowid))	;过滤台账无设备的科室
		.s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", crowid)
		.s remark=$p($g(^DHCEQCCode("DHCEQCDepartment",crowid)),"^",1)
		.q:(Desc'="")&&(desc'[Desc)&&(remark'[Desc)		//Add By DJ 2017-02-17
		.s rowid=crowid
		.d OutputRowValue
	}
	if Type="5"
	{
		s eqrowid=0
		f  s eqrowid=$o(^DHCEQEquip(eqrowid)) q:eqrowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQEquip(eqrowid)),"^",59)
		.q:invalidFlag="Y"
		.s desc=$p($g(^DHCEQEquip(eqrowid)),"^",1)
		.s desc=desc_","_$p($g(^DHCEQEquip(eqrowid)),"^",6)
		.s desc=desc_","_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(eqrowid)),"^",19))
		.s remark=$p($g(^DHCEQEquip(eqrowid)),"^",71)_","_$p($g(^DHCEQEquip(eqrowid)),"^",85)
		.q:(Desc'="")&&($ZCONVERT(desc,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(remark,"U")'[$ZCONVERT(Desc,"U"))		//Add By DJ 2017-02-17
		.s rowid=eqrowid
		.d OutputRowValue
	}
	if Type="6"
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s ItemID=0
		.f  s ItemID=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,ItemID)) quit:ItemID=""  d
		..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",8)
		..q:invalidFlag="Y"
		..s desc = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",1)
		..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",2)
		..q:(Desc'="")&&(($ZCONVERT(desc ,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Desc,"U")))
		..s remark=TCode
		..s rowid=ItemID
		..d OutputRowValue
	}
	Quit $$$OK
OutputRowValue
	set Data=$lb(rowid,invalidFlag,desc,remark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetValue
	Set (rowid,invalidFlag,desc,remark)=""
	Quit
}

ClassMethod GetValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueExecute ]
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

ClassMethod GetValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQCManageLimit).Chanage()
ClassMethod Chanage(str)
{
	n info,length,infostr
	s info=""
	s infostr=""
	i str=""  q ""
	s length=$l(str,"^")
	f i=1:1:length
	{
		s info=$p(str,"^",i)
		i infostr="" d
		.s infostr=infostr_info
		e  d
		.s infostr=infostr_","_info
	}
	q infostr
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCManageLimit","User")
Query User(Name As %String = "") As %Query(ROWSPEC = "rowid:%String,name:%String,initials:%String")
{
}

ClassMethod UserExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s srowid=0
	s Name=$ZCONVERT(Name,"U")
	f  s srowid=$o(^DHCEQCCode("DHCEQCUser",srowid)) q:srowid=""  d
	.d ResetVariablesUser
	.s rowid=srowid
	.s name=##Class(web.DHCEQCommon).GetTrakNameByID("user", srowid)
	.s initials=$p(^DHCEQCCode("DHCEQCUser",srowid),"^",1)
	.q:(Name'="")&&($ZCONVERT(name,"U")'[Name)&&($ZCONVERT(initials,"U")'[Name)		//Add By DJ 2017-02-17
 	.d OutputRowUser
	Quit $$$OK
    
OutputRowUser
	set Data=$lb(rowid,name,initials)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
ResetVariablesUser
	Set (rowid,name,initials)=""
	Quit
}

ClassMethod UserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2017-02-18
/// d ##class(%ResultSet).RunQuery("web.DHCEQCManageLimit","GetGroup",1,"")
Query GetGroup(UserDR As %String = "", Group As %String = "") As %Query(ROWSPEC = "groupdr:%String,group:%String")
{
}

ClassMethod GetGroupExecute(ByRef qHandle As %Binary, UserDR As %String = "", Group As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//add by zx 2018-08-17 不明确用在那里 暂时屏蔽
 	/*
 	i UserDR="" Quit $$$OK
 	k ^DHCEQTemp("GetGroup",$J)
 	//默认登录科室
 	s UserGroupDR=$p($g(^SSU("SSUSR",UserDR)),"^",5)
 	i UserGroupDR'="" s ^DHCEQTemp("GetGroup",$J,UserGroupDR)=1
	//其它登录科室
	s chl=0
	f  s chl=$O(^SSU("SSUSR",UserDR,"OTHLL",chl)) q:(chl="")  d
	.s UserGroupDR=$P(^SSU("SSUSR",UserDR,"OTHLL",chl),"^",2)
	.q:UserGroupDR=""
	.s ^DHCEQTemp("GetGroup",$J,UserGroupDR)=1
	//结果输出
	s UserGroupDR=0
	f  s UserGroupDR=$o(^DHCEQTemp("GetGroup",$J,UserGroupDR))  q:UserGroupDR=""  d
	.s groupdr=UserGroupDR
	.s group=$p(^SSU("SSGRP",groupdr),"^",1)
	.q:group=""
	.q:(Group'="")&&($ZCONVERT(Group,"U")'[$ZCONVERT(group,"U"))
	.d OutputRowGetGroup
	
	k ^DHCEQTemp("GetGroup",$J)
	*/
	Quit $$$OK
    
OutputRowGetGroup
	set Data=$lb(groupdr,group)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-27 zc0027
/// 描述：添加输出列opt
/// d ##class(%ResultSet).RunQuery("web.DHCEQCManageLimit","GetManageLimitListinfo","7","1","")
Query GetManageLimitListinfo(ManageLimitDR As %String = "", Type As %String = "", Group As %String = "") As %Query(ROWSPEC = "rowid:%String,invalidFlag:%String,valuedr:%String,value:%String,managelimitdr:%String,typedr:%String,opt:%String")
{
}

ClassMethod GetManageLimitListinfoExecute(ByRef qHandle As %Binary, ManageLimitDR As %String = "", Type As %String = "", Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if Type="1"
	{
		s erowid=0
		s mrowid=0
		f  s erowid=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",Group,erowid))  quit:erowid=""  d
		.d ResetVariablesManageLimitListinfo
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",4)
		.q:invalidFlag="Y"
		.s valuedr=erowid
		.s value=$p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",2)
		.s managelimitdr=ManageLimitDR
		.s typedr=1
		.f  s mrowid=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"Value",valuedr,mrowid))  quit:mrowid=""  d
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",2)'=1)
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",1)'=ManageLimitDR)
		..s rowid=mrowid
		.i rowid'="" d
		..s opt="Y"
		.e  d
		..s opt="N"
		.d OutputRowManageLimitListinfo
	}
	if Type="2"
	{
		s equipinfo=..Chanage(##Class(web.DHCEQCommon).GetEquipTypesByGroup(Group))
		s csrowid=0
		s mrowid=0
		f  s csrowid=$o(^DHCEQCCode("DHCEQCStatCat",csrowid)) q:csrowid=""  d
		.d ResetVariablesManageLimitListinfo
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",4)
		.q:invalidFlag="Y"
		.q:(0=(##Class(web.DHCEQCommon).Find(equipinfo,$e($p($p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1),"-",1),2,$l($p($p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1),"-",1))),"Y")))
		.s valuedr=csrowid
		.s value=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",2)
		.s managelimitdr=ManageLimitDR
		.s typedr=2
		.f  s mrowid=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"Value",valuedr,mrowid))  quit:mrowid=""  d
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",2)'=2)
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",1)'=ManageLimitDR)
		..s rowid=mrowid
		.i rowid'="" d
		..s opt="Y"
		.e  d
		..s opt="N"
		.d OutputRowManageLimitListinfo
	}
	Quit $$$OK
OutputRowManageLimitListinfo
	set Data=$lb(rowid,invalidFlag,valuedr,value,managelimitdr,typedr,opt)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesManageLimitListinfo
	Set (rowid,invalidFlag,valuedr,value,managelimitdr,typedr,opt)=""
	Quit
}

ClassMethod GetManageLimitListinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManageLimitListinfoExecute ]
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

ClassMethod GetManageLimitListinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManageLimitListinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQCManageLimit).SaveManageLimitListinfo("","","") 
ClassMethod SaveManageLimitListinfo(ManageLimitDR As %String, Type As %String, Value As %String)
{
	k PLIST
	s PLIST(2)=ManageLimitDR
	s PLIST(3)=Type
	s PLIST(4)=Value
	&SQL(Insert into sqluser.DHC_EQCManageLimitList Values :PLIST())
	if SQLCODE  q "更新失败"
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod DeleteManageLimitListinfo(ManageLimitDR As %String, Type As %String)
{
	i (ManageLimitDR'="")&&(Type'="")
	{ &SQL(delete from sqluser.DHC_EQCManageLimitList where MLL_ManageLimitDR=:ManageLimitDR and MLL_Type=:Type) }
	q 0
}

/// Modefied by zc 2015-07-27 zc0027
/// 描述：新增保存方法
ClassMethod SaveData(PTData)
{
	k PLIST
	s PLIST(1)=$p($G(PTData),"^",1)
	s PLIST(2)=$p($G(PTData),"^",2)
	s PLIST(3)=$p($G(PTData),"^",3)
	s PLIST(4)=$p($G(PTData),"^",4)
	s PLIST(5)=$p($G(PTData),"^",5)
	i (PLIST(1)="")
	{ 
		i (PLIST(5)="N") 
		{	
			q ""
		}
		else
		{
			//k PList(1)
			//注意提交后要刷新
			&SQL(insert into sqluser.DHC_EQCManageLimitList values :PLIST())
		}
	}
	else
	{
		i (PLIST(5)="N") 
		{
			s mllrowid=PLIST(1)
			&SQL(delete from SQLUser.DHC_EQCManageLimitList  where MLL_RowID=:mllrowid)
		}
		else 
		{
			s mllrowid=PLIST(1)
			&SQL(update  SQLUser.DHC_EQCManageLimitList Values :PLIST() where MLL_RowID=:mllrowid)
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

/// add by zy 2015-10-19 
/// 获取当前权限下的管理人员信息
/// 参数说明:Type  ：1,2,3,4:,类组,类型,分类,科室
///          GroupID  ：安全组ID
///          RoleID   ：角色
///          Value    ：当前权限的内容
/// 返回值  :UseIDs  :用逗号分割："1,2,3"
/// w ##Class(web.DHCEQCManageLimit).GetUserByValue(4,"238","",3)
ClassMethod GetUserByValue(Type, GroupID, RoleID, Value)
{
	i Value="" quit ""
	new MLLRowID,MLRowID,UserID,EquipType,TERowID,UserID,UserIDs
	s UserIDs=""
	//if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s MLLRowID=0
	f  s MLLRowID=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"Value",Value,MLLRowID)) quit:MLLRowID=""  d
	.quit:$p($g(^DHCEQCCode("DHCEQCManageLimitList",MLLRowID)),"^",2)'=Type
	.s MLRowID=$p($g(^DHCEQCCode("DHCEQCManageLimitList",MLLRowID)),"^",1)
	.quit:(GroupID'="")&&($p($g(^DHCEQCCode("DHCEQCManageLimit",MLRowID)),"^",2)'=GroupID)
	.quit:(RoleID'="")&&(RoleID'=$p($g(^DHCEQCCode("DHCEQCManageLimit",MLRowID)),"^",3))
	.s UserID=$p($g(^DHCEQCCode("DHCEQCManageLimit",MLRowID)),"^",1)
	.i UserIDs=""  d
	..s UserIDs=UserID
	.e  d
	..s UserIDs=UserIDs_","_UserID
	
	quit UserIDs
}

/// add by zy 2015-10-19 
/// 获取人员信息
/// 参数说明:UseIDs  :用逗号分割："1,2,3"
///          EmployeeTypeType  ：04是维修工程师
/// 返回值  :在员工类型定义中取了人员的电话 接收短信的电话,多个电话中间用逗号分割："13607197924,15895677509"
/// w ##Class(web.DHCEQCManageLimit).GetUserInfo(13053,"04")
ClassMethod GetUserInfo(UseIDs, EmployeeType)
{
	new Len,i,UseID,TEmployeeType,TERowID,Phone,Phones
	s Phones=""
	s Len=$l(UseIDs,",")
	f i=1:1:Len  d
	.s UseID=$p(UseIDs,",",i)
	.s TEmployeeType=0
	.f  s TEmployeeType=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EmployeeType",TEmployeeType)) quit:TEmployeeType=""  d
	..quit:$p($g(^DHCEQCCode("DHCEQCEmployeeType",TEmployeeType)),"^",1)'=EmployeeType
	..s TERowID=0
	..f  s TERowID=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EmployeeType",TEmployeeType,TERowID)) quit:TERowID=""  d
	...quit:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",TERowID)),"^",4)="Y"
	...quit:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",TERowID)),"^",2)'=UseID
	...s Phone=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",TERowID)),"^",5)
	...i Phones=""  d
	....s Phones=Phone
	...e  d
	....s Phones=Phones_","_Phone
	
	quit Phones
}

/// add by zy 2015-12-03
/// 判断当前数据是否是在这个用户的管理权限范围内
/// 入参: User ,GroupID  	当前的会话变量
/// 			vEquipType,vStatCat,vEquiCat,vLoc ,需要判断的数据：类组,类型,分类,科室
/// 返回值 flag  0  不再权限范围内,1 在权限内
/// w ##Class(web.DHCEQCManageLimit).IsInManageLimit("1","217","","","","53")
ClassMethod IsInManageLimit(User, GroupID, vEquipType, vStatCat, vEquipCat, vLoc)
{
	new RoleIDs,RoleDR,rowid,DataList,tmpType,tmpValue,value,flag
	s flag=0
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	i RoleIDs="" quit flag
	i RoleIDs'="" s RoleIDs=","_RoleIDs_","
	i '$Data(^DHCEQCCode("DHCEQCManageLimit",0,"User",User)) quit flag
	i '$Data(^DHCEQCCode("DHCEQCManageLimit",0,"User",User,GroupID)) quit flag
	s RoleDR=0
	f  s RoleDR=$o(^DHCEQCCode("DHCEQCManageLimit",0,"User",User,GroupID,RoleDR)) q:(RoleDR="")||(flag=1)  d
	.q:(RoleIDs'="")&&(RoleIDs'[(","_RoleDR_","))
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCManageLimit",0,"User",User,GroupID,RoleDR,rowid)) q:(rowid="")||(flag=1)  d
	..s DataList=$g(^DHCEQCCode("DHCEQCManageLimit",rowid))
	..s (counter,fixcounter)=0
	..i (vEquipType'="")&&($p(DataList,"^",4)="Y")  d
	...s tmpType="1"
	...s tmpValue=vEquipType
	...d CompareValue
	..i (vStatCat'="")&&($p(DataList,"^",5)="Y")  d
	...s tmpType="2"
	...s tmpValue=vStatCat
	...d CompareValue
	...s counter=counter+1
	...s fixcounter=fixcounter+fixflag
	..i (vEquipCat'="")&&($p(DataList,"^",6)="Y")  d
	...s tmpType="3"
	...s tmpValue=vEquipCat
	...d CompareValue
	..i (vLoc'="")&&($p(DataList,"^",7)="Y")  d
	...s tmpType="4"
	...s tmpValue=vLoc
	...d CompareValue
	..//两个计数器一致且不=0的时候,说明在权限范围内
	..i (counter>0)&&(counter=fixcounter) s flag=1
	
	quit flag
	
CompareValue
	///fixflag=0是没有对应权限,tmpflag=1有权限
	s fixflag=0
	i '$Data(^DHCEQCCode("DHCEQCManageLimitList",0,"LimitValue",rowid,tmpType)) q flag
	s value=0
	f  s value=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"LimitValue",rowid,tmpType,value)) q:(value="")||(flag=1)  d
	.i tmpValue=value s fixflag=1
	s counter=counter+1
	s fixcounter=fixcounter+fixflag
	q
}

}
