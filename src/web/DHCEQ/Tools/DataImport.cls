Class web.DHCEQ.Tools.DataImport Extends %RegisteredObject
{

/// 导入数据保存
/// val:导入数据信息串
/// BussType:业务类型 11：验收
/// CurUserID：用户ID
/// Job
/// i：行号
ClassMethod SaveData(val, BussType, CurUserID, Job, i)
{
	s SQLCODE = 0
	s rowid = $p(val,"^",1)
	s PLIST(2) = $p(val,"^",2)
	s PLIST(3) = $p(val,"^",3)
	s PLIST(4) = $p(val,"^",4)
	s PLIST(5) = $p(val,"^",5)
	s PLIST(6) = $p(val,"^",6)
	s PLIST(7) = $p(val,"^",7)
	s PLIST(8) = $p(val,"^",8)
	s PLIST(9) = $p(val,"^",9)
	s PLIST(10) = $p(val,"^",10)
	s PLIST(11) = $p(val,"^",11)
	s PLIST(12) = $p(val,"^",12)
	s PLIST(13) = $p(val,"^",13)
	s PLIST(14) = $p(val,"^",14)
	s PLIST(15) = $p(val,"^",15)
	s PLIST(16) = $p(val,"^",16)
	s PLIST(17) = $p(val,"^",17)
	s PLIST(18) = $p(val,"^",18)
	s PLIST(19) = $p(val,"^",19)
	s PLIST(20) = $p(val,"^",20)
	s PLIST(21) = $p(val,"^",21)
	s PLIST(22) = $p(val,"^",22)
	s PLIST(23) = $p(val,"^",23)
	s PLIST(24) = $p(val,"^",24)
	s PLIST(25) = $p(val,"^",25)
	s PLIST(26) = $p(val,"^",26)
	s PLIST(27) = $p(val,"^",27)
	s PLIST(28) = $p(val,"^",28)
	s PLIST(29) = $p(val,"^",29)
	s PLIST(30) = $p(val,"^",30)
	s PLIST(31) = $p(val,"^",31)
	s PLIST(32) = $p(val,"^",32)
	s PLIST(33) = $p(val,"^",33)
	s PLIST(34) = $p(val,"^",34)
	s PLIST(35) = $p(val,"^",35)
	s PLIST(36) = $p(val,"^",36)
	s PLIST(37) = $p(val,"^",37)
	s PLIST(38) = $p(val,"^",38)
	s PLIST(39) = $p(val,"^",39)
	s PLIST(40) = $p(val,"^",40)
	s PLIST(41) = $p(val,"^",41)
	s PLIST(42) = $p(val,"^",42)
	s PLIST(43) = $p(val,"^",43)
	s PLIST(44) = $p(val,"^",44)
	s PLIST(45) = $p(val,"^",45)
	s PLIST(46) = $p(val,"^",46)
	s PLIST(47) = $p(val,"^",47)
	s PLIST(48) = $p(val,"^",48)
	s PLIST(49) = $p(val,"^",49)
	s PLIST(50) = $p(val,"^",50)
	s PLIST(51) = $p(val,"^",51)
	s PLIST(52) = $p(val,"^",52)
	s PLIST(53) = $p(val,"^",53)
	s PLIST(54) = $p(val,"^",54)
	s PLIST(55) = $p(val,"^",55)
	s Status=0
	s PLIST(58) = Status
	s PLIST(59) = BussType
	s PLIST(60) = CurUserID
	s PLIST(61) = Job
	i rowid=""
	{
		&SQL(insert into sqluser.DHC_EQDataImport values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQDataImport values :PLIST() where DI_RowID=:rowid)
	}
	i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"第"_i_"行数据装载失败!"_$g(%msg))
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// 校验数据
/// w ##class(web.DHCEQ.Tools.DataImport).CheckData(11,1,"")
ClassMethod CheckData(BussType, CurUserID, Job)
{
	s ErrCount=0
	s RowID=0
	for  s RowID=$o(^DHCEQDataImport(RowID)) q:RowID=""  d
	.s DataImportInfo = $g(^DHCEQDataImport(RowID))
	.q:$p(DataImportInfo,"^",61)="Y"	//已执行标志
	.q:BussType'=$p(DataImportInfo,"^",58)
	.q:CurUserID'=$p(DataImportInfo,"^",59)
	.s SQLCODE=0
	.s ErrMsg=""
	.i BussType="11" d
	..d CheckOpenCheck
	.i ErrMsg'="" d
	..s ErrCount=ErrCount+1
	.&SQL(update sqluser.DHC_EQDataImport set Hold56=:ErrMsg where DI_RowID=:RowID)
	.q:SQLCODE'=0
	
	q ErrCount
	
CheckOpenCheck
	s Provider = $p(DataImportInfo,"^",1)
	i Provider = "" s ErrMsg="供应商不能为空!"
	s ProviderHandler = $p(DataImportInfo,"^",2)
	s ProviderTel = $p(DataImportInfo,"^",3)
	s EquipType = $p(DataImportInfo,"^",4)
	s EquipTyepeID = ""
	if EquipType = ""
	{
		i ErrMsg="" s ErrMsg="设备类组不能为空!"
		else  s ErrMsg=ErrMsg_";"_"设备类组不能为空!"
	}
	else
	{
		s EquipTyepeID=##Class(web.DHCEQImportDataTool).GetEquipTypeID(EquipType)
		i EquipTyepeID = ""
		{
			i ErrMsg="" s ErrMsg="没有找到类组:"_EquipType_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到类组:"_EquipType_"!"
		}
	}
	s Name = $p(DataImportInfo,"^",5)
	s MasterItemID = ""
	if Name = ""
	{
		i ErrMsg="" s ErrMsg="设备名称不能为空!"
		else  s ErrMsg=ErrMsg_";"_"设备名称不能为空!"
	}
	else
	{
		s MasterItemID=##Class(web.DHCEQCMasterItem).GetMasterInfoByDesc(Name,EquipTyepeID)
		i MasterItemID = ""
		{
			i ErrMsg="" s ErrMsg="没有找到设备项:"_Name_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到设备项:"_Name_"!"
		}
	}
	s Model = $p(DataImportInfo,"^",6)
	s OriginalFee = $p(DataImportInfo,"^",7)
	if OriginalFee = ""
	{
		i ErrMsg="" s ErrMsg="原值不能为空!"
		else  s ErrMsg=ErrMsg_";"_"原值不能为空!"
	}
	s Quantity = $p(DataImportInfo,"^",8)
	if Quantity = ""
	{
		i ErrMsg="" s ErrMsg="数量不能为空!"
		else  s ErrMsg=ErrMsg_";"_"数量不能为空!"
	}
	s ManuFactory = $p(DataImportInfo,"^",9)
	s Country = $p(DataImportInfo,"^",10)
	i Country '= ""
	{
		s CountryID = ##Class(web.DHCEQImportDataTool).GetCountryID(Country)
		i CountryID = "" 
		{
			i ErrMsg="" s ErrMsg="没有找到国别："_Country_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到国别："_Country_"!"
		}
	}
	s LeaveFactoryNo = $p(DataImportInfo,"^",11)
	s LeaveFactoryDate = $p(DataImportInfo,"^",12)
	s CheckDate = $p(DataImportInfo,"^",13)
	s GuaranteePeriodNum = $p(DataImportInfo,"^",14)
	s ContractNo = $p(DataImportInfo,"^",15)
	s Remark = $p(DataImportInfo,"^",16)
	s Origin = $p(DataImportInfo,"^",17)
	i Origin '= ""
	{
		s OriginID = ##Class(web.DHCEQImportDataTool).GetOriginID(Origin)
		i OriginID = "" 
		{
			i ErrMsg="" s ErrMsg="没有找到设备来源："_Origin_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到设备来源："_Origin_"!"
		}
	}
	s BuyType = $p(DataImportInfo,"^",18)
	i BuyType '= ""
	{
		s BuyTypeID = ##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCBuyType",BuyType)
		i BuyTypeID = "" 
		{
			i ErrMsg="" s ErrMsg="没有找到采购方式："_BuyType_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到采购方式："_BuyType_"!"
		}
	}
	s PurchaseType = $p(DataImportInfo,"^",19)
	i PurchaseType '= ""
	{
		s PurchaseTypeID = ##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCPurchaseType",PurchaseType)
		i PurchaseTypeID = "" 
		{
			i ErrMsg="" s ErrMsg="没有找到申购类别："_PurchaseType_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到申购类别："_PurchaseType_"!"
		}
	}
	s PurposeType = $p(DataImportInfo,"^",20)
	i PurposeType '= ""
	{
		s PurposeTypeID = ##Class(web.DHCEQImportDataTool).GetPurposeTypeID(PurposeType)
		i PurposeTypeID = "" 
		{
			i ErrMsg="" s ErrMsg="没有找到设备用途："_PurposeType_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到设备用途："_PurposeType_"!"
		}
	}
	s UseLoc = $p(DataImportInfo,"^",21)
	i UseLoc '= ""
	{
		s UseLocID = ##Class(web.DHCEQImportDataTool).GetUseLocID(UseLoc)
		i UseLocID = "" 
		{
			i ErrMsg="" s ErrMsg="没有找到使用科室："_UseLoc_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到使用科室："_UseLoc_"!"
		}
	}
	s FileNo = $p(DataImportInfo,"^",22)
	s Expenditures = $p(DataImportInfo,"^",23)
	i Expenditures '= ""
	{
		s ExpendituresID = ##Class(web.DHCEQImportDataTool).GetExpendituresID(Expenditures)
		i ExpendituresID = "" 
		{
			i ErrMsg="" s ErrMsg="没有找到经费来源："_Expenditures_"!"
			else  s ErrMsg=ErrMsg_";"_"没有找到经费来源："_Expenditures_"!"
		}
	}
	
	s Location = $p(DataImportInfo,"^",24)
	s MeasureFlag = $p(DataImportInfo,"^",25)
	s Hold7 = $p(DataImportInfo,"^",26)
	s Hold6 = $p(DataImportInfo,"^",27)
	s Hold2 = $p(DataImportInfo,"^",28)
	s Brand = $p(DataImportInfo,"^",29)
	s Hold1 = $p(DataImportInfo,"^",30)
	s Hold11 = $p(DataImportInfo,"^",31)
	s CheckResult = $p(DataImportInfo,"^",32)
	s ConfigState = $p(DataImportInfo,"^",33)
	s RunningState = $p(DataImportInfo,"^",34)
	s FileState = $p(DataImportInfo,"^",35)
	s PackageState = $p(DataImportInfo,"^",36)
	
	quit
}

/// 保存数据
/// w ##class(web.DHCEQ.Tools.DataImport).ExecuteData()
ClassMethod ExecuteData(BussType, CurUserID, Job, curHospitalID)
{
	s ErrCount=0
	Set $ZT="ERRORExecuteData"
	
	s RowID=0
	for  s RowID=$o(^DHCEQDataImport(RowID)) q:RowID=""  d
	.s DataImportInfo = $g(^DHCEQDataImport(RowID))
	.q:$p(DataImportInfo,"^",61)="Y"	//已执行标志
	.q:BussType'=$p(DataImportInfo,"^",58)
	.q:CurUserID'=$p(DataImportInfo,"^",59)
	.s SQLCODE=0
	.s ErrMsg=""
	.s result=""
	.i BussType="11" d
	..d ImportOpenCheck
	.i ErrMsg'="" d
	..s ErrCount=ErrCount+1
	..&SQL(update sqluser.DHC_EQDataImport set Hold56=:ErrMsg where DI_RowID=:RowID)
	.e  d
	..&SQL(update sqluser.DHC_EQDataImport set ExecuteFlag='Y',BussID=:result,Hold56=NULL where DI_RowID=:RowID)
	.q:SQLCODE'=0
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ErrCount)

ERRORExecuteData 
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
		
ImportOpenCheck
	s Provider = $p(DataImportInfo,"^",1)
	i Provider = "" s ErrMsg="供应商不能为空!"
	s ProviderHandler = $p(DataImportInfo,"^",2)
	s ProviderTel = $p(DataImportInfo,"^",3)
	s EquipType = $p(DataImportInfo,"^",4)
	s EquipTypeID=##Class(web.DHCEQImportDataTool).GetEquipTypeID(EquipType)
	s Name = $p(DataImportInfo,"^",5)
	s MasterItemInfo=##Class(web.DHCEQCMasterItem).GetMasterInfoByDesc(Name,EquipTypeID)
	s Model = $p(DataImportInfo,"^",6)
	s OriginalFee = $p(DataImportInfo,"^",7)
	s Quantity = $p(DataImportInfo,"^",8)
	s ManuFactory = $p(DataImportInfo,"^",9)
	s Country = $p(DataImportInfo,"^",10)
	s CountryID = ##Class(web.DHCEQImportDataTool).GetCountryID(Country)
	s LeaveFactoryNo = $p(DataImportInfo,"^",11)
	s LeaveFactoryDate = $p(DataImportInfo,"^",12)
	s CheckDate = $p(DataImportInfo,"^",13)
	s GuaranteePeriodNum = $p(DataImportInfo,"^",14)
	s ContractNo = $p(DataImportInfo,"^",15)
	s Remark = $p(DataImportInfo,"^",16)
	s Origin = $p(DataImportInfo,"^",17)
	s OriginID = ##Class(web.DHCEQImportDataTool).GetOriginID(Origin)
	s BuyType = $p(DataImportInfo,"^",18)
	s BuyTypeID = ##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCBuyType",BuyType)
	s PurchaseType = $p(DataImportInfo,"^",19)
	s PurchaseTypeID = ##class(web.DHCEQCommonEX).GetIDByDesc("DHCEQCPurchaseType",PurchaseType)
	s PurposeType = $p(DataImportInfo,"^",20)
	s PurposeTypeID = ##Class(web.DHCEQImportDataTool).GetPurposeTypeID(PurposeType)
	s UseLoc = $p(DataImportInfo,"^",21)
	s UseLocID = ##Class(web.DHCEQImportDataTool).GetUseLocID(UseLoc)
	s FileNo = $p(DataImportInfo,"^",22)
	s Expenditures = $p(DataImportInfo,"^",23)
	s ExpendituresID = ##Class(web.DHCEQImportDataTool).GetExpendituresID(Expenditures)
	s Location = $p(DataImportInfo,"^",24)
	s MeasureFlag = $p(DataImportInfo,"^",25)	//计量标志
	s Hold7 = $p(DataImportInfo,"^",26)	//中医标志
	s Hold6 = $p(DataImportInfo,"^",27)	//放射标志
	s Hold2 = $p(DataImportInfo,"^",28)	//注册证号
	s Brand = $p(DataImportInfo,"^",29)	//品牌
	s Hold1 = $p(DataImportInfo,"^",30)	//发票号
	s Hold11 = $p(DataImportInfo,"^",31)	//项目名称
	s CheckResult = $p(DataImportInfo,"^",32)
	s ConfigState = $p(DataImportInfo,"^",33)
	s RunningState = $p(DataImportInfo,"^",34)
	s FileState = $p(DataImportInfo,"^",35)
	s PackageState = $p(DataImportInfo,"^",36)
	
	s combindata=""
	s combindata=combindata_"^"_Name	//Name ;//2
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",2)	//Code;//3
	s combindata=combindata_"^"_PurchaseTypeID
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",3)	//EquipTypeDR; //5
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",5)	//StatCatDR; //6
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",4)	//EquiCatDR; //7
	s combindata=combindata_"^"	//+MemoryCode; //8
	s combindata=combindata_"^"_BuyTypeID	//+BuyTypeDR; //9     //modified by czf 370967
	s combindata=combindata_"^"	//+StoreLocDR; //10
	s combindata=combindata_"^"	//+ABCType; //11
	s combindata=combindata_"^"	//+PackTypeDR; //12
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",7)	//UnitDR; //13
	i Model=""
	{
		s combindata=combindata_"^"
	}
	else
	{
		s ModelID=##class(web.DHCEQCModel).UpdModel(Model,$p(MasterItemInfo,"^",35))
		s combindata=combindata_"^"_ModelID
	}
	s combindata=combindata_"^"_CountryID
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",10)	//CurrencyDR; //16
	s combindata=combindata_"^"_Quantity	 //17
	s combindata=combindata_"^"_PurposeTypeID	 //18
	s combindata=combindata_"^"	//+CurrencyFee; //19
	s val="^"_Provider_"^"_ProviderHandler_"^"_ProviderTel
	s rtn=##class(web.DHCEQForTrak).UpdProvider(val)
	s combindata=combindata_"^"_rtn		//20
	s combindata=combindata_"^"_ProviderHandler	 //21	供方联系人
	s combindata=combindata_"^"_ProviderTel	 //22
	i ManuFactory=""
	{
		s combindata=combindata_"^"
	}
	else
	{
		// MZY0153	3190069		2023-02-20
		s val="^"_ManuFactory_"^^^3"
		s rtn=##class(web.DHCEQForTrak).UpdProvider(val)
		s combindata=combindata_"^"_rtn
	}
	s combindata=combindata_"^"	//+MakeDate; //24
	s combindata=combindata_"^"_LeaveFactoryDate
	s combindata=combindata_"^"	//+ServiceDR; //26
	i (Location="")
	{
		s combindata=combindata_"^"
	}
	else
	{
		s val="^"_Location
		s rtn=##class(web.DHCEQCLocation).UpdLocation(val)
		s combindata=combindata_"^"_rtn
	}
	s combindata=combindata_"^"_GuaranteePeriodNum	
	s combindata=combindata_"^"_OriginalFee	 //29
	s combindata=combindata_"^"	//+NetRemainFee; //30
	s combindata=combindata_"^"_OriginID	 //31
	s combindata=combindata_"^"_UseLocID	 //32
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",32)	//LimitYearsNum; //33
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",33)	//DepreMethodDR; //34
	s combindata=combindata_"^"	//+InstallDate; //35
	s combindata=combindata_"^"	//+InstallLocDR; //36
	s combindata=combindata_"^"	//+DesignWorkLoadNum; //37
	s combindata=combindata_"^"	//+WorkLoadUnitDR; //38
	s combindata=combindata_"^"	//+GuaranteeStartDate; //39
	s combindata=combindata_"^"	//+GuaranteeEndDate; //40
	s combindata=combindata_"^"	//+FromDeptDR; //41
	s combindata=combindata_"^"	//+GuaranteeFlag; //42
	s combindata=combindata_"^"	//+UrgencyFlag; //43
	s MeasureFlag=$case(MeasureFlag,"true":"Y","是":"Y","1":"Y","y":"Y","Y":"Y",:"N")	// MZY0153	3194077,3194098		2023-02-20
	s combindata=combindata_"^"_MeasureFlag	 //44
	s combindata=combindata_"^"	//+MedicalFlag; //45
	s combindata=combindata_"^"	//+TestFlag; //46
	s combindata=combindata_"^"	//+AffixState; //47
	s combindata=combindata_"^"_CheckResult		//+CheckResult; //48
	s combindata=combindata_"^"	//+CheckUser; //49
	s combindata=combindata_"^"_ConfigState		//+ConfigState; //50
	s combindata=combindata_"^"_FileState		//+FileState; //51
	s combindata=combindata_"^"	//+OpenState; //52
	s combindata=combindata_"^"_PackageState		//+PackageState; //53
	s combindata=combindata_"^"	//+RejectReason; //54
	s combindata=combindata_"^"_Remark	 //55
	s combindata=combindata_"^"_RunningState		//+RunningState; //56
	s combindata=combindata_"^"	//+ContractListDR; //57
	s combindata=combindata_"^"_ContractNo	 //58
	s combindata=combindata_"^"_"1"	 //59 CheckTypeDR
	s combindata=combindata_"^"_CheckDate	 //60
	s combindata=combindata_"^"_CheckDate	 //61OpenCheckDate
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",35)	//ItemDR; //62
	s combindata=combindata_"^0"	//+Status; //63
	s combindata=combindata_"^"_LeaveFactoryNo	 //64
	s combindata=combindata_"^"_Hold1	 //+Hold1; //65	InvoiceInfos
	s combindata=combindata_"^"_Hold2		//+Hold2
	s combindata=combindata_"^"	//+Hold3; //67
	i Brand=""
	{
		s combindata=combindata_"^"
	}
	else
	{
		s val="^"_Brand
		s rtn=##class(web.DHCEQCBrand).UpdBrand(val)	// MZY0153	3194077.3194098		2023-02-20
		s combindata=combindata_"^"_rtn		//23
	}
	s combindata=combindata_"^"_ExpendituresID	 //69	经费来源20150819  Mozy0159
	s combindata=combindata_"^"	//+BenefitAnalyFlag;//65
	s combindata=combindata_"^"	//+CommonageFlag;//66
	s combindata=combindata_"^"	//+AutoCollectFlag;//67
	s combindata=combindata_"^0"  //Modify By zx 2020-02-18 BUG ZX0074 验收来源类型	//+HSourceType;//68
	s combindata=combindata_"^"_$p(MasterItemInfo,"^",35)	//SourceID;//69
	s combindata=combindata_"^"	//+WorkLoadPerMonth;//70
	s combindata=combindata_"^"	//+RequestHold1;//76
	s combindata=combindata_"^"_curHospitalID	//+RequestHold2;//77		 MZY0141	2969623,2969850		2022-11-02
	s combindata=combindata_"^"	//+RequestHold3;//78
	s combindata=combindata_"^"	//+RequestHold4;//79
	s combindata=combindata_"^"	//+RequestHold5;//80
	s combindata=combindata_"^"_Name	//CommonName;//81
	s combindata=combindata_"^"	//+ValueType;//82 价值类型
	s combindata=combindata_"^"	//+DirectionsUse;//83 使用方向
	s combindata=combindata_"^"	//+UserDR; //84 UserDR
	s combindata=combindata_"^"	//+AccountShape;  //85 入账形式
	s combindata=combindata_"^"	//+ProjectNo; //86 项目预算编号
	s combindata=combindata_"^"	//+AccountNo;  //87 会计凭证号
	s combindata=combindata_"^"_Hold6    //放射标志 //Modify By zx 2020-02-18 BUG ZX0074
	s combindata=combindata_"^"_Hold7	 //中医标志 //Modify By zx 2020-02-18 BUG ZX0074
	s combindata=combindata_"^"	//+Hold8;
	s combindata=combindata_"^"	//+Hold9;
	s combindata=combindata_"^"	//+Hold10;
	s combindata=combindata_"^"_FileNo
	// MZY0153	3194077,3194098		2023-02-20	增加验收单设备属性
	s EquipAttribute=""
	i MeasureFlag="Y" s EquipAttribute="id1&"
	i Hold6="Y" d
	.i EquipAttribute'="" s EquipAttribute=EquipAttribute_"^"
	.s EquipAttribute=EquipAttribute_"id6&"
	i Hold7="Y" d
	.i EquipAttribute'="" s EquipAttribute=EquipAttribute_"^"
	.s EquipAttribute=EquipAttribute_"id4&"
	s result=##Class(web.DHCEQOpenCheckRequest).SaveData("","",combindata,"2", "", 0, 0, "", "", EquipAttribute)
	if (result<0)
	{
		s ErrMsg="插入验收单失败,错误代码："_result
	}
	quit
}

/// 导入数据显示
/// add by czf 2022-12-12
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.DataImport","GetImportData","11","1","","")
Query GetImportData(BussType As %String = "", CurUserID As %String = "", Job As %String = "", DiffFlag As %String = "") As %Query(ROWSPEC = "DIRowID:%String,Hold1:%String,Hold2:%String,Hold3:%String,Hold4:%String,Hold5:%String,Hold6:%String,Hold7:%String,Hold8:%String,Hold9:%String,Hold10:%String,Hold11:%String,Hold12:%String,Hold13:%String,Hold14:%String,Hold15:%String,Hold16:%String,Hold17:%String,Hold18:%String,Hold19:%String,Hold20:%String,Hold21:%String,Hold22:%String,Hold23:%String,Hold24:%String,Hold25:%String,Hold26:%String,Hold27:%String,Hold28:%String,Hold29:%String,Hold30:%String,Hold31:%String,Hold32:%String,Hold33:%String,Hold34:%String,Hold35:%String,Hold36:%String,Hold56:%String,TDiffFlag:%String")
{
}

ClassMethod GetImportDataExecute(ByRef qHandle As %Binary, BussType As %String = "", CurUserID As %String = "", Job As %String = "", DiffFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s RowID=0
	for  s RowID=$o(^DHCEQDataImport(RowID)) q:RowID=""  d
	.s DataImportInfo = $g(^DHCEQDataImport(RowID))
	.q:$p(DataImportInfo,"^",61)="Y"	//已执行标志
	.q:BussType'=$p(DataImportInfo,"^",58)
	.q:CurUserID'=$p(DataImportInfo,"^",59)
	.q:(DiffFlag=1)&&($p(DataImportInfo,"^",56)="")
	.d ResetVariableGetImportData
	.s DIRowID=RowID
	.s Hold1 = $p(DataImportInfo,"^",1)
	.s Hold2 = $p(DataImportInfo,"^",2)
	.s Hold3 = $p(DataImportInfo,"^",3)
	.s Hold4 = $p(DataImportInfo,"^",4)
	.s Hold5 = $p(DataImportInfo,"^",5)
	.s Hold6 = $p(DataImportInfo,"^",6)
	.s Hold7 = $p(DataImportInfo,"^",7)
	.s Hold8 = $p(DataImportInfo,"^",8)
	.s Hold9 = $p(DataImportInfo,"^",9)
	.s Hold10 = $p(DataImportInfo,"^",10)
	.s Hold11 = $p(DataImportInfo,"^",11)
	.s Hold12 = $p(DataImportInfo,"^",12)
	.s Hold13 = $p(DataImportInfo,"^",13)
	.s Hold14 = $p(DataImportInfo,"^",14)
	.s Hold15 = $p(DataImportInfo,"^",15)
	.s Hold16 = $p(DataImportInfo,"^",16)
	.s Hold17 = $p(DataImportInfo,"^",17)
	.s Hold18 = $p(DataImportInfo,"^",18)
	.s Hold19 = $p(DataImportInfo,"^",19)
	.s Hold20 = $p(DataImportInfo,"^",20)
	.s Hold21 = $p(DataImportInfo,"^",21)
	.s Hold22 = $p(DataImportInfo,"^",22)
	.s Hold23 = $p(DataImportInfo,"^",23)
	.s Hold24 = $p(DataImportInfo,"^",24)
	.s Hold25 = $p(DataImportInfo,"^",25)
	.s Hold26 = $p(DataImportInfo,"^",26)
	.s Hold27 = $p(DataImportInfo,"^",27)
	.s Hold28 = $p(DataImportInfo,"^",28)
	.s Hold29 = $p(DataImportInfo,"^",29)
	.s Hold30 = $p(DataImportInfo,"^",30)
	.s Hold31 = $p(DataImportInfo,"^",31)
	.s Hold32 = $p(DataImportInfo,"^",32)
	.s Hold33 = $p(DataImportInfo,"^",33)
	.s Hold34 = $p(DataImportInfo,"^",34)
	.s Hold35 = $p(DataImportInfo,"^",35)
	.s Hold36 = $p(DataImportInfo,"^",36)
	.s Hold56 = $p(DataImportInfo,"^",56)
	.i Hold56 '= "" s TDiffFlag = 1
	.d OutputRowGetImportData
	Quit $$$OK
	
OutputRowGetImportData
	s Data=$lb(DIRowID,Hold1,Hold2,Hold3,Hold4,Hold5,Hold6,Hold7,Hold8,Hold9,Hold10,Hold11,Hold12,Hold13,Hold14,Hold15,Hold16,Hold17,Hold18,Hold19,Hold20,Hold21,Hold22,Hold23,Hold24,Hold25,Hold26,Hold27,Hold28,Hold29,Hold30,Hold31,Hold32,Hold33,Hold34,Hold35,Hold36,Hold56,TDiffFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariableGetImportData
	s (DIRowID,Hold1,Hold2,Hold3,Hold4,Hold5,Hold6,Hold7,Hold8,Hold9,Hold10,Hold11,Hold12,Hold13,Hold14,Hold15,Hold16,Hold17,Hold18,Hold19,Hold20,Hold21,Hold22,Hold23,Hold24,Hold25,Hold26,Hold27,Hold28,Hold29,Hold30,Hold31,Hold32,Hold33,Hold34,Hold35,Hold36,Hold56,TDiffFlag)=""
	quit
}

ClassMethod GetImportDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetImportDataExecute ]
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

ClassMethod GetImportDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetImportDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveDataList(list)
{
	Set $ZT="ERRORSaveData"
	s SQLCODE=0
	s SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$Length(list,SplitRowCode)
	f i=1:1:Length  q:SQLCODE'=0  d
	.K LIST
	.s valList= $Piece(list,SplitRowCode,i)
	.s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	.s LIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQDataImport",JsonData,.LIST)
	.s Rowid = JsonData.DIRowID
	.i (Rowid="")  d
	..&SQL(Insert Into SQLUSER.DHC_EQDataImport Values :LIST())
	.e  d
	..&SQL(Update SQLUSER.DHC_EQDataImport Values :LIST() where DI_RowID = :Rowid)
	.i SQLCODE=100 Set SQLCODE=0
	.q:SQLCODE'=0
	
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存错误!"_$g(%msg))
	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,0)

ERRORSaveData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

ClassMethod DeleteData(valist)
{
	i valist="" q 0
	s ErrCount=0
	s len=$l(valist,",")
	for i=1:1:len d
	.s RowID=$p(valist,",",i)
	.q:RowID=""
	.&SQL(Delete From SQLUSER.DHC_EQDataImport where DI_RowID = :RowID)
	.i SQLCODE=100 s SQLCODE=0
	.i SQLCODE s ErrCount=ErrCount+1
	
	q ErrCount
}

}
