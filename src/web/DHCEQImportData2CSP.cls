/// --------------------------------
/// Add By HZY 2013-4-15 
/// 增加方法:BuildingUnit
/// 描述:导入房屋单元信息
/// -------------------------------
/// 添加：zy 2010-07-26  ZY0025
/// 增加方法:StoreManageLoc
/// 描述：导入库房管理科室数据
/// -------------------------------
/// 修改：JDL 2009-09-8  JDL0025
/// 增加方法:AffixInfo,ChangeAccountInfo
/// 描述:导入设备附件信息以及设备调账信息
/// -------------------------------
/// 修改：Mzy0018 2009-07-18
/// 增加方法:ContrastInfo
/// 描述:导入对照类型信息
/// -----------------------------------------
/// 修改人： JDL 2009-06-23
/// 修改目的：解决JDL0018,增加供应商分类的处理。
/// 修改内容：修改方法APCVendor
/// -----------------------------------------
Class web.DHCEQImportData2CSP Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod SetGloble(RowStr) As %String
{
	s TmpStr=RowStr
	q:TmpStr="" ""
	s num=$l(TmpStr,"^"),i=0
	S PatNo=$p(TmpStr,"^")
	S ^FHQIQIQ("DATA")=$I(^FHQIQIQ("DATA"))
	s ^FHQIQIQ0109(PatNo)=TmpStr
	Q ""
}

ClassMethod UpData(ChangeType As %String = "", RowStr As %String = "", UpType As %String = "", Para As %String = "") As %String
{
	q:UpType=""
	s RetStr=""
	if Para'=""  d
	.s DateStr=$p(Para,"^")
	else  d
	.s DateStr=""
	
	s:UpType="CTCOUNTRY" RetStr=..Country(ChangeType,RowStr)
	s:UpType="CTUOM" RetStr=..UOM(ChangeType,RowStr)	
	s:UpType="APCVendor" RetStr=..APCVendor(ChangeType,RowStr)
	s:UpType="EQUIPTYPE" RetStr=..EquipType(ChangeType,RowStr)
    s:UpType="ORIGIN" RetStr=..Origin(ChangeType,RowStr)
	s:UpType="PURPOSETYPE" RetStr=..PurposeType(ChangeType,RowStr)
    s:UpType="EQUIPCAT" RetStr=..EquipCat(ChangeType,RowStr)
	s:UpType="MANUFACTURER" RetStr=..Manufacturer(ChangeType,RowStr)
	s:UpType="FROMTODEPT" RetStr=..FromToDept(ChangeType,RowStr)
    s:UpType="MASTERITEM" RetStr=..MasterItem(ChangeType,RowStr)
    s:UpType="UpdateMasterItem" RetStr=..UpdateMasterItem(ChangeType,RowStr)
    
	s:UpType="MODEL" RetStr=..Model(ChangeType,RowStr)
	s:UpType="EQUIP" RetStr=..Equip(ChangeType,RowStr)
	Set:UpType="ContrastInfo" RetStr=..ContrastInfo(ChangeType,RowStr)
	s:UpType="AffixInfo" RetStr=..AffixInfo(ChangeType,RowStr)
	s:UpType="ChangeAccountInfo" RetStr=..ChangeAccountInfo(ChangeType,RowStr)
	s:UpType="COLUMNS" RetStr=..ImportColumns(ChangeType,RowStr)
	s:UpType="LocType" RetStr=..LocType(ChangeType,RowStr)
	
	s:UpType="UserDefine" RetStr=..ImportDefineData(ChangeType,RowStr)
	s:UpType="Tree" RetStr=..Tree(ChangeType,RowStr)
	s:UpType="StoreManageLoc" RetStr=..StoreManageLoc(ChangeType,RowStr)
	s:UpType="TreeMap" RetStr=..TreeMap(ChangeType,RowStr)
	s:UpType="DeviceMap" RetStr=..DeviceMap(ChangeType,RowStr)
	
	s:UpType="EquipServiceItem" RetStr=..EquipServiceItem(ChangeType,RowStr)
	s:UpType="EquipServiceDetails" RetStr=..EquipServiceDetails(ChangeType,RowStr)
	s:UpType="BatchDisuseRequest" RetStr=..BatchDisuseRequest(ChangeType,RowStr)
	s:UpType="ServiceItemAndDetItemByCode" RetStr=..ServiceItemAndDetItemByCode(ChangeType,RowStr)
	s:UpType="ConsumableItemByCode" RetStr=..ConsumableItemByCode(ChangeType,RowStr)
	s:UpType="Location" RetStr=..Location(ChangeType,RowStr)
	
	/// Add by JDL 2012-2-9 JDL0115 调整分类
	s:UpType="AdjustCat" RetStr=##Class(web.DHCEQAdjustDataEX).AdjsutEquipCat(ChangeType,RowStr)
	s:UpType="BuildingUnit" RetStr=..BuildingUnit(ChangeType,RowStr)
	/// 2014-7-24 HZY0057 盘点结果导入
	s:UpType="InventoryResult" RetStr=..InventoryResult(ChangeType,RowStr)
	
	///根据菜单Name更新菜单信息 add by GR0022 2015-01-15
	s:UpType="websysMenuD" RetStr=..websysMenuDResult(ChangeType,RowStr)
	
	///经费来源导入 add by Mozy0154 2015-08-11
	s:UpType="Expenditures" RetStr=..Expenditures(ChangeType,RowStr)
	///品牌导入 Add By DJ 2015-08-21 DJ0157
	s:UpType="Brand" RetStr=..Brand(ChangeType,RowStr)
	///安全组菜单权限导入 Add By DJ 2015-09-09 DJ0162
	s:UpType="GroupMenu" RetStr=..GroupMenu(ChangeType,RowStr)
	s:UpType="AccessoryCat" RetStr=..AccessoryCat(ChangeType,RowStr)
	s:UpType="AccessoryItem" RetStr=..AccessoryItem(ChangeType,RowStr)
	s:UpType="Accessory" RetStr=..Accessory(ChangeType,RowStr)
	s:UpType="UpdateLeaveFactoryNo" RetStr=..UpdateLeaveFactoryNo(ChangeType,RowStr)
	s:UpType="UpdateDisusedDate" RetStr=..UpdateDisusedDate(ChangeType,RowStr)
	s:UpType="UpdateHisData" RetStr=..UpdateHisData(ChangeType,RowStr)
	s:UpType="EQInvalid" RetStr=..EQInvalid(ChangeType,RowStr)
	s:UpType="ComponentInfo" RetStr=..ComponentInfo(ChangeType,RowStr)
	s:UpType="UpdateComponentInfo" RetStr=..UpdateComponentInfo(ChangeType,RowStr)
	/// 标准设备项导入 Add by CZF 2017-12-18
	s:UpType="Hospital" RetStr=..Hospital(ChangeType,RowStr)
	s:UpType="KBMstItem" RetStr=..KBMstItem(ChangeType,RowStr,0)		//插入标准设备项
	s:UpType="UpdateKBMstItem" RetStr=..UpdateKBMstItem(ChangeType,RowStr)
	s:UpType="MatchCatEquip" RetStr=..MatchCatEquip(ChangeType,RowStr)
	s:UpType="UpdHospKBMstItem" RetStr=..KBMstItem(ChangeType,RowStr,1)		//更新整个项目标准设备项
	s:UpType="ComponentParasInfo" RetStr=..ComponentParasInfo(ChangeType,RowStr)  //modify by lmm 2018-09-29
	s:UpType="UpdateComponent" RetStr=..UpdateComponent(ChangeType,RowStr)
	s:UpType="UpdateComponentItem" RetStr=..UpdateComponentItem(ChangeType,RowStr)
	s:UpType="UpdCompMeassage" RetStr=..UpdCompMeassage(ChangeType,RowStr)
	s:UpType="UpdateMenu" RetStr=..UpdateMenu(ChangeType,RowStr)
	s:UpType="ChangeAccount" RetStr=..ChangeAccount(ChangeType,RowStr)		//add by czf 20190126 批量设备调账
	
	s:UpType="InsertDepartment" RetStr=..InsertDepartment(ChangeType,RowStr)  //add by zx 2019-05-28 升级时生成科室
	s:UpType="InsertUser" RetStr=..InsertUser(ChangeType,RowStr)  //add by zx 2019-05-28 升级时生成人员
	
	s:UpType="MaintItem" RetStr=..MaintItem(ChangeType,RowStr)		//add by zc0052 20191030 保养项目导入
	s:UpType="PMReport" RetStr=..PMReport(ChangeType,RowStr)		//add by zc0052 20191030 保养模板导入
	s:UpType="PMMaintItem" RetStr=..InsertMaintItem(ChangeType,RowStr)	// MZY0076	2021-05-25
	//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s:UpType="FinaceItem" RetStr= ..FinaceItem(ChangeType,RowStr)
	s:UpType="FunctionCat" RetStr= ..FunctionCat(ChangeType,RowStr)
	s:UpType="UpdateFunds" RetStr= ..UpdateFunds(ChangeType,RowStr)
	//End By QW 20190410 BUG:QW0027
	s:UpType="LocCostAllot" RetStr=..LocCostAllot(ChangeType,RowStr)	//add by czf 2020-02-20 CZF0054 科室分摊数据导入
	s:UpType="InHospitalType" RetStr=..InHospitalType(ChangeType,RowStr)	//add by zx 2020-02-21 BUG ZX0077 设备属性分类
	s:UpType="DHCEQCSysSet" RetStr=..DHCEQCSysSet(ChangeType,RowStr)		//add by lmm 2020-03-19
	s:UpType="GroupMenu" RetStr=..DHCEQGroupMenu(ChangeType,RowStr)
	s:UpType="ImportMenu" RetStr=..DHCEQImportMenu(ChangeType,RowStr)
	//Modify by zx 2020-09-15 功能模块菜单导入
	s:UpType="SysMenus" RetStr=..SysMenus(ChangeType,RowStr)
	s:UpType="MaintPlan" RetStr=..MaintPlan(ChangeType,RowStr)  //add by CSJ 2019-11-13 导入维护计划记录
	s:UpType="ImOtherCode" RetStr=..ImOtherCode(ChangeType,RowStr)  //add by wy 2020-9-24 导入动态库资产编码
	s:UpType="FacEquip" RetStr=..FacEquip(ChangeType,RowStr)  ///Modefied by zc0087 2020-11-30 简易台账导入
	s:UpType="UpdEquipCat" RetStr=..UpdEquipCat(ChangeType,RowStr)	//czf 2021-04-14 1836998，1836979
	s:UpType="ComponentItemVisit" RetStr=..ComponentItemVisit(ChangeType,RowStr)	//Add by ZY0271 20210621
	s:UpType="UpdKBSMstItem" RetStr=..UpdKBSMstItem(ChangeType,RowStr)	//czf 2021-12-02 更新标准设备项库数据
	s:UpType="EquipAttribute" RetStr=..EquipAttribute(ChangeType,RowStr)	//czf 2022-03-31 设备属性导入
	s:UpType="UPDVendor" RetStr=..UPDVendor(ChangeType,RowStr)		//czf 2022-09-15 供应商
	s:UpType="AppendFile" RetStr=..AppendFile(ChangeType,RowStr)	//czf 2022-09-18 电子资料
	s:UpType="OpenCheckList" RetStr=..OpenCheckList(ChangeType,RowStr)	//czf 2022-09-25 验收单明细
	s:UpType="UpdateDepreInfo" RetStr=..UpdateDepreInfo(ChangeType,RowStr)
	s:UpType="UpdEquipCatYears" RetStr=..UpdEquipCatYears(ChangeType,RowStr)	//czf 2023-04-04
	Quit RetStr
}

/// 根据菜单Name更新菜单信息 add by GR0022 2015-01-15
ClassMethod websysMenuDResult(ChangeType As %String = "", RowStr As %String = "")
{
	///IF ChangeType="Clear" K ^CT("COU")
	q:ChangeType="Clear" "websys.Menu数据不能清除"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s OldName=$p(RowStr,del,7)
 	s:OldName="" RetStr=..RetErrorValue(RetStr,"旧菜单名不能为空:")
 	s OldCaption=$p(RowStr,del,8)
 	s:OldCaption="" RetStr=..RetErrorValue(RetStr,"旧菜单标题不能为空:")
 	;s OldSubMenuName=$p(RowStr,del,9)
 	s OldMenuid=""
 	&SQL(select ID into :OldMenuid from websys.Menu where Name=:OldName)
 	s:OldMenuid="" RetStr=..RetErrorValue(RetStr,"旧菜单未找到，oldname:"_OldName)
 	q:RetStr'="" RetStr
 	
 	s NewSubMenuid=""
 	s Name=$p(RowStr,del,1)
 	s:Name="" RetStr=..RetErrorValue(RetStr,"新菜单名不能为空:")
 	s NewMenuid=""
 	&SQL(select ID into :NewMenuid from websys.Menu where Name=:Name)		//GR0022 2015-01-27防止新菜单名与老菜单名冲突
 	s:((NewMenuid'="")&&(NewMenuid'=OldMenuid)) RetStr=..RetErrorValue(RetStr,"新菜单名与老菜单名冲突:"_Name)
 	s Caption=$p(RowStr,del,2)
 	s:Caption="" RetStr=..RetErrorValue(RetStr,"新菜单标题不能为空:")
 	s SubMenuName=$p(RowStr,del,3)
 	i SubMenuName'="" d
 	.&SQL(select ID into :NewSubMenuid from websys.Menu where Name=:SubMenuName)
 	.s:NewSubMenuid="" RetStr=..RetErrorValue(RetStr,"新父菜单未找到，NewSubMenuname:"_SubMenuName)
 	s Sequence=$p(RowStr,del,4)
 	s Image=$p(RowStr,del,5)
 	s Type=$p(RowStr,del,6)
 	q:RetStr'="" RetStr
 	
 	if ChangeType'="Test" d
 	.i $d(^websys.MenuD(OldMenuid)) d
 	..&SQL(Update websys.Menu (SubMenuOf,Sequence,Caption,Name,Type,Image) values (:NewSubMenuid,:Sequence,:Caption,:Name,:Type,:Image) where ID=:OldMenuid)
 	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"InsertErr: Code="_RowStr_" SQLCODE="_SQLCODE)
 	
 	q:RetStr="" "OK"
	q RetStr
}

/// 导入国别表
ClassMethod Country(ChangeType As %String = "", RowStr As %String = "")
{
	///IF ChangeType="Clear" K ^CT("COU")
	q:ChangeType="Clear" "CT_Country数据不能清除"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空CT_Country:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空CT_Country:")
 	if RetStr'="" q RetStr
 	
 	i $d(^CT("COU",0,"Code",$$ALPHAUP^SSUTIL4(code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在CT_Country:"_code)
 	i $d(^CT("COU",0,"Desc",$$ALPHAUP^SSUTIL4(desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在CT_Country:"_desc)
 	if RetStr'="" q RetStr
 	if ChangeType'="Test" d
 	.s DataForm=+$H
 	.&SQL(Insert into sqluser.CT_Country (CTCOU_Code,CTCOU_Desc,CTCOU_Active,CTCOU_DateActiveFrom) values (:code,:desc,'Y',:DataForm) )
 	.i SQLCODE s RetStr=..RetErrorValue(RetStr,"InsertErr: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
 	
 	q:RetStr="" "OK"
	q RetStr
}

/// Modified By jdl 20150906 v4.1.0 单位改为存储DHC_EQCUOM表中，不再存储CT_UOM中
/// 导入单位表
ClassMethod UOM(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" K ^DHCEQCCode("DHCEQCUOM")
	q:ChangeType="Clear" "数据已清:设备单位(DHC_EQCUOM)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2),type=$p(RowStr,del,3)
 	s rowid=$p(RowStr,del,4)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCUOM:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCUOM:")
 	if type="设备单位"  d
 	.s type=2 
 	e  i type="工作量单位"  d
 	.s type=1
 	e  i type'=""  d
 	.s RetStr=..RetErrorValue(RetStr,"单位类型填写不正确(工作量单位或设备单位):")
 	e  d
 	.s RetStr=..RetErrorValue(RetStr,"单位类型不能为空(工作量单位或设备单位):")
 	if RetStr'="" q RetStr
 	
 	s uomdr=""
 	&SQL(Select UOM_rowid into :uomdr from SQLUSER.DHC_EQCUOM where UOM_UOMType=:type and UOM_Desc=:desc) 	
 	i (uomdr'="") s RetStr=..RetErrorValue(RetStr,"单位已经存在:"_desc)
 	if RetStr'="" q RetStr 	
 	
 	if ChangeType="Test"
 	{
	 	q:RetStr="" "OK"
		q RetStr
	}
	i rowid'="" s ^DHCEQCCode("DHCEQCUOM",0)=rowid-1
	&SQL(Insert into SQLUSER.DHC_EQCUOM(UOM_UOMType,UOM_Code,UOM_Desc,UOM_InvalidFlag) values (:type,:code,:desc,'N'))
 	i SQLCODE s RetStr=..RetErrorValue(RetStr,"InsertErr: 单位="_desc_" Type="_type_" SQLCODE="_SQLCODE)
 	
 	q:RetStr="" "OK"
	q RetStr
}

/// /导入供应商
ClassMethod APCVendor(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//2010-10-13 Add By DJ 设备专用供应商表导入数据
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCVendor")
	q:ChangeType="Clear" "数据已清:供应商(DHC_EQCVendor)"
	s del="^",RetStr=""
	
	//SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1) //编码
 	s code=##class(web.DHCEQCommon).Trim(code)
 	s desc=$p(RowStr,del,2) //名称
 	s desc=##class(web.DHCEQCommon).Trim(desc)
 	s address=$p(RowStr,del,3) //地址
 	s zipcode=$p(RowStr,del,4) //邮编
 	s contperson=$p(RowStr,del,5) //联系人
 	s tel=$p(RowStr,del,6) //联系电话
 	s fax=$p(RowStr,del,7) //传真
 	s remark=$p(RowStr,del,8) //备注
 	s shname=$p(RowStr,del,9)
 	s bank=$p(RowStr,del,10)	//开户行
 	s bankno=$p(RowStr,del,11)	//帐号
 	s OldRowID=$p(RowStr,del,12)	//旧版本RowID
 	i OldRowID'="" s ^DHCEQCCode("DHCEQCVendor",0)=OldRowID-1
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCVendor:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCVendor:")
 	if RetStr'="" q RetStr
 	
 	s desc=$ZCONVERT(desc,"U")
	s FirmType=2
	s tmpid=""
 	&SQL(Select v_rowid into :tmpid from SQLUSER.DHC_EQCVendor where v_name=:desc and v_invalidflag='N')		//modified by CZF0105 begin
 	i tmpid'=""
	{
		s fctmpid=""
		&SQL(Select FC_rowid into :fctmpid from SQLUSER.DHC_EQCFirmContrast where fc_firmdr=:tmpid and fc_firmtype=:FirmType)
		i fctmpid'="" q ..RetErrorValue(RetStr,"名称已经存在DHC_EQCVendor:"_desc)
	}
	
	if ChangeType'="Test"
	{
		s $ZT="ErrorSaveVendor"
		TStart
		k PLIST
		s PLIST(2) = code
	  	s PLIST(3) = desc 
		s PLIST(4) = address
		s PLIST(8) = zipcode
		s PLIST(9) = contperson
		s PLIST(10) = tel
		s PLIST(11) = fax
		s PLIST(12) = shname
		s PLIST(14) = bank
		s PLIST(15) = bankno
		s PLIST(20) = "N"
		s PLIST(23) = FirmType
		
		if tmpid=""
		{
			&SQL(Insert Into SQLUSER.DHC_EQCVendor Values :PLIST())
		}
		else
		{
			s VHold3=$p($g(^DHCEQCCode("DHCEQCVendor",tmpid)),"^",22)
			i VHold3="" s PLIST(23)=FirmType
			e  s PLIST(23)=VHold3_","_FirmType
			&SQL(update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID=:tmpid)
		}
		if SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
		}
		s VRowID=$g(%ROWID)
		
		&SQL(Insert Into SQLUSER.DHC_EQCFirmContrast(FC_FirmType,FC_FirmDR,FC_InvalidFlag) Values (:FirmType,:VRowID,'N'))
		if SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
		}
		
		TCommit
		q "OK"
		
ErrorSaveVendor
		TRollBack	
		Set ErrorMsg=$ZE	//得到系统返回的错误消息
		q ..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" ErrorMsg"_ErrorMsg)		;操作失败		//modified by CZF0105 end
	}
	q:RetStr="" "OK"
	q RetStr
}

/// 导入设备类组及设备类型
ClassMethod EquipType(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCEquipType")
	.k ^DHCEQCCode("DHCEQCStatCat")
	q:ChangeType="Clear" "数据已清:设备类组(DHC_EQCEquipType)和设备类型(DHC_EQCStatCat)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2),statcode=$p(RowStr,del,3),statdesc=$p(RowStr,del,4)
 	s limityears=$p(RowStr,del,5),statremark=$p(RowStr,del,6)
 	if code="" s RetStr=..RetErrorValue(RetStr,"设备类组编码不能为空DHC_EQCEquipType:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"设备类组名称不能为空DHC_EQCEquipType:")
 	if statcode="" s RetStr=..RetErrorValue(RetStr,"设备类型编码不能为空DHC_EQCStatCat:")
 	if statdesc="" s RetStr=..RetErrorValue(RetStr,"设备类型名称不能为空DHC_EQCStatCat:")
 	if RetStr'="" q RetStr
 	
 	s desc=$ZCONVERT(desc,"U")
	s statdesc=$ZCONVERT(statdesc,"U")
	s tmpid=""
	&SQL(Select et_rowid into :tmpid from SQLUSER.DHC_EQCEquipType where et_desc=:desc)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCEquipType(et_code,et_desc,et_invalidflag) values (:code,:desc,'N'))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入设备类组失败DHC_EQCEquipType: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	;e  d
	;.s RetStr=..RetErrorValue(RetStr,"设备类组名称已经存在DHC_EQCEquipType: Desc="_desc)
	i RetStr'="" q RetStr
	&SQL(Select sc_rowid into :tmpid from SQLUSER.DHC_EQCStatCat where sc_desc=:statdesc)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCStatCat(sc_code,sc_desc,sc_invalidflag,sc_hold1,sc_remark) values (:statcode,:statdesc,'N',:limityears,:statremark))
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"插入设备类型失败DHC_EQCStatCat: StatCode="_statcode_" StatDesc="_statdesc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"设备类型名称已经存在DHC_EQCStatCat: Desc="_statdesc)
 	q:RetStr="" "OK"
	q RetStr
}

/// 设备来源
ClassMethod Origin(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCOrigin")
	q:ChangeType="Clear" "数据已清:设备来源(DHC_EQCOrigin)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCOrigin:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCOrigin:")
 	if RetStr'="" q RetStr
 	
 	s desc=$ZCONVERT(desc,"U")	
	s tmpid=""
	&SQL(Select O_rowid into :tmpid from SQLUSER.DHC_EQCOrigin where O_desc=:desc)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCOrigin(o_code,o_desc,o_invalidflag) values (:code,:desc,'N'))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCOrigin:"_desc)
 	 	
 	q:RetStr="" "OK"
	q RetStr
}

/// 设备用途
ClassMethod PurposeType(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCPurposeType")
	q:ChangeType="Clear" "数据已清:设备用途(DHC_EQCPurposeType)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCPurposeType:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCPurposeType:")
 	if RetStr'="" q RetStr
 	
	s tmpid=""
	&SQL(Select pt_rowid into :tmpid from SQLUSER.DHC_EQCPurposeType where pt_desc=:desc)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCPurposeType(pt_code,pt_desc,pt_invalidflag) values (:code,:desc,'N'))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCPurposeType:"_desc)
 	q:RetStr="" "OK"
	q RetStr
}

/// 设备分类
ClassMethod EquipCat(ChangeType As %String = "", RowStr As %String = "")
{
	;Modified by JDL 2012-02-08   JDL0115 
	;FixLength是否固定长度,如新国标为固定长度7位,后面补0,则FixLength=7
	;			如果不是固定长度,则设FixLength=0
	;Step;分类层次每层占的位数,比如新国标分类中,除第一层外,每层为两位,
	s FixLength=7
	s Step=-2
	s ExChar=""	
	
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCEquipeCat")
	q:ChangeType="Clear" "数据已清:设备分类(DHC_EQCEquipeCat)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	s yearsnum=$p(RowStr,del,3),depremethod=$p(RowStr,del,4)
 	s parentcode=$p(RowStr,del,5),remark=$p(RowStr,del,6)
 	s excode=$p(RowStr,del,7),eqnoflag=$p(RowStr,del,8),remainrate=$p(RowStr,del,9)
 	
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCEquipeCat:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCEquipeCat:")
 	if RetStr'="" q RetStr
 	
 	s ID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",code,0))
 	//if ID'="" q ..RetErrorValue(RetStr,"编码已经存在DHC_EQCEquipeCat:"_code)
 	
 	k PLIST
 	s PLIST(2) = code
    s PLIST(3) = desc
    if remark'="" s PLIST(4) = remark
    s PLIST(5) = "0"				//EC_ParCatDR	            
    if yearsnum'="" s PLIST(7) = yearsnum
    s PLIST(8) = "N"
    if eqnoflag'="" 
    	{s PLIST(9) = eqnoflag}
    else
    	{s PLIST(9)="N"}
    
    i depremethod'=""   d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetDepreMethodID(depremethod)
 	.i tmpid'=""  d
 	..s PLIST(10) = tmpid
 	.e  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到折旧方法: 设备="_equipname_"  折旧方法"_depremethod)
	
    if remainrate'="" s PLIST(11) = remainrate
    if excode'="" s PLIST(12) = excode
 	
 	/*
 	s len=$l(code)
	s parref=""
	for i=len:Step:1
	{
		//Modified by JDL 2009-8-10
		s parCode=$e(code,1,i)
		if (FixLength>0) s parCode=##Class(web.DHCEQCommon).LPAD(parCode,"0",FixLength)
		
		s parref=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",parCode,0))
		if (parref'="")
		{ 
			s PLIST(5)=	parref
			q
		}
		else
		{
			s PLIST(5)=0
		}
	}
 	*/
 	
 	i parentcode="" s PLIST(5)=0
 	e  d
 	.s parref=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",parentcode,0))
 	.i parref'="" s PLIST(5)=parref
 	.e  s PLIST(5)=0	
 	
	//czf 2022-04-13
	if ChangeType'="Test" d
	.i ID="" d
 	..&SQL(Insert Into SQLUSER.DHC_EQCequipecat Values :PLIST())
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	.e  d
	..&SQL(Update SQLUSER.DHC_EQCequipecat Values :PLIST() where EC_RowID=:ID)
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"更新失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 生产厂商
ClassMethod Manufacturer(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCManufacturer")
	q:ChangeType="Clear" "数据已清:生产厂商(DHC_EQCManufacturer)"
	
	s del="^",RetStr=""
	//Mzy0001 2009-5-6
	//SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2),shname=$p(RowStr,del,3)
 	SET code=##Class(web.DHCEQCommon).Trim(code)
 	SET desc=##Class(web.DHCEQCommon).Trim(desc)
	SET shname=##Class(web.DHCEQCommon).Trim(shname)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCManufacturer:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCManufacturer:")
 	if RetStr'="" q RetStr
	
	s FirmType=3
	s tmpid=""
 	&SQL(Select v_rowid into :tmpid from SQLUSER.DHC_EQCVendor where v_name=:desc and v_invalidflag='N')		//modified by CZF0105 begin
 	i tmpid'=""
	{
		s fctmpid=""
		&SQL(Select FC_rowid into :fctmpid from SQLUSER.DHC_EQCFirmContrast where fc_firmdr=:tmpid and fc_firmtype=:FirmType)
		i fctmpid'="" q ..RetErrorValue(RetStr,"名称已经存在DHC_EQCVendor:"_desc)
	}
	s $ZT="ErrorSaveManu"
	TStart
	if ChangeType'="Test"
	{
		k PLIST
		s PLIST(2) = code
	  	s PLIST(3) = desc
		s PLIST(12) = shname
		s PLIST(20) = "N"
		s PLIST(23) = FirmType
		
		if tmpid=""
		{
			&SQL(Insert Into SQLUSER.DHC_EQCVendor Values :PLIST())
		}
		else
		{
			s VHold3=$p($g(^DHCEQCCode("DHCEQCVendor",tmpid)),"^",22)
			i VHold3="" s PLIST(23)=FirmType
			e  s PLIST(23)=VHold3_","_FirmType
			&SQL(update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID=:tmpid)
		}
		if SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
		}
		s VRowID=$g(%ROWID)
		
		&SQL(Insert Into SQLUSER.DHC_EQCFirmContrast(FC_FirmType,FC_FirmDR,FC_InvalidFlag) Values (:FirmType,:VRowID,'N'))
		if SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
		}
	}
	TCommit
	q "OK"
	
ErrorSaveManu
	TRollBack	
	Set ErrorMsg=$ZE	//得到系统返回的错误消息
	q ..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" ErrorMsg="_ErrorMsg)		;操作失败		//modified by CZF0105 end
}

/// 来源去向部门
ClassMethod FromToDept(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCFromToDept")
	q:ChangeType="Clear" "数据已清:设备来源去向部门(DHC_EQCFromToDept)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCFromToDept:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCFromToDept:")
 	if RetStr'="" q RetStr
 	
 	s tmpid=""
	&SQL(Select ftd_rowid into :tmpid from SQLUSER.DHC_EQCFromToDept where ftd_desc=:desc)
 	i tmpid'="" q ..RetErrorValue(RetStr,"名称已经存在DHC_EQCFromToDept:"_desc)
	&SQL(Select ftd_rowid into :tmpid from SQLUSER.DHC_EQCFromToDept where ftd_code=:code)
	i tmpid'="" q ..RetErrorValue(RetStr,"编码已经存在DHC_EQCFromToDept:"_code)
 	if ChangeType'="Test"  d
 	.&SQL(Insert into SQLUSER.DHC_EQCFromToDept(FTD_Code,FTD_Desc,FTD_InvalidFlag) values (:code,:desc,'N'))
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 设备项
ClassMethod MasterItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCMasterItem")
	q:ChangeType="Clear" "数据已清:设备项(DHC_EQCMasterItem)"
	s del="^",RetStr=""
	//SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1)
 	s code=##class(web.DHCEQCommon).Trim(code)
 	s desc=$p(RowStr,del,2)
 	s desc=##class(web.DHCEQCommon).Trim(desc)
 	s equiptype=$p(RowStr,del,3),statcat=$p(RowStr,del,4)
 	s equipcat=$p(RowStr,del,5),unit=$p(RowStr,del,6),remark=$p(RowStr,del,7)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCMasterItem:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCMasterItem:")
 	if RetStr'="" q RetStr
 	
 	k PLIST
 	
 	s equiptypeid=""
 	i equiptype'=""  d
	.s equiptypeid=##Class(web.DHCEQImportDataTool).GetEquipTypeID(equiptype)
	.i equiptypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类组: 设备="_desc_" 设备类组="_equiptype)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类组: 设备="_desc_" 设备类组="_equiptype)
 	if RetStr'="" q RetStr
 	
	s tmpid=""
	&SQL(Select mi_rowid into :tmpid from SQLUSER.DHC_EQCMasterItem where mi_desc=:desc and mi_equiptypeDR=:equiptypeid)
	i tmpid'="" q ..RetErrorValue(RetStr,"名称已经存在DHC_EQCMasterItem:"_desc)
	;&SQL(Select mi_rowid into :tmpid from SQLUSER.DHC_EQCMasterItem where mi_code=:code)
	;i tmpid'="" q ..RetErrorValue(RetStr,"编码已经存在DHC_EQCMasterItem:"_code)
		
	;k PLIST(1)
	i (desc'="") s PLIST(2) = desc
    i (code'="") s PLIST(3) = code
    
    s PLIST(4)=equiptypeid
    
 	i equipcat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,equipcat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_desc_" 设备分类="_equipcat)
	.e  d
	..s PLIST(5)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_desc)
	
	i statcat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_desc_" 设备类型="_statcat)
	.e  d
	..s PLIST(6)=tmpid
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类型: 设备="_desc)
	
    i (remark'="") s PLIST(7) = remark
    
    i unit'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_desc_" 设备单位="_unit)
	.e  d
	..s PLIST(8)=tmpid
	
    s PLIST(9) = "N"
    
    i RetStr'="" q RetStr
    
    if ChangeType'="Test"  d
    .&SQL(Insert Into SQLUSER.DHC_EQCMasterItem Values :PLIST())
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/***************************************************************/
ClassMethod LocType(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCLocType")
	q:ChangeType="Clear" "数据已清:科室类型(DHC_EQCLocType)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s group=$p(RowStr,del,1),type=$p(RowStr,del,2),loc=$p(RowStr,del,3)
 	s loc=##Class(web.DHCEQCommon).Trim(loc)
 	s type=##Class(web.DHCEQCommon).Trim(type)
 	s group=##Class(web.DHCEQCommon).Trim(group)
 	if group="" s RetStr=..RetErrorValue(RetStr,"科室组不能为空DHC_EQCLocGroup:")
 	if type="" s RetStr=..RetErrorValue(RetStr,"科室类型不能为空DHC_EQCLocType:")
 	if loc="" s RetStr=..RetErrorValue(RetStr,"科室不能为空DHC_EQCLocType:")
 	if RetStr'="" q RetStr
 	k PLIST
 	
 	i group'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetLocGroup(group)
 	.i tmpid=""  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到科室组:科室组="_group)
 	.e  d
 	..s LGDR=tmpid
 	e  d
 	.s RetStr=..RetErrorValue(RetStr,"没有科室组:科室组="_group)
 	
  	i type'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetLocGroupType(group,type)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室类型:科室组="_group_"  科室类型="_type)
	.e  d
	..s PLIST(2)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有科室类型:科室组="_group_"  科室类型="_type)	
 	
 	i loc'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(loc)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室:科室="_loc)
	.e  d
	..s PLIST(3)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有科室:科室="_loc)
	
 	if RetStr'="" q RetStr 
 	//判断重复记录
 	s tmpid=##Class(web.DHCEQCLocType).GetLocGroupType(LGDR,PLIST(2),PLIST(3))
 	i tmpid'="" s RetStr=..RetErrorValue(RetStr,"该组科室类型已经存在:科室组="_group_" 类型="_type_" 科室="_loc)
 	if RetStr'="" q RetStr
 	
    if ChangeType'="Test"  d
    .&SQL(Insert Into SQLUSER.DHC_EQCLocType Values :PLIST()) //2010-07-02
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: 科室="_loc_" 类型="_type_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/***************************************************************/
/// 机型
ClassMethod Model(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCModel")
	q:ChangeType="Clear" "数据已清:设备机型(DHC_EQCModel)"
	s del="^",RetStr=""
	//Mzy0001 2009-5-6
	//SET RowStr=$tr(RowStr," ","")
	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	SET code=##Class(web.DHCEQCommon).Trim(code)
 	SET desc=##Class(web.DHCEQCommon).Trim(desc)
	//SET RowStr=$tr(RowStr," ","")
 	s item=$p(RowStr,del,3)
 	SET item=##Class(web.DHCEQCommon).Trim(item)
 	s equiptype=$p(RowStr,del,4),remark=$p(RowStr,del,5)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCModel:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCModel:")
 	if RetStr'="" q RetStr 	
 	
 	s equiptypeid=""
 	i equiptype'=""  d
	.s equiptypeid=##Class(web.DHCEQImportDataTool).GetEquipTypeID(equiptype)
	.i equiptypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类组: 设备="_desc_" 设备类组="_equiptype)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类组: 设备="_desc_" 设备类组="_equiptype)
 	if RetStr'="" q RetStr
 	
 	s tmpid=""
	&SQL(Select m_rowid into :tmpid from SQLUSER.DHC_EQCModel where m_desc=:desc and M_ItemDR->MI_Desc=:item and M_ItemDR->MI_EquipTypeDR=:equiptypeid)
	i tmpid'="" q ..RetErrorValue(RetStr,"名称已经存在DHC_EQCModel:"_desc)
	&SQL(Select m_rowid into :tmpid from SQLUSER.DHC_EQCModel where m_code=:code and M_ItemDR->MI_Desc=:item and M_ItemDR->MI_EquipTypeDR=:equiptypeid)
	i tmpid'="" q ..RetErrorValue(RetStr,"编码已经存在DHC_EQCModel:"_code)
	&SQL(Select mi_rowid into :tmpid from SQLUSER.DHC_EQCMasterItem where MI_Desc=:item and MI_EquipTypeDR=:equiptypeid)
	i tmpid=""  d
	.i item'="" s RetStr=..RetErrorValue(RetStr,"没有找到该设备项:"_item)
	e  d
	.s item=tmpid
	if RetStr'="" q RetStr 
	if ChangeType'="Test"  d
	.&SQL(Insert into SQLUSER.DHC_EQCModel(M_Code,M_Desc,M_ItemDR,M_Remark,M_InvalidFlag) values (:code,:desc,:item,:remark,'N'))
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 设备
ClassMethod Equip(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQEquip
	q:ChangeType="Clear" "数据已清:设备(DHC_EQEquip)"
	s del="^",RetStr="",buildingArea=""     // add by mwz0049 2021-05-14
	s model=$p(RowStr,del,7)	// Mzy0001 机型中间的空格予以保留
	s manufacturer=$p(RowStr,del,20)	// Mzy0001 生产厂商中间的空格予以保留
	s model=##Class(web.DHCEQCommon).Trim(model)
 	s manufacturer=##Class(web.DHCEQCommon).Trim(manufacturer)
	//SET RowStr=$tr(RowStr," ","")
 	;s (设备类组,设备类型,设备分类,设备编号,名称,机型,数量,单位,原值,使用科室,状态,入库日期,购置日期)=""
 	;s (折旧方法,使用年限,累计折旧,残值率,供应商,生产厂商,出厂编号,出厂日期,国别,设备用途,设备来源,管理人,保管人,来源部门,备注)=""
 	s equiptype=$p(RowStr,del,1)
 	s statcat=$p(RowStr,del,2)
 	s equipcat=$p(RowStr,del,3)
 	s equipno=$p(RowStr,del,4)
 	s equipname=$p(RowStr,del,5)
 	s equipname=##Class(web.DHCEQCommon).Trim(equipname)
 	s code=$p(RowStr,del,6)
 	s code=##Class(web.DHCEQCommon).Trim(code)
 	;s model=$p(RowStr,del,7)
 	s quantity=$p(RowStr,del,8)
 	s unit=$p(RowStr,del,9)
 	s originalfee=$p(RowStr,del,10)
 	s useloc=$p(RowStr,del,11)
 	s status=$p(RowStr,del,12)
 	;modified by csj 20180815 根据实施规范最新数据准备模板改为先入库日期后启用日期
 	s instockdate=$p(RowStr,del,13)			// 入库(账)日期
 	s startdate=$p(RowStr,del,14)			// 启用日期 Modify DJ 2015-08-21 DJ0157
 	s depremethod=$p(RowStr,del,15)
 	s limityears=$p(RowStr,del,16)
 	s depretotalfee=$p(RowStr,del,17)
 	s remainrate=$p(RowStr,del,18)
 	s provider=$p(RowStr,del,19)
 	s provider=##Class(web.DHCEQCommon).Trim(provider)
 	;s manufacturer=$p(RowStr,del,20)
 	s leavefactoryno=$p(RowStr,del,21)
 	s leavefactorydate=$p(RowStr,del,22)
 	s country=$p(RowStr,del,23)
 	s purposetype=$p(RowStr,del,24)
 	s origin=$p(RowStr,del,25)
 	s manager=$p(RowStr,del,26)
 	s keeper=$p(RowStr,del,27)
 	s fromtodept=$p(RowStr,del,28)
 	s remark=$p(RowStr,del,29)
 	
 	// 旧科室30	报废日期31	助记码32	location33	凭证号34	资产唯一编号35	资金来源36	建筑面积37	品牌38	经费来源39	保修月数40
 	s oldloc=$p(RowStr,del,30)
 	s disuseddate=$p(RowStr,del,31)
 	;i disuseddate'="" s disuseddate=$e(disuseddate,1,4)_"-"_$e(disuseddate,5,6)_"-"_$e(disuseddate,7,8)	////czf 2022-02-22
 	s memorycode=$p(RowStr,del,32)
 	s Location=$p(RowStr,del,33)   ;服务联系人->变更为存放地点
 	s Location=##Class(web.DHCEQCommon).Trim(Location)
 	s accountNo=$p(RowStr,del,34)   ;凭证号
 	s EQFileNo=$p(RowStr,del,35)   ;导入系统前,原始数据中唯一标识,可以为ID或资产唯一编号oldID
 	s fundsstr=$p(RowStr,del,36)	;资金来源
 	i fundsstr="" d		//czf 2022-02-22
 	.s DefaultFundsTypeDR=##class(web.DHCEQCommon).GetSysInfo("990015")
 	.s DefaultFundsType=##class(web.DHCEQCommon).GetTrakNameByID("fundstype",DefaultFundsTypeDR)
 	.s fundsstr=DefaultFundsType_"="_originalfee_":"_depretotalfee
 	s RegisterNo=$p(RowStr,del,37)	//注册证号  add by mwz0049 2021-05-14
 	s brand=$p(RowStr,del,38)		//品牌 Add By DJ 2015-08-21 DJ0157
 	s Expenditures=$p(RowStr,del,39)		//经费来源 Add By DJ 2015-08-21 DJ0157
 	s PeriodNum=$p(RowStr,del,40)		//保修月数
 	s CatCode68=$p(RowStr,del,41)		//68码分类——>设备项关联
 	s FinaceItemCode=$p(RowStr,del,42)	//核算项目编码
 	s DepreMonthNum=$p(RowStr,del,43)		//已折月数(次数)	 MZY0058	1549257		2020-10-18
 	s masteritemname=$p(RowStr,del,44) 	    //设备项名称  add by mwz0049 2021-05-14
	i masteritemname="" s masteritemname=equipname
 	;s locFlag=1		;获取科室ID方式： 1根据科室名称； 2根据科室代码； 3新旧科室对照
 	;s catFlag=1
 	s manageloc=$p(RowStr,del,45)  //add by mwz 20220606 MWZ0061
	s parentEquip=$p(RowStr,del,46)	//主设备编号	czf 2022-04-13
 	s isConfig=$p(RowStr,del,47)	//是否附属设备
 	s isConfig=$case(isConfig,"是":"Y","Y":"Y",:"")
	
 	d SetEquipInfo
 	
 	if RetStr'="" q RetStr
 	if quantity="" s quantity=1
 	if quantity>1
 	{
	 	d InsertInStockInfo
	 	if RetStr'="" q RetStr
	 	s PLIST(71)=ISLRowID
	}
	
	s bdEquipTypeRowIDs=##class(web.DHCEQCommon).GetSysInfo("401003")		//房屋建筑的类组RowIDs. 2013-4-15
 	for i=1:1:quantity
	{
		q:RetStr'=""
		;s PLIST(72) = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQEquip",+$H)  ;EQNo
		if ChangeType'="Test"  d
		.&SQL(Insert Into SQLUSER.DHC_EQEquip Values :PLIST())
		.i SQLCODE  d
	    ..s RetStr=..RetErrorValue(RetStr,"插入设备台帐信息失败: 设备="_equipname_" SQLCODE="_SQLCODE)
	    ..;s ^DHCEQTemp("jdl")=ChangeType_"@"_RowStr
	    .e  d
	    ..s ID=$g(%ROWID)
	    ..;##Class(web.DHCEQEquip).GetEquipeCatCode(equipcatdr)
	    ..;##Class(web.DHCEQInStockList).GetYearsByEquipCat(equipcatdr)
	    ..s TempNo=$p($g(^DHCEQEquip(ID)),"^",71) //2011-02-19 DJ
	    ..i TempNo="" d
	    ...d ##CLASS(web.DHCEQEquip).UpdateEquipNo(ID,+$H)
	    ..i fundsstr'=""  d
	    ...;s ^DHCEQTemp("jdl")=fundsstr_ChangeType
	    ...s ErrTemp=..EquipFunds(ChangeType,ID_"^"_equipname_"^"_originalfee_"^"_fundsstr_"^"_depretotalfee_"^"_FinaceItemCode) //modify by mwz 20220606 MWZ0061
	    ...i ErrTemp'="OK" s RetStr=..RetErrorValue(RetStr,ErrTemp)
	    ..//Add 2013-4-15 若类组为房屋建筑类的,则需向表DHC_EQBuilding中写入信息.
	    ..s tmpEquipType=$p($g(^DHCEQEquip(ID)),"^",63)
	    ..i ((","_bdEquipTypeRowIDs_",")[(","_tmpEquipType_",")) d
	    ...d InsertBuildingInfo
	    ..;已折月数(次数)	 MZY0058	1549257		2020-10-18
	    ..i DepreMonthNum'="" d
	    ...s DepreSetID=$o(^DHCEQDepreSet(0,"Source",1,0,ID,0))
	    ...i DepreSetID'="" d
	    ....i $p($g(^DHCEQDepreSet(DepreSetID)),"^",3)="Y" &SQL(update sqluser.DHC_EQDepreSet set DS_DepreTotal=:DepreMonthNum where DS_RowID=:DepreSetID)
	}
	
 	q:RetStr="" "OK"
	q RetStr
	
SetEquipInfo
	k PLIST
	k PLIST(1)	;RowID
	s PLIST(2) = equipname	;Name
		
 	;s PLIST(3) = abctype	;ABCType
 	i model'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetModelID(model,masteritemname,equiptype)  //add by mwz0049 2021-05-14
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到机型: 设备="_equipname_" 机型="_model)
	.e  d
	.s PLIST(4)=tmpid
		
	
	i equipcat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,equipcat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_equipname_" 设备分类="_equipcat)
	.e  d
	..s PLIST(5)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_equipname)
	
	i unit'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_equipname_" 设备单位="_unit)
	.e  d
	..s PLIST(6)=tmpid
	
	i code'="" s PLIST(7) = code		;Code
	s equiptypeid=""
	i equiptype'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipTypeID(equiptype)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类组: 设备="_equipname_" 设备类组="_equiptype)
	.e  d
	..s PLIST(64)=tmpid
	..s equiptypeid=tmpid
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类组: 设备="_equipname_" 设备类组="_equiptype)
 	
	i equipname'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetItemID(masteritemname,equiptypeid) 
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备项: 设备="_equipname_" 设备项="_masteritemname)  //add by mwz0049 2021-05-14
	.e  d
	..s PLIST(8)=tmpid
	i masteritemname="" s RetStr=..RetErrorValue(RetStr,"设备项名称为空: 设备="_equipname)  //add by mwz0049 2021-06-10
 	;s PLIST(9) = 	;InstallLocDR 
 	;s PLIST(10) = 	;InstallDate
 	i leavefactoryno'="" s PLIST(11) = leavefactoryno
 	i leavefactorydate'="" d
 	.s PLIST(12) = $zdh(leavefactorydate,3)	;LeaveFactoryDate
 	
 	;s PLIST(13) = 	;OpenCheckDate
 	;s PLIST(14) = 	;CheckDate
 	;s PLIST(15) = 	;MakeDate
 	;s PLIST(16) = 	;ComputerFlag 
 	
 	i country'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetCountryID(country)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到国别: 设备="_equipname_" 国别="_country)
	.e  d
	..s PLIST(17)=tmpid
	
 	;s PLIST(18) = 	;ManageLocDR
 	;s PLIST(19) = 	;ManageLevelDR
 	
 	i useloc'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(useloc)
	.;s tmpid=410
	.i tmpid=""  d 
	..;s PLIST(20)=1276
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室: 设备="_equipname_" 科室="_useloc)
	.e  d
	..i status="在库"  d //2011-02-19 DJ
	...s PLIST(68)=tmpid
	..s PLIST(20)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有科室: 设备="_equipname)
	
	i origin'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetOriginID(origin)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备来源: 设备="_equipname_" 来源="_origin)
	.e  d
	..s PLIST(21)=tmpid
	
	i fromtodept'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetFromToDept(fromtodept)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备来源部门: 设备="_equipname_" 来源部门="_fromtodept)
	.e  d
	..s PLIST(22)=tmpid
		
 	;s PLIST(23) = 	;ToDeptDR
 	;s PLIST(24) = 	;BuyTypeDR
 	;s PLIST(25) = 	;EquipTechLevelDR
 	
 	i provider'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetProviderID(provider,1)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到供应商: 设备="_equipname_" 供应商="_provider)
	.e  d
	..s PLIST(26)=tmpid
	
	i manufacturer'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetManuFactoryID(manufacturer)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到生产厂商: 设备="_equipname_" 生产厂商="_manufacturer)
	.e  d
	..s PLIST(27)=tmpid
	
	i originalfee'=""  d
	.s PLIST(28) = $Number(originalfee,2)
	.s PLIST(29) =originalfee 	;NetFee //2011-03-03 DJ
	.i depretotalfee'="" s PLIST(29)=$Number(originalfee,2)-$Number(depretotalfee,2) //2011-03-03 DJ
	.i (remainrate'="") s PLIST(30) = $Number(originalfee*remainrate,2)	;NetRemainFee
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有原值: 设备="_equipname)
 	
 	;s PLIST(31) = 	;GroupDR
 	
 	i limityears'="" s PLIST(32) = limityears
 	;s PLIST(33) = 	;ContractListDR
 	i depremethod'=""   d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetDepreMethodID(depremethod)
 	.i tmpid'=""  d
 	..s PLIST(34) = tmpid
 	.e  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到折旧方法: 设备="_equipname_"  折旧方法"_depremethod)
 	i remark'="" s PLIST(35) = remark
 	i depretotalfee'="" s PLIST(36) = $Number(depretotalfee,2)
 	;s PLIST(37) = 	;DesignWorkLoadNum
 	;s PLIST(38) = 	;WorkLoadUnitDR
 	//modify by mwz 20220117 mwz0056 
 	i (status="启用")||(status="在用")  d
 	.s status=1
 	e  i status="在库"  d
 	.s status=0
 	.k PLIST(20)		;useloc
 	e  i status="报废"  d
 	.s status=3
 	.s PLIST(68)=PLIST(20)
 	.k PLIST(20)		;useloc
 	s PLIST(39) = status
 	
 	i manager'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUserID(manager)
	.i tmpid=""  d 
	..;s RetStr=..RetErrorValue(RetStr,"没有找到该管理人: 设备="_equipname_" 管理人="_manager)
	.e  d
	..s PLIST(40)=tmpid
	
 	;s PLIST(41) = 	;MaintUserDR
 	;s PLIST(42) = 	;ContactUser
 	;s PLIST(43) = 	;ContactMode
 	;s PLIST(44) = 	;AppendFeeTotalFee
 	i startdate'="" s PLIST(45) =$zdh(startdate,3)  ;StartDate
 	i instockdate'=""   d
 	.s PLIST(46) = $zdh(instockdate,3)
 	e  d
 	.s RetStr=..RetErrorValue(RetStr,"没有设置入库日期: 设备="_equipname)
 	;i transassetdate'="" s PLIST(46) = $zdh(transassetdate,3)
 	;s PLIST(47) = 	;GuaranteeFlag
 	s PLIST(48) = "Y"	;InputFlag
 	;s PLIST(49) = 	;TestFlag
 	;s PLIST(50) = 	;MedicalFlag
 	;s PLIST(51) = 	;GuaranteeStartDate
 	;s PLIST(52) = 	;GuaranteeEndDate 
 	;s PLIST(53) = 	;AddUserDR
 	s PLIST(54) = PLIST(46)	;EQ_AddDate	 modified by csj 20180815  启用日期"PLIST(45)"可能为空(在库)而出现"undefined"错误,改为入库日期"PLIST(46)"
 	;s PLIST(55) = 	;AddTime
 	;s PLIST(56) = 	;UpdateUserDR
 	;s PLIST(57) = 	;UpdateDate
 	;s PLIST(58) = 	;UpdateTime
 	;s PLIST(59) = 	;Currency
 	s PLIST(60) = "N"		;InvalidFlag
 	//添加
 	s PLIST(61) = 1	;StockStatus
 	i memorycode'="" s PLIST(62) = memorycode		;MemoryCode
 	;s PLIST(63) = 	;UrgencyFlag
 	
 	;s PLIST(65) = 	;PurchaseTypeDR
 	
 	i purposetype'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetPurposeTypeID(purposetype)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该用途: 设备="_equipname_" 用途="_purposetype)
	.e  d
	..s PLIST(66)=tmpid
 	
 	i keeper'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUserID(keeper)
	.i tmpid=""  d 
	..;s RetStr=..RetErrorValue(RetStr,"没有找到该保管人: 设备="_equipname_" 人员="_keeper)
	.e  d
	..s PLIST(67)=tmpid
	
	i $g(PLIST(20))'="" s PLIST(68) = $g(PLIST(20))	;StoreLocDR
 	;s PLIST(69) = 	;StartDepreMonth
 	;s PLIST(70) = 	;ServiceDR
 	;s PLIST(71) = ;	;InStockListDR
 	;s PLIST(72) = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQEquip")   ;EQNo   
 	//modified by ZY 2858845   2022-08-11
 	//i equipno'="" s PLIST(72) = equipno              
 	i equipno'=""  d
 	.s tmpid=##Class(web.DHCEQEquip).GetEquipIDByNo(equipno)
 	.i tmpid'=""  d
 	..s RetStr=..RetErrorValue(RetStr,"该设备编号设备已经存在: 设备="_equipname_" 设备编号="_equipno)
 	.e  d
 	..s PLIST(72) =equipno 	;Location
 	
 	
 	;Modified by JDL 2011-12-19 JDL0106
 	i Location'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetLocationID(Location)
 	.i tmpid=""  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到该存放地点: 设备="_equipname_" 存放地点="_Location)
 	.e  d
 	..s PLIST(73) =tmpid 	;Location
 	i PeriodNum'="" s PLIST(74) =PeriodNum 	;EQ_ServiceTel	EQ_GuaranteePeriodNum
 	
 	i statcat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_equipname_" 设备类型="_statcat)
	.e  d
	..s PLIST(76)=tmpid
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类型: 设备="_equipname)
	
	s PLIST(80)=oldloc
	//modofied by ZY0235 模版列名是旧资产编号
	i EQFileNo'=""  d
 	.s tmpid=##Class(web.DHCEQOpenCheckRequest).CheckFileNo("","",EQFileNo)
	.i tmpid'=0  d 
	..s RetStr=..RetErrorValue(RetStr,"有重复的编号: 设备="_equipname_" 档案号="_EQFileNo)
	.e  d
	.//s PLIST(86)=EQFileNo	;EQFileNo
	.s PLIST(92)=EQFileNo	;EQOldNo
	s PLIST(93)=RegisterNo    //add by mwz0049 2021-05-14
	i disuseddate'="" s PLIST(90)=$zdh(disuseddate,3)
 	i accountNo'="" s PLIST(91)=accountNo
 	
 	i fundsstr'=""  d //检测资金来源是否存在以及总金额时候等于原值
 	.s ErrTemp=..EquipFunds("Test","^"_equipname_"^"_originalfee_"^"_fundsstr_"^"_depretotalfee)   //modify by mwz 2021-04-12
 	.i ErrTemp'="OK" s RetStr=..RetErrorValue(RetStr,ErrTemp)
 	
 	//Add By DJ 2015-08-21 DJ0157 begin
 	i brand'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetbrandID(brand)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到品牌: 设备="_equipname_" 品牌="_brand)
	.e  d
	.s PLIST(95)=tmpid
	
 	i Expenditures'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetExpendituresID(Expenditures)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到经费来源: 设备="_equipname_" 经费来源="_Expenditures)
	.e  d
	.s PLIST(96)=tmpid
	//ADD by mwz 20220606 MWZ0061
	i manageloc'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(manageloc)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到责任科室: 设备="_equipname_" 责任科室="_manageloc)
	.e  d
	.s PLIST(18)=tmpid
	
	s parentid=""		//czf 2022-04-13 begin
	i parentEquip'="" d
	.s parentid=$o(^DHCEQEquip(0,"No",parentEquip,""))
	.i parentid="" s RetStr=..RetErrorValue(RetStr,"没有找到主设备: 设备="_equipname_" 主设备="_parentEquip)
	
	s PLIST(120)=parentid	//czf 2022-04-13 end
	s PLIST(123)=isConfig		//附属设备
	quit
	
InsertInStockInfo
	k ISPL,ISLPL
	k ISPL(1)	;RowID
	k ISLPL(1)	;RowID
	
	s ISPL(2)=PLIST(54) //入库时间
	s ISPL(3)=PLIST(68) //库房
	;s ISPL(4)= //拒绝原因
	;s ISPL(5)= //申请人
	;s ISPL(6)= //申请日期
	;s ISPL(7)= //入库审核人
	s ISPL(8)=PLIST(54)	//审核日期
	;s ISPL(9)= //拒绝人
	;s ISPL(10)= //拒绝日期
	s ISPL(11)="2"	//状态审核
	s ISPL(12)="期初"
	;s ISPL(13)= //账单审核人
	s ISPL(14)=PLIST(54)	//账务审核日期
	;s ISPL(15)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock")
	i $g(PLIST(21))'="" s ISPL(16)= PLIST(21) //设备来源
	i $g(PLIST(22))'="" s ISPL(17)= PLIST(22) //来源部门
	i $g(PLIST(26))'="" s ISPL(18)=PLIST(26)	//供应商
	;s ISPL(19) = //采购部门
	;s ISPL(20) = //采购人
	s ISPL(21)=PLIST(64)
	s ISPL(22)=PLIST(76)
	if ChangeType'="Test"  d
	.&SQL(Insert Into SQLUSER.DHC_EQInStock Values :ISPL())
	.i SQLCODE  d
	..s RetStr=..RetErrorValue(RetStr,"插入入库信息失败: 设备="_equipname_" SQLCODE="_SQLCODE)
	.e  d
	..s ISLPL(2)=$G(%ROWID)
	i RetStr'="" q	
	
	;s ISLPL(3)= //设备ID
	s ISLPL(4)="Y" //批
	;s ISLPL(5)= //采购计划ID
	s ISLPL(6)=PLIST(2) //设备名称
	i $g(PLIST(27))'="" s ISLPL(7)=PLIST(27) //生产厂家
	s ISLPL(8)=PLIST(28) //原值
	s ISLPL(9)=quantity  //数量
	i $g(PLIST(4))'="" s ISLPL(10)=PLIST(4) //机型
	s ISLPL(11)=PLIST(6) //单位
	;s ISLPL(12)= //保留
	;s ISLPL(13)= //备注
	;s ISLPL(14)= //附加费
	s ISLPL(15)=PLIST(5) //设备分类
	i limityears'="" s ISLPL(16)=limityears //使用年限
	s ISLPL(17)=PLIST(8) //设备项
	s ISLPL(18)=PLIST(76) //2011-03-10 DJ begin
	s ISLPL(19)=1
	s ISLPL(20)=PLIST(8) //2011-03-10 DJ end
	if ChangeType'="Test"  d
	.&SQL(Insert Into SQLUSER.DHC_EQInStockList Values :ISLPL())
	.i SQLCODE  d
	..s RetStr=..RetErrorValue(RetStr,"插入入库明细信息失败: 设备="_equipname_" SQLCODE="_SQLCODE)
	.e  d
	..s ISLRowID=$G(%ROWID)
	e  d
	.s ISLRowID=""
			
	quit
InsertBuildingInfo		//Add 2013-4-15.插入房屋建筑物信息
	k BDPL
	s BDPL(2)=ID			//BD_EquipDR
	s BDPL(5)=buildingArea	//BD_UtilizationArea	
	if ChangeType'="Test"  d
	.&SQL(Insert Into SQLUSER.DHC_EQBuilding Values :BDPL())
	.i SQLCODE  d
	..s RetStr=..RetErrorValue(RetStr,"插入房屋建筑物信息失败:房屋="_equipname_",SQLCODE="_SQLCODE)

	quit
}

ClassMethod RetErrorValue(RetStr As %String = "", ErrorStr As %String = "") As %String
{
	if RetStr="" d
	.s:ErrorStr'="" RetStr=ErrorStr
	else  d
	.s:ErrorStr'="" RetStr=RetStr_"@"_"   "_ErrorStr
	q RetStr
}

ClassMethod Test()
{
	s strTemp=$g(^DHCEQTemp("jdl"))
	s strTemp=$p(strTemp,"@",2)
	w ##Class(web.DHCEQImportData2CSP).Equip("Init",strTemp)
}

/// 创建：Mozy 2009-07-18
/// 描述：导入对照类型信息
/// 访问表:DHC_EQCContrastInfo
/// 输入：ChangeType：操作类别
/// 			RowStr：ContrastTypeDR^SYSID^SYSCODE^SYSDESC^EXID^EXCODE^EXDESC
/// 输出：无
/// 返回：成功返回"OK"，否则返回出错信息
/// 备注：
/// w ##class(web.DHCEQImportData2CSP).ContrastInfo("","1555^zjsmsyxyqyxgs-浙江史密斯医学仪器有限公司")
ClassMethod ContrastInfo(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"
	{
		&SQL(delete from sqluser.DHC_EQCContrastInfo)
	}
	Quit:ChangeType="Clear" "数据已清:对照类型表(DHC_EQCContrastInfo)"
	
	Set Flag="^",RetStr=""
	Set RowStr=$tr(RowStr," ","")
	
 	Set ContrastTypeDR=$Piece(RowStr,Flag,1)
 	Set SYSID=$Piece(RowStr,Flag,2)
 	Set SYSCODE=$Piece(RowStr,Flag,3)
 	Set SYSDESC=$Piece(RowStr,Flag,4)
 	Set EXID=$Piece(RowStr,Flag,5)
 	Set EXCODE=$Piece(RowStr,Flag,6)
 	Set EXDESC=$Piece(RowStr,Flag,7)

	If ChangeType'="Test"
	{
		TSTART
		&SQL(Insert into SQLUSER.DHC_EQCContrastInfo(CI_ContrastTypeDR, CI_SYSID, CI_SYSCODE, CI_SYSDESC, CI_EXID, CI_EXCODE, CI_EXDESC, CI_InvalidFlag) values (:ContrastTypeDR,:SYSID,:SYSCODE,:SYSDESC,:EXID,:EXCODE,:EXDESC,'N'))
		
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		TCOMMIT
	}
	Quit:RetStr="" "OK"
	Quit RetStr
}

/// 创建：JDL 2009-09-7
/// 描述：导入设备附件信息
/// 访问表:DHC_EQAffix
/// 输入：ChangeType：操作类别
/// 			RowStr：EqNo^Affix^Model^Qty^UOM^Price^LeaveFacNo^AddDate^Remark
/// 输出：无
/// 返回：成功返回"OK"，否则返回出错信息
/// 备注：
/// w ##class(web.DHCEQImportData2CSP).AffixInfo("","")
ClassMethod AffixInfo(ChangeType As %String = "", RowStr As %String = "")
{

	Quit:ChangeType="Clear" "未操作"
	s Flag="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
		
	s EqNo=$p(RowStr,Flag,1)
 	s EquipDR=$o(^DHCEQEquip(0,"No",EqNo,0))
 	if (EquipDR="") 
 	{
	 	s RetStr=..RetErrorValue(RetStr,"没有找到该设备,请确认设备编号是否正确! 设备编号="_EqNo)
	 	q RetStr
 	}
 	
 	s Affix=$p(RowStr,Flag,2)
 	if Affix=""
 	{
	 	s RetStr=..RetErrorValue(RetStr,"附件名称不能为空!")
	 	q RetStr
	}
 	
	s UOMDesc=$p(RowStr,Flag,5)
	i UOMDesc'=""
	{
		;Modified By jdl 20150906 v4.1.0 规范单位取值
		//s UOM=$o(^CT("UOM",0,"Desc",UOMDesc,0))
		s UOM=##Class(web.DHCEQImportDataTool).GetUnitID(UOM)
		
		i UOM=""
		{
			s RetStr=..RetErrorValue(RetStr,"没有找到该单位,请确认单位是否正确!  附件="_Affix_" 设备单位="_UOMDesc)
	 		q RetStr
		}
	}
	
 	s Affix=$p(RowStr,Flag,2)
 	s Model=$p(RowStr,Flag,3)
 	s Qty=$p(RowStr,Flag,4)
 	s Price=$p(RowStr,Flag,6) 	
 	s LeaveFacNo=$p(RowStr,Flag,7)
 	s AddDate=$p(RowStr,Flag,8)
 	s Remark=$p(RowStr,Flag,9)
 	
 	i AddDate'="" s AddDate = $zdh(AddDate,3)
 	if Qty=""
 	{
	 	s RetStr=..RetErrorValue(RetStr,"附件数量不能为空!")
	 	q RetStr
	}

 	 	
	If ChangeType'="Test"
	{
		&SQL(Insert into SQLUSER.DHC_EQAffix(AF_EquipDR,AF_PartSpec,AF_PartModel,AF_QuantityNum,AF_PriceFee,AF_Remark,AF_CurrencyDR,AF_LeaveFacNo,AF_LeaveDate,AF_InValidFlag) values (:EquipDR,:Affix,:Model,:Qty,:Price,:Remark,:UOM,:LeaveFacNo,:AddDate,'N'))
		If SQLCODE s RetStr=..RetErrorValue(RetStr,"插入设备附件信息失败: 设备编号="_EqNo_" 附件="_Affix_" SQLCODE="_SQLCODE)
	}
	Quit:RetStr="" "OK"
	Quit RetStr
}

/// 创建：JDL 2009-09-7
/// 描述：导入设备调账信息
/// 访问表:DHC_EQChangeAccount
/// 输入：ChangeType：操作类别
/// 			RowStr：EqNo^Amount^Reason^Remark
/// 输出：无
/// 返回：成功返回"OK"，否则返回出错信息
/// 备注：
/// w ##class(web.DHCEQImportData2CSP).ChangeAccountInfo("","")
ClassMethod ChangeAccountInfo(ChangeType As %String = "", RowStr As %String = "")
{
	Quit:ChangeType="Clear" "未操作"
	
	s Flag="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
	
 	s EqNo=$p(RowStr,Flag,1)
 	s EquipDR=$o(^DHCEQEquip(0,"No",EqNo,0))
 	if (EquipDR="") q "没有找到该设备,请确认设备编号是否正确!"
 	
 	
 	Set AddDate=$Piece(RowStr,Flag,2)
 	i AddDate'="" s AddDate = $zdh(AddDate,3)
 	Set Amount=$Piece(RowStr,Flag,3)
 	Set Reason=$Piece(RowStr,Flag,4)
 	Set Remark=$Piece(RowStr,Flag,5)

	If ChangeType'="Test"
	{
		;&SQL(Insert into SQLUSER.DHC_EQChangeAccount(CA_EquipDR,CA_ChangeFee,CA_ChangedOriginalFee,CA_ChangedNetFee,CA_ChangeReason,CA_ChangeDate,CA_Remark) values (:EquipDR,:Amount,'','',:Reason,:AddDate,:Remark))
		&SQL(Insert into SQLUSER.DHC_EQChangeAccount(CA_EquipDR,CA_ChangeFee,CA_ChangeReason,CA_ChangeDate,CA_Remark,CA_Status) values (:EquipDR,:Amount,:Reason,:AddDate,:Remark,2))
		If SQLCODE s RetStr=..RetErrorValue(RetStr,"插入调账信息失败: 设备编号="_EqNo_" 调账原因="_Reason_" SQLCODE="_SQLCODE)
	}
	Quit:RetStr="" "OK"
	Quit RetStr
}

/// 创建：JDL 2009-09-22
/// 描述：导入列设置列信息
/// 访问表:DHC_EQCColumns
/// 输入：ChangeType：操作类别
/// 			RowStr：表ID,列名,隐藏标志,列标题,位置,备注,格式,排序,Hold1,Hold2,Hold3,Hold4,Hold5
/// 输出：无
/// 返回：成功返回"OK"，否则返回出错信息
/// 备注：
/// w ##class(web.DHCEQImportData2CSP).ImportColumns("","")
ClassMethod ImportColumns(ChangeType As %String = "", RowStr As %String = "")
{
	Quit:ChangeType="Clear" "未操作"
	
	s Flag="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
	
	k PLIST
	s PLIST(2)=$p(RowStr,Flag,1)	;TableID
	s PLIST(3)=$p(RowStr,Flag,2)	;Name
	
	s PLIST(4)=$p(RowStr,Flag,3)	;HiddenFlag
	s PLIST(5)=$p(RowStr,Flag,4)	;Caption
	s PLIST(6)=$p(RowStr,Flag,5)	;Location
	
	s PLIST(7)=$p(RowStr,Flag,6)	;Remark
	s PLIST(8)=$p(RowStr,Flag,7)	;Format
	s PLIST(9)=$p(RowStr,Flag,8)	;Sort
	s PLIST(10)=$p(RowStr,Flag,9)	;Hold1
	s PLIST(11)=$p(RowStr,Flag,10)	;Hold2
	s PLIST(12)=$p(RowStr,Flag,11)	;Hold3
	s PLIST(13)=$p(RowStr,Flag,12)	;Hold4
	s PLIST(14)=$p(RowStr,Flag,13)	;Hold5
	
	s TableID=PLIST(2)
	s ColName=PLIST(3)
 	if ((TableID="")||(ColName="")) q "列名或者表ID不能为空!" 
 	s ColumnID=""
 	&SQL(Select C_RowID into :ColumnID from SQLUSER.DHC_EQCColumns where C_TableDR=:TableID and C_Name=:ColName)
 	i ColumnID'="" q "在表中改列已经存在!  Table:"_TableID_"  ColName:"_ColName

	If ChangeType'="Test"
	{
		&SQL(Insert into SQLUSER.DHC_EQCColumns Values :PLIST())
		If SQLCODE s RetStr=..RetErrorValue(RetStr,"插入列信息失败: 列名="_PLIST(3)_" SQLCODE="_SQLCODE)
	}
	Quit:RetStr="" "OK"
	Quit RetStr
}

ClassMethod ImportDefineData(ChangeType As %String = "", RowStr As %String = "")
{
	q:ChangeType="Clear" "..."
	s del="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
	
	s sortNo=$p(RowStr,del,1)
	s name=$p(RowStr,del,2)
	s model=$p(RowStr,del,3)
	s qty=$p(RowStr,del,4)
	s unit=$p(RowStr,del,5)
	s originalfee=$p(RowStr,del,6)
	s loc=$p(RowStr,del,7)
	s status=$p(RowStr,del,8)
	s indate=$p(RowStr,del,9)
	
	s rowid=sortNo
	if ($p(^DHCEQEquip(rowid),"^",67)="")
	{
		if name'=$p(^DHCEQEquip(rowid),"^",1) s RetStr="名称不符:"_name_"<>"_$p(^DHCEQEquip(rowid),"^",1)
		q:RetStr'="" RetStr
		if originalfee'=$p(^DHCEQEquip(rowid),"^",27) s RetStr="金额不符:"_originalfee_"<>"_$p(^DHCEQEquip(rowid),"^",27)
		q:RetStr'="" RetStr
		
		if $ZDATEH(indate,3)'=$p(^DHCEQEquip(rowid),"^",45) s RetStr="入库日期不符:"_indate_"<>"_$p(^DHCEQEquip(rowid),"^",45)
		q:RetStr'="" RetStr
		if ChangeType'="Test" d
		.//&SQL(Update SQLUSER.DHC_EQEquip set eq_hold4=:loc Where eq_rowid=:rowid)
		.//i SQLCODE  s RetStr=..RetErrorValue(RetStr,"更新数据失败: ID="_rowid_" Desc="_name_" SQLCODE="_SQLCODE)
	
	}
	else
	{
		s RetStr="已有库房"
	}
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 医疗器械分类
/// add by jdl 2010-3-22
ClassMethod Tree(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCTree")
	;q:ChangeType="Clear" "数据不可清理:设备分类(DHC_EQCEquipeCat)"
	s del="^",RetStr=""
	SET RowStr=##Class(web.DHCEQCommon).Replace(RowStr," ","")
	s treeType=$p(RowStr,del,1)
 	s code=$p(RowStr,del,2) 	
 	s desc=$p(RowStr,del,3)
 	
 	s excode=$p(RowStr,del,4)
 	s remark=$p(RowStr,del,5)
 	
 	s parcode=$p(RowStr,del,6)
 	
 	s hold1=$p(RowStr,del,7)
 	s hold2=$p(RowStr,del,8)
 	s hold3=$p(RowStr,del,9)
 	
 	if treeType="" s RetStr=..RetErrorValue(RetStr,"树类型不能为空DHC_EQCTree:")
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCTree:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCTree:")
 	if RetStr'="" q RetStr
 	
 	s ID=$o(^DHCEQCCode("DHCEQCTree",0,"TypeCode",treeType,code,0))
 	if ID'="" q ..RetErrorValue(RetStr,"编码已经存在DHC_EQCTree:"_code)
 	
 	k PLIST
 	s PLIST(2) = treeType
    s PLIST(3) = code
    s PLIST(4) = desc
    s PLIST(5) = "0"				//T_ParTreeDR
    
    if excode'="" s PLIST(6) = excode
    if remark'="" s PLIST(7) = remark
    
    if hold1'="" s PLIST(8) = hold1
    if hold2'="" s PLIST(9) = hold2
    if hold3'="" s PLIST(10) = hold3    
    
    s PLIST(18) = "N"
    
    i parcode=""
    {
	    s parcode=code
	    s parcode=##Class(web.DHCEQCommon).Replace(parcode,"-","")
	 	s len=$l(parcode)
	 	
		s parref=""
		for i=len:-1:1
		{
			q:parref'=""
			//Modified by JDL 2009-8-10
			s parcode=$e(parcode,1,i)
			//s parcode=##Class(web.DHCEQCommon).LPAD(parcode,"0",6)
			
			s parref=$o(^DHCEQCCode("DHCEQCTree",0,"TypeCode",treeType,parcode,0))
			if (parref'="")
			{ 
				s PLIST(5)=	parref
			}
		}
    }
    else
    {
	    s parcode=##Class(web.DHCEQCommon).Replace(parcode,"-","")
	    s parref=$o(^DHCEQCCode("DHCEQCTree",0,"TypeCode",treeType,parcode,0))
		if (parref'="")
		{ 
			s PLIST(5)=	parref
		}
	}
	if ChangeType'="Test" d
 	.&SQL(Insert Into SQLUSER.DHC_EQCTree Values :PLIST())
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2010-07-26 ZY0025
/// 描述：导入库房管理科室数据
/// 访问表:DHC_EQCStoreManageLoc
/// 输入：ChangeType：操作类别
/// 	RowStr：库房^被管理科室^备注
/// w ##class(web.DHCEQImportData2CSP).StoreManageLoc("","产科^综合二科^备注")
ClassMethod StoreManageLoc(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCStoreManageLoc")
	q:ChangeType="Clear" "数据已清:库房管理科室(DDHC_EQCStoreManageLoc)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s Storeloc=$p(RowStr,del,1),loc=$p(RowStr,del,2),remark=$p(RowStr,del,3)
 	s Storeloc=##Class(web.DHCEQCommon).Trim(Storeloc)
 	s loc=##Class(web.DHCEQCommon).Trim(loc)
 	s remark=##Class(web.DHCEQCommon).Trim(remark)
 	i Storeloc="" s RetStr=..RetErrorValue(RetStr,"库房不能为空DDHC_EQCStoreManageLoc:")
 	i loc="" s RetStr=..RetErrorValue(RetStr,"科室不能为空DDHC_EQCStoreManageLoc:")
 	if RetStr'="" q RetStr
 	k PLIST
 	i Storeloc'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetStoreLocID(Storeloc)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到库房:库房="_Storeloc)
	.e  d
	..s PLIST(2)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有找到库房:库房="_Storeloc)
 	
 	i loc'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(loc)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室:科室="_loc)
	.e  d
	..s PLIST(3)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有科室:科室="_loc)
	s PLIST(4)=remark
 	if RetStr'="" q RetStr 
    if ChangeType'="Test"  d
    .&SQL(Insert Into SQLUSER.DHC_EQCStoreManageLoc Values :PLIST()) //2010-07-02
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: 库房="_Storeloc_" 科室="_loc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/***************************************************************/
/// Add By DJ 2010-10-20
/// 描述:设备级别树导入
ClassMethod TreeMap(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCTreeMap")
	q:ChangeType="Clear" "数据已清:科室类型(DHC_EQCTreeMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s sourcetype=$p(RowStr,del,1), type=$p(RowStr,del,2),partree=$p(RowStr,del,3),curtree=$p(RowStr,del,4)
 	s sourcetype=##Class(web.DHCEQCommon).Trim(sourcetype)
 	s type=##Class(web.DHCEQCommon).Trim(type)
 	s partree=##Class(web.DHCEQCommon).Trim(partree)
 	s curtree=##Class(web.DHCEQCommon).Trim(curtree)
 	if sourcetype="" s RetStr=..RetErrorValue(RetStr,"来源类型不能为空DHC_EQCTreeMap:")
 	if type="" s RetStr=..RetErrorValue(RetStr,"类型不能为空DHC_EQCTreeMap:")
 	if partree="" s RetStr=..RetErrorValue(RetStr,"父节点不能为空DHC_EQCTreeMap:")
 	if curtree="" s RetStr=..RetErrorValue(RetStr,"子节点不能为空DHC_EQCTreeMap:")
 	if RetStr'="" q RetStr
 	k PLIST
 	
 	i sourcetype="CT_Loc"  d //科室级别树
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(curtree)
 	.i tmpid=""  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到子节点:科室="_curtree)
 	.e  d
 	..s PLIST(4)=tmpid
 	..s Find=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",type,tmpid,0))
 	..i Find'=""  d
	...s FindPar=$p($g(^DHCEQCCode("DHCEQCTreeMap",Find)),"^",4)
	...s FindDesc=##Class(web.DHCEQCTreeMap).GetTreeDesc(FindPar)
	...s RetStr=..RetErrorValue(RetStr,"子节点重复:["_curtree_"]已在["_FindDesc_"]中存在!")
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(partree)
	.i tmpid=""  d
	..s Find=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",type,partree,0))
	..i Find=""  d
	...s RetStr=..RetErrorValue(RetStr,"没有找到父节点:科室="_partree)
	..e  d
	...s tmpid=partree
	.i tmpid'="" d
	..s Find=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",type,tmpid,0))
	..i Find'=""  d
	...s PLIST(5)=Find
	..e  d
	...s RetStr=..RetErrorValue(RetStr,"父节点不存在:父节点="_partree)
	
 	if RetStr'="" q RetStr 
 	
    if ChangeType'="Test"  d
    .s PLIST(2)=sourcetype
    .s PLIST(3)=type
    .s PLIST(13)="N"
    .&SQL(Insert Into SQLUSER.DHC_EQCTreeMap Values :PLIST()) //2010-07-02
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: 父节点="_partree_" 子节点="_curtree_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2010-07-26 ZY0025
/// 描述：导入库房管理科室数据
/// 输入：ChangeType：操作类别
/// 	RowStr：设备编号^检验科设备^
/// w ##class(web.DHCEQImportData2CSP).DeviceMap("","213000058^AC1500^备注")
ClassMethod DeviceMap(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQDeviceMap
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s EquipNo=$p(RowStr,del,1),DeviceID=$p(RowStr,del,2),Remark=$p(RowStr,del,3)
 	s EquipNo=##Class(web.DHCEQCommon).Trim(EquipNo)
 	s DeviceID=##Class(web.DHCEQCommon).Trim(DeviceID)
 	s Remark=##Class(web.DHCEQCommon).Trim(Remark)
 	i EquipNo="" s RetStr=..RetErrorValue(RetStr,"设备编号不能为空DHC_EQDeviceMap:")
 	i DeviceID="" s RetStr=..RetErrorValue(RetStr,"检验系统设备不能为空DHC_EQDeviceMap:")
 	if RetStr'="" q RetStr
 	k PLIST
 	i EquipNo'=""  d
	.&SQL(Select EQ_RowID into :tmpid  from sqluser.DHC_EQEquip where EQ_No=:EquipNo)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"设备管理系统中没有找到设备:设备编号="_EquipNo)
	.e  d
	..s PLIST(2)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"设备管理系统中没有找到设备:设备编号="_EquipNo)
 	
 	i DeviceID=""  d
 	.s RetStr=..RetErrorValue(RetStr,"检验系统中没有找到设备:设备="_DeviceID)
 	e  d
 	.s flag=0
 	.s rowid=0
 	.f  s rowid=$o(^TMIF(rowid))  quit:rowid=""||flag'=0  d
 	..s (LTRowID,LName)=""
 	..s LTRowID = rowid	//rowid
 	..i DeviceID=LTRowID s flag=1 //找到了该设备
 	..q:flag=0 
 	..s LName=$p($g(^TMIF(rowid)),"\",1)
 	..s PLIST(3)=DeviceID
 	..s PLIST(13)=LName
 	.i flag=0  d
 	..s RetStr=..RetErrorValue(RetStr,"检验系统中没有找到设备:设备="_DeviceID)
	
	s PLIST(4)="DHC-LIS"
	s PLIST(5)=Remark
	s PLIST(12)="N"
 	if RetStr'="" q RetStr 
    if ChangeType'="Test"  d
    .&SQL(Insert Into SQLUSER.DHC_EQDeviceMap Values :PLIST())
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: EquipNo="_EquipNo_" DeviceID="_DeviceID_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/***************************************************************/
/// 创建：zy 2010-11-11  ZY0040
/// 描述：处理大量的设备转科
/// 输入：ChangeType：操作类别
/// 	RowStr：液氮罐^皮肤科^组织标本库^4525^2009014500005
/// w ##class(web.DHCEQImportData2CSP).EquipChangeLoc("","液氮罐^皮肤科^组织标本库^4525^2009014500005")
ClassMethod EquipChangeLoc(ChangeType As %String = "", RowStr As %String = "")
{
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s Name=$p(RowStr,del,1),OldLoc=$p(RowStr,del,2),NewLoc=$p(RowStr,del,3),Price=$p(RowStr,del,4),No=$p(RowStr,del,5)
 	s Name=##Class(web.DHCEQCommon).Trim(Name)
 	s OldLoc=##Class(web.DHCEQCommon).Trim(OldLoc)
 	s NewLoc=##Class(web.DHCEQCommon).Trim(NewLoc)
 	s Price=##Class(web.DHCEQCommon).Trim(Price)
 	s No=##Class(web.DHCEQCommon).Trim(No)
 	i No="" s RetStr=..RetErrorValue(RetStr,"No不能为空")
 	i Name="" s RetStr=..RetErrorValue(RetStr,"Name不能为空")
 	i OldLoc="" s RetStr=..RetErrorValue(RetStr,"OldLoc不能为空")
 	i NewLoc="" s RetStr=..RetErrorValue(RetStr,"NewLoc不能为空")
 	i Price="" s RetStr=..RetErrorValue(RetStr,"Price不能为空")
 	
 	if RetStr'="" q RetStr
 	k PLIST
 	i OldLoc'=""  d
	s (tmpid,OldLocID)=""
	&SQL(Select ctloc_rowid into :tmpid  from sqluser.ct_loc where ctloc_Code=:OldLoc)
	i tmpid'="" d
	.s OldLocID=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr, OldLoc_"不存在")	
	i RetStr'="" q RetStr
	
 	i NewLoc'=""  d
	s (tmpid,NewLocID)=""
	&SQL(Select ctloc_rowid into :tmpid  from sqluser.ct_loc where ctloc_Code=:NewLoc)
	i tmpid'="" d
	.s NewLocID=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr, NewLoc_"不存在")
	i RetStr'="" q RetStr
	
	s (tmpid,EquipID,EQName,EQPeice,EQUseLoc,EQStoreLoc)=""
 	i No'=""  d
	.&SQL(Select EQ_RowID into :tmpid  from sqluser.DHC_EQEquip where EQ_No=:No)
	.i tmpid="" d
	..s RetStr=..RetErrorValue(RetStr, No_"编号设备不存在")
	.e  d
	..s EquipID=tmpid
	..i $D(^DHCEQLifeInfo(0,"Equip",EquipID))'=0 s RetStr=..RetErrorValue(RetStr,No_"有业务单据")
	..q:RetStr'=""
	..s EQName=$p($g(^DHCEQEquip(EquipID)),"^",1)
	..i Name'=EQName s RetStr=..RetErrorValue(RetStr,No_"^Name不对")
	..q:RetStr'=""
	..s EQPeice=$p($g(^DHCEQEquip(EquipID)),"^",27)
	..s EQPeice=##Class(web.DHCEQCommon).FormatNumber(EQPeice,"",2)
	..i Price'=EQPeice s RetStr=..RetErrorValue(RetStr,No_"^Price不对")
	..q:RetStr'=""
	..s EQUseLoc=$p($g(^DHCEQEquip(EquipID)),"^",19)
	..s EQStoreLoc=$p($g(^DHCEQEquip(EquipID)),"^",67)
	..i EQUseLoc'=EQStoreLoc s RetStr=..RetErrorValue(RetStr,No_"原使用科室和库房不对")
	..i OldLocID'=EQStoreLoc s RetStr=..RetErrorValue(RetStr,No_"^科室对不上")
 	..s PLIST(35)=""
 	..s PLIST(67)=""
 	..s PLIST(20)=NewLocID
 	..s PLIST(68)=NewLocID
	..i (RetStr="")&(ChangeType="Append") d
	...&SQL(Update sqluser.DHC_EQEquip  Values :PLIST()  where EQ_RowID=:EquipID)
	...i SQLCODE s RetStr=..RetErrorValue(RetStr,"更新失败!")
	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2010-11-11  ZY0043
/// 描述：服务项目，主要是his里面的设备分析取到设备能做的医嘱项
/// 输入：ChangeType：操作类别
/// 	RowStr：EX_ID^Code^服务项^EquipID
///  w ##class(web.DHCEQImportData2CSP).EquipServiceConsumableItem("","设备^2282^6842||1^BCSJMRPS^臂丛神经MR平扫^胶片^1")
///  w ##class(web.DHCEQImportData2CSP).EquipServiceConsumableItem("","设备^2282^6857||1^CTPS+ZQ^垂体平扫+增强^胶片^1")
ClassMethod EquipServiceConsumableItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQCCode("DHCEQCConsumableItem")
	.;k ^DHCEQEquipService
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s SourceType=$p(RowStr,del,1),SourceID=$p(RowStr,del,2)
 	s SIEXID=$p(RowStr,del,3),SICode=$p(RowStr,del,4),SIDesc=$p(RowStr,del,5)
 	s ConsumableItem=$p(RowStr,del,6),Quantity=$p(RowStr,del,7)
 	
 	s SourceType=##Class(web.DHCEQCommon).Trim(SourceType)
 	s SourceID=##Class(web.DHCEQCommon).Trim(SourceID)
 	s SIEXID=##Class(web.DHCEQCommon).Trim(SIEXID)
 	s SICode=##Class(web.DHCEQCommon).Trim(SICode)
 	s SIDesc=##Class(web.DHCEQCommon).Trim(SIDesc)
 	s ConsumableItem=##Class(web.DHCEQCommon).Trim(ConsumableItem)
 	s Quantity=##Class(web.DHCEQCommon).Trim(Quantity)

 	i SourceType="" s RetStr=..RetErrorValue(RetStr,"来源类型不能为空")
 	i SourceID="" s RetStr=..RetErrorValue(RetStr,"来源ID不能为空")
 	i SIEXID="" s RetStr=..RetErrorValue(RetStr,"医嘱项ID不能为空")
 	i SICode="" s RetStr=..RetErrorValue(RetStr,"服务项Code不能为空")
 	i SIDesc="" s RetStr=..RetErrorValue(RetStr,"服务项Desc不能为空")
 	i ConsumableItem="" s RetStr=..RetErrorValue(RetStr,"消耗项不能为空")
 	i Quantity="" s RetStr=..RetErrorValue(RetStr,"消耗项数量不能为空")
 	if RetStr'="" q RetStr
 	i SourceType="设备" s SourceType="1"
 	i SourceType="设备项" s SourceType="2"
 	k PLIST,PESList,PSCList
 	
 	s PLIST(2)=SIDesc
 	s PLIST(3)=SICode
 	s PLIST(4)=""
 	s PLIST(5)=""
 	s PLIST(6)="DHC-HIS"
 	s PLIST(7)=SIEXID
 	s PLIST(8)=""
 	s PLIST(9)="N"
 	s PLIST(10)=""
 	s PLIST(11)=""
 	s PLIST(12)=""
 	s PLIST(13)="N"
 	s PLIST(14)=""
 	s PLIST(15)=SIDesc
 	
 	s (tmpid,SIRowID)=""
	&SQL(Select SI_RowID into :tmpid  from sqluser.DHC_EQCServiceItem where SI_Desc=:SIDesc and SI_ExID=:SIEXID and SI_ExType='DHC-HIS')
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务相中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceItem Values :PLIST())
	..s SIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"服务项插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
	s PESList(2)=SourceType					//SourceType
	s PESList(3)=SourceID 					//SourceID
	s PESList(4)=$p($g(^DHCEQEquip(SourceID)),"^",3)				//ModelDR
	s PESList(5)=SIRowID 					//ServiceDR
	s PESList(6)="" 						//MinMinutes
	s PESList(7)=""							//MinutesPerTimes
	s PESList(8)="" 						//MaxMinutes
	s PESList(9)="" 						//Remark
	s PESList(10)="N"
	s (tmpid)=""
	&SQL(Select ES_RowID into :tmpid  from sqluser.DHC_EQEquipService where ES_SourceType=:SourceType and ES_SourceID=:SourceID and ES_ModelDR=:PESList(4) and ES_ServiceDR=:SIRowID and ES_InvalidFlag='N')
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务项中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQEquipService Values :PESList())
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
	s PSCList(2)=SourceType					//SourceType
	s PSCList(3)=SourceID 					//SourceID
	s PSCList(4)=SIRowID					//ServiceItemDR
	s PSCList(7)=Quantity					//quantity
	s PSCList(8)=$p($g(^DHCEQEquip(SourceID)),"^",3)		//ModelDR
	
 	s (tmpid)=""
	&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_Desc=:ConsumableItem and CI_InvalidFlag='N')
	i tmpid=""  d
	.s RetStr=..RetErrorValue(RetStr,"消耗项没有找到^"_ConsumableItem)
	e  d
	.s PSCList(5)=tmpid											//ConsumableItemDR
	.s PSCList(6)=$p($g(^DHCEQCCode("DHCEQCConsumableItem",tmpid)),"^",4)		//uomDR
	i RetStr'="" q RetStr
	
	s (tmpid)=""
	&SQL(Select SIC_RowID into :tmpid  from sqluser.DHC_EQCServiceConsumable where SIC_SourceType=:SourceType and SIC_SourceID=:SourceID and SIC_ModelDR=:PSCList(6) and SIC_ServiceItemDR=:SIRowID)
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务项中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PSCList())
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
 		
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2011-03-03  ZY0063
/// 描述：根据已经做好的His设备服务项,导入服务项对应的收费项以及每个收费项对用的消耗明细.
/// 输入：ChangeType：操作类别
/// 	RowStr：设备ID^医嘱项ID^收费项ID^EquipID^消耗材料ID
///  w ##class(web.DHCEQImportData2CSP).EquipServiceDetails("Append","2282^16830||1^14147^1")
ClassMethod EquipServiceDetails(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQCCode("DHCEQCConsumableItem")
	.;k ^DHCEQEquipService
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s EquipID=$p(RowStr,del,1),ARCIMID=$p(RowStr,del,2),TARItemID=$p(RowStr,del,3),INCIID=$p(RowStr,del,4)
 	
 	s EquipID=##Class(web.DHCEQCommon).Trim(EquipID)
 	s ARCIMID=##Class(web.DHCEQCommon).Trim(ARCIMID)
 	s TARItemID=##Class(web.DHCEQCommon).Trim(TARItemID)
 	s INCIID=##Class(web.DHCEQCommon).Trim(INCIID)

 	i EquipID="" s RetStr=..RetErrorValue(RetStr,"设备ID不能为空")
 	i ARCIMID="" s RetStr=..RetErrorValue(RetStr,"医嘱项ID不能为空")
 	i TARItemID="" s RetStr=..RetErrorValue(RetStr,"收费项ID不能为空")
 	i INCIID="" s RetStr=..RetErrorValue(RetStr,"消耗材料ID不能为空")
 	if RetStr'="" q RetStr
 	
 	k PLIST,PSIList,PCILIST,PSICLIST
 	
 	i $D(^DHCEQCCode("DHCEQCServiceItem",0,"ExID","DHC-HIS",ARCIMID)) d
 	.s ServiceItemID=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID","DHC-HIS",ARCIMID,""))
 	i ServiceItemID="" s RetStr=..RetErrorValue(RetStr,"服务项不存在"_ARCIMID)
 	if RetStr'="" q RetStr
 	
 	s TARCode=$p($g(^DHCTARI(TARItemID)),"^",1)  ;Code
 	s TARDesc=$p($g(^DHCTARI(TARItemID)),"^",2)  ;Desc
 	s TARUOM=$p($g(^DHCTARI(TARItemID)),"^",3)	 ;UOM
 	s TARPrice=$p($g(^DHCTARI(TARItemID)),"^",8)  ;Price
 	
	s vDate=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARItemID,""))
	i vDate'="" d
	.s OLTRowID=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARItemID,vDate,""))
	.i OLTRowID'="" s Qty=$p($g(^DHCOLT(OLTRowID)),"^",3)
	
 	s PLIST(2)=TARDesc		;Desc
 	s PLIST(3)=TARCode		;Code
 	s PLIST(4)=TARUOM		;UnitDR
 	s PLIST(5)=TARPrice		;Price
 	s PLIST(6)="2"			;ExType
 	s PLIST(7)=TARItemID	;ExID
 	s PLIST(8)=""			;Remark		
 	s PLIST(9)="Y"			;ImportFlag
 	s PLIST(10)=""			;MinMinutes	
 	s PLIST(11)=""			;MinutesPerTime
 	s PLIST(12)=""			;MaxMinutes
 	s PLIST(13)=""			;InvalidFlag
 	s PLIST(14)=+$h			;UpdateDate
 	s PLIST(15)=TARDesc		;ExDesc
 	
 	s (tmpid)=""
	&SQL(Select SDI_RowID into :tmpid  from sqluser.DHC_EQCServDetItem where SDI_ExID=:TARItemID and SDI_InvalidFlag='N' and SDI_ExType='DHC-HIS')
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务细项中有重复……"_TARItemID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServDetItem Values :PLIST())
	..s SDIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"服务细项插入记录失败……"_TARItemID)
	i RetStr'="" q RetStr
	
	i SDIRowID="" q "OK"
	
	s PSIList(2)=ServiceItemID				;ServiceItemDR
	s PSIList(3)=SDIRowID 					;ServDetItemDR
	s PSIList(4)=Qty						;Quantity
	s PSIList(5)=""		 					;Remark
	s PSIList(6)="" 						;InvalidFlag
	
	s (tmpid)=""
	&SQL(Select SD_RowID into :tmpid  from sqluser.DHC_EQCServiceDetails where SD_ServiceItemDR=:ServiceItemID and SD_ServDetItemDR=:SDIRowID and SD_InvalidFlag='N')
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务项与细项中有重复……"_SDIRowID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceDetails Values :PSIList())
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"服务项与细项对照插入记录失败……"_SDIRowID)
	i RetStr'="" q RetStr
	
	///消耗项目明细
	//INCIID
	s INCICode=$p($g(^INCI(INCIID,1)),"^",1)  ;Code
	s INCIDesc=$p($g(^INCI(INCIID,1)),"^",2)  ;Desc
	s INCIPrice=$p($g(^INCI(INCIID,1)),"^",5)  ;Price
	s INCIUomDR=$p($g(^INCI(INCIID,1)),"^",10)  ;UomDR
	
	s PCILIST(2)=INCIDesc			;Desc
	s PCILIST(3)=INCICode			;Code
	s PCILIST(4)=INCIPrice			;Price
	s PCILIST(5)=INCIUomDR			;UomDR
	s PCILIST(6)="DHC-ST"			;ExType 
	s PCILIST(7)=INCIID				;ExID
	s PCILIST(8)=""					;InvalidFlag
	s PCILIST(9)=INCIDesc			;ExDesc 
	
	s (tmpid)=""
	&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_ExType='DHC-ST' and CI_ExID=:INCIID and CI_InvalidFlag='N')
	i tmpid=""  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCConsumableItem Values :PCILIST())
	..s CIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"消耗项插入记录失败……"_INCIID)
	i RetStr'="" q RetStr
	
	///服务项对应消耗项目
	s PSICLIST(2)="1"			;SourceType
	s PSICLIST(3)=EquipID		;SourceID
	s PSICLIST(4)=ServiceItemID	;ServiceItemDR
	s PSICLIST(5)=CIRowID		;ConsumableItemDR
	s PSICLIST(6)=INCIUomDR		;UomDR
	s PSICLIST(7)="1"			;Quantity
	s PSICLIST(8)=$p($g(^DHCEQEquip(EquipID)),"^",3)	;ModelDR
	s PSICLIST(9)="2"			;QuantityType  
	s PSICLIST(10)=SDIRowID		;ServDetItemDR
		
	s (tmpid)=""
	&SQL(Select SIC_RowID into :tmpid  from sqluser.DHC_EQCServiceConsumable where SIC_SourceType='1' and SIC_SourceID=:EquipID and SIC_ServiceItemDR=:ServiceItemID and SIC_ConsumableItemDR=:CIRowID and SIC_ServDetItemDR=:SDIRowID)
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务项消耗项对照中有重复……"_CIRowID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PSICLIST())
	..s CIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"服务项消耗项对照插入记录失败……"_CIRowID)
	i RetStr'="" q RetStr
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2011-03-03  ZY0063
/// 描述：效益分析设备对应his里面的服务项(医嘱项)
/// 输入：ChangeType：操作类别
/// 	RowStr：设备^设备ID^医嘱项ID
///  w ##class(web.DHCEQImportData2CSP).EquipServiceConsumableItem("","设备^2282^16830||1")
///  w ##class(web.DHCEQImportData2CSP).EquipServiceItem("Append","设备^2282^16830||1")
ClassMethod EquipServiceItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.;k ^DHCEQCCode("DHCEQCConsumableItem")
	.;k ^DHCEQEquipService
	q:ChangeType="Clear" "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s SourceType=$p(RowStr,del,1),SourceID=$p(RowStr,del,2)
 	s SIEXID=$p(RowStr,del,3)
 	
 	s SourceType=##Class(web.DHCEQCommon).Trim(SourceType)
 	s SourceID=##Class(web.DHCEQCommon).Trim(SourceID)
 	s SIEXID=##Class(web.DHCEQCommon).Trim(SIEXID)

 	i SourceType="" s RetStr=..RetErrorValue(RetStr,"来源类型不能为空")
 	i SourceID="" s RetStr=..RetErrorValue(RetStr,"来源ID不能为空")
 	i SIEXID="" s RetStr=..RetErrorValue(RetStr,"医嘱项ID不能为空")
 	
 	s subscript=$p(SIEXID,"||",1)
 	s version=$p(SIEXID,"||",2)
 	S SICode=$p($g(^ARCIM(subscript,version,1)),"^",1)
 	S SIDesc=$p($g(^ARCIM(subscript,version,1)),"^",2)
 	
 	i SICode="" s RetStr=..RetErrorValue(RetStr,"服务项Code不能为空")
 	i SIDesc="" s RetStr=..RetErrorValue(RetStr,"服务项Desc不能为空") 	
 	if RetStr'="" q RetStr
 	
 	i SourceType="设备" s SourceType="1"
 	i SourceType="设备项" s SourceType="2"
 	k PLIST,PESList
 	
 	s PLIST(2)=SIDesc
 	s PLIST(3)=SICode
 	s PLIST(4)=""
 	s PLIST(5)=""
 	s PLIST(6)="DHC-HIS"
 	s PLIST(7)=SIEXID
 	s PLIST(8)=""
 	s PLIST(9)="N"
 	s PLIST(10)=""
 	s PLIST(11)=""
 	s PLIST(12)=""
 	s PLIST(13)="N"
 	s PLIST(14)=""
 	s PLIST(15)=SIDesc
 	
 	s (tmpid,SIRowID)=""
	&SQL(Select SI_RowID into :tmpid  from sqluser.DHC_EQCServiceItem where SI_Desc=:SIDesc and SI_ExID=:SIEXID and SI_ExType='DHC-HIS')
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务相中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceItem Values :PLIST())
	..s SIRowID=$G(%ROWID)
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"服务项插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
	s PESList(2)=SourceType					//SourceType
	s PESList(3)=SourceID 					//SourceID
	s PESList(4)=$p($g(^DHCEQEquip(SourceID)),"^",3)				//ModelDR
	s PESList(5)=SIRowID 					//ServiceDR
	s PESList(6)="" 						//MinMinutes
	s PESList(7)=""							//MinutesPerTimes
	s PESList(8)="" 						//MaxMinutes
	s PESList(9)="" 						//Remark
	s PESList(10)="N"
	s (tmpid)=""
	&SQL(Select ES_RowID into :tmpid  from sqluser.DHC_EQEquipService where ES_SourceType=:SourceType and ES_SourceID=:SourceID and ES_ModelDR=:PESList(4) and ES_ServiceDR=:SIRowID and ES_InvalidFlag='N')
	i tmpid'=""  d
	.s RetStr=..RetErrorValue(RetStr,"服务项中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQEquipService Values :PESList())
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
	i RetStr'="" q RetStr
	
 	q:RetStr="" "OK"
	q RetStr
}

/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：根据Type的值对数据进行更新,提交,反提交,删除,审核操作。
///  w ##class(web.DHCEQImportData2CSP).BatchDisuseRequest("Append","2003034500160^泌尿外科^31500.00^在科室,已填报废单")
/// ----------------------------------
ClassMethod BatchDisuseRequest(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQDisuseRequest
	.k ^DHCEQDisuseRequestList
	q:ChangeType="Clear" "数据已清:设备报废DHCEQDisuseRequest"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s EquipNo=$p(RowStr,del,1),UseLoc=$p(RowStr,del,2)
 	s Fee=$p(RowStr,del,3),Remark=$p(RowStr,del,4)
 	
 	s EquipNo=##Class(web.DHCEQCommon).Trim(EquipNo)
 	s UseLoc=##Class(web.DHCEQCommon).Trim(UseLoc)
 	//s StoreLocID=##Class(web.DHCEQCommon).Trim(StoreLocID)
 	s Fee=##Class(web.DHCEQCommon).Trim(Fee)
 	s Remark=##Class(web.DHCEQCommon).Trim(Remark)

 	i EquipNo="" s RetStr=..RetErrorValue(RetStr,"EquipNo不能为空")
 	i UseLoc="" s RetStr=..RetErrorValue(RetStr,"UseLoc不能为空") 	
 	
 	s (tmpid,EquipID)=""
 	&SQL(Select EQ_RowID into :tmpid  from sqluser.DHC_EQEquip where EQ_No=:EquipNo)
	i tmpid'="" d
	.s EquipID=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"设备没找到---"_EquipNo)
 	i RetStr'="" q RetStr
 	/*
	s (tmpid,UseLocID)=""
	&SQL(Select ctloc_rowid into :tmpid  from sqluser.ct_loc where ctloc_Code=:UseLoc)
	i tmpid'="" d
	.s UseLocID=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr, UseLoc_"不存在")	
	i RetStr'="" q RetStr
	*/
 	s TUseLocDR = $p($g(^DHCEQEquip(EquipID)),"^",19)
 	s TOriginalFee = $p($g(^DHCEQEquip(EquipID)),"^",27)
 	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
 	//s TStoreLocDR = $p($g(^DHCEQEquip(EquipID)),"^",67)
 	
 	//i TUseLocDR'=UseLocID s RetStr=..RetErrorValue(RetStr,"使用科室不一样  "_TUseLocDR_"^"_UseLocID)
 	//i RetStr'="" q RetStr
 	
 	i TOriginalFee'=Fee s RetStr=..RetErrorValue(RetStr,"原值不一样  "_TOriginalFee_"^"_Fee)
 	i RetStr'="" q RetStr
 	
 	//i TStoreLocDR'=StoreLocID s RetStr=..RetErrorValue(RetStr,"库房不一样  "_TStoreLocDR_"^"_StoreLocID)
 	
 	IF ChangeType'="Test"
 	{	 	
		s Date=+$H
	 	set (RowID,GroupDR,UseState,DisuseTypeDR,ChangeReason,RequestNo,TotleTime,Income,CheckResult)=""
	 	set (TechnicEvaluate,RepairHours,RepairFee,RepairTimes,ChangeReason,RequestNo,TotleTime,Income,CheckResult,InStockListDR)=""
	 	set RequestLocDR="410"
	 	set RequestDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	 	set DisureDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	 	set Status="1"
	 	set LocDR=TUseLocDR
	 	set LimitYears=$p($g(^DHCEQEquip(EquipID)),"^",31)
	 	set EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
	 	set KindFlag=0
	 	
	 	set val=RowID_"^"_EquipID_"^"_GroupDR_"^"_RequestLocDR_"^"_RequestDate_"^"_UseState
	  	set val=val_"^"_DisuseTypeDR_"^"_ChangeReason_"^"_DisureDate_"^"_Remark
	  	for i=11:1:33
		{
			set val=val_"^"
		}
		set val=val_"^"_RequestNo_"^"_LocDR_"^"_TotleTime_"^"_Income_"^"_CheckResult_"^"_TechnicEvaluate_"^"_RepairHours
		set val=val_"^"_RepairFee_"^"_RepairTimes_"^"_LimitYears_"^"_KindFlag_"^"_InStockListDR_"^^^"_EquipTypeDR
	 
	 	s rowid=##class(web.DHCEQBatchDisuseRequest).UpdateData("","",val,0)	//更新
	 	if rowid<=0 s RetStr=..RetErrorValue(RetStr,EquipNo_"报废申请单更新失败..."_rowid)
	 	i RetStr'="" q RetStr
	 	
		set rowid=##class(web.DHCEQBatchDisuseRequest).UpdateData("","",rowid,1)	//提交
	 	if rowid<=0 s RetStr=..RetErrorValue(RetStr,EquipNo_"报废申请单提交失败..."_rowid)
	 	i RetStr'="" q RetStr
	 	
	 	set val=rowid_"^2^1^同意^"
		set rowid=##class(web.DHCEQBatchDisuseRequest).UpdateData("","",val,5)  //Type=5 审核
	 	if rowid<=0 s RetStr=..RetErrorValue(RetStr,EquipNo_"报废申请单第一步审核失败...")
	 	i RetStr'="" q RetStr
	 	
	 	set val=rowid_"^18^2^同意^"
		set rowid=##class(web.DHCEQBatchDisuseRequest).UpdateData("","",val,5)
	 	if rowid<=0 s RetStr=..RetErrorValue(RetStr,"EquipNo报废申请单第一步审核失败...")
	 }
	 q RetStr
}

/// 创建：zy 2011-03-03  ZY0063
/// 描述：效益分析设备对应his里面的服务项(医嘱项)
/// 输入：ChangeType：操作类别
/// 	RowStr：ExType^SourceType^SourceID^收费项Code^医嘱项
///  w ##class(web.DHCEQImportData2CSP).ServiceItemAndDetItemByCode("Append","DHC-HIS^设备^1^120100011^111||1")
ClassMethod ServiceItemAndDetItemByCode(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCServiceDetails")
	.k ^DHCEQCCode("DHCEQCServiceItem")
	.k ^DHCEQCCode("DHCEQCServDetItem")
	.k ^DHCEQEquipService
	quit:ChangeType="Clear" ""
	IF ChangeType="Clear"  quit "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s ExType=$p(RowStr,del,1),SourceType=$p(RowStr,del,2),SourceID=$p(RowStr,del,3)
 	s TARICode=$p(RowStr,del,4),ExID=$p(RowStr,del,5)
  
 	s ExType=##Class(web.DHCEQCommon).Trim(ExType)
 	s SourceType=##Class(web.DHCEQCommon).Trim(SourceType)
 	s SourceID=##Class(web.DHCEQCommon).Trim(SourceID)
 	s TARICode=##Class(web.DHCEQCommon).Trim(TARICode)
 	s ExID=##Class(web.DHCEQCommon).Trim(ExID)
 	
 	i SourceType="设备" s SourceType="1"
 	i SourceType="设备项" s SourceType="2"
	
 	i ExType="" s RetStr=..RetErrorValue(RetStr,"分析来源类型不能为空")
 	i SourceType="" s RetStr=..RetErrorValue(RetStr,"来源类型不能为空")
 	i SourceID="" s RetStr=..RetErrorValue(RetStr,"来源ID不能为空")
 	i TARICode="" s RetStr=..RetErrorValue(RetStr,"TARICode不能为空")
 	//i ExID="" s RetStr=..RetErrorValue(RetStr,"ExID不能为空")
 	if RetStr'="" q RetStr
 	 	
	//取收费项目ID	//^DHCOLT(0,"TAR",{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})
	s TARIID=""
	s TARICode=$ZCONVERT(TARICode,"U")
 	if $Data(^DHCTARI(0,"Code",TARICode))'=0 d
 	.s TARIID=$o(^DHCTARI(0,"Code",TARICode,0))
	i TARIID="" s RetStr=..RetErrorValue(RetStr,"收费项不存在……"_TARICode)
	i RetStr'="" q RetStr
 	
 	//通过收费项目到DHC_OrderLinkTar表中循环找医嘱项
 	if $data(^DHCOLT(0,"TAR",TARIID)) d
 	.s OLTStartDate=0
 	.for  s OLTStartDate=$o(^DHCOLT(0,"TAR",TARIID,OLTStartDate)) quit:OLTStartDate=""  d
 	..s oltrowid=0
 	..for  s oltrowid=$o(^DHCOLT(0,"TAR",TARIID,OLTStartDate,oltrowid)) quit:oltrowid=""  d
 	...s ARCIMID=$p($g(^DHCOLT(oltrowid)),"^",1)
 	...quit:(ExID'="")&&(ExID'=ARCIMID)
 	...s result=..CheckARCItem(ARCIMID)
 	...quit:result'=0
 	...
 	...//写入收费项目   DHC_EQCServDetItem
 	...s ServDetItemID=..InsertSerDetItem(ChangeType,ExType,TARIID,ARCIMID)
 	...quit:ServDetItemID<=0
 	...
 	...//写入服务项     DHC_EQCServiceItem
 	...s ServiceItemID=..InsertServiceItem(ChangeType,ExType,ARCIMID)
 	...quit:ServiceItemID=""
 	...
 	...//写入设备对应的服务项  DHC_EQEquipService
 	...if ExType="DHC-HIS"  d
 	....s result=..InsertEquipServiceItem(ChangeType,ExType,SourceType,SourceID,ServiceItemID)
 	...quit:result'=0
 	...
 	...//取服务项对收费项的数量
 	...s Qty=0
	...s vDate=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARIID,""))
	...i vDate'="" d
	....s OLTRowID=$o(^DHCOLT(0,"ARTTA",ARCIMID,TARIID,vDate,""))
	....i OLTRowID'="" s Qty=$p($g(^DHCOLT(OLTRowID)),"^",3)
	...
 	...//写入服务项和收费项的对照关系   DHC_EQCServiceDetails
 	...s flag=..InsertEquipServDetItem(ChangeType,ExType,ServiceItemID,ServDetItemID,Qty)
 	...quit:flag'=0
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 创建：zy 2011-03-03  ZY0063
/// 描述：根据已经做好的His设备服务项,导入服务项对应的收费项以及每个收费项对用的消耗明细.
/// 输入：ChangeType：操作类别
/// 	RowStr：EquipNo^收费项目ID^消耗材料Code
///  w ##class(web.DHCEQImportData2CSP).ConsumableItemByCode("Append","DHC-HIS^w0223000032^肝动脉造影^CG0000343^耦合剂(威高)")
ClassMethod ConsumableItemByCode(ChangeType As %String = "", RowStr As %String = "")
{
	s RetStr=""
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCConsumableItem")
	.k ^DHCEQCCode("DHCEQCServiceConsumable")
	
	IF ChangeType="Clear"  quit "数据已清:设备对照(DHC_EQDeviceMap)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s ExType=$p(RowStr,del,1),TARICode=$p(RowStr,del,2),TARIDesc=$p(RowStr,del,3)
 	s INCICode=$p(RowStr,del,4),INCIDesc=$p(RowStr,del,5)
 	
 	s ExType=##Class(web.DHCEQCommon).Trim(ExType)
 	s TARICode=##Class(web.DHCEQCommon).Trim(TARICode)
 	s TARIDesc=##Class(web.DHCEQCommon).Trim(TARIDesc)
 	s INCICode=##Class(web.DHCEQCommon).Trim(INCICode)
 	s INCIDesc=##Class(web.DHCEQCommon).Trim(INCIDesc)

 	i ExType="" s RetStr=..RetErrorValue(RetStr,"收费项类型不能为空")
 	i TARICode="" s RetStr=..RetErrorValue(RetStr,"收费项Code不能为空")
 	//i TARIDesc="" s RetStr=..RetErrorValue(RetStr,"收费项Desc不能为空")
 	i INCICode="" s RetStr=..RetErrorValue(RetStr,"消耗材料ID不能为空")
 	
 	if RetStr'="" q RetStr
 	
 	i ExType="DHC-HIS" set Type=1,QuantityType=1
 	i ExType="DHC-LIS" set Type=2,QuantityType=2
 	i ExType="DHC-RIS" set Type=3,QuantityType=1
	//取收费项目ID
	//^DHCOLT(0,"TAR",{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})
	s TARIID=""
	s TARICode=$ZCONVERT(TARICode,"U")
 	if $Data(^DHCTARI(0,"Code",TARICode))'=0 d
 	.s TARIID=$o(^DHCTARI(0,"Code",TARICode,0))
	i TARIID="" s RetStr=..RetErrorValue(RetStr,"收费项……"_TARICode)
	i RetStr'="" q RetStr
	
 	s ServiceDetID=""
 	if $D(^DHCEQCCode("DHCEQCServDetItem","0",Type,TARIID))'=0 d
 	.s ServiceDetID=$Order(^DHCEQCCode("DHCEQCServDetItem","0",Type,TARIID,0))
 	if ServiceDetID="" q "收费项  不存在"_TARICode
	
	//写入消耗材料
	s ConsumableItemID=..InsertConsumableItem(ChangeType,ExType,INCICode)
	if ConsumableItemID'>0 q "消耗材料不存在"_INCICode
 	
 	s ServiceItemID=""
 	if $D(^DHCEQCCode("DHCEQCServiceDetails",0,"ServiceItem",ServiceDetID)) d
 	.s ServiceItemID=0
 	.f  s ServiceItemID=$Order(^DHCEQCCode("DHCEQCServiceDetails",0,"ServDetItem",ServiceDetID,ServiceItemID)) quit:((ServiceItemID="")||(RetStr'=""))  d
 	..s sdrowid=0
 	..f  s sdrowid=$Order(^DHCEQCCode("DHCEQCServiceDetails",0,"ServDetItem",ServiceDetID,ServiceItemID,sdrowid)) quit:((sdrowid="")||(RetStr'=""))  d
 	...//^DHCEQEquipService(0,"ServiceSource",439,1
 	...s EquipID=0
 	...f  s EquipID=$Order(^DHCEQEquipService(0,"ServiceSource",ServiceItemID,1,EquipID)) quit:((EquipID="")||(RetStr'=""))  d
 	....
 	....///服务项对应消耗项目
 	....s PSICLIST(2)="1"					;SourceType
 	....s PSICLIST(3)=EquipID				;SourceID
 	....s PSICLIST(4)=ServiceItemID			;ServiceItemDR
 	....s PSICLIST(5)=ConsumableItemID		;ConsumableItemDR
 	....s PSICLIST(6)=$p($g(^DHCEQCCode("DHCEQCServDetItem",ServiceDetID)),"^",3)				;UomDR
 	....s PSICLIST(7)="1"					;Quantity
 	....s PSICLIST(8)=$p($g(^DHCEQEquip(EquipID)),"^",3)	;ModelDR
 	....s PSICLIST(9)=QuantityType			;QuantityType  
 	....s PSICLIST(10)=ServiceDetID			;ServDetItemDR
 	....s (tmpid)=""
 	....&SQL(Select SIC_RowID into :tmpid  from sqluser.DHC_EQCServiceConsumable where SIC_SourceType='1' and SIC_SourceID=:EquipID and SIC_ServiceItemDR=:ServiceItemID and SIC_ConsumableItemDR=:ConsumableItemID and SIC_ServDetItemDR=:ServiceDetID)
 	....
 	....i tmpid'=""  d
 	.....;s RetStr=..RetErrorValue(RetStr,"服务项消耗项对照中有重复……"_CIRowID)
 	....e  d
 	.....i (ChangeType="Append") d
 	......&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :PSICLIST())
 	......s CIRowID=$G(%ROWID)
 	......i SQLCODE s RetStr=..RetErrorValue(RetStr,"服务项消耗项对照插入记录失败……"_ConsumableItemID)
 
 	if RetStr'="" q RetStr
 	q:RetStr="" "OK"
}

/// w ##class(web.DHCEQImportData2CSP).CheckARCItem("13453||1")
ClassMethod CheckARCItem(ARCIMID)
{
 	s (subscript,version,ARCIC,ARCIMItemCatDR,ARCIMorderOnItsOwn)=""
 	s subscript=$p(ARCIMID,"||",1)
 	s version=$p(ARCIMID,"||",2)
 	//s ARCIMItemCatDR=$p($g(^ARCIM(subscript,version,1)),"^",10)  //ItemCatDR
 	//if ARCIMItemCatDR'="" s ARCIC=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)  ;OrderType
 	//if ARCIC'="N" quit 0
 	s ARCIMorderOnItsOwn=$p($g(^ARCIM(subscript,version,7)),"^",13)
 	if ARCIMorderOnItsOwn'="Y"  quit 1
 	quit 0
}

/// w ##class(web.DHCEQImportData2CSP).InsertSerDetItem("2880","3159||1")
ClassMethod InsertSerDetItem(ChangeType, ExType, TARIID, ARCIMID)
{
	///收费项目明细
	//^DHCOLT(0,"TAR",{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})
	k PLIST
	s RetStr=""
	s ServDetItemID=""
	
 	s TARCode=$p($g(^DHCTARI(TARIID)),"^",1)  ;Code
 	s TARDesc=$p($g(^DHCTARI(TARIID)),"^",2)  ;Desc
 	s TARUOM=$p($g(^DHCTARI(TARIID)),"^",3)	 ;UOM
 	s TARPrice=$p($g(^DHCTARI(TARIID)),"^",8)  ;Price
 	if ExType="DHC-HIS" set Type=1
 	if ExType="DHC-LIS" set Type=2
 	
 	s PLIST(2)=TARDesc		;Desc
 	s PLIST(3)=TARCode		;Code
 	s PLIST(4)=TARUOM		;UnitDR
 	s PLIST(5)=TARPrice		;Price
 	s PLIST(6)=Type			;ExType	
 	s PLIST(7)=TARIID		;ExID
 	s PLIST(8)=""			;Remark		
 	s PLIST(9)="Y"			;ImportFlag
 	s PLIST(10)=""			;MinMinutes	
 	s PLIST(11)=""			;MinutesPerTime
 	s PLIST(12)=""			;MaxMinutes
 	s PLIST(13)="N"			;InvalidFlag
 	s PLIST(14)=+$h			;UpdateDate
 	s PLIST(15)=TARDesc		;ExDesc
 	
 	s (tmpid)=""
	&SQL(Select SDI_RowID into :tmpid  from sqluser.DHC_EQCServDetItem where SDI_ExType=:Type and SDI_ExID=:TARIID and SDI_InvalidFlag='N')
	i tmpid'=""  d
	.s ServDetItemID=tmpid
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServDetItem Values :PLIST())
	..s ServDetItemID=$G(%ROWID)
	..i SQLCODE s RetStr="-1"			//..RetErrorValue(RetStr,"服务细项插入记录失败……"_TARItemID)
	
	if RetStr'="" q RetStr
	q ServDetItemID
}

ClassMethod InsertServiceItem(ChangeType, ExType, ARCIMID)
{
 	
 	k PLIST
 	s RetStr=""
 	s (subscript,version,ServiceItemID)=""
 	s subscript=$p(ARCIMID,"||",1)
 	s version=$p(ARCIMID,"||",2)
 	S SICode=$p($g(^ARCIM(subscript,version,1)),"^",1)
 	S SIDesc=$p($g(^ARCIM(subscript,version,1)),"^",2)
 	s UnitDR=$p($g(^ARCIM(subscript,version,1)),"^",4)
 	
 	&SQL(Select SI_RowID into :tmpid  from sqluser.DHC_EQCServiceItem where SI_Desc=:SIDesc and SI_ExID=:ARCIMID and SI_ExType=:ExType)
 	i tmpid'=""  d
 	.s ServiceItemID=tmpid
 	e  d
 	.s PLIST(2)=SIDesc
 	.s PLIST(3)=SICode
 	.s PLIST(4)=UnitDR
 	.s PLIST(5)=##class(web.DHCEQIUsedRecord).GetServicePriceByExID(ExType,ARCIMID,+$h)
 	.s PLIST(6)=ExType
 	.s PLIST(7)=ARCIMID
 	.s PLIST(8)=""
 	.s PLIST(9)="N"
 	.s PLIST(10)=""
 	.s PLIST(11)=""
 	.s PLIST(12)=""
 	.s PLIST(13)="N"
 	.s PLIST(14)=""
 	.s PLIST(15)=SIDesc
 	.i (ChangeType="Append") d
 	..&SQL(Insert Into SQLUSER.DHC_EQCServiceItem Values :PLIST())
 	..s ServiceItemID=$G(%ROWID)
 	..i SQLCODE s RetStr="-1"		//..RetErrorValue(RetStr,"服务项插入记录失败……"_SIDesc)
 	
 	i RetStr'="" q RetStr
 	
 	q ServiceItemID
}

/// w ##class(web.DHCEQImportData2CSP).InsertEquipServiceItem("Append","","1","16828","443")
ClassMethod InsertEquipServiceItem(ChangeType, ExType, SourceType, SourceID, ServiceItemID)
{
	s RetStr=0
	k PESList
	s ModelDR=""
	i SourceType=1 d
	.s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	s PESList(2)=SourceType					//SourceType
	s PESList(3)=SourceID 					//SourceID
	s PESList(4)=ModelDR					//ModelDR
	s PESList(5)=ServiceItemID				//ServiceDR
	s PESList(6)="" 						//MinMinutes
	s PESList(7)=""							//MinutesPerTimes
	s PESList(8)="" 						//MaxMinutes
	s PESList(9)="" 						//Remark
	s PESList(10)="N"
	s (tmpid)=""
	&SQL(Select ES_RowID into :tmpid  from sqluser.DHC_EQEquipService where ES_SourceType=:SourceType and ES_SourceID=:SourceID  and ES_ServiceDR=:ServiceItemID and ES_InvalidFlag='N')
	i tmpid'=""  d
	.;s RetStr=..RetErrorValue(RetStr,"设备服务项对照中有重复……"_SIDesc)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQEquipService Values :PESList())
	..i SQLCODE s RetStr="-1"			//..RetErrorValue(RetStr,"设备服务对照插入记录失败……"_SIDesc)
	
	q RetStr
}

ClassMethod InsertEquipServDetItem(ChangeType, ExType, ServiceItemID, ServDetItemID, Qty)
{
	s RetStr=0
	k PSIList
	s PSIList(2)=ServiceItemID				;ServiceItemDR
	s PSIList(3)=ServDetItemID				;ServDetItemDR
	s PSIList(4)=Qty						;Quantity
	s PSIList(5)=""		 					;Remark
	s PSIList(6)="N" 						;InvalidFlag
	
	s (tmpid)=""
	&SQL(Select SD_RowID into :tmpid  from sqluser.DHC_EQCServiceDetails where SD_ServiceItemDR=:ServiceItemID and SD_ServDetItemDR=:ServDetItemID and SD_InvalidFlag='N')
	i tmpid'=""  d
	.;s RetStr=..RetErrorValue(RetStr,"服务项与细项对照有重复……"_ServDetItemID)
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCServiceDetails Values :PSIList())
	..i SQLCODE s RetStr="-1"			//..RetErrorValue(RetStr,"服务项与细项对照插入记录失败……"_ServDetItemID)
	q RetStr
}

/// w ##class(web.DHCEQImportData2CSP).InsertConsumableItem("Append","DHC-HIS","W050401127")
ClassMethod InsertConsumableItem(ChangeType, ExType, INCICode)
{
	///消耗项目明细
	//INCIID   ^INCI(0,"Code",$$ALPHAUP({INCI_Code}),{INCI_RowId})
	s RetStr=""
	s INCIID=""
	s INCICode=$ZCONVERT(INCICode,"U")
 	if $Data(^INCI(0,"Code",INCICode))'=0 d
 	.s INCIID=$o(^INCI(0,"Code",INCICode,0))
	i INCIID="" s RetStr="-1"		//..RetErrorValue(RetStr,"材料不存在……"_INCICode)
	i RetStr'="" q RetStr
	
	s INCICode=$p($g(^INCI(INCIID,1)),"^",1)  ;Code
	s INCIDesc=$p($g(^INCI(INCIID,1)),"^",2)  ;Desc
	s INCIPrice=$p($g(^INCI(INCIID,1)),"^",5)  ;Price
	s INCIUomDR=$p($g(^INCI(INCIID,1)),"^",10)  ;UomDR
	
	i ExType="DHC-LIS" s ExType="DHC-ST"
	
	s PCILIST(2)=INCIDesc			;Desc
	s PCILIST(3)=INCICode			;Code
	s PCILIST(4)=INCIPrice			;Price
	s PCILIST(5)=INCIUomDR			;UomDR
	s PCILIST(6)=ExType				;ExType 
	s PCILIST(7)=INCIID				;ExID
	s PCILIST(8)=""					;InvalidFlag
	s PCILIST(9)=INCIDesc			;ExDesc 
	
	s (tmpid,ConsumableItemID)=""
	&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_ExType=:ExType and CI_ExID=:INCIID)
	i tmpid'=""  d
	.;s RetStr=..RetErrorValue(RetStr,"服务项消耗项对照中有重复……"_CIRowID)
	.s ConsumableItemID=tmpid
	e  d
	.i (ChangeType="Append") d
	..&SQL(Insert Into SQLUSER.DHC_EQCConsumableItem Values :PCILIST())
	..s ConsumableItemID=$G(%ROWID)
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"消耗项插入记录失败……"_INCIID)
 	if RetStr'="" q RetStr
	q ConsumableItemID
}

/// 调整更新及补充设备项分类等信息
ClassMethod UpdateMasterItem(ChangeType As %String = "", RowStr As %String = "")
{
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s MIRowID=$p(RowStr,del,1)
 	s MIName=$p(RowStr,del,2)
 	s MIOldET=$p(RowStr,del,3)
 	s MIOldSC=$p(RowStr,del,4)
 	s MIOldEC=$p(RowStr,del,5)
 	s MIEquipType=$p(RowStr,del,6)
 	s MIStatCat=$p(RowStr,del,7)
 	s MIEquipCat=$p(RowStr,del,8)
 	
	k PLIST
	
	i MIEquipType'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipTypeID(MIEquipType)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类组: 设备="_MIName_" 设备类组="_MIEquipType)
	.e  d
	..s PLIST(4)=tmpid
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备类组: 设备="_MIName)
 	
 	i MIEquipCat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,MIEquipCat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_MIName_" 设备分类="_MIEquipCat)
	.e  d
	..s PLIST(5)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_MIName)
	
	i MIStatCat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetStatCatID(MIStatCat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_MIName_" 设备类型="_MIStatCat)
	.e  d
	..s PLIST(6)=tmpid
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类型: 设备="_MIName)
	
    if ChangeType'="Test"  d
    .s OldETDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",MIRowID)),"^",3)
    .s OldECDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",MIRowID)),"^",4)
    .s OldSCDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",MIRowID)),"^",5)
    .i (OldETDR'=PLIST(4))||(OldECDR'=PLIST(5))||(OldSCDR'=PLIST(6))  d
    ..s ^DHCEQUpdate("MasterItem",MIRowID)=OldETDR_"^"_OldSCDR_"^"_OldECDR_"^"_PLIST(4)_"^"_PLIST(6)_"^"_PLIST(5)
	..&SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID=:MIRowID)
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"更新失败: MIName="_MIName_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// Add by JDL 2011-12-19 JDL0106
/// 存放地点
ClassMethod Location(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCLocation")
	q:ChangeType="Clear" "数据已清:存放地点(DHC_EQCLocation)"
	s del="^",RetStr=""
	//SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1)
 	s code=##class(web.DHCEQCommon).Trim(code)
 	s desc=$p(RowStr,del,2)
 	s desc=##class(web.DHCEQCommon).Trim(desc)
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCLocation:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCLocation:")
 	if RetStr'="" q RetStr
 	
 	s desc=$ZCONVERT(desc,"U")	
	s tmpid=""
	&SQL(Select L_rowid into :tmpid from SQLUSER.DHC_EQCLocation where L_desc=:desc)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCLocation(L_code,L_desc,L_invalidflag) values (:code,:desc,'N'))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCLocation:"_desc)
 	 	
 	q:RetStr="" "OK"
	q RetStr
}

/// Add by JDL 2011-12-19 JDL0106   
/// Modify by mwz 2021-04-10
/// 设备资金来源明细
/// w ##class(web.DHCEQImportData2CSP).EquipFunds()
ClassMethod EquipFunds(ChangeType As %String = "", RowStr As %String = "")
{
	;n equipid,fundsstr,curfunds,fundstype,fundsamount,fundsid
	;n Amount,fundscount,originalfee,equipname
	;n errDesc
	
	s errDesc=""
	s Amount=0,DepreAmount=0
	s del="^"
	; ID_"^"_equipname_"^"_originalfee_"^"_fundsstr_"^"_depretotalfee_"^"_finaceitemstr
	s equipid=$p(RowStr,del,1)
	s equipname=$p(RowStr,del,2)
	s originalfee=+$p(RowStr,del,3)
	s fundsstr=$p(RowStr,del,4)
	s depretotalfee=$p(RowStr,del,5)
	s finaceitemstr=$p(RowStr,del,6)  //modify by mwz 20220606 MWZ0061
 	i fundsstr'=""  d //检测资金来源是否存在以及总金额时候等于原值
 	.s Amount=0
	.s fundscount=$l(fundsstr,",")
	.f i=1:1:fundscount  d
	..s curfunds=$p(fundsstr,",",i)
	..s fundstype=$p(curfunds,"=",1)
	..s fundsamount=+$p($p(curfunds,"=",2),":",1)
	..s fundsdepre=+$p(curfunds,":",2)  
	..i (fundsamount=0)&&(fundscount=1) s fundsamount=originalfee
	..q:fundsamount=0
	..s Amount=Amount+fundsamount
	..s DepreAmount=DepreAmount+fundsdepre
	..//ADD by mwz 20220606 MWZ0061 BEGIN
	..s finaceitemcount=$l(finaceitemstr,",")
	..s fitemid=""
	..f j=1:1:finaceitemcount  d
	...s finaceitems=$p(finaceitemstr,",",j)
	...s ffundstype=$p(finaceitems,":",1)  
	...s finaceitemcode=$p(finaceitems,":",2)
	...q:(ffundstype'=fundstype)  //检测当前资金来源下的核算项目
	...&SQL(Select FI_RowID into :fitemid from SQLUSER.DHC_EQCFinaceItem where FI_code=:finaceitemcode)
	...if fitemid="" Set errDesc=..RetErrorValue(errDesc,finaceitemcode_"核算项目不存在")  //通过code检测核算项目
	..//ADD by mwz 20220606 MWZ0061 END
	..i fundstype'=""  d
	...s fundsid=##Class(web.DHCEQImportDataTool).GetFundsType(fundstype)
	...i fundsid=""  d
	....s errDesc=..RetErrorValue(errDesc,"没有找到该资金来源: 设备="_equipname_" 资金来源="_fundstype)
	..e  d
	...s errDesc=..RetErrorValue(errDesc,"资金来源不能为空: 设备="_equipname)
	..if ChangeType'="Test" d
	...k FTLIST
	...s FTLIST(2)=equipid
	...s FTLIST(3)=fundsid
	...s FTLIST(4)=fundsamount
	...s FTLIST(7)="0"
	...s FTLIST(9)=+$H
	...s FTLIST(10)=$p($H,",",2)
	...s FTLIST(11)="N"
	...s FTLIST(14)=fundsdepre
	...s FTLIST(15)="1"		//2013-01-01 DJ DJ0110
	...s FTLIST(16)=equipid		//2013-01-01 DJ DJ0110
	...s FTLIST(21)=fitemid   	//Modify by mwz 20220606 MWZ0061  核算项目编码
	...&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FTLIST())
	...i SQLCODE  d
	....s errDesc=..RetErrorValue(errDesc,"插入设备资金来源信息失败: 设备="_equipid_" SQLCODE="_SQLCODE)
	.i (+Amount)'=(+originalfee)  d
	..s errDesc=..RetErrorValue(errDesc,"设备资金来源总金额不等于原值: 设备="_equipid_" 资金来源总额="_Amount)
	.i (+DepreAmount'=0)&&((+DepreAmount)'=(+depretotalfee))  d          // Modify by mwz 2021-06-10 MWZ0049
	..s errDesc=..RetErrorValue(errDesc,"设备资金来源总折旧金额不等于折旧金额: 设备="_equipid_" 资金来源总折旧金额="_DepreAmount)
	q:errDesc="" "OK"
	q errDesc
}

/// Add By HZY 2013-4-15
/// Desc:房屋单元 DHC_EQBuildingUnit 
ClassMethod BuildingUnit(ChangeType As %String = "", RowStr As %String = "")
{
	if (ChangeType="Clear")
	{
		k ^DHCEQBuildingUnit
		q "数据已清:房屋单元(DHC_EQBuildingUnit)"
	}
	s bdEquipTypeRowIDs=##class(web.DHCEQCommon).GetSysInfo("401003")		//房屋建筑的类组RowIDs
	///建筑名称^Code^楼层^科室^使用面积^建筑面积^长*宽
	s del="^",RetStr="",eqrowid="",bdrowid="",locrowid=""
	s RowStr=$tr(RowStr," ","")
 	s buildingName=$p(RowStr,del,1)	//建筑名称
 	s buildingCode=$p(RowStr,del,2)	//建筑名称Code
 	if (buildingName="") s RetStr=..RetErrorValue(RetStr,"建筑名称不能为空!")
 	s buildingFloor=$p(RowStr,del,3)	//楼层
 	//if buildingFloor="" s RetStr=..RetErrorValue(RetStr,"楼层不能为空!")
 	s loc=$p(RowStr,del,4)	//科室
 	if (loc="")	s RetStr=..RetErrorValue(RetStr,"科室不能为空!")
	s useArea=$p(RowStr,del,5)		//使用面积
 	//if useArea="" s RetStr=..RetErrorValue(RetStr,"使用面积不能为空!")
 	s buildingArea=$p(RowStr,del,6)	//建筑面积
 	if buildingArea="" s RetStr=..RetErrorValue(RetStr,"建筑面积不能为空!")
 	s lengthWidth=$p(RowStr,del,7)	//长*宽
 	s originalFee=$p(RowStr,del,8)	//原值
 	i RetStr'="" q RetStr

 	//&SQL(select EQ_RowID into :eqrowid from SQLUSER.DHC_EQEquip where EQ_Name=:buildingName and EQ_EquipTypeDR=:)
 	s tmpEqRowID=0 , findFlag=0	//找出名称相同,且类组属于房屋建筑的那条记录
 	f  s tmpEqRowID=$o(^DHCEQEquip(0,"Code",buildingCode,tmpEqRowID)) q:(tmpEqRowID="")||(findFlag=1)  d
 	.q:(buildingName'=$p($g(^DHCEQEquip(tmpEqRowID)),"^",1))
 	.s tmpEquipType=$p($g(^DHCEQEquip(tmpEqRowID)),"^",63)
 	.q:((","_bdEquipTypeRowIDs_",")'[(","_tmpEquipType_","))
 	.s eqrowid=tmpEqRowID , findFlag=1
 	
 	if (eqrowid'="")
	{
		&SQL(select BD_RowID into :bdrowid from SQLUSER.DHC_EQBuilding where BD_EquipDR=:eqrowid)
	}
	else{
		s RetStr=..RetErrorValue(RetStr,"建筑名称在DHC_EQEquip中未找到!")
	}	
	&SQL(select CTLOC_RowID into :locrowid from SQLUSER.CT_Loc where CTLOC_Desc=:loc)
	if (locrowid="")
	{
		s RetStr=..RetErrorValue(RetStr,"科室未找到!")
	}
	i RetStr'="" q RetStr
 	
 	s BURowID=""
 	&SQL(select BU_RowID into :BURowID from SQLUSER.DHC_EQBuildingUnit where BU_BuildingDR=:bdrowid and BU_Floor=:buildingFloor and BU_UseLocDR=:locrowid)
 	if BURowID'="" s RetStr=..RetErrorValue(RetStr,"建筑名称="_buildingName_",楼层="_buildingFloor_",科室="_loc_" , 已经存在!")
	
	i RetStr'="" q RetStr
	
	k PLIST
    s PLIST(2)=bdrowid			//BU_BuildingDR
    s PLIST(4)=buildingFloor	//BU_Floor
    s PLIST(7)=useArea			//BU_BuildingArea
    s PLIST(8)=buildingArea		//BU_UtilizationArea
    s PLIST(10)=locrowid		//BU_UseLocDR
    s PLIST(15)=originalFee		//BU_OriginalFee
    s PLIST(29)=lengthWidth		//BU_Hold1
    
    if ChangeType'="Test"  d
    .i BURowID=""  d
    ..&SQL(Insert Into SQLUSER.DHC_EQBuildingUnit Values :PLIST())
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: 建筑名称="_buildingName_",楼层="_buildingFloor_",科室="_loc_",SQLCODE="_SQLCODE)
	
	q:RetStr="" "OK"
	q RetStr
}

/// Created By HZY 2013-4-16
/// 在导入房屋的科室使用明细后,根据科室占的面积比设置科室的分摊明细信息
/// w ##class(web.DHCEQImportData2CSP).SetBuildingCostAllotInfo()
/// 提示:将类DHCEQCostAllot中的函数SaveData()中的##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))改为数字.
ClassMethod SetBuildingCostAllotInfo()
{
	s result=0
	s rowid=0
	f  s rowid=$o(^DHCEQBuilding(rowid)) q:(rowid="")||(result<0)  d
	.s result=##class(web.DHCEQBuildingUnit).BuildingUnitDepreAllot(rowid)
	
	i (result=0)
	{
		q "No Data !"
	}
	elseif (result>0)
	{
		q "Success!"
	}else{
		q "Failed! "_result
	}
}

/// 2014-7-24 HZY0057
/// 盘点结果的导入.
ClassMethod InventoryResult(ChangeType, RowStr)
{
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s InventoryNo= $p(RowStr,del,1)
 	s EquipNo=$p(RowStr,del,2)
 	s EquipName=$p(RowStr,del,3) 
 	s StoreLoc=$p(RowStr,del,4) 
 	s UseLoc=$p(RowStr,del,5)  
 	s ReasonType="" 
 	if InventoryNo="" s RetStr=..RetErrorValue(RetStr,"盘点单号不能为空:"_RowStr)
 	if EquipNo="" s RetStr=..RetErrorValue(RetStr,"设备编号不能为空:"_RowStr)
 	if EquipName="" s RetStr=..RetErrorValue(RetStr,"设备名称不能为空:"_RowStr)
 	if StoreLoc="" s RetStr=..RetErrorValue(RetStr,"存放部门不能为空:"_RowStr)
 	if UseLoc="" s RetStr=..RetErrorValue(RetStr,"使用部门不能为空:"_RowStr)
 	if RetStr'="" q RetStr
 	
 	s InventoryDR= $o(^DHCEQInventory(0,"InventoryNo",InventoryNo,0))
 	s EquipID=$o(^DHCEQEquip(0,"No",EquipNo,0))
 	s StoreLocDR=##Class(web.DHCEQImportDataTool).GetUseLocID(StoreLoc) 
 	s UseLocDR=##Class(web.DHCEQImportDataTool).GetUseLocID(UseLoc)  
 	if InventoryDR="" s RetStr=..RetErrorValue(RetStr,"盘点单号不存在:"_RowStr)
 	if EquipID="" s RetStr=..RetErrorValue(RetStr,"设备不存在:"_RowStr)
 	if StoreLocDR="" s RetStr=..RetErrorValue(RetStr,"存放部门不存在:"_RowStr)
 	if UseLocDR="" s RetStr=..RetErrorValue(RetStr,"使用部门不存在:"_RowStr)
 	if RetStr'="" q RetStr
 	
 	s User=""  //93
 	s InventoryDate=""
 	s InventoryTime=""
 	
 	if ChangeType'="Test"  
 	{
	 	s Ret=##Class(web.DHCEQInventory).UpLoadInventoryResult(InventoryDR, StoreLocDR, UseLocDR, EquipID, EquipNo, EquipName, ReasonType, User, InventoryDate, InventoryTime)
		i Ret=0
		{
			q "OK"
		}else{
			q Ret
		}
 	}
 	
 	q:RetStr="" "OK"
	q RetStr
}

/// 经费来源导入
ClassMethod Expenditures(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" Kill ^DHCEQCCode("DHCEQCExpenditures")
	Quit:ChangeType="Clear" "数据已清:经费来源(DHC_EQCExpenditures)"
	
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set code=$Piece(RowStr,del,1),desc=$Piece(RowStr,del,2)
 	if code="" Set RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCOrigin:")
 	if desc="" Set RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCOrigin:")
 	if RetStr'="" Quit RetStr
 	
 	Set desc=$ZCONVERT(desc,"U")	
	Set tmpid=""
	&SQL(Select e_rowid into :tmpid from SQLUSER.DHC_EQCExpenditures where e_desc=:desc)
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Insert into SQLUSER.DHC_EQCExpenditures(e_code,e_desc,e_invalidflag) values (:code,:desc,'N'))
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCExpenditures:"_desc)
 	 	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Add By DJ 2015-08-21 DJ0157
ClassMethod Brand(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" Kill ^DHCEQCCode("DHCEQCBrand")
	Quit:ChangeType="Clear" "数据已清:品牌(DHC_EQCBrand)"
	
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set code=$Piece(RowStr,del,1),desc=$Piece(RowStr,del,2)
 	if code="" Set RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCBrand:")
 	if desc="" Set RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCBrand:")
 	if RetStr'="" Quit RetStr
 	
 	Set desc=$ZCONVERT(desc,"U")	
	Set tmpid=""
	&SQL(Select b_rowid into :tmpid from SQLUSER.DHC_EQCBrand where b_desc=:desc)
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Insert into SQLUSER.DHC_EQCBrand(b_code,b_desc,b_invalidflag) values (:code,:desc,'N'))
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCBrand:"_desc)
 	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Add By DJ 2015-09-09 DJ0162
ClassMethod GroupMenu(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set vGroupName=$Piece(RowStr,del,1),vMenuName=$Piece(RowStr,del,2)
 	Set MenuCaption=$Piece(RowStr,del,3),Flag=$Piece(RowStr,del,4)
 	
 	if vGroupName="" Set RetStr=..RetErrorValue(RetStr,"安全组不能为空:")
 	if vMenuName="" Set RetStr=..RetErrorValue(RetStr,"菜单名不能为空:")
 	if Flag="" Set RetStr=..RetErrorValue(RetStr,"分配或取消标志不能为空:")
 	
 	if RetStr'="" Quit RetStr
 	s vGroupID=..GetGroupIDByDesc(vGroupName)
	//&SQL(Select SSGRP_RowID Into :vGroupID From SQLUSER.SS_Group Where SSGRP_Desc=:vGroupName)
	i vGroupID="" s RetStr=..RetErrorValue(RetStr,"安全组不存在: 安全组="_vGroupName)
	s vMenuID=""
	&SQL(Select ID Into :vMenuID From websys.Menu Where Name=:vMenuName)
	i vMenuID="" s RetStr=..RetErrorValue(RetStr,"菜单不存在: 菜单="_vMenuName)
	
	d ##Class(web.DHCEQComponent).SetGroupMenu(vGroupID,vMenuID,Flag,"0")
	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

ClassMethod GetGroupIDByDesc(vDesc)
{
	s vGroupID=""
	s tmpGroupID=0
	f  s tmpGroupID=$o(^SSU("SSGRP",tmpGroupID))  q:tmpGroupID=""  d
	.q:$p(^SSU("SSGRP",tmpGroupID),"^",1)'=vDesc
	.s vGroupID=tmpGroupID	
	q vGroupID
}

/// Add By DJ 2015-07-17
/// 描述:ETL工具导入设备台帐测试
ClassMethod ContractStrTest(vStr As %String(MAXLEN=10000)) As %String [ SqlProc ]
{
	//测试数据
	s ReturnStr=##Class(web.DHCEQImportData2CSP).Equip("Test",vStr)	
	q ReturnStr
}

/// Add By DJ 2015-07-17
/// 描述:ETL工具导入设备台帐追加记录
ClassMethod ContractStrAppend(vStr As %String(MAXLEN=10000)) As %String [ SqlProc ]
{
	//追加数据
	s ReturnStr=##Class(web.DHCEQImportData2CSP).Equip("Append",vStr)	
	q ReturnStr
}

/// Add By DJ 2015-07-17
/// 描述:ETL工具导入设备台帐新装数据
ClassMethod ContractStrInit(vStr As %String(MAXLEN=10000)) As %String [ SqlProc ]
{
	//新装数据
	s ReturnStr=##Class(web.DHCEQImportData2CSP).Equip("Clear",vStr)	
	q ReturnStr
}

ClassMethod UpdateLeaveFactoryNo(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set fileno=$Piece(RowStr,del,1),no=$Piece(RowStr,del,2)
 	
 	/*Set tmpid=""
	&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where EQ_FileNo=:fileno)
	If tmpid'=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_LeaveFactoryNo=:no Where eq_rowid=:tmpid )
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败: fileno="_fileno_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称不存在DHC_EQEquip:"_fileno)
	*/
	Set tmpid=""
	&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where EQ_FileNo=:fileno)
	If tmpid'=""  Do
	.if ChangeType'="Test" Do
	..;&SQL(Update SQLUSER.DHC_EQEquip Set EQ_PurposeTypeDR=:no Where eq_rowid=:tmpid )
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败: fileno="_fileno_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称不存在DHC_EQEquip:"_fileno)
	
	Quit:RetStr="" "OK"
	Quit RetStr
}

/// add by GBX 2016-02-22
/// 配件分类导入
ClassMethod AccessoryCat(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" Kill ^DHCEQCCode("DHCEQCAccessoryCat")
	Quit:ChangeType="Clear" "数据已清:配件项(DHC_EQCAccessoryCat)"

	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set Code=$Piece(RowStr,del,1),Desc=$Piece(RowStr,del,2)
 	Set Remark=$Piece(RowStr,del,3)
 	
 	Set tmpid=""
	&SQL(Select ac_rowid into :tmpid from SQLUSER.DHC_EQCAccessoryCat where ac_desc=:Desc)
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Insert into SQLUSER.DHC_EQCAccessoryCat(ac_code,ac_desc,ac_remark,ac_invalidflag) values (:Code,:Desc,:Remark,'N'))
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCAccessoryCat:"_desc)

	Quit:RetStr="" "OK"
	Quit RetStr
}

/// add by GBX 2016-02-22
/// 配件项导入
ClassMethod AccessoryItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" Kill ^DHCEQCCode("DHCEQCAccessory")
	Quit:ChangeType="Clear" "数据已清:配件项(DHC_EQCAccessory)"
	/*A_RowID,A_Code,A_Desc,A_ShortDesc,A_Model,A_BaseUOMDR,A_BillUOMDR,A_StdSPrice,A_MinSPrice,A_MaxSPrice
	A_CurBPrice,A_MinBPrice,A_MaxBPrice,A_FeeRulesDR,A_TypeDR,A_CatDR,A_CountryDR,A_PlaceOfProduction,A_GeneralName,
	A_CommercialName,A_Brand,A_BrandCertificate,A_RegisterNo,A_CertificateNo,A_ProductionLicence,A_ImportNo,A_ImportRegisterNo,
	A_ManuFactoryDR,A_PakageType,A_WastageRate,A_SolitudeFlag,A_BarCode,A_ExpiredFlag,A_ExpiredDays,A_WarningDays,A_SerialFlag,
	A_MinOrderQty,A_MaxOrderQty,A_ABCType,A_OverStock,A_SelfMakeFlag,A_SaleFlag,A_VirtualFlag,A_PurchaseFlag,A_FixPreDays,
	A_ExpSaleRate,A_WorthQty,A_SafeQty,A_MinQty,A_MaxQty,A_StockEnabledFlag,A_Volume,A_VolumeUOMDR,A_Weight,A_WeightUOMDR,
	A_RequireNote,A_ShowMessage,A_NeedTest
	A_AllowOrderNoStock,A_EffDate,A_EffTime,A_EffDateTo,A_EffTimeTo,A_VisibleInOrderList,A_ServMaterial,A_Version,A_ExtendCode,
	A_ReturnableFlag,A_ReturnInspectRequirement
	A_PickingRule,A_Remark,A_AddUserDR,A_AddDate,A_AddTime,A_UpdateUserDR,A_UpdateDate,A_UpdateTime,A_InvalidFlag,
	A_Hold1,A_Hold2,A_Hold3,A_Hold4,A_Hold5,A_Hold6,A_Hold7,A_Hold8,A_Hold9,A_Hold10,A_BatchFlag,A_CurProviderDR
	*/
	Set del="^",RetStr=""
	
	set Desc=$Piece(RowStr,del,2)
 	Set ShortDesc=$Piece(RowStr,del,3)
	Set Model=$Piece(RowStr,del,4)
 	Set Model=##Class(web.DHCEQCommon).Trim(Model)
 	
	SET RowStr=$tr(RowStr," ","")
 	Set Code=$Piece(RowStr,del,1)
 	Set ManuFactoryDR=$Piece(RowStr,del,5)
 	Set CountryDR=$Piece(RowStr,del,6)
 	Set BaseUOMDR=$Piece(RowStr,del,7)
 	Set CurBPrice=$Piece(RowStr,del,8)
 	Set Hold1=$Piece(RowStr,del,9)	;帐页
 	Set CatDR=$Piece(RowStr,del,10)
 	Set TypeDR=$Piece(RowStr,del,11)
 	/*
 	Set BillUOMDR=$Piece(RowStr,del,6)
 	Set StdSPrice=$Piece(RowStr,del,7)
 	Set MinSPrice=$Piece(RowStr,del,8)
 	Set MaxSPrice=$Piece(RowStr,del,9)
 	Set MinBPrice=$Piece(RowStr,del,11)
 	set MaxBPrice=$Piece(RowStr,del,12)
 	Set FeeRulesDR=$Piece(RowStr,del,13)
 	Set PlaceOfProduction=$Piece(RowStr,del,17)
 	Set GeneralName=$Piece(RowStr,del,18)
	Set CommercialName=$Piece(RowStr,del,19)
 	Set Brand=$Piece(RowStr,del,20)
 	Set BrandCertificate=$Piece(RowStr,del,21)
 	set RegisterNo=$Piece(RowStr,del,22)
 	Set CertificateNo=$Piece(RowStr,del,23)
 	Set ProductionLicence=$Piece(RowStr,del,24)
 	Set ImportNo=$Piece(RowStr,del,25)
 	Set ImportRegisterNo=$Piece(RowStr,del,26)
 	Set PakageType=$Piece(RowStr,del,28)
 	Set WastageRate=$Piece(RowStr,del,29)	
 	Set SolitudeFlag=$Piece(RowStr,del,30)
 	Set BarCode=$Piece(RowStr,del,31)
 	set ExpiredFlag=$Piece(RowStr,del,32)
 	Set ExpiredDays=$Piece(RowStr,del,33)
 	Set WarningDays=$Piece(RowStr,del,34)
 	Set SerialFlag=$Piece(RowStr,del,35)
 	Set MinOrderQty=$Piece(RowStr,del,36)
 	Set MaxOrderQty=$Piece(RowStr,del,37)
 	Set ABCType=$Piece(RowStr,del,38)
 	Set OverStock=$Piece(RowStr,del,39)
 	Set SelfMakeFlag=$Piece(RowStr,del,40)
 	Set SaleFlag=$Piece(RowStr,del,41)
 	set VirtualFlag=$Piece(RowStr,del,42)
 	Set PurchaseFlag=$Piece(RowStr,del,43)
 	Set FixPreDays=$Piece(RowStr,del,44)
 	Set ExpSaleRate=$Piece(RowStr,del,45)
 	Set WorthQty=$Piece(RowStr,del,46)
 	Set SafeQty=$Piece(RowStr,del,47)
 	Set MinQty=$Piece(RowStr,del,48)
 	Set MaxQty=$Piece(RowStr,del,49)
 	Set StockEnabledFlag=$Piece(RowStr,del,50)
 	Set Volume=$Piece(RowStr,del,51)
 	set VolumeUOMDR=$Piece(RowStr,del,52)
 	Set Weight=$Piece(RowStr,del,53)
 	Set WeightUOMDR=$Piece(RowStr,del,54)
 	Set RequireNote=$Piece(RowStr,del,55)
 	Set ShowMessage=$Piece(RowStr,del,56)
 	Set NeedTest=$Piece(RowStr,del,57)
 	Set AllowOrderNoStock=$Piece(RowStr,del,58)
 	Set EffDate=$Piece(RowStr,del,59)
 	Set EffTime=$Piece(RowStr,del,60)
 	Set EffDateTo=$Piece(RowStr,del,61)
 	set EffTimeTo=$Piece(RowStr,del,62)
 	Set VisibleInOrderList=$Piece(RowStr,del,63)
 	Set ServMaterial=$Piece(RowStr,del,64)
  	Set Version=$Piece(RowStr,del,65)
 	Set ExtendCode=$Piece(RowStr,del,66)	
 	Set ReturnableFlag=$Piece(RowStr,del,67)
 	Set ReturnInspectRequirement=$Piece(RowStr,del,68)
 	Set PickingRule=$Piece(RowStr,del,69)
 	Set Remark=$Piece(RowStr,del,70)
 	Set BatchFlag=$Piece(RowStr,del,71)
 	Set CurProviderDR=$Piece(RowStr,del,72)*/
 	
 	k PLIST
 	s tmpid=""
	s PLIST(2) = Code	;Code
 	s PLIST(3) = Desc	;Desc
 	s PLIST(4) = ShortDesc	;ShortDesc
 	s PLIST(5) = Model	;Model
 	;s PLIST(6) = BaseUOMDR	;BaseUOMDR
 	i BaseUOMDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUnitID(BaseUOMDR)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该单位: 配件="_Desc_" 设备单位="_BaseUOMDR)
	.e  d
	..s PLIST(6)=tmpid
	/*
 	;s PLIST(7) = BillUOMDR		;BillUOMDR
 	i BillUOMDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUnitID(BillUOMDR)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该单位: 配件="_Desc_" 设备单位="_BillUOMDR)
	.e  d
	..s PLIST(7)=tmpid
	*/
 	s PLIST(8) = CurBPrice		;StdSPrice
 	;s PLIST(9) = MinSPrice		;MinSPrice
 	;s PLIST(10) = MaxSPrice	;MaxSPrice
 	s PLIST(11) = CurBPrice		;CurBPrice
 	;s PLIST(12) = MinBPrice	;MinBPrice
 	;s PLIST(13) = MaxBPrice	;MaxBPrice
 	;s PLIST(14) = FeeRulesDR	;FeeRulesDR
 	;s PLIST(15) = TypeDR		;TypeDR
 	i TypeDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetTypeID(TypeDR)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到类组: 配件="_Desc_" 类组="_TypeDR)
	.e  d
	..s PLIST(15)=tmpid
	
 	;s PLIST(16) = CatDR		;CatDR
 	i CatDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetCatID(CatDR)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到类组: 配件="_Desc_" 分类="_CatDR)
	.e  d
	..s PLIST(16)=tmpid
	
 	;s PLIST(17) = CountryDR	;CountryDR
 	i CountryDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetCountryID(CountryDR)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到国别: 配件="_Desc_" 国别="_CountryDR)
	.e  d
	..s PLIST(17)=tmpid
	/*
 	s PLIST(18) = PlaceOfProduction	;PlaceOfProduction
 	s PLIST(19) = GeneralName	;GeneralName
 	s PLIST(20) = CommercialName	;CommercialName
 	s PLIST(21) = Brand	;Brand
 	s PLIST(22) = BrandCertificate	;BrandCertificate
 	s PLIST(23) = RegisterNo	;RegisterNo
 	s PLIST(24) = CertificateNo	;CertificateNo
  	s PLIST(25) = ProductionLicence	;ProductionLicence
 	s PLIST(26) = ImportNo	;ImportNo
 	s PLIST(27) = ImportRegisterNo	;ImportRegisterNo	
 	*/
 	;s PLIST(28) = ManuFactoryDR	;ManuFactoryDR
	i ManuFactoryDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetManuFactoryID(ManuFactoryDR)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到生产厂商: 配件="_Desc_" 生产厂商="_ManuFactoryDR)
	.e  d
	..s PLIST(28)=tmpid
	/*
 	s PLIST(29) = PakageType	;PakageType
 	s PLIST(30) = WastageRate	;WastageRate
 	s PLIST(31) = SolitudeFlag	;SolitudeFlag
 	s PLIST(32) = BarCode		;BarCode
 	s PLIST(33) = ExpiredFlag	;ExpiredFlag
 	s PLIST(34) = ExpiredDays	;ExpiredDays
 	s PLIST(35) = WarningDays	;WarningDays
 	*/
 	s PLIST(36) = "N"			;SerialFlag		导入配件按批号管理
 	/*
 	s PLIST(37) = MinOrderQty	;MinOrderQty
 	s PLIST(38) = MaxOrderQty	;MaxOrderQty
 	s PLIST(39) = ABCType		;ABCType
	s PLIST(40) = OverStock		;OverStock
 	s PLIST(41) = SelfMakeFlag	;SelfMakeFlag
 	s PLIST(42) = SaleFlag		;SaleFlag
 	s PLIST(43) = VirtualFlag	;VirtualFlag
 	s PLIST(44) = PurchaseFlag	;PurchaseFlag
  	s PLIST(45) = FixPreDays	;FixPreDays  	
 	s PLIST(46) = ExpSaleRate	;ExpSaleRate
 	s PLIST(47) = WorthQty		;WorthQty	
 	s PLIST(48) = SafeQty		;SafeQty
 	s PLIST(49) = MinQty		;MinQty
 	s PLIST(50) = MaxQty		;MaxQty
 	s PLIST(51) = StockEnabledFlag	;StockEnabledFlag
 	s PLIST(52) = Volume		;Volume
 	;s PLIST(53) = VolumeUOMDR	;VolumeUOMDR
 	s PLIST(54) = Weight		;Weight
 	;s PLIST(55) = WeightUOMDR	;WeightUOMDR	
 	s PLIST(56) = RequireNote	;RequireNote
 	s PLIST(57) = ShowMessage	;ShowMessage
 	s PLIST(58) = NeedTest		;NeedTest
 	s PLIST(59) = AllowOrderNoStock	;AllowOrderNoStock
 	s PLIST(60) = EffDate		;EffDate
 	s PLIST(61) = EffTime		;EffTime
 	s PLIST(62) = EffDateTo		;EffDateTo
 	s PLIST(63) = EffTimeTo		;EffTimeTo
 	s PLIST(64) = VisibleInOrderList	;VisibleInOrderList
  	s PLIST(65) = ServMaterial	;ServMaterial	
 	s PLIST(66) = Version		;Version
 	s PLIST(67) = ExtendCode	;ExtendCode
  	s PLIST(68) = ReturnableFlag	;ReturnableFlag
 	s PLIST(69) = ReturnInspectRequirement	;ReturnInspectRequirement
 	s PLIST(70) = PickingRule	;ReturnableFlag
 	s PLIST(71) = Remark		;ReturnInspectRequirement
 	s PLIST(78) = "N"
 	*/
 	s PLIST(79) = Hold1			;帐页
 	s PLIST(89) = "Y"			;BatchFlag	导入配件按批号管理
 	;s PLIST(90) = CurProviderDR  ;CurProviderDR
  	/*i CurProviderDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetProviderID(CurProviderDR,1)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到供应商: 配件="_Desc_" 供应商="_CurProviderDR)
	.e  d
	..s PLIST(26)=tmpid
	*/
	if RetStr'="" Quit RetStr
 	Set tmpid=""
	&SQL(Select a_rowid into :tmpid from SQLUSER.DHC_EQCAccessory where A_Desc=:Desc and a_code=:Code and a_model=:Model and A_CurBPrice=:CurBPrice and A_ManuFactoryDR=:PLIST(28) and A_Hold1=:Hold1)
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Insert Into SQLUSER.DHC_EQCAccessory Values :PLIST())
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_Code_" Desc="_Desc_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCAccessory:"_Desc)

	Quit:RetStr="" "OK"
	Quit RetStr
}

/// add by GBX 2016-02-22
/// 配件库存导入
ClassMethod Accessory(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" Kill ^DHCEQAStockDetail
	IF ChangeType="Clear" Kill ^DHCEQAStock
	Quit:ChangeType="Clear" "数据已清:配件数据(DHC_EQAStockDetail)"
	///MTRL_CODE	Name	MTRL_SPEC	厂家	UNITS	PURCHASE_PRICE	QUANTITY	LOCATION	Type	SUB_STORAGE10	BATCH_NO
	Set del="^",RetStr=""
	set Desc=$Piece(RowStr,del,2)
	Set Model=$Piece(RowStr,del,3)
 	Set Model=##Class(web.DHCEQCommon).Trim(Model)
	SET RowStr=$tr(RowStr," ","")
	
 	Set Code=$Piece(RowStr,del,1)
 	Set ManuFactory=$Piece(RowStr,del,4)
 	Set BaseUOM=$Piece(RowStr,del,5)
 	Set Bprice=$Piece(RowStr,del,6)
 	Set Stock=$Piece(RowStr,del,7)
 	Set LOCATION=$Piece(RowStr,del,8)
 	Set AccessoryType=$Piece(RowStr,del,9)
 	Set Loc=$Piece(RowStr,del,10)
 	Set BatchNo=$Piece(RowStr,del,11)
 	k PLIST, PLISTX
 	
	;;ASD_LocDR
	s tmpid=""
	i Loc'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(Loc)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室: 配件="_Desc_" 科室="_Loc)
	.e  d
	..s PLIST(2)=tmpid
	
	;;ManuFactoryDR
 	i ManuFactory'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetManuFactoryID(ManuFactory)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到生产厂商: 配件="_Desc_" 生产厂商="_ManuFactory)
	.e  d
	..s PLIST(15)=tmpid
	
 	;;ASD_ItemDR
 	Set itemid=""
 	&SQL(Select a_rowid into :itemid from SQLUSER.DHC_EQCAccessory where a_code=:Code and a_model=:Model and A_CurBPrice=:Bprice and A_ManuFactoryDR=:PLIST(15))
	i itemid=""  d
	.Set RetStr=..RetErrorValue(RetStr,"无法匹配配件项: Code="_Code_" 配件="_Desc)
	e  d
	.s PLIST(3)=itemid
	.i LOCATION'="" &SQL(Update SQLUSER.DHC_EQCAccessory set a_hold2=:LOCATION where A_RowID = :itemid)		;更新存放地点
	
 	;s PLIST(4) = 				;ASD_AInStockListDR
 	s PLIST(5) = Code			;ASD_Code
 	s PLIST(6) = Desc			;ASD_Desc
 	s PLIST(7) = BatchNo		;ASD_BatchNo
 	;s PLIST(8) = ExpiryDate	;ExpiryDate
 	s PLIST(9) = Bprice			;Bprice
 	;s PLIST(10) = SerialNo		;SerialNo
 	;s PLIST(11) = No			;No
 	;;AccessoryTypeDR
 	i AccessoryType'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetTypeID(AccessoryType)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到类组: 配件="_Desc_" 类组="_TypeDR)
	.e  d
	..s PLIST(12)=tmpid
 	s PLIST(13) = 0				;Status		库存配件
 	;s PLIST(14) = BaseUOMDR	;BaseUOMDR
 	i BaseUOM'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUnitID(BaseUOM)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该单位: 配件="_Desc_" 设备单位="_BaseUOM)
	.e  d
	..s PLIST(14)=tmpid

  	s PLIST(16) = Model			;Model
 	;s PLIST(17) = ProviderDR	;ProviderDR
 	/*i ProviderDR'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetProviderID(ProviderDR,1)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到供应商: 配件="_Desc_" 供应商="_ProviderDR)
	.e  d
	..s PLIST(17)=tmpid
	*/
 	s PLIST(18) = Stock			;Stock	
 	;s PLIST(19) = FreezeStock	;FreezeStock
 	;s PLIST(20) =	ASD_StartDate
	;s PLIST(21) =	ASD_DisuseDate
	;;;;;;;;;;;;;;;;;;;;;;;;;s PLIST(22) =	ASD_StockDR	库存表DR
	s PLIST(23) = 0				;ASD_InType			入库类型"0":"采购","1":"盘盈","2":"接受捐赠","3":"分解","9":"其他",:"没有定义"
	s PLIST(24) = itemid		;ASD_InSourceID		配件项DR
	;s PLIST(25) =	ASD_ToType
	;s PLIST(26) =	ASD_ToSourceID
	;s PLIST(27) =	ASD_HasStockFlag
	;s PLIST(28) =	ASD_Remark
	s PLIST(29) = LOCATION		;ASD_Location
	;s PLIST(30) =	ASD_BillPage
	i itemid'="" s PLIST(30) = $p($g(^DHCEQCCode("DHCEQCAccessory",itemid)),"^",78)	;帐页
	;s PLIST(31) =	ASD_Hold1
	;s PLIST(32) =	ASD_Hold2
	;s PLIST(33) =	ASD_Hold3
	;s PLIST(34) =	ASD_Hold4
	;s PLIST(35) =	ASD_Hold5
	
	/////////插入配件库存表
	if ChangeType'="Test" Do
	.s RowID=""
	.s id=""
	.For  Set id=$Order(^DHCEQAStock(0,"Loc",PLIST(2),id))  Quit:id=""  Do
	...Set AS=$Get(^DHCEQAStock(id))
	...If ($Piece(AS,"^",2)=itemid) && ($Piece(AS,"^",7)=Bprice) Set RowID=id
	.
	.If (RowID="") Do
	..Set PLISTX(2)=PLIST(2)						;AS_LocDR
	..Set PLISTX(3)=PLIST(3)						;AS_ItemDR
	..Set PLISTX(4)=Code							;AS_Code
	..;Set Desc=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",AccessoryDR)),"^",2)
	..Set PLISTX(5)=Desc							;AS_Desc
	..Set PLISTX(6)=PLIST(12)                		;AS_AccessoryTypeDR
	..;Set PLISTX(7)=ExpiryDate                     ;ExpiryDate
	..Set PLISTX(8)=+Bprice							;AS_FinalBPrice
	..Set PLISTX(9)=+Bprice							;AS_WtdBPrice	标准单价
	..Set PLISTX(11)=+Stock							;AS_Stock
	..Set PLISTX(10)=PLISTX(11)*PLISTX(8)			;AS_Amount
	..&SQL(Insert into sqluser.DHC_EQAStock values :PLISTX())
	..s StockID=$G(%ROWID)
	.Else  Do
	..Set AS=$Get(^DHCEQAStock(RowID))
	..Set XStock=+$Piece(AS,"^",10)
	..Set XAmount=+$Piece(AS,"^",9)
	..; val DHCEQAInStockList
	..Set PLISTX(8)=+Bprice  						;AS_FinalBPrice	最后进价
	..Set PLISTX(11)=XStock+Stock					;AS_Stock
	..Set PLISTX(10)=XAmount+(Stock*PLISTX(8))		;AS_Amount
	.If PLISTX(11)'=0 Set PLIST(9)=PLISTX(10)/PLISTX(11)			;AS_WtdBPrice	标准单价
	..If PLISTX(9)'="" Set PLIST(9)=##Class(web.DHCEQCommon).FormatNumber(PLIST(9),"",3)
	..&SQL(Update sqluser.DHC_EQAStock values :PLISTX() where AS_RowID = :RowID)
	..s StockID=RowID
	.s PLIST(22)=StockID
	
	
	////////插入配件库存详细表
	;If tmpid=""  Do
	if ChangeType'="Test" Do
	.&SQL(Insert Into SQLUSER.DHC_EQAStockDetail Values :PLIST())
	.i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_Code_" Desc="_Desc_" SQLCODE="_SQLCODE)

	Quit:RetStr="" "OK"
	Quit RetStr
}

ClassMethod UpdateDisusedDate(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set fileno=$Piece(RowStr,del,1),date=$Piece(RowStr,del,2)
 	s date = $zdh(date,3)
 	/*Set tmpid=""
	&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where EQ_FileNo=:fileno)
	If tmpid'=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_LeaveFactoryNo=:no Where eq_rowid=:tmpid )
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败: fileno="_fileno_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称不存在DHC_EQEquip:"_fileno)
	*/
	Set tmpid=""
	&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where EQ_FileNo=:fileno)
	If tmpid'=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_Status=3, EQ_DisuseDate=:date Where eq_rowid=:tmpid )
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败: fileno="_fileno_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称不存在DHC_EQEquip:"_fileno)
	
	Quit:RetStr="" "OK"
	Quit RetStr
}

/// 创建：Mozy	2012-12-4
/// 描述：更新His数据
/// 	把系统内旧的科室信息替换为最新的科室名称,需要把新系统的科室数据整理出来
/// 	程序自动把整理得到的数据与当前系统的科室进行比较核对
/// 	不一致则把整理的数据替换当前系统的科室信息
/// 访问表: 
/// 输入：ChangeType：操作类别
/// 			RowStr：代码,名称,备注
/// 输出：无
/// 返回：成功返回"OK",否则返回出错信息
/// 备注：
/// w ##class(web.DHCEQImportData2CSP).UpdateHisData("","")
ClassMethod UpdateHisData(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	Set RowStr=$TRANSLATE(RowStr," ","")
	
 	Set OperationType=$ZCONVERT($Piece(RowStr,del,1),"U")
 	Set ID=$Piece(RowStr,del,2)
	Set CODE=$Piece(RowStr,del,3)
 	Set CODE=##Class(web.DHCEQCommon).Trim(CODE)
 	Set DESC=$Piece(RowStr,del,4)
 	Set DESC=##Class(web.DHCEQCommon).Trim(DESC)
 	Set Name=$Piece(RowStr,del,5)
 	Set Name=##Class(web.DHCEQCommon).Trim(Name)
 	Set Hospital=$Piece(RowStr,del,6)
 	

 	Set find=""
 	If OperationType="" Set RetStr=..RetErrorValue(RetStr,"操作类型不能为空")
 	If CODE="" Set RetStr=..RetErrorValue(RetStr,"系统CODE不能为空")
 	If DESC="" Set RetStr=..RetErrorValue(RetStr,"系统DESC不能为空")
 	
 	
 	If OperationType=1
 	{
 		////////////////  CT_Loc
 		; s ^CTLOC("258")="220403^测试科室^^^^^^^^Y^Y^^^^^^^N^^^N^^N^62811^^N^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	 	;Set NationCode="DHCEQ"		;设备系统使用科室标志
	 	Kill PLIST
	 	Set PLIST(2) = "CXKS"
	 	Set PLIST(3) = "测试科室"
	 	Set PLIST(21) = "Y"
	    Set PLIST(42) = "N"
	    Set PLIST(45) = "N"
		Set PLIST(47) = "N"
		Set PLIST(50) = "N"
		Set PLIST(51) = "N"
	    Set PLIST(53) = "N"
    	
		&SQL(Insert Into SQLUSER.CT_Loc Values :PLIST())
 	}
 	ElseIf OperationType=2
 	{
	 	&SQL(select ctloc_rowid into :find From SQLUSER.CT_Loc where ctloc_rowid=:ID)
	 	If find="" Do
	 	.Set RetStr=..RetErrorValue(RetStr,"系统没有该Id记录:"_ID)
	 	Else  Do
	 	.Set desc=$Piece($Get(^CTLOC(ID)),"^",2)
	 	.If desc'=DESC Do
	 	..If ChangeType'="Test" Do
	 	...&SQL(Update SQLUSER.CT_Loc Set ctloc_code=:CODE,ctloc_desc=:DESC,CTLOC_ContactName=:Name,CTLOC_Hospital_DR=:Hospital Where ctloc_rowid=:ID)
		...If SQLCODE Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_CODE_" Desc="_DESC_" SQLCODE="_SQLCODE)
	}
	ElseIf OperationType=3
 	{
 		////////////////  SS_User
 		&SQL(Insert Into SQLUSER.SS_User (SSUSR_Initials,SSUSR_Name,SSUSR_Group,SSUSR_Password) Values (:ID,'测试姓名',1,'W8!Z0w666666'))
 	}
 	ElseIf OperationType=4
 	{
	 	&SQL(select SSUSR_rowid into :find From SQLUSER.SS_User where SSUSR_rowid=:ID)
	 	If find="" Do
	 	.Set RetStr=..RetErrorValue(RetStr,"系统没有该Id记录:"_ID)
	 	Else  Do
	 	.If ChangeType'="Test" Do
	 	..&SQL(Update SQLUSER.SS_User Set SSUSR_Initials=:CODE,SSUSR_Name=:DESC Where SSUSR_rowid=:ID)
	 	..If SQLCODE Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_CODE_" Desc="_DESC_" SQLCODE="_SQLCODE)
 	}
 	ElseIf OperationType=5
 	{
 	 	////////////////  CT_UOM
 	 	; s ^CT("UOM",4)="测试单位^测试单位"
	 	Kill PLIST
	    Set PLIST(2) = "测试单位"_CODE
 		Set PLIST(3) = "测试单位"_CODE
 		
 		&SQL(Insert Into SQLUSER.CT_UOM Values :PLIST())
 	}
 	ElseIf OperationType=6
 	{
	 	&SQL(select ctuom_rowid into :find From SQLUSER.CT_UOM where ctuom_rowid=:ID)
	 	If find="" Do
	 	.Set RetStr=..RetErrorValue(RetStr,"系统没有该Id记录:"_ID)
	 	Else  Do
	 	.Set desc=$Piece($Get(^CT("UOM",ID)),"^",2)
	 	.If desc'=DESC Do
	 	..If ChangeType'="Test" Do
	 	...&SQL(Update SQLUSER.CT_UOM Set ctuom_code=:CODE,ctuom_desc=:DESC Where ctuom_rowid=:ID)
		...If SQLCODE Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_CODE_" Desc="_DESC_" SQLCODE="_SQLCODE)
 	}
 	ElseIf OperationType=7
 	{
 		////////////////  APC_Vendor
	 	//APCVM_CoCode_DR, APCVM_Code, APCVM_Name, APCVM_Addr, APCVM_City_DR, APCVM_State_DR, APCVM_Zip_DR, APCVM_Tel, APCVM_ContPerson, APCVM_Type, APCVM_CtrlAcct_DR, APCVM_CrLimit, APCVM_DiscRate, APCVM_DiscDays, APCVM_CrTerm, APCVM_Category_DR, APCVM_CrAvail, APCVM_PrevBal, APCVM_CurBal, APCVM_FwdBal, APCVM_LstPoDate, APCVM_LstPayDate, APCVM_LstInvDate, APCVM_CostCent_DR, APCVM_AcctCode_DR, APCVM_RcFlag, APCVM_ShName, APCVM_Fax, APCVM_Grading, APCVM_President, APCVM_Registration, APCVM_Status
	 	Set CatDR=3				;设备系统使用供应商分类
	 	Set Code="CSGYS"
	 	Set Desc="CSGYS-测试供应商"
	 	
	 	&SQL(Insert into SQLUSER.APC_Vendor (APCVM_CoCode_DR, APCVM_Code, APCVM_Name, APCVM_Addr, APCVM_City_DR, APCVM_State_DR, APCVM_Zip_DR, APCVM_Tel, APCVM_ContPerson, APCVM_Type, APCVM_CtrlAcct_DR, APCVM_CrLimit, APCVM_DiscRate, APCVM_DiscDays, APCVM_CrTerm, APCVM_Category_DR, APCVM_CrAvail, APCVM_PrevBal, APCVM_CurBal, APCVM_FwdBal, APCVM_LstPoDate, APCVM_LstPayDate, APCVM_LstInvDate, APCVM_CostCent_DR, APCVM_AcctCode_DR, APCVM_RcFlag, APCVM_ShName, APCVM_Fax, APCVM_Grading, APCVM_President, APCVM_Registration, APCVM_Status) select APCVM_CoCode_DR, :Code, :Desc, APCVM_Addr, APCVM_City_DR, APCVM_State_DR, APCVM_Zip_DR, APCVM_Tel, APCVM_ContPerson, APCVM_Type, APCVM_CtrlAcct_DR, APCVM_CrLimit, APCVM_DiscRate, APCVM_DiscDays, APCVM_CrTerm, :CatDR, APCVM_CrAvail, APCVM_PrevBal, APCVM_CurBal, APCVM_FwdBal, APCVM_LstPoDate, APCVM_LstPayDate, APCVM_LstInvDate, APCVM_CostCent_DR, APCVM_AcctCode_DR, APCVM_RcFlag, :Desc, APCVM_Fax, APCVM_Grading, APCVM_President, APCVM_Registration, APCVM_Status from sqluser.APC_Vendor Where APCVM_RowId=1)
 		Set RowID=$Get(%ROWID)
 		&sql(UPDATE SQLUSER.APC_Vendor SET APCVM_Code=:RowID WHERE APCVM_RowId=:RowID)
 	}	
 	ElseIf OperationType=8
 	{
	 	&SQL(select APCVM_rowid into :find From SQLUSER.APC_Vendor where APCVM_RowId=:ID)
	 	If find="" Do
	 	.Set RetStr=..RetErrorValue(RetStr,"系统没有该Id记录:"_ID)
	 	Else  Do
	 	.If ChangeType'="Test" Do
	 	..&sql(UPDATE SQLUSER.APC_Vendor SET APCVM_Code=:CODE, APCVM_Name=:DESC, APCVM_Category_DR=:CatDR, APCVM_ShName=:DESC WHERE APCVM_RowId=:ID)
	 	..If SQLCODE Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_CODE_" Desc="_DESC_" SQLCODE="_SQLCODE)
 	}
 	
	
 	Quit:RetStr'="" RetStr
 	Quit:RetStr="" "Ok"
	Quit RetStr
}

/// Mozy	2015-6-30
/// 无效设备台帐记录
ClassMethod EQInvalid(ChangeType As %String = "", RowStr As %String = "")
{
	SET RowStr=$tr(RowStr," ","")
	Set del="^",RetStr=""
 	Set name=$Piece(RowStr,del,1),no=$Piece(RowStr,del,3)
 	Set originalfee=$Piece(RowStr,del,6)
 	
 	if no="" Set RetStr=..RetErrorValue(RetStr,"编号不能为空DHC_EQEquip:")
 	if name="" Set RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQEquip:")
 	 
	
	;&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where eq_no=:no and EQ_OriginalFee=:originalfee and EQ_Name=:name)
	;&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where eq_fileno=:no and EQ_OriginalFee=:originalfee and EQ_Name=:name)
	&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where eq_fileno=:no and EQ_Name=:name)
	i tmpid="" q ..RetErrorValue(RetStr,"名称不存在DHC_EQEquip:"_name)
	
	if ChangeType'="Test" Do
	.s no="2016OLD"_no
 	.&SQL(Update sqluser.DHC_EQEquip Set EQ_fileno=:no, EQ_InvalidFlag='Y' Where EQ_RowID=:tmpid)
 	.s ^DHCEQEQInvalidLog("2016OLD",tmpid)=no
	.if SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
	Quit:RetStr="" "Ok"
	Quit RetStr
}

ClassMethod UpdateComponentInfo(ChangeType As %String = "", RowStr As %String = "")
{
	q:ChangeType="Clear" "数据不能清除"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s componentName=$p(RowStr,del,1),defaultSize=$p(RowStr,del,2),itemName=$p(RowStr,del,3)
 	s ItemCaption=$p(RowStr,del,4),itemStyle=$p(RowStr,del,5)
 	s hiddenFlag=$p(RowStr,del,6),dataType=$p(RowStr,del,7)
 	s displayType=$p(RowStr,del,8),displayOnly=$p(RowStr,del,9),newitemName=$p(RowStr,del,10)
 	k PLIST
 	
    Set PLIST(4) = ItemCaption
    Set PLIST(9) = dataType
    Set PLIST(14) = displayOnly
    Set PLIST(15) = displayType
	Set PLIST(17) = hiddenFlag
    Set PLIST(42) = itemStyle
    
    if defaultSize'="" d
	.if ChangeType'="Test" Do
	..&SQL(update SQLUSER.DHC_EQCComponent set C_DefaultSize=:defaultSize where C_Name=:componentName)
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败: componentName="_componentName_" DefaultSize="_DefaultSize_" SQLCODE="_SQLCODE)
	//modified by ZY0199  20191211
	//e  d
	//.Set RetStr=..RetErrorValue(RetStr,"组件:"_componentName_" ,元素itemName:"_itemName_" 没有找到.")
 	i RetStr'="" q RetStr
	
	Set tmpid=""
	&SQL(Select CI_RowID into :tmpid from SQLUSER.DHC_EQCComponentItem where CI_ComponentDR->C_Name=:componentName and CI_Name=:itemName)
	If tmpid'=""  Do
	.if ChangeType'="Test" Do
	..i newitemName'="" Set PLIST(3) = newitemName
	..&SQL(update SQLUSER.DHC_EQCComponentItem values PLIST() where CI_RowID=:tmpid)
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败: componentName="_componentName_" itemName="_itemName_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"组件:"_componentName_" ,元素itemName:"_itemName_" 没有找到.")
 	
 	q:RetStr="" "OK"
	q RetStr
}

/// modified by zy 20191211  ZY0199
/// modified by zy 20180930  ZY0170
/// 导入过程中增加两个属性
/// 导入列信息
ClassMethod ComponentInfo(ChangeType As %String = "", RowStr As %String = "")
{
	q:ChangeType="Clear" "数据不能清除"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s componentName=$p(RowStr,del,1),componentDesc=$p(RowStr,del,2)
	///modified by ZY0199 设置lookup弹窗大小
 	s defaultStyle=$p(RowStr,del,3),className=$p(RowStr,del,4)
 	s classQuery=$p(RowStr,del,5),itemName=$p(RowStr,del,6)
 	s itemDesc=$p(RowStr,del,7),DisplayType=$p(RowStr,del,8)	//modified by ZY0276 20210722
	///modified by zy 20180930  ZY0170 ///导入过程中增加两个属性	
 	s hiddenFlag=$p(RowStr,del,9),LookupCustomComponent=$p(RowStr,del,10)
 	s function=$p(RowStr,del,11)
 	s itemStyle=$p(RowStr,del,12),sort=$p(RowStr,del,13)
 	s Image=$p(RowStr,del,14),LinkUrl=$p(RowStr,del,15)
 	s LinkExpression=$p(RowStr,del,16)
 	s DataType=$p(RowStr,del,17)
 	s DisplayOnly=$p(RowStr,del,18)
 	
 	//add by lmm 2018-09-29 begin
 	s IdField=$p(RowStr,del,19)
 	s TextField=$p(RowStr,del,20)
 	s JsFunction=$p(RowStr,del,21)
 	
 	//add by lmm 2018-09-29 begin
 	s FrozenFlag=$p(RowStr,del,22)  //add by lmm 2018-11-14
 	s ShowInNewWindow=$p(RowStr,del,23)
 	s OlditemName=$p(RowStr,del,24)
 	//Add By QW20200108 BUG:QW0034 begin 增加导入列
 	s ClassMethod=$p(RowStr,del,25)
 	s LinkComponent=$p(RowStr,del,26)
 	s LookupClassName=$p(RowStr,del,27)
 	s LookupProperties=$p(RowStr,del,28)
 	s LookupQueryName=$p(RowStr,del,29)
 	s ValueGet=$p(RowStr,del,30)
 	s SaveFlag=$p(RowStr,del,31)
 	s Required=$p(RowStr,del,32)
	s ComponentSetKey=$p(RowStr,del,33)
 	//Add By QW20200108 BUG:QW0034 End 
 	///add by ZY0213
	s Hold1=$p(RowStr,del,34)
	s Hold2=$p(RowStr,del,35)
	s Hold3=$p(RowStr,del,36)
	s Hold4=$p(RowStr,del,37)
	s Hold5=$p(RowStr,del,38)
	s Tooltip=$p(RowStr,del,39)   //add by lmm 2020-05-20
	s Zone=$p(RowStr,del,40)      //add by QW20200628
	s TableName=$p(RowStr,del,41)      //add by ZY0271
	s ItemType=$p(RowStr,del,42)      //add by ZY0271
	s MultiFlag=$p(RowStr,del,43)      //add by ZY0271
	s Description=$p(RowStr,del,44)    //add by zc0125 2022-12-20 增加描述信息导入
	
	i componentName="" s RetStr=..RetErrorValue(RetStr,"C_Name不能为空!")		//czf 2021-05-17 begin
	i itemName="" s RetStr=..RetErrorValue(RetStr,"CI_Name不能为空!")
	i itemDesc="" s RetStr=..RetErrorValue(RetStr,"CI_Caption不能为空!")
 	i RetStr'="" q RetStr														//czf 2021-05-17 end
	
 	s val="^"_componentName
 	s val=val_"^"_componentDesc
 	s val=val_"^"	//CaptionStyle
 	s val=val_"^"_className
 	s val=val_"^"_classQuery
 	s val=val_"^"	//template
 	s val=val_"^"	//Specification
 	s val=val_"^"	//Remark
 	s val=val_"^"	//C_SysFlag
 	s val=val_"^"	//C_ValueItemDR
 	s val=val_"^"	//C_DescItemDR
 	s val=val_"^"_defaultStyle	//C_DefaultSize
 	s val=val_"^"	//C_Hold5
 	
 	s valList="^"_itemName
 	s valList=valList_"^"_itemDesc
 	s valList=valList_"^"_itemStyle
 	s valList=valList_"^"_ClassMethod	//ClassMethod //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	s valList=valList_"^"	//ClassMethodIfDirty
 	s valList=valList_"^"	//CustomExpression
 	s valList=valList_"^"_DataType	//DataType
 	s valList=valList_"^"	//DefaultValueAlways
 	s valList=valList_"^"	//DefaultValueExpression
 	s valList=valList_"^"_Description   //modified by  zc0125 2022-12-20 增加描述信息导入
 	s valList=valList_"^"	//Disabled
 	s valList=valList_"^"_DisplayOnly	//DisplayOnly
 	s valList=valList_"^"_DisplayType	//DisplayType	//modified by ZY0276 20210722
 	s valList=valList_"^"	//HelpUrl
 	s valList=valList_"^"_hiddenFlag	//Hidden
 	s valList=valList_"^"_Image	//Image
 	s valList=valList_"^"_LinkComponent	//LinkComponent //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	s valList=valList_"^"	//LinkConditionalExp
 	s valList=valList_"^"_LinkExpression	//LinkExpression
 	s valList=valList_"^"_LinkUrl	//LinkUrl
 	s valList=valList_"^"	//LinkWorkFlow
 	s valList=valList_"^"	//ListCellStyle
 	s valList=valList_"^"	//LookupBrokerMethod
 	s valList=valList_"^"_LookupClassName	//LookupClassName //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	s valList=valList_"^"_LookupCustomComponent	//LookupCustomComponent
 	s valList=valList_"^"_function	//LookupJavascriptFunction
 	s valList=valList_"^"_LookupProperties	//LookupProperties //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	s valList=valList_"^"_LookupQueryName	//LookupQueryName //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	s valList=valList_"^"	//LookupUserDefined
 	s valList=valList_"^"	//LookupUserDefinedValues
 	s valList=valList_"^"	//NestedComponent
 	s valList=valList_"^"	//NestedCondExpr
 	s valList=valList_"^"	//OrderMode
 	s valList=valList_"^"	//Password
 	s valList=valList_"^"	//ReadOnly
 	s valList=valList_"^"	//ReferencedObject
 	s valList=valList_"^"_Required	//Required //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	s valList=valList_"^"	//ShortcutKey
 	s valList=valList_"^"_ShowInNewWindow	//ShowInNewWindow modify by lmm 2019-10-16
 	s valList=valList_"^"_itemStyle	//Style
 	s valList=valList_"^"	//TabSequence
 	s valList=valList_"^"_Tooltip    //modify by lmm 2020-05-20
 	s valList=valList_"^"_ValueGet	//ValueGet //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	s valList=valList_"^"	//ValueSet
 	//add by lmm 2018-09-29 begin
 	s valList=valList_"^"_sort	//sort  
 	s valList=valList_"^"_IdField	//sort  
 	s valList=valList_"^"_TextField	//sort  
 	s valList=valList_"^"_JsFunction	//sort  
 	s valList=valList_"^"_FrozenFlag	//FrozenFlag  add by lmm 2018-11-14
 	s valList=valList_"^"_OlditemName	//OlditemName  add by lmm 2019-10-16
 	s valList=valList_"^"_SaveFlag      //CSI_SaveFlag  Add By QW20200108 BUG:QW0034 begin 增加导入列
 	///add by ZY0213
 	s valList=valList_"^"_Hold1	//CI_Hold1
 	s valList=valList_"^"_Hold2	//CI_Hold2
 	s valList=valList_"^"_Hold3	//CI_Hold3
 	s valList=valList_"^"_Hold4	//CI_Hold4
 	s valList=valList_"^"_Hold5	//CI_Hold5
 	s valList=valList_"^"_Zone	//add by QW20200628
 	
 	s valList=valList_"^"_TableName	//add by ZY0271
 	s valList=valList_"^"_ItemType	//add by ZY0271
 	s valList=valList_"^"_MultiFlag	//add by ZY0271
 	
 	if ChangeType'="Test" d
 	.s SQLCODE= ##Class(web.DHCEQCComponent).SaveData(val,valList,0,"Y",ComponentSetKey)  //Modified By QW20200108 BUG:QW0034 增加入参
 	.i SQLCODE=-1111 s RetStr=..RetErrorValue(RetStr,"导入失败,组件名称:"_componentName_"组件元素:"_itemName_"sqcode:"_SQLCODE_"IdField:"_IdField_"或TextField:"_TextField_"的列数据不存在,该行请放置相应数据行后")
 	.e  i SQLCODE<0 s RetStr=..RetErrorValue(RetStr,"导入失败,组件名称:"_componentName_"组件元素:"_itemName_"sqcode:"_SQLCODE)
 	//modify by lmm 2020-05-20
 	q:RetStr="" "OK"
	q RetStr
}

/// Author:add by czf 20171215
/// Description:插入医院数据
/// Input:ChangeType:Clear:清除数据,Test:数据测试;
/// Command:d ##Class(web.DHCEQImportData2CSP).Hospital("","")
ClassMethod Hospital(ChangeType As %String = "", RowStr As %String = "")
{
	if ChangeType="Clear" k ^DHCEQKB("DHCEQKBHospital")
	Quit:ChangeType="Clear" "数据已清:医院(DHC_EQKBHospital)"
	
	k PLIST
	Set del="^",RetStr=""
	Set RowStr=$tr(RowStr," ","")
 	Set code=$Piece(RowStr,del,1),desc=$Piece(RowStr,del,2)
 	Set PLIST(2)=desc
 	Set PLIST(3)=code
 	Set PLIST(4)=$Piece(RowStr,del,3)	;remark
 	Set PLIST(5)=$Piece(RowStr,del,4)	;address
 	Set PLIST(6)=$Piece(RowStr,del,5)	;telphone
 	Set PLIST(7)="N"					;InvalidFlag
 	if desc="" Set RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQKBHospital:")
 	if RetStr'="" Quit RetStr
 	if code="" Set RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQKBHospital:")
 	if RetStr'="" Quit RetStr
 	
 	Set desc=$ZCONVERT(desc,"U")	
	Set tmpid=""
	&SQL(Select H_RowID into :tmpid from SQLUSER.DHC_EQKBHospital where H_Desc=:desc)
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Insert into SQLUSER.DHC_EQKBHospital values PLIST())
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQKBHospital:"_desc)
 	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Author:add by czf 2017-12-15
/// Description:插入标准设备项
/// Input:Type:0 插入标准设备项, 1 更新整个项目标准设备项
/// 插入新的标准设备项(DHC_EQKBMstItem)时更新DHC_EQKBSMstItem
ClassMethod KBMstItem(ChangeType As %String = "", RowStr As %String = "", Type As %String = "")
{
	i ChangeType="Clear"  d
	.k ^DHCEQKB("DHCEQKBMstItem")
	.k ^DHCEQKB("DHCEQKBSMstItem")
	q:ChangeType="Clear" "数据已清:标准设备项(DHC_EQKBMstItem)&标准设备项统计表(DHC_EQKBSMstItem)"
	
	s $ZT="ERRORInsert"
	s del="^",RetStr="",KBSValue="",KBMIRowID=""
	s RowStr=$tr(RowStr," ","")
 	s desc=$p(RowStr,del,1)
 	//s code=$p(RowStr,del,2)
 	s desc=$ZCONVERT(desc,"U")
 	s desc=$replace(desc,"（","(")
 	s desc=$replace(desc,"）",")")
 	s desc=$replace(desc,"，",",")
 	s code=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")
 	s financetype=$p(RowStr,del,3),statcat=$p(RowStr,del,4)
 	s equipcat=$p(RowStr,del,5),unit=$p(RowStr,del,6),hospital=$p(RowStr,del,7)
 	s treecat=$p(RowStr,del,8),remark=$p(RowStr,del,9)
 	s forceinspectflag=$p(RowStr,del,10)
 	s medicalfalg=$p(RowStr,del,11)
 	s raditionflag=$p(RowStr,del,12)
 	s measureflag=$p(RowStr,del,13)
 	s cyclenum=$p(RowStr,del,14),cycleunit=$p(RowStr,del,15)
 	
 	k PLIST
 	
 	i code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQKBMstItem:")
 	i RetStr'="" q RetStr
 	i desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQKBMstItem:")
 	i RetStr'="" q RetStr
 	
 	s financetypeid=""
 	i financetype'=""  d
	.s financetypeid=##Class(web.DHCEQImportDataTool).GetFinanceTypeID(financetype)
	.i financetypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该资产大类: 设备="_desc_" 资产大类"_financetype)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置资产大类: 设备="_desc_" 资产大类="_financetype)
 	i RetStr'="" q RetStr
 	
 	s hospid=""
 	i hospital'=""  d
	.s hospid=##Class(web.DHCEQImportDataTool).GetHospID(hospital)
	.i hospid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到该医院: 设备="_desc_" 医院="_hospital)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置医院: 设备="_desc_" 医院="_hospital)
 	i RetStr'="" q RetStr
    
    s StatCatID=""
	i statcat'=""  d
	.s StatCatID=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i StatCatID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_desc_" 设备类型="_statcat)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_desc_" 设备类型="_statcat)
	i RetStr'="" q RetStr
	
    s CatID=""
 	i equipcat'=""  d
	.s CatID=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,equipcat)
	.i CatID=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_desc_" 设备分类="_equipcat)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_desc)
	i RetStr'="" q RetStr
	
	i treecat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetTreeID(treecat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该68码分类: 设备="_desc_" 68码分类="_treecat)
	.e  d
	..s PLIST(7)=tmpid	;TreeDR
	i RetStr'="" q RetStr
	
    i unit'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_desc_" 设备单位="_unit)
	.e  d
	..s PLIST(8)=tmpid	;UnitDR
	i RetStr'="" q RetStr
	
	s CUID=""
    i cycleunit'=""  d
	.s CUID=##Class(web.DHCEQImportDataTool).GetCycleUnitID(cycleunit)
	.i CUID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到计量单位: 设备="_desc_" 计量单位="_cycleunit)
	;i RetStr'="" q RetStr
	
	i ((ChangeType'="Test")&&(Type'=1)) d		//更新整个项目标准项数据测试时不检测
	.s tmpid=""
	.&SQL(Select MI_RowID into :tmpid from SQLUSER.DHC_EQKBMstItem where MI_Desc=:desc and MI_FinanceTypeDR=:financetypeid and MI_StatCatDR=:StatCatID and MI_CatDR=:CatID and MI_HospDR=:hospid)
	.i tmpid'="" d
	..Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQKBMstItem:设备="_desc)
	i RetStr'="" q RetStr
	
	s PLIST(2)=desc
    s PLIST(3)=code
    s PLIST(4)=financetypeid		;财务大类
    s PLIST(5)=StatCatID			;设备类型
    s PLIST(6)=CatID				;设备分类
    s PLIST(9)="N"					;无效标志
    s PLIST(10)=forceinspectflag	;强检标志
 	s PLIST(11)=medicalfalg			;医疗标志
 	s PLIST(12)=raditionflag  		;放射标志
 	s PLIST(13)=measureflag   		;计量标志
 	s PLIST(14)=cyclenum     		;计量周期
 	s PLIST(15)=CUID				;计量单位
    s PLIST(16)=remark				;备注
    s PLIST(17)=hospid				;医院ID
	s PLIST(18)="N"					;设备分类末级标志
	s Find='$d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",CatID))
	i Find=0 s PLIST(18) ="Y"
	
	TStart
    if ChangeType'="Test"
    {
    	&SQL(Insert Into SQLUSER.DHC_EQKBMstItem Values :PLIST())
		i SQLCODE
		{
			s RetStr=..RetErrorValue(RetStr,"插入DHC_EQKBMstItem失败: Desc="_desc_" SQLCODE="_SQLCODE)
			TROLLBACK
			q RetStr
		}
		s RowID=$G(%ROWID)
		s KBSValue=##Class(web.DHCEQImportData2CSP).UpdateKBSMstItem(RowID,"")
		i KBSValue
		{
			s RetStr=..RetErrorValue(RetStr,"插入DHC_EQKBMstItem失败: Desc="_desc_" SQLCODE="_KBSValue)
			TROLLBACK
			q RetStr
		}
    }
 	i RetStr="" s RetStr="OK"
	TCOMMIT
	q RetStr
ERRORInsert 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORInsert"_ErrorMsg     //返回错误消息 ;
}

/// Author:add by czf 2017-12-18
/// Description:标准设备项统计,每次导入标准设备项数据后，更新DHC_EQKBSMstItm表
/// Input:KBMIID 新数据标准设备项的ID ; oldval 原标准设备项串
/// Command:d ##Class(web.DHCEQImportData2CSP).UpdateKBSMstItem("B超诊断机^BCZDJ^2^9^2587^^4^N^^^^^^^^2^N^^^^^^^^","2^9^2593")
ClassMethod UpdateKBSMstItem(KBMIID, oldval As %String = "")
{
	s RetStr=""
	k PLISTMX
	s val=$g(^DHCEQKB("DHCEQKBMstItem",KBMIID))
	s desc=$p(val,"^",1)
	s desc=$ZCONVERT(desc,"U")
	s financetypedr=$p(val,"^",3)
	s statcatdr=$p(val,"^",4)
	s catdr=$p(val,"^",5)
	s PLISTMX(2)=desc
	s PLISTMX(3)=$p(val,"^",2)	;code
	s PLISTMX(4)=financetypedr
	s PLISTMX(5)=statcatdr
	s PLISTMX(6)=catdr
	s PLISTMX(7)=$p(val,"^",6)	;treecatdr
	s PLISTMX(8)=$p(val,"^",7)	;unitdr
	s PLISTMX(9)="N"
	i $p(val,"^",9)="Y" s PLISTMX(10)="Y"		;ForceInspectFlag
	i $p(val,"^",10)="Y" s PLISTMX(11)="Y"		;MedicalFlag
	i $p(val,"^",11)="Y" s PLISTMX(12)="Y"		;RaditionFlag
	i $p(val,"^",12)="Y" d						;MeasureFlag
	.s PLISTMX(13)="Y"							;MeasureFlag
	.s PLISTMX(14)=$p(val,"^",13)				;CycleNum
	.s PLISTMX(15)=$p(val,"^",14)				;CycleUnit
	s PLISTMX(16)=$p(val,"^",15)				;Remark
	s PLISTMX(18)=$p(val,"^",17)				;EqCatInEndFlag
	
	s oldsmiid=""
	i oldval'="" d
	.s oldfinancedr=$p(oldval,"^",1)
	.s oldstatcatdr=$p(oldval,"^",2)
	.s oldcatdr=$p(oldval,"^",3)
	.s oldsmiid=$o(^DHCEQKB("DHCEQKBSMstItem",0,"MultiDR",desc,oldfinancedr,oldstatcatdr,oldcatdr,oldsmiid))
	
	s smirowid=""
	s smirowid=$o(^DHCEQKB("DHCEQKBSMstItem",0,"MultiDR",desc,financetypedr,statcatdr,catdr,smirowid))
	
	i oldsmiid'=""
	{
		s PLISTMX(17)=$p($g(^DHCEQKB("DHCEQKBSMstItem",oldsmiid)),"^",16)-1	//旧分类频次减1
		i PLISTMX(17)<=0
		{
			&SQL(Delete SQLUSER.DHC_EQKBSMstItem where SMI_RowID=:oldsmiid)
			i SQLCODE=100 s SQLCODE=0
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQKBSMstItem set SMI_Frequency=:PLISTMX(17) where SMI_RowID=:oldsmiid)
		}
		i SQLCODE q ..RetErrorValue(RetStr,"更新DHC_EQKBSMstItem原类别频次失败: Desc="_desc_" SQLCODE="_SQLCODE)
	}	
	
	i smirowid=""
	{
		s PLISTMX(17)=1
    	&SQL(Insert Into SQLUSER.DHC_EQKBSMstItem Values :PLISTMX())
	}
	else
	{
		s PLISTMX(17)=$p($g(^DHCEQKB("DHCEQKBSMstItem",smirowid)),"^",16)+1	//新分类频次加1
		&SQL(Update SQLUSER.DHC_EQKBSMstItem set SMI_Frequency=:PLISTMX(17) where SMI_RowID=:smirowid)
	}
	i SQLCODE  s RetStr=..RetErrorValue(RetStr,"更新DHC_EQKBSMstItem失败: Desc="_desc_" SQLCODE="_SQLCODE)

 	q:RetStr="" 0
	q RetStr
}

/// Author:Add By CZF 20171218
/// Description:调整更新及补充标准设备项分类等信息
/// Input:ChangeType:Clear(清除数据),Test(测试数据)
/// Method:d ##Class(web.DHCEQImportData2CSP).UpdateKBMstItem()
ClassMethod UpdateKBMstItem(ChangeType As %String = "", RowStr As %String = "")
{
	i ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQKBMstItem")
	q:ChangeType="Clear" "数据已清:设备项(DHC_EQKBMsttem)"
	
	s del="^",RetStr="",KBSValue="",KBMIRowID="",mirowid="",OldVal=""
	s RowStr=$tr(RowStr," ","")
 	s Name=$p(RowStr,del,1),FromFinanceType=$p(RowStr,del,2)
 	s FromStatCat=$p(RowStr,del,3),FromEquipCat=$p(RowStr,del,4)
 	s FromHosp=$p(RowStr,del,5)
 	s ToFinanceType=$p(RowStr,del,6)
 	s ToStatCat=$p(RowStr,del,7),ToEquipCat=$p(RowStr,del,8)
 	s ToTreeCat=$p(RowStr,del,9)
 	s ToHosp=$p(RowStr,del,10),ToUnit=$p(RowStr,del,11)
 	s ToForceInspectFalg=$p(RowStr,del,12)
 	s ToMedicalFalg=$p(RowStr,del,13)
 	s ToRaditionFlag=$p(RowStr,del,14)
 	s ToMeasureFlag=$p(RowStr,del,15)
 	s ToCycleNum=$p(RowStr,del,16),ToCycleUnit=$p(RowStr,del,17)
 	
 	i Name="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQKBMstItem:")
 	i RetStr'="" q RetStr
 	
 	i (FromFinanceType'="")&&(FromStatCat'="")&&(FromEquipCat'="")&&(FromHosp'="")
 	{
	 	s (FromFTypeID,FromStatCatID,FromEquipCatID,FromHospID)=""
	 	s FromFTypeID=##Class(web.DHCEQImportDataTool).GetFinanceTypeID(FromFinanceType)
	 	i FromFTypeID="" s RetStr=..RetErrorValue(RetStr,"没有来源资产大类: 设备="_Name_" 资产大类="_FromFinanceType)
	 	if RetStr'="" q RetStr
	 	s FromStatCatID=##Class(web.DHCEQImportDataTool).GetStatCatID(FromStatCat)
	 	i FromStatCatID="" s RetStr=..RetErrorValue(RetStr,"没有找到来源类型: 设备="_Name_" 设备类型"_FromStatCat)
	 	if RetStr'="" q RetStr
	 	s FromEquipCatID=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,FromEquipCat)
	 	i FromEquipCatID="" s RetStr=..RetErrorValue(RetStr,"没有找到来源分类: 设备="_Name_" 设备分类="_FromEquipCat)
	 	if RetStr'="" q RetStr
	 	s FromHospID=##Class(web.DHCEQImportDataTool).GetHospID(FromHosp)
	 	i FromHospID="" s RetStr=..RetErrorValue(RetStr,"没有来源医院: 设备="_Name_" 医院"_FromHosp)
	 	if RetStr'="" q RetStr
	 	
		s OldVal=FromFTypeID_"^"_FromStatCatID_"^"_FromEquipCatID
		&SQL(Select mi_rowid into :mirowid from SQLUSER.DHC_EQKBMstItem where mi_desc=:Name and mi_Hospdr=:FromHospID and mi_financetypedr=:FromFTypeID and mi_statcatdr=:FromStatCatID and mi_catdr=:FromEquipCatID)
 	}
 	k PLIST
 	
 	s ToFtypeID=""
 	i ToFinanceType'=""  d
	.s ToFtypeID=##Class(web.DHCEQImportDataTool).GetFinanceTypeID(ToFinanceType)
	.i ToFtypeID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该资产大类: 设备="_Name_" 资产大类="_ToFinanceType)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置资产大类: 设备="_Name_" 资产大类="_ToFinanceType)
 	i RetStr'="" q RetStr
 	
 	s ToStatCatID=""
	i ToStatCat'=""  d
	.s ToStatCatID=##Class(web.DHCEQImportDataTool).GetStatCatID(ToStatCat)
	.i ToStatCatID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_Name_" 设备类型="_ToStatCat)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_Name_" 设备类型="_ToStatCat)
	i RetStr'="" q RetStr
	
	s ToEquipCatID=""
 	i ToEquipCat'=""  d
	.s ToEquipCatID=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,ToEquipCat)
	.i ToEquipCatID=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_Name_" 设备分类="_ToEquipCat)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_Name_" 设备分类="_ToEquipCat)
	i RetStr'="" q RetStr
	
	s ToTreeCatID=""
	i ToTreeCat'=""  d
	.s ToTreeCatID=##Class(web.DHCEQImportDataTool).GetTreeID(ToTreeCat)
	.i ToTreeCatID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该68码分类: 设备="_Name_" 68码分类="_ToTreeCat)
	i RetStr'="" q RetStr
	
	s ToHospID=""
 	i ToHosp'=""  d
	.s ToHospID=##Class(web.DHCEQImportDataTool).GetHospID(ToHosp)
	.i ToHospID=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到该医院: 设备="_Name_" 医院="_ToHosp)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置医院: 设备="_Name_" 医院="_ToHosp)
 	i RetStr'="" q RetStr
    
    s unitid=""
    i ToUnit'=""  d
	.s unitid=##Class(web.DHCEQImportDataTool).GetUnitID(ToUnit)
	.i unitid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_Name_" 设备单位="_ToUnit)
	i RetStr'="" q RetStr
	
	s CUID=""
    i ToCycleUnit'=""  d
	.s CUID=##Class(web.DHCEQImportDataTool).GetCycleUnitID(ToCycleUnit)
	.i CUID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到计量单位: 设备="_Name_" 计量单位="_ToCycleUnit)
	
	s tomirowid=""
	&SQL(Select mi_rowid into :tomirowid from SQLUSER.DHC_EQKBMstItem where mi_desc=:Name and mi_Hospdr=:ToHospID and mi_financetypedr=:ToFtypeID and mi_statcatdr=:ToStatCatID and mi_catdr=:ToEquipCatID)
	i tomirowid'="" s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQKBMstItem:"_Name)
	i RetStr'="" q RetStr
	
	s PLIST(2)=Name
	s PLIST(3)=##class(web.DHCEQCHanZiEncoding).GetEncoding(Name,"4","","U")
	s PLIST(4)=ToFtypeID
	s PLIST(5)=ToStatCatID
	s PLIST(6)=ToEquipCatID
	s PLIST(7)=ToTreeCatID
	s PLIST(8)=unitid
    s PLIST(9)="N"
    s PLIST(10)=ToForceInspectFalg	;强检标志
 	s PLIST(11)=ToMedicalFalg		;医疗标志
 	s PLIST(12)=ToRaditionFlag  	;放射标志
 	s PLIST(13)=ToMeasureFlag   	;计量标志
 	s PLIST(14)=ToCycleNum     		;计量周期
 	s PLIST(15)=CUID				;计量单位
    s PLIST(17)=ToHospID
	s PLIST(18)="N"
	s Find='$d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",ToEquipCatID))
	i Find=0 s PLIST(18) ="Y"
    
    s $ZT="ERRORUpdate"
    
    TStart
    if ChangeType'="Test"
    {
	    i (mirowid="")	//原资产大类、类型、分类、医院为空
	    {
		    &SQL(Insert Into SQLUSER.DHC_EQKBMstItem Values :PLIST())
			i SQLCODE 
			{
				s RetStr=..RetErrorValue(RetStr,"插入DHC_EQKBMstItem失败: Desc="_Name_" SQLCODE="_SQLCODE)
				TROLLBACK
				q RetStr
			}
			s RowID=$G(%ROWID)
			s KBSValue=..UpdateKBSMstItem(RowID,"")
			i KBSValue 
			{
				s RetStr=..RetErrorValue(RetStr,"更新DHC_EQKBSMstItem失败: Desc="_Name_" SQLCODE="_SQLCODE)
				TROLLBACK
				q RetStr
			}
   	 	}
		else
		{
			&SQL(Update SQLUSER.DHC_EQKBMstItem Values :PLIST() where MI_RowID=:mirowid)
			i SQLCODE 
			{	
				s RetStr=..RetErrorValue(RetStr,"更新DHC_EQKBMstItem失败: Desc="_Name_" SQLCODE="_SQLCODE)
				TROLLBACK 
				q RetStr
			}
			s KBSValue=..UpdateKBSMstItem(mirowid,OldVal)
			i KBSValue 
			{
				s RetStr=..RetErrorValue(RetStr,"更新DHC_EQKBSMstItem失败: Desc="_Name_" SQLCODE="_SQLCODE)
				TROLLBACK
				q RetStr
			}
		}
    }
    i RetStr="" s RetStr="OK"
    TCOMMIT
	q RetStr
ERRORUpdate 
	TRollBack	
	Set ErrorMsg=$ZE
 	Quit "ERRORUpdate"_ErrorMsg
}

/// Author:add by czf 20180514
/// Description:向中间表(DHC_EQTransition)插入分类匹配设备
/// Input:ChangeType:Clear:清除数据,Test:数据测试;
/// modified by czf 20201028 增加类组和类型导,匹配时可根据类组匹配，根据类型匹配
/// Command:d ##Class(web.DHCEQImportData2CSP).MatchCatEquip("a^A^2^3^4^5^6","")
ClassMethod MatchCatEquip(ChangeType As %String = "", RowStr As %String = "")
{
	i ChangeType="Clear" k ^DHCEQKB("DHCEQMatchCatList")
	q:ChangeType="Clear" "数据已清:(DHC_EQMatchCatList)"
	
	k PLIST
	s del="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
 	s desc=$Piece(RowStr,del,1)
 	s desc=$ZCONVERT(desc,"U")
 	s desc=$replace(desc,"（","(")
 	s desc=$replace(desc,"）",")")
 	s desc=$replace(desc,"，",",")
 	s financetype=$Piece(RowStr,del,2)
 	s statcat=$Piece(RowStr,del,3)
 	s equipcat=$Piece(RowStr,del,4)
 	s unit=$Piece(RowStr,del,5)
 	s hospital=$Piece(RowStr,del,6)
 	s newhospflag=$Piece(RowStr,del,7)
 	
 	i desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQMatchCatList:")
 	i RetStr'="" q RetStr
 	
 	s financetypeID=""
 	i financetype'=""  d
	.s financetypeID=##Class(web.DHCEQImportDataTool).GetFinanceTypeID(financetype)
	.i financetypeID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该资产大类: 设备="_desc_" 资产大类="_financetype)
 	i RetStr'="" q RetStr
 	
 	s statcatID=""
	i statcat'=""  d
	.s statcatID=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i statcatID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_desc_" 设备类型="_statcat)
	i RetStr'="" q RetStr
	
    s equipcatID=""
 	i equipcat'=""  d
	.s equipcatID=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,equipcat)
	.i equipcatID=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_desc_" 设备分类="_equipcat)
	i RetStr'="" q RetStr
	
	s unitID=""
	i unit'=""  d
	.s unitID=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
	.i unitID=""  d 
	..;s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_desc_" 设备单位="_unit)
	
	s hospID=""
 	i hospital'=""  d
	.s hospID=##Class(web.DHCEQImportDataTool).GetHospID(hospital)
	.i hospID=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到该医院: 设备="_desc_" 医院="_hospital)
 	i RetStr'="" q RetStr
 	
 	s PLIST(2)=desc
 	s PLIST(14)=financetypeID
 	s PLIST(15)=statcatID
 	s PLIST(16)=equipcatID
 	s PLIST(17)=unitID
 	s PLIST(18)=hospID
 	s PLIST(22)=newhospflag
 	
 	s desc=$ZCONVERT(desc,"U")
	s tmpid=""
	;&SQL(Select MCL_RowID into :tmpid from SQLUSER.DHC_EQMatchCatList where MCL_Desc=:desc)
	i tmpid=""  d
	.i ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQMatchCatList values PLIST())
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQMatchCatList:"_desc)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// Author:Add By CZF 2018-04-23
/// Description:ETL工具导入和更新标准设备项
/// Input：type：1 导入标准设备项,2 更新标准设备项
/// Command:d ##Class(web.DHCEQImportData2CSP).UpdateImportData(1)
ClassMethod UpdateImportData(type)
{
	k ^TempEQTrans("ReturnStr")
	s ReturnStr=""
	s rowid=0
	f  s rowid=$o(^DHCEQTransition(rowid))  quit:rowid=""  d
	.s DataList=$G(^DHCEQTransition(rowid))
	.s THold1=$p(DataList,"^",1)
	.s THold2=$p(DataList,"^",2)
	.s THold3=$p(DataList,"^",3)
	.s THold4=$p(DataList,"^",4)
	.s THold5=$p(DataList,"^",5)
	.s THold6=$p(DataList,"^",6)
	.s THold7=$p(DataList,"^",7)
	.s THold8=$p(DataList,"^",8)
	.s THold9=$p(DataList,"^",9)
	.s THold10=$p(DataList,"^",10)
	.s THold11=$p(DataList,"^",11)
	.s THold12=$p(DataList,"^",12)
	.s THold13=$p(DataList,"^",13)
	.s THold14=$p(DataList,"^",14)
	.s THold15=$p(DataList,"^",15)
	.s THold16=$p(DataList,"^",16)
	.s THold17=$p(DataList,"^",17)
	.s THold18=$p(DataList,"^",18)
	.s THold19=$p(DataList,"^",19)
	.s THold20=$p(DataList,"^",20)
	.s THold21=$p(DataList,"^",21)
	.s THold22=$p(DataList,"^",22)
	.s THold23=$p(DataList,"^",23)
	.s THold24=$p(DataList,"^",24)
	.s THold25=$p(DataList,"^",25)
	.s THold26=$p(DataList,"^",26)
	.s THold27=$p(DataList,"^",27)
	.s THold28=$p(DataList,"^",28)
	.s THold29=$p(DataList,"^",29)
	.s THold30=$p(DataList,"^",30)
	.s THold31=$p(DataList,"^",31)
	.s THold32=$p(DataList,"^",32)
	.s THold33=$p(DataList,"^",33)
	.s THold34=$p(DataList,"^",34)
	.s THold35=$p(DataList,"^",35)
	.s THold36=$p(DataList,"^",36)
	.s THold37=$p(DataList,"^",37)
	.s THold38=$p(DataList,"^",38)
	.s THold39=$p(DataList,"^",39)
	.s ReturnStr=THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_THold6_"^"_THold7_"^"_THold8_"^"_THold9_"^"_THold10_"^"_THold11_"^"_THold12_"^"_THold13_"^"_THold14_"^"_THold15_"^"_THold16_"^"_THold17_"^"_THold18_"^"_THold19_"^"_THold20_"^"_THold21_"^"_THold22_"^"_THold23_"^"_THold24_"^"_THold25_"^"_THold26_"^"_THold27_"^"_THold28_"^"_THold29_"^"_THold30_"^"_THold31_"^"_THold32_"^"_THold33_"^"_THold34_"^"_THold35_"^"_THold36_"^"_THold37_"^"_THold38_"^"_THold39
	.i type=1 s ReturnStr=##Class(web.DHCEQImportData2CSP).KBMstItem("Append",ReturnStr)
	.i type=2 s ReturnStr=##Class(web.DHCEQImportData2CSP).UpdateKBMstItem("Append",ReturnStr)
	.i ReturnStr'="OK" s ^TempEQTrans("ReturnStr",rowid)=ReturnStr
	q ReturnStr
}

/// Author:Add By CZF 2018-04-23
/// Description:删除整个医院标准设备项并更新标准设备项统计表
/// Input：hospital：医院名称
/// Command:d ##Class(web.DHCEQImportData2CSP).DelHospKBMstItem("海安县人民医院")
ClassMethod DelHospKBMstItem(hospital)
{
	s RetStr=""
	s HospID=##Class(web.DHCEQImportDataTool).GetHospID(hospital)
	i HospID="" s RetStr=..RetErrorValue(RetStr,"没有医院"_hospital)
	i RetStr q RetStr
	s $ZT="ERRORDelete"
	
	TSTART 
	i $d(^DHCEQKB("DHCEQKBMstItem",0,"HospDR",HospID))
	{
		s KBMstID=""
		f  s KBMstID=$o(^DHCEQKB("DHCEQKBMstItem",0,"HospDR",HospID,KBMstID)) q:(KBMstID="")||(RetStr'="")  d
		.s desc=$p(^DHCEQKB("DHCEQKBMstItem",KBMstID),"^",1)
		.s FTID=$p(^DHCEQKB("DHCEQKBMstItem",KBMstID),"^",3)
		.s SCID=$p(^DHCEQKB("DHCEQKBMstItem",KBMstID),"^",4)
		.s ECID=$p(^DHCEQKB("DHCEQKBMstItem",KBMstID),"^",5)
		.s smid=""
		.s sminum=0
		.&SQL(Select smi_rowid,smi_frequency into :smid,:sminum from SQLUSER.DHC_EQKBSMstItem where smi_desc=:desc and smi_financetypedr=:FTID and smi_statcatdr=:SCID and smi_catdr=:ECID)
		.i smid'="" d
		..s sminum=sminum-1
		..i sminum<=0 d
		...&SQL(Delete SQLUSER.DHC_EQKBSMstItem where SMI_RowID=:smid)
		...i SQLCODE=100 s SQLCODE=0
		..e  d
		...&SQL(Update SQLUSER.DHC_EQKBSMstItem set SMI_Frequency=:sminum where SMI_RowID=:smid)
		..i SQLCODE s RetStr="删除DHC_EQKBSMstItem失败,SQLCODE="_SQLCODE
		i RetStr
		{
			TROLLBACK
			q RetStr
		}
		&SQL(delete SQLUSER.DHC_EQKBMstItem where mi_hospdr=:HospID)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE s RetStr="删除DHC_EQKBMstItem失败,医院="_hospital_" SQLCODE="_SQLCODE
		i RetStr
		{
			TROLLBACK
			q RetStr
		}
	}
	i RetStr="" s RetStr="OK"
	TCOMMIT
	q RetStr
	
ERRORDelete
	TRollBack	
	Set ErrorMsg=$ZE
 	Quit "ERRORDelete"_ErrorMsg
}

/// add by lmm 2018-09-29
/// 描述：导入组件定义入参
ClassMethod ComponentParasInfo(ChangeType As %String = "", RowStr As %String = "")
{
	
	q:ChangeType="Clear" "数据不能清除"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s componentName=$p(RowStr,del,1),componentparaCode=$p(RowStr,del,2)
 	s Position=$p(RowStr,del,3),ValueType=$p(RowStr,del,4)
 	s Value=$p(RowStr,del,5)
 	s OldParaCode=$p(RowStr,del,6) //Add By QW20200108 BUG:QW0034 begin 增加导入列
 	if ChangeType'="Test" d
 	.s SQLCODE= ##Class(web.DHCEQCComponent).SaveComponentParaData(componentName,componentparaCode,Position,ValueType,Value,OldParaCode) //Modified By QW20200108 BUG:QW0034 begin 增加导入列
 	.i SQLCODE<0 s RetStr=..RetErrorValue(RetStr,"导入失败,组件名称:"_componentName_"入参名称:"_componentparaCode)

 	q:RetStr="" "OK"
	q RetStr
}

/// Author:add by czf 20180823
/// Description:HISUI改造:更新组件元素OtherScripts
/// Input:ChangeType:Test:数据测试;
/// Command:d ##Class(web.DHCEQImportData2CSP).UpdateComponent("","")
ClassMethod UpdateComponent(ChangeType As %String = "", RowStr As %String = "")
{
	Set RetStr=""
 	Set name=$Piece(RowStr,"^",1)
 	Set name=$tr(name," ","")
 	Set filed=$Piece(RowStr,"^",2)
 	Set value=$Piece(RowStr,"^",3)
 	if name="" Set RetStr=..RetErrorValue(RetStr,"组件名称不能为空")
 	if filed="" Set RetStr=..RetErrorValue(RetStr,"属性不能为空")
 	if RetStr'="" Quit RetStr
 	
	Set tmpid=""
	&SQL(Select ID into :tmpid from SQLUSER.websys.component where Name=:name)
	If tmpid'=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Update SQLUSER.websys.component set OtherScripts=:value where ID=:tmpid)
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败:filed="_filed_" value="_value_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"组件不存在websys.component"_name)
 	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Author:add by czf 20180823
/// Description:HISUI改造:更新组件元素
/// Input:ChangeType:Test:数据测试;
/// Command:d ##Class(web.DHCEQImportData2CSP).UpdateComponentItem("","DHCEQAffixDetailFind^TRow^General^Style^TEXT-ALIGN:center^陈飞^2018/8/15^")
ClassMethod UpdateComponentItem(ChangeType As %String = "", RowStr As %String = "")
{
	s del="^",RetStr=""
	//s RowStr=$tr(RowStr," ","")
 	s component=$Piece(RowStr,del,1)
 	s component=$tr(component," ","")
 	s ItemName=$Piece(RowStr,del,2)
 	s properties=$Piece(RowStr,del,4)
 	s value=$Piece(RowStr,del,5)
 	
 	s component=$$ALPHAUP^SSUTIL4(component)
 	i component="" s RetStr=..RetErrorValue(RetStr,"组件名称不能为空")
 	e  d
 	.s ComponentId=""
 	.i $d(^websys.ComponentI("UniqueNameIndex",component))'=0  d
	..s ComponentId=""
	..s ComponentId=$o(^websys.ComponentI("UniqueNameIndex",component,ComponentId))
 	.i ComponentId="" s RetStr=..RetErrorValue(RetStr,"组件不存在")
 	
 	s ItemName=" "_$$ALPHAUP^SSUTIL4(ItemName)
 	i ItemName="" s RetStr=..RetErrorValue(RetStr,"组件元素名称不能为空")
 	e  d
 	.s ItemId="",TableItemId=""
 	.i $d(^websys.ComponentItemsI("Name",ComponentId,ItemName))'=0  d
	..s ItemId=$o(^websys.ComponentItemsI("Name",ComponentId,ItemName,ItemId))	;item
	.e  i $d(^websys.ComponentTableItemsI("Name",ComponentId,ItemName))'=0  d
	..s TableItemId=$o(^websys.ComponentTableItemsI("Name",ComponentId,ItemName,TableItemId))	;tableitem
	.i (ItemId="")&&(TableItemId="") s RetStr=..RetErrorValue(RetStr,"组件元素不存在")
	
	i properties="" s RetStr=..RetErrorValue(RetStr,"属性不能为空")
 	i RetStr'="" q RetStr
	i ItemId'=""
 	{
	 	s objItemsStructure=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentItems")
		s objItemsPersistent=##class(websys.ComponentItems).%OpenId(ComponentId_"||"_ItemId)
 	}
 	elseif TableItemId'=""
 	{
	 	s objItemsStructure=##Class(%Dictionary.CompiledClass).%OpenId("websys.ComponentTableItems")
		s objItemsPersistent=##class(websys.ComponentTableItems).%OpenId(ComponentId_"||"_TableItemId)
	}			
	s cnt=objItemsStructure.Properties.Count()
	s Flag=0
	for i=1:1:cnt
	{
		s PropertyName=objItemsStructure.Properties.GetAt(i).Name
		i PropertyName=properties s Flag=1
		q:Flag=1
		/*
		s mValue=$ZOBJPROPERTY(objItemsPersistent,PropertyName)
        i PropertyName=properties d
        .s mValue=value
        .s ^CacheTemp(PropertyName)=mValue
		.s aCmdLetValue="objItemsPersistent."_PropertyName_"="_"$g(^CacheTemp(PropertyName))"
		.s @aCmdLetValue*/
	}
	i Flag=0 s RetStr=..RetErrorValue(RetStr,"属性"_properties_"不存在")
	i RetStr'="" q RetStr
	
 	i ChangeType'="Test"
 	{
		i properties="Name" s objItemsPersistent.Name=value
		i properties="Caption" s objItemsPersistent.Caption=value
		i properties="DisplayType"
		{
			i value="" q ..RetErrorValue(RetStr,"属性"_properties_"的值不能为空")
			s value=$case(value,"TEXTBOX":"T","LISTBOX":"L","CHECKBOX":"C","TEXTAREA":"TA","LINK":"A","BUTTON":"B","CUSTOM":"S")
			s objItemsPersistent.DisplayType=value
		}
		i properties="DataType" s objItemsPersistent.DataType=value
		i properties="Hidden" 
		{
			s value=$$ALPHAUP^SSUTIL4(value)
			s value=$case(value,"YES":"1","TRUE":1,"1":1,"":0,"NO":0,"FALSE":0,"0":0)
			s objItemsPersistent.Hidden=value
		}
		i properties="DisplayOnly" 
		{
			s value=$$ALPHAUP^SSUTIL4(value)
			s value=$case(value,"YES":"1","TRUE":1,"1":1,"":0,"NO":0,"FALSE":0,"0":0)
			s objItemsPersistent.DisplayOnly=value
		}
		i properties="Disabled" s objItemsPersistent.Disabled=value
		i properties="DisplayOnly" 
		{
			s value=$$ALPHAUP^SSUTIL4(value)
			s value=$case(value,"YES":"1","TRUE":1,"1":1,"":0,"NO":0,"FALSE":0,"0":0)
			s objItemsPersistent.Disabled=value
		}
		i properties="Image" s objItemsPersistent.Image=value
		i properties="ValueGet" s objItemsPersistent.ValueGet=value
		i properties="ValueSet" s objItemsPersistent.ValueSet=value
		i properties="Style" s objItemsPersistent.Style=value
		i properties="CaptionStyle" s objItemsPersistent.CaptionStyle=value
		i properties="ClassMethod" s objItemsPersistent.ClassMethod=value
		i properties="ShowInNewWindow" s objItemsPersistent.ShowInNewWindow=value
		i properties="CustomExpression" s objItemsPersistent.CustomExpression=value
		i properties="LinkUrl" s objItemsPersistent.LinkUrl=value
		i properties="LinkComponent" s objItemsPersistent.LinkComponent=value
		i properties="LinkExpression" s objItemsPersistent.LinkExpression=value
		i properties="LookupClassName" s objItemsPersistent.LookupClassName=value
		i properties="LookupQueryName" s objItemsPersistent.LookupQueryName=value
		i properties="LookupProperties" s objItemsPersistent.LookupProperties=value
		i properties="LookupJavascriptFunction" s objItemsPersistent.LookupJavascriptFunction=value
		
	 	s sc=objItemsPersistent.%Save()
		i $$$ISERR(sc)  d
		.;d $System.Status.DisplayError(sc)
		.s RetStr= "更新组件"_component_"元素"_ItemName_"属性"_properties_"失败"_sc
		i RetStr'=""	q RetStr
 	}
 	q:RetStr="" "OK"
	q RetStr
}

/// Author:add by czf 20180826
/// Description:HISUI改造:更新组件Message
/// Input:ChangeType:Test:数据测试;
/// Command:d ##Class(web.DHCEQImportData2CSP).UpdCompMeassage("","")
ClassMethod UpdCompMeassage(ChangeType As %String = "", RowStr As %String = "")
{
	s del="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
 	s Component=$Piece(RowStr,del,1)
 	s Component=$tr(Component," ","")
 	s MessageCode=$Piece(RowStr,del,2)
 	s Desc=$Piece(RowStr,del,3)
 	s Type=$Piece(RowStr,del,4)
 	s Type=$case(Type,"新增":1,"更新":2,"删除":3,"":"")
 	
 	s Component=$$ALPHAUP^SSUTIL4(Component)
 	i Component="" s RetStr=..RetErrorValue(RetStr,"组件名称不能为空")
 	e  d
 	.s ComponentId=""
 	.i $d(^websys.ComponentI("UniqueNameIndex",Component))'=0  d
	..s ComponentId=""
	..s ComponentId=$o(^websys.ComponentI("UniqueNameIndex",Component,ComponentId))
 	.i ComponentId="" s RetStr=..RetErrorValue(RetStr,"组件不存在")
 	
 	i Type="" q ..RetErrorValue(RetStr,"Type不能为空")
	s MessageId=""
 	i (Type=2)||(Type=3) d
 	.i MessageCode="" s RetStr=..RetErrorValue(RetStr,"Code不能为空")
	.e  d
	..&SQL(SELECT ID INTO :MessageId FROM websys.ComponentMessages Where (ParRef=:ComponentId AND Code=:MessageCode))
	.i MessageId="" s RetStr=..RetErrorValue(RetStr,"Code不存在")
 	e  i Type=1 d
 	.s Childsub=""
 	.f  s Childsub=$o(^websys.ComponentD(ComponentId,"Messages",Childsub)) q:Childsub=""  d
 	..s message=##class(websys.ComponentMessages).%OpenId(ComponentId_"||"_Childsub)
 	..i message.Code=MessageCode s RetStr=..RetErrorValue(RetStr,"Code"_MessageCode_"已经存在,不能新增")
 	..q:RetStr'=""
 	i RetStr'="" q RetStr
 	
 	i ChangeType'="Test"
 	{
	 	i (Type=1)||(Type=2)
	 	{	
	 		s objComp=##class(websys.Component).%OpenId(ComponentId)
		 	i Type=1 d	;新增
		 	.s message=##class(websys.ComponentMessages).%New()
		 	.s message.Code=MessageCode
		 	.s message.Description=Desc
			i Type=2 d	;更新
			.s message=##class(websys.ComponentMessages).%OpenId(MessageId)
			.s message.Description=Desc
		 	s message.ParRef=objComp
			s sc=objComp.%Save()
			i $$$ISERR(sc)  d
			.;d $System.Status.DisplayError(sc)
			.s RetStr=..RetErrorValue(RetStr,"更新组件"_Component_" Code:"_ MessageCode_"失败"_sc)
			i RetStr'="" q RetStr
	 	}
		elseif Type=3 	;删除
		{
			&SQL(Delete websys.ComponentMessages where ID=:MessageId)
			i SQLCODE=100 s SQLCODE=0
			i SQLCODE q ..RetErrorValue(RetStr,"删除组件"_ Component_" Code:"_ MessageCode_"失败"_sc)
		}
 	}
 	q:RetStr="" "OK"
	q RetStr
}

/// Author:add by czf 20180826
/// Description:HISUI改造:更新菜单
/// Input:ChangeType:Test:数据测试;
/// Command:d ##Class(web.DHCEQImportData2CSP).UpdateMenu("","")
ClassMethod UpdateMenu(ChangeType As %String = "", RowStr As %String = "")
{
	s del="^",RetStr=""
	//s RowStr=$tr(RowStr," ","")
 	s menuname=$Piece(RowStr,del,1)
 	s menuname=$tr(menuname," ","")
 	s menucaption=$Piece(RowStr,del,2)
 	s properties=$Piece(RowStr,del,3)
 	s value=$Piece(RowStr,del,4)
 	s value=$tr(value,"~","^")
 	
	s menuid=""
	i menuname="" s RetStr=..RetErrorValue(RetStr,"菜单名称不能为空")
	e  d
	.&SQL(SELECT id into :menuid FROM websys.Menu WHERE Name=:menuname)
	.i menuid="" s RetStr=..RetErrorValue(RetStr,"菜单名称"_menuname_"不存在")
	
	i properties="" s RetStr=..RetErrorValue(RetStr,"属性不能为空")
	e  d
	.s objMenuStructure=##Class(%Dictionary.CompiledClass).%OpenId("websys.Menu")
	.s cnt=objMenuStructure.Properties.Count()
	.s Flag=0
	.f i=1:1:cnt d
	..s PropertyName=objMenuStructure.Properties.GetAt(i).Name
	..i PropertyName=properties s Flag=1
	..q:Flag=1
	.i Flag=0 s RetStr=..RetErrorValue(RetStr,"菜单"_menuname_"属性"_properties_"不存在")
	i RetStr'="" q RetStr
	
	i ChangeType'="Test"
	{
		s menu=##class(websys.Menu).%OpenId(menuid)
		i properties="LinkComponent" s menu.LinkComponent=value
		i properties="LinkUrl" s menu.LinkUrl=value
		i properties="ValueExpression" s menu.ValueExpression=value
		s sc=menu.%Save()
		i $$$ISERR(sc)  d
		.;d $System.Status.DisplayError(sc)
		.s RetStr=..RetErrorValue(RetStr,"更新菜单"_menuname_"属性"_properties_"失败"_sc)
		i RetStr'="" q RetStr
	}
 	q:RetStr="" "OK"
	q RetStr
}

/// Creator:add by czf 20190126
/// Description:批量数据调账,不关联附件
/// Input:ChangeType:Test:数据测试;
/// Command:d ##Class(web.DHCEQImportData2CSP).SetGroupMenusByName("","")
ClassMethod ChangeAccount(ChangeType As %String = "", RowStr As %String = "")
{
	s del="^",RetStr=""
 	s Name=$Piece(RowStr,del,1)					;名称
 	s No=$Piece(RowStr,del,2)					;编号
 	s OriginalFee=$Piece(RowStr,del,3)			;原值
 	s DepreTotalFee=$Piece(RowStr,del,4)		;累计折旧
 	s ChangeFee=$Piece(RowStr,del,5)			;调整金额
 	s ChangeTotalFee=$Piece(RowStr,del,6)		;调整累计折旧
	s ChangeMonth=$Piece(RowStr,del,7)			;调整月份
	s Reason=$Piece(RowStr,del,8)				;调整原因
	s ChangeDate=$Piece(RowStr,del,9)			;调整日期
	s FundsInfo=$Piece(RowStr,del,10)			;调整至资金来源
	s ISByFundsRate=$Piece(RowStr,del,11)		;资金来源累计折旧是否按比例调整
	s ChangedFundsDepreTotal=$Piece(RowStr,del,12)	;资金来源累计折旧
	
	i Name="" s RetStr=..RetErrorValue(RetStr,"设备名称不能为空")
 	i OriginalFee="" s RetStr=..RetErrorValue(RetStr,"原值不能为空")
 	i FundsInfo="" s RetStr=..RetErrorValue(RetStr,"资金来源不能为空")
 	i (ISByFundsRate="N")&(ChangedFundsDepreTotal="") s RetStr=..RetErrorValue(RetStr,"资金来源累计折旧不能为空")
 	
	s EQID=""
	i No'="" d
	.&SQL(Select EQ_RowID into :EQID From SQLUSER.DHC_EQEquip Where EQ_No=:No)
	.i EQID="" s RetStr=..RetErrorValue(RetStr,"编号"_No_"不存在!")
	.e  d
	..s EQStatus=$p($g(^DHCEQEquip(EQID)),"^",38)
	..i EQStatus=3 s RetStr=..RetErrorValue(RetStr,Name_"已报废,无法调账")
	e  d
	.s RetStr=..RetErrorValue(RetStr,"编号不能为空!")
	i RetStr'="" q RetStr
	
	s EQOriginalFee=$p(^DHCEQEquip(EQID),"^",27)
	i OriginalFee'=EQOriginalFee d
	.s RetStr=..RetErrorValue(RetStr,Name_"原值不正确:"_EQOriginalFee)
	
	s EQDepreTotalFee=$p(^DHCEQEquip(EQID),"^",35)
	i EQDepreTotalFee="" s EQDepreTotalFee=0
	i DepreTotalFee'=EQDepreTotalFee d
	.s RetStr=..RetErrorValue(RetStr,Name_"累计折旧不正确:"_EQDepreTotalFee)
	
 	s ChangedOriginalFee=OriginalFee+ChangeFee				;调后原值
 	i ChangedOriginalFee<0 s RetStr=..RetErrorValue(RetStr,Name_"调后原值不能小于0"_ChangedOriginalFee)
 	s ChangedDepreTotalFee=DepreTotalFee+ChangeTotalFee		;调后累计折旧
 	i ChangedDepreTotalFee<0 s RetStr=..RetErrorValue(RetStr,Name_"调后累计折旧不能小于0"_ChangedDepreTotalFee)
 	
 	;检测资金来源是否存在以及总金额是否等于调后原值
 	s Return=..CheckFundsInfo(FundsInfo,0,ChangedOriginalFee)
 	i Return'="" s RetStr=..RetErrorValue(RetStr,Return)
 	;检测资金来源累计折旧是否存在以及总金额是否等于调后累计折旧
 	i ChangedFundsDepreTotal'="" d
 	.s Return=..CheckFundsInfo(ChangedFundsDepreTotal,1,,ChangedDepreTotalFee)
	.i Return'="" s RetStr=..RetErrorValue(RetStr,Return)
	s ChangedNetFee=ChangedOriginalFee-ChangedDepreTotalFee
 	;变动后净值不能小于变动后净残值
 	s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")
 	i ##Class(web.DHCEQCommon).FormatNumber(ChangedNetFee,"",2)<##Class(web.DHCEQCommon).FormatNumber(ChangedOriginalFee*RemainFeeRate/100,"",2) d
 	.s RetStr=..RetErrorValue(RetStr,Name_"调后净值不能小于净残值")
 	i RetStr'="" q RetStr
 	
 	s val="",changefundsinfo=""
 	s FTRowID=0
	f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:(FTRowID="")  d
 	.s FTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",4)
 	.q:FTInvalidFlag="Y"
 	.s (TPreFundsFee,TPreDepreTotalFee,AfterFundsFee,AfterDepreTotal,changefundsfee,changefundsdepre)=0
 	.s FRowID=$o(^DHCEQFunds("0","EquipType",EQID,FTRowID,0))
 	.i FRowID'=""  d
 	..s TPreFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
	..s TPreDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)
 	..d GetChangeFundsInfo
 	.e  d
 	..d GetChangeFundsInfo
 	.i AfterDepreTotal>AfterFundsFee s RetStr=..RetErrorValue(RetStr,Name_"变动资金来源后累计折旧不能大于资金来源金额")
	.s changefundsfee=AfterFundsFee-TPreFundsFee
	.s changefundsdepre=AfterDepreTotal-TPreDepreTotalFee
	.i (ChangeFee>0)&&(changefundsfee<0) s RetStr=..RetErrorValue(RetStr,Name_"变动金额大于0时,资金来源变动应该大于或等于0")
	.i (ChangeFee<0)&&(changefundsfee>0) s RetStr=..RetErrorValue(RetStr,Name_"变动金额小于0时,资金来源变动应该小于或等于0")
	.i (ChangeTotalFee>0)&&(changefundsdepre<0) s RetStr=..RetErrorValue(RetStr,Name_"变动累计折旧大于0时,资金来源累计折旧变动应该大于或等于0")
	.i (ChangeTotalFee<0)&&(changefundsdepre>0) s RetStr=..RetErrorValue(RetStr,Name_"变动累计折旧小于0时,资金来源累计折旧变动应该小于或等于0")
	.q:RetStr'=""
	.q:(changefundsfee=0)&(TPreDepreTotalFee=0)&(changefundsdepre=0)&(TPreFundsFee=0)
	.s val="^"_FTRowID_"^"_changefundsfee_"^^^"_TPreDepreTotalFee_"^^^^^"_changefundsdepre_"^"_TPreFundsFee
	.i changefundsinfo="" s changefundsinfo=val
	.e  s changefundsinfo=changefundsinfo_"||"_val
 	i RetStr'="" q RetStr
 	;s ^CZF("c")=changefundsinfo
 	i ChangeType'="Test"
	{
		k PLIST
		
	 	s PLIST(2) = EQID
	 	s PLIST(3) = ChangeFee
	 	s PLIST(4) = ChangedOriginalFee
	 	s PLIST(5) = ChangedNetFee
	 	s PLIST(6) = ChangedDepreTotalFee
	 	s PLIST(9) = Reason
	 	i ChangeDate'=""  s PLIST(10) = $zdh(ChangeDate,3)	;ChangeDate
	 	e  s PLIST(10) =+$h
	 	;s PLIST(11) = $p(val,"^",11)	;Remark
	 	s PLIST(12) = 0					;Status
	 	s PLIST(13) = 1
		s PLIST(14) = +$H
		s PLIST(15) = $P($H,",",2)
	 	s PLIST(25) = OriginalFee
	 	s PLIST(26) = $p(^DHCEQEquip(EQID),"^",28)	;NetFee
	 	s PLIST(27) = $p(^DHCEQEquip(EQID),"^",29)	;NetRemainFee
	 	s PLIST(29) = $p(^DHCEQEquip(EQID),"^",67)	;StoreLocDR
	 	s PLIST(30) = $p(^DHCEQEquip(EQID),"^",19)	;UseLocDR
	 	s PLIST(31) = $p(^DHCEQEquip(EQID),"^",63)	;EquipTypeDR
	 	s PLIST(32) = $p(^DHCEQEquip(EQID),"^",75)	;StatCatDR
	 	s PLIST(34) = ChangeTotalFee		;调整累计折旧
	 	s PLIST(35) = ChangeMonth			;调整月份
	 	
	 	Set $ZT="ERRORAudit"
		TSTART
		;保存调账单
		&SQL(Select CA_RowID from SQLUSER.DHC_EQChangeAccount Where CA_EquipDR=:PLIST(2) and CA_Status<2)
		if (%ROWCOUNT>0)  s RetStr=..RetErrorValue(RetStr,Name_"尚有调账记录未审核,不能新增") 
		if RetStr q RetStr 
		&SQL(Insert Into SQLUSER.DHC_EQChangeAccount Values :PLIST())
		if SQLCODE
		{
			TROLLBACK
			q ..RetErrorValue(RetStr,Name_"插入调账单失败:"_SQLCODE)
		}
		Set CAID=$g(%ROWID)
		
		;保存资金来源调账信息
		s ListCount=$L(changefundsinfo,"||")
		s (ReturnID,flag)=0
		for i=1:1:ListCount
		{
			s List=$p(changefundsinfo,"||",i)
			s ReturnID=##Class(web.DHCEQFunds).UpdateFunds(7,CAID,List)
			i ReturnID<0 s flag=1
		}
		i flag'=0
		{
			TRollBack
			q ..RetErrorValue(RetStr,Name_"插入资金来源失败:"_ReturnID)
		}
		;执行调账单
		/*if ($p($g(^DHCEQChangeAccount(CAID)),"^",11)=2)
	 	{
		 	;s RetStr=..RetErrorValue(RetStr,Name_"调账单已审核"_CAID)
		 	TRollback
		 	q ..RetErrorValue(RetStr,Name_"该调账单已审核")
	 	}*/
	 	s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(7,CAID,ChangeFee)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q ..RetErrorValue(RetStr,Name_"更新资金来源失败:"_SQLCODE)
	 	}
	 	
	 	k PLISTMX
	 	s PLISTMX(15)="1"			;SourceType
	 	s PLISTMX(16)=EQID			;SourceID
	 	s PLISTMX(2)=EQID
	 	s PLISTMX(7)="0"
	 	s PLISTMX(8)=1
		s PLISTMX(9)=+$h
		s PLISTMX(10)=$p($h,",",2)
		s PLISTMX(11)="N"
		
		;更新设备资金来源表
		s CAFundsRowID=0
		f  s CAFundsRowID=$o(^DHCEQFunds("0","Source","7",CAID,CAFundsRowID))  q:((CAFundsRowID="")||(SQLCODE'=0))  d
		.q:$p($g(^DHCEQFunds(CAFundsRowID)),"^",10)="Y"
		.s FTypeDR=$p($g(^DHCEQFunds(CAFundsRowID)),"^",2)	;FundsType
		.s PLISTMX(3)=FTypeDR
		.s TFundsInfo=##Class(web.DHCEQFunds).GetSourceFunds("1",EQID,EQOriginalFee,FTypeDR)
		.s TFundsRowID=$p(TFundsInfo,"^",2)
		.s TFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",3)				;调整的资金来源
		.s TDepreTotalFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",13)	;调整的累计折旧
		.i TFundsRowID'=""  d
		..s TFee=+TFundsInfo+TFee									;调后资金来源
		..s TDepreTotalFee=+$Piece(TFundsInfo,"^",4)+TDepreTotalFee		;调后累计折旧
		.i TFee<0 s SQLCODE=-3001
		.q:SQLCODE'=0
		.s PLISTMX(4)=TFee
		.s PLISTMX(14)=TDepreTotalFee		
		.
		.i TFundsRowID'=""  d
		..&SQL(Update SQLUSER.DHC_EQFunds Values :PLISTMX() where F_RowID = :TFundsRowID)
		.e  d
		..&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLISTMX())
	 	if SQLCODE 
	 	{
		 	TRollback
		 	q ..RetErrorValue(RetStr,Name_"更新设备资金来源失败:"_SQLCODE)
	 	}
	 	
	 	;更新调账表
	 	s CADepreTotal=+$Piece($Get(^DHCEQChangeAccount(CAID)),"^",33)	;CA_Hold2
	 	s OriginalFee=$p($g(^DHCEQEquip(EQID)),"^",27)
	 	s NetFee=$p($g(^DHCEQEquip(EQID)),"^",28)
	 	s EQDepreTotalFee=+$Piece($Get(^DHCEQEquip(EQID)),"^",35)
	 	s EQStatus=$p($g(^DHCEQEquip(EQID)),"^",38)
	 	s OriginalFee=OriginalFee+ChangeFee
	 	s NetFee=NetFee+ChangeFee
	 	s NetRemainFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*RemainFeeRate/100,"",2)
	 	i NetFee<0 s NetFee=0
	 	s DepreTotal=OriginalFee-NetFee
	 	If CADepreTotal'=0
	 	{
	 		Set DepreTotal=OriginalFee-NetFee+CADepreTotal
	 		Set NetFee=NetFee-CADepreTotal
	 	}
	 	s Curdate=+$h
	 	s Curtime=$p($h,",",2)
	 	&SQL(Update SQLUSER.DHC_EQChangeAccount set CA_Status=2,CA_AuditUserDR=1,CA_AuditDate=+:Curdate,CA_AuditTime=:Curtime,CA_Hold1=:EQStatus where CA_RowID = :CAID)
	 	if SQLCODE 
	 	{
		 	TRollback
		 	q ..RetErrorValue(RetStr,Name_"更新调账表失败:"_SQLCODE)
	 	}
	 	
	 	;更新生命周期表
	 	s LI(2)=EQID  //设备
		s LI(4)=$p($g(^DHCEQEquip(EQID)),"^",19)   //原使用科室
		s LI(5)=$p($g(^DHCEQEquip(EQID)),"^",17) //原管理科室
		s LI(6)=$p($g(^DHCEQEquip(EQID)),"^",67)  //原库房
		s LI(7)=$p($g(^DHCEQEquip(EQID)),"^",27)  //原值
		s LI(8)=$p($g(^DHCEQEquip(EQID)),"^",28)  //原净值
		s LI(14)=$p($g(^DHCEQChangeAccount(CAID)),"^",8)  //变动原因
		s LI(15)=$p($g(^DHCEQChangeAccount(CAID)),"^",6)  //变动描述
		s LI(16)=+$H			//变动日期
		s LI(17)=$p($h,",",2)	//变动时间
		s LI(19)="C"			//生命周期类型
		s LI(20)=51				//来源类型
		s LI(21)=CAID			//来源ID
		s LI(23)=$p($g(^DHCEQChangeAccount(CAID)),"^",10)  //备注
		s LI(27)=1				//更新人
		s LI(28)=+$H			//更新日期
		s LI(29)=$p($h,",",2)	//更新时间
		
		;更新DHCEQEquip表
	 	&SQL(Update SQLUSER.DHC_EQEquip set EQ_NetFee=:NetFee,EQ_OriginalFee=:OriginalFee,EQ_NetRemainFee=:NetRemainFee,EQ_DepreTotalFee=:DepreTotal where EQ_RowID = :EQID)
	 	if SQLCODE 
	 	{
		 	TRollback
		 	q ..RetErrorValue(RetStr,Name_"更新台账失败:"_SQLCODE)
	 	}
		s LI(9)=$p($g(^DHCEQEquip(EQID)),"^",19)   	//变动后使用科室
		s LI(10)=$p($g(^DHCEQEquip(EQID)),"^",17) 	//变动后管理科室
		s LI(11)=$p($g(^DHCEQEquip(EQID)),"^",67)  	//变动后库房
		s LI(12)=$p($g(^DHCEQEquip(EQID)),"^",27)  	//变动后原值
		s LI(13)=$p($g(^DHCEQEquip(EQID)),"^",28)  	//变动后净值
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		if SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,Name_"更新生命周期失败:"_SQLCODE)
		}
		;更新DHCEQDepreSet表
		s DepreSetID=$Order(^DHCEQDepreSet(0,"Source",1,0,EQID,0))
		i DepreSetID'="" d
		.s DSDepreTotalFee=CADepreTotal+$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",23)
		.&SQL(update sqluser.DHC_EQDepreSet set DS_DepreTotalFee=:DSDepreTotalFee where DS_RowID=:DepreSetID)
	 	.i SQLCODE=100 s SQLCODE=0
	 	if SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,Name_"更新DepreSet失败:"_SQLCODE)
		}
		;更新DHC_EQBillInfo表
	 	s SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(7,CAID)
	 	if SQLCODE
		{
			TRollBack
			Quit ..RetErrorValue(RetStr,Name_"更新DHC_EQBillInfo失败:"_SQLCODE)
		}
	 	TCommit
	 	q "OK"
ERRORAudit
		TRollBack	
		Set ErrorMsg=$ZE	//得到系统返回的错误消息
		q "调账失败"		;操作失败
	}
	q:RetStr="" "OK"
	q RetStr
	
GetChangeFundsInfo
 	s fundscount=$l(FundsInfo,",")
	f i=1:1:fundscount  d
	.s curfunds=$p(FundsInfo,",",i)
	.s fundstype=$p(curfunds,"=",1)
	.s fundstypeid=##Class(web.DHCEQImportDataTool).GetFundsType(fundstype)
	.q:fundstypeid'=FTRowID
	.s AfterFundsFee=+$p(curfunds,"=",2)		;变动后资金来源
	.i (ISByFundsRate="Y") d		;按资金来源比例调整资金来源累计折旧
	..i ChangedOriginalFee=0 s TFDepre=0
	..e  s TFDepre=AfterFundsFee*ChangedDepreTotalFee/ChangedOriginalFee
	..s TFDepre=##Class(web.DHCEQCommon).FormatNumber(TFDepre,"",2)
	..s ChangedFundsDepreTotal=fundstype_"="_TFDepre
	.s fundsdeprelen=$l(ChangedFundsDepreTotal,",")
	.f j=1:1:fundsdeprelen d
	..s curfundsdepre=$p(ChangedFundsDepreTotal,",",j)
	..s deprefundstype=$p(curfundsdepre,"=",1)
	..s deprefundtypeid=##Class(web.DHCEQImportDataTool).GetFundsType(deprefundstype)
	..q:deprefundtypeid'=FTRowID
	..s AfterDepreTotal=$p(curfundsdepre,"=",2)		;变动后资金来源累计折旧
	
	quit
}

/// Creator:add by czf 20190126
/// Description:批量数据调账
/// Input:ChangeType:Test:数据测试;
/// Command:d ##Class(web.DHCEQImportData2CSP).SetGroupMenusByName("","")
ClassMethod CheckFundsInfo(FundsInfo As %String = "", Type As %String = "", originalfee As %String = "", depretotalfee As %String = "")
{
	s errDesc=""
	s Amount=0
	s fundscount=$l(FundsInfo,",")
	f i=1:1:fundscount  d
	.s curfunds=$p(FundsInfo,",",i)
	.s fundstype=$p(curfunds,"=",1)
	.s fundsamount=$p(curfunds,"=",2)
	.i fundsamount<0 d
	..i Type=0 s errDesc=..RetErrorValue(errDesc,"变动后资金来源不能小于0:"_fundsamount)
	..i Type=1 s errDesc=..RetErrorValue(errDesc,"变动后资金来源累计折旧不能小于0:"_fundsamount)
	.;q:errDesc'=""
	.s Amount=Amount+fundsamount
	.i fundstype'=""  d
	..s fundsid=##Class(web.DHCEQImportDataTool).GetFundsType(fundstype)
	..i fundsid=""  d
	...s errDesc=..RetErrorValue(errDesc,"没有找到该资金来源:"_fundstype)
	.e  d
	..s errDesc=..RetErrorValue(errDesc,"资金来源不能为空")
	i (Type=0)&((+Amount)'=(+originalfee))  d
	.s errDesc=..RetErrorValue(errDesc,"设备资金来源总金额不等于原值,资金来源总额="_Amount)
	i (Type=1)&((+Amount)'=(+depretotalfee))  d
	.s errDesc=..RetErrorValue(errDesc,"设备资金来源累计折旧不等于设备累计折旧,资金来源总累计折旧="_Amount)
	
	q errDesc
}

/// modfied by ZY0301 20220523 增加旧ID处理
/// add by zx 2019-06-01 
/// 导入his科室到DHC_EQCDepartment表
ClassMethod InsertDepartment(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//2010-10-13 Add By DJ 设备专用供应商表导入数据
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCDepartment")
	q:ChangeType="Clear" "数据已清:科室(DHC_EQCDepartment)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s OldRowID=$p(RowStr,del,1) //编码
 	s code=$p(RowStr,del,2) //编码
 	s desc=$p(RowStr,del,3) //名称
 	i code="" s code=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")
 	s LeaderUserDR=$p(RowStr,del,4) 
 	s ContactsUserDR=$p(RowStr,del,5) 
 	s OrganizeType=$p(RowStr,del,6) 
 	s OrganizeID=$p(RowStr,del,7) 
 	s DeptType=$p(RowStr,del,8) 
 	s ExType=$p(RowStr,del,9)
 	s ExID=$p(RowStr,del,10)
 	s ExDesc=$p(RowStr,del,11)	
 	s ActiveFlag=$p(RowStr,del,12)	
 	s InvalidFlag=$p(RowStr,del,13)	
 	//i ExID'="" s ^DHCEQCCode("DHCEQCDepartment",0)=ExID-1
 	i OldRowID'="" s ^DHCEQCCode("DHCEQCDepartment",0)=OldRowID-1
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCDepartment:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCDepartment:")
 	if RetStr'="" q RetStr
 	
	s tmpid=""
	&SQL(Select Dept_ExType into :tmpid from SQLUSER.DHC_EQCDepartment where Dept_ExDesc=:desc)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCDepartment(Dept_Code,Dept_Desc,Dept_LeaderUserDR,Dept_ContactsUserDR,Dept_OrganizeType,Dept_OrganizeID,Dept_DeptType,Dept_ExType,Dept_ExID,Dept_ExDesc,Dept_ActiveFlag,Dept_InvalidFlag) values (:code,:desc,:LeaderUserDR,:ContactsUserDR,:OrganizeType,:OrganizeID,:DeptType,:ExType,:ExID,:ExDesc,:ActiveFlag,:InvalidFlag))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Name="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCDepartment:"_desc)
 	 	
 	q:RetStr="" "OK"
	q RetStr
}

/// modfied by ZY0301 20220523 增加旧ID处理
/// add by zx 2019-06-01 
/// 导入his人员到DHC_EQCUser表
ClassMethod InsertUser(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//2010-10-13 Add By DJ 设备专用供应商表导入数据
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCUser")
	q:ChangeType="Clear" "数据已清:科室(DHC_EQCUser)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	// U_LoginName,U_LogoinPassword,U_Code,U_Name,U_DefaultLocDR,U_GroupDR,U_ExType,U_ExID,U_ActiveFlag
	s OldRowID=$p(RowStr,del,1) //编码
 	s LoginName=$p(RowStr,del,2) //编码
 	s LogoinPassword=$p(RowStr,del,3) //名称
 	s Code=$p(RowStr,del,4) 
 	s Name=$p(RowStr,del,5) 
 	i Code="" s Code=##class(web.DHCEQCHanZiEncoding).GetEncoding(Name,4,"","U")
 	s DefaultLocDR=$p(RowStr,del,6) 
 	s GroupDR=$p(RowStr,del,7) 
 	s ExType=$p(RowStr,del,8)
 	s ExID=$p(RowStr,del,9)
 	s ActiveFlag=$p(RowStr,del,10)
 	s OrganizeType=$p(RowStr,del,11)
 	s OrganizeID=$p(RowStr,del,12)
 	//i ExID'="" s ^DHCEQCCode("DHCEQCUser",0)=ExID-1
 	i OldRowID'="" s ^DHCEQCCode("DHCEQCUser",0)=OldRowID-1
 	if LoginName="" s RetStr=..RetErrorValue(RetStr,"工号不能为空DHC_EQCUser:")
 	if LogoinPassword="" s RetStr=..RetErrorValue(RetStr,"密码不能为空DHC_EQCUser:")
 	if Name="" s RetStr=..RetErrorValue(RetStr,"姓名不能为空DHC_EQCUser:")
 	if RetStr'="" q RetStr
 	
	s tmpid=""
	&SQL(Select U_ExType into :tmpid from SQLUSER.DHC_EQCUser where U_LoginName=:LoginName)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCUser(U_LoginName,U_LogoinPassword,U_Code,U_Name,U_DefaultLocDR,U_GroupDR,U_ExType,U_ExID,U_ActiveFlag,U_OrganizeType,U_OrganizeID) values (:LoginName,:LogoinPassword,:Code,:Name,:DefaultLocDR,:GroupDR,:ExType,:ExID,:ActiveFlag,:OrganizeType,:OrganizeID))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Name="_Name_" LoginName="_LoginName_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCUser:"_LoginName)
 	 	
 	q:RetStr="" "OK"
	q RetStr
}

// add by zc0052 20191030 保养项目导入

ClassMethod MaintItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCMaintItem")
	.k ^DHCEQCCode("DHCEQCMaintItemCat")
	q:ChangeType="Clear" "数据已清:保养项(DHC_EQCMaintItem)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s desc=$p(RowStr,del,1),mdesc=$p(RowStr,del,2)
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCMaintItem:")
 	if RetStr'="" q RetStr
 	
 	k PLIST
 	
 	s mdesc=$ZCONVERT(mdesc,"U")
 	s tmpid=""
	s ID=""
	&SQL(Select mic_rowid into :tmpid  from sqluser.DHC_EQCMaintItemCat where mic_desc=:mdesc and MIC_Type='1')
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCMaintItemCat(MIC_Type,MIC_Desc) values ('1',:mdesc))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入保养大项失败DHC_EQCMaintItemCat: Desc="_DHC_EQCMaintItemCat_" SQLCODE="_SQLCODE)
	..e  d
	...s ID=$g(%ROWID)
 	if RetStr'="" q RetStr
 	i tmpid'="" s PLIST(8)=tmpid
	i ID'="" s PLIST(8)=ID

	i (desc'="") s PLIST(3) = desc
	s PLIST(6)=1

    if ChangeType'="Test"  d
    .&SQL(Insert Into SQLUSER.DHC_EQCMaintItem Values :PLIST())
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Desc="_desc_" MDesc="_mdesc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

// add by zc0052 20191030 保养模板导入

// MZY0076	2021-05-25

ClassMethod PMReport(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCPMTemplate")
	.k ^DHCEQCCode("DHCEQCPMTemplateList")
	q:ChangeType="Clear" "数据已清:保养模板名称(DHC_EQCPMTemplate)和保养模板明细(DHC_EQCPMTemplateList)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s name=$p(RowStr,del,1),type=$p(RowStr,del,2),mdesc=$p(RowStr,del,3),desc=$p(RowStr,del,4),sort=$p(RowStr,del,5)
 	Set type=$Piece(type,":",1)
 	k PLIST
 	if name="" s RetStr=..RetErrorValue(RetStr,"报告名称不能为空DHC_EQCPMTemplate:")
 	if type="" s RetStr=..RetErrorValue(RetStr,"报告类型不能为空DHC_EQCPMTemplate:")
 	if mdesc="" s RetStr=..RetErrorValue(RetStr,"保养大项不能为空DHC_EQCPMTemplateList:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"保养项不能为空DHC_EQCPMTemplateList:")

 	if RetStr'="" q RetStr
 	
 	s name=$ZCONVERT(name,"U")
	s tmpid=""
	s ID=""
	&SQL(Select pmt_rowid into :tmpid from SQLUSER.DHC_EQCPMTemplate where pmt_name=:name and PMT_Type=:type and PMT_InvalidFlag<>'Y')
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCPMTemplate(PMT_Type,PMT_Name,PMT_Caption,PMT_InvalidFlag) values (:type,:name,:name,'N'))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入保养模板名称失败DHC_EQCPMTemplate: Name="_name_" SQLCODE="_SQLCODE)
	..e  d
	...s ID=$g(%ROWID)
	i RetStr'="" q RetStr
	i tmpid'="" s PLIST(2)=tmpid
	i ID'="" s PLIST(2)=ID
	
	s maintitemid=""
 	i mdesc'=""  d
	.s maintitemid=##Class(web.DHCEQImportDataTool).GetMaintItemID(desc,mdesc,type)
	.i maintitemid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该保养项: 小项="_desc_" 大项="_mdesc_" 类型:"_type)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置保养项: 小项="_desc_" 大项="_mdesc_" 类型:"_type)
 	if RetStr'="" q RetStr
	
	i maintitemid'="" s PLIST(3)=maintitemid
	s PLIST(5)=sort
	s vtmpid=""
	&SQL(Select pmtl_rowid into :vtmpid from SQLUSER.DHC_EQCPMTemplateList where PMTL_TemplateDR=:PLIST(2) and PMTL_MaintItemDR=:PLIST(3))
	i vtmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCPMTemplateList values  :PLIST())
	..i SQLCODE s RetStr=..RetErrorValue(RetStr,"插入保养模板明细失败DHC_EQCPMTemplateList: Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"保养模板明细已经存在DHC_EQCPMTemplateList: Desc="_desc)
 	q:RetStr="" "OK"
	q RetStr
}

/// Creator:czf	2020-02-20 CZF0054
/// Description:科室分摊设置
ClassMethod LocCostAllot(ChangeType As %String = "", RowStr As %String = "")
{
	SET RowStr=$tr(RowStr," ","")
	Set del="^",RetStr=""
 	Set no=$Piece(RowStr,del,1)
 	Set name=$Piece(RowStr,del,2)
 	Set AllotType=$Piece(RowStr,del,3)	//分摊方式
 	Set AllotType=$case(AllotType,"固定比例":0,"工作量":1,:"")
 	Set AllotLoc=$Piece(RowStr,del,4)	//分摊科室
 	Set AllotRate=$Piece(RowStr,del,5)	//分摊比例
 	Set AllotValue=$Piece(RowStr,del,6)	//分摊值
 	Set Types=$Piece(RowStr,del,7)	//1:折旧 2：维修 3：保养 4：检查 5：其他
 	Set Types=$case(Types,"折旧":1,"维修":2,"保养":3,"检查":4,:5)
 	
 	if no="" Set RetStr=..RetErrorValue(RetStr,"编号不能为空")
 	if name="" Set RetStr=..RetErrorValue(RetStr,"名称不能为空")
	if AllotType="" Set RetStr=..RetErrorValue(RetStr,"分摊方式不能为空")
	if AllotLoc="" Set RetStr=..RetErrorValue(RetStr,"分摊科室不能为空")
	if Types="" Set RetStr=..RetErrorValue(RetStr,"分摊费用类型不能为空")
	i RetStr q RetStr
	
	s EQID=""
	&SQL(Select eq_rowid into :EQID from SQLUSER.DHC_EQEquip where eq_no=:no and EQ_Name=:name)
	i EQID="" q ..RetErrorValue(RetStr,"设备不存在DHC_EQEquip:"_name)
	
	s LocID=""
	i AllotLoc'=""  d
	.s LocID=##Class(web.DHCEQImportDataTool).GetUseLocID(AllotLoc)
	.i LocID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室: 设备="_name_" 科室="_AllotLoc)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有科室: 设备="_name)
	i RetStr q RetStr
	
	s ValList="^"_Types_"^"_EQID_"^"_LocID_"^"_AllotRate_"^"_AllotType_"^"_AllotValue
	if ChangeType'="Test" Do
	.Set ReturnValue=##Class(web.DHCEQCostAllot).SaveData("","",ValList,"")
	.if ReturnValue<0 s RetStr=..RetErrorValue(RetStr,"科室分摊设置失败: 设备="_name_" SQLCODE="_ReturnValue)
	
	q:RetStr="" "OK"
	Quit RetStr
}

/// Add by zx 2020-02-21
/// 属性分类导入
ClassMethod InHospitalType(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCInHospitalType")
	q:ChangeType="Clear" "数据已清:设备属性分类(DHC_EQCInHospitalType)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s type=$p(RowStr,del,1),code=$p(RowStr,del,2),desc=$p(RowStr,del,3)
 	SET code=##Class(web.DHCEQCommon).Trim(code)
 	SET desc=##Class(web.DHCEQCommon).Trim(desc)
 	
 	if type="" s RetStr=..RetErrorValue(RetStr,"属性类型不能为空DHC_EQCInHospitalType:")
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCInHospitalType:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCInHospitalType:")
 	if RetStr'="" q RetStr 	
 	
 	s typecode=""
 	i type'=""  d
	.&SQL(Select EA_Code into :typecode from SQLUSER.DHC_EQCEquipAttribute where EA_Name=:type)
	.i typecode=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备属性: 分类="_desc_" 设备属性="_type)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备属性:  分类="_desc_" 设备属性="_type)
 	if RetStr'="" q RetStr
 	
 	s tmpid=""
	&SQL(Select IHT_RowID into :tmpid from SQLUSER.DHC_EQCInHospitalType where IHT_Code=:code and IHT_Desc=:desc and IHT_Type=:typecode)
	i tmpid=""  d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCInHospitalType(IHT_Code,IHT_Desc,IHT_Type,IHT_InvalidFlag) values (:code,:desc,:typecode,'N'))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Type="_type_" Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCInHospitalType:"_desc)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// Creator：      QW
/// CreatDate：   20190410
/// Description:   BUG:QW0027   核算项目导入
/// Table：        DHC_EQCFinaceItem
ClassMethod FinaceItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" Kill ^DHCEQCCode("DHCEQCFinaceItem")
	Quit:ChangeType="Clear" "数据已清:核算项目(DHC_EQCFinaceItem)"
	
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set code=$Piece(RowStr,del,1),desc=$Piece(RowStr,del,2)
 	Set flag=$Piece(RowStr,del,3),fundsype=$Piece(RowStr,del,4)
 	if code="" Set RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCFinaceItem:")
 	if desc="" Set RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCFinaceItem:")
 	if RetStr'="" Quit RetStr
 	
 	Set desc=$ZCONVERT(desc,"U")	
	Set tmpid=""
	&SQL(Select FI_rowid into :tmpid from SQLUSER.DHC_EQCFinaceItem where FI_desc=:desc)
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Insert into SQLUSER.DHC_EQCFinaceItem(FI_code,FI_desc,FI_invalidflag,FI_Hold1,FI_Hold2) values (:code,:desc,'N',:flag,:fundsype))
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCFinaceItem:"_desc)
 	 	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Creator：      QW
/// CreatDate：   20190410
/// Description:   BUG:QW0027 功能分类导入
/// Table：        DHC_EQCFunctionCat
ClassMethod FunctionCat(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" Kill ^DHCEQCCode("DHCEQCFunctionCat")
	Quit:ChangeType="Clear" "数据已清:功能分类(DHC_EQCFunctionCat)"
	
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set code=$Piece(RowStr,del,1),desc=$Piece(RowStr,del,2)
 	if code="" Set RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCFunctionCat:")
 	if desc="" Set RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCFunctionCat:")
 	if RetStr'="" Quit RetStr
 	
 	Set desc=$ZCONVERT(desc,"U")	
	Set tmpid=""
	&SQL(Select FC_rowid into :tmpid from SQLUSER.DHC_EQCFunctionCat where FC_desc=:desc)
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..&SQL(Insert into SQLUSER.DHC_EQCFunctionCat(FC_code,FC_desc,FC_invalidflag) values (:code,:desc,'N'))
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQCFunctionCat:"_desc)
 	 	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Creator：      QW
/// CreatDate：    20190410 
/// Description:   BUG:QW0027 更新所有设备资金来源中的核算项目及功能分类
/// Table：        DHC_EQFunds
ClassMethod UpdateFunds(ChangeType As %String = "", RowStr As %String = "")
{
	
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set no=$Piece(RowStr,del,1),fundstype=$Piece(RowStr,del,2)
 	Set finaceitem=$Piece(RowStr,del,3),functioncat=$Piece(RowStr,del,4)
 	Set fee=+$Piece(RowStr,del,5)	//,deprefee=$Piece(RowStr,del,6)
 	if no="" Set RetStr=..RetErrorValue(RetStr,"编号不能为空:")
 	if fundstype="" Set RetStr=..RetErrorValue(RetStr,"资金来源不能为空")
 	if finaceitem="" Set RetStr=..RetErrorValue(RetStr,"核算项目不能为空:")
 	//if functioncat="" Set RetStr=..RetErrorValue(RetStr,"功能分类不能为空")
 	if fee="" Set RetStr=..RetErrorValue(fee,"金额不能为空")
 	if RetStr'="" Quit RetStr
 	Set finaceitemid=""
	&SQL(Select FI_RowID into :finaceitemid from SQLUSER.DHC_EQCFinaceItem where FI_code=:finaceitem)
	if finaceitemid="" Set RetStr=..RetErrorValue(RetStr,finaceitem_"核算项目不存在")
 	if RetStr'="" Quit RetStr	
 	//Set functioncatid=""
	//&SQL(Select FC_RowID into :functioncatid from SQLUSER.DHC_EQCFunctionCat where  FC_desc=:functioncat)
	//if functioncatid="" Set RetStr=..RetErrorValue(RetStr,functioncat_"功能分类不存在")
 	//if RetStr'="" Quit RetStr
 	Set fundstypeid=""
	&SQL(Select FT_RowID into :fundstypeid from SQLUSER.DHC_EQCFundsType where  FT_Desc=:fundstype)
	if fundstypeid="" Set RetStr=..RetErrorValue(RetStr,fundstype_"资金来源不存在")
 	if RetStr'="" Quit RetStr
	Set eqid=""
	s eqid=##class(web.DHCEQEquip).GetEquipIDByNo(no)
	if eqid="" Set RetStr=..RetErrorValue(RetStr,no_"设备不存在")
 	if RetStr'="" Quit RetStr
 	s OriginalFee=+$p($g(^DHCEQEquip(eqid)),"^",27)
 	i fee'=OriginalFee Set RetStr=..RetErrorValue(RetStr,no_"设备原值不一样"_fee_","_OriginalFee)
 	if RetStr'="" Quit RetStr
 	
 	Set tmpid=""
 	&SQL(select F_RowID into :tmpid from SQLUSER.DHC_EQFunds where F_SourceType=1 and F_SourceID=:eqid and F_FundsTypeDR=:fundstypeid )
 	i tmpid'="" d
	.if ChangeType'="Test" Do
	..k FTLIST
	..//s FTLIST(14)=$p($g(^DHCEQEquip(eqid)),"^",35)
	..//s FTLIST(14)=deprefee
	..//s FTLIST(15)="1"
	..//s FTLIST(16)=eqid
	..s FTLIST(21)=finaceitemid		
	..s FTLIST(22)=1		//functioncatid
	..&SQL(update SQLUSER.DHC_EQFunds Values :FTLIST() where F_RowID=:tmpid)
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: no="_no_" SQLCODE="_SQLCODE)
 	e  d
 	.Set RetStr=..RetErrorValue(RetStr,no_"设备没有资金来源:"_fundstype)
	i SQLCODE=100 s SQLCODE=0
	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Creator：      lmm
/// CreatDate：    20200319 
/// Description:   新增更新系统配置参数信息
/// Table：        DHC_EQCSysSet
ClassMethod DHCEQCSysSet(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set code=$Piece(RowStr,del,1),desc=$Piece(RowStr,del,2)
 	Set remark=$Piece(RowStr,del,3),hiddenflag=$Piece(RowStr,del,4)
 	Set value=$Piece(RowStr,del,5)    //modify by lmm 2020-04-26 除数值存在其他值
 	if code="" Set RetStr=..RetErrorValue(RetStr,"系统参数不能为空:")
 	if RetStr'="" Quit RetStr
 	Set syssetid=""
	&SQL(Select SS_RowID into :syssetid from SQLUSER.DHC_EQCSysSet where SS_Code=:code)
	
	K FTLIST
	if ChangeType'="Test" Do
	.s FTLIST(3)=value
	.s FTLIST(4)=desc
	.s FTLIST(5)=remark
	.s FTLIST(7)=hiddenflag
	.i syssetid'=""  d
	..&SQL(update SQLUSER.DHC_EQCSysSet Values :FTLIST() where SS_RowID=:syssetid)
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"更新失败: no="_code_" SQLCODE="_SQLCODE)
	.e  d
	..s FTLIST(2)=code
	..&SQL(Insert Into SQLUSER.DHC_EQCSysSet Values :FTLIST())
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"新增失败: no="_code_" SQLCODE="_SQLCODE)
 	
	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

ClassMethod DHCEQImportMenu(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set code=$Piece(RowStr,del,1),desc=$Piece(RowStr,del,2)
 	if code="" Set RetStr=..RetErrorValue(RetStr,"菜单代码不能为空:")
 	if RetStr'="" Quit RetStr
 	if desc="" Set RetStr=..RetErrorValue(RetStr,"菜单名称不能为空:")
 	if RetStr'="" Quit RetStr
 	
	if ChangeType'="Test" Do
	.s SQLCODE=##Class(web.DHCEQComponent).UpdateMenu("8",code)
	.i SQLCODE<0  Set RetStr=..RetErrorValue(RetStr,"更新失败: 菜单="_code)

 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Add By DJ 2020-04-19
ClassMethod DHCEQGroupMenu(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set group=$Piece(RowStr,del,1),menu=$Piece(RowStr,del,2)
 	Set flag=$Piece(RowStr,del,3)
 	
 	if group'=""  d
 	.s vGroupID=""
	.&SQL(Select SSGRP_RowID Into :vGroupID From SQLUSER.SS_Group Where SSGRP_Desc=:group)
	.if vGroupID="" Set RetStr=..RetErrorValue(RetStr,"["_group_"]安全组不存在:")
 	e  d
 	.Set RetStr=..RetErrorValue(RetStr,"安全组不能为空:")
 	
 	if menu'=""  d
 	.s vMenuID=""
	.&SQL(Select ID Into :vMenuID From websys.Menu Where Name=:menu)
	.i vMenuID="" Set RetStr=..RetErrorValue(RetStr,"["_menu_"]菜单不存在:")
 	e  d
 	.Set RetStr=..RetErrorValue(RetStr,"菜单不能为空:")
 	
 	if flag="" Set RetStr=..RetErrorValue(RetStr,"菜单配置取消标志不能为空(0取消1配置):")
 	if RetStr'="" Quit RetStr
 	
	if ChangeType'="Test" Do
	.i ((flag=0)||(flag=1))  d
	..s SQLCODE=##Class(web.DHCEQComponent).SetGroupMenu(vGroupID,vMenuID,flag,"0")
	..i $p(SQLCODE,":",2)'="SetSuccess"  Set RetStr=..RetErrorValue(RetStr,"更新失败: 安全组="_group_" menu="_menu_" SQLCODE="_SQLCODE)

 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Add By CSJ 2020-08-24
/// 描述:ETL工具导入设备台帐
/// modify by 20210420 MWZ0046 修改最新导入的字段顺序及名称
/// 入参：ChangeType :"Test"->测试 ,"Append"->追加
/// w ##class(web.DHCEQImportData2CSP).InsertAll("Test")
ClassMethod InsertAll(ChangeType As %String = "Test")
{
	s t=$p($h,",",2)
	k ^DHCEQTemp("CheckReturnStr")
	s ReturnStr="" 
	s EquipNo=""
	s rowid=0
	f  s rowid=$o(^DHCEQImportData(rowid))  quit:rowid=""  d
	.s DataList=$G(^DHCEQImportData(rowid))
	.s EquipType=$p(DataList,"^",1)
	.s StatCat=$p(DataList,"^",2)
	.s EquipCat=$p(DataList,"^",3)
	.s EquipNo=$p(DataList,"^",4)
	.s EquipName=$p(DataList,"^",5)
	.s Code=$p(DataList,"^",6)
	.s Model=$p(DataList,"^",7)
	.;s Model=##class(web.DHCEQCommon).Replace(Model,"（","(")
	.;s Model=##class(web.DHCEQCommon).Replace(Model,"）",")")
	.s Quantity=$fn($p(DataList,"^",8),"",0)
	.s Unit=$p(DataList,"^",9)
	.s OriginalFee=$fn(##class(web.DHCEQCommon).Replace($p(DataList,"^",10)," ",""),"",2) //add by mwz MWZ0050 2021-06-14
	.s UseLoc=$p(DataList,"^",11)
	.s Status=$p(DataList,"^",12)
	.s InStockDate=$E($p(DataList,"^",13),1,10)
	.s TransAssetDate=$E($p(DataList,"^",14),1,10)
	.s DepreMethod=$p(DataList,"^",15)
	.s LimitYears=$p(DataList,"^",16)
	.s DepreTotalFee=$fn(##class(web.DHCEQCommon).Replace($p(DataList,"^",17)," ",""),"",2)  //add by mwz MWZ0050 2021-06-14
	.s RemainRate=$p(DataList,"^",18)
	.s Provider=$p(DataList,"^",19)
	.s ManuFacturer=$p(DataList,"^",20)
	.s LeaveFactoryNo=$p(DataList,"^",21)
	.s LeaveFactoryDate=$E($p(DataList,"^",22),1,10)
	.s Country=$p(DataList,"^",23)
	.s PurposeType=$p(DataList,"^",24)
	.s Origin=$p(DataList,"^",25)
	.s Manager=$p(DataList,"^",26)
	.s Keeper=$p(DataList,"^",27)
	.s FormToDept=$p(DataList,"^",28)
	.//AccountNo_"^"_OldID_"^"_FundsStr_"^"_BuildingArea_"^"_Brand_"^"_FundsOrigin
	.s Remark=$p(DataList,"^",29)
	.s OldLoc=$p(DataList,"^",30)
	.s DisusedDate=$E($p(DataList,"^",31),1,10)
	.s MemoryCode=$p(DataList,"^",32)
	.s ServiceHandler=$p(DataList,"^",33)
	.s AccountNo=$p(DataList,"^",34)
	.s OldID=$p(DataList,"^",35)
	.s FundsStr=$p(DataList,"^",36)
	.//s FundsStr="自筹资金="_OriginalFee
	.s RegisterNo=$p(DataList,"^",37)    //注册证号 add by mwz0049 2021-05-14
	.s Brand=$p(DataList,"^",38)
	.s Expenditures=$p(DataList,"^",39)	//
	.s PeriodNum=$p(DataList,"^",40)
 	.s CatCode68=$p(DataList,"^",41)		//68码分类——>设备项关联
 	.s FinaceItemCode=$p(DataList,"^",42)	//核算项目编码
 	.s DepreMonthNum=$p(DataList,"^",43)		//已折月数(次数)
 	.s MasterItemName=$p(DataList,"^",44)		//设备项名称  add by mwz0049 2021-05-14
 	.s ManageLoc=$p(DataList,"^",45)   //add by mwz 20220606 MWZ0061  管理部门
	.s parentNo=$p(DataList,"^",46)	//主设备编号
	.s IsConfig=$p(DataList,"^",47)	//是否附属设备 
	.s ImportStr=EquipType_"^"_StatCat_"^"_EquipCat_"^"_EquipNo_"^"_EquipName_"^"_Code_"^"_Model_"^"_Quantity_"^"_Unit_"^"_OriginalFee_"^"_UseLoc_"^"_Status_"^"_InStockDate_"^"_TransAssetDate_"^"_DepreMethod_"^"_LimitYears_"^"_DepreTotalFee_"^"_RemainRate_"^"_Provider_"^"_ManuFacturer_"^"_LeaveFactoryNo_"^"_LeaveFactoryDate_"^"_Country_"^"_PurposeType_"^"_Origin_"^"_Manager_"^"_Keeper_"^"_FormToDept_"^"_Remark_"^"_OldLoc_"^"_DisusedDate_"^"_MemoryCode_"^"_ServiceHandler_"^"_AccountNo_"^"_OldID_"^"_FundsStr_"^"_RegisterNo_"^"_Brand_"^"_Expenditures_"^"_PeriodNum_"^"_CatCode68_"^"_FinaceItemCode_"^"_DepreMonthNum_"^"_MasterItemName_"^"_ManageLoc    //Modify by mwz 20220606 MWZ0061 
	.s ReturnStr=##Class(web.DHCEQImportData2CSP).Equip(ChangeType,ImportStr)
	.i ReturnStr'="OK" s ^DHCEQTemp("CheckReturnStr",rowid)=ReturnStr
	s t=$p($h,",",2)-t
	s ROWID=0 
	f  s ROWID=$o(^DHCEQTemp("CheckReturnStr",ROWID)) quit:ROWID=""  d
	.w !,"第"_ROWID_"行："_$g(^DHCEQTemp("CheckReturnStr",ROWID))
	q "总耗时："_t_"s"
}

// Modify by zx 2020-09-15 功能模块菜单导入

ClassMethod SysMenus(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCSysMenus")
	q:ChangeType="Clear" "数据已清:功能模块菜单(DHCEQCSysMenus)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s moduletype=$p(RowStr,del,1),busstype=$p(RowStr,del,2),code=$p(RowStr,del,3),desc=$p(RowStr,del,4)
 	s menutype=$p(RowStr,del,5),clienttype=$p(RowStr,del,6),image=$p(RowStr,del,7),linkurl=$p(RowStr,del,8),remark=$p(RowStr,del,9)
 	s moduletype=$Case(moduletype,"":"","设备管理":"1","维修管理":"2","效益分析":"3","移动盘点":"4","移动维修":"5")
 	s clienttype=$Case(clienttype,"":"","PC端菜单":"6","移动端菜单":"7") 
 	if moduletype="" s RetStr=..RetErrorValue(RetStr,"模块类型不能为空DHC_EQCSysMenus:")
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCSysMenus:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"描述不能为空DHC_EQCSysMenus:")
 	if menutype="" s RetStr=..RetErrorValue(RetStr,"菜单类型不能为空DHC_EQCSysMenus:")
 	if clienttype="" s RetStr=..RetErrorValue(RetStr,"客户端类型不能为空DHC_EQCSysMenus:")
 	if RetStr'="" q RetStr
 	
	s busstypeid=""
	i busstype'=""  d
	.&SQL(Select BT_RowID into :busstypeid from SQLUSER.DHC_EQCBussType where BT_Desc=:busstype)
	.i busstypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该业务类型: 描述="_desc_" 业务="_busstype)
	if RetStr'="" q RetStr
 	
 	s desc=$ZCONVERT(desc,"U")	
	s tmpid=""
	&SQL(Select M_RowID into :tmpid from SQLUSER.DHC_EQCSysMenus where M_Name=:code and M_MenuType=:menutype)
	i tmpid="" d
	.if ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCSysMenus(M_ModuleType,M_BussTypeDR,M_Name,M_Caption,M_MenuType,M_ClientType,M_Image,M_LinkUrl,M_Remark) values (:moduletype,:busstypeid,:code,:desc,:menutype,:clienttype,:image,:linkurl,:remark))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"代码已经存在DHC_EQCSysMenus:"_code)
 	 	
 	q:RetStr="" "OK"
	q RetStr
}

///  add by csj 2020-09-15 导入维护计划记录
ClassMethod MaintPlan(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s Date=+$H
	s Time=$P($H,",",2)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s MaintLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	IF ChangeType="Clear"  d
	.k ^DHCEQMaintPlan
	.k ^DHCEQMaint
	.k ^DHCEQEquipRange
	.k ^DHCEQEquipRangeList
	q:ChangeType="Clear" "数据已清:维护计划(DHC_EQMaintPlan)"
	s del="^",RetStr=""
	//SET RowStr=$tr(RowStr," ","")
	s RowLen = $l(RowStr,del)
 	s PlanType=$p(RowStr,del,1) //计划类型
 	s MaintType=PlanType	//维护类型
 	s PlanName=$p(RowStr,del,2) //计划名称
 	s EquipRange=$p(RowStr,del,3) //计划范围 设备或设备项
 	s EQName=$p(RowStr,del,4) //设备名称
 	s EQNo=$p(RowStr,del,5) //设备编号
 	s EQEquipType=$p(RowStr,del,6) //设备类组
 	s EQUseLoc=$p(RowStr,del,7)  //使用科室
 	s MeasureDept=$p(RowStr,del,8)	//计量部门
 	s MaintUser=$p(RowStr,del,9)	//负责人
 	s CycleNumDesc=$p(RowStr,del,10)	//维护周期
 	s PreWarnDaysNum=$p(RowStr,del,11)	//提前预警天数
 	s MaintFee=$p(RowStr,del,12)	//单台维护费用	
 	s FromDate=$p(RowStr,del,13)	//计划开始日期
 	
 	i PlanType="" s RetStr=..RetErrorValue(RetStr,"维护类型不能为空")
 	i PlanName="" s RetStr=..RetErrorValue(RetStr,"计划名称不能为空")
 	i EquipRange="" s RetStr=..RetErrorValue(RetStr,"计划范围不能为空")
 	i EQEquipType="" s RetStr=..RetErrorValue(RetStr,"设备类组不能为空")
 	i EQUseLoc="" s RetStr=..RetErrorValue(RetStr,"使用科室不能为空")
 	i CycleNumDesc="" s RetStr=..RetErrorValue(RetStr,"维护周期不能为空")
 	i PreWarnDaysNum="" s RetStr=..RetErrorValue(RetStr,"提前预警天数不能为空")
 	i FromDate="" s RetStr=..RetErrorValue(RetStr,"计划开始日期不能为空")
 	
 	i EQEquipType'=""  d
	.s EQEquipTypeDR=##Class(web.DHCEQImportDataTool).GetEquipTypeID(EQEquipType)
	.i EQEquipTypeDR=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类组: 设备="_EQName_" 设备类组="_EQEquipType)
	
	s tmpid=""
	&SQL(Select mi_rowid into :tmpid from SQLUSER.DHC_EQCMasterItem where mi_desc=:EQName and mi_equiptypeDR=:EQEquipTypeDR)
	i tmpid=""  d 
	.s RetStr = ..RetErrorValue(RetStr,"设备项不存在:"_EQName_"类组:"_EQEquipType)
	e  d
	.s ItemDR = tmpid
	
 	i PlanType'="" d
 	.s PlanTypeDR = $Case(PlanType,"计量":"2","保养":"1","巡检":"2")
 	i EquipRange'="" d
 	.s EquipRange = $Case(EquipRange,"设备":"5","设备项":"6","":"")
	i MaintType'="" d
	.s MaintTypeDR = $Case(MaintType,"计量":"5","保养":"","巡检":"4")
#;	s EQComputerFlag = $Case(EQComputerFlag,"是":"Y","否":"N","":"N")
	s EQMeasureFlag=""
	i (PlanTypeDR=2)&&(MaintTypeDR=5) d
	.s EQMeasureFlag="Y"
	i EQUseLoc'="" d
	.s EQUseLocDR = ##Class(web.DHCEQImportDataTool).GetUseLocID(EQUseLoc)
	.i EQUseLocDR="" d
	..s RetStr=RetErrorValue(RetStr,"未找到使用科室"_EQUseLoc)

	
	s CycleNum = +CycleNumDesc
 	s CycleUnit = $E(CycleNumDesc,$l(+CycleNumDesc)+1,$l(CycleNumDesc))
 	i CycleUnit["年" s CycleUnitDR = "1"
 	e  i CycleUnit["月" s CycleUnitDR = "2"
 	e  s RetStr=..RetErrorValue(RetStr,"维护周期格式错误！")
 	
	i MaintUser'=""  d
	.s tmpid=""
	.&SQL(select U_RowID into:tmpid from sqluser.DHC_EQCUser where U_Name = :MaintUser)
	.i tmpid = "" d
	..s RetStr=..RetErrorValue(RetStr, MaintUser_"负责人不存在")
	.e  s MaintUserDR = tmpid
	
	i MeasureDept'=""  d
	.s tmpid=""
	.&SQL(select MD_RowID into:tmpid from sqluser.DHC_EQCMeasureDept where MD_Name = :MeasureDept)
	.i tmpid = "" d
	..s RetStr=..RetErrorValue(RetStr, MeasureDept_"计量部门不存在")
	.e  s MeasureDeptDR = tmpid
	
 	i RetStr'="" q RetStr
	
	i EquipRange=5 d	;指定设备
	.i (EQNo="")&&(EQEquipType'["简易") d
	..s RetStr=..RetErrorValue(RetStr, EQNo_"指定设备编号不能为空")
	.e  i EQNo'="" d
	..s tmpid=""
	..&SQL(Select EQ_RowID into :tmpid  from sqluser.DHC_EQEquip where EQ_No=:EQNo)
	..i tmpid="" d
	...s RetStr=..RetErrorValue(RetStr, EQNo_"编号设备不存在")
	..e  d
	...s EquipDR = tmpid
	...;s tmpid=""	;是否判断重复
	...;&SQL(select ERL_RowID into:tmpid from SQLUSER.DHC_EQEquipRangeList where ERL_Type=:EquipRange and ERL_Value=:EquipDR)
	...;i tmpid '= ""  d
	...;.s RetStr=..RetErrorValue(RetStr, DHC_EQEquipRangeList_"该设备已存在于计划中")
	...s EquipTypeDR = $p($g(^DHCEQEquip(EquipDR)),"^",63)
	...i EQEquipTypeDR'=EquipTypeDR d
	....s RetStr=..RetErrorValue(RetStr, ModelDR_"设备类组与导入类组不一致")
	...s UseLocDR = $p($g(^DHCEQEquip(EquipDR)),"^",19)
	...i UseLocDR'=EQUseLocDR d
	....s RetStr=..RetErrorValue(RetStr, UseLocDR_"设备使用科室与导入设备使用科室不一致")
	if RetStr'="" q RetStr
	
	/*	;是否判断重复
	i EquipRange=6	d	;指定设备项
	.s tmpid=""
	.&SQL(select ERL_RowID into:tmpid from SQLUSER.DHC_EQEquipRangeList where ERL_Type=:EquipRange and ERL_Value=:ItemDR)
	.i tmpid '= ""  d
	..s RetStr=..RetErrorValue(RetStr, DHC_EQEquipRangeList_"该设备项已存在于计划中")
	if RetStr'="" q RetStr
	*/
 	if ChangeType'="Test"
 	{
		TStart
		//先判断是否有简易台账
		i (EQNo="")&&(EQEquipType["简易")
		{
			k PLIST
			s ItemInfo = ##class("web.DHCEQCMasterItem").GetDocByID("","",ItemDR)
			s Code = $p(ItemInfo,"^",2)
			s StatCatDR = $p(ItemInfo,"^",8)
			s EquipeCatDR = $p(ItemInfo,"^",6)
			s UnitDR = $p(ItemInfo,"^",11)
			s PLIST(2) = EQName	;Name	//2013-06-24 DJ0118
			s PLIST(4) = EQModelDR	;ModelDR
			s PLIST(5) = EquipeCatDR	;EquiCatDR
			s PLIST(6) = UnitDR	;UnitDR
			s PLIST(7) = Code	;Code
			s PLIST(8) = ItemDR	;ItemDR
			s PLIST(11) = EQFactoryNo	;LeaveFactoryNo
#;			s PLIST(16) = EQComputerFlag	;ComputerFlag 
			s PLIST(20) = EQUseLocDR	;UseLocDR
			;s PLIST(26) = $p(val,"^",26)	;ProviderDR
			s PLIST(27) = EQManufacDR	;ManuFactoryDR
			;s PLIST(28) = $p(val,"^",28)	;OriginalFee
			;s PLIST(29) = $p(val,"^",29)	;NetFee
			;s PLIST(30) = $p(val,"^",30)	;NetRemainFee
			;s PLIST(32) = $p(val,"^",32)	;LimitYearsNum
			s PLIST(35) = "维护计划导入简易台账"	;Remark
			s PLIST(39) = 1	;Status
			s PLIST(60) = "N"	;InvalidFlag
			s PLIST(61) = 1	;StockStatus
			s PLIST(64) = EQEquipTypeDR ;EQ_EquipTypeDR
			s PLIST(68) = EQUseLocDR	;EQ_StoreLocDR
			s PLIST(76) = StatCatDR ;EQ_StatCatDR
			
			&SQL(Insert Into SQLUSER.DHC_EQEquip Values :PLIST())
			i SQLCODE 
		 	{
			 	TRollBack
			 	s RetStr=..RetErrorValue(RetStr,"插入失败:DHC_EQEquip,SQLCODE="_SQLCODE) 
			 	q RetStr
			}
	 		Set EquipDR=$g(%ROWID)
			s updateNo= ##CLASS(web.DHCEQEquip).UpdateEquipNo(EquipDR,+$H)
			i updateNo'=0 
			{
			 	TRollBack
			 	s RetStr=..RetErrorValue(RetStr,"更新设备编号失败:updateNo"_updateNo) 
			 	q RetStr
			}
		}
		/*s tmpid=""	先不弄进一张计划单
		&SQL(select MP_RowID into:tmpid from sqluser.DHC_EQMaintPlan where MP_Type = :PlanTypeDR and MP_Name = :PlanName and MP_MeasureDeptDR = :MeasureDeptDR and MP_FromDate = :FromDate)
		i tmpid = "" 
		{*/
			k MPList
			s MPList(2) = PlanName
			s MPList(3) = PlanTypeDR
			s MPList(8) = CycleNum
			s MPList(9) = CycleUnitDR
			i MaintTypeDR'="" d
			.s MPList(10) = MaintTypeDR
			s MPList(11) = $zdh(FromDate,3)
			s MPList(13) = PreWarnDaysNum
			s MPList(14) = MaintFee
			s MPList(15) = MaintLocDR	;MaintLocDR
			s MPList(16) = MaintUserDR
			s MPList(20) = MeasureDeptDR
			s MPList(26) = "导入计划"
			s MPList(27) = "2"				;Status
			s MPList(28) = User				;UpdateUserDR
			s MPList(29) = Date				;UpdateDate
			s MPList(30) = Time				;UpdateTime
			s MPList(37) = "N"
			s MPList(51) = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMaintPlan",Date)

			&SQL(insert into SQLUSER.DHC_EQMaintPlan values :MPList())
			i SQLCODE 
		 	{
			 	TRollBack
			 	s RetStr=..RetErrorValue(RetStr,"插入失败:DHC_EQMaintPlan,SQLCODE="_SQLCODE) 
			 	q RetStr
			}
			s MPRowID = $G(%ROWID)
		/*}
		else
		{
			s MPRowID = tmpid
		}
		*/
		s tmpid=""
	 	&SQL(select ER_RowID into:tmpid from sqluser.DHC_EQEquipRange where ER_SourceType = '2' and ER_SourceID = :MPRowID)
	 	i tmpid=""
	 	{
		 	i EquipRange=5  d	;指定设备
		 	.s ERItemFlag="N"
		 	.s EREquipFlag="Y"
		 	e  i EquipRange=6 d	;指定设备项
			.s ERItemFlag="Y"
			.s EREquipFlag="N"
			&SQL(insert into SQLUSER.DHC_EQEquipRange(ER_RangeDesc,ER_SourceType,ER_SourceID,ER_EquipTypeFlag,ER_StatCatFlag,ER_EquipCatFlag,ER_LocFlag,ER_EquipFlag,ER_ItemFlag) values('计划导入','2',:MPRowID,'N','N','N','N',:EREquipFlag,:ERItemFlag))
			i SQLCODE 
		 	{
			 	TRollBack
			 	s RetStr=..RetErrorValue(RetStr,"插入失败:DHC_EQEquipRange,SQLCODE="_SQLCODE) 
			 	q RetStr
			}	
			s ERRowID = $G(%ROWID)
		}
		else
		{
			s ERRowID = tmpid
		}
		i EquipRange=5  d	;指定设备
	 	.s ERLValue=EquipDR
	 	e  i EquipRange=6 d	;指定设备项
		.s ERLValue=ItemDR
		&SQL(insert into SQLUSER.DHC_EQEquipRangeList(ERL_EquipRangeDR,ERL_Type,ERL_Value,ERL_AccessFlag) values (:ERRowID,:EquipRange,:ERLValue,'Y'))
	 	i SQLCODE 
	 	{
		 	TRollBack
		 	s RetStr=..RetErrorValue(RetStr,"插入失败:DHC_EQEquipRangeList,SQLCODE="_SQLCODE) 
		 	q RetStr
		}
	 	s MaintTime = RowLen-13	;维护记录次数
	 	s Flag = 1
	 	f i=1:1:MaintTime d
	 	.q:Flag'=1
	 	.s MaintDate = $p(RowStr,del,13+i)
	 	.i EquipRange=6 d	;指定设备项
	 	..s rowid=0
	 	..f  s rowid=$O(^DHCEQEquip(rowid)) q:rowid=""  d
	 	...q:Flag'=1
	 	...s EItemDR = $p(^DHCEQEquip(rowid),"^",7)
	 	...s EModelDR = $p(^DHCEQEquip(rowid),"^",3)
	 	...q:EModelDR'=EQModelDR
	 	...q:EItemDR'=ItemDR
	 	...s EInvalidFlag=$p(^DHCEQEquip(rowid),"^",59)
		...q:EInvalidFlag'="N"
		...s EStockStatus=$p(^DHCEQEquip(rowid),"^",60)
		...q:EStockStatus=3
		...q:EStockStatus=0
		...s EStatus=$p(^DHCEQEquip(rowid),"^",38)
		...q:EStatus=3
		...s EMeasureFlag=$p(^DHCEQEquip(rowid),"^",15)
		...q:(EQMeasureFlag'="")&&(EQMeasureFlag'=EMeasureFlag)
	 	...k MList
	 	...s MList(2) = rowid
	 	...s MList(3) = PlanTypeDR
	 	...s MList(4) = MPRowID		;MT_SourceID
	 	...s MList(5) = MaintTypeDR	;MT_MaintTypeDR
	 	...s MList(6) = $zdh(MaintDate,3)			;MT_MaintDate
	 	...s MList(7) = MaintLocDR 	;MT_MaintLoc	;维护科室
	 	...s MList(8) = MaintUserDR		;负责人
	 	...;s MList(9) = MT_MaintMode
	 	...s MList(10) = MaintFee		;MT_TotalFee
	 	...s MList(13) = $p(^DHCEQEquip(rowid),"^",19) ;UseLocDR
	 	...s MList(14) = "2"	;MT_Status
	 	...s MList(15) = "导入计划生成记录"
	 	...s MList(16) = User				;UpdateUserDR
		...s MList(17) = Date				;UpdateDate
		...s MList(18) = Time				;UpdateTime
	 	...s MList(19) = User				;AuditUserDR
		...s MList(20) = Date				;AuditDate
		...s MList(21) = Time				;AuditTime
	 	...s MList(25) = MaintFee 		;MTMaintFee
	 	...s MList(32) = MeasureDeptDR	;MTMeasureDeptDR
	 	...s MList(40) = "N"
		...&SQL(insert into SQLUSER.DHC_EQMaint values :MList()) ;生成维护记录
		...i SQLCODE s Flag = 0
		...q:Flag'=1
		...s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo($G(%ROWID),User)
	 	...i SQLCODE s Flag = 0
	 	.i EquipRange=5 d	;指定设备
	 	..k MList
	 	..s MList(2) = EquipDR
	 	..s MList(3) = PlanTypeDR
	 	..s MList(4) = MPRowID		;MT_SourceID
	 	..s MList(5) = MaintTypeDR	;MT_MaintTypeDR
	 	..s MList(6) = $zdh(MaintDate,3)			;MT_MaintDate
	 	..s MList(7) = MaintLocDR 	;MT_MaintLoc	;维护科室
	 	..s MList(8) = MaintUserDR		;负责人
	 	..;s MList(9) = MT_MaintMode
	 	..s MList(10) = MaintFee		;MT_TotalFee
	 	..s MList(13) = EQUseLocDR ;MT_UseLoc
	 	..s MList(14) = "2"	;MT_Status
	 	..s MList(15) = "导入计划生成记录"
	 	..s MList(16) = User				;UpdateUserDR
		..s MList(17) = Date				;UpdateDate
		..s MList(18) = Time				;UpdateTime
	 	..s MList(19) = User				;AuditUserDR
		..s MList(20) = Date				;AuditDate
		..s MList(21) = Time				;AuditTime
	 	..s MList(25) = MaintFee 		;MTMaintFee
	 	..s MList(32) = MeasureDeptDR	;MTMeasureDeptDR
	 	..s MList(40) = "N"
	 	..;i i=MaintTime d
	 	..;.s LastExcuteDate = MaintDate
	 	..;.&SQL(insert into SQLUSER.DHC_EQPlanExcute values :MList()) ;生成计划执行单
		..&SQL(insert into SQLUSER.DHC_EQMaint values :MList()) ;生成维护记录
		..i SQLCODE s Flag = 0
		..q:Flag'=1
		..s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo($G(%ROWID),User)
	 	..i SQLCODE s Flag = 0
	 	
	 	i Flag'=1
	 	{
		 	TRollBack
		 	s RetStr=..RetErrorValue(RetStr,"插入失败:DHC_EQMaint,SQLCODE="_SQLCODE) 
		 	q RetStr
		}
		TCommit
	}

 	q:RetStr="" "OK"
	q RetStr
}

/// Creator：      wy 1561597
/// CreatDate：    20200924
/// Description:   导入设备编号和动态库编号对照
/// Table：        DHC_EQBindObj
ClassMethod ImOtherCode(ChangeType As %String = "", RowStr As %String = "")
{
	
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set no=$Piece(RowStr,del,1),OtherNo=$Piece(RowStr,del,2)
 	if no="" Set RetStr=..RetErrorValue(RetStr,"设备编号不能为空:")
 	if OtherNo="" Set RetStr=..RetErrorValue(RetStr,"动态编码不能为空")
 	if RetStr'="" Quit RetStr
 	
 	Set EQRowID=""
	&SQL(Select EQ_RowID into :EQRowID from SQLUSER.DHC_EQEquip where EQ_No=:no)
	i EQRowID=""  s RetStr=..RetErrorValue(RetStr,"没有找到设备: 设备="_no)
 	if RetStr'="" Quit RetStr
	Set tmpid=""
	&SQL(Select BO_ROWID into :tmpid from SQLUSER.DHC_EQBindObj where BO_SourceID=:EQRowID and BO_BindType='3')
	If tmpid=""  Do
	.if ChangeType'="Test" Do
	..k FTLIST
	..s FTLIST(2)="1"
	..s FTLIST(3)=EQRowID
	..s FTLIST(4)="3"	 //	动态编码类型为3  modified by wy 2020-12-10 WY0084 导入数据取值错误
	..s FTLIST(6)=OtherNo
    ..s FTLIST(14)="N"
	..&SQL(Insert into SQLUSER.DHC_EQBindObj  Values :FTLIST())
	..i SQLCODE  Set RetStr=..RetErrorValue(RetStr,"插入失败: no="_no_" OtherNo="_OtherNo_" SQLCODE="_SQLCODE)
	e  d
	.Set RetStr=..RetErrorValue(RetStr,"动态编码对照已经存在DHC_EQBindObj:"_no)	 	
 	Quit:RetStr="" "OK"
	Quit RetStr
}

/// Modefied by zc0087 2020-11-30 未在帐设备导入
ClassMethod FacEquip(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQEquip
	q:ChangeType="Clear" "数据已清:设备(DHC_EQEquip)"
	s del="^",RetStr=""
	s model=$p(RowStr,del,7)	// Mzy0001 机型中间的空格予以保留
	s manufacturer=$p(RowStr,del,20)	// Mzy0001 生产厂商中间的空格予以保留
	s model=##Class(web.DHCEQCommon).Trim(model)
 	s manufacturer=##Class(web.DHCEQCommon).Trim(manufacturer)
	SET RowStr=$tr(RowStr," ","")
 	;s (设备类组,设备类型,设备分类,设备编号,名称,机型,数量,单位,原值,使用科室,状态,入库日期,购置日期)=""
 	;s (折旧方法,使用年限,累计折旧,残值率,供应商,生产厂商,出厂编号,出厂日期,国别,设备用途,设备来源,管理人,保管人,来源部门,备注)=""
 	s equiptype=$p(RowStr,del,1)
 	s statcat=$p(RowStr,del,2)
 	s equipcat=$p(RowStr,del,3)
 	s equipno=$p(RowStr,del,4)
 	s equipname=$p(RowStr,del,5)
 	s code=$p(RowStr,del,6)
 	;s model=$p(RowStr,del,7)
 	s quantity=$p(RowStr,del,8)
 	s unit=$p(RowStr,del,9)
 	s originalfee=$p(RowStr,del,10)
 	s useloc=$p(RowStr,del,11)
 	s status=$p(RowStr,del,12)
 	;modified by csj 20180815 根据实施规范最新数据准备模板改为先入库日期后启用日期
 	s instockdate=$p(RowStr,del,13)			// 入库(账)日期
 	s startdate=$p(RowStr,del,14)			// 启用日期 Modify DJ 2015-08-21 DJ0157
 	s depremethod=$p(RowStr,del,15)
 	s limityears=$p(RowStr,del,16)
 	s depretotalfee=$p(RowStr,del,17)
 	s remainrate=$p(RowStr,del,18)
 	s provider=$p(RowStr,del,19)
 	;s manufacturer=$p(RowStr,del,20)
 	s leavefactoryno=$p(RowStr,del,21)
 	s leavefactorydate=$p(RowStr,del,22)
 	s country=$p(RowStr,del,23)
 	s purposetype=$p(RowStr,del,24)
 	s origin=$p(RowStr,del,25)
 	s manager=$p(RowStr,del,26)
 	s keeper=$p(RowStr,del,27)
 	s fromtodept=$p(RowStr,del,28)
 	s remark=$p(RowStr,del,29)
 	
 	// 旧科室30	报废日期31	助记码32	location33	凭证号34	资产唯一编号35	资金来源36	建筑面积37	品牌38	经费来源39	保修月数40
 	s oldloc=$p(RowStr,del,30)
 	s disuseddate=$p(RowStr,del,31)
 	i disuseddate'="" s disuseddate=$e(disuseddate,1,4)_"-"_$e(disuseddate,5,6)_"-"_$e(disuseddate,7,8)
 	s memorycode=$p(RowStr,del,32)
 	s Location=$p(RowStr,del,33)   ;服务联系人->变更为存放地点
 	s accountNo=$p(RowStr,del,34)   ;凭证号
 	s EQFileNo=$p(RowStr,del,35)   ;导入系统前,原始数据中唯一标识,可以为ID或资产唯一编号oldID
 	s fundsstr=$p(RowStr,del,36)	;资金来源
 	s buildingArea=$p(RowStr,del,37)	//总建筑面积 2013-4-15 Hzy
 	s brand=$p(RowStr,del,38)		//品牌 Add By DJ 2015-08-21 DJ0157
 	s Expenditures=$p(RowStr,del,39)		//经费来源 Add By DJ 2015-08-21 DJ0157
 	s PeriodNum=$p(RowStr,del,40)		// 保修月数
 	
 	
 	 	
 	d SetEquipInfo
 	
 	if RetStr'="" q RetStr

	if ChangeType'="Test"  d
	.&SQL(Insert Into SQLUSER.DHC_EQEquip Values :PLIST())
	.i SQLCODE  d
	..s RetStr=..RetErrorValue(RetStr,"插入设备台帐信息失败: 设备="_equipname_" SQLCODE="_SQLCODE)
	.e  d
	..s ID=$g(%ROWID)
	..s TempNo=$p($g(^DHCEQEquip(ID)),"^",71) //2011-02-19 DJ
	..i TempNo="" d
	...d ##CLASS(web.DHCEQEquip).UpdateEquipNo(ID,+$H)
	
 	q:RetStr="" "OK"
	q RetStr
	
SetEquipInfo
	k PLIST
	k PLIST(1)	;RowID
	s PLIST(2) = equipname	;Name
		
 	;s PLIST(3) = abctype	;ABCType
 	i model'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetModelID(model,equipname,equiptype)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到机型: 设备="_equipname_" 机型="_model)
	.e  d
	.s PLIST(4)=tmpid
		
	
	i equipcat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,equipcat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_equipname_" 设备分类="_equipcat)
	.e  d
	..s PLIST(5)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_equipname)
	
	i unit'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_equipname_" 设备单位="_unit)
	.e  d
	..s PLIST(6)=tmpid
	
	i code'="" s PLIST(7) = code		;Code
	s equiptypeid=""
	i equiptype'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipTypeID(equiptype)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类组: 设备="_equipname_" 设备类组="_equiptype)
	.e  d
	..s PLIST(64)=tmpid
	..s equiptypeid=tmpid
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类组: 设备="_equipname_" 设备类组="_equiptype)
 	
	i equipname'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetItemID(equipname,equiptypeid)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备项: 设备="_equipname_" 设备项="_equipname)
	.e  d
	..s PLIST(8)=tmpid
	
 	i leavefactoryno'="" s PLIST(11) = leavefactoryno
 	i leavefactorydate'="" d
 	.s PLIST(12) = $zdh(leavefactorydate,3)	;LeaveFactoryDate
 	
 	
 	i country'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetCountryID(country)
	.i tmpid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到国别: 设备="_equipname_" 国别="_country)
	.e  d
	..s PLIST(17)=tmpid

 	
 	i useloc'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUseLocID(useloc)
	.;s tmpid=410
	.i tmpid=""  d 
	..;s PLIST(20)=1276
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室: 设备="_equipname_" 科室="_useloc)
	.e  d
	..i status="在库"  d //2011-02-19 DJ
	...s PLIST(68)=tmpid
	..s PLIST(20)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有科室: 设备="_equipname)
	
	i origin'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetOriginID(origin)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备来源: 设备="_equipname_" 来源="_origin)
	.e  d
	..s PLIST(21)=tmpid
	
	i fromtodept'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetFromToDept(fromtodept)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备来源部门: 设备="_equipname_" 来源部门="_fromtodept)
	.e  d
	..s PLIST(22)=tmpid
		
 	
 	i provider'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetProviderID(provider,1)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到供应商: 设备="_equipname_" 供应商="_provider)
	.e  d
	..s PLIST(26)=tmpid
	
	i manufacturer'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetManuFactoryID(manufacturer)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到生产厂商: 设备="_equipname_" 生产厂商="_manufacturer)
	.e  d
	..s PLIST(27)=tmpid
	
 	

 	i remark'="" s PLIST(35) = remark
 	i depretotalfee'="" s PLIST(36) = $Number(depretotalfee,2)
 	
 	//modify by mwz 20220117 mwz0056 
 	i (status="启用")||(status="在用")  d
 	.s status=1
 	e  i status="在库"  d
 	.s status=0
 	.k PLIST(20)		;useloc
 	e  i status="报废"  d
 	.s status=3
 	.s PLIST(68)=PLIST(20)
 	.k PLIST(20)		;useloc
 	s PLIST(39) = status
 	
 	i manager'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUserID(manager)
	.i tmpid=""  d 
	..;s RetStr=..RetErrorValue(RetStr,"没有找到该管理人: 设备="_equipname_" 管理人="_manager)
	.e  d
	..s PLIST(40)=tmpid
	
 	
 	i startdate'="" s PLIST(45) =$zdh(startdate,3)  ;StartDate
 	i instockdate'=""   d
 	.s PLIST(46) = $zdh(instockdate,3)


 	s PLIST(48) = "Y"	;InputFlag

 	s PLIST(54) = +$h	;EQ_AddDate	 modified by csj 20180815  启用日期"PLIST(45)"可能为空(在库)而出现"undefined"错误,改为入库日期"PLIST(46)"
 
 	s PLIST(60) = "N"		;InvalidFlag
 	//添加
 	s PLIST(61) = 1	;StockStatus
 	i memorycode'="" s PLIST(62) = memorycode		;MemoryCode
 	;s PLIST(63) = 	;UrgencyFlag
 	
 	;s PLIST(65) = 	;PurchaseTypeDR
 	
 	i purposetype'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetPurposeTypeID(purposetype)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该用途: 设备="_equipname_" 用途="_purposetype)
	.e  d
	..s PLIST(66)=tmpid
 	
 	i keeper'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetUserID(keeper)
	.i tmpid=""  d 
	..;s RetStr=..RetErrorValue(RetStr,"没有找到该保管人: 设备="_equipname_" 人员="_keeper)
	.e  d
	..s PLIST(67)=tmpid
	
	i $g(PLIST(20))'="" s PLIST(68) = $g(PLIST(20))	;StoreLocDR
 
 	i equipno'="" s PLIST(72) = equipno
 	
 	
 	i Location'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetLocationID(Location)
 	.i tmpid=""  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到该存放地点: 设备="_equipname_" 存放地点="_Location)
 	.e  d
 	..s PLIST(73) =tmpid 	;Location
 	i PeriodNum'="" s PLIST(74) =PeriodNum 	;EQ_ServiceTel	EQ_GuaranteePeriodNum
 	
 	i statcat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_equipname_" 设备类型="_statcat)
	.e  d
	..s PLIST(76)=tmpid
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类型: 设备="_equipname)
	
	s PLIST(80)=oldloc
	
	i EQFileNo'=""  d
 	.s tmpid=##Class(web.DHCEQOpenCheckRequest).CheckFileNo("","",EQFileNo)
	.i tmpid'=0  d 
	..s RetStr=..RetErrorValue(RetStr,"有重复的编号: 设备="_equipname_" 档案号="_EQFileNo)
	.e  d
	.s PLIST(86)=EQFileNo	;EQFileNo
	
	i disuseddate'="" s PLIST(90)=$zdh(disuseddate,3)
 	i accountNo'="" s PLIST(91)=accountNo
 	
 	
 	//Add By DJ 2015-08-21 DJ0157 begin
 	i brand'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetbrandID(brand)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到品牌: 设备="_equipname_" 品牌="_brand)
	.e  d
	.s PLIST(95)=tmpid
	
 	i Expenditures'=""  d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetExpendituresID(Expenditures)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到经费来源: 设备="_equipname_" 经费来源="_Expenditures)
	.e  d
	.s PLIST(96)=tmpid
	
	
	quit
}

/// MZY0076	2021-05-25
/// Creator：      ZX
/// CreatDate：    2021-03-23
/// Description:   导入预防性维护项目
/// Table：        DHC_EQCMaintItem,DHC_EQMCMaintItemValues,DHC_EQMCMaintItemNormalValues
ClassMethod InsertMaintItem(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear" d
	.Kill ^DHCEQCCode("DHCEQCMaintItemCat")
	.Kill ^DHCEQCCode("DHCEQCMaintItem")
	.Kill ^DHCEQCCode("DHCEQMCMaintItemValues")
	.Kill ^DHCEQCCode("DHCEQMCMaintItemNormalValues")
	Quit:ChangeType="Clear" "数据已清:预防性维护项目(DHC_EQCMaintItem)"
	
	Set del="^",RetStr=""
	Set RowStr=$tr(RowStr," ","")
 	Set Type=$Piece(RowStr,del,1),ItemCatCode=$Piece(RowStr,del,2),ItemCatDesc=$Piece(RowStr,del,3),ItemCode=$Piece(RowStr,del,4)
 	Set ItemDesc=$Piece(RowStr,del,5),ItemDateType=$Piece(RowStr,del,6),ItemDisplayType=$Piece(RowStr,del,7),MIVValue=$Piece(RowStr,del,8)
 	Set MIVDesc=$Piece(RowStr,del,9),MIVNormalType=$Piece(RowStr,del,10),MINVValueType=$Piece(RowStr,del,11),MINVAllFlag=$Piece(RowStr,del,12)
 	Set MINVNormalValue=$Piece(RowStr,del,13),MINVMinValue=$Piece(RowStr,del,14),MINVMaxValue=$Piece(RowStr,del,15),MINVItemFactorKey=$Piece(RowStr,del,16)
 	
 	;s ItemCatDesc=$ZCONVERT(ItemCatDesc,"U")
 	;s ItemDesc=$ZCONVERT(ItemDesc,"U")
 	
 	Set Type=$Piece(Type,":",1)
 	Set ItemDateType=$Piece(ItemDateType,":",1)
 	Set ItemDisplayType=$Piece(ItemDisplayType,":",1)
 	
 	s tmpid=""
	s MICID=""
	&SQL(Select MIC_RowID into :tmpid from sqluser.DHC_EQCMaintItemCat where MIC_Desc=:ItemCatDesc and MIC_Type=:Type)
 	i tmpid=""  d
	.i ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCMaintItemCat(MIC_Type,MIC_Code,MIC_Desc,MIC_InvalidFlag) values (:Type,:ItemCatCode,:ItemCatDesc,'N'))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入保养大项失败DHC_EQCMaintItemCat: Desc="_ItemCatDesc_" SQLCODE="_SQLCODE)
	..e  d
	...s tmpid=$g(%ROWID)
	i RetStr'="" q RetStr
	s MICID=tmpid
	
	s tmpid=""
	s MIID=""
	&SQL(Select MI_RowID into :tmpid from sqluser.DHC_EQCMaintItem where MI_Desc=:ItemDesc and MI_Type=:Type and MI_ItemCatDR=:MICID)
	i tmpid=""  d
	.i ChangeType'="Test" d
	..&SQL(Insert into SQLUSER.DHC_EQCMaintItem(MI_Code,MI_Desc,MI_InvalidFlag,MI_Type,MI_ItemCatDR,MI_DateType,MI_DisplayType) values (:ItemCode,:ItemDesc,'N',:Type,:MICID,:ItemDateType,:ItemDisplayType))
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入保养项失败DHC_EQCMaintItem: Desc="_ItemDesc_" SQLCODE="_SQLCODE)
	..e  d
	...s tmpid=$g(%ROWID)
	i RetStr'="" q RetStr
	s MIID=tmpid
	
 	i (ChangeType'="Test")&&(MIID="") s RetStr=..RetErrorValue(RetStr,"保养不能为空DHC_EQCMaintItem: Desc="_ItemDesc_" SQLCODE="_SQLCODE)
 	i RetStr'="" q RetStr
 	
 	
 	s Len=$l(MIVValue,",")
	f i=1:1:Len q:RetStr'=""  d
	.s tmpMIVValue=$p(MIVValue,",",i)
	.s tmpMIVDesc=$p(MIVDesc,",",i)
 	.s tmpMIVNormalType=$p(MIVNormalType,",",i)
 	.Set tmpMIVNormalType=$Piece(tmpMIVNormalType,":",1)
 	.s tmpid=""
 	.i tmpMIVValue'="" d
 	..&SQL(Select MIV_RowID into :tmpid from sqluser.DHC_EQMCMaintItemValues where MIV_MaintItemDR=:MIID and MIV_Value=:tmpMIVValue)
 	..i tmpid=""  d
	...i ChangeType'="Test" d
	....&SQL(Insert into SQLUSER.DHC_EQMCMaintItemValues(MIV_MaintItemDR,MIV_Value,MIV_Desc,MIV_NormalType,MIV_InvalidFlag) values (:MIID,:tmpMIVValue,:tmpMIVDesc,:tmpMIVNormalType,'N'))
	....i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Value="_tmpMIVValue_" Desc="_tmpMIVDesc_" SQLCODE="_SQLCODE)
	..e  d
	...s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQMCMaintItemValues:"_MIVDesc)
	i RetStr'="" q RetStr
 	
 	s tmpid=""
 	i MINVValueType'="" d
 	.&SQL(Select MINV_RowID into :tmpid from sqluser.DHC_EQMCMaintItemNormalValues where MINV_MaintItemDR=:MIID and MINV_ValueType=:MINVValueType and MINV_ItemFactorKey=:MINVItemFactorKey)
 	.i tmpid=""  d
	..i ChangeType'="Test" d
	...&SQL(Insert into SQLUSER.DHC_EQMCMaintItemNormalValues(MINV_MaintItemDR,MINV_ValueType,MINV_AllFlag,MINV_NormalValue,MINV_MinValue,MINV_MaxValue,MINV_ItemFactorKey) values (:MIID,:MINVValueType,:MINVAllFlag,:MINVNormalValue,:MINVMinValue,:MINVMaxValue,:MINVItemFactorKey))
	...i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: ValueType="_MINVValueType_" NormalValue="_MINVNormalValue_" SQLCODE="_SQLCODE)
	.e  d
	..s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_EQMCMaintItemNormalValues:"_MINVValueType)
	i RetStr'="" q RetStr
 	
 	q:RetStr="" "OK"
	q RetStr
}

/// add by czf 2021-04-14 1836998，1836979
/// 更新设备分类财务大类和设备类型
ClassMethod UpdEquipCat(ChangeType As %String = "", RowStr As %String = "")
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCEquipeCat")
	q:ChangeType="Clear" "数据已清:设备分类(DHC_EQCEquipeCat)"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	s statcat=$p(RowStr,del,3),financetype=$p(RowStr,del,4)
 	
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCEquipeCat:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCEquipeCat:")
 	if RetStr'="" q RetStr
 	
 	s ID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",code,0))
 	if ID="" q ..RetErrorValue(RetStr,"编码不存在DHC_EQCEquipeCat:"_code)
 	
 	k PLIST
 	
 	s statcatid=""
 	i statcat'=""  d
	.s statcatid=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i statcatid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 分类="_desc_" 设备类型="_statcat)
	
	s PLIST(12)=statcatid
 	
 	s financetypeid=""
 	i financetype'=""  d
	.s financetypeid=##Class(web.DHCEQImportDataTool).GetFinanceTypeID(financetype)
	.i financetypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该资产大类: 分类="_desc_" 资产大类"_financetype)
	
	s PLIST(11)=financetypeid
	
 	i RetStr'="" q RetStr
 	
	if ChangeType'="Test" d
 	.&SQL(Update SQLUSER.DHC_EQCEquipeCat Values :PLIST() where EC_RowID=:ID)
	.i SQLCODE  s RetStr=..RetErrorValue(RetStr,"更新失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

/// Add By MWZ 2020-08-24
/// 描述:ETL工具导入设备机型
/// 入参：ChangeType :"Test"->测试 ,"Append"->追加
/// w ##class(web.DHCEQImportData2CSP).InsertModelAll("Test")
ClassMethod InsertModelAll(ChangeType As %String = "Test")
{
	s t=$p($h,",",2)
	k ^DHCEQTemp("CheckReturnStrModel")
	s ReturnStr="" 
	s rowid=0
	f  s rowid=$o(^DHCEQImportModel(rowid))  quit:rowid=""  d
	.s DataList=$G(^DHCEQImportModel(rowid))
	.s IMCode=$p(DataList,"^",1)
	.s IMDesc=$p(DataList,"^",2)
	.s IMItem=$p(DataList,"^",3)
	.s IMEquipType=$p(DataList,"^",4)
	.s ImportStr=IMCode_"^"_IMDesc_"^"_IMItem_"^"_IMEquipType
	.s ReturnStr=##Class(web.DHCEQImportData2CSP).Model(ChangeType,ImportStr)
	.i ReturnStr'="OK" s ^DHCEQTemp("CheckReturnStrModel",rowid)=ReturnStr
	s t=$p($h,",",2)-t
	s ROWID=0 
	f  s ROWID=$o(^DHCEQTemp("CheckReturnStrModel",ROWID)) quit:ROWID=""  d
	.w !,"第"_ROWID_"行："_$g(^DHCEQTemp("CheckReturnStrModel",ROWID))
	q "总耗时："_t_"s"  //返回错误结果数
}

/// Add By MWZ 2020-08-24
/// 描述:ETL工具导入设备项
/// 入参：ChangeType :"Test"->测试 ,"Append"->追加
/// w ##class(web.DHCEQImportData2CSP).InsertMasterItemAll("Test")
ClassMethod InsertMasterItemAll(ChangeType As %String = "Test")
{
	s t=$p($h,",",2)
	k ^DHCEQTemp("CheckReturnStrMasterItem")
	s ReturnStr="" 
	s rowid=0
	f  s rowid=$o(^DHCEQImportMasterItem(rowid))  quit:rowid=""  d
	.s DataList=$G(^DHCEQImportMasterItem(rowid))
	.s IMICode=$p(DataList,"^",1)
	.s IMIDesc=$p(DataList,"^",2)
	.s IMIEquipType=$p(DataList,"^",3)
	.s IMIStatCat=$p(DataList,"^",4)
	.s IMIEquipCat=$p(DataList,"^",5)
	.s IMIUnit=$p(DataList,"^",6)
	.s ImportStr=IMICode_"^"_IMIDesc_"^"_IMIEquipType_"^"_IMIStatCat_"^"_IMIEquipCat_"^"_IMIUnit
	.s ReturnStr=##Class(web.DHCEQImportData2CSP).MasterItem(ChangeType,ImportStr)
	.i ReturnStr'="OK" s ^DHCEQTemp("CheckReturnStrMasterItem",rowid)=ReturnStr
	s t=$p($h,",",2)-t
	s ROWID=0 
	f  s ROWID=$o(^DHCEQTemp("CheckReturnStrMasterItem",ROWID)) quit:ROWID=""  d
	.w !,"第"_ROWID_"行："_$g(^DHCEQTemp("CheckReturnStrMasterItem",ROWID))
	q "总耗时："_t_"s"
}

/// Add by ZY0271 20210621
/// 导入安全组敏感信息控制数据
/// w ##class(web.DHCEQImportData2CSP).ComponentItemVisit("Test","固定资产(科室)^EM.G.Equip.EquipList^TOriginalFee^1")
ClassMethod ComponentItemVisit(ChangeType As %String = "", RowStr As %String = "")
{
	q:ChangeType="Clear" "数据不能清除"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s groupName=$p(RowStr,del,1),componentName=$p(RowStr,del,2)
 	s itemName=$p(RowStr,del,3),DisplayType=$p(RowStr,del,4)
 	
 	k PLIST
 	
	i groupName'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetGroupID(groupName)
	.i tmpid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到安全组: "_groupName)
	.e  d
	..s PLIST(2)=tmpid
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有安全组: "_equipname)
	
 	s FindItemID=0
	s ComponentID=0
	f  s ComponentID=$o(^DHCEQCCode("DHCEQCComponent",0,"Name",componentName,ComponentID)) q:(ComponentID="")||(FindItemID'=0)  d
	.quit:$p($g(^DHCEQCCode("DHCEQCComponent",ComponentID)),"^",12)="Y"
	.s ItemID=0
	.f  s ItemID=$o(^DHCEQCCode("DHCEQCComponentItem",0,"Component",ComponentID,ItemID))  quit:(ItemID="")||(FindItemID'=0)  d
	..s DataList=$g(^DHCEQCCode("DHCEQCComponentItem",ItemID))
	..s TItemType=$p(DataList,"^",48)
	..q:TItemType'=1
	..s TName=$p(DataList,"^",2)
	..q:(itemName'=TName)
	..s FindItemID=ItemID
	s:FindItemID=0 RetStr=..RetErrorValue(RetStr,"元素未找到，itemName:"_componentName_","_itemName)
 	q:RetStr'="" RetStr
 	s PLIST(3)=FindItemID
 	
	s PLIST(4)=DisplayType
 	if ChangeType'="Test"
 	{
	 	s tmpid=""
	 	&SQL(select CIV_RowID Into :tmpid from SQLUSER.DHC_EQCComponentItemVisit where CIV_GroupDR=:PLIST(2) and CIV_ComponentItemDR=:PLIST(3))
	 	i tmpid=""
	 	{
		 	&SQL(Insert Into SQLUSER.DHC_EQCComponentItemVisit Values :PLIST())	
		}
		else
		{
			&SQL(update SQLUSER.DHC_EQCComponentItemVisit Values :PLIST()  where CIV_RowID=:tmpid)	
		}
		i SQLCODE s RetStr=..RetErrorValue(RetStr,"InsertErr: Code="_RowStr_" SQLCODE="_SQLCODE)
	}
 	
 	q:RetStr="" "OK"
	q RetStr
}

/// Add By MWZ 2021-06-29 MWZ0051
/// 描述:批量初始化台账中导入设备中未生成入库记录的设备
/// w ##class(web.DHCEQImportData2CSP).InsertInStockList()
ClassMethod InsertInStockList()
{
	s rowid=0
	f  s rowid=$O(^DHCEQEquip(rowid)) q:rowid=""  d
	.q:$p(^DHCEQEquip(rowid),"^",70)'=""
	.q:$p(^DHCEQEquip(rowid),"^",47)'="Y"
	.s IS(2)=$p(^DHCEQEquip(rowid),"^",45) //入库日期
	.s IS(3)=$p(^DHCEQEquip(rowid),"^",67)  //库房
	.s IS(8)=$p(^DHCEQEquip(rowid),"^",45)	//审核日期
	.s IS(11)="2"	//状态审核
	.s IS(12)="期初"
	.s IS(14)=$p(^DHCEQEquip(rowid),"^",45)	//账务审核日期
	.i $p(^DHCEQEquip(rowid),"^",20)'="" s IS(16)= $p(^DHCEQEquip(rowid),"^",20) //设备来源
	.i $p(^DHCEQEquip(rowid),"^",21)'="" s IS(17)= $p(^DHCEQEquip(rowid),"^",21) //来源部门
	.i $p(^DHCEQEquip(rowid),"^",25)'="" s IS(18)=$p(^DHCEQEquip(rowid),"^",25)	//供应商
	.s IS(21)=$p(^DHCEQEquip(rowid),"^",63)  //类组
	.s IS(22)=$p(^DHCEQEquip(rowid),"^",75)   //类型
	.&SQL(Insert Into SQLUSER.DHC_EQInStock Values :IS())
	.s ISL(2)=$G(%ROWID)
	.s ISL(4)="Y" //批
	.s ISL(6)=$p(^DHCEQEquip(rowid),"^",1) //设备名称
	.i $p(^DHCEQEquip(rowid),"^",26)'="" s ISL(7)=$p(^DHCEQEquip(rowid),"^",26) //生产厂家
	.s ISL(8)=$p(^DHCEQEquip(rowid),"^",27) //原值
	.s ISL(9)=1  //数量
	.i $p(^DHCEQEquip(rowid),"^",3)'="" s ISL(10)=$p(^DHCEQEquip(rowid),"^",3) //机型
	.s ISL(11)=$p(^DHCEQEquip(rowid),"^",5) //单位
	.s ISL(15)=$p(^DHCEQEquip(rowid),"^",4) //设备分类
	.i $p(^DHCEQEquip(rowid),"^",31)'="" s ISL(16)=$p(^DHCEQEquip(rowid),"^",31) //使用年限
	.s ISL(17)=$p(^DHCEQEquip(rowid),"^",8) //设备项
	.s ISL(18)=$p(^DHCEQEquip(rowid),"^",75) //2011-03-10 DJ begin
	.s ISL(19)=1
	.s ISL(20)=$p(^DHCEQEquip(rowid),"^",7) //2011-03-10 DJ end
	.&SQL(Insert Into SQLUSER.DHC_EQInStockList Values :ISL())
	.s ISLRowID=$G(%ROWID)
	.&SQL(Update SQLUSER.DHC_EQEquip set EQ_InStockListDR=:ISLRowID Where EQ_RowID=:rowid)
	q SQLCODE
}

/// Author:add by czf 2021-12-02
/// Description:更新标准设备项
ClassMethod UpdKBSMstItem(ChangeType As %String = "", RowStr As %String = "", Type As %String = "")
{
	s del="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
 	s rowid=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	s desc=$ZCONVERT(desc,"U")
 	s desc=$replace(desc,"（","(")
 	s desc=$replace(desc,"）",")")
 	s desc=$replace(desc,"，",",")
 	s code=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")
 	s FromFinanceType=$p(RowStr,del,3),FromStatCat=$p(RowStr,del,4),FromEquipCat=$p(RowStr,del,5)
 	s invalidflag=$p(RowStr,del,6)
 	i invalidflag="" s invalidflag="N"
 	s financetype=$p(RowStr,del,7),statcat=$p(RowStr,del,8)
 	s equipcat=$p(RowStr,del,9),unit=$p(RowStr,del,10),confirmstatus=$p(RowStr,del,11)		//1为项目确认，2为最终确认
 	
 	k PLIST
 	
 	;i rowid="" s RetStr=..RetErrorValue(RetStr,"rowid不能为空DHC_EQKBMstItem:")
 	i desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQKBMstItem:") 	
 	
 	s (FromFTypeID,FromStatCatID,FromEquipCatID)=""
 	s FromFTypeID=##Class(web.DHCEQImportDataTool).GetFinanceTypeID(FromFinanceType)
 	;i FromFTypeID="" s RetStr=..RetErrorValue(RetStr,"没有来源资产大类: 设备="_desc_" 资产大类="_FromFinanceType)
 	s FromStatCatID=##Class(web.DHCEQImportDataTool).GetStatCatID(FromStatCat)
 	;i FromStatCatID="" s RetStr=..RetErrorValue(RetStr,"没有找到来源类型: 设备="_desc_" 设备类型"_FromStatCat)
 	s FromEquipCatID=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,FromEquipCat)
 	;i FromEquipCatID="" s RetStr=..RetErrorValue(RetStr,"没有找到来源分类: 设备="_desc_" 设备分类="_FromEquipCat)
 	
 	s financetypeid=""
 	i financetype'=""  d
	.s financetypeid=##Class(web.DHCEQImportDataTool).GetFinanceTypeID(financetype)
	.i financetypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该资产大类: 设备="_desc_" 资产大类"_financetype)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置资产大类: 设备="_desc_" 资产大类="_financetype)
    
    s StatCatID=""
	i statcat'=""  d
	.s StatCatID=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i StatCatID=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_desc_" 设备类型="_statcat)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_desc_" 设备类型="_statcat)
	
    s CatID=""
 	i equipcat'=""  d
	.s CatID=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,equipcat)
	.i CatID=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_desc_" 设备分类="_equipcat)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_desc)
	
	s UnitDR=""
	i unit'=""  d
	.s UnitDR=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
	.i UnitDR=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_desc_" 设备单位="_unit)
	
	i rowid="" d
	.&SQL(Select smi_rowid into :rowid from SQLUSER.DHC_EQKBSMstItem where smi_desc=:desc and smi_financetypedr=:financetypeid and smi_statcatdr=:FromStatCatID and smi_catdr=:FromEquipCatID)
	;i rowid="" s RetStr=..RetErrorValue(RetStr,"rowid不能为空!")
	
	i RetStr'="" q RetStr
	
	s newrowid=""
	&SQL(Select smi_rowid into :newrowid from SQLUSER.DHC_EQKBSMstItem where smi_desc=:desc and smi_financetypedr=:FromFTypeID and smi_statcatdr=:StatCatID and smi_catdr=:CatID)

	s PLIST(2)=desc
	s PLIST(3)=code
    s PLIST(4)=financetypeid		;财务大类
    s PLIST(5)=StatCatID			;设备类型
    s PLIST(6)=CatID				;设备分类
    s PLIST(8)=UnitDR				;单位
    s PLIST(9)="N"					;无效标志
	s PLIST(18)="N"					;设备分类末级标志
	s Find='$d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",CatID))
	i Find=0 s PLIST(18) ="Y"
	s PLIST(26)=confirmstatus		;确认标志：1为项目确认，2为最终确认
	
    if ChangeType'="Test"
    {
	    i (newrowid'="")&&(newrowid'=rowid) d
	    .s Frequence=$p($g(^DHCEQKB("DHCEQKBSMstItem",newrowid)),"^",16)
	    .s OldFrequence=$p($g(^DHCEQKB("DHCEQKBSMstItem",rowid)),"^",16)
	    .s PLIST(17)=Frequence+OldFrequence
	    .&SQL(Update SQLUSER.DHC_EQKBSMstItem Values :PLIST() where SMI_RowID=:newrowid)
	    .q:SQLCODE'=0
	    .&SQL(Update SQLUSER.DHC_EQKBSMstItem set SMI_InvalidFlag='Y' where SMI_RowID=:rowid)
	    .q:SQLCODE'=0
	    e  d
	    .i rowid'="" d
    	..&SQL(Update SQLUSER.DHC_EQKBSMstItem Values :PLIST() where SMI_RowID=:rowid)
    	.e  d
    	..&SQL(Insert Into SQLUSER.DHC_EQKBSMstItem Values :PLIST())
		i SQLCODE s RetStr=..RetErrorValue(RetStr,"更新DHC_EQKBSMstItem失败: Desc="_desc_" SQLCODE="_SQLCODE)
    }
 	i RetStr="" s RetStr="OK"
	q RetStr
}

/// 创建：czf 2022-03-31
/// 描述：导入设备属性信息
/// 访问表:DHC_EQAffix
/// 输入：ChangeType：操作类别
/// 	RowStr：EqNo^EqName^EqAttribbute^EqAttributeCat
/// 输出：无
/// 返回：成功返回"OK"，否则返回出错信息
/// 备注：
/// w ##class(web.DHCEQImportData2CSP).EquipAttribute("Append","A000013^无创呼吸机^急诊急救设备^")
ClassMethod EquipAttribute(ChangeType As %String = "", RowStr As %String = "")
{
	Quit:ChangeType="Clear" "未操作"
	s Flag="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
	s EqNo=$p(RowStr,Flag,1)
 	s EquipDR=$o(^DHCEQEquip(0,"No",EqNo,0))
 	if (EquipDR="") 
 	{
	 	s RetStr=..RetErrorValue(RetStr,"没有找到该设备,请确认设备编号是否正确! 设备编号="_EqNo)
	 	q RetStr
 	}
 	
 	s EqName=$p(RowStr,Flag,2)
 	s EqAttribbute=$p(RowStr,Flag,3)
 	s EqAttributeCat=$p(RowStr,Flag,4)
 	
 	&SQL(Update SQLUSER.DHC_EQCEquipAttribute set EA_InvalidFlag='N' where EA_InvalidFlag IS NULL)
 	i SQLCODE=100 s SQLCODE=0
 	
 	&SQL(Update SQLUSER.DHC_EQCInHospitalType set IHT_InvalidFlag='N' where IHT_InvalidFlag IS NULL)
 	i SQLCODE=100 s SQLCODE=0
 	
 	if EqAttribbute=""
 	{
	 	s RetStr=..RetErrorValue(RetStr,"设备属性不能为空!")
	 	q RetStr
	}
	s EqAttribbuteDR=""
 	&SQL(Select EA_RowID into :EqAttribbuteDR from SQLUSER.DHC_EQCEquipAttribute where EA_Name=:EqAttribbute and EA_InvalidFlag!='Y')
 	if EqAttribbuteDR=""
 	{
	 	s RetStr=..RetErrorValue(RetStr,"设备属性："_EqAttribbute_"不存在!")
	 	q RetStr
	}
	
	s EqAttributeCatDR=""
	i EqAttributeCat'=""
	{
		&SQL(Select IHT_RowID into :EqAttributeCatDR from SQLUSER.DHC_EQCInHospitalType where IHT_Desc=:EqAttributeCat and IHT_InvalidFlag!='Y')
	 	if EqAttributeCatDR=""
	 	{
		 	s RetStr=..RetErrorValue(RetStr,"设备属性分类"_EqAttributeCat_"不存在!")
		 	q RetStr
		}
	}
		
	k PLIST
 	s PLIST(2)=EqAttribbuteDR
	s PLIST(3)="3"
	s PLIST(4)=EquipDR
	s PLIST(5)=EqAttributeCatDR
	s PLIST(7)="N"
	
	If ChangeType'="Test"
	{
		&SQL(insert into sqluser.DHC_EQEquipAttributeList values :PLIST())
		If SQLCODE s RetStr=..RetErrorValue(RetStr,"插入设备属性失败: 设备编号="_EqNo_" 属性="_EqAttribbute_" SQLCODE="_SQLCODE)
	}
	Quit:RetStr="" "OK"
	Quit RetStr
}

/// /导入供应商
ClassMethod UPDVendor(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQCVendor")
	q:ChangeType="Clear" "数据已清:供应商(DHC_EQCVendor)"
	s del="^",RetStr=""
	
 	s desc=$p(RowStr,del,1) //名称
 	s desc=##class(web.DHCEQCommon).Trim(desc)
 	s address=$p(RowStr,del,2) //地址
 	s contperson=$p(RowStr,del,3) //联系人
 	s tel=$p(RowStr,del,4) //联系电话
 	s fax=$p(RowStr,del,5) //传真
 	s zipcode=$p(RowStr,del,6) //邮编
 	s remark=$p(RowStr,del,7) //备注
 	s shname=$p(RowStr,del,8)
 	s bank=$p(RowStr,del,9)	//开户行
 	s bankno=$p(RowStr,del,10)	//帐号
 	
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCVendor:")
 	if RetStr'="" q RetStr
 	s desc=$ZCONVERT(desc,"U")
	
	s tmpid=""
 	&SQL(Select v_rowid into :tmpid from SQLUSER.DHC_EQCVendor where v_name=:desc and v_invalidflag='N')		//modified by CZF0105 begin
 	i tmpid=""
	{
		q ..RetErrorValue(RetStr,"名称不存在DHC_EQCVendor:"_desc)
	}
	
	if ChangeType'="Test"
	{
		k PLIST
		s PLIST(4) = address
		s PLIST(8) = zipcode
		s PLIST(9) = contperson
		s PLIST(10) = tel
		s PLIST(11) = fax
		s PLIST(12) = shname
		s PLIST(14) = bank
		s PLIST(15) = bankno
		
		&SQL(update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID=:tmpid)
		if SQLCODE q ..RetErrorValue(RetStr,"插入失败: Desc="_desc_" SQLCODE="_SQLCODE)
	}
	q:RetStr="" "OK"
	q RetStr
}

/// czf 2022-09-08
/// 导入电子资料
ClassMethod AppendFile(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear"  d
	.k ^DHCEQCCode("DHCEQAppendFile")
	q:ChangeType="Clear" "数据已清:电子资料(DHC_EQAppendFile)"
	s del="^",RetStr=""
	
 	s SourceType=$p(RowStr,del,1) //来源类型
 	s BussNo=$p(RowStr,del,2)	//编号
 	s AppenFileType=$p(RowStr,del,3) //资料类型
 	s DocName=$p(RowStr,del,4) //文件名
 	s FileName=$p(RowStr,del,5) //ftp文件名称
 	s FilePath=$p(RowStr,del,6) //ftp文件路径
 	s FileType=$p(RowStr,del,7) //ftp文件类型
 	s Remark=$p(RowStr,del,8) //备注
 	s AddUser=$p(RowStr,del,9) //新增人
 	s AddDate=$p(RowStr,del,10)	//日期
 	s AddTime=$p(RowStr,del,11)	//时间
 	s SubmitUser=$p(RowStr,del,12)	//提交人
 	s SubmitDate=$p(RowStr,del,13)	//日期
 	s SubmitTime=$p(RowStr,del,14)	//时间
 	s InvalidFlag=$p(RowStr,del,15)	//无效标志
 	s OldAppendFileID=$p(RowStr,del,16)	//旧系统文件ID
 	
 	if SourceType="" q ..RetErrorValue(RetStr,"文件类型不能为空!")
 	if DocName="" q ..RetErrorValue(RetStr,"名称不能为空!")
 	s SourceID=""
 	i SourceType="52" d
 	.s SourceID=$o(^DHCEQEquip(0,"No",BussNo,""))
 	.i SourceID="" s SourceID="" 	//s RetStr=..RetErrorValue(RetStr,"编号不存在!"_EquipNo)
 	e  i SourceType="11" d
 	.s ocrrowid=$o(^DHCEQOpenCheckRequest(0,"RequestNo"," "_BussNo,""))
 	.s SourceID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",ocrrowid,""))
 	.i SourceID="" s SourceID=""
 	e  d
 	.s SourceID=0
 	i RetStr q RetStr
 	
 	s tmpid=""
 	//&SQL(select AF_RowID into :tmpid from SQLUSER.DHC_EQAppendFile where AF_SourceType='52' and AF_SourceID=:SourceID and AF_FileName=:FileName)
 	s AFRowID=0
 	f  s AFRowID=$o(^DHCEQAppendFile(0,"SourceType",SourceType,+SourceID,AFRowID)) q:(AFRowID="")||(tmpid'="")  d
 	.q:$p($g(^DHCEQAppendFile(AFRowID)),"^",5)'=FileName
 	.s tmpid=AFRowID
 	i tmpid'="" q ..RetErrorValue(RetStr,"该文件已存在!")
 	
 	s SQLCODE=0
 	
 	s AddUserID=##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCUser",AddUser)
 	i AddDate'="" s AddDate=$zdh(AddDate,3)
 	i AddTime'="" s AddTime=$zth(AddTime,3)
 	s SubmitUserID=##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCUser",SubmitUser)
 	i SubmitDate'="" s SubmitDate=$zdh(SubmitDate,3)
 	i SubmitTime'="" s SubmitTime=$zth(SubmitTime,3)
	
	if ChangeType'="Test"
	{
		k PLIST
		s PLIST(2) = SourceType
		s PLIST(3) = SourceID
		s PLIST(4) = AppenFileType
		s PLIST(5) = DocName
		s PLIST(6) = FileName
		s PLIST(7) = FilePath
		s PLIST(8) = FileType
		s PLIST(9) = Remark
		s PLIST(10) = AddUser
		s PLIST(11) = AddDate
		s PLIST(12) = AddTime
		s PLIST(13) = SubmitUser
		s PLIST(14) = SubmitDate
		s PLIST(15) = SubmitTime
		s PLIST(19) = "0"
		s PLIST(20) = InvalidFlag
		s PLIST(21) = "N"
		s PLIST(22) = OldAppendFileID
		s PLIST(23) = "Y"	//导入标识
		
		&SQL(insert into SQLUSER.DHC_EQAppendFile Values :PLIST())
		if SQLCODE q ..RetErrorValue(RetStr,"插入失败: DocName="_DocName_" SQLCODE="_SQLCODE_"错误信息:"_$g(%msg))
	}
	q:RetStr="" "OK"
	q RetStr
}

/// czf 2022-09-25
/// 验收单
/// w ##class(web.DHCEQImportData2CSP).OpenCheckList("Append","YS220829005392^医用低温保存箱^YYDWBCX^海上紧急医学救援队^专用设备^其他^医用低温设备^DW-25L 262^18900.00^自有资金=18900^1^台^0^新购设备^20/04/2022^20/04/2022^中国^青岛海尔生物医疗股份有限公司^南宁市思高加科技有限公司^杨国寿^13902309795^医疗用^购置^^14/02/2022^BE02Q300000QEN2EQAGJ^平均年限法^5^^12^SGJXX20220416^存放地点：检验科分院门诊^鲁械注准20162220180^^0^165^^^^^0^^^^^^^^王誉皓^6^5392")
ClassMethod OpenCheckList(ChangeType As %String = "", RowStr As %String = "")
{
	//s ^tempczf("opencheck")=$lb(ChangeType,RowStr)
	IF ChangeType="Clear"  d
	.k ^DHCEQEquip
	q:ChangeType="Clear" "数据已清:设备(DHC_EQEquip)"
	s del="^",RetStr=""
	s opencheckno=$p(RowStr,del,1)	//验收单号
	s equipname=$p(RowStr,del,2)	//设备名称
 	s equipname=##Class(web.DHCEQCommon).Trim(equipname)
 	s code=$p(RowStr,del,3)		//代码
 	s code=##Class(web.DHCEQCommon).Trim(code)
 	s useloc=$p(RowStr,del,4)		//使用科室
 	s equiptype=$p(RowStr,del,5)	//类组
 	s statcat=$p(RowStr,del,6)		//类型
 	s equipcat=$p(RowStr,del,7)		//分类
 	s model=$p(RowStr,del,8)		//机型
	s model=##Class(web.DHCEQCommon).Trim(model)
 	s originalfee=$p(RowStr,del,9)	//原值
 	s fundsinfo=$p(RowStr,del,10)	//资金来源
 	i fundsinfo="" d
 	.s DefaultFundsTypeDR=##class(web.DHCEQCommon).GetSysInfo("990015")
 	.s DefaultFundsType=##class(web.DHCEQCommon).GetTrakNameByID("fundstype",DefaultFundsTypeDR)
 	.s fundsinfo=DefaultFundsType_"="_originalfee
 	
 	s quantity=$p(RowStr,del,11)	//数量
 	s originalfeetotal=originalfee*quantity
 	
 	s unit=$p(RowStr,del,12)	//单位
 	s status=$p(RowStr,del,13)	//单据状态
 	s purchasetype=$p(RowStr,del,14)	//申购类型
 	s opencheckdate=$p(RowStr,del,15)	//开箱日期
 	i opencheckdate'="" s opencheckdate=$zdh(opencheckdate,4)
 	s checkdate=$p(RowStr,del,16)	//验收日期
 	i checkdate'="" s checkdate=$zdh(checkdate,4)
 	s country=$p(RowStr,del,17)		//国别
 	s manufacturer=$p(RowStr,del,18)	//生产厂商
 	s manufacturer=##Class(web.DHCEQCommon).Trim(manufacturer)
 	s provider=$p(RowStr,del,19)	//供应商
 	s provider=##Class(web.DHCEQCommon).Trim(provider)
 	s providerhandler=$p(RowStr,del,20)	//供方联系人
 	s providertel=$p(RowStr,del,21)	//供方联系方式
 	s purposetype=$p(RowStr,del,22)	//用途
 	s origin=$p(RowStr,del,23)		//来源
 	s buytype=$p(RowStr,del,24)		//采购方式
 	s leavefactorydate=$p(RowStr,del,25)	//出厂日期
 	i leavefactorydate'="" s leavefactorydate=$zdh(leavefactorydate,4)
 	s leavefactoryno=$p(RowStr,del,26)	//出厂编号
 	s depremethod=$p(RowStr,del,27)	//折旧方法
 	s limityears=$p(RowStr,del,28)	//使用年限
 	s location=$p(RowStr,del,29)	//存放地点
 	s guaranteenums=$p(RowStr,del,30)	//保修期
 	s contratno=$p(RowStr,del,31)	//合同号
 	s remark=$p(RowStr,del,32)		//备注
 	s registerno=$p(RowStr,del,33)	//注册证号
 	s configlicense=$p(RowStr,del,34)		//配置许可证号
 	s newoldpercent=$p(RowStr,del,35)		//新旧程度
 	s power=$p(RowStr,del,36)		//功率
 	s voltage=$p(RowStr,del,37)		//电压
 	s electricity=$p(RowStr,del,38)		//电流
 	s noticeitem=$p(RowStr,del,39)	//注意事项
 	s maintpoint=$p(RowStr,del,40)	//保养要点
 	s isbuyitem=$p(RowStr,del,41)	//是否2012年后采购项目
 	s isbuyitem=$case(isbuyitem,"1":"Y",:"N")
 	s buyitemcode=$p(RowStr,del,42)	//采购项目名称代码
 	s buyitemyear=$p(RowStr,del,43)	//采购年份
 	s buyiteminvestFee=$p(RowStr,del,44)	//采购项目投入金额
 	s pakacgestate=$p(RowStr,del,45)	//包装完好性
 	s configstate=$p(RowStr,del,46)		//配置相符
 	s filestate=$p(RowStr,del,47)		//随机文件
 	s runningstate=$p(RowStr,del,48)	//运行状况
 	s checkuser=$p(RowStr,del,49)	//验收人
 	s VenderSuggestYear=$p(RowStr,del,50)	//厂家建议年限
 	
 	d CheckOpenCheckInfo
 	
	if ChangeType'="Test"
	{
		s $zt="ErrorSaveOpenCheckList"
		TStart
		k PLIST
	    s PLIST(2)=0
	    s PLIST(3)=equiptypeid
	    s PLIST(4)=purchasetypeid
	    s PLIST(5)=statcatid
	    s PLIST(6)=providerid
	    s PLIST(7)=providerhandler
	    s PLIST(8)=providertel
	    s PLIST(9)=originid
	    s PLIST(10)=""		//FromDeptDR
	    s PLIST(11)=opencheckdate
	    s PLIST(12)=checkdate
	    s PLIST(13)=pakacgestate
	    s PLIST(14)=configstate
	    s PLIST(15)=filestate
	    s PLIST(16)=""		//affixstate
	    s PLIST(17)=runningstate
	    s PLIST(18)=""		//openstate
	    s PLIST(19)=""		//checkresult
	    s PLIST(20)=checkuser
	    s PLIST(21)=status
	    s PLIST(22)=remark 		//remark
	    s PLIST(38)=opencheckno
	    s PLIST(46)="N"
	    
		&SQL(Insert Into SQLUSER.DHC_EQOpenCheckRequest Values :PLIST())
		i SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,"插入设备验收单失败: 设备="_equipname_" SQLCODE="_SQLCODE_" msg="_$g(%msg))
		}
		s OCRRowID=$g(%ROWID)
		
		k PLISTMX
		s PLISTMX(2)=OCRRowID
		s PLISTMX(3)=equipname
		s PLISTMX(4)=equiptypeid
		s PLISTMX(5)=""		//ABCType
		s PLISTMX(6)=modelid
		s PLISTMX(7)=equipcatid
		s PLISTMX(8)=unitid
		s PLISTMX(9)=code
		s PLISTMX(10)=itemid
		s PLISTMX(11)=""	//makedate
		s PLISTMX(12)=countryid
		s PLISTMX(13)=""	//manageleveldr
		s PLISTMX(14)=buytypeid
		s PLISTMX(15)=""	//equiptechleveldr
		s PLISTMX(16)=manufacturerid
		s PLISTMX(17)=quantity
		s PLISTMX(18)=originalfee
		s PLISTMX(19)=""	//netremainfee
		s PLISTMX(20)=limityears
		s PLISTMX(21)=depremethodid
		s PLISTMX(22)=""	//currencydr
		s PLISTMX(23)=""	//memorycode
		s PLISTMX(24)=purchasetypeid
		s PLISTMX(25)=purposetypeid
		s PLISTMX(26)=""	//servicedr
		s PLISTMX(27)=locationid
		s PLISTMX(28)=guaranteenums
		s PLISTMX(29)=statcatid
		s PLISTMX(34)=uselocid
		s PLISTMX(35)=remark
		s PLISTMX(37)=contratno
		s PLISTMX(46)=opencheckdate
		s PLISTMX(47)=checkdate
		s PLISTMX(50)=leavefactorydate
		s PLISTMX(57)=registerno
		s PLISTMX(64)="0"		//sourcetype
		s PLISTMX(65)=itemid	//sourceid
		s PLISTMX(85)=power		//
		s PLISTMX(89)=configlicense
		s PLISTMX(90)=newoldpercent
		s PLISTMX(91)=voltage
		s PLISTMX(92)=electricity
		s PLISTMX(93)=VenderSuggestYear
		s PLISTMX(94)=noticeitem
		s PLISTMX(95)=maintpoint
		s PLISTMX(96)=isbuyitem
		s PLISTMX(97)=buyitemcode
		s PLISTMX(98)=buyitemyear
		s PLISTMX(99)=buyiteminvestFee
		
		
		&SQL(Insert Into SQLUSER.DHC_EQOpenCheckList Values :PLISTMX())
		
		i SQLCODE
		{
			TRollBack
			q ..RetErrorValue(RetStr,"插入设备验收明细失败: 设备="_equipname_" SQLCODE="_SQLCODE_" msg="_$g(%msg))
		}
		s OCLRowID=$g(%ROWID)
		
		s ^DHCEQOpenCheckList(OCLRowID,"EX")=leavefactoryno
		s ^DHCEQOpenCheckList(OCLRowID,"MFInfo")="^"
		
		s SQLCODE=0
		
		s ErrTemp=..InsertFundsInfo(ChangeType,"0^"_OCLRowID_"^"_equipname_"^"_originalfeetotal_"^"_fundsinfo_"^")
		
		i ErrTemp'="OK"
		{
			TRollBack
			q ..RetErrorValue(RetStr,ErrTemp)
		}
		
		TCommit
		q "OK"
	}

 	q:RetStr="" "OK"
	q RetStr
	
ErrorSaveOpenCheckList
	TRollBack
	Set ErrorMsg=$ZE	//得到系统返回的错误消息
	q ..RetErrorValue(RetStr,"验收单保存失败，ErrorMsg"_ErrorMsg)	
		
CheckOpenCheckInfo
	i opencheckno="" d
	.s RetStr=..RetErrorValue(RetStr,"验收单号不能为空: 设备="_equipname)
	e  d
	.s ocrid=$o(^DHCEQOpenCheckRequest(0,"RequestNo"," "_opencheckno,""))
	.i ocrid'="" s RetStr=..RetErrorValue(RetStr,"验收单号已存在, 设备="_equipname_" 验收单号="_opencheckno)
	
	i equipname="" s RetStr=..RetErrorValue(RetStr,"设备名称不能为空: 设备="_equipname)
	
	s uselocid=""
	i useloc'=""  d
	.s uselocid=##Class(web.DHCEQImportDataTool).GetUseLocID(useloc)
	.i uselocid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到科室: 设备="_equipname_" 科室="_useloc)
	
	s equiptypeid=""
	i equiptype'=""  d
	.s equiptypeid=##Class(web.DHCEQImportDataTool).GetEquipTypeID(equiptype)
	.i equiptypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类组: 设备="_equipname_" 设备类组="_equiptype)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类组: 设备="_equipname_" 设备类组="_equiptype)
 	
 	s statcatid=""
 	i statcat'=""  d
	.s statcatid=##Class(web.DHCEQImportDataTool).GetStatCatID(statcat)
	.i statcatid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该设备类型: 设备="_equipname_" 设备类型="_statcat)
 	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设置设备类型: 设备="_equipname)
	
	s equipcatid=""
	i equipcat'=""  d
	.s equipcatid=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,equipcat)
	.i equipcatid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备分类: 设备="_equipname_" 设备分类="_equipcat)
	e  d
	.s RetStr=..RetErrorValue(RetStr,"没有设备分类: 设备="_equipname)
	
	s itemid=""
	i equipname'=""  d
	.s itemid=##Class(web.DHCEQImportDataTool).GetItemID(equipname,equiptypeid) 
	.i itemid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备项: 设备="_equipname)
	
	s modelid=""
	i model'=""  d
 	.s modelid=##Class(web.DHCEQImportDataTool).GetModelID(model,equipname,equiptype)
	.i modelid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到机型: 设备="_equipname_" 机型="_model)

	s unitid=""
	i unit'=""  d
	.s unitid=##Class(web.DHCEQImportDataTool).GetUnitID(unit)
	.i unitid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备单位: 设备="_equipname_" 设备单位="_unit)
	
	s purchasetypeid=""
	i purchasetype'="" d
	.s purchasetypeid=##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCPurchaseType",purchasetype)
 	.i purchasetypeid="" d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到设备申购类型: 设备="_equipname_" 申购类型="_purchasetype)
 	
 	s countryid=""
 	i country'=""  d
	.s countryid=##Class(web.DHCEQImportDataTool).GetCountryID(country)
	.i countryid=""  d
	..s RetStr=..RetErrorValue(RetStr,"没有找到国别: 设备="_equipname_" 国别="_country)

	s manufacturerid=""
 	i manufacturer'=""  d
	.s manufacturerid=##Class(web.DHCEQImportDataTool).GetManuFactoryID(manufacturer)
	.i manufacturerid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到生产厂商: 设备="_equipname_" 生产厂商="_manufacturer)
	
	s providerid=""
	i provider'=""  d
	.s providerid=##Class(web.DHCEQImportDataTool).GetProviderID(provider,1)
	.i providerid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到供应商: 设备="_equipname_" 供应商="_provider)
	
	s purposetypeid=""
 	i purposetype'=""  d
	.s purposetypeid=##Class(web.DHCEQImportDataTool).GetPurposeTypeID(purposetype)
	.i purposetypeid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到该用途: 设备="_equipname_" 用途="_purposetype)
 	
 	s originid=""
	i origin'=""  d
	.s originid=##Class(web.DHCEQImportDataTool).GetOriginID(origin)
	.i originid=""  d 
	..s RetStr=..RetErrorValue(RetStr,"没有找到设备来源: 设备="_equipname_" 来源="_origin)

	s buytypeid=""
 	i buytype'="" d
	.s buytypeid=##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCBuyType",buytype)
 	.i buytypeid="" d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到设备采购方式: 设备="_equipname_" 采购方式="_buytype)

 	s depremethodid=""
 	i depremethod'=""   d
 	.s depremethodid=##Class(web.DHCEQImportDataTool).GetDepreMethodID(depremethod)
 	.i depremethodid=""  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到折旧方法: 设备="_equipname_"  折旧方法"_depremethod)
 	 	
 	s locationid=""
 	i location'=""  d
 	.s locationid=##Class(web.DHCEQImportDataTool).GetLocationID(location)
 	.i locationid=""  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到该存放地点: 设备="_equipname_" 存放地点="_location)
	
 	i fundsinfo'=""  d	//检测资金来源是否存在以及总金额时候等于原值
 	.s ErrTemp=..InsertFundsInfo("Test","0^^"_equipname_"^"_originalfeetotal_"^"_fundsinfo_"^")
 	.i ErrTemp'="OK" s RetStr=..RetErrorValue(RetStr,ErrTemp)
 	
	quit
}

/// czf 2022-09-25
/// 插入资金来源
/// w ##class(web.DHCEQImportData2CSP).InsertFundsInfo("Append","0^23^避孕药具自助发放机^13300^地方财政资金=13300^")
ClassMethod InsertFundsInfo(ChangeType As %String = "", RowStr As %String = "")
{
	s errDesc=""
	s Amount=0,DepreAmount=0
	s del="^"
	
	s sourcetype=$p(RowStr,del,1)
	s sourceid=$p(RowStr,del,2)
	s equipid=""
	i sourcetype="1" s equipid=sourceid
	s checklistdr=""
	i sourcetype="0" s checklistdr=sourceid
	s equipname=$p(RowStr,del,3)
	s amountfee=+$p(RowStr,del,4)
	s fundsstr=$p(RowStr,del,5)
	s depretotalfee=$p(RowStr,del,6)
	
 	i fundsstr'=""  d //检测资金来源是否存在以及总金额时候等于原值
 	.s Amount=0
	.s fundscount=$l(fundsstr,",")
	.f i=1:1:fundscount  d
	..s curfunds=$p(fundsstr,",",i)
	..s fundstype=$p(curfunds,"=",1)
	..s fundsamount=+$p($p(curfunds,"=",2),":",1)
	..s fundsdepre=+$p(curfunds,":",2)  
	..i (fundsamount=0)&&(fundscount=1) s fundsamount=amountfee
	..q:fundsamount=0
	..s Amount=Amount+fundsamount
	..s DepreAmount=DepreAmount+fundsdepre
	..i fundstype'=""  d
	...s fundsid=##Class(web.DHCEQImportDataTool).GetFundsType(fundstype)
	...i fundsid=""  d
	....s errDesc=..RetErrorValue(errDesc,"没有找到该资金来源: 设备="_equipname_" 资金来源="_fundstype)
	..e  d
	...s errDesc=..RetErrorValue(errDesc,"资金来源不能为空: 设备="_equipname)
	..if ChangeType'="Test" d
	...k FTLIST
	...s FTLIST(2)=equipid
	...s FTLIST(3)=fundsid
	...s FTLIST(4)=fundsamount
	...s FTLIST(5)=checklistdr
	...s FTLIST(7)="0"
	...s FTLIST(9)=+$H
	...s FTLIST(10)=$p($H,",",2)
	...s FTLIST(11)="N"
	...s FTLIST(14)=fundsdepre
	...s FTLIST(15)=sourcetype
	...s FTLIST(16)=sourceid
	...&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FTLIST())
	...i SQLCODE  d
	....s errDesc=..RetErrorValue(errDesc,"插入设备资金来源信息失败: 设备="_equipid_" SQLCODE="_SQLCODE)
	.i (+Amount)'=(+amountfee)  d
	..s errDesc=..RetErrorValue(errDesc,"设备资金来源总金额不等于原值: 设备="_equipid_" 资金来源总额="_Amount)
	.i (+DepreAmount'=0)&&((+DepreAmount)'=(+depretotalfee))  d
	..s errDesc=..RetErrorValue(errDesc,"设备资金来源总折旧金额不等于折旧金额: 设备="_equipid_" 资金来源总折旧金额="_DepreAmount)
	q:errDesc="" "OK"
	q errDesc
}

/// czf 2023-03-01
/// 更新台账折旧信息
/// w ##class(web.DHCEQImportData2CSP).UpdateDepreInfo("Append","B004911^3080^616^12^2022-02-12^5^平均年限法")
ClassMethod UpdateDepreInfo(ChangeType As %String = "", RowStr As %String = "")
{
	Set del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	Set no=$Piece(RowStr,del,1)
 	Set EQOriginalFee=$Piece(RowStr,del,2)
 	Set depretotalfee=$Piece(RowStr,del,3)
 	Set depretotalmonth=$Piece(RowStr,del,4)
 	Set deprestartdate=$Piece(RowStr,del,5)
 	Set deprestartdate=$zdh(deprestartdate,3)
 	Set limityearsnum=$Piece(RowStr,del,6)
 	Set depremethod=$Piece(RowStr,del,7)
 	Set deprestatus="true"
 	
 	s depremethodid=""
 	i depremethod'=""   d
 	.s depremethodid=##Class(web.DHCEQImportDataTool).GetDepreMethodID(depremethod)
 	.i depremethodid="" d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到折旧方法: 设备="_no_"  折旧方法"_depremethod)
 	
 	i +depretotalmonth>(limityearsnum*12) s RetStr=..RetErrorValue(RetStr,"已折旧期数不能大于折旧年限：设备="_no)
 	e  i +limityearsnum=0 s RetStr=..RetErrorValue(RetStr,"折旧年限不能为空：设备="_no)
 	
 	i RetStr'="" q RetStr
 	
 	i depremethodid=3 Set deprestatus="false"	//不计提折旧
 	
	Set tmpid=""
	&SQL(Select eq_rowid into :tmpid from SQLUSER.DHC_EQEquip where EQ_No=:no)
	If tmpid'=""
	{
		if ChangeType'="Test"
		{
			
			k PLIST
			s originalfee=$p($g(^DHCEQEquip(tmpid)),"^",27)
			i $fn(EQOriginalFee,"",2)'=$fn(originalfee,"",2) q ..RetErrorValue(RetStr,"设备原值和系统不一致：设备="_no_"原值："_originalfee)
			i +depretotalfee>originalfee q ..RetErrorValue(RetStr,"累计折旧不能大于原值：设备="_no)
			
			s netfee=originalfee-depretotalfee
			s PLIST(36)=depretotalfee
			s PLIST(29)=netfee
			s PLIST(34)=depremethodid
			s PLIST(32)=limityearsnum
			&SQL(Update SQLUSER.DHC_EQEquip Values :PLIST()  where EQ_RowID=:tmpid)
			i SQLCODE q ..RetErrorValue(RetStr,"台账更新失败: no="_no_" SQLCODE="_SQLCODE)
			
			&SQL(Update SQLUSER.DHC_EQFunds set F_DepreTotal=:depretotalfee where F_EquipDR=:tmpid)
			i SQLCODE q ..RetErrorValue(RetStr,"资金来源累计折旧更新失败: no="_no_" SQLCODE="_SQLCODE)
			
			s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",tmpid,""))
			i DepreSetID="" q ..RetErrorValue(RetStr,"折旧设置不存在!no="_no)
			&SQL(Update SQLUSER.DHC_EQDepreSet set DS_Hold1=:deprestartdate,DS_Hold2=:deprestatus,DS_DepreTotal=:depretotalmonth,DS_DepreTotalFee=:depretotalfee  where DS_RowID=:DepreSetID)
			i SQLCODE q ..RetErrorValue(RetStr,"设置设置更新失败: no="_no_" SQLCODE="_SQLCODE)
		}
	}
	else
	{
		Set RetStr=..RetErrorValue(RetStr,"编号不存在DHC_EQEquip:"_no)
	}
	
	Quit:RetStr="" "OK"
	Quit RetStr
}

/// czf 2023-03-27
/// 更新设备分类年限
ClassMethod UpdEquipCatYears(ChangeType As %String = "", RowStr As %String = "")
{
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 	s code=$p(RowStr,del,1),desc=$p(RowStr,del,2)
 	s yearsnum=$p(RowStr,del,3),depremethod=$p(RowStr,del,4)
 	
 	if code="" s RetStr=..RetErrorValue(RetStr,"编码不能为空DHC_EQCEquipeCat:")
 	if desc="" s RetStr=..RetErrorValue(RetStr,"名称不能为空DHC_EQCEquipeCat:")
 	if RetStr'="" q RetStr
 	
 	s ID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",code,0))
 	i ID="" q ..RetErrorValue(RetStr,"编码不存在DHC_EQCEquipeCat:"_code)
 	
 	k PLIST
 	;s PLIST(2) = code
    ;s PLIST(3) = desc
    s PLIST(7) = yearsnum
    
    i depremethod'=""   d
 	.s tmpid=##Class(web.DHCEQImportDataTool).GetDepreMethodID(depremethod)
 	.i tmpid'=""  d
 	..s PLIST(10) = tmpid
 	.e  d
 	..s RetStr=..RetErrorValue(RetStr,"没有找到折旧方法: "_depremethod)
	
	if ChangeType'="Test" d
	.i ID="" d
 	..;&SQL(Insert Into SQLUSER.DHC_EQCequipecat Values :PLIST())
	..;i SQLCODE  s RetStr=..RetErrorValue(RetStr,"插入失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	.e  d
	..&SQL(Update SQLUSER.DHC_EQCequipecat Values :PLIST() where EC_RowID=:ID)
	..i SQLCODE  s RetStr=..RetErrorValue(RetStr,"更新失败: Code="_code_" Desc="_desc_" SQLCODE="_SQLCODE)
	
 	q:RetStr="" "OK"
	q RetStr
}

}
