Import SQLUser

/// 名称: web.DHCEQ.Plat.LIBFind
/// 描述: 各系统模块通用业务查询
/// 编写者：LMM
/// 编写日期: 2018-09-17
/// 产品组：设备管理
Class web.DHCEQ.Plat.LIBFind Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Mozy	972115	2019-8-1	修正员工类型定义取值错误
/// 描述：hisui改造 查询人员
/// 入参：type:设备员工类型代码
///       name：员工姓名或工号
///       loc：员工所在科室
///       equiptype：员工可查看类组
///       manageloc：员工指定科室
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","EQUser","01","","","","")
/// modify by lmm 2018-09-17 增加出参 TUserLocDR：默认科室id  TUserLoc：默认科室 THospitalDR：医院id THospital：医院
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
/// Modified By QW20211224 增加联系电话 TMobilePhone:%String:联系电话
Query EQUser(Type As %String, Name As %String = "", Loc As %String = "", Equiptype As %String = "", Manageloc As %String = "") As %Query(ROWSPEC = "TName:%String:姓名,TRowID:%String,TInitials:%String:首字母,TUserLocDR:%String,TUserLoc:%String:使用科室,THospitalDR:%String,THospital:%String:院区,TMobilePhone:%String:联系电话")
{
}

ClassMethod EQUserExecute(ByRef qHandle As %Binary, Type As %String, Name As %String = "", Loc As %String = "", Equiptype As %String = "", Manageloc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","")	//CZF0138 2021-05-26
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	
 	s rowid=0
 	s Name=$ZCONVERT(Name,"U")
 	if (Type'="")||(Equiptype'="")
 	{
	 	s userid=0
		if (Type'="")
		{
			s typeid=##Class(web.DHCEQCommon).GetStandardIDByCode("DHCEQCEmployeeType",Type)
			i Type="" s id="" Quit $$$OK
		 	if Equiptype'=""
		 	{
			 	f  s userid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EquipType",typeid,Equiptype,userid)) q:userid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",3)="Y"
			 	.s rowid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",2)
			 	.d GetEQUserList
			}
		 	else
		 	{
			 	f  s userid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EmployeeType",typeid,userid)) q:userid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",3)="Y"
			 	.s rowid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",2)
			 	.d GetEQUserList
			}
		}
		else
		{
			f  s userid=$o(^DHCEQCCode("DHCEQCTypeEmployee",userid)) q:userid=""  d
			.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",3)="Y"
			.s userequiptype=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",5)
			.quit:(Equiptype'="")&&(Equiptype'=userequiptype)
			.s rowid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",2)
			.d GetEQUserList
		}
	}
 	else
 	{
	 	if Manageloc'=""
		{
			f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.s hisuserid=$p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",19)
		 	.i $p($g(^SSU("SSUSR",hisuserid)),"^",4)=Manageloc d
		 	..d GetEQUserList
		 	.s chl=0
		 	.f  s chl=$O(^SSU("SSUSR",hisuserid,"OTHLL",chl)) q:(chl="")  d
		    ..q:$P(^SSU("SSUSR",hisuserid,"OTHLL",chl),"^",2)'="86"	//是否在指定安全组内的用户  modified by wy 2022-8-29
		    ..;q:$P(^SSU("SSUSR",hisuserid,"OTHLL",chl),"^",1)'=Manageloc //有指定科室时,判断科室  modify by lmm 2018-10-25 
		    ..d GetEQUserList
		}
	 	else
	 	{
		 	f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.Do GetEQUserList
		}
 	}	
	Quit $$$OK
GetEQUserList
	s userdata=$g(^DHCEQCCode("DHCEQCUser",rowid))
	q:userdata=""
	q:($p(userdata,"^",31)="Y") //ADD by JYP 20181009
    q:($p(userdata,"^",20)="N") //add by wy 2023-4-12 3433917过滤未激活的人员和过期人员 begin
    s SSUserID= $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",19)
    s DateTo=$P($G(^SSU("SSUSR",SSUserID)),"^",97)
    q:(DateTo'="")&&(DateTo<+$H)  //add by wy 2023-4-12 3433917过滤未激活的人员和过期人员 end 
	s initials=$p(userdata,"^",1)
	s username=$p(userdata,"^",4)
	s usercode=$p(userdata,"^",3)  //add by zx 2019-05-31 增加代码检索
	i usercode="" s usercode=##class(web.DHCEQCHanZiEncoding).GetEncoding(username,4,"","U")		//czf 20210430
	s userlocid=$p(userdata,"^",14) //modify by JYP 20181009
	i userlocid'="" s userloc=##class(web.DHCEQCommon).GetTrakNameByID("dept",userlocid)
	q:(Loc'="")&&(userloc'=Loc)
	s OrganizeType=$p(userdata,"^",12)
	s OrganizeID=$p(userdata,"^",13)
	q:(HospFlag=2)&&(OrganizeType=1)&&(sHospID'="")&&(OrganizeID'=sHospID)	//CZF0138 2021-05-26
	//Modified By QW20211224 begin
	s (HospitalDR,Hospital,MobilePhone)="" 
	s MobilePhone=$p(userdata,"^",6)
	//Modified By QW20211224 end
	i OrganizeType="1" s HospitalDR=$p(userdata,"^",13)
	i HospitalDR'="" s Hospital=$p($g(^CT("HOSP",HospitalDR)),"^",2)
	quit:##Class(web.DHCEQCommon).HospitalIsInclude(userloc)=0
	q:(Name'="")&&($ZCONVERT(username,"U")'[Name)&&($ZCONVERT(initials,"U")'[Name)&&($ZCONVERT(usercode,"U")'[Name)       //&&($e(PYCode,1,$l(Name))'=Name)   //modify by lmm 2018-11-1 注释拼音码筛选
	d OutputRowEQUser
	quit
	
OutputRowEQUser
	set Data=$lb(username,rowid,initials,userlocid,userloc,HospitalDR,Hospital,MobilePhone)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod EQUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQUserExecute ]
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

ClassMethod EQUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by sjh SJH0041 2020-12-01 lookup组件调用人员query
Query EQUserComponent(Type As %String, Name As %String = "", Loc As %String = "", Equiptype As %String = "", Manageloc As %String = "") As %Query(ROWSPEC = "TName:%String:姓名,Hidden:%String,TInitials:%String:首字母,Hidden:%String,TUserLoc:%String:使用科室,Hidden:%String,THospital:%String:院区")
{
}

ClassMethod EQUserComponentExecute(ByRef qHandle As %Binary, Type As %String, Name As %String = "", Loc As %String = "", Equiptype As %String = "", Manageloc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	s rowid=0
 	s Name=$ZCONVERT(Name,"U")
 	if (Type'="")||(Equiptype'="")
 	{
	 	s userid=0
		if (Type'="")
		{
			s typeid=##Class(web.DHCEQCommon).GetStandardIDByCode("DHCEQCEmployeeType",Type)
			i Type="" s id="" Quit $$$OK
		 	if Equiptype'=""
		 	{
			 	f  s userid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EquipType",typeid,Equiptype,userid)) q:userid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",3)="Y"
			 	.s rowid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",2)
			 	.d GetEQUserListComponent
			}
		 	else
		 	{
			 	f  s userid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EmployeeType",typeid,userid)) q:userid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",3)="Y"
			 	.s rowid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",2)
			 	.d GetEQUserListComponent
			}
		}
		else
		{
			f  s userid=$o(^DHCEQCCode("DHCEQCTypeEmployee",userid)) q:userid=""  d
			.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",3)="Y"
			.s userequiptype=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",5)
			.quit:(Equiptype'="")&&(Equiptype'=userequiptype)
			.s rowid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",userid)),"^",2)
			.d GetEQUserListComponent
		}
	}
 	else
 	{
	 	if Manageloc'=""
		{
			f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.s hisuserid=$p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",19)
		 	.i $p($g(^SSU("SSUSR",hisuserid)),"^",4)=Manageloc d
		 	..d GetEQUserListComponent
		 	.s chl=0
		 	.f  s chl=$O(^SSU("SSUSR",hisuserid,"OTHLL",chl)) q:(chl="")  d
		    ..q:$P(^SSU("SSUSR",rowid,"OTHLL",chl),"^",2)'="86"	//是否在指定安全组内的用户
		    ..;q:$P(^SSU("SSUSR",hisuserid,"OTHLL",chl),"^",1)'=Manageloc //有指定科室时,判断科室  modify by lmm 2018-10-25 
		    ..d GetEQUserListComponent
		}
	 	else
	 	{
		 	f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.Do GetEQUserListComponent
		}
 	}	
	Quit $$$OK
GetEQUserListComponent
	s userdata=$g(^DHCEQCCode("DHCEQCUser",rowid))
	q:userdata=""
	q:($p(userdata,"^",31)="Y") //ADD by JYP 20181009
	s initials=$p(userdata,"^",1)
	s username=$p(userdata,"^",4)
	s usercode=$p(userdata,"^",3)  //add by zx 2019-05-31 增加代码检索
	s userlocid=$p(userdata,"^",14) //modify by JYP 20181009
	i userlocid'="" s userloc=##class(web.DHCEQCommon).GetTrakNameByID("dept",userlocid)
	q:(Loc'="")&&(userloc'=Loc)
	s OrganizeType=$p(userdata,"^",12)
	s (HospitalDR,Hospital)="" //ADD by JYP 20181010
	i OrganizeType="1" s HospitalDR=$p(userdata,"^",13)
	i HospitalDR'="" s Hospital=$p($g(^CT("HOSP",HospitalDR)),"^",2)
	quit:##Class(web.DHCEQCommon).HospitalIsInclude(userloc)=0
	q:(Name'="")&&($ZCONVERT(username,"U")'[Name)&&($ZCONVERT(initials,"U")'[Name)&&($ZCONVERT(usercode,"U")'[Name)       //&&($e(PYCode,1,$l(Name))'=Name)   //modify by lmm 2018-11-1 注释拼音码筛选
	d OutputRowEQUserComponent
	quit
	
OutputRowEQUserComponent
	set Data=$lb(username,rowid,initials,userlocid,userloc,HospitalDR,Hospital)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod EQUserComponentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQUserComponentExecute ]
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

ClassMethod EQUserComponentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserComponentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by lmm 2018-08-16
/// 描述：hisui改造 查询生产厂商
/// 入参：Name:生产厂商
/// modified by CZF0093 供应商、生产厂商、服务商三商合一
Query GetManuFacturer(Name As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetManuFacturerExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Name=##Class(web.DHCEQCommon).UnEscape(Name)
 	Set Name=$ZCONVERT(Name ,"U")
 	
	Set index=1
	Set FirmType=3
	
	Set rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid)) q:rowid=""  d	//modified by czf 20200404 begin
	.s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid,""))
	.q:FCRowid=""
	.q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"		 //modified by CZF0103 20200408
	.Do ResetGetManuFacturer
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)		//add by CZF00093 2020-03-17 公司类型
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.Quit:(Name'="")&&($ZCONVERT(TCode ,"U")'[Name)&&($ZCONVERT(TName ,"U")'[Name)
	.Do OutputGetManuFacturer
	Quit $$$OK
	/*
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCManufacturer",rowid)) Quit:rowid=""  Do
	.Do ResetGetManuFacturer
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",10)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",2)
	.Set TName=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1)
	.Quit:(Name'="")&&($ZCONVERT(TCode ,"U")'[Name)&&($ZCONVERT(TName ,"U")'[Name)
	.Do OutputGetManuFacturer
	*/
OutputGetManuFacturer
	Set Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetManuFacturer
	Set (TName,TRowID,TCode)=""
	Quit
}

ClassMethod GetManuFacturerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManuFacturerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetManuFacturerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManuFacturerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/*  Modified By QW20210512  BUG:QW0108
/// add by zc 2018-09-03
/// 描述：hisui改造 查询设备来源
/// 入参：Desc:来源描述
/// Modified By QW20210422  BUG:QW0098 增加入参EquipFlag,FacilityFlag
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetOrigin","","N","N")
Query GetOrigin(Desc, EquipFlag As %Library.String = "Y", FacilityFlag As %Library.String = "N") As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
	SELECT O_Desc,
		   O_RowID,
		   O_Code
	FROM sqluser.DHC_EQCOrigin
	where O_InvalidFlag = 'N' and O_Desc like nvl(:Desc,'')||'%' and O_EquipFlag=:EquipFlag and O_FacilityFlag=:FacilityFlag
}
*/
/// add by zc 2018-09-03
/// 描述：hisui改造 查询国别
/// 入参：Country:国别
Query GetCountry(Name) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetCountryExecute(ByRef qHandle As %Binary, Name) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Name=$ZCONVERT(Name,"U")	//2014-07-21 DJ0125 国别检索处理
	s rowid=0
	f  s rowid=$o(^CT("COU",rowid))  q:rowid=""  d
	.s Desc=$p($g(^CT("COU",rowid)),"^",2)
	.s Code=$p($g(^CT("COU",rowid)),"^",1)
	.q:(Name'="")&&($ZCONVERT(Desc,"U")'[Name)&&($ZCONVERT(Code,"U")'[Name)
	.d OutputRowGetCountry
    Quit $$$OK
OutputRowGetCountry
	s Desc=$p($g(^CT("COU",rowid)),"^",2)
	s Code=$p($g(^CT("COU",rowid)),"^",1)
	
	s Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetCountryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCountryExecute ]
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

ClassMethod GetCountryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCountryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zc 2018-09-03
/// 描述：hisui改造 查询设备单位
/// 入参：desc:单位  type:单位类型
Query GetUOM(Desc As %String, Type As %String) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetUOMExecute(ByRef qHandle As %Binary, Desc As %String, Type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCUOM","0","UOMType",Type,rowid)) q:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",5)="Y"  /// Modefied by zc0096 2021-01-21  无效过滤
	.s id=rowid				
	.s unitdesc=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",4)			
	.s unitcode=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",3)			
	.q:unitdesc'[Desc
 	.Do OutputRowGetGetUOM	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetGetUOM
	set Data=$lb(unitdesc,id,unitcode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetUOMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUOMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod GetUOMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUOMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zc 2018-09-03
/// 描述：hisui改造 查询设备来源
/// 入参：Desc:来源描述
Query GetBuyType(Desc) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT BT_Desc,
	   BT_RowID,
	   BT_Code
FROM sqluser.DHC_EQCBuyType
where BT_InvalidFlag = 'N' and BT_Desc like nvl(:Desc,'')||'%'
}

/// Creator：      ZX
/// CreatDate：    2018-09-02
/// Description:   设备用途LookUp所需Query
/// Table：        DHC_EQCExpenditures
/// Input：        Desc:用途描述
Query GetPurposeType(Desc) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT PT_Desc,
	   PT_RowID,
	   PT_Code
FROM sqluser.DHC_EQCPurposeType
where PT_InvalidFlag = 'N' and PT_Desc like nvl(:Desc,'')||'%'
}

/// Creator：      ZX
/// CreatDate：    2018-09-02
/// Description:   申购类别LookUp所需Query
/// Table：        DHC_EQCPurchaseType
/// Input：        Desc:申购类别描述
Query GetPurchaseType(Desc) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT PT_Desc,
	   PT_RowID,
	   PT_Code
FROM sqluser.DHC_EQCPurchaseType
where PT_InvalidFlag = 'N' and PT_Desc like nvl(:Desc,'')||'%'
}

/// 增加参数notUseFlag:限制是否显示无效科室，""不限制显示全部科室，"Y"不显示无效科室
/// -----------------------------
/// 修改：JDL 2010-7-30
/// LocType：参数为库房类型的关键字，库房类型代码。
/// 		 如：库房为0101，科室为0102，租赁中心为0301
/// -------------------------------
/// 修改：zy 2009-07-22   zy0007
/// 描述:设备入库管理中，库房要从属于库房这一类的科室中选择
/// 增加参数:LocType：科室类型代码
/// 备注:科室类型：1，库房；0，科室
/// modify by lmm 2019-08-06 972010 增加入参 ExportType 有值时不输出内容 
/// -------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetEQLoc","2","","","0102","")
/// Modified By QW20190823 需求号:979934 增加输出Thospital:%String:院区
/// Modified by czf 20200821 增加LinkLocID 被关联科室ID 1476453
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetEQLoc(Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "", ExportType As %Library.String = "", LinkLocID As %Library.String = "", ManageLocFlag As %Library.String = "") As %Query(ROWSPEC = "TName:%String:名称,TRowID:%String,TCode:%String:编码,TPYM:%String:拼音码,TTel:%String:电话,Thospital:%String:院区") [ SqlProc ]
{
}

ClassMethod GetEQLocExecute(ByRef qHandle As %Binary, Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "", ExportType As %Library.String = "", LinkLocID As %Library.String = "", ManageLocFlag As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	if ExportType'="" Quit $$$OK //add by lmm 2019-08-06 972010
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("",CurHosptailID)	//CZF0138 2021-05-26
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	
	s LocTypeID=""
	if LocType'=""     //科室类型
	{
		s LocTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code",LocType,0))
		if LocTypeID="" Quit $$$OK
	}	
	
	if (Type="0")||(Type="")  //所有科室
	{
		s IsLinkFlag=##Class(web.DHCEQCommon).GetSysInfo("992011")	//是否启用his关联科室  modified by czf 20200821 begin 1476453
		i (IsLinkFlag=1)&&(LinkLocID'="")
		{
			s ctlocid=$p($g(^DHCEQCCode("DHCEQCDepartment",LinkLocID)),"^",11)
			s ExType=$p($g(^DHCEQCCode("DHCEQCDepartment",LinkLocID)),"^",10)
			i (ExType=1)&&(ctlocid'="")
			{
				s linkctlocid=""
				f  s linkctlocid=$o(^CTLOC(ctlocid,"LINK",0,"Loc",linkctlocid)) q:linkctlocid=""  d
				.s locid=##Class(web.DHCEQCommon).getMapIDBySource("dept",linkctlocid)
				.d GetOneLoc
			}
		}
		else				//是否启用his关联科室  modified by czf 20200821 end
		{
			s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
			s LGTLocRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0102",0))
			//modify by lmm 2018-10-25 begin
			f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:rowid=""  d
			.s locid=rowid
			.s StoreFlag=""
			.s LocFlag=""
			.i LGTStoreRowID'="" s StoreFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,locid))
			.i LGTLocRowID'="" s LocFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTLocRowID,locid))
			.q:((CTLocAllFlag'="Y")&&(StoreFlag=0)&&(LocFlag=0))
			.d GetOneLoc
			
			//modify by lmm 2018-10-25 end
		}
	}
	if Type="1"  //安全组科室
	{
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		s StoreDR=0
		f  s StoreDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,StoreDR))  q:StoreDR=""  d
		.;modify by lmm 2018-10-25 begin
		.s (OrganizeType,StoreHospDR)=""
		.s OrganizeType=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreDR)),"^",7)   
		.i (OrganizeType=1) s StoreHospDR=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreDR)),"^",8) 
		.;modify by lmm 2018-10-25 begin
		.s GroupHospIDs=##Class(web.DHCEQCommon).GetHospIDSByGroup(vgroupid)
		.q:GroupHospIDs'[("^"_StoreHospDR_"^")
		.s locid=StoreDR
		.d GetOneLoc
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",StoreDR,locid)) q:(locid="")||(LocType="0101")  d
		..d GetOneLoc
		/*
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		f  s rowid=$o(^SSU("SSGRP",vgroupid,"ST",0,"Loc",rowid)) q:rowid=""  d
		.s locid=rowid
		.d GetOneLoc
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",rowid,locid)) q:(locid="")  d
		..d GetOneLoc
		*/
	}
	if Type="2" //本科室
	{
		s rowid=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		s locid=rowid
		d GetOneLoc
	}
	
	
	Quit $$$OK

GetOneLoc
	;当前登录人是否有权限查看表数据 CZF0138	
	s DeptOrganizeType = $p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",7)
	s DeptOrganizeID = $p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",8)
	q:(+HospFlag'=0)&&(DeptOrganizeType=1)&&(sHospID'="")&&(DeptOrganizeID'=sHospID)   //modify by lmm 2021-09-07
	
	s TIsManageLoc=""
	s ctLocTypeID=$o(^DHCEQCCode("DHCEQCLocType",0,"Loc",locid,""))	//czf 2023-03-27
	i ctLocTypeID'="" d
	.s TIsManageLoc=$p($g(^DHCEQCCode("DHCEQCLocType",ctLocTypeID)),"^",9)
	q:(ManageLocFlag="1")&&(TIsManageLoc'="1")		//取管理科室

	//add by zy 2015-04-09 ZY0125 分院区管理,通过科室的医院属性来管理
	s HIIFlag=1		//Add By DJ 2017-03-22
	i '((CurHosptailID=0)&&(LocType="0101"))  d		//转移单为库房调配时接收部门可选择所有库房
	.s HIIFlag=##Class(web.DHCEQCommon).HospitalIsInclude(locid,vgroupid,CurHosptailID)
	quit:HIIFlag=0
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit(UserID,vgroupid,"","","","",locid))
	q:(($p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",19))="Y")  //add by jyp 2019-01-11
	s code=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",1)
	s desc=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",2)
	///add by ZY0210 增加别名表中拼音码的检索
	s AText=""
	s ARowID=##Class(web.DHCEQ.Plat.CTAlias).GetAlias("DHCEQCDepartment",locid,"text","PYCode")
	i ARowID'="" s AText=$p($g(^DHCEQCCode("DHCEQCAlias",ARowID)),"^",1)	//czf 2022-03-255
	i AText="" s AText=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")			//czf 20210430
	
	s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",13)
	q:(notUseFlag'="")&&(NotUse="Y")
	s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",18)
	q:((notUseFlag'="")&&(+DATo'=0)&&(+DATo<+$H))
	s LocDesc=$ZCONVERT(LocDesc,"U")
	q:($ZCONVERT(desc,"U")'[LocDesc)&&($ZCONVERT(code,"U")'[LocDesc)&&($ZCONVERT(AText,"U")'[LocDesc)
	if LocTypeID'=""     //库房类型
	{
		if '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeID,locid)) q
	}
	;Modified By QW20190823 需求号:979934 获取院区信息
	s detail= ##Class(web.DHCEQCLocType).GetEQLocDetailByID("", "", locid)	;取科室类型表电话	//201702-04	Mozy
	s Thospital=$p(detail,"^",3)
	s tel=$p(detail,"^",17)
	;End By QW20190823 需求号:979934
	d OutputRowGetEQLoc

	quit
OutputRowGetEQLoc
	s TPYM=AText		//czf 20210430
	s TRowID=locid
	s TCode=code
	s TName=##class(web.DHCEQCommon).GetSplitDataByFlag(desc,"-")
	s TTel=tel
	s Data=$lb(TName,TRowID,TCode,TPYM,TTel,Thospital) ;Modified By QW20190823 需求号:979934 增加输出Thospital
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

/// add by sjh SJH0041 2020-12-01 lookup组件调用科室query
Query GetEQLocComponent(Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "", ExportType As %Library.String = "", LinkLocID As %Library.String = "") As %Query(ROWSPEC = "TName:%String:名称,HIDDEN:%String,TCode:%String:编码,TPYM:%String:拼音码,TTel:%String:电话,Thospital:%String:院区") [ SqlProc ]
{
}

ClassMethod GetEQLocComponentExecute(ByRef qHandle As %Binary, Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "", ExportType As %Library.String = "", LinkLocID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	if ExportType'="" Quit $$$OK //add by lmm 2019-08-06 972010
	
	s LocTypeID=""
	if LocType'=""     //科室类型
	{
		s LocTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code",LocType,0))
		if LocTypeID="" Quit $$$OK
	}	
	
	if (Type="0")||(Type="")  //所有科室
	{
		s IsLinkFlag=##Class(web.DHCEQCommon).GetSysInfo("992011")	//是否启用his关联科室  modified by czf 20200821 begin 1476453
		i (IsLinkFlag=1)&&(LinkLocID'="")
		{
			s ctlocid=$p($g(^DHCEQCCode("DHCEQCDepartment",LinkLocID)),"^",11)
			s ExType=$p($g(^DHCEQCCode("DHCEQCDepartment",LinkLocID)),"^",10)
			i (ExType=1)&&(ctlocid'="")
			{
				s linkctlocid=""
				f  s linkctlocid=$o(^CTLOC(ctlocid,"LINK",0,"Loc",linkctlocid)) q:linkctlocid=""  d
				.s locid=##Class(web.DHCEQCommon).getMapIDBySource("dept",linkctlocid)
				.d GetOneLocComponent
			}
		}
		else				//是否启用his关联科室  modified by czf 20200821 end
		{
			s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
			s LGTLocRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0102",0))
			//modify by lmm 2018-10-25 begin
			f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:rowid=""  d
			.s locid=rowid
			.s StoreFlag=""
			.s LocFlag=""
			.i LGTStoreRowID'="" s StoreFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,locid))
			.i LGTLocRowID'="" s LocFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTLocRowID,locid))
			.q:((CTLocAllFlag'="Y")&&(StoreFlag=0)&&(LocFlag=0))
			.d GetOneLocComponent
			
			//modify by lmm 2018-10-25 end
		}
	}
	if Type="1"  //安全组科室
	{
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		s StoreDR=0
		f  s StoreDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,StoreDR))  q:StoreDR=""  d
		.;modify by lmm 2018-10-25 begin
		.s (OrganizeType,StoreHospDR)=""
		.s OrganizeType=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreDR)),"^",7)   
		.i (OrganizeType=1) s StoreHospDR=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreDR)),"^",8) 
		.;modify by lmm 2018-10-25 begin
		.s GroupHospIDs=##Class(web.DHCEQCommon).GetHospIDSByGroup(vgroupid)
		.q:GroupHospIDs'[("^"_StoreHospDR_"^")
		.s locid=StoreDR
		.d GetOneLocComponent
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",StoreDR,locid)) q:(locid="")||(LocType="0101")  d
		..d GetOneLocComponent
		/*
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		f  s rowid=$o(^SSU("SSGRP",vgroupid,"ST",0,"Loc",rowid)) q:rowid=""  d
		.s locid=rowid
		.d GetOneLoc
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",rowid,locid)) q:(locid="")  d
		..d GetOneLoc
		*/
	}
	if Type="2" //本科室
	{
		s rowid=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		s locid=rowid
		d GetOneLocComponent
	}
	
	
	Quit $$$OK

GetOneLocComponent	

	//add by zy 2015-04-09 ZY0125 分院区管理,通过科室的医院属性来管理
	s HIIFlag=1		//Add By DJ 2017-03-22
	i '((CurHosptailID=0)&&(LocType="0101"))  d		//转移单为库房调配时接收部门可选择所有库房
	.s HIIFlag=##Class(web.DHCEQCommon).HospitalIsInclude(locid,vgroupid,CurHosptailID)
	quit:HIIFlag=0
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit(UserID,vgroupid,"","","","",locid))
	q:(($p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",19))="Y")  //add by jyp 2019-01-11
	s code=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",1)
	s desc=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",2)
	///add by ZY0210 增加别名表中拼音码的检索
	s AText=""
	s ARowID=##Class(web.DHCEQ.Plat.CTAlias).GetAlias("DHCEQCDepartment",locid,"text","PYCode")
	i ARowID'="" s AText=$p($g(^DHCEQCCode("DHCEQCAlias",rowid)),"^",1)
	
	s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",13)
	q:(notUseFlag'="")&&(NotUse="Y")
	s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",18)
	q:((notUseFlag'="")&&(+DATo'=0)&&(+DATo<+$H))
	s LocDesc=$ZCONVERT(LocDesc,"U")
	q:($ZCONVERT(desc,"U")'[LocDesc)&&($ZCONVERT(code,"U")'[LocDesc)&&($ZCONVERT(AText,"U")'[LocDesc)
	if LocTypeID'=""     //库房类型
	{
		if '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeID,locid)) q
	}
	;Modified By QW20190823 需求号:979934 获取院区信息
	s detail= ##Class(web.DHCEQCLocType).GetEQLocDetailByID("", "", locid)	;取科室类型表电话	//201702-04	Mozy
	s Thospital=$p(detail,"^",3)
	s tel=$p(detail,"^",17)
	;End By QW20190823 需求号:979934
	d OutputRowGetEQLocComponent

	quit
OutputRowGetEQLocComponent
	s TPYM=$p(desc,"-",1)
	s TRowID=locid
	s TCode=code
	s TName=##class(web.DHCEQCommon).GetSplitDataByFlag(desc,"-")
	s TTel=tel
	s Data=$lb(TName,TRowID,TCode,TPYM,TTel,Thospital) ;Modified By QW20190823 需求号:979934 增加输出Thospital
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEQLocComponentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEQLocComponentExecute ]
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

ClassMethod GetEQLocComponentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEQLocComponentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by jyp 2018-09-03
/// 描述：查询通用Lookup JYP0014
/// 入参：para:来源描述
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","TypeDefine","","Flag")
Query TypeDefine(Desc, Lookupname) As %SQLQuery(ROWSPEC = "TRowID:%String,TDesc:%String")
{
SELECT TD_Value,
	   TD_Desc
FROM sqluser.DHC_EQCTypeDefine
where TD_InvalidFlag = 'N' and TD_Name = :Lookupname and TD_Desc like nvl(:Desc,'')||'%'
}

/// add by JYP 2018-10-09
/// 描述：根据姓名或工号来查找员工 JYP0014
/// 入参：name:姓名
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","User","")
ClassMethod UserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UserExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	
 	If $g(ind)="" Set ind=1
	s rowid=0
	s rowids=""
	s Name=$ZCONVERT(Name,"U")	
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.s userid=rowid
	.s initials=$p(^SSU("SSUSR",rowid),"^",1)
	.s username=$p(^SSU("SSUSR",rowid),"^",2)
	.s sex=$p(^SSU("SSUSR",rowid),"^",123)
	.s sexdesc=$CASE(sex,"1":"男","2":"女","":"")
	.s officephone=$p(^SSU("SSUSR",rowid),"^",100)  // add by LMH 20220721 BUG LMH0009
	.s mobilephone=$p(^SSU("SSUSR",rowid),"^",99)
	.s email=$p(^SSU("SSUSR",rowid),"^",101)        // add by LMH 20220721 BUG LMH0009
	.s PYCode=$p($g(^DHCEQUserPYTemp(rowid)),"^",2) //2009-09-19 党军  hisui后期拼音码调整
	.q:($ZCONVERT(username,"U")'[Name)&&($e(PYCode,1,$l(Name))'=Name)&&($ZCONVERT(initials,"U")'[Name)
 	.Do OutputRowUser	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowUser
	set Data=$lb(username,userid,initials,officephone,mobilephone,email,sexdesc,sex)

 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
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

// add by LMH 20220721 BUG LMH0009

Query User(Name As %String = "") As %Query(ROWSPEC = "TUserName:%String,TRowID:%String,TInitials:%String,TOfficePhone:%String,TMobilePhone:%String,TEmail:%String,TSexDesc:%String,TSexDR:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","Group")
Query Group(Name As %String = "") As %Query(ROWSPEC = "TGroupName:%String,TGroupID:%String")
{
}

/// add by JYP 2018-10-09
/// 描述：根据安全组名来查找安全组 JYP0014
/// 入参：Name:安全组名称
ClassMethod GroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GroupExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	
 	If $g(ind)="" Set ind=1
	s rowid=0
	s rowids=""
	s Name=$ZCONVERT(Name,"U")
	/*
	i Name'=""
	{
	f  s rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",Name,rowid))  q:rowid=""  d
	.s username=$p(^SSU("SSUSR",rowid),"^",2)
	.s rowid0=rowid
	.s initials=$p(^SSU("SSUSR",rowid),"^",1)
	.s rowids=","_rowid0
	.Do OutputRowUser	
	}
	if (rowids'="") s rowids=rowids_","
	*/
	f  s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""  d
	.s GroupName=$p(^SSU("SSGRP",rowid),"^",1)
	.q:(Name'="")&($ZCONVERT(GroupName,"U")'[Name)
 	.Do OutputRowGroup	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGroup
	set Data=$lb(GroupName,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupExecute ]
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

/// add by lmm 2018-10-08
/// 描述：获取医院信息
/// 入参：Hospital：医院名称
///      CurGorupID:安全组id
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetHospital")
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetHospital(Hospital As %Library.String = "", CurGorupID As %String = "") As %Query(ROWSPEC = "TName:%String:院区,TRowID:%String,TCode:%String:代码")
{
}

ClassMethod GetHospitalExecute(ByRef qHandle As %Binary, Hospital As %Library.String = "", CurGorupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set job=$job
	i CurGorupID="" s CurGorupID=%session.Get("LOGON.GROUPID")
	s GroupHospIDs=##Class(web.DHCEQCommon).GetHospIDSByGroup(CurGorupID)
	Set rowid=0
	For  Set rowid=$Order(^CT("HOSP",rowid)) Quit:rowid=""  Do
	.Set hospitalid=rowid
	.q:GroupHospIDs'[("^"_rowid_"^")
	.Set desc=$Piece($Get(^CT("HOSP",hospitalid)),"^",2)
	.Set code=$Piece($Get(^CT("HOSP",hospitalid)),"^",1)
	.Set Hospital=$ZCONVERT(Hospital,"U")
	.Quit:(Hospital'="")&($ZCONVERT(desc,"U")'[Hospital)
	.Set ^TempDHCEQ("HospitalTemp",job,$ZCONVERT(desc,"U"),hospitalid)=""

	Set hospitaldesc=""
	For  Set hospitaldesc=$Order(^TempDHCEQ("HospitalTemp",job,hospitaldesc)) Quit:hospitaldesc=""  Do
	.Set hospitalid=0
	.For  Set hospitalid=$Order(^TempDHCEQ("HospitalTemp",job,hospitaldesc,hospitalid)) Quit:hospitalid=""  Do
	..Set desc=$Piece($Get(^CT("HOSP",hospitalid)),"^",2)
	..Set code=$Piece($Get(^CT("HOSP",hospitalid)),"^",1)
	..Do OutputRowGetHospital
	Kill ^TempDHCEQ("HospitalTemp",job)
	
	Quit $$$OK
OutputRowGetHospital
	Set Data=$lb(desc,hospitalid,code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by sjh SJH0041 2020-12-01 lookup组件调用院区query
Query GetHospitalComponent(Hospital As %Library.String = "", CurGorupID As %String = "") As %Query(ROWSPEC = "TName:%String:院区,Hidden:%String,TCode:%String:代码")
{
}

ClassMethod GetHospitalComponentExecute(ByRef qHandle As %Binary, Hospital As %Library.String = "", CurGorupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set job=$job
	i CurGorupID="" s CurGorupID=%session.Get("LOGON.GROUPID")
	s GroupHospIDs=##Class(web.DHCEQCommon).GetHospIDSByGroup(CurGorupID)
	Set rowid=0
	For  Set rowid=$Order(^CT("HOSP",rowid)) Quit:rowid=""  Do
	.Set hospitalid=rowid
	.q:GroupHospIDs'[("^"_rowid_"^")
	.Set desc=$Piece($Get(^CT("HOSP",hospitalid)),"^",2)
	.Set code=$Piece($Get(^CT("HOSP",hospitalid)),"^",1)
	.Set Hospital=$ZCONVERT(Hospital,"U")
	.Quit:(Hospital'="")&($ZCONVERT(desc,"U")'[Hospital)
	.Set ^TempDHCEQ("HospitalTemp",job,$ZCONVERT(desc,"U"),hospitalid)=""

	Set hospitaldesc=""
	For  Set hospitaldesc=$Order(^TempDHCEQ("HospitalTemp",job,hospitaldesc)) Quit:hospitaldesc=""  Do
	.Set hospitalid=0
	.For  Set hospitalid=$Order(^TempDHCEQ("HospitalTemp",job,hospitaldesc,hospitalid)) Quit:hospitalid=""  Do
	..Set desc=$Piece($Get(^CT("HOSP",hospitalid)),"^",2)
	..Set code=$Piece($Get(^CT("HOSP",hospitalid)),"^",1)
	..Do OutputRowGetHospitalComponent
	Kill ^TempDHCEQ("HospitalTemp",job)
	
	Quit $$$OK
OutputRowGetHospitalComponent
	Set Data=$lb(desc,hospitalid,code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetHospitalComponentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalComponentExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetHospitalComponentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalComponentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by lmm 2018-10-08
/// 描述：组件查询的基本query
/// 入参：Desc 组件名称的模糊查询条件
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetComponent","")
Query GetComponent(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCaption:%String,TName:%String")
{
}

ClassMethod GetComponentExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
	s index=1
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCComponent",rowid))  quit:rowid=""  d
	.s (TRowID,TCode,TName)=""
	.s TRowID = rowid	//rowid
	.s TName=$p($g(^DHCEQCCode("DHCEQCComponent",rowid)),"^",1)
	.s TCaption=$p($g(^DHCEQCCode("DHCEQCComponent",rowid)),"^",2)
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCComponent",rowid)),"^",12) //无符号标志
	.q:LTInvalidFlag="Y"
	.//modified by ZY0199 增加caption模糊查询
	.q:(Desc'="")&&(($ZCONVERT(TName,"U")'[Desc)&&($ZCONVERT(TCaption,"U")'[Desc))
	.d OutputRowGetComponent
	Quit $$$OK
	
OutputRowGetComponent
   	s Data=$lb(TRowID,TCaption,TName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentExecute ]
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

ClassMethod GetComponentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by czf 20200404
/// 描述: 服务商
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetService","")
Query GetService(Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String,TTel:%String,TContPerson:%String")
{
}

ClassMethod GetServiceExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc) //modified by CZF0103 20200408
 	Set Desc=$ZCONVERT(Desc ,"U")
 	
	Set index=1
	Set FirmType=4
	
	Set rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid)) q:rowid=""  d	
	.s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid,""))
	.q:FCRowid=""
	.q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"		 //modified by CZF0103 20200408
	.Do ResetGetService
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)	
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.Quit:(Desc'="")&&($ZCONVERT(TCode ,"U")'[Desc)&&($ZCONVERT(TDesc ,"U")'[Desc)
	.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)
	.Do OutputGetService
	Quit $$$OK

OutputGetService
	Set Data=$lb(TDesc,TRowID,TCode,TTel,TContPerson)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetService
	Set (TDesc,TRowID,TCode,TTel,TContPerson)=""
	Quit
}

ClassMethod GetServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// modify by lmm 2018-11-06  入参名称更改 valName->ValName
Query GetBrand(ManuFactoryDR, ValName) As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetBrandExecute(ByRef qHandle As %Binary, ManuFactoryDR, ValName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCBrand",rowid))  quit:rowid=""  d
	.d ResetVariablesGetBrandList
	.s RowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",5)
	.q:Flag="Y"
	.s Name = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",3)
	.s Code=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",2)
	.q:(ValName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(ValName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(ValName,"U")))
	.s ManuFactory=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",1)
	.q:(ManuFactoryDR'="")&&(ManuFactoryDR'=ManuFactory)&&(ManuFactory'="")
	.d OutputRowGetBrandList
	Quit $$$OK
OutputRowGetBrandList
	Set Data=$lb(Name,RowID,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBrandList
	s (Name,RowID,Code)=""
	quit
}

ClassMethod GetBrandFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBrandExecute ]
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

ClassMethod GetBrandClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBrandExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCycleUnit(Desc) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT CU_Desc,
	   CU_RowID,
	   CU_Code
FROM sqluser.DHC_EQCCycleUnit
where CU_InvalidFlag = 'N' and CU_Desc like nvl(:Desc,'')||'%'
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetCTLoc","")
Query GetSSLoc(LocDesc As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetSSLocExecute(ByRef qHandle As %Binary, LocDesc As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s locid=rowid
	.d GetOneCTLoc

	//add by jdl 2009-9-14 JDL0030
	s locdesc=""
	f  s locdesc=$o(^TempDHCEQ("LocTemp",$j,locdesc)) q:locdesc=""  d
	.s locid=0
	.f  s locid=$o(^TempDHCEQ("LocTemp",$j,locdesc,locid)) q:locid=""  d
	..s TRowID=locid
	..s TName=$p($g(^CTLOC(locid)),"^",2)
	..s TName=##class(web.DHCEQCommon).GetSplitDataByFlag(TName,"-")
	..s TCode=$p($g(^CTLOC(locid)),"^",1)
	..d OutputRowGetCTLoc
	k ^TempDHCEQ("LocTemp",$j)
	
	Quit $$$OK

GetOneCTLoc	
	//add by zy 2015-04-09 ZY0125 分院区管理,通过科室的医院属性来管理
	quit:##Class(web.DHCEQCommon).HospitalIsInclude(locid)=0
	
	s desc=$p($g(^CTLOC(locid)),"^",2)
	s code=$p($g(^CTLOC(locid)),"^",1)
	s NotUse=$p($g(^CTLOC(locid)),"^",37)
	q:(NotUse="Y")
	s DATo=$p($g(^CTLOC(locid)),"^",25)
	q:((+DATo'=0)&&(+DATo<+$H))
	s LocDesc=$ZCONVERT(LocDesc,"U")
	q:($ZCONVERT(desc,"U")'[LocDesc)&&($ZCONVERT(code,"U")'[LocDesc)
	
	//modified by jdl 2009-9-14 JDL0030
	s ^TempDHCEQ("LocTemp",$j,$ZCONVERT(desc,"U"),locid)=""
	quit
OutputRowGetCTLoc
	s Data=$lb(TName,TRowID,TCode)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetSSLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSLocExecute ]
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

ClassMethod GetSSLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2019-10-22 BUG ZX0077
/// 描述：设备配件来源
/// 入参：Desc:来源描述
Query GetAccessoryOriginal(Desc) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
	SELECT AO_Desc,
		   AO_RowID,
		   AO_Code
	FROM sqluser.DHC_EQCAccessoryOriginal
	where AO_InvalidFlag = 'N' and AO_Desc like nvl(:para,'')||'%'
}

/// add by WY 2020-4-25 来源部门 bug WY0088
/// 入参：设备来源部门Desc
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetFromToDept","")
Query GetFromToDept(Desc) As %SQLQuery(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String")
{
}

ClassMethod GetFromToDeptExecute(ByRef qHandle As %Binary, Name) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Name=$ZCONVERT(Name,"U")	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFromToDept",rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCFromToDept",rowid)),"^",4)="Y"
	.s Desc=$p($g(^DHCEQCCode("DHCEQCFromToDept",rowid)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQCFromToDept",rowid)),"^",1)
	.q:(Name'="")&&($ZCONVERT(Desc,"U")'[Name)&&($ZCONVERT(Code,"U")'[Name)
	.d OutputRowGetFromToDept
    Quit $$$OK
OutputRowGetFromToDept
	s Desc=$p($g(^DHCEQCCode("DHCEQCFromToDept",rowid)),"^",2)
	s Code=$p($g(^DHCEQCCode("DHCEQCFromToDept",rowid)),"^",1)
	s Data=$lb(rowid,Code,Desc)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetFromToDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFromToDeptExecute ]
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

ClassMethod GetFromToDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFromToDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetOrigin","")
/// Add By QW20210512 BUG:QW0108 改造资产来源query
/// 资产来源
Query GetOrigin(Desc, EquipFlag As %Library.String = "Y", FacilityFlag As %Library.String = "") As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TEquipFlag:%String,TFacilityFlag:%String")
{
}

ClassMethod GetOriginExecute(ByRef qHandle As %Binary, Desc, EquipFlag As %Library.String = "Y", FacilityFlag As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
 	Set Desc=$ZCONVERT(Desc ,"U")
 	
	Set index=1

	
	Set rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCOrigin",rowid)) q:rowid=""  d
	.Do ResetGetOrigin
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TEquipFlag=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",5)
	.s TFacilityFlag=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",6)
	.q:(EquipFlag'="")&&(EquipFlag'=TEquipFlag)
	.q:(FacilityFlag'="")&&(FacilityFlag'=TFacilityFlag)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",2)
	.Quit:(Desc'="")&&($ZCONVERT(TCode ,"U")'[Desc)&&($ZCONVERT(TName ,"U")'[Desc)
	.Do OutputGetOrigin
	Quit $$$OK
OutputGetOrigin
	Set Data=$lb(TName,TRowID,TCode,TEquipFlag,TFacilityFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetOrigin
	Set (TName,TRowID,TCode,TEquipFlag,TFacilityFlag)=""
	Quit
}

ClassMethod GetOriginFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOriginExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOriginClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOriginExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by ZY 2022-9-13 配置批准单位 bug:2907381、2907386、2907390
/// 入参：配置批准单位
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetAuthorizeDept","")
Query GetAuthorizeDept(vDesc As %Library.String = "") As %SQLQuery(ROWSPEC = "TRowID:%String:ID,TCode:%String:代码,TName:%String:配置批准单位")
{
}

ClassMethod GetAuthorizeDeptExecute(ByRef qHandle As %Binary, vDesc) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vDesc=$ZCONVERT(vDesc,"U")  
    s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCAuthorizeDept",rowid))  quit:rowid=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCAuthorizeDept",rowid)),"^",4)="Y"
    .s Desc=$p($g(^DHCEQCCode("DHCEQCAuthorizeDept",rowid)),"^",2)
    .s Code=$p($g(^DHCEQCCode("DHCEQCAuthorizeDept",rowid)),"^",1)
    .q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
    .d OutputRowGetAuthorizeDept
    Quit $$$OK
OutputRowGetAuthorizeDept
    s Data=$lb(rowid,Code,Desc)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetAuthorizeDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAuthorizeDeptExecute ]
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

ClassMethod GetAuthorizeDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAuthorizeDeptExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by ZY 2022-9-13 使用责任主体 bug:2907381、2907386、2907390
/// 入参：使用责任主体
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetUseSubject","")
Query GetUseSubject(vDesc As %Library.String = "") As %SQLQuery(ROWSPEC = "TRowID:%String:ID,TCode:%String:代码,TName:%String:使用责任主体")
{
}

ClassMethod GetUseSubjectExecute(ByRef qHandle As %Binary, vDesc) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vDesc=$ZCONVERT(vDesc,"U")  
    s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCUseSubject",rowid))  quit:rowid=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCUseSubject",rowid)),"^",4)="Y"
    .s Desc=$p($g(^DHCEQCCode("DHCEQCUseSubject",rowid)),"^",2)
    .s Code=$p($g(^DHCEQCCode("DHCEQCUseSubject",rowid)),"^",1)
    .q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
    .d OutputRowGetUseSubject
    Quit $$$OK
OutputRowGetUseSubject
    s Data=$lb(rowid,Code,Desc)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetUseSubjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseSubjectExecute ]
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

ClassMethod GetUseSubjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseSubjectExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by ZY 2022-9-13 采购组织形式 bug:2907381、2907386、2907390
/// 入参：采购组织形式
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetBuyMode","")
Query GetBuyMode(vDesc As %Library.String = "") As %SQLQuery(ROWSPEC = "TRowID:%String:ID,TCode:%String:代码,TName:%String:采购组织单位")
{
}

ClassMethod GetBuyModeExecute(ByRef qHandle As %Binary, vDesc) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vDesc=$ZCONVERT(vDesc,"U")  
    s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCBuyMode",rowid))  quit:rowid=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCBuyMode",rowid)),"^",4)="Y"
    .s Desc=$p($g(^DHCEQCCode("DHCEQCBuyMode",rowid)),"^",2)
    .s Code=$p($g(^DHCEQCCode("DHCEQCBuyMode",rowid)),"^",1)
    .q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
    .d OutputRowGetBuyMode
    Quit $$$OK
OutputRowGetBuyMode
    s Data=$lb(rowid,Code,Desc)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetBuyModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyModeExecute ]
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

ClassMethod GetBuyModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyModeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by ZY 2022-9-13 价值类型 bug:2907381、2907386、2907390
/// 入参：价值类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetValueType","")
Query GetValueType(vDesc As %Library.String = "") As %SQLQuery(ROWSPEC = "TRowID:%String:ID,TCode:%String:代码,TName:%String:价值类型")
{
}

ClassMethod GetValueTypeExecute(ByRef qHandle As %Binary, vDesc) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vDesc=$ZCONVERT(vDesc,"U")  
    s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCValueType",rowid))  quit:rowid=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCValueType",rowid)),"^",4)="Y"
    .s Desc=$p($g(^DHCEQCCode("DHCEQCValueType",rowid)),"^",2)
    .s Code=$p($g(^DHCEQCCode("DHCEQCValueType",rowid)),"^",1)
    .q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
    .d OutputRowGetValueType
    Quit $$$OK
OutputRowGetValueType
    s Data=$lb(rowid,Code,Desc)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetValueTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueTypeExecute ]
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

ClassMethod GetValueTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by CZF 2022-11-01
/// 入参：使用权类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetRightType","")
Query GetRightType(vDesc) As %SQLQuery(ROWSPEC = "TRowID:%String:ID,TCode:%String:代码,TName:%String:使用权类型")
{
}

ClassMethod GetRightTypeExecute(ByRef qHandle As %Binary, vDesc) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vDesc=$ZCONVERT(vDesc,"U")  
    s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCRightType",rowid))  quit:rowid=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCRightType",rowid)),"^",4)="Y"
    .s Desc=$p($g(^DHCEQCCode("DHCEQCRightType",rowid)),"^",2)
    .s Code=$p($g(^DHCEQCCode("DHCEQCRightType",rowid)),"^",1)
    .q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
    .d OutputRowGetRightType
    Quit $$$OK
OutputRowGetRightType
    s Data=$lb(rowid,Code,Desc)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetRightTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRightTypeExecute ]
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

ClassMethod GetRightTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRightTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
