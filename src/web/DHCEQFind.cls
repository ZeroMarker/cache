/// 新增设备分摊比例查询
/// Modified By MR 2014-04-04 MR0013
/// -------------------------------
/// Modified By HZY 2011-10-14 HZY0014
/// 修改查询方法: GetBussType
/// Desc:添加4种业务类型.
/// -------------------------------
/// add：ZY 2011-03-22   ZY0066
/// Desc：Status的四个状态,元素是CUSTOM型
/// -------------------------------
/// 修改：zy 2009-07-22   zy0007
/// 修改查询方法：GetEQLoc
/// 修改方法：增加一个参数：LocType科室类型；
/// 描述:设备入库管理中，库房要从属于库房这一类的科室中选择
/// -----------------------------------------
/// 修改人： JDL 2009-06-23
/// 修改目的：解决JDL0018,增加供应商分类的处理。
/// 修改内容：增加方法GetVendCat
/// -----------------------------------------
/// 修改人： JDL 2009-05-14 
/// 修改目的：解决JDL0003、JDL0004,增加科室和设备类组的查找条件。
/// 修改内容：1.修改EQUser方法：增加参数loc,equiptype,优化性能
/// ----------------------------------------------
/// modified by GR 2014-09-29 
/// 缺陷3243 设备采购合同-设备采购合同-点击【签订部门】放大镜，弹出多余错误提示框
/// 修改位置GetGroupLocExecute()
/// 修改内容：修正参数错误问题
/// ---------------------------------------------------------
/// 设备管理系统的公用的查询方法
/// ---------------------------------------------
/// ---------------------------------------------------------
/// Modefied by zc 2014-10-17 
/// 修改位置EQUserExecute()
/// 修改目的：入库时根据类组查找人员
/// ---------------------------------------------
Class web.DHCEQFind Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// "RowID:%String,Name:%String,ABCType:%String,ModelDR:%String,EquiCatDR:%String,UnitDR:%String,Code:%String,Desc:%String,InstallLocDR:%String,InstallDate:%String,LeaveFactoryNo:%String,LeaveFactoryDate:%String,OpenCheckDate:%String,CheckDate:%String,MakeDate:%String,ComputerFlag:%String,CountryDR:%String,ManageLocDR:%String,ManageLevelDR:%String,UseLocDR:%String,OriginDR:%String,FromDeptDR:%String,ToDeptDR:%String,BuyTypeDR:%String,EquipTechLevelDR :%String,ProviderDR:%String,ManuFactoryDR:%String,OriginalValueFee:%String,NetValueFee:%String,NetRemainValueFee:%String,GroupDR:%String,LimitYearsNum:%String,ContractListDR:%String,DepreMethodDR:%String,Remark:%String,DepreTotalFee:%String,DesignWorkLoadFee:%String,WorkLoadUnitDR:%String,Status:%String,ManageUserDR:%String,MaintUserDR:%String,ContactUser:%String,ContactMode:%String,AppendFeeTotalFee:%String,StartDate:%String,TransAssetDate:%String,GuaranteeFlag:%String,InputFlag:%String,TestFlag:%String,MedicalFlag:%String,GuaranteeStart:%String,GuaranteeEnd:%String,AddUserDR:%String,AddDate:%String,AddTime:%String,UpdateUserDR:%String,UpdateDate:%String,UpdateTime:%String,Model:%String,EquiCat:%String,Unit:%String,InstallLoc:%String,Country:%String,ManageLoc:%String,ManageLevel:%String,UseLoc:%String,Origin:%String,FromDept:%String,ToDept:%String,BuyType:%String,Provider:%String,ManuFactory:%String,Group:%String,ContractList:%String,DepreMethod:%String,WorkLoadUnit:%String,ManageUser:%String,MaintUser:%String,AddUser:%String,UpdateUser:%String"
Query GetEquip() As %Query(ROWSPEC = "RowID:%String,Name:%String")
{
}

ClassMethod GetEquipExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetEquip
	Quit $$$OK
BuildDataGetEquip
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquip
	.s RowID = rowid
	.s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	.d OutputRowGetEquip
	quit
OutputRowGetEquip
	s Data=$lb(RowID,Name) //,ModelDR,ManageLocDR,UseLocDR,GroupDR,ManageUserDR,Model,ManageLoc,UseLoc,ManageUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquip
	quit
}

ClassMethod GetEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipExecute ]
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

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据姓名或工号来查找员工
ClassMethod UserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UserExecute(ByRef qHandle As %Binary, name As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	
 	If $g(ind)="" Set ind=1
	s rowid=0
	
	s name=$ZCONVERT(name,"U")
	f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
	.s userdata=$g(^DHCEQCCode("DHCEQCUser",rowid))
	.s initials=$p(userdata,"^",1)
	.s username=$p(userdata,"^",4)
	.s userloc=$p(userdata,"^",14)
	.s PYCode=$p(userdata,"^",3)
	.i PYCode="" s PYCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(username,4,"","U")
	.q:(name'="")&&($ZCONVERT(username,"U")'[name)&&($ZCONVERT(initials,"U")'[name)&&($e(PYCode,1,$l(name))'=name)
 	.Do OutputRowUser	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowUser
	set Data=$lb(username,rowid,initials)
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

/// modified by ZY20221206 bug:3132693
Query User(name As %String = "") As %Query(ROWSPEC = "UserName:%String,Hidden:%String,Initials:%String:别名")
{
}

ClassMethod GetPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPatientExecute(ByRef qHandle As %Binary, patientname As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//if (patientname="")
 	//{Set qHandle=$lb(0,repid,0)
 	// quit $$$OK}
	s rowid=0
	if patientname'=""
	{
	f  s rowid=$o(^PAADMi("No",$ZCONVERT(patientname,"U"),rowid)) q:rowid=""  d
	.s admno=$p(^PAADM(rowid),"^",81)
	.s admid=rowid	
	.s patientid =$p(^PAADM(rowid),"^",1)	
 	.Do OutputRowGetPatient
 	
 	s rowid=0
 	f  s rowid=$o(^PAPERi("PAPER_PatName",$ZCONVERT(patientname,"U"),rowid)) q:rowid=""  d
 	.s patientid =rowid 	
 	.Do OutputRowGetPatient
 	
 	s rowid=0
 	f  s rowid=$o(^PAPERi("PAPMI_PatNo",$ZCONVERT(patientname,"U"),rowid)) q:rowid=""  d
 	.s patientid =rowid 	
 	.Do OutputRowGetPatient
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK  
OutputRowGetPatient
	s pname=$p(^PAPER(patientid,"ALL"),"^",1)
	s pno=$p(^PAPER(patientid,"PAT",1),"^",1)	
	s sex=$p(^PAPER(patientid,"ALL"),"^",7)	
	i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	set Data=$lb(pname,pno,patientid,sex)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientExecute ]
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

Query GetPatient(patientname As %String) As %Query(ROWSPEC = "Name:%String,No:%String,Hidden:%String,Sex:%String")
{
}

ClassMethod GetPayModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPayModeExecute(ByRef qHandle As %Binary, vdesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s desc=$p(^CT("CTPM",rowid),"^",2)
	.s code=$p(^CT("CTPM",rowid),"^",1)
	.q:desc'[vdesc
	.s rowid0=rowid
 	.Do OutputRowGetPayMode	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetPayMode
	set Data=$lb(desc,rowid0,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPayModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayModeExecute ]
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

Query GetPayMode(vdesc As %String) As %Query(ROWSPEC = "Desc:%String,ID:%String,Code:%String")
{
}

ClassMethod GetStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStatusExecute(ByRef qHandle As %Binary, statustype As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s DisplayValue="新增"
    s LogicalValue="0"
    Do OutputRowGetStatus
    s DisplayValue="提交"
    s LogicalValue="1"
    Do OutputRowGetStatus
    s DisplayValue="审核"
    s LogicalValue="2"
    Do OutputRowGetStatus
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetStatus
	set Data=$lb(DisplayValue,LogicalValue)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatusExecute ]
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

Query GetStatus(statustype As %String) As %Query(ROWSPEC = "DisplayValue:%String,LogicalValue:%String")
{
}

ClassMethod YesNoAllList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=Y>是</option>"
	w "<option value=N>否</option>"
	w "</select>",!
}

/// 获取该安全组能够访问的库房科室
ClassMethod GetGroupLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 增加参数notUseFlag:限制是否显示无效科室，""不限制显示全部科室，"Y"不显示无效科室
ClassMethod GetGroupLocExecute(ByRef qHandle As %Binary, includloc, vdesc As %String, notUseFlag As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s locid=0
	s curLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s vgroupid=%session.Get("LOGON.GROUPID")
	f  s locid=$o(^SSU("SSGRP",vgroupid,"ST",0,"Loc",locid)) q:locid=""  d
	.s locid=##Class(web.DHCEQCommon).getMapIDBySource("dept",locid)
	.s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",locid)
	.s code=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",locid)
	.s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",13)
	.q:(notUseFlag'="")&&(NotUse="Y")
	.s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",18)
	.q:((notUseFlag'="")&&(+DATo'=0)&&(+DATo<+$H))
	.q:(desc'[vdesc)&&(code'[vdesc)
	.s rowid0=locid
	.i curLocID=locid s curLocID=0
 	.Do OutputRowGetGroupLoc
  	i curLocID'=0  d
 	.s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",locid)
	.s code=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",locid)
	.s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",13)  //modified by GR 2014-09-29 begin 缺陷3243 修正参数不正确问题
	.//s NotUse=$p($g(^CTLOC(locid)),"^",37)
	.q:(notUseFlag'="")&&(NotUse="Y")
	.s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",18)
	.//s DATo=$p($g(^CTLOC(locid)),"^",25)    //modified by GR 2014-09-29 end 缺陷3243
	.q:((notUseFlag'="")&&(+DATo'=0)&&(+DATo<+$H))
 	.s rowid0=curLocID
 	.Do OutputRowGetGroupLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetGroupLoc
	set Data=$lb(desc,rowid0,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGroupLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupLocExecute ]
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

Query GetGroupLoc(includloc As %String, vdesc As %String, notUseFlag As %String = "") As %Query(ROWSPEC = "Desc:%String,Hidden:%String,Code:%String")
{
}

/// MR 添加FLAG  1：获取被服类组  MR0015
/// add by wy  2017-06-19 添加列表序号
/// modified by sjh SJH0041 2020-12-02 输出列标题修改
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","GetEquipType","","85","0","0","2","2")
Query GetEquipType(Desc, GroupID As %Library.String = "", Flag As %Library.String = "0", FacilityFlag As %String = "0", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Query(ROWSPEC = "Desc:%String:设备类组,Hidden:%String,Code:%String:编码,TRow:%String") [ SqlProc ]
{
}

ClassMethod GetEquipTypeExecute(ByRef qHandle As %Binary, Desc, GroupID As %Library.String = "", Flag As %Library.String = "0", FacilityFlag As %String = "0", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)	//CZF0138 2021-05-26
	s vEquipTypeIDs=""
	d BuildDataGetEquipType
	Quit $$$OK
BuildDataGetEquipType
	i Flag="1"  s vEquipTypeIDs=##class(web.DHCEQCommon).GetSysInfo("990024")  
	i ""'=vEquipTypeIDs s vEquipTypeIDs=","_vEquipTypeIDs_","   //2014-9-10 HZY0060 
	s Type=##class(web.DHCEQCommon).GetEquipTypesByGroup(GroupID,"",FacilityFlag) //add by zx 2017-03-20 BUG ZX0036
	if (Type="")  //所有类组
	{
		q
	}
	else  //可访问类组
	{
		s i=$l(Type,"^")
		for j=1:1:i
		{
			s rowid=$p(Type,"^",j)
			d ResetVariablesGetEquipType
			d GetOneEquipType
		}
	}
	quit
GetOneEquipType
	s locid=rowid
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit("",GroupID,"",locid))
	q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCEquipType",locid,sHospID)'="Y"		//CZF0138 2021-05-26
	s desc=$p(^DHCEQCCode("DHCEQCEquipType",locid),"^",2)
	s code=$p(^DHCEQCCode("DHCEQCEquipType",locid),"^",1)
	s Invaild=$p(^DHCEQCCode("DHCEQCEquipType",locid),"^",4)
	q:Invaild="Y"
	q:(desc'[Desc)&&(code'[Desc)
	q:(vEquipTypeIDs'="")&&(vEquipTypeIDs'[(","_locid_","))
	d OutputRowGetEquipType
	quit
OutputRowGetEquipType
    s TRow=TRow+1
	s Data=$lb(desc,locid,code,TRow)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipType
	s (desc,locid,code)=""
	quit
}

ClassMethod GetEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipTypeExecute ]
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

ClassMethod GetEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ExportTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>增加</option>"
	w "<option value=2>减少</option>"
	w "<option value=3>折旧</option>"
	w "</select>",!
}

ClassMethod ExportEquipTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value='01'>土地</option>"
	w "<option value='02'>房屋建筑物</option>"
	w "<option value='03'>通用设备</option>"
	w "<option value='04'>专用设备</option>"
	w "<option value='05'>交通运输设备</option>"
	w "<option value='06'>电气设备</option>"
	w "<option value='07'>电子产品及通讯设备</option>"
	w "<option value='08'>仪器仪表及量具</option>"
	w "<option value='09'>文艺体育设备</option>"
	w "<option value='10'>图书文物及陈列品</option>"
	w "<option value='11'>家具用具及其他类</option>"
	w "</select>",!
}

/// modified by ZY 20220927  修改global
Query GetCountry(Country) As %Query(ROWSPEC = "Desc:%String:描述,Hidden:%String,Code:%String:编码")
{
}

ClassMethod GetCountryExecute(ByRef qHandle As %Binary, Country) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Country=$ZCONVERT(Country,"U")	//2014-07-21 DJ0125 国别检索处理
	s rowid=0
	f  s rowid=$o(^CT("COU",rowid))  q:rowid=""  d
	.s Desc=$p($g(^CT("COU",rowid)),"^",2)
	.s Code=$p($g(^CT("COU",rowid)),"^",1)
	.q:(Country'="")&&($ZCONVERT(Desc,"U")'[Country)&&($ZCONVERT(Code,"U")'[Country)
	.d OutputRowGetCountry
	
	//如果为空遍历所有国别
	/*
	if Country=""
	{
		s rowid=0
		f  s rowid=$o(^CT("COU",rowid))  q:rowid=""  d
		.d OutputRowGetCountry
	}
	else
	{
		//根据Code遍历前匹配的国别
		s Country=$ZCONVERT(Country,"U")
		s code=$o(^CT("COU",0,"Code",Country),-1)
		f  s code=$o(^CT("COU",0,"Code",code))  q:((code="")||(code'[Country))  d
		.s rowid=0
		.f  s rowid=$o(^CT("COU",0,"Code",code,rowid))   q:rowid=""  d
		..S ^TempDHCEQ("StoreCountry",$J,rowid)=""
		
		s desc=$o(^CT("COU",0,"Desc",Country),-1)
		f  s desc=$o(^CT("COU",0,"Desc",desc))  q:((desc="")||(desc'[Country))  d
		.s rowid=0
		.f  s rowid=$o(^CT("COU",0,"Desc",desc,rowid))   q:rowid=""  d
		..S ^TempDHCEQ("StoreCountry",$J,rowid)=""
		
		s rowid=0
		f  s rowid=$o(^TempDHCEQ("StoreCountry",$J,rowid))   q:rowid=""  d
		.d OutputRowGetCountry
		
		///删除临时global
		k ^TempDHCEQ("StoreCountry",$J)
	}
	*/
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

/// modified by ZY 20220927  修改global
Query GetMasterItem(MasterItem) As %Query(ROWSPEC = "Desc:%String,Hidden:%String,Code:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, MasterItem) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1	
	//如果为空遍历所有国别
	if MasterItem=""
	{
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",rowid))  q:rowid=""  d
		.d OutputRowGetMasterItem
	}
	else
	{		
		s MasterItem=$ZCONVERT(MasterItem,"U")            ///根据Code遍历前匹配的国别
		s code=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Code",MasterItem),-1)
		f  s code=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Code",code))  q:((code="")||(code'[MasterItem))  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Code",code,rowid))   q:rowid=""  d
		..S ^TempDHCEQ("StoreMasterItem",$J,rowid)=""			
		s desc=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Desc",MasterItem),-1)    ///根据Desc遍历前匹配的国别	
		f  s desc=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Desc",desc))  q:((desc="")||(desc'[MasterItem))  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Desc",desc,rowid))   q:rowid=""  d
		..S ^TempDHCEQ("StoreMasterItem",$J,rowid)=""			
		s rowid=0                                    ///从临时global	里面取值	
		f  s rowid=$o(^TempDHCEQ("StoreMasterItem",$J,rowid))   q:rowid=""  d
		.d OutputRowGetMasterItem			
		k ^TempDHCEQ("StoreMasterItem",$J)              ///删除临时global
	}
    Quit $$$OK
OutputRowGetMasterItem
	s Desc=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s Code=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)	
	s Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemExecute ]
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

ClassMethod GetMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetVendCat(cat) As %Query(ROWSPEC = "Desc:%String,Hidden:%String,Code:%String")
{
}

ClassMethod GetVendCatExecute(ByRef qHandle As %Binary, cat) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	f  s rowid=$o(^APC("APCVC",rowid))  q:rowid=""  d
	.d OutputRowGetVendCat
	Quit $$$OK
OutputRowGetVendCat
	s Desc=$p($g(^APC("APCVC",rowid)),"^",3)
	s Code=$p($g(^APC("APCVC",rowid)),"^",2)
	
	s Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetVendCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVendCatExecute ]
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

ClassMethod GetVendCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVendCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 新增：2009-08-06 党军
/// 描述：入库单设备来源类型使用下拉列表控件
ClassMethod SourceTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	//modified by jdl 2009-10-29 JDL0037
	;w "<option value=></option>"
	;w "<option value=0>设备</option>"
	w "<option value=1>设备项</option>"
	w "<option value=2>验收单</option>"
	w "</select>",!
}

/// 新增:2010-07-14 党军
/// 描述:消耗资源类型定价方式
/// Modify By QW 2018-10-10 HISUI改造：自定义下拉列表显示格式错误
ClassMethod ResourceType(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	w "<option value=></option>"
	w "<option value=1>固定单价</option>"
	w "<option value=2>无固定单价</option>"
	w "<option value=3>根据接口获取单价</option>"
	w "</select>",!
}

/// 新增：2009-09-07 ZY 
/// 描述：入库单设备来源类型使用下拉列表控件
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","GetAccessoryType")
/// Modified by czf 20201012 修改出参名称
Query GetAccessoryType(AccessoryType As %Library.String = "", GroupID As %Library.String = "") As %Query(ROWSPEC = "TName:%String:名称,Hidden:%String,TCode:%String:编码")
{
}

ClassMethod GetAccessoryTypeExecute(ByRef qHandle As %Binary, AccessoryType As %Library.String = "", GroupID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessoryType",rowid))  q:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",4)'="N"		// 20191117 Mozy0232
	.d ResetVariablesGetAccessoryType
	.s RowID=rowid
	.Quit:##Class(web.DHCEQACommon).AccessoryTypeIsIn(RowID,GroupID)	// 20150327  Mozy0153
	.s Desc=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",2)
	.Quit:(AccessoryType'="")&(Desc'[AccessoryType)
	.s Code=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",1)
	.d OutputRowGetAccessoryType
	Quit $$$OK
OutputRowGetAccessoryType
	s Data=$lb(Desc,RowID,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAccessoryType
	s (Desc,RowID,Code)=""
	quit
}

ClassMethod GetAccessoryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
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

ClassMethod GetAccessoryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified By HZY 2011-10-14 HZY0014
/// Desc:添加4种业务类型.
Query GetBussType(vBussTypeDR As %String = "") As %Query(ROWSPEC = "Desc:%String:描述,ID:%String:编码")
{
}

ClassMethod GetBussTypeExecute(ByRef qHandle As %Binary, vBussTypeDR As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    If $g(ind)="" Set ind=1
    
    s ID="0"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="11"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="12"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="21"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="22"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="23"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="31"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="32"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="33"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="34"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="35"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="41"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    s ID="51"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    //add by zy 20120217  ZY0088
    s ID="61"
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
    //Start Add By HZY 2011-10-14 HZY0014
    s ID="91" 
    s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
	s ID="92" 
	s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
	s ID="93" 
	s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
	s ID="94" 
	s Desc=..GetBussTypeDesc(ID)
    i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
	//End Add By HZY 2011-10-14 HZY0014
	
	//Add BY HZY 2012-03-12 HZY0024
	s ID="62" 
	s Desc=..GetBussTypeDesc(ID)
	i (vBussTypeDR="")||(vBussTypeDR=ID) Do OutputRowGetBussType
	
	Quit $$$OK
    
OutputRowGetBussType
	set Data=$lb(Desc,ID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBussTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussTypeExecute ]
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

ClassMethod GetBussTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*
ClassMethod GetBussTypeDesc(ID)
{
	i ID="0" q "无"
	i ID="11" q "开箱验收"
	i ID="12" q "安装调试验收"
	i ID="21" q "入库"
	i ID="22" q "转移"
	i ID="23" q "减少"
	i ID="31" q "维修"
	i ID="32" q "保养"
	i ID="33" q "检查"
	i ID="34" q "报废"
	i ID="35" q "折旧"
	i ID="41" q "使用"
	i ID="51" q "设备调帐"
	i ID="61" q "工程记录"   //add by zy 20120217  ZY0088
	i ID="91" q "采购申请"
	i ID="92" q "采购计划"
	i ID="93" q "采购招标"
	i ID="94" q "采购合同"
	
	//Add BY HZY 2012-03-12 HZY0024
	i ID="62" q "研究课题"	
	q "未定义"
}
*/
/// modified by czf 2014955 2021-07-04 增加55拆分
ClassMethod GetBussTypeDesc(ID)
{
	q $CASE(ID,
              "":"未定义","0":"无",
              "11":"开箱验收","12":"安装调试验收",
              "21":"入库","22":"转移","23":"减少",
              "31":"维修","32":"保养","33":"检查","34":"报废","35":"折旧",
              "41":"使用","51":"设备调帐","52":"设备台帐","55":"设备拆分",
              "61":"工程记录","62":"科研课题",
              "63-1":"供应商资质","63-2":"生产厂商资质","63-3":"计量证书",
              "64":"租赁","65":"配送","66":"发票",  //add by zx 2017-04-20 Bug ZX0038
              "71":"保养预警","72-1":"计量检查","72-2":"巡检","73":"保修到期","75":"采购合同到货","76":"计划付款","81":"维修监控","82":"设备鉴定报告",	//Mozy0226	2019-9-22
              "91":"采购申请","92":"采购招标","93":"采购合同","94":"采购合同","94-1":"采购合同明细","95":"保修合同","95-1":"保修合同明细",		// MZY0095	2021-09-15
              "A01":"配件入库","A02":"配件转移","A03":"配件退货","A04":"配件减少")
    /*
    s BTDesc="未定义"
    i ID'="" 
    {
	    s BTRowID=$o(^DHCEQCCode("DHCEQCBussType",0,"Code",ID,0))
	    i BTRowID'="" s BTDesc=$p($g(^DHCEQCCode("DHCEQCBussType",BTRowID)),"^",2)
    }
    q BTDesc
    */
}

/// add：ZY 2011-03-22   ZY0066
/// Desc：Status的四个状态,元素是CUSTOM型
/// -------------------------------
ClassMethod GetStatusDiplay(name, width) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //hisui改造 modified by czf 20180929
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>新增</option>"
	w "<option value=1>提交</option>"
	w "<option value=2>审核</option>"
	w "</select>",!
}

/// 输出标准代码表的 下拉框
/// 参数：
/// name:界面元素名字
/// width:生成下拉框的宽度
/// node:代码表的名称,区分大小写,不带下划线,如DHCEQCBuyType
/// invalidPos:无效标志 字段 在global中的位置,标准代码的InvalidFlag默认位置是4
/// 输出：对应数据的下拉框的html
/// -------------------------------
ClassMethod CreateCboCode(name, width, node, invalidPos As %Library.String = "4") As %String
{
	n rowid
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;' class='hisui-combobox'>"	//hisui改造 add by CZF 20180831
	;modify by lmm 2019-09-05 修改下拉列表必填提示
	if (width="")||(width=0) s width=155	//modified by czf 20181211
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	s rowid=0
	f  s rowid=$o(^DHCEQCCode(node,rowid))  quit:(rowid="")  d
	.q:$p(^DHCEQCCode(node,rowid),"^",invalidPos)="Y"
	.w "<option value="_rowid_">"_$p($g(^DHCEQCCode(node,rowid)),"^",2)_"</option>"
	w "</select>",!
}

/// modified by ZY 20220927  修改global
/// Mozy0068	2011-11-09
/// 获取医院信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","GetHospital")
Query GetHospital(Hospital As %Library.String = "", CurGorupID As %String = "") As %Query(ROWSPEC = "Desc:%String:描述,Hidden:%String,Code:%String:编码")
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

/// Add By DJ 2012-02-29
Query GetCodeTable(CodeTable) As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetCodeTableExecute(ByRef qHandle As %Binary, CodeTable) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetCodeTable
	Quit $$$OK
BuildDataGetCodeTable
 	i CodeTable="" q
	f  s rowid=$o(^DHCEQCCode(CodeTable,rowid))  quit:rowid=""  d
	.d ResetVariablesGetCodeTable
	.s InvalidFlag=$p($g(^DHCEQCCode(CodeTable,rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s RowID=rowid
	.s Code=$p($g(^DHCEQCCode(CodeTable,rowid)),"^",1)
	.s Desc=$p($g(^DHCEQCCode(CodeTable,rowid)),"^",2)
	.d OutputRowGetCodeTable
	quit
OutputRowGetCodeTable
	s Data=$lb(RowID,Code,Desc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCodeTable
	quit
}

ClassMethod GetCodeTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCodeTableExecute ]
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

ClassMethod GetCodeTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCodeTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// by marui  2014-04-04  MR0013
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","GetEquipCostAllot","","","")
/// Flag:"Y":只显示分摊比例不为1的设备
Query GetEquipCostAllot(Type As %Library.String = "", EquipNo As %Library.String = "", Flag As %Library.String = "") As %Query(ROWSPEC = "TEquipDR:%String,TEquipNo:%String,TEquipName:%String,TEquipUseLoc:%String,TType:%String,TTypeDR:%String,TotalPercentNum:%String")
{
}

ClassMethod GetEquipCostAllotExecute(ByRef qHandle As %Binary, Type As %Library.String = "", EquipNo As %Library.String = "", Flag As %Library.String = "") As %Status
{
	new repid, index,rowid,locdr
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s EquipTypeIDS=##Class(web.DHCEQCommon).GetEquipTypesByGroup() //2010-06-29 党军
 	i EquipTypeIDS="" Quit $$$OK //2010-06-29 党军
 	s EquipTypeIDS="^"_EquipTypeIDS_"^"
	
	s rowid=0
	f  s rowid=$O(^DHCEQCostAllot(rowid))  quit:rowid=""  d
	.s DataInfo=$G(^DHCEQCostAllot(rowid))
	.d CheckData
	.q:passed=0
	.s CALRowID=0
	.s TotalPercentNum=0
	.f  s CALRowID=$O(^DHCEQCostAllotList(0,"CostAllotDR",rowid,CALRowID))  quit:CALRowID=""  d
	..s AllotPercentNum=$P($G(^DHCEQCostAllotList(CALRowID)),"^",3)
	..s TotalPercentNum=TotalPercentNum+AllotPercentNum
	.q:(Flag="on")&&(TotalPercentNum=100)
	.d OutputRow
	
	Quit $$$OK
CheckData
	s passed=0
	s InvalidFlag=$P(DataInfo,"^",2)
	i InvalidFlag="Y" quit
	s TTypeDR=$P(DataInfo,"^",15)
	i (Type'="")&&(TTypeDR'[Type)  {quit}
	s TType= $CASE(TTypeDR,"":"全部","1":"折旧","2":"维修","3":"保养","4":"检查","5":"其他支出")
	s TEquipDR=$P(DataInfo,"^",13)
	s TEquipType=$P($G(^DHCEQEquip(TEquipDR)),"^",63)
	i (EquipTypeIDS'="")&&(EquipTypeIDS'[TEquipType)  {quit}
	s CommonageFlag=$P($G(^DHCEQEquip(TEquipDR)),"^",82)
	i CommonageFlag'="Y"  {quit}
	s TEquipNo=$P($G(^DHCEQEquip(TEquipDR)),"^",71)
	s TEquipName=$P($G(^DHCEQEquip(TEquipDR)),"^",1)
	s TEquipCode=$P($G(^DHCEQEquip(TEquipDR)),"^",6)
	s TEquipUseLocDR=$P($G(^DHCEQEquip(TEquipDR)),"^",19)
	i TEquipUseLocDR'=""  d
	.s TEquipUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TEquipUseLocDR)
	i (EquipNo'="")&&(TEquipNo'[EquipNo)&&(TEquipName'[EquipNo)&&(TEquipCode'[EquipNo)  {quit}

	s passed=1
	quit
	
OutputRow
	s Data=$lb(TEquipDR,TEquipNo,TEquipName,TEquipUseLoc,TType,TTypeDR,TotalPercentNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEquipCostAllotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipCostAllotExecute ]
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

ClassMethod GetEquipCostAllotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipCostAllotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// by marui   MR0013  
/// 分摊类型
ClassMethod GetCostAllotTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>折旧</option>"
	w "<option value=2>维修</option>"
	w "<option value=3>保养</option>"
	w "<option value=4>检查</option>"
	w "<option value=5>其他支出</option>"
	w "</select>",!
}

/// 2014-08-21 DJ0126
/// 新旧程度
ClassMethod GetNewOldPercent(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>全新</option>"
	w "<option value=1>九成新</option>"
	w "<option value=2>八成新</option>"
	w "<option value=3>七成新</option>"
	w "<option value=4>六成新</option>"
	w "<option value=5>五成新</option>"
	w "<option value=10>旧设备</option>"
	w "</select>",!
}

/// 运行状态
ClassMethod GetRunStatus(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>关机</option>"
	w "<option value=1>待机</option>"
	w "<option value=2>工作中</option>"
	w "</select>",!
}

/// 故障状态
ClassMethod GetFaultStatus(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>完好</option>"
	w "<option value=1>部分可用</option>"
	w "<option value=2>不可用</option>"
	w "</select>",!
}

/// Add By DJ 2014-09-25
/// 维修评价分值登记
ClassMethod ScoreList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=0>0</option>"
	w "<option value=1>1</option>"
	w "<option value=2>2</option>"
	w "<option value=3>3</option>"
	w "<option value=4>4</option>"
	w "<option value=5>5</option>"
	w "<option value=6>6</option>"
	w "<option value=7>7</option>"
	w "<option value=8>8</option>"
	w "<option value=9>9</option>"
	w "<option value=10>10</option>"
	w "</select>",!
}

/****************************************************/
Query MaintGroup(vType As %String = "", vDesc As %String = "", vUserDR As %String = "") As %Query(ROWSPEC = "TDesc:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod MaintGroupExecute(ByRef qHandle As %Binary, vType As %String = "", vDesc As %String = "", vUserDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	K ^Temp("DHCEQMCMaintGroup",$J)
	
	s vDesc=$ZCONVERT(vDesc,"U")
	i vUserDR="" s vUserDR=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s MGRowID=0
	f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",vType,vUserDR,MGRowID))  q:MGRowID=""  d
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
	.q:InvalidFlag="Y"
	.s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",3)
	.q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
	.s ^Temp("DHCEQMCMaintGroup",$J,MGRowID)=""
	
	s MGLRowID=0
	f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",vUserDR,MGLRowID))  q:MGLRowID=""  d
	.s MGRowID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",1)
	.s Type=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",1)
	.q:(vType'="")&&(Type'=vType)
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
	.q:InvalidFlag="Y"
	.s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",3)
	.q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
	.s ^Temp("DHCEQMCMaintGroup",$J,MGRowID)=""
	
	s MGRowID=0
	f  s MGRowID=$o(^Temp("DHCEQMCMaintGroup",$J,MGRowID))  q:MGRowID=""  d
	.s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",3)
	.s rowid=MGRowID
	.d OutputRowMaintGroup
	
	k ^Temp("DHCEQMCMaintGroup",$J)
	
	Quit $$$OK
OutputRowMaintGroup
	s Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MaintGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintGroupExecute ]
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

ClassMethod MaintGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetCostAllotType(name, width) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")  //hisui改造 modify by lmm 2018-08-22
	//w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=0>固定比例(%)</option>"
	//w "<option value=1>工作量</option>"
	w "<option value=2>科室面积(M2)</option>"
	w "<option value=3>科室人数(人)</option>"
	w "<option value=4>科室床位(床)</option>"
	w "<option value=5>科室收入(元)</option>"
	w "<option value=6>固定值</option>"		//add by CZF0076 2020-02-26
	w "</select>",!
}

ClassMethod GetDisplayAllotType(ID)
{
	q $CASE(ID,"0":"固定比例(%)","1":"工作量","2":"科室面积(M2)","3":"科室人数(人)","4":"科室床位(床)","5":"科室收入(元)","6":"固定值",:"")		//czf 2100574 2021-09-08
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","Group")
Query Group(name As %String = "") As %Query(ROWSPEC = "GroupName:%String,GroupID:%String")
{
}

/// 根据安全组名来查找安全组
ClassMethod GroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GroupExecute(ByRef qHandle As %Binary, name As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	
 	If $g(ind)="" Set ind=1
	s rowid=0
	s rowids=""
	s name=$ZCONVERT(name,"U")
	/*
	i name'=""
	{
	f  s rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",name,rowid))  q:rowid=""  d
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
	.q:(GroupName="")&($ZCONVERT(GroupName,"U")'[name)
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

/*
 * description 人员lookup元素query
 * param type:设备员工类型代码 name:员工姓名或工号 loc:员工所在科室  equiptype:设备类组  manageloc:员工管理科室
 * author zouxuan 2018-08-14
 * return username:姓名  userid:员工id  initials:工号
*/
/// modified by ZY 20220927  修改global
/// modified by wy 2021-5-6 1877364输出列标题修改,系统配置中已有匹配的输出列优先采用系统匹配的
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","EQUser","","1132")
Query EQUser(type As %String, name As %String = "", loc As %String = "", equiptype As %String = "", manageloc As %String = "") As %Query(ROWSPEC = "UserName:%String:名称,UserID:%String:用户ID,Initials:%String:登录名")
{
}

ClassMethod EQUserExecute(ByRef qHandle As %Binary, type As %String, name As %String = "", loc As %String = "", equiptype As %String = "", manageloc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","")	//CZF0138 2021-05-26
 	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
 	
 	s rowid=0
 	s name=$ZCONVERT(name,"U")
 	k ^TempDHCEQ("EQUser",$j)
 	if (type'="")||(equiptype'="")
 	{
		if (type'="")
		{
			s typeid=##Class(web.DHCEQCommon).GetStandardIDByCode("DHCEQCEmployeeType",type)
			i typeid="" Quit $$$OK
		 	if equiptype'=""
		 	{
			 	f  s rowid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EquipType",typeid,equiptype,rowid)) q:rowid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)="Y"
			 	.s userid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2)
			 	.d OutputRowEQUser
			}
		 	else
		 	{
			 	f  s rowid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EmployeeType",typeid,rowid)) q:rowid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)="Y"
			 	.s userid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2)
			 	.d OutputRowEQUser
			}
		}
		else
		{
			f  s rowid=$o(^DHCEQCCode("DHCEQCTypeEmployee",rowid)) q:rowid=""  d
			.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)="Y"
			.s userequiptype=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)
			.s userid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2)
			.quit:(equiptype'="")&&(equiptype'=userequiptype)
			.d OutputRowEQUser
		}
	}
 	else
 	{
	 	if manageloc'=""
		{
			f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.s userid=rowid
		 	.s hisuserid=$p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",19)
		 	.i $p($g(^SSU("SSUSR",hisuserid)),"^",4)=manageloc d
		 	..d OutputRowEQUser
		 	.s chl=0
		 	.f  s chl=$O(^SSU("SSUSR",hisuserid,"OTHLL",chl)) q:(chl="")  d
		    ..;q:$P(^SSU("SSUSR",rowid,"OTHLL",chl),"^",2)'="86"	//是否在指定安全组内的用户
		    ..q:$P(^SSU("SSUSR",hisuserid,"OTHLL",chl),"^",1)'=manageloc //有指定科室时,判断科室
		    ..d OutputRowEQUser
		}
	 	else
	 	{
		 	f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.s userid=rowid
		 	.Do OutputRowEQUser
		}		
 	}
 	
 	s initials=""
	f  s initials=$o(^TempDHCEQ("EQUser",$j,initials)) q:initials=""  d
	.s userid=0
	.f  s userid=$o(^TempDHCEQ("EQUser",$j,initials,userid)) q:userid=""  d
	..s username=$g(^TempDHCEQ("EQUser",$j,initials,userid))
	..set Data=$lb(username,userid,initials)
 	..Set ^CacheTemp(repid,index)=Data
 	..Set index=index+1
	k ^TempDHCEQ("EQUser",$j)
	
	Quit $$$OK
    
OutputRowEQUser
	s userdata=$g(^DHCEQCCode("DHCEQCUser",rowid))
	q:userdata=""
	
	s initials=$p(userdata,"^",1)
	s username=$p(userdata,"^",4)
	s userloc=$p(userdata,"^",14)
	s OrganizeType=$p(userdata,"^",12)
	s OrganizeID=$p(userdata,"^",13)
	q:(HospFlag=2)&&(OrganizeType=1)&&(sHospID'="")&&(OrganizeID'=sHospID)	//CZF0138 2021-05-26
	q:$d(^TempDHCEQ("EQUser",$j,$ZCONVERT(initials,"U"),userid))
	quit:##Class(web.DHCEQCommon).HospitalIsInclude(userloc)=0
	q:(name'="")&&($ZCONVERT(username,"U")'[name)&&($ZCONVERT(initials,"U")'[name)  //Modified By QW20181030 Bug号:QW0020
	q:(loc'="")&&(userloc'=loc)
	s ^TempDHCEQ("EQUser",$j,$ZCONVERT(initials,"U"),userid)=username
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

/*
 * description 科室人员lookup元素query
 * param Type:所在科室范围代码 LocDesc:科室描述 vgroupid:安全组  LocType:科室类型组  notUseFlag:启用标志 UserID:用户  CurHosptailID:院区  CTLocAllFlag
 * author zouxuan 2018-08-16
*/
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","GetEQLoc","0","","","0101","")
Query GetEQLoc(Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "") As %Query(ROWSPEC = "Desc:%String:描述,Hidden:%String,Code:%String:编码,PYM:%String:拼音码,Tel:%String:电话,Hospital:%String:院区") [ SqlProc ]
{
}

ClassMethod GetEQLocExecute(ByRef qHandle As %Binary, Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","")	//CZF0138 2021-05-26
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	
	s LocTypeID=""
	if LocType'=""     //科室类型
	{
		s LocTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code",LocType,0))
		if LocTypeID="" Quit $$$OK
	}	
	
	if (Type="0")||(Type="")  //所有科室
	{
		s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		s LGTLocRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0102",0))
		f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:rowid=""  d
		.s locid=rowid
		.s StoreFlag=""
		.s LocFlag=""
		.i LGTStoreRowID'="" s StoreFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,locid))
		.i LGTLocRowID'="" s LocFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTLocRowID,locid))
		.q:((CTLocAllFlag'="Y")&&(StoreFlag=0)&&(LocFlag=0))
		.d GetOneLoc
	}
	if Type="1"  //安全组科室
	{
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		s StoreDR=0
		f  s StoreDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,StoreDR))  q:StoreDR=""  d
		.s StoreHospDR=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreDR)),"^",8)
		.s GroupHospIDs=##Class(web.DHCEQCommon).GetHospIDSByGroup(vgroupid)
		.q:GroupHospIDs'[("^"_StoreHospDR_"^")
		.s locid=StoreDR
		.d GetOneLoc
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",StoreDR,locid)) q:(locid="")||(LocType="0101")  d
		..d GetOneLoc
		
	}
	if Type="2" //本科室
	{
		s rowid=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		s locid=rowid
		d GetOneLoc
	}
	
	s locdesc=""
	f  s locdesc=$o(^TempDHCEQ("LocTemp",$j,locdesc)) q:locdesc=""  d
	.s locid=0
	.f  s locid=$o(^TempDHCEQ("LocTemp",$j,locdesc,locid)) q:locid=""  d
	..s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", locid)
	..s code=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode", locid)
	..s tel= ##Class(web.DHCEQCLocType).GetEQLocDetailByID("", "", locid)	;取科室类型表电话
	..s tel=$p(tel,"^",17)
	..d OutputRowGetEQLoc
	k ^TempDHCEQ("LocTemp",$j)
	
	Quit $$$OK

GetOneLoc
	;当前登录人是否有权限查看表数据 CZF0138
	s DeptOrganizeType = $p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",7)
	s DeptOrganizeID = $p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",8)
	q:(HospFlag=2)&&(DeptOrganizeType=1)&&(sHospID'="")&&(DeptOrganizeID'=sHospID)
	
	//分院区管理,通过科室的医院属性来管理
	s HIIFlag=1
	i '((CurHosptailID=0)&&(LocType="0101"))  d		//转移单为库房调配时接收部门可选择所有库房
	.s HIIFlag=##Class(web.DHCEQCommon).HospitalIsInclude(locid,vgroupid,CurHosptailID)
	quit:HIIFlag=0
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit(UserID,vgroupid,"","","","",locid))
	q:(($p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",19))="Y")  //add by jyp 2019-01-11
	s code=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode", locid)
	s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", locid)
	
	//czf 20210430
	s AText=""
	s ARowID=##Class(web.DHCEQ.Plat.CTAlias).GetAlias("DHCEQCDepartment",locid,"text","PYCode")
	i ARowID'="" s AText=$p($g(^DHCEQCCode("DHCEQCAlias",ARowID)),"^",1)
	i AText="" s AText=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")
	
	s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",13)
	q:(notUseFlag'="")&&(NotUse="Y")
	s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",18)
	q:((notUseFlag'="")&&(+DATo'=0)&&(+DATo<+$H))
	s LocDesc=$ZCONVERT(LocDesc,"U")
	q:($ZCONVERT(desc,"U")'[LocDesc)&&($ZCONVERT(code,"U")'[LocDesc)&&($ZCONVERT(AText,"U")'[LocDesc)    //增加拼音码过滤
	if LocTypeID'=""     //库房类型
	{
		if '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeID,locid)) q
	}
	
	s ^TempDHCEQ("LocTemp",$j,$ZCONVERT(desc,"U"),locid)=""
	quit
OutputRowGetEQLoc
	s pym=""		//czf 20210430
	s ARowID=##Class(web.DHCEQ.Plat.CTAlias).GetAlias("DHCEQCDepartment",locid,"text","PYCode")
	i ARowID'="" s pym=$p($g(^DHCEQCCode("DHCEQCAlias",ARowID)),"^",1)
	i pym="" s pym=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")
	s (detail,hospital)=""
	s detail= ##Class(web.DHCEQCLocType).GetEQLocDetailByID("", "", locid)
	s hospital=$p(detail,"^",3)
	s desc=##class(web.DHCEQCommon).GetSplitDataByFlag(desc,"-")
	s Data=$lb(desc,locid,code,pym,tel,hospital)
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

/// add by csj 20191203 
/// 描述：根据付款来源取设备或配件类组
/// 入参：PayRequestType 业务类型, GroupID 安全组, PayFromType：付款来源
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","GetPayEquipType","专用","85","12")
Query GetPayEquipType(PayRequestType As %Library.String = "", GroupID As %Library.String = "", PayFromType As %String = "") As %Query(ROWSPEC = "Desc:%String:名称,Hidden:%String,Code:%String:编码")
{
}

ClassMethod GetPayEquipTypeExecute(ByRef qHandle As %Binary, PayRequestType As %Library.String = "", GroupID As %Library.String = "", PayFromType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	if PayFromType=3 //配件类组
	{
		f  s rowid=$o(^DHCEQCCode("DHCEQCAccessoryType",rowid))  q:rowid=""  d
		.d ResetVariablesGetPayEquipType
		.s RowID=rowid
		.Quit:##Class(web.DHCEQACommon).AccessoryTypeIsIn(RowID,GroupID)	// 20150327  Mozy0153
		.s Desc=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",2)
		.Quit:(PayRequestType'="")&(Desc'[PayRequestType)
		.s Code=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",1)
		.d OutputRowGetPayEquipType
	}
	else
	{
		s Type=##class(web.DHCEQCommon).GetEquipTypesByGroup(GroupID) //add by zx 2017-03-20 BUG ZX0036
		if (Type="")  //所有类组
		{
			q
		}
		else  //可访问类组
		{
			s i=$l(Type,"^")
			for j=1:1:i
			{
				s rowid=$p(Type,"^",j)
				d ResetVariablesGetPayEquipType
				s RowID=rowid
				d GetEquipType
			}
		}
	}
	quit $$$OK
	
GetEquipType
	s locid=rowid
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",locid))
	s Desc=$p(^DHCEQCCode("DHCEQCEquipType",locid),"^",2)
	s Code=$p(^DHCEQCCode("DHCEQCEquipType",locid),"^",1)
	s Invaild=$p(^DHCEQCCode("DHCEQCEquipType",locid),"^",4)
	q:Invaild="Y"
	q:(Desc'[PayRequestType)&&(Code'[PayRequestType)
	d OutputRowGetPayEquipType
	Quit $$$OK
OutputRowGetPayEquipType
	s Data=$lb(Desc,RowID,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPayEquipType
	s (Desc,RowID,Code)=""
	quit
}

ClassMethod GetPayEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
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

ClassMethod GetPayEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCEQFindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQFindD</DataLocation>
<DefaultData>DHCEQFindDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEQFindD</IdLocation>
<IndexLocation>^web.DHCEQFindI</IndexLocation>
<StreamLocation>^web.DHCEQFindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
