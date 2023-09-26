Class web.DHCEQ.Plat.CTManageLimit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetManageLimit(User As %String = "", Group As %String = "", Role As %String = "") As %Query(ROWSPEC = "TRowID:%String,TUserDR:%String,TUser:%String,TGroupDR:%String,TGroup:%String,TRoleDR:%String,TRole:%String,TEquipTypeFlag:%String,TStatCatFlag:%String,TEquipCatFlag:%String,TLocFlag:%String,TEquipFlag:%String,TItemFlag:%String")
{
}

ClassMethod GetManageLimitExecute(ByRef qHandle As %Binary, User As %String = "", Group As %String = "", Role As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	k ^DHCEQTemp("GetManageLimit",$j)
	Set userdr=0
	For  Set userdr=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr)) Quit:userdr=""  Do
	.Quit:(User'="")&&(userdr'=User)
	.Set initials=+$Piece($Get(^DHCEQCCode("DHCEQCUser",userdr)),"^",1)
	.Set user=##class(web.DHCEQCommon).GetTrakNameByID("user",userdr)
	.Set groupdr=0
	.For  Set groupdr=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr,groupdr)) Quit:groupdr=""  Do
	..Quit:(Group'="")&&(groupdr'=Group)
	..Set group=$Piece($Get(^SSU("SSGRP",groupdr)),"^",1)
	..Set roledr=""
	..For  Set roledr=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr,groupdr,roledr)) Quit:roledr=""  Do
	...Quit:(Role'="")&&(roledr'=Role)
	...Quit:$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",4)="Y"
	...Set role=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",2)
	...s ^DHCEQTemp("GetManageLimit",$j,initials,userdr,groupdr,roledr)=""	;按姓名首拼进行排序
	
	///输出
	Set initials=""
	For  Set initials=$Order(^DHCEQTemp("GetManageLimit",$j,initials)) Quit:initials=""  Do
	.Do ResetVariablesGetManageLimit
	.Set userdr=""
	.For  Set userdr=$Order(^DHCEQTemp("GetManageLimit",$j,initials,userdr)) Quit:userdr=""  Do
	..Set TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",userdr)
	..Set groupdr=""
	..For  Set groupdr=$Order(^DHCEQTemp("GetManageLimit",$j,initials,userdr,groupdr)) Quit:groupdr=""  Do
	...Set TGroup=$Piece($Get(^SSU("SSGRP",groupdr)),"^",1)
	...Set roledr=""
	...For  Set roledr=$Order(^DHCEQTemp("GetManageLimit",$j,initials,userdr,groupdr,roledr)) Quit:roledr=""  Do
	....Set TRole=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",roledr)),"^",2)
	....Set mlrowid=""
	....For  Set mlrowid=$Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",userdr,groupdr,roledr,mlrowid)) Quit:mlrowid=""  Do
	.....s TRowID=mlrowid
	.....s TUserDR=userdr
	.....s TGroupDR=groupdr
	.....s TRoleDR=roledr
	.....Set TEquipTypeFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",4)
	.....Set TStatCatFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",5)
	.....Set TEquipCatFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",6)
	.....Set TLocFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",7)
	.....Set TEquipFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",8)
	.....Set TItemFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",9)
	.....Do OutputRowManageLimit
	k ^DHCEQTemp("GetManageLimit",$j)
	Quit $$$OK
OutputRowManageLimit
	set Data=$lb(TRowID,TUserDR,TUser,TGroupDR,TGroup,TRoleDR,TRole,TEquipTypeFlag,TStatCatFlag,TEquipCatFlag,TLocFlag,TEquipFlag,TItemFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetManageLimit
	Set (TRowID,TUserDR,TUser,TGroupDR,TGroup,TRoleDR,TRole,TEquipTypeFlag,TStatCatFlag,TEquipCatFlag,TLocFlag,TEquipFlag,TItemFlag)=""
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

ClassMethod SaveManageLimit(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		&SQL(delete from  sqluser.DHC_EQCManageLimitList where MLL_ManageLimitDR = :rowid)
		&SQL(delete from  sqluser.DHC_EQCManageLimit where ML_RowID = :rowid)
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)

	s tmpid=""
	&SQL(select ML_RowID into :tmpid from sqluser.DHC_EQCManageLimit where ML_UserDR=:PLIST(2) and ML_GroupDR=:PLIST(3) and ML_RoleDR=:PLIST(4))
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQCManageLimit Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQCManageLimit Values :PLIST() where ML_RowID = :rowid)
	}
	if SQLCODE  q -3001
	Set ID=$g(%ROWID)
	q ID
}

ClassMethod GetOneManageLimit(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCManageLimit",rowid)
	s resultex=resultex_"^"	
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",1))
	s resultex=resultex_"^"	
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("grp",$p(result,"^",2))
	s resultex=resultex_"^"	
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",3))),"^",2) 
	s resultex=resultex_"^"	
	q result_resultex
}

/// Modefied by zc 2015-07-27 zc0027
/// 描述：添加输出列opt
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTManageLimit","GetManageLimitListinfo","1","1","85")
Query GetManageLimitListinfo(ManageLimitDR As %String = "", Type As %String = "", Group As %String = "") As %Query(ROWSPEC = "TRowID:%String,TValue:%String,TValueDR:%String,TManageLimitDR:%String,TTypeDR:%String,opt:%String")
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
		.q:$p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",4)="Y"
		.s TValueDR=erowid
		.s TValue=$p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",2)
		.s TManageLimitDR=ManageLimitDR
		.s TTypeDR=1
		.f  s mrowid=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"Value",TValueDR,mrowid))  quit:mrowid=""  d
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",2)'=1)
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",1)'=ManageLimitDR)
		..s TRowID=mrowid
		.i TRowID'="" d
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
		.q:$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",4)="Y"
		.;q:(0=(##Class(web.DHCEQCommon).Find(equipinfo,$e($p($p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1),"-",1),2,$l($p($p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1),"-",1))),"Y")))
        .q:(0=(##Class(web.DHCEQCommon).Find(equipinfo,$e($p($p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1),"-",1),2,2),"Y")))  ;modified by kdf 2019-07-23 需求号：958795 修正判断
		.s TValueDR=csrowid
		.s TValue=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",2)
		.s TManageLimitDR=ManageLimitDR
		.s TTypeDR=2
		.f  s mrowid=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"Value",TValueDR,mrowid))  quit:mrowid=""  d
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",2)'=2)
		..q:($p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",1)'=ManageLimitDR)
		..s TRowID=mrowid
		.i TRowID'="" d
		..s opt="Y"
		.e  d
		..s opt="N"
		.d OutputRowManageLimitListinfo
	}
	Quit $$$OK
OutputRowManageLimitListinfo
	set Data=$lb(TRowID,TValue,TValueDR,TManageLimitDR,TTypeDR,opt)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesManageLimitListinfo
	Set (TRowID,TValue,TValueDR,TManageLimitDR,TTypeDR,opt)=""
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

/// Modefied by zc 2015-07-13 zc0027
/// 描述：根据类型来控制内容的显示
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTManageLimit","GetLimitValue","4","")
Query GetLimitValue(Type As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCode:%String")
{
}

ClassMethod GetLimitValueExecute(ByRef qHandle As %Binary, Type As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s group=%session.Get("LOGON.GROUPID")
	;s User=%session.Get("LOGON.USERID")
	if Type="1"
	{
		s EquipTypeDR=""
		f  s EquipTypeDR=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",group,EquipTypeDR))  quit:EquipTypeDR=""  d
		.d ResetVariablesGetLimitValue
		.q:$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",4)="Y"
		.s TName=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
		.q:(Desc'="")&&(TName'[Desc)
		.s TCode=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1)
		.s TRowID=EquipTypeDR
		.d OutputRowValue
	}
	if Type="2"
	{
		s equipinfo=..Chanage(##Class(web.DHCEQCommon).GetEquipTypesByGroup(group))
		s csrowid=0
		f  s csrowid=$o(^DHCEQCCode("DHCEQCStatCat",csrowid)) q:csrowid=""  d
		.d ResetVariablesGetLimitValue
		.q:$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",4)="Y"
		.s TName=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1)
		.s TName=$e($p(TName,"-",1),2,$l($p(TName,"-",1)))
		.q:(0=(##Class(web.DHCEQCommon).Find(equipinfo,TName,"N")))
		.s TName=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",2)
		.s TCode=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1)
		.q:(Desc'="")&&(TName'[Desc)&&(TCode'[Desc)		//Add By DJ 2017-02-17
		.s TRowID=csrowid
		.d OutputRowValue
	}
	if Type="3"
	{
		s cerowid=0
		f  s cerowid=$o(^DHCEQCCode("DHCEQCEquipeCat",cerowid)) q:cerowid=""  d
		.d ResetVariablesGetLimitValue
		.q:$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",7)="Y"
		.s TName=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",2)
		.s TCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",1)
		.q:(Desc'="")&&(TName'[Desc)&&(TCode'[Desc)			//Add By DJ 2017-02-17
		.s TRowID=cerowid
		.d OutputRowValue
	}
	if Type="4"
	{
		/*  //modify by jyp 2019-10-18 CTLOC调整
		s crowid=0
		f  s crowid=$o(^CTLOC(crowid)) q:crowid=""  d
		.d ResetVariablesGetLimitValue
		.;s TInvalidFlag=$p($g(^CTLOC(crowid)),"^",10)
		.;q:'$d(^DHCEQEquip("0","UseLoc",crowid))	;过滤台账无设备的科室
		.s TName=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(crowid)),"^",2),"-")
		.s TCode=$p($g(^CTLOC(crowid)),"^",1)
		.q:(Desc'="")&&(TName'[Desc)&&(TCode'[Desc)		//Add By DJ 2017-02-17
		.s TRowID=crowid
		.d OutputRowValue
		*/  //modify by jyp 2019-10-18 CTLOC调整
		s crowid=0
		f  s crowid=$o(^DHCEQCCode("DHCEQCDepartment",crowid)) q:crowid=""  d
		.d ResetVariablesGetLimitValue
		.;s TInvalidFlag=$p($g(^CTLOC(crowid)),"^",10)
		.;q:'$d(^DHCEQEquip("0","UseLoc",crowid))	;过滤台账无设备的科室
		.s TName=##class(web.DHCEQCommon).GetTrakNameByID("dept",crowid)
		.s TCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",crowid)
		.q:(Desc'="")&&(TName'[Desc)&&(TCode'[Desc)		//Add By DJ 2017-02-17
		.s TRowID=crowid
		.d OutputRowValue
	}
	if Type="5"
	{
		s eqrowid=0
		f  s eqrowid=$o(^DHCEQEquip(eqrowid)) q:eqrowid=""  d
		.d ResetVariablesGetLimitValue
		.q:$p($g(^DHCEQEquip(eqrowid)),"^",59)="Y"
		.s TName=$p($g(^DHCEQEquip(eqrowid)),"^",1)
		.s TName=TName_","_$p($g(^DHCEQEquip(eqrowid)),"^",6)
		.s TName=TName_","_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(eqrowid)),"^",19))
		.s TCode=$p($g(^DHCEQEquip(eqrowid)),"^",71)_","_$p($g(^DHCEQEquip(eqrowid)),"^",85)
		.q:(Desc'="")&&($ZCONVERT(TName,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Desc,"U"))		//Add By DJ 2017-02-17
		.s TRowID=eqrowid
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
		..q:$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",8)="Y"
		..s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",1)
		..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",2)
		..q:(Desc'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Desc,"U")))
		..s TRowID=ItemID
		..d OutputRowValue
	}
	Quit $$$OK
OutputRowValue
	set Data=$lb(TRowID,TName,TCode)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLimitValue
	Set (TRowID,TName,TCode)=""
	Quit
}

ClassMethod GetLimitValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLimitValueExecute ]
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

ClassMethod GetLimitValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLimitValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-13 zc0027
/// 描述：根据类型来区分不同的控制类型的输出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTManageLimit","GetManageLimitList","1","4","")
Query GetManageLimitList(ManageLimitDR As %String = "", Type As %String = "", Value As %String = "") As %Query(ROWSPEC = "TRowID:%String,TTypeDR:%String,TType:%String,TValueDR:%String,TValue:%String,TAccessflag:%String")
{
}

ClassMethod GetManageLimitListExecute(ByRef qHandle As %Binary, ManageLimitDR As %String = "", Type As %String = "", Value As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i ManageLimitDR="" Quit $$$OK 
	s index=1
	s mrowid=0
	f  s mrowid=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"LimitDR",ManageLimitDR,mrowid))  quit:mrowid=""  d
	.d ResetVariablesGetManageLimitList
	.s TRowID=mrowid
	.s TTypeDR=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",2)
	.q:TTypeDR'=Type
	.s TType=$CASE(TTypeDR,"":"","1":"类组","2":"类型","3":"分类","4":"科室","5":"设备","6":"设备项")
	.s TAccessflag=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",4)
	.s TValueDR=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",3)
	.q:(Value'="")&&(TValueDR'=Value)
	.i TTypeDR=1 d
	..q:$p($g(^DHCEQCCode("DHCEQCEquipType",TValueDR)),"^",4)="Y"
	..s TValue=$p($g(^DHCEQCCode("DHCEQCEquipType",TValueDR)),"^",2)
	..d OutputRowManageLimitList
	.e  i TTypeDR=2 d
	..q:$p($g(^DHCEQCCode("DHCEQCStatCat",TValueDR)),"^",4)="Y"
	..s TValue=$p($g(^DHCEQCCode("DHCEQCStatCat",TValueDR)),"^",2)
	..d OutputRowManageLimitList
	.e  i TTypeDR=3 d
	..q:$p($g(^DHCEQCCode("DHCEQCEquipeCat",TValueDR)),"^",7)="Y"
	..s TValue=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TValueDR)),"^",2)
	..d OutputRowManageLimitList
	.e  i TTypeDR=4 d
	..;s TValue=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(TValueDR)),"^",2),"-")	//Modefied by zc 2015-07-13 zc0027 end   //modify by jyp 2019-10-18 CTLOC调整
	..s TValue=##class(web.DHCEQCommon).GetTrakNameByID("dept",TValueDR)   //modify by jyp 2019-10-18 CTLOC调整
	..d OutputRowManageLimitList
	.e  i TTypeDR=5 d
	..s TValue=$p($g(^DHCEQEquip(TValueDR)),"^",71)_","_$p($g(^DHCEQEquip(TValueDR)),"^",85)_","_$p($g(^DHCEQEquip(TValueDR)),"^",1)
	..s TValue=TValue_","_$p($g(^DHCEQEquip(TValueDR)),"^",6)
	..s TValue=TValue_","_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(TValueDR)),"^",19))
	..d OutputRowManageLimitList
	.e  i TTypeDR=6 d
	..q:$p($g(^DHCEQCCode("DHCEQCMasterItem",TValueDR)),"^",8)="Y"
	..s TValue=$p($g(^DHCEQCCode("DHCEQCMasterItem",TValueDR)),"^",1)
	..d OutputRowManageLimitList
	Quit $$$OK
OutputRowManageLimitList
	set Data=$lb(TRowID,TTypeDR,TType,TValueDR,TValue,TAccessflag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetManageLimitList
	Set (TRowID,TTypeDR,TType,TValueDR,TValue,TAccessflag)=""
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

/// Modefied by zc 2015-07-27 zc0027
/// 描述：新增与更新分开，此部分为更新
ClassMethod SaveManageLimitList(RowId As %String, ManageLimitDR As %String, Type As %String, Value As %String, AccessFlag As %String = "")
{
	k PLIST,rowid
	s rowid=RowId
	s PLIST(2)=ManageLimitDR
	s PLIST(3)=Type
	s PLIST(4)=Value
	s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage(AccessFlag,"bool")
	s tmpid=""
	&SQL(select MLL_RowID into :tmpid from sqluser.DHC_EQCManageLimitList where MLL_ManageLimitDR=:ManageLimitDR and MLL_Type=:Type and MLL_Value=:Value)
	if ((tmpid'="")&&(tmpid'=rowid)) q "数据有重复"	;重复记录
	&SQL(Update sqluser.DHC_EQCManageLimitList Values :PLIST() where MLL_RowID = :rowid)
	q SQLCODE
}

/// w ##Class(web.DHCEQ.Plat.CManageLimit).AddManageLimitList("1","4","3") 
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

/// w ##Class(web.DHCEQCManageLimit).SaveManageLimitListinfo("","","") 
ClassMethod SaveManageLimitListinfo(ManageLimitDR As %String, Type As %String, IDs As %String)
{
	s SQLCODE=0
	&SQL(delete from  sqluser.DHC_EQCManageLimitList where MLL_ManageLimitDR=:ManageLimitDR and MLL_Type=:Type)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE q SQLCODE
	new Length,i
	s Length=$l(IDs,",")
	for i=1:1:Length
	{
		k PLIST
		s PLIST(2)=ManageLimitDR
		s PLIST(3)=Type
		s PLIST(4)=$p(IDs,",",i)
		s PLIST(5)="Y"
		&SQL(insert into sqluser.DHC_EQCManageLimitList values :PLIST())
		q:SQLCODE'=0
	}
	q SQLCODE
}

// Add By QW20210129 BUG:QW0090

// w ##Class(web.DHCEQ.Plat.CTManageLimit).CopyManageLimitList("3","1")

ClassMethod CopyManageLimitList(rowid As %Library.String = "", MLLManageLimitDR As %Library.String = "")
{
	if (MLLManageLimitDR="")||(rowid="") quit -3001
	Set EquipTypeFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",rowid)),"^",4)
	Set StatCatFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",rowid)),"^",5)
	Set EquipCatFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",rowid)),"^",6)
	Set LocFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",rowid)),"^",7)
	Set EquipFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",rowid)),"^",8)
	Set ItemFlag=$Piece($Get(^DHCEQCCode("DHCEQCManageLimit",rowid)),"^",9)
	s SQLCODE=0
	i (EquipTypeFlag="Y")
	{ 
		s num=0
		&SQL(SELECT count(MLL_RowID) into :num FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='1')
		if num'=0
		{
			&SQL(INSERT INTO sqluser.DHC_EQCManageLimitList (MLL_ManageLimitDR,MLL_Type,MLL_Value,MLL_AccessFlag)  SELECT :rowid,MLL_Type,MLL_Value,MLL_AccessFlag FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='1')
			if SQLCODE  q -3001
		}
	}
	i (StatCatFlag="Y")
	{ 
		s num=0
		&SQL(SELECT count(MLL_RowID) into :num FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='2')
		if num'=0
		{
			&SQL(INSERT INTO sqluser.DHC_EQCManageLimitList (MLL_ManageLimitDR,MLL_Type,MLL_Value,MLL_AccessFlag)  SELECT :rowid,MLL_Type,MLL_Value,MLL_AccessFlag FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='2')
			if SQLCODE  q -3001
		}
	}
	i (EquipCatFlag="Y")
	{ 
		s num=0
		&SQL(SELECT count(MLL_RowID) into :num FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='3')
		if num'=0
		{
			&SQL(INSERT INTO sqluser.DHC_EQCManageLimitList (MLL_ManageLimitDR,MLL_Type,MLL_Value,MLL_AccessFlag)  SELECT :rowid,MLL_Type,MLL_Value,MLL_AccessFlag FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='3')
			if SQLCODE  q -3001
		}
	}
	i (LocFlag="Y")
	{ 
		s num=0
		&SQL(SELECT count(MLL_RowID) into :num FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='4')
		if num'=0
		{
			&SQL(INSERT INTO sqluser.DHC_EQCManageLimitList (MLL_ManageLimitDR,MLL_Type,MLL_Value,MLL_AccessFlag)  SELECT :rowid,MLL_Type,MLL_Value,MLL_AccessFlag FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='4')
			if SQLCODE  q -3001
		}
	}
	i (EquipFlag="Y")
	{ 
		s num=0
		&SQL(SELECT count(MLL_RowID) into :num FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='5')
		if num'=0
		{
			&SQL(INSERT INTO sqluser.DHC_EQCManageLimitList (MLL_ManageLimitDR,MLL_Type,MLL_Value,MLL_AccessFlag)  SELECT :rowid,MLL_Type,MLL_Value,MLL_AccessFlag FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='5')
			if SQLCODE  q -3001
		}
	}
	i (ItemFlag="Y")
	{ 
		s num=0
		&SQL(SELECT count(MLL_RowID) into :num FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='6')
		if num'=0
		{
			&SQL(INSERT INTO sqluser.DHC_EQCManageLimitList (MLL_ManageLimitDR,MLL_Type,MLL_Value,MLL_AccessFlag)  SELECT :rowid,MLL_Type,MLL_Value,MLL_AccessFlag FROM sqluser.DHC_EQCManageLimitList WHERE MLL_ManageLimitDR=:MLLManageLimitDR AND MLL_Type='6')
			if SQLCODE  q -3001
		}
	}
	Q rowid
}

}
