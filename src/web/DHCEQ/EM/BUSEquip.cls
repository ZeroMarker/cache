/// 名称: web.DHCEQ.EM.BUSEquip
/// 描述: 设备台账管理
/// 编写者：ZX
/// 编写日期: 2018-08-22
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSEquip Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-08-22
/// Description:   解析单条台账信息
/// Table：        DHC_EQEquip
/// Input：        RowID:台账ID
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetOneEquip(3)
ClassMethod GetOneEquip(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneEquip"
	s ObjEquip=##Class(User.DHCEQEquip).%OpenId(RowID)
	s EquipInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjEquip)
	d EquipInfo.%Set("EQModelDR_MDesc",ObjEquip.EQModelDR.MDesc)
    d EquipInfo.%Set("EQEquiCatDR_ECCode",ObjEquip.EQEquiCatDR.ECCode) //added by LMH 20220919 2904739 
	d EquipInfo.%Set("EQEquiCatDR_ECDesc",ObjEquip.EQEquiCatDR.ECDesc)
	d EquipInfo.%Set("EQUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjEquip.EQUnitDR))
	d EquipInfo.%Set("EQItemDR_MIDesc",ObjEquip.EQItemDR.MIDesc)
	d EquipInfo.%Set("EQInstallLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQInstallLocDR))
	d EquipInfo.%Set("EQCountryDR_CTCOUDesc",##class(web.DHCEQCommon).GetTrakNameByID("cou",ObjEquip.EQCountryDR))
	d EquipInfo.%Set("EQManageLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQManageLocDR))
	d EquipInfo.%Set("EQManageLevelDR_MLDesc",ObjEquip.EQManageLevelDR.MLDesc)
	d EquipInfo.%Set("EQUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQUseLocDR))
	d EquipInfo.%Set("EQOriginDR_ODesc",ObjEquip.EQOriginDR.ODesc)
	d EquipInfo.%Set("EQFromDeptDR_FTDDesc",ObjEquip.EQFromDeptDR.FTDDesc)
	d EquipInfo.%Set("EQToDeptDR_FTDDesc",ObjEquip.EQToDeptDR.FTDDesc)
	d EquipInfo.%Set("EQBuyTypeDR_BTDesc",ObjEquip.EQBuyTypeDR.BTDesc)
	d EquipInfo.%Set("EQEquipTechLevelDR_TLDesc",ObjEquip.EQEquipTechLevelDR.TLDesc)
	d EquipInfo.%Set("EQProviderDR_VName",##class(web.DHCEQCommon).GetTrakNameByID("prov",ObjEquip.EQProviderDR))
	d EquipInfo.%Set("EQManuFactoryDR_MFName",ObjEquip.EQManuFactoryDR.VName)		//modified by CZF0103 20200408
	//s EQManuFactoryDR=ObjEquip.EQManuFactoryDRGetObjectId()
	//d EquipInfo.%Set("EQManuFactoryDR_MFName",##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",EQManuFactoryDR))	//modified by CZF0093 2020-03-17
	d EquipInfo.%Set("EQOriginalFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQOriginalFee,""))
	d EquipInfo.%Set("EQNetFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQNetFee,""))
	d EquipInfo.%Set("EQNetRemainFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQNetRemainFee,""))
	d EquipInfo.%Set("EQGroupDR_GRName",ObjEquip.EQGroupDR.GRName)
	d EquipInfo.%Set("EQDepreMethodDR_DMDesc",ObjEquip.EQDepreMethodDR.DMDesc)
	d EquipInfo.%Set("EQDepreTotalFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQDepreTotalFee,""))
	d EquipInfo.%Set("EQWorkLoadUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjEquip.EQWorkLoadUnitDR))
	d EquipInfo.%Set("EQManageUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQManageUserDR))
	d EquipInfo.%Set("EQMaintUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQMaintUserDR))
	d EquipInfo.%Set("EQAppendFeeTotalFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQAppendFeeTotalFee,""))
	d EquipInfo.%Set("EQAddUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQAddUserDR))
	d EquipInfo.%Set("EQUpdateUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQUpdateUserDR))
	d EquipInfo.%Set("EQEquipTypeDR_ETDesc",ObjEquip.EQEquipTypeDR.ETDesc)
	d EquipInfo.%Set("EQPurchaseTypeDR_PTDesc",ObjEquip.EQPurchaseTypeDR.PTDesc)
	d EquipInfo.%Set("EQPurposeTypeDR_PTDesc",ObjEquip.EQPurposeTypeDR.PTDesc)
	d EquipInfo.%Set("EQKeeperDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQKeeperDR))
	d EquipInfo.%Set("EQStoreLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQStoreLocDR))
	//d EquipInfo.%Set("EQServiceDR_SVName",ObjEquip.EQServiceDR.SVName)
	s EQServiceDR=ObjEquip.EQServiceDRGetObjectId()
	d EquipInfo.%Set("EQServiceDR_SVName",##class(web.DHCEQCommon).GetTrakNameByID("cservice",EQServiceDR))	//modified by CZF0093 2020-03-17
	d EquipInfo.%Set("EQLocationDR_LDesc",ObjEquip.EQLocationDR.LDesc)
	d EquipInfo.%Set("EQStatCatDR_SCDesc",ObjEquip.EQStatCatDR.SCDesc)
	d EquipInfo.%Set("EQRentLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQRentLocDR))
	d EquipInfo.%Set("EQUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQUserDR))
	if ObjEquip.EQHold10'="" d EquipInfo.%Set("EQHold10_EDesc",$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",ObjEquip.EQHold10)),"^",2))
	d EquipInfo.%Set("EQAddDepreMonths",$p(##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(RowID),"^",1))  //调整折旧月份数	//modified by czf 1560234 2020-11-05
	d EquipInfo.%Set("EQStatusDisplay",##Class(web.DHCEQEquip).GetEquipStatusDisplay(ObjEquip.EQStatus)) 
	d EquipInfo.%Set("EQGuaranteePeriodNum",ObjEquip.EQGuaranteePeriodNum)
	d EquipInfo.%Set("EQLimitYearsNum",ObjEquip.EQLimitYearsNum)
	d EquipInfo.%Set("EQAdvanceDisFlagDesc",##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(ObjEquip.EQAdvanceDisFlag))
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	d EquipInfo.%Set("EQSelfFundsFlag",SelfFundsFlag)
	s FundsInfo=##Class(web.DHCEQFunds).GetSourceFunds(1,RowID,ObjEquip.EQOriginalFee,SelfFundsFlag)
	d EquipInfo.%Set("EQSelfFundFee",$p(FundsInfo,"^",1))
	d EquipInfo.%Set("EQClassFlag",ObjEquip.EQClassFlag)		//Modify DJ 2019-06-27
	i ObjEquip.EQStoreLocDR'="" d
	.d EquipInfo.%Set("EQHospital",##Class(web.DHCEQCommon).GetHospitalDesc(ObjEquip.EQStoreLocDR))	;Mozy	2019-9-28
	e  d
	.d EquipInfo.%Set("EQHospital","")
	d EquipInfo.%Set("EQRowID",RowID)		//czf 20201018
    d EquipInfo.%Set("EQBrand_BDesc",##class(web.DHCEQCommon).GetTrakNameByID("brand",ObjEquip.EQBrand)) //Add by QW20220531  BUG:QW0162 增加品牌
	///add by0282 ZY20211102
	s EQParentDRNo=""		//czf 2023-02-28
	i ObjEquip.EQParentDR'="" s EQParentDRNo=$p($g(^DHCEQEquip(ObjEquip.EQParentDR)),"^",71)
	d EquipInfo.%Set("EQParentDR_EQNo",EQParentDRNo)
	if (ObjEquip.EQKeeperDR="")
	{
		//d EquipInfo.%Set("EQKeeperDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQKeeperDR))
		if (ObjEquip.EQUseLocDR'="")
		{
			s Locid=ObjEquip.EQUseLocDR
			s tmpid=""
			&SQL(Select LT_RowID into :tmpid from SQLUSER.DHC_EQCLocType where LT_Type='2' and LT_LocDR=:Locid)
			i tmpid'=""
			{
				s TLManageUseDR=$p($g(^DHCEQCCode("DHCEQCLocType",tmpid)),"^",6)
				d EquipInfo.%Set("EQKeeperDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",TLManageUseDR))
			}
		}
	}
	///end by ZY20211102
    ///add by ZY 20220913 2907381、2907386、2907390
    d EquipInfo.%Set("EQAuthorizeDeptDR_ADDesc",ObjEquip.EQAuthorizeDeptDR.ADDesc)
    d EquipInfo.%Set("EQUseSubjectDR_USDesc",ObjEquip.EQUseSubjectDR.USDesc)
    d EquipInfo.%Set("EQBuyModeDR_BMDesc",ObjEquip.EQBuyModeDR.BMDesc)
	
	//Begin add by jyp 2019-02-16   设备属性相关更新
	d EquipInfo.%Set("EQComputerFlag",##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(RowID))
	d EquipInfo.%Set("EQComputerFlagNew",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).GetOneEquipAttributeGroup("3",RowID,"01"))
	d EquipInfo.%Set("EQFirstAidFlag",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",RowID,"21"))
	d EquipInfo.%Set("EQChineseMedicineFlag",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",RowID,"22"))
	d EquipInfo.%Set("EQInspectionFlag",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",RowID,"23"))
	d EquipInfo.%Set("EQRaditionFlagNew",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",RowID,"24"))
	d EquipInfo.%Set("EQVideoFlag",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",RowID,"25"))
	d EquipInfo.%Set("EQRehabilitationFlag",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",RowID,"26"))
	d EquipInfo.%Set("EQSpecialFlag",##CLASS(web.DHCEQ.EM.BUSEquipAttribute).GetOneEquipAttributeGroup("3",RowID,"03"))
	//End add by jyp 2019-02-16     设备属性相关更新
	//s EquipInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJSONToJSONString(EquipInfo)	//Add by JYP 2019-08-26
    //modified by ZY 20221107 Buy:2978130、3019200
    /*
    s Result=##class(web.DHCEQ.EM.BUSMMaintRequest).GetGuaranteeData(RowID)  //add by wy 2021-11-12 更新设备的保修截止日期
    if $p(Result,"^",1)=1 d
    .d EquipInfo.%Set("EQGuaranteePeriodNum",$p(Result,"^",2))
    */
	//add by czf 2022-09-14 begin
	s ConfigInfo=""
	s ConfigNum=##class(web.DHCEQ.EM.BUSConfig).GetEQConfigInfo(RowID)	//附属设备总数
	s parentDR=$p($g(^DHCEQEquip(RowID,"OtherInfo")),"^",24)
	s (parentEQName,parentEQNo)=""
	i parentDR'="" d
	.s parentEQName=$p($g(^DHCEQEquip(parentDR)),"^",1)
	.s parentEQNo=$p($g(^DHCEQEquip(parentDR)),"^",71)
	i +ConfigNum>0 s ConfigInfo="包含"_ConfigNum_"个附属设备"
	e  i parentEQName'="" s ConfigInfo="主设备:"_parentEQName	//_"("_parentEQNo_")"
	d EquipInfo.%Set("EQConfigInfo",ConfigInfo)
	//add by czf 2022-09-14 end
	//add by zyq 2023-02-09 begin
	s MakeOpenCheckUser=""
	s OpenCheckListDR=$p($g(^DHCEQEquip(RowID)),"^",77)
	i OpenCheckListDR'="" d 
	.s OpenCheckRequestDR=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",1)
	.i OpenCheckRequestDR'="" d 
	..s MakeOpenCheckUserDR=$p($g(^DHCEQOpenCheckRequest(OpenCheckRequestDR)),"^",39)
	..s MakeOpenCheckUser=##class(web.DHCEQCommon).GetTrakNameByID("user",MakeOpenCheckUserDR)
	d EquipInfo.%Set("EQMakeOpenCheckUser",MakeOpenCheckUser)
	// MZY0156	3381014		2023-03-24
	i ObjEquip.EQManuFactoryDR'=""
	{
		d EquipInfo.%Set("EQMFAdress",ObjEquip.EQManuFactoryDR.VAddress)
		d EquipInfo.%Set("EQMFTel",ObjEquip.EQManuFactoryDR.VTel)
	}
	else
	{
		d EquipInfo.%Set("EQMFAdress","")
		d EquipInfo.%Set("EQMFTel","")
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERRORGetOneEquip
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

// Modefied by zc0044 2018-11-22 修改入参名称

ClassMethod GetEquipStatusDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "在库"
	i +status=1  q "启用"
	i +status=2  q "停用"
	i +status=3  q "报废"
	i +status=4  q "其他"
	q "未定义"
}

/// Creator：      ZX
/// CreatDate：    2018-09-07
/// Description:   数据保存
/// Input：        data:前台获取字符串 field:value,filed:vale
/// Return：       ID
/// add by zx 2019-07-24 增加操作日志记录
/// modify by zc0054 2019-12-02 保存方法添加入参EquipAttribute
/// modify by Mozy0247 2020-2-17	修正无法保存错误
/// modofied by ZY0263 台帐编辑逻辑有点问题
/// modified by wy 2022-4-28 移动端增加session入参
/// w ##Class(web.DHCEQ.EM.BUSEquip).SaveData("","",1)
ClassMethod SaveData(Data, EquipAttribute As %Library.String = "", User As %Library.String = "", SSLocID As %Library.String = "")
{
	k PLIST,RowID
	s $ZT="ERRORSaveData"
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQEquip",JsonData,.PLIST)
	s RowID = JsonData.%Get("EQRowID")      //modify by jyp 2019-08-26
	s EQLocationDR = JsonData.%Get("EQLocationDR")
	s EQLocationDRLdesc = JsonData.%Get("EQLocationDR_Ldesc")
	
	i (EQLocationDR="")&&(EQLocationDRLdesc'="")
	{
		s LocationInfo=##Class(web.DHCEQ.Plat.CTLocaton).UpdLocation(EQLocationDRLdesc)
		s LocationInfo={}.%FromJSON(LocationInfo)
		i LocationInfo.%Get("SQLCODE")=0 s EQLocationDR=CodeInfo.%Get("Data")
	}
	//i User'="" s user=##Class(web.DHCEQCommon).getMapIDBySource("user",User)		//czf 20201119 微信端信息修改
	i User=""  s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//modefied by zc0091 2020-12-22 user改为User //modified by czf 2020-05-12
	
	TStart
    if RowID'=""
    {
	    s PLIST(73)=EQLocationDR
	    ;无效前判断是否存在维修,报废业务(1,2报废，3,4维修)
	    s EQAdvanceDisFlag=+$p($g(^DHCEQEquip(RowID)),"^",93)
	    i (EQAdvanceDisFlag=1)||(EQAdvanceDisFlag=2)
	    {
		    TROLLBACK
		    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9040","当前设备存在报废未完成单据!")
	    }
	    i (EQAdvanceDisFlag=3)||(EQAdvanceDisFlag=4)
	    {
		    TROLLBACK
		    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9040","当前设备存在维修未完成单据!")
	    }
	    //czf 2023-02-28 begin
		s OldNo=$p($g(^DHCEQEquip(RowID)),"^",71)
		s EQNewNo=OldNo
		s PLIST(72)=EQNewNo
		s EQParentDR=JsonData.EQParentDR	//父设备 
		s EQOldParentDR=$Piece($Get(^DHCEQEquip(RowID,"OtherInfo")),"^",24) //modify by zyq 2023-04-23
		if (EQParentDR'="")&&(EQOldParentDR'=EQParentDR)
		{
			s ParentNo=$p($g(^DHCEQEquip(EQParentDR)),"^",71)
			s prefix=""
			s LastEquipID=$Order(^DHCEQEquip(0,"Parent",EQParentDR,""),-1)	//当前EquipID设备的最后一个附属设备ID
			i LastEquipID="" d
			.s prefix=1
			e  d
			.s prefix=$p($g(^DHCEQEquip(LastEquipID)),"^",71)		;No
			.;s prefix=$p($g(^DHCEQEquip(LastEquipID)),"^",85)		;FileNo
			.s prefix=1+$p(prefix,"-",2)
			s prefix=##class(web.DHCEQCCounter).LPAD(prefix,"0",2)
			s EQNewNo=ParentNo_"-"_prefix
			s PLIST(72)=EQNewNo
		}
		//czf 2023-02-28 end
		&SQL(Update SQLUSER.DHC_EQEquip Values :PLIST() where EQ_RowID = :RowID)
		i SQLCODE=100 s SQLCODE=0
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存数据失败，错误信息:"_$g(%msg)) //modified by LMH 20220913 2815234 当保存失败时修改返回的错误信息
		}
		//czf 2023-02-28 begin
		if (OldNo'=EQNewNo)
		{
			s EQOldObj={}.%Set("EQRowID",RowID).%Set("EQNo",OldNo)
			s EQNewObj={}.%Set("EQNo",EQNewNo)
			s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQEquip","User.DHCEQEquip",RowID,"U",EQNewObj.%ToJSON(),EQOldObj.%ToJSON(),User,"")
			if SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存数据日志失败！"_$g(%msg))
			}
		}
		s ^DHCEQMark("DHCEQEquip",RowID,User,$H)=$g(^DHCEQEquip(RowID))
		//czf 2023-02-28 end
	}
	else
	{
		// Mozy0251	826982		2020-3-2
		s PLIST(53)=User //modefied by zc0091 2020-12-22 改为取User ;##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;EQ_AddUserDR
		s PLIST(54)=+$H			;EQ_AddDate
		s PLIST(55)=$p($H,",",2)	;EQ_AddTime
		//add by wy 2022-4-1 控制简易设备名称类组不重复
		s EQClassFlag = JsonData.%Get("EQClassFlag")
		s EQItemDR= JsonData.%Get("EQItemDR")
		if (EQClassFlag="Y")
		{
			Set tmpid=""
			&SQL(Select EQ_RowID into :tmpid from SQLUSER.DHC_EQEquip where EQ_ItemDR=:EQItemDR and EQ_ClassFlag='Y' and EQ_InvalidFlag='N')
			If (tmpid'="")
			{
			    TROLLBACK
			    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","范类设备重复!")
			}
		}

		&SQL(insert into SQLUSER.DHC_EQEquip Values :PLIST())
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
		}
		s RowID=$g(%ROWID)
		if (PLIST(72)="")&&(RowID'="")
		 {
			s UpdateNo= ##Class(web.DHCEQ.EM.BUSEquip).UpdateEquipNo(RowID,+$H,SSLocID)
		 	i UpdateNo'=0 
		 	{
			 	TROLLBACK
			 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","设备编号生成错误"_UpdateNo)
			}
		 }
	}
	
	/*	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}*/
	
	//add by czf 20200911 档案号保存 CZF0128
	s FileNo=$p($g(^DHCEQEquip(RowID)),"^",85)
	s FileNoSelfFlag=##class(web.DHCEQCommon).GetSysInfo("990059")		//档案号自动生成 0:不启用 1:启用
	i (FileNo="")&&(FileNoSelfFlag=1)
	{
		s UpdFileNo=##Class(web.DHCEQ.EM.BUSEquip).UpdateFileNo(RowID,+$H)
		i UpdFileNo'=0 
	 	{
		 	TROLLBACK
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","档案号自动生成代码执行错误"_UpdFileNo)
		}
	}
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") //modefied by zc0091 2020-12-22 未在帐判断 begin
	i ((","_FacilityEquipType_",")[(","_JsonData.%Get("EQEquipTypeDR")_","))
	{
		///modify by zc0054 2019-12-02 begin 设备属性保存
		s SQLCODE=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(3,RowID,EquipAttribute)
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
		}
		///modify by zc0054 2019-12-02 end 设备属性保存
	}
	//modefied by zc0091 2020-12-22 未在帐判断 end
	;s SQLCODE=##Class(web.DHCEQPlanExecute).SavaOperateInfo("52",RowID)
	s SQLCODE=##Class(web.DHCEQ.EM.BUSRentEquip).SavaOperateLog("52",RowID,"",User) //modefied by zc0091 2020-12-22 user改为User //add by zx 2017-07-24 更换存放表
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	TCommit
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSaveData
	TRollBack
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// modified by wy 2022-4-28 移动端增加session入参
ClassMethod UpdateEquipNo(rowid, curdate, LocID As %Library.String = "")
{
	new eqno
	s eqno =##Class(web.DHCEQ.EM.BUSEquip).GetNextNo(rowid,curdate,LocID)
	i eqno="" q ""
	&SQL(Update SQLUSER.DHC_EQEquip set EQ_No=:eqno Where EQ_RowID=:rowid)
	if SQLCODE q SQLCODE
	q 0
}

/// modified by wy 2022-4-28 移动端增加session入参
ClassMethod GetNextNo(rowid, curdate, LocID As %Library.String = "")
{
	new equiptype,statcat,equipcatdr,equipecatno,storelocdr
	s (equiptype,statcat,equipcatdr,equipecatno,storelocdr)=""
	&SQL(select EQ_EquipTypeDR->ET_Code,EQ_StatCatDR->SC_Code,EQ_EquiCatDR,EQ_StoreLocDR into :equiptype,:statcat,:equipcatdr,:storelocdr from SQLUSER.DHC_EQEquip where EQ_RowID=:rowid)
	i SQLCODE  q ""
	s equipecatno=##Class(web.DHCEQ.EM.BUSEquip).GetEquipeCatCode(equipcatdr)
	///生成编号时，去掉分类编码中的“-”
	s equipecatno=##class(web.DHCEQCommon).Replace(equipecatno,"-","")
	if storelocdr="" s storelocdr=LocID
	s nextno=##class(web.DHCEQCCounter).GetNextNo("DHC_EQEquip",curdate,storelocdr,equiptype,statcat,equipecatno)	
	q nextno
}

ClassMethod GetEquipeCatCode(equipcatdr)
{
	new equipecode,flag
	s equipecode=""
	while((equipecode="")&&(equipcatdr'="")){
		s flag=$p($g(^DHCEQCCode("DHCEQCEquipeCat",equipcatdr)),"^",8)
		if flag="Y"  d 
		.s equipecode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",equipcatdr)),"^",1)
		e  d
		.s equipcatdr=$p($g(^DHCEQCCode("DHCEQCEquipeCat",equipcatdr)),"^",4)
	}
	q equipecode
}

/// Creator：      ZX
/// CreatDate：    2018-09-20
/// Description:   获取附件、图片等信息
/// Input：        Type:数据来源类型 EquipDR:设备ID CheckListDR:验收单明细ID
/// Return：       附件、图片等信息json格式数据
/// w ##Class(web.DHCEQ.EM.BUSEquip).EquipRelatedInfo("","299","")
ClassMethod EquipRelatedInfo(Type As %String = "", EquipDR As %String = "", CheckListDR As %String = "")
{
	//s Result=##Class(web.DHCEQ.Plat.LIBCommon).GetNewJSONObj()  // modify by jyp 2019-08-26
	s Result=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20	//add by csj 20191202 
	s EQParentDR=$p($g(^DHCEQEquip(EquipDR,"OtherInfo")),"^",24)
	//附件信息
	s result=##class(%ResultSet).%New("web.DHCEQAffix:GetAffix")
	d result.Execute(EquipDR,CheckListDR,EQParentDR)	;Mozy	914928	2019-7-11
	s AffixInfo=""
	s AffixNum=0
	while(result.Next()){
		s TName=result.GetDataByName("TPartSpec")
		s TNum=result.GetDataByName("TQuantityNum")
		s TModel=result.GetDataByName("TCurrency")
		//Modify by zx 2020-08-07 BUG ZX0100 附件不显示问题修复
		i TName="" continue
		i AffixInfo'="" s AffixInfo=AffixInfo_"^"
		s AffixInfo=AffixInfo_TName_"&"_TNum_"&"_TModel
		s AffixNum=AffixNum+TNum
	}
	d Result.%Set("AffixInfo",AffixInfo)
	d Result.%Set("AffixNum",AffixNum)
	
	//图片资料
	// add by zx 2019-03-27 BUG:857616 根据权限控制可查看图片 begin
	//s result=##class(%ResultSet).%New("web.DHCEQ.Process.DHCEQPictureList:GetPictureListInfo")
	//d result.Execute("52",EquipDR,"")
	s PicTypeDRs=##Class(web.DHCEQ.Plat.LIBPicture).GetPicTypeBySource("52","0") //add by zx 2019-04-02 需求号:866638
	s result=##class(%ResultSet).%New("web.DHCEQ.Process.DHCEQPicture:GetPicture")
	d result.Execute("52",EquipDR,"^^^^^"_PicTypeDRs_"^^^^^^^^")
	// add by zx 2019-03-27 BUG:857616 根据权限控制可查看图片 end
	s PicInfo=""
	s PicNum=0
	while(result.Next()){
		s TName=result.GetDataByName("TPicName")
		s TNum=result.GetDataByName("TPicNum")  //add by zx 2019-04-02 需求号:866638
		s TModel="张"
		i PicInfo'="" s PicInfo=PicInfo_"^"
		s PicInfo=PicInfo_TName_"&"_TNum_"&"_TModel
		s PicNum=PicNum+TNum
	}
	d Result.%Set("PicInfo",PicInfo)
	d Result.%Set("PicNum",PicNum)
	
	//相关文件
	s result=##class(%ResultSet).%New("web.DHCEQDoc:GetDoc")
	d result.Execute(EquipDR,CheckListDR,EQParentDR)
	s DocInfo=""
	s DocNum=0
	while(result.Next()){
		s TName=result.GetDataByName("TDocName")
		s TNum=result.GetDataByName("TShareNum")	//czf 2022-05-11	
		i TNum="" s TNum="1"
		s TModel="份"
		i DocInfo'="" s DocInfo=DocInfo_"^"
		s DocInfo=DocInfo_TName_"&"_TNum_"&"_TModel
		s DocNum=DocNum+TNum
	}
	d Result.%Set("DocInfo",DocInfo)
	d Result.%Set("DocNum",DocNum)
	
	//保修合同		Mozy	2018-11-20
	s result=##class(%ResultSet).%New("web.DHCEQ.Con.BUSContract:ContractList")	//modified by csj 20191214 类名修改
	d result.Execute("^EquipDR="_EquipDR,"Y")	// Mozy0239		2019-12-17
	s ContractInfo=""
	s ContractNum=0
	while(result.Next()){
		i result.GetDataByName("TRow")'="合计:"
		{
			s TName=result.GetDataByName("TContractName")	// Mozy0239		2019-12-17
			s TNum=result.GetDataByName("TStartDate")_"至"_result.GetDataByName("TEndDate")	//modified by csj 20191214
			s TNum=##Class(web.DHCEQ.Plat.LIBCommon).Replace(TNum,"-","")
			s TRowID=result.GetDataByName("TRowID")  //modified by csj 20191214
			i ContractInfo'="" s ContractInfo=ContractInfo_"^"
			s ContractInfo=ContractInfo_TName_"&"_TNum_"&"_TRowID
			s ContractNum=ContractNum+1
		}
	}
	d Result.%Set("ContractInfo",ContractInfo)
	d Result.%Set("ContractNum",ContractNum)
	
	//配置信息		Mozy	2018-11-25
	s result=##class(%ResultSet).%New("web.DHCEQ.EM.BUSConfig:GetConfig")
	d result.Execute("",2,"","","",EquipDR,1)	//Mozy	976774	2019-8-1
	s ConfigInfo=""
	s ConfigNum=0
	while(result.Next()){
		s TName=result.GetDataByName("TTypeDesc")
		s TNum=result.GetDataByName("TQuantityNum")
		i ConfigInfo'="" s ConfigInfo=ConfigInfo_"^"
		s ConfigInfo=ConfigInfo_TName_"&"_TNum
		s ConfigNum=ConfigNum+1
	}
	d Result.%Set("ConfigInfo",ConfigInfo)
	d Result.%Set("ConfigNum",ConfigNum)
	
	//附属设备		Mozy	2018-11-25
	s result=##class(%ResultSet).%New("web.DHCEQ.EM.BUSConfig:GetEQConfigList")
	d result.Execute(EquipDR)
	s EquipConfigInfo=""
	s EquipConfigNum=0
	while(result.Next()){
		s TName=result.GetDataByName("TName")_"("_result.GetDataByName("TNo")_")"
		s TNum=result.GetDataByName("TQuantity")
		i EquipConfigInfo'="" s EquipConfigInfo=EquipConfigInfo_"^"
		s EquipConfigInfo=EquipConfigInfo_TName_"&"_TNum
		s EquipConfigNum=EquipConfigNum+1
	}
	d Result.%Set("EquipConfigInfo",EquipConfigInfo)
	d Result.%Set("EquipConfigNum",EquipConfigNum)
	
	//设备树		add by zx 2019-01-24
	s result=##class(%ResultSet).%New("web.DHCEQAssociated:Associated")
	d result.Execute(EquipDR,"")
	s TreeInfo=""
	s TreeNum=0
	while(result.Next()){
		s TName=result.GetDataByName("TChildEquip")
		s TNo=result.GetDataByName("TChildEQNo")
		s TNum=1
		i TreeInfo'="" s TreeInfo=TreeInfo_"^"
		s TreeInfo=TreeInfo_TName_"&"_TNo
		s TreeNum=TreeNum+TNum
	}
	d Result.%Set("TreeNum",TreeNum)
	d Result.%Set("TreeInfo",TreeInfo)
	
	//电子资料	 //Modify by zx 2020-02-19 BUG ZX0076
	//Moidefied by zc0071 文件类型类修改 begin
	//s result=##class(%ResultSet).%New("web.DHCEQ.Process.DHCEQAppendFile:GetAppendFile")
	s result=##class(%ResultSet).%New("web.DHCEQ.Plat.CTAppendFile:GetAppendFile")
	//Moidefied by zc0071 文件类型类修改 end
	d result.Execute("52",EquipDR,"")
	s AppendFileInfo=""
	s AppendFileNum=0
	while(result.Next()){
		s TDocName=result.GetDataByName("TDocName")
		s TAppendFileTypeDesc=result.GetDataByName("TAppendFileTypeDesc")
		s TNum=1
		i AppendFileInfo'="" s AppendFileInfo=AppendFileInfo_"^"
		s AppendFileInfo=AppendFileInfo_TAppendFileTypeDesc_"&"_TDocName
		s AppendFileNum=AppendFileNum+TNum
	}
	d Result.%Set("AppendFileNum",AppendFileNum)
	d Result.%Set("AppendFileInfo",AppendFileInfo)
	//s Result=##Class(web.DHCEQ.Plat.LIBCommon).GetJSONToJSONString(Result)	//Add by JYP 2019-08-26
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Result)
}

/// add by lmm 2018-08-16
/// 描述：hisui改造 查询采购计划单
/// 入参：Equip 设备名称
///       VUseLoc 使用科室
///       NeedUseLoc，是否需要使用科室，0：不需要，当UseLoc为空时不限制科室  1：需要，未指定科室则查找不到数据
///       StockStatuType 为空的时候选择出来库房状态为"入库","转移出库"的设备，否则选择出的为设置的状态
///       VBAFlag 检测是否包含效益分析设备 Y:检测 N:不检测
///       QXType:设备查看范围
///       VComputerFlag:计量标记
///       PlanNameDR:保养计划id
///       VProviderDR:供应商id
///       IncludeBussFlag:过滤处于业务单据里的台账数据 1:过滤
/// 	vConfig：空或0包含附属设备，1：仅固定资产 2：仅附属设备 czf 20230228
/// Modify by zx 2020-11-24 SessionIDs 移动端增加会话变量入参
/// MZY0091	2072005		2021-08-26	增加院区信息
/// Modified By QW20211224 增加参数 vData。输出TRemark:%String,TParentDR:%String
/// czf 9.0之前版本入参最多16个，后续新增参数在vData中解析
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSEquip","GetShortEquip","","","","","","","N","","","","","","","","","SSLocID=^SSGroupID=^SSUserID=^EquipAttribute=^vAllInFlag=Y^MRSourceType=1")
Query GetShortEquip(Equip, VUseLoc As %String = "", NeedUseLoc, StockStatuType As %String = "", VBAFlag As %String = "", QXType As %String = "", VComputerFlag As %String = "", PlanNameDR As %String = "", VProviderDR As %String = "", IncludeBussFlag As %String = "", FacilityFlag As %String = "", VModelDR As %String = "", VEquipTypeDR As %String = "", VNo As %String = "", vContractListDR As %String = "", vData As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TUseLoc:%String,TNo:%String,TLeaveFactoryNo:%String,TUseLocDR:%String,TModelDR:%String,TModel:%String,TEquipTypeDR:%String,TEquipType:%String,TManuFactoryDR:%String,TManuFactory:%String,TUnitDR:%String,TUnit:%String,TOriginalFee:%String,TFileNo:%String,TItemDR:%String,TProviderDR:%String,TProvider:%String,TTransAssetDate:%String,TClassFlag:%String,TDepreTotalFee:%String,TNetFee:%String,TStatCat:%String,TStatCatDR:%String,TEquipCat:%String,TEquipCatDR:%String,TOrigin:%String,TOriginDR:%String,TStartDate:%String,TDepreMethod:%String,TDepreMethodDR:%String,TLimitYearsNum:%String,TStoreLocDR:%String,TStoreLoc:%String,THospital:%String,TRemark:%String,TParentDR:%String")
{
}

ClassMethod GetShortEquipExecute(ByRef qHandle As %Binary, Equip As %String, VUseLoc As %String = "", NeedUseLoc, StockStatuType As %String = "", VBAFlag As %String = "", QXType As %String = "", VComputerFlag As %String = "", PlanNameDR As %String = "", VProviderDR As %String = "", IncludeBussFlag As %String = "", FacilityFlag As %String = "", VModelDR As %String = "", VEquipTypeDR As %String = "", VNo As %String = "", vContractListDR As %String = "", vData As %String = "") As %Status
{
 	new repid, index,rowid
 	new passed
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s (SourceType,SourceID)=""				 //modefied by zc 2017-02-23  begin
	i PlanNameDR'="" d
	.s SourceType = $p($g(^DHCEQMaintPlan(PlanNameDR)),"^",3)
	.s SourceID = $p($g(^DHCEQMaintPlan(PlanNameDR)),"^",4)		 //modefied by zc 2017-02-23  end
	s Equip=##Class(web.DHCEQCommon).UnEscape(Equip)
	s Equip=$ZCONVERT(Equip,"U")
	
	//Modify by zx 2020-11-24 移动端会话变量处理 //add by wy 2022-4-14 移动端会话变量合并到vData 
	s SSLocID=##class(web.DHCEQCommon).GetDataByName(vData,"SSLocID")
	s SSGroupID=##class(web.DHCEQCommon).GetDataByName(vData,"SSGroupID")
	s SSUserID=##class(web.DHCEQCommon).GetDataByName(vData,"SSUserID")
	s vConfig=##class(web.DHCEQCommon).GetDataByName(vData,"vConfig")
	//Modify by zx 2021-11-11 移动端机型描述参数处理
	/// Modified By QW20211224 begin 
 	Set EquipAttribute=##class(web.DHCEQCommon).GetDataByName(vData,"EquipAttribute")
 	Set vAIncludeFlag=##class(web.DHCEQCommon).GetDataByName(vData,"vAIncludeFlag")
 	if vAIncludeFlag="" s vAIncludeFlag="Y"
 	Set vAllInFlag=##class(web.DHCEQCommon).GetDataByName(vData,"vAllInFlag")
 	if vAllInFlag="" s vAllInFlag="N"
	if vAllInFlag="N"
	{
		i ((NeedUseLoc=1)&&(VUseLoc="")) Quit $$$OK
		i (Equip="")&&(VModelDR="")&&(VEquipTypeDR="")&&(VUseLoc="")&&(VNo="")&&(VUseLoc="") Quit $$$OK
	}
	/// Modified By QW20211224 end
    Set MRSourceType=##class(web.DHCEQCommon).GetDataByName(vData,"MRSourceType")  //add by wy 2022-4-14 取维修设备类型SourceType
	
	s paramModelDR=$p(VModelDR,"^",1)
	s paramModel=$p(VModelDR,"^",2)
	
	i (Equip'="")&&(VModelDR="")&&(VEquipTypeDR="")&&(VNo="")&&$D(^DHCEQEquip(0,"No",Equip))  d
	.s rowid=$o(^DHCEQEquip(0,"No",Equip,0))
	.d BuildDataGetShortEquip
	e  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(rowid))	q:rowid=""  d
	..s NewEQCode=$p($g(^DHCEQEquip(rowid)),"^",6)
	..s NewName=$p($g(^DHCEQEquip(rowid)),"^",1)
	..s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	..s No=$p($g(^DHCEQEquip(rowid)),"^",71)
	..s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	..s FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	..q:($ZCONVERT(No,"U")'[Equip)&&($ZCONVERT(NewEQCode,"U")'[Equip)&&($ZCONVERT(NewName,"U")'[Equip)&&($ZCONVERT(LeaveFactoryNo,"U")'[Equip)&&($ZCONVERT(MemoryCode,"U")'[Equip)&&($ZCONVERT(FileNo,"U")'[Equip)
	..d BuildDataGetShortEquip
	Quit $$$OK
BuildDataGetShortEquip
	d ResetVariablesGetShortEquip
	s RowID = rowid
	d CheckDataGetShortEquip
	i passed=0 q
	q:(VNo'="")&&(No'[VNo)  //add by lmm 2018-10-28
	;s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	s ABCType = $p($g(^DHCEQEquip(rowid)),"^",2)
	s ModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	q:(paramModelDR'="")&&(paramModelDR'=ModelDR)  //add by lmm2018-10-28
	i ModelDR '=""  d
	.s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	s ItemDR = $p($g(^DHCEQEquip(rowid)),"^",7)  //add by wy 2017-9-27
	s EquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)
	i EquiCatDR '=""  d
	.s EquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquiCatDR)),"^",2)
	s EquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63) //add by zx 2015-01-16
	q:(VEquipTypeDR'="")&&(VEquipTypeDR'=EquipTypeDR)  //add by lmm2018-10-28
	i EquipTypeDR '="" d
	.s EquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	s UnitDR = $p($g(^DHCEQEquip(rowid)),"^",5)
	i UnitDR '=""  d
	.s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	;s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	;s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	s InstallLocDR = $p($g(^DHCEQEquip(rowid)),"^",8)
	i InstallLocDR '=""  d
	.s InstallLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",InstallLocDR)
	s InstallDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",9),"date")
	;s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	s LeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",11),"date")
	s OpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",12),"date")
	s CheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",13),"date")
	s MakeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",14),"date")
	//s ComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15) //modify by jyp 2019-09-01   设备属性相关调整
	//modify by lmm 2020-05-19 强检设备属于计量设备
	s ComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",rowid)
	//s ComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(rowid)    //modify by jyp 2019-09-01
	q:(VComputerFlag="Y")&(VComputerFlag'=ComputerFlag)
	s CountryDR = $p($g(^DHCEQEquip(rowid)),"^",16)
	i CountryDR '=""  d
	.s Country =##class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR)
	s ManageLocDR = $p($g(^DHCEQEquip(rowid)),"^",17)
	i ManageLocDR '=""  d
	.s ManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR) ; ##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR)	
	s ManageLevelDR = $p($g(^DHCEQEquip(rowid)),"^",18)
	i ManageLevelDR '=""  d
	.s ManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",ManageLevelDR)),"^",2)
	//s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	i UseLocDR '=""  d
	.s UseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	s OriginDR = $p($g(^DHCEQEquip(rowid)),"^",20)
	i OriginDR '=""  d
	.s Origin = $p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	s FromDeptDR = $p($g(^DHCEQEquip(rowid)),"^",21)
	i FromDeptDR '=""  d
	.s FromDept = ##class(web.DHCEQCommon).GetTrakNameByID("todept",FromDeptDR)  //modified by wy 20200928 1547435
	s ToDeptDR = $p($g(^DHCEQEquip(rowid)),"^",22)
	i ToDeptDR '=""  d
	.s ToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",ToDeptDR)),"^",2)
	s BuyTypeDR = $p($g(^DHCEQEquip(rowid)),"^",23)
	i BuyTypeDR '=""  d
	.s BuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",BuyTypeDR)),"^",2)
	s EquipTechLevelDR  = $p($g(^DHCEQEquip(rowid)),"^",24)
	s ProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	i ProviderDR '=""  d
	.s Provider =##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	s ManuFactoryDR = $p($g(^DHCEQEquip(rowid)),"^",26)
	i ManuFactoryDR '=""  d
	.s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1) //CZF0093
	s OriginalFee = $p($g(^DHCEQEquip(rowid)),"^",27)
	s NetFee = $p($g(^DHCEQEquip(rowid)),"^",28)
	s NetRemainFee = $p($g(^DHCEQEquip(rowid)),"^",29)
	s GroupDR = $p($g(^DHCEQEquip(rowid)),"^",30)
	i GroupDR '=""  d
	.s Group = $p($g(^DHCEQGroup(GroupDR)),"^",2)
	s LimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	s ContractListDR = $p($g(^DHCEQEquip(rowid)),"^",32)
	q:(vContractListDR'="")&&(vContractListDR'=ContractListDR)  //add by lmm 2020-04-28
	i ContractListDR '=""  d
	.s ContractList = $p($g(^DHCEQContractList(ContractListDR)),"^",1)
	s DepreMethodDR = $p($g(^DHCEQEquip(rowid)),"^",33)
	i DepreMethodDR '=""  d
	.s DepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	s Remark = $p($g(^DHCEQEquip(rowid)),"^",34)
	s DepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
	s DesignWorkLoadNum = $p($g(^DHCEQEquip(rowid)),"^",36)
	s WorkLoadUnitDR = $p($g(^DHCEQEquip(rowid)),"^",37)
	i WorkLoadUnitDR '=""  d
	.s WorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadUnitDR)
	s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	s ManageUserDR = $p($g(^DHCEQEquip(rowid)),"^",39)
	i ManageUserDR '=""  d
	.s ManageUser =##class(web.DHCEQCommon).GetTrakNameByID("user",ManageUserDR)
	s MaintUserDR = $p($g(^DHCEQEquip(rowid)),"^",40)
	i MaintUserDR '=""  d
	.s MaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",MaintUserDR)
	s ContactUser = $p($g(^DHCEQEquip(rowid)),"^",41)
	s ContactMode = $p($g(^DHCEQEquip(rowid)),"^",42)
	s AppendFeeTotalFee = $p($g(^DHCEQEquip(rowid)),"^",43)
	s StartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",44),"date")
	s TransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")
	s GuaranteeFlag = $p($g(^DHCEQEquip(rowid)),"^",46)
	s InputFlag = $p($g(^DHCEQEquip(rowid)),"^",47)
	s TestFlag = $p($g(^DHCEQEquip(rowid)),"^",48)
	s MedicalFlag = $p($g(^DHCEQEquip(rowid)),"^",49)
	s GuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",50),"date")
	s GuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",51),"date")
	s AddUserDR = $p($g(^DHCEQEquip(rowid)),"^",52)
	i AddUserDR '=""  d
	.s AddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",AddUserDR)
	s AddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",53),"date")
	s AddTime = $p($g(^DHCEQEquip(rowid)),"^",54)
	s UpdateUserDR = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",55),"date")
	i UpdateUserDR '=""  d
	.s UpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",UpdateUserDR)
	s UpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",56),"date")
	s UpdateTime = $p($g(^DHCEQEquip(rowid)),"^",57)
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	;s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	s KeeperDR = $p($g(^DHCEQEquip(rowid)),"^",66)
	i KeeperDR '=""  d
	.s Keeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",KeeperDR)
	s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i StoreLocDR '=""  d
	.s StoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	s StartDepreMonth = $p($g(^DHCEQEquip(rowid)),"^",68)
	s ServiceDR = $p($g(^DHCEQEquip(rowid)),"^",69)
	i ServiceDR '=""  d
    .s Service = ##Class(web.DHCEQCommon).GetTrakNameByID("service",ServiceDR) //$p($g(^DHCEQCCode("DHCEQCService",ServiceDR)),"^",1) //CZF0093 modify by zyq 2022-11-09
	s InStockListDR = $p($g(^DHCEQEquip(rowid)),"^",70)
	i InStockListDR '=""  d
	.s InStockList = $p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	;s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	s LocationDR = $p($g(^DHCEQEquip(rowid)),"^",72)
	s GuaranteePeriodNum = $p($g(^DHCEQEquip(rowid)),"^",73)
	s StatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	i StatCatDR'="" d
	.s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	Set FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)	//20150819  Mozy0159
	s TClassFlag=$p($g(^DHCEQEquip(rowid)),"^",83)	//Modify DJ 2019-06-27
	// MZY0091	2072005		2021-08-26	增加院区信息
	Set HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(StoreLocDR)
	i HospitalDR'="" s Hospital=$Piece($Get(^CT("HOSP", HospitalDR)),"^",2)
	// Add By QW20211224 增加输出TRemark,TParentDR
	s TRemark=$p($g(^DHCEQEquip(rowid)),"^",34)
	s TParentDR=$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",24)
	d OutputRowGetShortEquip
	quit
OutputRowGetShortEquip
	s Data=$lb(Name,RowID,UseLoc,No,LeaveFactoryNo,UseLocDR,ModelDR,Model,EquipTypeDR,EquipType,ManuFactoryDR,ManuFactory,UnitDR,Unit,OriginalFee,FileNo,ItemDR,ProviderDR,Provider,TransAssetDate,TClassFlag,DepreTotalFee,NetFee,StatCat,StatCatDR,EquiCat,EquiCatDR,Origin,OriginDR,StartDate,DepreMethod,DepreMethodDR,LimitYearsNum,StoreLocDR,StoreLoc,Hospital,TRemark,TParentDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetShortEquip
	s (Name,ABCType,ModelDR,EquiCatDR,UnitDR,Code,Desc,InstallLocDR,InstallDate,LeaveFactoryNo,LeaveFactoryDate,OpenCheckDate,CheckDate,MakeDate,ComputerFlag,CountryDR,ManageLocDR,ManageLevelDR,UseLocDR,OriginDR,FromDeptDR,ToDeptDR,BuyTypeDR,EquipTechLevelDR ,ProviderDR,ManuFactoryDR,OriginalFee,NetFee,NetRemainFee,GroupDR,LimitYearsNum,ContractListDR,DepreMethodDR,Remark,DepreTotalFee,DesignWorkLoadNum,WorkLoadUnitDR,Status,ManageUserDR,MaintUserDR,ContactUser,ContactMode,AppendFeeTotalFee,StartDate,TransAssetDate,GuaranteeFlag,InputFlag,TestFlag,MedicalFlag,GuaranteeStartDate,GuaranteeEndDate,AddUserDR,AddDate,AddTime,UpdateUserDR,UpdateDate,UpdateTime,Model,EquiCat,Unit,InstallLoc,Country,ManageLoc,ManageLevel,UseLoc,Origin,FromDept,ToDept,BuyType,Provider,ManuFactory,Group,ContractList,DepreMethod,WorkLoadUnit,ManageUser,MaintUser,AddUser,UpdateUser,FileNo,ItemDR,TClassFlag,Hospital,TRemark,TParentDR)=""
	quit
CheckDataGetShortEquip
	s passed=1
	s ProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	i (VProviderDR'="")&&(VProviderDR'=ProviderDR) s passed=0	//Add By DJ  2017-04-10 360838
	i passed=0 q
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag'="N" s passed=0
	i passed=0 q
	i (##Class(web.DHCEQCommon).CheckManageLimit(SSUserID,SSGroupID,"","","","","",rowid)) s passed=0
	i passed=0 q
	;s BAFlag=$p($g(^DHCEQEquip(rowid)),"^",81)
	;i (VBAFlag'="")&&(BAFlag'=VBAFlag) s passed=0
	i (VBAFlag="Y") d
	.s passed=##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)
	i passed=0 q
	s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	//s ComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15)		//Add By DJ 2017-02-21 begin    //modify by jyp 2019-09-01   设备属性相关调整
	//modify by lmm 2020-05-19 强检设备属于计量设备
	s ComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",rowid)
	//s ComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(rowid)    //modify by jyp 2019-09-01   设备属性相关调整
	i (VComputerFlag'="")&&(ComputerFlag'=VComputerFlag) s passed=0
	i passed=0 q		//Add By DJ 2017-02-21
	s EquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipType'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,SSGroupID,"",FacilityFlag)) s passed=0
	i passed=0 q
	//add by wy 2022-4-18 区分简易设备和泛类设备
	s TClassFlag=$p($g(^DHCEQEquip(rowid)),"^",83)
	i TClassFlag="" s TClassFlag="N"
	if (+MRSourceType=2)&&(TClassFlag'="N") s passed=0
	i passed=0 q
	if (+MRSourceType=3)&&(TClassFlag'="Y") s passed=0
	i passed=0 q
	i ((IncludeBussFlag=1)&(##Class(web.DHCEQEquip).CheckEquipInBussType(rowid,31)=1)) s passed=0      //modefied by zc 2017-02-23  begin
	i passed=0 q
	i ((IncludeBussFlag=1)&(##Class(web.DHCEQEquip).CheckEquipInBussType(rowid,34)=1)) s passed=0
	i passed=0 q
	i (PlanNameDR'="")&&(SourceType=1)&&($p($g(^DHCEQEquip(rowid)),"^",4)'=SourceID) s passed=0
	i passed=0 q
	i (PlanNameDR'="")&&(SourceType=2)&&($p($g(^DHCEQEquip(rowid)),"^",7)'=SourceID) s passed=0
	i passed=0 q
	i (PlanNameDR'="")&&(SourceType=3)&&(rowid'=SourceID) s passed=0
	i passed=0 q	
	s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	Set FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)	//20150819  Mozy0159
	i (Equip'="")&&(($ZCONVERT(Name,"U")'[Equip)&($ZCONVERT(LeaveFactoryNo,"U")'[Equip)&(RowID'=Equip)&($ZCONVERT(MemoryCode,"U")'[Equip)&($ZCONVERT(No,"U")'[Equip)&($ZCONVERT(Code,"U")'[Equip)&($ZCONVERT(FileNo,"U")'[Equip))   d
	.s passed=0
	i passed=0 q
	s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	i ((Status="3")||(Status="4")) d
	.s passed=0
	s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i StoreLocDR'=""  d
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR,SSLocID,SSGroupID)))  d 
	..s passed=0
	i passed=0 q
	i (VUseLoc'="")&&(+FacilityFlag=0)
	{
		i ((Status="0")||(Status="2"))
			{	if (VUseLoc'=StoreLocDR) s passed=0}
		elseif  (VUseLoc'=UseLocDR) 
			{	s passed=0}
	}
	i ((+FacilityFlag=1)&&(VUseLoc'="")&&(StoreLocDR'="")&&(VUseLoc'=StoreLocDR)&&(+MRSourceType'=3)) s passed=0 //modified by zyq 2023-01-10
	i passed=0 q
	s StockStatus = $p($g(^DHCEQEquip(rowid)),"^",60)
	i StockStatuType="" d
	.i ((StockStatus="0")||(StockStatus="3")) s passed=0
	e  d
	.s Flag=##class(web.DHCEQBuyRequest).StringIsIn(StockStatuType,StockStatus)
	.i Flag="N" s passed=0
	;Add By QW20211224 增加设备属性 begin
	if EquipAttribute'=""
	{
		i ##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",rowid,EquipAttribute)="0"
		{ 
			if (vAIncludeFlag="Y") s passed=0
			
		}
		else{
			if (vAIncludeFlag="N") s passed=0
		}
	}
	i passed=0 q
	;Add By QW20211224 增加设备属性 end
	s THold3=$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",26)
	i (vConfig=1)&&(THold3'="") s passed=0		//仅固定资产
	i passed=0 q
	i (vConfig=2)&&(THold3="") s passed=0		//仅附属设备
	i passed=0 q
	
	quit
}

ClassMethod GetShortEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortEquipExecute ]
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

ClassMethod GetShortEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0158	3467100,3467101		2023-04-23	增加经费来源
/// modified by ZY 20220928 增加输出字段，修改global节点
/// MZY0125 2637708     2022-06-08  追加输出列分摊金额
/// Modified by JYP0019 台账添加job对多用户进行限制
/// Mozy	754550	2018-12-18	增加TConfigFlag输出
/// Modefied by zc0044 2018-11-22 将GetEquipList写入web.DHCEQ.EM.BUSEquip这个类里
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSEquip","GetEquipList","^No=^Name=^CommonName=^EquipCatDR=^Code=^UseLocDR=^IncludeFlag=1^MinValue=^MaxValue=^FundsTypeDR=^LocationDR=^BeginInStockDate=^EndInStockDate=2022-12-01^EquipTypeDR=^StatCatDR=^ProviderDR=^ManuFactoryDR=^Status=^InStockNo=^FileNo=^ContractNo=^InvoiceNo=^StoreMoveNo=^QXType=0^IsDisused=N^IsOut=N^BeginDisuseDate=^EndDisuseDate=^BeginOutDate=^EndOutDate=^OriginDR=^PurchaseTypeDR=^PurposeTypeDR=^Chk=^CheckRentFlag=0^LeaveFactoryNo=^ConditionLimit=1^LocIncludeFlag=1^BeginTransAssetDate=^EndTransAssetDate=^EndNo=^AdvanceDisFlag=^EquipAttributeString=^HospitalDR=^OldNo=^ModelDR=^StandardItemDR=^EquipAttributeStringCat=^AppendFileInclude=^UseLocDRStr=^FilterFlag=Y","","1132")
/// Modify By zx 2020-02-20 BUG ZX0076 数字改为Float用于列排序
/// Modify by mwz 2021-06-29 增加打印操作记录：TOperateInfo
/// modify by zyq 2023-02-09 增加验收制单人：TMakeOpenCheckUser
/// "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TServiceHandler:%String,TServiceTel:%String,TStatCatDR:%String,TStatCat:%String,TModelDR:%String,TEquiCatDR:%String,TUnitDR:%String,TCountryDR:%String,TManageLocDR:%String,TManageLevelDR:%String,TWorkLoadUnitDR:%String,TUseLocDR:%String,TOriginDR:%String,TFromDeptDR:%String,TToDeptDR:%String,TBuyTypeDR:%String,TEquipTechLevelDR:%String,TProviderDR:%String,TManuFactoryDR:%String,TKeeperDR:%String,TEquipTypeDR:%String,TPurchaseTypeDR:%String,TPurposeTypeDR:%String"
Query GetEquipList(Data As %String, ReadOnly, Ejob) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TManuFactoryNo:%String,TManuFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%Float,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TLocation:%String,TGuaranteePeriodNum:%String,TStatCatDR:%String,TStatCat:%String,TFundsFee:%String,TFileNo:%String,TRentLocDR:%String,TRentStatus:%String,TFaultStatus:%String,TDisuseDate:%String,TAccountNo:%String,Thold6:%String,Thold7:%String,Thold8:%String,Thold9:%String,Thold10:%String,TAdvanceDisFlag:%String,TInStockNo:%String,TCommonName:%String,TFundsInfo:%String,TPayNo:%String,TUnusualRemark:%String,TRow:%String,TContractNo:%String,TBackColor:%String,TStartDateFlag:%String,THasDoc:%String,THasFile:%String,TReciveDate:%String,TConfigFlag:%String,TCurDepreFee:%String,TDepreMonths:%String,TReDepreMonths:%String,THospital:%String,FFee1:%String,FFee2:%String,FFee3:%String,FFee4:%String,TOperateInfo:%String,_parentId:%String,TOutToDept:%String,TWorkLoadNum:%String,THold5:%String,TConfigLicense:%String,TNewOldPercent:%String,TPower:%String,TVoltage:%String,TElectriccurrent:%String,TNote:%String,TMaintNote:%String,THold16:%String,THold17:%String,THold18:%String,THold19:%String,THold20:%String,TAuthorizeDept:%String,TUseSubject:%String,TBuyMode:%String,TAccountDate:%String,TIdleFlag:%String,TieUpInfo:%String,TFinaceItem:%String,TMakeOpenCheckUser:%String,TManageCat:%String,TSMLRemark:%String,THold10EDesc:%String")
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, vData As %String, ReadOnly, Ejob) As %Status
{
	s gnum=1
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	new repid, index,rowid,vStoreLocDR,TotalNum,TotalFee,TTotalFundsFee
 	Set TotalNum=0
 	Set TotalFee=0
 	Set TTotalFundsFee=0
 	Set (TotalNetFee,TotalNetRemainFee,TotalDepreTotalFee)=0
 	// 附属设备合计		MZY0125	2637708,2637710		2022-06-08
 	Set CTotalNum=0
 	Set CTotalFee=0
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	
 	//add by CZF0097 2020-03-23 begin
	;当前查询条件
	s PreDataFlag=0,ListNum=1
	//s EquipListPage=$g(%request.Data("page",1)) //modified by czf 1325738 
	//s EquipListRows=$g(%request.Data("rows",1))
	//modified by CZF0108 2020-05-12
	//若对Equip表做过修改，则清空^DHCEQEquipGetEquipList("GetEquipList")数据，重新查询
	i $d(^TempDHCEQGetEquipList("RecordTime")) k ^DHCEQEquipGetEquipList("GetEquipList")
	s ^DHCEQEquipGetEquipList("GetEquipList","Data",curuser,Ejob)=""
	//modify by lmm 2020-05-11 1313211 //modified by czf 1325738
	s ^DHCEQEquipGetEquipList("GetEquipList","Cur",curuser,Ejob)=vData
	i $d(^DHCEQEquipGetEquipList("GetEquipList","Pre",curuser,Ejob)) {
		;上次查询条件
		s EquFlag=(^DHCEQEquipGetEquipList("GetEquipList","Pre",curuser,Ejob)=^DHCEQEquipGetEquipList("GetEquipList","Cur",curuser,Ejob)) 
		i (EquFlag=1) d		 //modified by czf 20200522
		.d OutPutPreData
		.s PreDataFlag=1
		e  d
		.k ^DHCEQEquipGetEquipList("GetEquipList","Data",curuser)
	}
	
	Quit:PreDataFlag=1 $$$OK
	;每次新的查询清空以前的查询条件
	k ^DHCEQEquipGetEquipList("GetEquipList","Pre",curuser)
	;将此次查询条件置为上一次查询条件
	s ^DHCEQEquipGetEquipList("GetEquipList","Pre",curuser,Ejob)=^DHCEQEquipGetEquipList("GetEquipList","Cur",curuser,Ejob)
	;清除本次查询条件
	k ^DHCEQEquipGetEquipList("GetEquipList","Cur",curuser)		//czf 2021-08-09
	
    //modified by ZY 20220928
    //d ##Class(web.DHCEQCommon).KillEQTempGlobal("EquipList",Ejob,curuser)  //czf 2021-10-15 
    //k ^DHCEQTemp("EquipList",+$h,Ejob,curuser)  //modified by lmm 2020-05-09
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("EquipList",Ejob,curuser)
	
	;首次查询清空触发器中最近一次记录表操作的时间点 modified by czf 2020-05-12
	k ^TempDHCEQGetEquipList("RecordTime")
	
	//add by CZF0097 end
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	//modified by ZY0218 2020-04-10
 	Set InitFlag=##class(web.DHCEQCommon).GetDataByName(vData,"InitFlag")
 	if InitFlag="Y" Quit $$$OK
 	Set EquipCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
 	Set StoreLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"StoreLocDR")
 	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set ManageLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"ManageLocDR") 	
 	Set InStockListDR=##class(web.DHCEQCommon).GetDataByName(vData,"InStockListDR")
 	Set BatchFlag=##class(web.DHCEQCommon).GetDataByName(vData,"BatchFlag")
 	Set No=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"No"),"U")
 	Set Code=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Code"),"U")
 	Set Name=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Name"),"U")
 	Set CommonName=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"CommonName"),"U")
 	Set ModelDR=##class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
 	Set Status=##class(web.DHCEQCommon).GetDataByName(vData,"Status")
 	Set MinValue=##class(web.DHCEQCommon).GetDataByName(vData,"MinValue")
 	Set MaxValue=##class(web.DHCEQCommon).GetDataByName(vData,"MaxValue")
 	Set ProviderDR=##class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
 	Set ManuFactoryDR=##class(web.DHCEQCommon).GetDataByName(vData,"ManuFactoryDR")
 	Set EquipTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
 	Set ServiceDR=##class(web.DHCEQCommon).GetDataByName(vData,"ServiceDR")
 	Set QXType=##class(web.DHCEQCommon).GetDataByName(vData,"QXType")
 	Set PurposeTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"PurposeTypeDR")
 	set IncludeFlag=##class(web.DHCEQCommon).GetDataByName(vData,"IncludeFlag")
 	Set PurchaseTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"PurchaseTypeDR")
 	Set OriginDR=##class(web.DHCEQCommon).GetDataByName(vData,"OriginDR")
 	Set StatCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")
 	Set BeginInStockDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginInStockDate")
 	Set EndInStockDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndInStockDate")
	///modified by ZY 20230209 
 	Set OldNo=##class(web.DHCEQCommon).GetDataByName(vData,"OldNo") //add hly 20200602
 	Set IdleFlag=##class(web.DHCEQCommon).GetDataByName(vData,"IdleFlag")
 	Set CheckUserDR=##class(web.DHCEQCommon).GetDataByName(vData,"CheckUserDR") //add by zyq 2023-02-08
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginInStockDate=##class(web.DHCEQCommon).TransValueFromPage(BeginInStockDate,"date")
	Set EndInStockDate=##class(web.DHCEQCommon).TransValueFromPage(EndInStockDate,"date")
 	Set InvoiceNo=##class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNo")
 	Set ContractNo=##class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")
 	Set IsDisused=##class(web.DHCEQCommon).GetDataByName(vData,"IsDisused")
 	Set IsDisusing=##class(web.DHCEQCommon).GetDataByName(vData,"IsDisusing")
 	Set IsOut=##class(web.DHCEQCommon).GetDataByName(vData,"IsOut")
 	Set ComputerFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ComputerFlag")
 	Set BeginDisuseDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginDisuseDate")
 	Set EndDisuseDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndDisuseDate")
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginDisuseDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDisuseDate,"date")
	Set EndDisuseDate=##class(web.DHCEQCommon).TransValueFromPage(EndDisuseDate,"date")
	Set MemoryCode=##class(web.DHCEQCommon).GetDataByName(vData,"MemoryCode")
	Set BeginTransAssetDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginTransAssetDate")
	Set EndTransAssetDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndTransAssetDate")
	
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginTransAssetDate=##class(web.DHCEQCommon).TransValueFromPage(BeginTransAssetDate,"date")
	Set EndTransAssetDate=##class(web.DHCEQCommon).TransValueFromPage(EndTransAssetDate,"date")
 	Set FundsTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"FundsTypeDR")
	Set FundsRecordDR=##class(web.DHCEQCommon).GetDataByName(vData,"FundsRecordDR")
 	Set BeginOutDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginOutDate")
	Set EndOutDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndOutDate")
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginOutDate=##class(web.DHCEQCommon).TransValueFromPage(BeginOutDate,"date")
	Set EndOutDate=##class(web.DHCEQCommon).TransValueFromPage(EndOutDate,"date")
 	Set MasterItemDR=##class(web.DHCEQCommon).GetDataByName(vData,"MasterItemDR")	
	Set LocIncludeFlag=##class(web.DHCEQCommon).GetDataByName(vData,"LocIncludeFlag")
	Set TreeNo=##class(web.DHCEQCommon).GetDataByName(vData,"TreeNo")
	Set AdvanceDisFlag=##class(web.DHCEQCommon).GetDataByName(vData,"AdvanceDisFlag")
	Set InStockNo=##class(web.DHCEQCommon).GetDataByName(vData,"InStockNo")
	Set LeaveFactoryNo=##class(web.DHCEQCommon).GetDataByName(vData,"LeaveFactoryNo")
	Set StoreMoveNo=##class(web.DHCEQCommon).GetDataByName(vData,"StoreMoveNo")
	Set HospitalDR=##class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR")
	Set FilterFlag=##class(web.DHCEQCommon).GetDataByName(vData,"FilterFlag")
	Set NameStr=##class(web.DHCEQCommon).GetDataByName(vData,"NameStr")
	Set UseLocDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDRStr")
	Set ProviderDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"ProviderDRStr")
	Set EquipTypeDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDRStr")
	Set StatusStr=##class(web.DHCEQCommon).GetDataByName(vData,"StatusStr")
	Set ModelDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"ModelDRStr")
	Set NoStr=##class(web.DHCEQCommon).GetDataByName(vData,"NoStr")
	Set MIHold1=##class(web.DHCEQCommon).GetDataByName(vData,"MIHold1")
	Set CommonageFlag=##class(web.DHCEQCommon).GetDataByName(vData,"CommonageFlag")
	Set LimitYearsNum=##class(web.DHCEQCommon).GetDataByName(vData,"LimitYearsNum")
	Set BrandDR=##class(web.DHCEQCommon).GetDataByName(vData,"BrandDR")
	Set Model=##class(web.DHCEQCommon).GetDataByName(vData,"Model")
	Set Model=$ZCONVERT(Model,"U")
	Set FileNo=##class(web.DHCEQCommon).GetDataByName(vData,"FileNo")
	Set FileNo=$ZCONVERT(FileNo,"U")
	Set Location=""
	Set LocationDR=##class(web.DHCEQCommon).GetDataByName(vData,"LocationDR")
	If LocationDR'="" Set Location=$p($g(^DHCEQCCode("DHCEQCLocation",LocationDR)),"^",1)
	Set UserLoc=##class(web.DHCEQCommon).GetDataByName(vData,"UserLoc")
	Set UserLoc=$ZCONVERT(UserLoc,"U")
	Set Name=##Class(web.DHCEQCommon).Trim(Name)
	Set Chk=##class(web.DHCEQCommon).GetDataByName(vData,"Chk")
	Set UnCheckLimitFlag=##class(web.DHCEQCommon).GetDataByName(vData,"UnCheckLimitFlag")
	Set CheckRentFlag=##class(web.DHCEQCommon).GetDataByName(vData,"CheckRentFlag")
	Set FacilityFlag=##class(web.DHCEQCommon).GetDataByName(vData,"FacilityFlag")  //add by zx 2017-03-28 BUG ZX0036
	Set LifeEmergencyFlag=##class(web.DHCEQCommon).GetDataByName(vData,"LifeEmergencyFlag")
	Set UnDisFlag=##class(web.DHCEQCommon).GetDataByName(vData,"UnDisFlag")
	///add by lmm 2018-11-08 begin
	Set EquipDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"EquipDRStr")
	Set StatCatDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"StatCatDRStr")
	Set MastitemDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"MastitemDRStr")
	///add by lmm 2018-11-08 end
	Set ConfigFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ConfigFlag")  // Mozy0217  2018-11-01
	Set ClassFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ClassFlag")  //modify by lmm 2019-08-05 932337
	Set ConditionLimit=##class(web.DHCEQCommon).GetDataByName(vData,"ConditionLimit")  //Modify By zx 2020-02-20 BUG ZX0076
	Set EndNo=##class(web.DHCEQCommon).GetDataByName(vData,"EndNo")  //Modify By zx 2020-02-20 BUG ZX0076
	Set EquipAttributeString=##class(web.DHCEQCommon).GetDataByName(vData,"EquipAttributeString")  //add by csj 20191129 
	Set StandardItemDR=##class(web.DHCEQCommon).GetDataByName(vData,"StandardItemDR")
	Set EquipAttributeStringCat=##class(web.DHCEQCommon).GetDataByName(vData,"EquipAttributeStringCat")		//czf 2022-04-14 
	Set AppendFileInclude=##class(web.DHCEQCommon).GetDataByName(vData,"AppendFileInclude")		//add by ZY0305 20220617 2724602
	Set RegisterNo=##class(web.DHCEQCommon).GetDataByName(vData,"RegisterNo")
	Set IsIFB=##class(web.DHCEQCommon).GetDataByName(vData,"IsIFB")	//FX
	Set HasConfigLicence=##class(web.DHCEQCommon).GetDataByName(vData,"HasConfigLicence")
	Set DisYearFlag=##class(web.DHCEQCommon).GetDataByName(vData,"DisYearFlag")	//报废状态 2023-04-04
	Set UsedYearType=##class(web.DHCEQCommon).GetDataByName(vData,"UsedYearType")   //add by zc0133 2023-04-12 年限类型
	// MZY0158	3467100,3467101		2023-04-23
	Set BeginSMDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginSMDate")
 	Set EndSMDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndSMDate")
	Set BeginSMDate=##class(web.DHCEQCommon).TransValueFromPage(BeginSMDate,"date")
	Set EndSMDate=##class(web.DHCEQCommon).TransValueFromPage(EndSMDate,"date")

	Set index=2
	Set rowid=0
    k ^TempDHCEQ("EquipList",0,"Cat",$j)
	s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s CurGroupID=%session.Get("LOGON.GROUPID")
	
	//modified by czf begin 台账速率优化
	Set SplitNumCode=":" ;##class(web.DHCEQCommon).GetSysInfo("990026") //Modified By QW20210416 BUG:QW0097 修正传参错误
	s GroupFundsTypeFlag=$d(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",CurGroupID))
	s PreMonthStr=##Class(web.DHCEQReport).GetPreMonth($p($zd(+$h,3),"-",1,2)) //获取当前月的上月
	s CostAllotFlag=""	; MZY0125	2637708,2637710		2022-06-08
	d BuildDataGetEquipList
	; MZY0125	2637708,2637710		2022-06-08	其他科室分摊设备
	i UseLocDR'=""
	{
		s CAEquipDR=0
		f  s CAEquipDR=$o(^DHCEQCostAllot(0,"EquipType",CAEquipDR)) quit:CAEquipDR=""  d
		.s OutFlag=0
		.s Count=0
        .f  s Count=$o(^TempDHCEQ("EquipList",+$H,$j,curuser,Count)) quit:(Count="")||(OutFlag=1)  d
        ..i $g(^TempDHCEQ("EquipList",+$H,$j,curuser,Count,"EquipDR"))=CAEquipDR s OutFlag=1
		.q:OutFlag=1	;过滤已输出设备
		.
		.s CARowID=0
		.f  s CARowID=$o(^DHCEQCostAllot(0,"EquipType",CAEquipDR,1,CARowID)) quit:CARowID=""  d		;折旧分摊
		..q:$p($g(^DHCEQCostAllot(CARowID)),"^",5)'="N"
		..
		..s CALAllotLocDR=0
		..f  s CALAllotLocDR=$o(^DHCEQCostAllotList(0,"AllotLoc",CARowID,CALAllotLocDR)) quit:CALAllotLocDR=""  d
		...q:(LocIncludeFlag'="1")&&(CALAllotLocDR'=UseLocDR)
		...q:(LocIncludeFlag="1")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(UseLocDR,CALAllotLocDR,"1")=0)
		...
		...s CALRowID=0
		...f  s CALRowID=$o(^DHCEQCostAllotList(0,"AllotLoc",CARowID,CALAllotLocDR,CALRowID)) quit:CALRowID=""  d
		....s rowid=CAEquipDR
		....d ResetVariablesGetEquipList
		....d CheckGetEquipList
		....q:passed=0
		....d SetVariablesGetEquipList
		....s TWorkLoadNum=$p($g(^DHCEQCostAllotList(CALRowID)),"^",5)
		....i TWorkLoadNum="" s TWorkLoadNum=$p($g(^DHCEQEquip(CAEquipDR)),"^",27)*$p($g(^DHCEQCostAllotList(CALRowID)),"^",3)/100
		....s CostAllotFlag=1
		....;s ^DHCEQMozy("Sub",+$H,$j,CAEquipDR,CALRowID)=TWorkLoadNum
		....d OutputRowGetEquipList
	}
	
    k ^TempDHCEQ("EquipList",0,"Cat",$j)
    k ^TempDHCEQ("EquipList",0,"Depre",$j)
    k ^TempDHCEQ("EquipList",+$h,$job,curuser,"EquipTypeIsIn")      //add by jyp 2020-07-24 解决台账速率优化后，导致的批量打印条码失败的问题
    k ^TempDHCEQ("EquipList",+$h,$job,curuser,"LocIsInEQ")          //add by jyp 2020-07-24
	
	//add by zx 2019-07-24 增加合计导出
	d ResetVariablesGetEquipList
	Set TName="设备合计:"
	Set TQuantity=TotalNum
 	Set TOriginalFee=TotalFee
 	Set TNetFee=TotalNetFee
 	Set TDepreTotalFee=TotalDepreTotalFee
 	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
 	i TNetFee'="" s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"")
 	i TDepreTotalFee'="" s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TDepreTotalFee,"")  //Modify by zx 2020-08-07 Bug ZX0100 调用公共方法
	// MZY0125	2637708,2637710		2022-06-08
	s TConfigFlag=""
	i CTotalNum>0 d
	.s TQuantity=TQuantity-CTotalNum
	.s TOriginalFee=TOriginalFee-CTotalFee
    .//modified by ZY 20220928
    .//s ^DHCEQTemp("EquipList",+$h,Ejob,curuser,gnum)="附属设备合计:^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_"^"_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_CTotalNum_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag_"^"_TCurDepreFee_"^"_TDepreMonths_"^"_TReDepreMonths_"^^^^^^^"
    .s tmpValue="附属设备合计:^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_"^"_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_CTotalNum_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag_"^"_TCurDepreFee_"^"_TDepreMonths_"^"_TReDepreMonths_"^^^^^^^"
    .d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("EquipList",+$H,Ejob,curuser,gnum,tmpValue)
    .s gnum=gnum+1
    //modified by ZY 20220928
    //s ^DHCEQTemp("EquipList",+$h,Ejob,curuser,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag_"^"_TCurDepreFee_"^"_TDepreMonths_"^"_TReDepreMonths_"^"_FFee1_"^"_FFee2_"^"_FFee3_"^"_FFee4_"^"_TOperateInfo_"^"_TOutToDept_"^"_TWorkLoadNum
    s tmpValue=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag_"^"_TCurDepreFee_"^"_TDepreMonths_"^"_TReDepreMonths_"^"_FFee1_"^"_FFee2_"^"_FFee3_"^"_FFee4_"^"_TOperateInfo_"^"_TOutToDept_"^"_TWorkLoadNum_"^"_TUseLocCode_"^"_TManageLoc_"^"  //Modefued by zc0125 2022-11-16 增加TUseLocCode导出
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("EquipList",+$H,Ejob,curuser,gnum,tmpValue)
	Quit $$$OK
BuildDataGetEquipList
	s findnolist=0
	s CheckLocFlag=0
	i BatchFlag ="Y" 
	{
		s InStockList=0		
		f  s InStockList=$o(^DHCEQEquip(0,"InStockList",InStockList))  quit:InStockList=""  d
		.q:(InStockListDR'="")&(InStockListDR'=InStockList)
		.s vStoreLocDR=0
		.f  s vStoreLocDR=$o(^DHCEQEquip(0,"InStockList",InStockList,vStoreLocDR))  quit:vStoreLocDR=""  d
		..s TQuantity=0
		..s TBatchFundsFee=0
		..s tmpTotalFee=0	;;Modified by JDL 2012-3-1 JDL0118 修正合计错误
		..s tmpTotalNetFee=0
		..s tmpTotalNetRemainFee=0
		..s tmpTotalDepreTotalFee=0
		..s TInStockListDR=InStockList
		..s vRowID=""
		..s rowid=0
		..f  s rowid=$o(^DHCEQEquip(0,"InStockList",InStockList,vStoreLocDR,rowid))  quit:rowid=""  d
		...d ResetVariablesGetEquipList
		...d CheckGetEquipList
		...q:passed=0
		...s TQuantity=TQuantity+1
		...;Modified by JDL 2012-3-1 JDL0118 修正合计错误
		...s tmpTotalFee=tmpTotalFee+$p(^DHCEQEquip(rowid),"^",27)
		...s tmpTotalNetFee=tmpTotalNetFee+$p(^DHCEQEquip(rowid),"^",28)
		...s tmpTotalNetRemainFee=tmpTotalNetRemainFee+$p(^DHCEQEquip(rowid),"^",29)
		...s tmpTotalDepreTotalFee=tmpTotalDepreTotalFee+$p(^DHCEQEquip(rowid),"^",35)
		...s vRowID=rowid
		...s TBatchFundsFee=TBatchFundsFee+TFundsFee
		...;add by lmm 2018-09-14 begin 685010
		...S (EquipNetFee,EquipDepreFee)=""
		...s EquipNetFee=$p(^DHCEQEquip(rowid),"^",28)
		...s EquipDepreFee=$p(^DHCEQEquip(rowid),"^",35)
        ...i $d(^TempDHCEQ("EquipList",0,"Depre",$j,InStockList,vStoreLocDR))  d
        ....s ^TempDHCEQ("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)=($p($g(^TempDHCEQ("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)),"^",1)+EquipNetFee)_"^"_($p($g(^TempDHCEQ("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)),"^",2)+EquipDepreFee)
        ...e  d
        ....s ^TempDHCEQ("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)=EquipNetFee_"^"_EquipDepreFee
        ...;add by lmm 2018-09-14 end 685010
		...;Modified by jdl 2011-3-15 取消BatchFlag的使用
		...;i $p($g(^DHCEQInStockList(InStockList)),"^",3)="N"  d
		...;.d SetVariablesGetEquipList
		..q:TQuantity=0
		..
		..;Modified by JDL 2012-3-1 JDL0118 修正批量显示出错
		..s TInStockListDR=InStockList
		..
		..;Modified by jdl 2011-3-15 取消BatchFlag的使用
		..;以数量来区分处理,一条显示设备信息,多个显示批量信息
		..i TQuantity=1  d
		...s rowid=vRowID
		...d SetVariablesGetEquipList
		..e  d
		...s TotalNum=TotalNum+TQuantity
		...;Modified by JDL 2012-3-1 JDL0118 修正合计错误
		...s TotalFee=TotalFee+tmpTotalFee
		...s TotalNetFee=TotalNetFee+tmpTotalNetFee
		...s TotalNetRemainFee=TotalNetRemainFee+tmpTotalNetRemainFee
		...s TotalDepreTotalFee=TotalDepreTotalFee+tmpTotalDepreTotalFee
		...Set rowid=vRowID		;Mozy0100	2013-6-3	批量的情况取第一台设备信息
		...d SetBatchVariablesGetEquipList
		..
		..;i $p($g(^DHCEQInStockList(InStockList)),"^",3)="Y"  d
		..;.s TotalNum=TotalNum+TQuantity
		..;.d SetBatchVariablesGetEquipList
		..d OutputRowGetEquipList
		s findnolist=1
	}
	s rowid=0
	if (FilterFlag="Y")&&((UseLocDRStr'="")||(ProviderDRStr'=""))
	{
		if (UseLocDRStr'="")
		{
			s Len=$l(UseLocDRStr,",")
			//modify by lmm 2019-05-17 896639
			for j=1:1:Len    
			{
				s UseLocID=$p(UseLocDRStr,",",j)
				s rowid=0
				f  s rowid=$o(^DHCEQEquip(0,"UseLoc",UseLocID,rowid))  quit:rowid=""  d
				.d FillOneDataGetEquipList		
			}
		}
		elseif(ProviderDRStr'="")
		{
			s Len=$l(ProviderDRStr,",")
			for i=1:1:Len
			{
				s ProviderDR=$p(ProviderDRStr,",",i)
				s rowid=0
				f  s rowid=$o(^DHCEQEquip(0,"Provider",ProviderDR,rowid))  quit:rowid=""  d
				.d FillOneDataGetEquipList	
			}
		}
	}
	elseif InStockListDR'=""
	{
		s vStoreLocDR=0
		f  s vStoreLocDR=$o(^DHCEQEquip(0,"InStockList",InStockListDR,vStoreLocDR))  quit:vStoreLocDR=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"InStockList",InStockListDR,vStoreLocDR,rowid))  quit:rowid=""  d
		..d FillOneDataGetEquipList
		//quit
	}
	elseif (StoreMoveNo'="")
	{
		Set SMRowID=0		
		For  Set SMRowID=$Order(^DHCEQStoreMove(0,"StoreMoveNo",StoreMoveNo,SMRowID))  Quit:SMRowID=""  Do
		.Set TStoreMoveNo=StoreMoveNo
		.Set SMLRowID=0 
		.For  Set SMLRowID=$Order(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  Quit:SMLRowID=""  Do
		..Set CSRowID=0
		..For  Set CSRowID=$Order(^DHCEQChangeStock(0,"Source",1,SMLRowID,CSRowID))  Quit:CSRowID=""  Do
		...Set rowid = $Piece($Get(^DHCEQChangeStock(CSRowID)),"^",1)
		...Do FillOneDataGetEquipList
		//quit
	}
	elseif (StoreLocDR'="")
	{	
		f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",StoreLocDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		//quit
	}
	elseif(UseLocDR'="")||(HospitalDR'="")
	{
		//modified by ZY0241 修改索引，避免只选院区时在库的数据统计不到
		;检测科室标志
		s CheckLocFlag=1
		s TCUseLocDR=0
		f  s TCUseLocDR=$o(^DHCEQEquip(0,"StoreLoc",TCUseLocDR))  quit:TCUseLocDR=""  d
		.q:(LocIncludeFlag'="1")&&(TCUseLocDR'=UseLocDR)&&(UseLocDR'="")
		.;检测是否为子科室
		.q:(LocIncludeFlag="1")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(UseLocDR,TCUseLocDR,"1")'="1")&&(UseLocDR'="")
		.
		.;add by Mozy 2011-11-09	Mozy0068
		.;Set THospitalDR=$Piece($Get(^CTLOC(TCUseLocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
		.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TCUseLocDR)   //modify by jyp 2019-10-18 CTLOC调整
		.i THospitalDR'="" s THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2) //add hly 20200430
		.Quit:(HospitalDR'="")&(HospitalDR'=THospitalDR)
		.
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",TCUseLocDR,rowid))  quit:rowid=""  d
		..d FillOneDataGetEquipList		
	}
	elseif(ProviderDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"Provider",ProviderDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		
	}
	elseif(ManuFactoryDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"ManuFactory",ManuFactoryDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		
	}
	elseif(ServiceDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"Service",ServiceDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		
	}
	else
	{
		f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
	}
	
	quit
FillOneDataGetEquipList
	d ResetVariablesGetEquipList
	d CheckGetEquipList
	q:passed=0
	d SetVariablesGetEquipList
	d OutputRowGetEquipList
	quit
ResetVariablesGetEquipList
    s (TRowID,TName,TABCType,TModelDR,TEquiCatDR,TUnitDR,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TCountryDR,TManageLocDR,TManageLevelDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TWorkLoadUnitDR,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR,TKeeperDR,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TDisplayStatus,TDisplayStockStatus,TOperateInfo,TAuthorizeDept,TUseSubject,TBuyMode,TAccountDate,TIdleFlag,TieUpInfo)=""
	s (TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TStoreMoveNo,TInStockNo,TCommonName,THospitalDR,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TBackColor,TStartDateFlag,THasDoc,THasFile,TReciveDate,TCurDepreFee,TDepreSetDR,TDepreMonths,TReDepreMonths,THospital,TParentID,TOutToDept,TWorkLoadNum,TCheckUser,THold5,TConfigLicense,TNewOldPercent,TPower,TVoltage,TElectriccurrent,TNote,TMaintNote,THold16,THold17,THold18,THold19,THold20,TIsIFB,TUseLocCode,TMakeOpenCheckUser,TMakeOpenCheckUserDR,TManageCat,TSMLRemark,THold10EDesc)="" // MZY0158	3467100,3467101		2023-04-23
    s TConfigFlag="N"
    s TBatchFlag="N"
    quit
CheckGetEquipList
	s passed=0
	s EquipData=$g(^DHCEQEquip(rowid))
	//modified by ZY 20230209 
	q:(OldNo'="")&&($p(EquipData,"^",91)'[OldNo) //add hly 20200602
	//modified by czf 2020-05-14 begin 台账速率优化
	// 访问资金来源类型		Mozy0237	2019-12-9	1127176
	i GroupFundsTypeFlag 	//modified by czf 2020-05-14 未设置不过滤资金来源，影响台账加载效率
	{
		i (##class(web.DHCEQCommon).FundsTypeIsIn(1,rowid)=1)
		{quit}
	}
	;start by csj 20191129 设备属性过滤
	i (EquipAttributeString'="")
	{
		s EALength=$L(EquipAttributeString,SplitNumCode)
		s hasFlag=1
		f i=1:1:EALength d
		.q:hasFlag'=1
		.s EquipAttributeID=$p($P(EquipAttributeString,SplitNumCode,i),"id",2)
		.i $o(^DHCEQEquipAttributeList(0,"SourceAttribute",3,rowid,EquipAttributeID,0))="" s hasFlag=0
		i hasFlag=0 {quit}
	}
	;end by csj 20191129 设备属性过滤
	;start by czf 20220414 设备属性分类过滤
	i (EquipAttributeStringCat'="")
	{
		s EACLength=$L(EquipAttributeStringCat,",")
		s hasFlag=1
		f i=1:1:EACLength d
		.q:hasFlag'=1
		.s EquipAttributeCatID=$P(EquipAttributeStringCat,",",i)
		.q:EquipAttributeCatID=""
		.i $o(^DHCEQEquipAttributeList(0,"SubInfo",3,rowid,EquipAttributeCatID,0))="" s hasFlag=0
		i hasFlag=0 {quit}
	}
	;end by czf 20220414 设备属性过滤
	//简易台帐过滤位置置前处理.
	Set TEquipTypeDR=$p(EquipData,"^",63)
	i (EquipTypeDR'="")&((","_ EquipTypeDR _",")'[(","_ TEquipTypeDR _",")) //modify by cjc 2022-07-15
		{quit}	
    i '$d(^TempDHCEQ("EquipList",+$h,$job,curuser,"EquipTypeIsIn",TEquipTypeDR))
    {
        s ^TempDHCEQ("EquipList",+$h,$job,curuser,"EquipTypeIsIn",TEquipTypeDR)=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID,"",FacilityFlag)
    }   
    i $g(^TempDHCEQ("EquipList",+$h,$job,curuser,"EquipTypeIsIn",TEquipTypeDR))=1 quit
	/*
	i (EquipTypeDR="")&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID,"",FacilityFlag))
		{quit}
	*/
	if (FilterFlag="Y")&&(EquipTypeDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(EquipTypeDRStr,TEquipTypeDR,"Y")=0 {quit}
	}
	s TInvalidFlag = $p(EquipData,"^",59)
	i TInvalidFlag'="N" quit
	;Modified by jdl 2012-1-6 JDL0109
	;优化查询及查询报错
	s TStatus = $p(EquipData,"^",38)
	i (Status'="")&(Status'=TStatus)
		{quit}
	if (FilterFlag="Y")&&(StatusStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(StatusStr,TStatus,"Y")=0 {quit}
	}
	//是否包含已经报废设备
	i (IsDisused="Y")&(TStatus'=3)
		{quit}
	i (IsDisused="N")&(TStatus=3)
		{quit}
	i (UsedYearType'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckEquipInUsedYear(rowid)'=UsedYearType) {quit}		//add by zc0133 2023-04-12 年限类型过滤
	///判断是否还未入库
	s TStockStatus=$p(EquipData,"^",60)
	i (TStockStatus="0")
		{quit}
	//是否包含已经出库设备
	i (IsOut="Y")&(TStockStatus'="3")
		{quit}
	i (IsOut="N")&(TStockStatus="3")
		{quit}
	s TInStockListDR = $p(EquipData,"^",70)
	i (InStockListDR'="")&(InStockListDR'=TInStockListDR)
		{quit}
	if ((BeginInStockDate'="")||(EndInStockDate'=""))	
	{
		i (TInStockListDR="")
		{	s InStockDate=$p(EquipData,"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
			s InStockDate=$p(^DHCEQInStock(InStockDate),"^",13)
		}
		i ((BeginInStockDate'="")&(InStockDate<BeginInStockDate))
		{quit}
		
		i ((EndInStockDate'="")&(InStockDate>EndInStockDate))
		{quit}
	}
	
	if ((BeginTransAssetDate'="")||(EndTransAssetDate'=""))	
	{
		s TransAssetDate=$p(EquipData,"^",45)
		i ((BeginTransAssetDate'="")&(TransAssetDate<BeginTransAssetDate))
		{quit}
		
		i ((EndTransAssetDate'="")&(TransAssetDate>EndTransAssetDate))
		{quit}
	}
	//add by lmm 2019-08-05 begin 932337
	//过滤简易台账范类设备
	s TClassFlag=$p(EquipData,"^",83)
	i TClassFlag="" s TClassFlag="N"   //add by lmm 2020-03-16 1226721
	i (ClassFlag'="")&(ClassFlag'=TClassFlag)	//modified by csj 2020-02-11 
		{quit}
	//add by lmm 2019-08-05 end 932337
	s TStoreLocDR = $p(EquipData,"^",67)
	i (StoreLocDR'="")&(StoreLocDR'=TStoreLocDR) quit
	i (TClassFlag="N")
	{
        i '$d(^TempDHCEQ("EquipList",+$h,$job,curuser,"LocIsInEQ",TStoreLocDR))
        {
            s ^TempDHCEQ("EquipList",+$h,$job,curuser,"LocIsInEQ",TStoreLocDR)=##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID)
        }
        i $g(^TempDHCEQ("EquipList",+$h,$job,curuser,"LocIsInEQ",TStoreLocDR))=1 quit
	}
	/*
	i (TClassFlag="N")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID)))
	{
		quit
	}
	*/

	;Set THospitalDR=$Piece($Get(^CTLOC(TStoreLocDR)),"^",22)     //modify by jyp 2019-10-18 CTLOC调整
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)  //modify by jyp 2019-10-18 CTLOC调整
	i THospitalDR'="" s THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2) //add hly 20200430
	i (HospitalDR'="")&(HospitalDR'=THospitalDR)
		{quit}	
	s TUseLocDR = $p(EquipData,"^",19)
	i (CheckLocFlag=0)&&(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
		{quit}
	i TUseLocDR'="" s TUseLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",TUseLocDR)),"^",2),"-")	//##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	i (UserLoc'="")&&(TUseLoc'[UserLoc) //  add by jy 2015-12-23  JY0009
	{quit}
	s TUseLocCode=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode", TUseLocDR)  //Modefied by zc0125 2022-11-16 科室代码取值
	;ZY0098
	if (FilterFlag="Y")&&(UseLocDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(UseLocDRStr,TUseLocDR,"Y")=0 {quit}
	}
	s TOriginalFee=$p(EquipData,"^",27)
	i (MinValue'="")&(MinValue>TOriginalFee)
		{quit}
	i (MaxValue'="")&(MaxValue<=TOriginalFee)
		{quit}
	s TProviderDR = $p(EquipData,"^",25)
	i (ProviderDR'="")&(ProviderDR'=TProviderDR)
		{quit}
		
	if (FilterFlag="Y")&&(ProviderDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(ProviderDRStr,TProviderDR,"Y")=0 {quit}
	}
	s TManuFactoryDR = $p(EquipData,"^",26)
	i (ManuFactoryDR'="")&(ManuFactoryDR'=TManuFactoryDR)
		{quit}
	;add by jdl 2010-8-25
	;增加减少日期的判断
	i (TStockStatus="3")
	{
		i ((BeginOutDate'="")||(EndOutDate'=""))
		{
			s TOutID=$o(^DHCEQLifeInfo(0,"EquipSource","23",rowid,0))	
			s TLifeInfoID=$o(^DHCEQLifeInfo(0,"EquipSource","23",rowid,TOutID,0))	
			s TOutDate=$p(^DHCEQLifeInfo(TLifeInfoID),"^",15)
			i (BeginOutDate'="")
			{
				i (TOutDate<BeginOutDate)
				{
					quit
				}
			}
			i (EndOutDate'="")
			{
				i (TOutDate>EndOutDate)
				{
					quit
				}
			}
		}
	}
	i (TStatus="3")   //add by wy 2021-4-21 报废日期查询  bug WY0087
	{
		if ((BeginDisuseDate'="")||(EndDisuseDate'=""))	
		{
			s DisuseDate=$p(EquipData,"^",89)			
			i ((BeginDisuseDate'="")&&(DisuseDate<BeginDisuseDate)) quit
			i ((EndDisuseDate'="")&&(DisuseDate>EndDisuseDate)) quit
		}
	}
	//add by mwz 2017-10-30 需求号467202
	//停用设备查询
	i (TStatus="2")
	{
		s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",rowid,2,0,0,""),-1)
		i CIRowID'=""
		{
			s OutDate=$p(^DHCEQChangeInfo(CIRowID),"^",4)
			i (BeginOutDate'="")&&(OutDate<BeginOutDate) quit
			i (EndOutDate'="")&&(OutDate>EndOutDate) quit
		}
	}
	///modified by ZY0301 20220513 修改台帐名称筛选逻辑
	s (TName,TStandardItemDR)=""
	s TLifeEmergencyFlag=""
	s TItemDR=$p(EquipData,"^",7)
	i TItemDR'=""  d
	.;s TName=$ZCONVERT($p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1),"U")
	.;s TLifeEmergencyFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",13)
	.s TStandardItemDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",22)
	i (StandardItemDR'="")&&(StandardItemDR'=TStandardItemDR) {quit}
	
	;i (LifeEmergencyFlag="Y")&&(TLifeEmergencyFlag'=LifeEmergencyFlag)
	;{quit}
	s TName=$p(EquipData,"^",1)
	///end by ZY0301
	s TNo = $ZCONVERT($p(EquipData,"^",71),"U")
	if (FilterFlag="Y")&&(NameStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(NameStr,TName,"N")=0 {quit}
	}
	if (FilterFlag="Y")&&(NoStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(NoStr,TNo,"N")=0 {quit}
	}
	//Modify By zx 2020-02-20 BUG ZX0076 
	//i ((TCode'[Code)||(TNo'[No))
	//	{quit}
	i (No'="")&&(EndNo'="")
	{
		i (##class(web.DHCEQCommon).CompareStr(TNo,EndNo)=1)||(##class(web.DHCEQCommon).CompareStr(No,TNo)=1)	////i (TNo>EndNo)||(TNo<No) //modify by czf 2022-04-20
		{
			quit
		}
	}
	else
	{
		i (TNo'[No)
		{
			quit
		}
	}
	i (Name'="")
	{
		Set len = $Length(Name," ")
		for i=1:1:len
		{
			//Modify By zx 2020-02-20 BUG ZX0076 
			if (ConditionLimit=1)
			{
				If ($Piece(Name," ",i)'="")&&(TName[$Piece(Name," ",i)) Set passed=1
			}
			elseif (ConditionLimit=2)
			{
				If ($Piece(Name," ",i)'="")&&(TName=$Piece(Name," ",i)) Set passed=1
			}
			else
			{
				If ($Piece(Name," ",i)'="")&&(TName'[$Piece(Name," ",i)) Set passed=1
				
			}
		}
		i passed'=1 q
		s passed=0
	}
	s TStatCatDR = $p(EquipData,"^",75)
	i (StatCatDR'="")&&(StatCatDR'=TStatCatDR)
	{quit}
	s TEquiCatDR = $p(EquipData,"^",4)	
	i (EquipCatDR'="")&(EquipCatDR'=TEquiCatDR)
	{
		i (IncludeFlag'="1")
		{
			quit
		}
		else
		{
			//modified by jdl 2010-10-11 JDL0050 优化根据分类查找
			i TEquiCatDR=""
			{
				quit
			}
			else
			{
                i $g(^TempDHCEQ("EquipList",0,"Cat",$j,TEquiCatDR))=""
                {                   
                    s ^TempDHCEQ("EquipList",0,"Cat",$j,TEquiCatDR)=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,TEquiCatDR)                      
                }
                i +$g(^TempDHCEQ("EquipList",0,"Cat",$j,TEquiCatDR))=0 quit
			}
		}
	}
	//add by jdl 2010-3-30	JDL0045
	s TFundsFee=TOriginalFee
	i ((FundsTypeDR'="")||(FundsRecordDR'=""))
	{
		s TFundsFee=##Class(web.DHCEQFunds).GetFundsAmountByFromID(1,rowid,FundsTypeDR,FundsRecordDR)
		i +TFundsFee=0
		{
			quit
		}
	}
	i (InStockNo'="")
	{
		i (TInStockListDR="") quit
		s TInStockNo=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
		s TInStockNo=$p($g(^DHCEQInStock(TInStockNo)),"^",14)
		i (TInStockNo'[InStockNo) quit
	}
	i (findnolist=1)&(TInStockListDR'="")
	{
		quit
	}
	Set TLeaveFactoryNo=$p(EquipData,"^",10)		//出厂编号
	If (LeaveFactoryNo'="")&(TLeaveFactoryNo'[LeaveFactoryNo) quit
	if StoreMoveNo'=""
	{
		i TStoreMoveNo=""
		{
			s LifeSourceID=0
			f  s LifeSourceID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID)) quit:(LifeSourceID="")  d
			.i ($p($g(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(LifeSourceID)),"^",1))),"^",1)=StoreMoveNo)  d
			..s passed=1
			i passed'=1 q
			s passed=0
		}
	}
	s Thold9=$P(EquipData,"^",94)
	i (BrandDR'="")&(Thold9'=BrandDR)
		{quit}
	s TServiceDR = $p(EquipData,"^",69)
	i (ServiceDR'="")&(ServiceDR'=TServiceDR)
		{quit}
	s TPurchaseTypeDR=$p(EquipData,"^",64)
	i (PurchaseTypeDR'="")&(PurchaseTypeDR'=TPurchaseTypeDR)
		{quit}
	s TOriginDR=$p(EquipData,"^",20)
	i (OriginDR'="")&(OriginDR'=TOriginDR)
		{quit}	
	
 	Set TPurposeTypeDR=$p(EquipData,"^",65)
 	i (PurposeTypeDR'="")&(PurposeTypeDR'=TPurposeTypeDR)
		{quit}
	s TCode = $ZCONVERT($p(EquipData,"^",6),"U")
	///Modefied by ZC0081 2020-09-07 编码过滤 begin
	i (Code'="")&(TCode'[Code)
	{quit}
	///Modefied by ZC0081 2020-09-07 编码过滤 end
	s TCommonName = $ZCONVERT($p(EquipData,"^",1),"U")
	i (CommonName'="")&(TCommonName'[CommonName)
	{quit}
	s TManageLocDR = $p(EquipData,"^",17)
	i (ManageLocDR'="")&(ManageLocDR'=TManageLocDR)
		{quit}
	s TModelDR = $p(EquipData,"^",3)
	i (ModelDR'="")&(ModelDR'=TModelDR)
		{quit}
	If (Model'="")
	{
		Set TModel = ""
		If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		If (TModel="")||($ZCONVERT(TModel,"U")'[Model) Quit
	}
	if (FilterFlag="Y")&&(ModelDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(ModelDRStr,TModelDR,"Y")=0 {quit}
	}
	
	i (InvoiceNo'="")
	{
		// Mozy0059	2011-8-17	模糊检索某一来源的全部发票号
		Set TInvoiceNo=##Class(web.DHCEQ.EM.BUSEquip).GetInvoiceNo(rowid,0)
		Set len = $Length(TInvoiceNo,"&")
		for i=1:1:len
		{
			If $Piece($Piece(TInvoiceNo,"&",i),"^",1)[InvoiceNo Set passed=1
		}
		i passed'=1 q
		s passed=0
	}
	i (ContractNo'="")
	{
		s THold1=$p($g(^DHCEQEquip(rowid)),"^",76)
		if THold1'[ContractNo
		{
			quit
		}
	}
		i (CheckUserDR'="") //add by zyq 2023-02-08 验收制单人
	{
		s OpenCheckListDR=$p($g(^DHCEQEquip(rowid)),"^",77)
		q:OpenCheckListDR=""
		s OpenCheckRequestDR=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",1)
		q:OpenCheckRequestDR=""
		s TMakeOpenCheckUserDR=$p($g(^DHCEQOpenCheckRequest(OpenCheckRequestDR)),"^",39)
		q:CheckUserDR'=TMakeOpenCheckUserDR
		s TMakeOpenCheckUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TMakeOpenCheckUserDR)
	}
	//s TComputerFlag = $p(EquipData,"^",15)  //modify by jyp 2019-09-01   设备属性相关调整
	//modify by lmm 2020-05-19 1317554   强检设备也属于计量设备，错误纠正
	s TComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",rowid)    //modify by CSJ 2020-03-27 根据计量设备属性组过滤 需求号：1238377
	i ((ComputerFlag="Y")&("Y"'=TComputerFlag))||((ComputerFlag="N")&("Y"=TComputerFlag))  //Modified  2014-1-16 HZY0047
	{quit}
	s THold1 = $p(EquipData,"^",76)
	i (IsDisusing="Y")&(THold1'="1")
	{quit}
	i (IsDisusing="N")&(THold1="1")
	{quit}
	//add by JDL 2009-9-7 JDL0023
	s TMemoryCode=$p(EquipData,"^",61)
	i (MemoryCode'="")&&(MemoryCode'=TMemoryCode)
	{quit}
	s TMasterItemDR = $p(EquipData,"^",7)
	i (MasterItemDR'="")&&(MasterItemDR'=TMasterItemDR)
	{quit}
	//Mozy0110 68码
	If (MIHold1'="")
	{
		Set TMIHold1=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR)),"^",10)
		If (TMIHold1'=MIHold1) Quit
	}
	s TLimitYearsNum = $p(EquipData,"^",31)
	i (LimitYearsNum'="")&&(LimitYearsNum'=TLimitYearsNum)
	{quit}
	i TreeNo'=""
	{
		s TTreeNo=""
		i (TMasterItemDR'="")
		{
			s TTreeNo=$p($g(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR)),"^",10)
			i TTreeNo'="" s TTreeNo=$p($g(^DHCEQCCode("DHCEQCTree",TTreeNo)),"^",2)
		}
		i ((TTreeNo="")||(TreeNo'=$e(TTreeNo,1,$l(TreeNo))))
		{quit}
	}
	//20150827  Mozy0163	存放地点
	i Location'=""
	{
		s TLocationDR = $p(EquipData,"^",72)
		i TLocationDR=""
		{quit}
		i $e($p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",1),1,$l(Location))'=Location
		{quit}
	}
	//modified by ZY 2015-07-27  ZY0134 Hold8改成EQ_AdvanceDisFlag,用于记录设备的异常状态
	//add by zy 2011-02-22  ZY0061 设备院内报废参数查询 
	//修改为直接取EQ_Hold8字段的值来判断设备的预报废
	s THold8 = $p(EquipData,"^",93)
	//Modify By zx 2020-02-20 BUG ZX0076 
	i AdvanceDisFlag=2	;预报废	modified by czf 20200911 begin CZF0127
	{
		i THold8'=2
		{quit}
	}
	i AdvanceDisFlag=1	;报废提交
	{
		i THold8'=1
		{quit}
	}
	i AdvanceDisFlag=0	;正常
	{
		i (THold8=1)||(THold8=2)		;modified by czf 20200911 begin CZF0127
		{quit}
	}
	s TDueToDateFlag=##class(web.DHCEQEquip).GetLimitYearsNum(rowid)		//czf 2023-04-04 begin
	i DisYearFlag=0	;未到报废期
	{
		i TDueToDateFlag>0 {quit}
	}
	i DisYearFlag=1	;到期未报废
	{
		i (TDueToDateFlag<0) {quit}
		i (TDueToDateFlag>0)&&(THold8'="") {quit}
	}
	i DisYearFlag=2	;到期报废中
	{
		i (TDueToDateFlag<0) {quit}
		i (TDueToDateFlag>0)&&(THold8="") {quit} 		//czf 2023-04-04 end
	}
	//i (AdvanceDisFlag'="")&&(THold8'=AdvanceDisFlag)
	//{quit}
	s TCommonageFlag=$p(EquipData,"^",82) //共用标记
	If (CommonageFlag'="")
	{
		i (CommonageFlag="Y")&&(TCommonageFlag'=CommonageFlag) quit
		i (CommonageFlag="N")&&(TCommonageFlag="Y") quit
	}
	Set TFileNo=$Piece(EquipData,"^",85)
	If (FileNo'="")&&($ZCONVERT(TFileNo,"U")'[FileNo) Quit
	//modify by lmm 2020-03-20 1230002 修改
	If (Chk'="")&&(##class(web.DHCEQ.Plat.BUSOperateLog).GetOperateTimes(52,rowid,2)>0) Quit 
	If (CheckRentFlag'=0)&&(CheckRentFlag'="")&&(##Class(web.DHCEQEquipRent).CheckEquipIsInRent(rowid)) Quit
	// Mozy0217  2018-11-01
	//是否包含附属设备
	i (ConfigFlag'="")&&(##Class(web.DHCEQEquip).GetConfigFlag(ConfigFlag,rowid)=1) { quit}
	If (UnDisFlag'="")&&(THold8=2) Quit
	
	//add by lmm 2018-11-08 begin
	if (FilterFlag="Y")&&(EquipDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(EquipDRStr,rowid,"Y")=0 {quit}
	}
	if (FilterFlag="Y")&&(StatCatDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(StatCatDRStr,TStatCatDR,"Y")=0 {quit}
	}
	if (FilterFlag="Y")&&(MastitemDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(MastitemDRStr,TMasterItemDR,"Y")=0 {quit}
	}
	//add by lmm 2018-11-08 end
	//modified by czf 2020-05-14 end 台账速率优化
	/// modified by ZY0305 20220617 2724602
	i AppendFileInclude'=""
	{
		s THasFile=##Class(web.DHCEQDoc).HasFile(rowid,AppendFileInclude)
		i THasFile="" {quit}
	}
	set TRegistrationNo=$Piece(EquipData,"^",92)
	i (RegisterNo'="")&&(TRegistrationNo'[RegisterNo) quit
	i (HasConfigLicence="1")&&($p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",2)="") quit
	s TContractListDR = $p(EquipData,"^",32)
	i TContractListDR '="" d
	.s TContractDR=$p(^DHCEQContractList(TContractListDR),"^",1)
	.i TContractDR'="" s TIsIFB=$p(^DHCEQContract(TContractDR),"^",59)
	i (IsIFB=1)&&($p(^DHCEQContractList(+TContractListDR),"^",5)'=2) quit	// MZY0153	3244663		2023-02-20
	s TIdleFlag=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",40)
	i (IdleFlag=1)&&(TIdleFlag'="Y") quit
	// MZY0158	3467100,3467101		2023-04-23
	i (BeginSMDate'="")||(EndSMDate'="")
	{
		s SMDate=""
		s LifeSourceID=""
		f  s LifeSourceID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID),-1) quit:(LifeSourceID="")||(SMDate'="")  d
		.q:$p($g(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(LifeSourceID)),"^",1))),"^",12)=3	;过滤返库
		.s TLifeInfoID=$o(^DHCEQLifeInfo(0,"EquipSource","22",rowid,LifeSourceID,0))
		.s SMDate=$p(^DHCEQLifeInfo(TLifeInfoID),"^",15)
		q:(BeginSMDate'="")&&(SMDate<BeginSMDate)
		q:(EndSMDate'="")&&(SMDate>EndSMDate)
	}

	s passed=1
	quit
SetBatchVariablesGetEquipList
	
	s TNo=""  //add by lmm 2018-09-14 684046
    s TNetFee=$p($g(^TempDHCEQ("EquipList",0,"Depre",$j,TInStockListDR,vStoreLocDR)),"^",1) //add by lmm 2018-09-14 685010
    s TDepreTotalFee=$p($g(^TempDHCEQ("EquipList",0,"Depre",$j,TInStockListDR,vStoreLocDR)),"^",2) //add by lmm 2018-09-14 685010
	s TBatchFlag="Y"
	s TCommonName = $p($g(^DHCEQInStockList(TInStockListDR)),"^",5)	//2013-06-24 DJ0118 begin
	s TName=$p($g(^DHCEQInStockList(TInStockListDR)),"^",16)
	i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1) //2013-06-24 DJ0118 end
	s TManuFactoryDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",6)
	i TManuFactoryDR '=""  d
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	s TOriginalFee = $p($g(^DHCEQInStockList(TInStockListDR)),"^",7)
	;s TotalFee=TotalFee+(TOriginalFee*TQuantity)
	
	//add by jdl
	s TTotalFundsFee=TTotalFundsFee+TBatchFundsFee
	
	s TModelDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",9)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TUnitDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",10)
	i TUnitDR '=""  d
	.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TProviderDR = $p($g(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListDR)),"^",1))),"^",17)
	i TProviderDR '=""  d
	.s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	
	s TEquipTypeDR = $p($g(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListDR)),"^",1))),"^",20)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatCatDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListDR)),"^",1))),"^",21)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)


	s TEquiCatDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",14)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	
	i vStoreLocDR'=""  d
	.s TStoreLocDR=vStoreLocDR
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	;Mozy0100	2013-6-3
	Set TInStockList=TInStockListDR
	If TInStockList'="" Do
	.Set TInStockList = $Piece($Get(^DHCEQInStockList(TInStockListDR)),"^",1)
	.If TInStockList'="" Set TInStockNo = $Piece($Get(^DHCEQInStock(TInStockList)),"^",14)
	Set TLeaveFactoryDate=$Piece($Get(^DHCEQEquip(rowid)),"^",11)
	Set TOpenCheckDate=$Piece($Get(^DHCEQEquip(rowid)),"^",12)
	Set TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
	Set TCheckDate=$Piece($Get(^DHCEQEquip(rowid)),"^",13)
	Set TCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date")
	Set TMakeDate=$Piece($Get(^DHCEQEquip(rowid)),"^",14)
	Set TMakeDate=##Class(web.DHCEQCommon).TransValueToPage(TMakeDate,"date")
	Set TNetRemainFee=$Piece($Get(^DHCEQEquip(rowid)),"^",29)
	Set TLimitYearsNum=$Piece($Get(^DHCEQEquip(rowid)),"^",31)
	Set TDepreMethodDR=$Piece($Get(^DHCEQEquip(rowid)),"^",33)
	If TDepreMethodDR'="" Set TDepreMethod=$Piece($Get(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	Set TProviderHandler=$Piece($Get(^DHCEQEquip(rowid)),"^",41)
	Set TProviderTel=$Piece($Get(^DHCEQEquip(rowid)),"^",42)
	Set TTransAssetDate=$Piece($Get(^DHCEQEquip(rowid)),"^",45)
	Set TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
	Set TServiceDR=$Piece($Get(^DHCEQEquip(rowid)),"^",69)
	If TServiceDR'="" Set TService=##Class(web.DHCEQCommon).GetTrakNameByID("cservice",TServiceDR) //$Piece($Get(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",2) //CZF0093
	Set TCountryDR=$Piece($Get(^DHCEQEquip(rowid)),"^",16)
	If TCountryDR'="" Set TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	Set TOriginDR=$Piece($Get(^DHCEQEquip(rowid)),"^",20)
	If TOriginDR'="" Set TOrigin=$Piece($Get(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	Set TFromDeptDR=$Piece($Get(^DHCEQEquip(rowid)),"^",21)
	If TFromDeptDR'="" Set TFromDept=##Class(web.DHCEQCommon).GetTrakNameByID("todept",TFromDeptDR)  //modified by wy 20200928 1547435
	Set TBuyTypeDR=$Piece($Get(^DHCEQEquip(rowid)),"^",23)
	If TBuyTypeDR'="" Set TBuyType=$Piece($Get(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	Set TEquipTechLevelDR=$Piece($Get(^DHCEQEquip(rowid)),"^",24)
	If TEquipTechLevelDR'="" Set TEquipTechLevel=$Piece($Get(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	Set TContractListDR = $Piece($Get(^DHCEQEquip(rowid)),"^",32)
	If TContractListDR '=""  Set TContractList = $Piece($Get(^DHCEQContractList(TContractListDR)),"^",1)
	Set TWorkLoadUnitDR = $Piece($Get(^DHCEQEquip(rowid)),"^",37)
	If TWorkLoadUnitDR '="" Set TWorkLoadUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	Set TCurrencyDR=$Piece($Get(^DHCEQEquip(rowid)),"^",58)
	If TCurrencyDR'="" Set TCurrency=$Piece($Get(^DHCEQCCode("DHCEQCCurrency",TCurrencyDR)),"^",2)
	Set TMemoryCode=$Piece($Get(^DHCEQEquip(rowid)),"^",61)
	Set TPurchaseTypeDR=$Piece($Get(^DHCEQEquip(rowid)),"^",64)
	If TPurchaseTypeDR'="" Set TPurchaseType=$Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	Set TPurposeTypeDR=$Piece($Get(^DHCEQEquip(rowid)),"^",65)
	If TPurposeTypeDR'="" Set TPurposeType=$Piece($Get(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	Set TLocationDR=$Piece($Get(^DHCEQEquip(rowid)),"^",72)
	Set TGuaranteePeriodNum=$Piece($Get(^DHCEQEquip(rowid)),"^",73)
	
	Quit
SetVariablesGetEquipList
	s TQuantity = 1
	s TotalNum=TotalNum+TQuantity
	s TRowID = rowid
	//modified by zy 2014-01-07  zy0109 批量显示数据显示错误
	s EquipData=$g(^DHCEQEquip(rowid))
	;Modified by JDL 2012-3-1 JDL0118 优化速度
	;s TItemDR = $p(EquipData,"^",7)
	
	s TName = $p(EquipData,"^",1)  //modified by ZY0290 2022-01-11
	s TABCType = $p(EquipData,"^",2)

	s TUnitDR = $p(EquipData,"^",5)

	s TInstallLocDR = $p(EquipData,"^",8)	
	
	s TInstallDate = ..TransDateFormat($p(EquipData,"^",9),"date")
	;s TLeaveFactoryNo = $p(EquipData,"^",10)
	s TLeaveFactoryDate = ..TransDateFormat($p(EquipData,"^",11),"date")
	s TOpenCheckDate = ..TransDateFormat($p(EquipData,"^",12),"date")
	s TCheckDate = ..TransDateFormat($p(EquipData,"^",13),"date")
	s TMakeDate = ..TransDateFormat($p(EquipData,"^",14),"date")
	//s TComputerFlag = $p(EquipData,"^",15) //modify by jyp 2019-09-01   设备属性相关调整
	//modify by lmm 2020-05-19 1317554   强检设备也属于计量设备，错误纠正
	;s TComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",rowid)    //modify by jyp 2019-09-01    设备属性相关调整
	s TCountryDR = $p(EquipData,"^",16)

	s TManageLevelDR = $p(EquipData,"^",18)
	
	s TFromDeptDR = $p(EquipData,"^",21)
	
	s TToDeptDR = $p(EquipData,"^",22)
	
	s TBuyTypeDR = $p(EquipData,"^",23)
	
	s TEquipTechLevelDR = $p(EquipData,"^",24)
	
	s TOriginalFee = $p(EquipData,"^",27)
	s TotalFee=TotalFee+TOriginalFee
	
	s TTotalFundsFee=TTotalFundsFee+TFundsFee
	s TNetFee = $p(EquipData,"^",28)
	s TNetRemainFee = $p(EquipData,"^",29)
	s TGroupDR = $p(EquipData,"^",30)

	;s TLimitYearsNum = $p(EquipData,"^",31)
	s TContractListDR = $p(EquipData,"^",32)
	
	s TDepreMethodDR = $p(EquipData,"^",33)
	
	s TRemark = $p(EquipData,"^",34)
	s TDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",35),"")  // Modify by zx 2020-08-07 BUG ZX0100 调公共方法
	/// 20150918  Mozy0166
	s TotalNetFee=TotalNetFee+TNetFee
	s TotalNetRemainFee=TotalNetRemainFee+TNetRemainFee
	s TotalDepreTotalFee=TotalDepreTotalFee+TDepreTotalFee
	s TDesignWorkLoadNum = $p(EquipData,"^",36)
	s TWorkLoadUnitDR = $p(EquipData,"^",37)

	s TStatus = $p(EquipData,"^",38)  //modify by lmm 2018-09-14 684036
	s TDisplayStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStatusDisplay(TStatus)
	s TManageUserDR = $p(EquipData,"^",39)
	
	s TMaintUserDR = $p(EquipData,"^",40)
	
	s TProviderHandler = $p(EquipData,"^",41)
	s TProviderTel = $p(EquipData,"^",42)	
	s TAppendFeeTotalFee = $p(EquipData,"^",43)
	s TStartDateFlag=$p(EquipData,"^",44)
	s TStartDate = ..TransDateFormat($p(EquipData,"^",44),"date")
	s TTransAssetDate = ..TransDateFormat($p(EquipData,"^",45),"date")
	s TGuaranteeFlag = $p(EquipData,"^",46)
	s TInputFlag = $p(EquipData,"^",47)
	s TTestFlag = $p(EquipData,"^",48)
	s TMedicalFlag = $p(EquipData,"^",49)
	s TGuaranteeStartDate = ..TransDateFormat($p(EquipData,"^",50),"date")
	s TGuaranteeEndDate = ..TransDateFormat($p(EquipData,"^",51),"date")
	s TAddUserDR = $p(EquipData,"^",52)
	
	s TAddDate = ..TransDateFormat($p(EquipData,"^",53),"date")
	s TAddTime = $p(EquipData,"^",54)
	s TUpdateUserDR = $p(EquipData,"^",55)
	
	s TUpdateDate = ..TransDateFormat($p(EquipData,"^",56),"date")
	s TUpdateTime = $p(EquipData,"^",57)
	s TCurrencyDR = $p(EquipData,"^",58)
	
	;s TInvalidFlag = $p(EquipData,"^",59)
	;s TStockStatus = $p(EquipData,"^",60)
	s TDisplayStockStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStockStatusDisplay(TStockStatus)
	;s TMemoryCode = $p(EquipData,"^",61)
	s TUrgencyFlag = $p(EquipData,"^",62)
	;s TEquipTypeDR = $p(EquipData,"^",63)
	
	s TKeeperDR = $p(EquipData,"^",66)
	s TStartDepreMonth = $p(EquipData,"^",68)
	
	s TInStockListDR = $p(EquipData,"^",70)
	i TTransAssetDate="" d //2009-09-19 党军 begin 无转资日期显示入库审核日期
	.i TInStockListDR '=""  d
	..s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	..s TTransAssetDate=..TransDateFormat($p($g(^DHCEQInStock(TInStockList)),"^",13),"date") //2009-09-19 党军 end
	i TInStockListDR '=""  d
	.s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	.i TInStockList'="" s TInStockNo = $p($g(^DHCEQInStock(TInStockList)),"^",14)	//czf 2022-08-23
	.s TPayNo=##class(web.DHCEQPayRecord).GetPayNo("1",TInStockListDR) //2014-7-18 HZY0056
	s TNo = $p(EquipData,"^",71)
	s TLocationDR = $p(EquipData,"^",72)
	
	s TGuaranteePeriodNum = $p(EquipData,"^",73)
	;s TStatCatDR=$p(EquipData,"^",75)

	s TContractNo = $p(EquipData,"^",76)
	/// Modefied by ZY0307 2022-07-13 新增输出字段
	s TOpenCheckListDR = $p(EquipData,"^",77)
		i TOpenCheckListDR'="" d
	.s OpenCheckRequestDR=$p($g(^DHCEQOpenCheckList(TOpenCheckListDR)),"^",1) //add by zyq begin 2023-02-09
	.i OpenCheckRequestDR'="" s TMakeOpenCheckUserDR=$p($g(^DHCEQOpenCheckRequest(OpenCheckRequestDR)),"^",39)
	.s TMakeOpenCheckUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TMakeOpenCheckUserDR)
	 //add by zyq end 2023-02-09
	s THold5 = $p(EquipData,"^",80)  //使用年限
	//add by jdl 2010-8-24
	;s TFileNo=$p(EquipData,"^",85)
	s TRentLocDR=$p(EquipData,"^",86)
	s TRentStatus=$p(EquipData,"^",87)
	s TFaultStatus=$p(EquipData,"^",88)
	s TDisuseDate=$p(EquipData,"^",89)
	i TDisuseDate'="" s TDisuseDate=..TransDateFormat(TDisuseDate,"date")
	s TAccountNo=$p(EquipData,"^",90)
	s Thold6=$p(EquipData,"^",91) //2011-08-08 DJ begin
	s Thold7=$p(EquipData,"^",92)
	s Thold8=$p(EquipData,"^",93)
	s TBackColor=Thold8 //add by zx 2016-06-13 异常状态背景色处理
	s TBackColor=$Case(TBackColor,1:"#ffb746",2:"#ffb746",3:"#f16e57",4:"#f16e57",6:"#ff0000",:"")  //Modify by zx 2020-12-25   //Modefied by zc 2022-4-8
	//midified by zy 2015-7-1 ZY0134 
	s Thold8=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(Thold8)
	/// 20150918  Mozy0166
	s TAdvanceDisFlag=Thold8
	//s TUnusualRemark=$p(EquipData,"^",104)
	s TUnusualRemark=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",9)
	//end by zy 2015-7-1 ZY0134
	;s Thold9=$p(EquipData,"^",94)
	
	s Thold10=$p(EquipData,"^",95)	// MZY0158	3467100,3467101		2023-04-23
	i Thold10'="" s THold10EDesc=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",Thold10)),"^",2)
	s TFundsInfo=##Class(web.DHCEQ.EM.BUSEquip).GetFundsInfo(TRowID) //2014-6-20 HZY0055 增加资金来源描述信息的显示
	;Mozy	2017-1-11	文本资料和电子资料标记
	/// modified by ZY0305 20220617 2724602
	;s THasDoc=##Class(web.DHCEQDoc).HasDoc(TRowID)
	;s THasFile=##Class(web.DHCEQDoc).HasFile(TRowID)
	;s TName=TOutDate
	//Add By DJ 2017-12-28
	s TReciveDate=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",8)
	i TReciveDate'="" s TReciveDate=..TransDateFormat(TReciveDate,"date")
	i $p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",24)'="" s TConfigFlag="Y"	; Mozy	754500	2018-12-6
	s TCommonName = $p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)	//modified by ZY0290 2022-01-11 设备项名称
	;s TModelDR = $p(EquipData,"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	;s TEquiCatDR = $p(EquipData,"^",4)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	i TUnitDR '=""  d
	.s TUnit = $p($g(^DHCEQCCode("DHCEQCUOM",TUnitDR)),"^",4)	//##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	;s TCode = $p(EquipData,"^",6)
	;s TDesc = $p(EquipData,"^",7)
	i TInstallLocDR '=""  d
	.s TInstallLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",TInstallLocDR)),"^",2),"-")	//##class(web.DHCEQCommon).GetTrakNameByID("dept",TInstallLocDR)
	i TCountryDR '=""  d
	.s TCountry = $p($g(^CT("COU",TCountryDR)),"^",2)	//##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	;s TManageLocDR = $p(EquipData,"^",17)
	i TManageLocDR '=""  d
	.s TManageLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",TManageLocDR)),"^",2),"-")	//##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	i TManageLevelDR '=""  d
	.s TManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",TManageLevelDR)),"^",2)
	;s TUseLocDR = $p(EquipData,"^",19)
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",TUseLocDR)),"^",2),"-")	//##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	;s TOriginDR = $p(EquipData,"^",20)
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	i TFromDeptDR '=""  d
	.s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	i TToDeptDR '=""  d
	.s TToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TToDeptDR)),"^",2)
	i TBuyTypeDR '=""  d
	.s TBuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	i TEquipTechLevelDR '=""  d
	.s TEquipTechLevel = $p($g(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	;s TProviderDR = $p(EquipData,"^",25)
	i TProviderDR '=""  d
	.s TProvider = $p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)	//##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	;s TManuFactoryDR = $p(EquipData,"^",26)
	i TManuFactoryDR '=""  d
	.s TManuFactory = $p($g(^DHCEQCCode("DHCEQCVendor",TManuFactoryDR)),"^",2)	///##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	i TGroupDR '=""  d
	.s TGroup =$p($g(^DHCEQGroup(TGroupDR)),"^",2)
	i TContractListDR '=""  d
	.s TContractList = $p($g(^DHCEQContractList(TContractListDR)),"^",1)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	i TWorkLoadUnitDR '=""  d
	.s TWorkLoadUnit = $p($g(^DHCEQCCode("DHCEQCUOM",TWorkLoadUnitDR)),"^",4)	//##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	i TManageUserDR '=""  d
	.s TManageUser = $p($g(^DHCEQCCode("DHCEQCUser",TManageUserDR)),"^",4)	//##class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	i TMaintUserDR '=""  d
	.s TMaintUser = $p($g(^DHCEQCCode("DHCEQCUser",TMaintUserDR)),"^",4)	//##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	i TAddUserDR '=""  d
	.s TAddUser = $p($g(^DHCEQCCode("DHCEQCUser",TAddUserDR)),"^",4)	//##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = $p($g(^DHCEQCCode("DHCEQCUser",TUpdateUserDR)),"^",4)	//##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	i TCurrencyDR '=""  d
	.s TCurrency = $p($g(^CT("CUR",TCurrencyDR)),"^",2)	//##class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	;s TPurchaseTypeDR = $p(EquipData,"^",64)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	;s TPurposeTypeDR = $p(EquipData,"^",65)
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	i TKeeperDR '=""  d
	.s TKeeper = $p($g(^DHCEQCCode("DHCEQCUser",TKeeperDR)),"^",4)	//##class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	;s TStoreLocDR = $p(EquipData,"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",TStoreLocDR)),"^",2),"-")	//##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	;s TServiceDR = $p(EquipData,"^",69)
	i TServiceDR '=""  d
	.s TService = $p($g(^DHCEQCCode("DHCEQCVendor",TServiceDR)),"^",2)	//##Class(web.DHCEQCommon).GetTrakNameByID("cservice",TServiceDR) //$p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1) //CZF0093
	i TLocationDR'="" d
	.s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	i Thold9'="" s Thold9=$p($g(^DHCEQCCode("DHCEQCBrand",Thold9)),"^",3)
	/*
	s TCurDepreFee=##Class(web.DHCEQ.EM.BUSEquip).GetCurMonthDepre(rowid)
	s TDepreSetDR=$o(^DHCEQDepreSet(0,"Equip",rowid,""))
	i TDepreSetDR'="" d
	.s TDepreMonths=+$p($g(^DHCEQDepreSet(TDepreSetDR)),"^",22)
	.s TReDepreMonths=TLimitYearsNum*12-TDepreMonths
	.i TReDepreMonths<0 s TReDepreMonths=0
	*/
	s DepreSetInfo=$g(^DHCEQEquipShadow("RecordEQCurDepre",rowid))
	s TPreDepreMonth=$p(DepreSetInfo,"^",1)	//czf 2022-05-10 
	s TCurDepreFee=$p(DepreSetInfo,"^",3)	//最近一次月折旧
	i PreMonthStr'=TPreDepreMonth s TCurDepreFee=0 
	s TDepreMonths=+$p(DepreSetInfo,"^",2)
	s TReDepreMonths=TLimitYearsNum*12-TDepreMonths
	i TReDepreMonths<0 s TReDepreMonths=0
	
	// MZY0070	1756498		2021-02-20
	s (FFee1,FFee2,FFee3,FFee4)=##Class(web.DHCEQCommon).FormatNumber("","")
	s FRowID=0
	s TFinaceItem=""  // add by txr 20230208 核算项目
	f  s FRowID=$o(^DHCEQFunds("0","Equip",TRowID,FRowID)) q:FRowID=""  d
	.q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
	.
	.i $p($g(^DHCEQFunds(FRowID)),"^",2)=1 s FFee1=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"")
	.i $p($g(^DHCEQFunds(FRowID)),"^",2)=2 s FFee2=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"")
	.i $p($g(^DHCEQFunds(FRowID)),"^",2)=3 s FFee3=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"")
	.i $p($g(^DHCEQFunds(FRowID)),"^",2)=4 s FFee4=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"")
	.i $p($g(^DHCEQFunds(FRowID)),"^",20)'="" s TFinaceItem=TFinaceItem_""_$p($g(^DHCEQCCode("DHCEQCFinaceItem",$p($g(^DHCEQFunds(FRowID)),"^",20))),"^",2)   // add by txr 20230208 核算项目
    //modified by ZY 20220929  修改打印输出内容
    // add by mwz 2021-06-29  MWZ0051 增加TTOperateInfo begin
    s TBarPrintTimes=##class(web.DHCEQOperateLog).GetOperateTimes(52,rowid,2)
    s TCardPrintTimes=+##class(web.DHCEQOperateLog).GetOperateTimes(52,rowid,3)
    s LifeSourceID=0,TStoreMoveTimes=0
    f  s LifeSourceID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID)) quit:(LifeSourceID="")  d
    .; MZY0154	3258912		2023-03-03	修正索引
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID,LIRowID)) quit:(LIRowID="")  d
    ..q:($p($g(^DHCEQLifeInfo(LIRowID)),"^",30)="Y")
    ..q:($p($g(^DHCEQLifeInfo(LIRowID)),"^",21)'=1)  //仅当科室转移时统计
    ..s TStoreMoveTimes=TStoreMoveTimes+1
    s TOperateInfo="打印卡片:"_TCardPrintTimes_"次,打印条码:"_$p(TBarPrintTimes,"^",1)_"次,最后一次打印时间是:"_##Class(web.DHCEQCommon).TransValueToPage($p(TBarPrintTimes,"^",2)_","_$p(TBarPrintTimes,"^",3),"datetime")_",发生调拨:"_TStoreMoveTimes_"次"
    // add by mwz 2021-06-29  MWZ0051 增加TTOperateInfo end
    
    s TParentID=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",24)     //czf 2022-05-09
    i IsOut="Y" d
    .s TOutToDept=##class(web.DHCEQReturnList).GetReturnToDeptByEquip(rowid)
    
    s TConfigLicense=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",2) 
    s TNewOldPercent=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",3)
    s TNewOldPercent=$Case(TNewOldPercent,0:"全新",1:"九成新",2:"八成新",3:"七成新",4:"六成新",5:"五成新",10:"旧设备","":"")
    s TPower=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",4) 
    s TVoltage=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",5)
    s TElectriccurrent=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",6)
	s TNote=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",29)			//注意事项
	s TMaintNote=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",30)	//保养要点
	s THold16=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",31)
	s THold17=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",32)
	s THold18=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",33)
	s THold19=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",34)	//
    s THold20=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",35)
    //modified by ZY 20220929  增加输出内容
    s TAuthorizeDeptDR=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",36)
    s TAuthorizeDept=##Class(web.DHCEQCommon).GetTrakNameByID("authorizedept",TAuthorizeDeptDR) 
    s TUseSubjectDR=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",37)
    s TUseSubject=##Class(web.DHCEQCommon).GetTrakNameByID("usesubject",TUseSubjectDR) 
    s TBuyModeDR=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",38)
    s TBuyMode=##Class(web.DHCEQCommon).GetTrakNameByID("buymode",TBuyModeDR) 
    s TAccountDate=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",39)
    s TAccountDate=##Class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
    s TIdleFlag=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",40)
    s TIdleFlag=##Class(web.DHCEQCommon).TransValueToPage(TIdleFlag,"bool")
    s TManageCatDR=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",41)    //管理类别 add by txr 20230417
    s TManageCat=##class(web.DHCEQCommon).GetManageCatByID(TManageCatDR)  //add by txr 20230417
    s TieUpInfo=##Class(web.DHCEQ.EM.BUSEquip).GetTieUpEquipInfo(rowid)
    s AllAppendFileType=""
    s PicSourceTypeDR=0
	for  set PicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) q:PicSourceTypeDR=""  d
	.s SourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	.q:$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)="Y"
	.q:($p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",11)'="Y")
	.Quit:(0=##Class(web.DHCEQ.Process.DHCEQPicture).SourceTypeAccessable(52,SourceType))
	.s PicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	.q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(PicTypeDR,CurGroupID)=1
	.i AllAppendFileType'="" s AllAppendFileType=AllAppendFileType_","
	.s AllAppendFileType=AllAppendFileType_PicTypeDR
	s THasFile=##Class(web.DHCEQDoc).HasFile(rowid,AllAppendFileType)
    
	s TSMLRowid=$o(^DHCEQLifeInfo(0,"EquipSource","22",rowid,""))
	i TSMLRowid'="" s TSMLRemark = $p($g(^DHCEQStoreMoveList(TSMLRowid)),"^",11)
    quit
    //add by CZF0097 2020-03-23
OutputRowGetEquipList
	;TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TServiceHandler,TServiceTel,TStatCatDR,TStatCat,TModelDR,TEquiCatDR,TUnitDR,TCountryDR,TManageLocDR,TManageLevelDR,TWorkLoadUnitDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TKeeperDR,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR
	//格式化金额为小数点两位
	//czf 2768017 2022-09-06 千分位显示金额
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"1")
	i TNetFee'="" s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"1")
	i TNetRemainFee'="" s TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TNetRemainFee,"1")
	i TFundsFee'="" s TFundsFee=##Class(web.DHCEQCommon).FormatNumber(TFundsFee,"1")
	i TCurDepreFee'="" s TCurDepreFee=##Class(web.DHCEQCommon).FormatNumber(TCurDepreFee,"1")
	i TDepreTotalFee'="" s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TDepreTotalFee,"1")
	Set TRow=gnum	// 20150914  Mozy0165 序号
	// MZY0125	2637708,2637710		2022-06-08
	i TConfigFlag="Y" d
	.s CTotalNum=CTotalNum+1
	.s CTotalFee=CTotalFee+TOriginalFee
	
	s tmpCARowID=0
	f  s tmpCARowID=$o(^DHCEQCostAllot(0,"EquipType",TRowID,1,tmpCARowID)) quit:(tmpCARowID="")||(CostAllotFlag'="")  d		;折旧分摊
	.q:$p($g(^DHCEQCostAllot(tmpCARowID)),"^",5)'="N"
	.
	.s tmpCALRowID=0
	.f  s tmpCALRowID=$o(^DHCEQCostAllotList(0,"AllotLoc",tmpCARowID,TStoreLocDR,tmpCALRowID)) quit:tmpCALRowID=""  d
	..s TWorkLoadNum=$p($g(^DHCEQCostAllotList(tmpCALRowID)),"^",5)
	..i TWorkLoadNum="" s TWorkLoadNum=$p($g(^DHCEQEquip(TRowID)),"^",27)*$p($g(^DHCEQCostAllotList(tmpCALRowID)),"^",3)/100
	..;s ^DHCEQMozy("Main",+$H,$j,TRowID,tmpCARowID,TStoreLocDR,tmpCALRowID)=TWorkLoadNum
	s TWorkLoadNum=##Class(web.DHCEQCommon).FormatNumber(TWorkLoadNum,"")
    s Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TBackColor,TStartDateFlag,THasDoc,THasFile,TReciveDate,TConfigFlag,TCurDepreFee,TDepreMonths,TReDepreMonths,THospital,FFee1,FFee2,FFee3,FFee4,TOperateInfo,TParentID,TOutToDept,TWorkLoadNum,THold5,TConfigLicense,TNewOldPercent,TPower,TVoltage,TElectriccurrent,TNote,TMaintNote,THold16,THold17,THold18,THold19,THold20,TAuthorizeDept,TUseSubject,TBuyMode,TAccountDate,TIdleFlag,TieUpInfo,TFinaceItem,TMakeOpenCheckUser,TManageCat,TSMLRemark,THold10EDesc) // MZY0158	3467100,3467101		2023-04-23
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    //modified by ZY 20220928
    //modify by lmm 2020-05-09
    //s ^DHCEQTemp("EquipList",+$h,Ejob,curuser,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag_"^"_TCurDepreFee_"^"_TDepreMonths_"^"_TReDepreMonths_"^"_FFee1_"^"_FFee2_"^"_FFee3_"^"_FFee4_"^"_TOperateInfo_"^"_TOutToDept_"^"_TWorkLoadNum    // MZY0070  1756498     2021-02-20
    s tmpValue=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag_"^"_TCurDepreFee_"^"_TDepreMonths_"^"_TReDepreMonths_"^"_FFee1_"^"_FFee2_"^"_FFee3_"^"_FFee4_"^"_TOperateInfo_"^"_TOutToDept_"^"_TWorkLoadNum_"^"_TUseLocCode_"^"_TManageLoc_"^"_TFinaceItem_"^"_THold10EDesc  // MZY0158	3467100,3467101		2023-04-23
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("EquipList",+$H,Ejob,curuser,gnum,tmpValue)
    s ^TempDHCEQ("EquipList",+$h,Ejob,curuser,gnum,"EquipDR")=TRowID    //Modefied by zc0107 20211115 用于关联附件
	s gnum=gnum+1
	//add by CZF0097 2020-03-23
	s ^DHCEQEquipGetEquipList("GetEquipList","Data",curuser,Ejob,ListNum)=Data
	s ListNum=ListNum+1
	
	quit
	//add by CZF0097 2020-03-23
OutPutPreData	
	;输出上一次查询数据
	s index=1	//modified by czf 1325738 begin
	s Sum=0 f  s Sum=$o(^DHCEQEquipGetEquipList("GetEquipList","Data",curuser,Ejob,Sum)) q:(Sum="")  d
	.s Data=$g(^DHCEQEquipGetEquipList("GetEquipList","Data",curuser,Ejob,Sum))
	.s ^CacheTemp(repid,index)=Data
	.s index=index+1 		//modified by czf 1325738 end
	quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
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

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// Modefied by zc0044 2018-11-22 移入GetEquipList中相应方法

/// Add by jdl 2010-11-22
/// 检测ChildLoc是否是ParLoc的后代。
/// TreeType：树类型
/// 返回值：0不是，1是
ClassMethod CheckIsChildLoc(ParLoc, ChildLoc, TreeType)
{
	n ParTreeID,rowid,IsChildFlag
	s IsChildFlag=0
	i ParLoc=ChildLoc q 1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",TreeType,ChildLoc,rowid)) q:(rowid="")||(IsChildFlag=1)  d
	.q:$p($g(^DHCEQCCode("DHCEQCTreeMap",rowid)),"^",12)="Y"		//czf 2021-07-14
	.s ParTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",rowid)),"^",4)
	.q:(ParTreeID=0)
	.i ParTreeID'=""  s ParTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",ParTreeID)),"^",3)
	.if ParTreeID=ParLoc s IsChildFlag=1
	.q:(IsChildFlag=1)||(ParTreeID=0)
	.s IsChildFlag=..CheckIsChildLoc(ParLoc,ParTreeID,TreeType)
	
	q IsChildFlag
}

// Modefied by zc0044 2018-11-22 移入GetEquipList中相应方法

ClassMethod GetInvoiceNo(equipdr, firstFlag As %Library.String = "1")
{
	s invoiceno=""
	if equipdr'=""
	{
		s instocklistdr=$p($g(^DHCEQEquip(equipdr)),"^",70)
		if (instocklistdr'="")
		{
			if (firstFlag="1")
			{
				s invoiceno=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,instocklistdr),"^",1)
			}
			else
			{
				s invoiceno=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,instocklistdr)
			}
		}
	}
	q invoiceno
}

// Modefied by zc0044 2018-11-22 移入GetEquipList中相应方法

/// 2014-6-20 HZY0055 获取资金来源描述信息
/// w ##Class(web.DHCEQEquip).GetFundsInfo("123,124")
/// 返回值：自筹=123,财政=234,科研=345
ClassMethod GetFundsInfo(EquipIDs)
{
	n length,i,equipRowID,node
	n FTDR,FRowID,FundsInfo,FundsType,FundsFee
	s Times=$H
	s node="web.DHCEQEquip.GetFundsInfo"
    k ^TempDHCEQ(node,Times,$j)
	i EquipIDs="" q ""
	
	s FundsInfo=""
	s length=$l(EquipIDs,",")
	f i=1:1:length d
	.s equipRowID=$p(EquipIDs,",",i)
	.q:equipRowID=""
	.s FTDR=0
	.f  s FTDR=$o(^DHCEQFunds("0","EquipType",equipRowID,FTDR))  q:FTDR=""  d
	..s FRowID=0
	..f  s FRowID=$o(^DHCEQFunds("0","EquipType",equipRowID,FTDR,FRowID))  q:FRowID=""  d
	...q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
	...s FundsFee=$p($g(^DHCEQFunds(FRowID)),"^",3)
	...i length=1  d
	....d BuildDataFundsInfo
	...e  d
    ....s ^TempDHCEQ(node,Times,$j,FTDR)=+$g(^TempDHCEQ(node,Times,$j,FTDR))+FundsFee
	
	i length>1  d
	.s FundsInfo=""
	.s FTDR=0
    .f  s FTDR=$o(^TempDHCEQ(node,Times,$j,FTDR)) q:FTDR=""  d
    ..s FundsFee=^TempDHCEQ(node,Times,$j,FTDR)
    ..d BuildDataFundsInfo
    
    k ^TempDHCEQ(node,Times,$j) 
	q FundsInfo
	
BuildDataFundsInfo
	s FundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTDR)),"^",2)
	i FundsInfo="" d
	.s FundsInfo=FundsType_"="_FundsFee
	e  d
	.s FundsInfo=FundsInfo_","_FundsType_"="_FundsFee
}

// Modefied by zc0044 2018-11-22 移入GetEquipList中相应方法

ClassMethod GetEquipStockStatusDisplay(vStatus As %Library.String = "")
{
	i vStatus=""  q ""
	i +vStatus=0  q "新增"
	i +vStatus=1  q "入库"
	i +vStatus=2  q "转移出库"
	i +vStatus=3  q "出库"
	q "未定义"
}

/// Mozy	785784	2018-12-21
/// 增加附属设备查询标识	空：包含附属设备	0：不包含附属设备		1:仅附属设备
/// w ##Class(web.DHCEQ.EM.BUSEquip).ConfigFlag()
ClassMethod ConfigFlag(name, width) As %String
{
	w ##Class(web.DHCEQCommon).GetDefaultStyle(name, width)
	w "<option value=>包含</option>"
	w "<option value=0>不包含</option>"
	w "<option value=1>仅附属设备</option>"
	w "</select>",!
}

/// add by zx 2019-05-30
/// 获取上月折旧额
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetCurMonthDepre(130)
ClassMethod GetCurMonthDepre(CurEquipID As %String = "")
{
	i CurEquipID="" q "0"
	s PreMonthStr=##Class(web.DHCEQReport).GetPreMonth($p($zd(+$h,3),"-",1,2))
	s DepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",CurEquipID,PreMonthStr,""),-1)
	i DepreID="" q "0"
	q $p($g(^DHCEQMonthDepre(DepreID)),"^",14)
}

/// add by zx 2019-05-30
/// 批量更新台账信息
/// w ##Class(web.DHCEQ.EM.BUSEquip).ModifyEquip("901,898,899","4650^12",4674)
ClassMethod ModifyEquip(RowIDs As %Library.String = "", val As %Library.String = "", User As %Library.String = "")
{
	new (RowIDs,val,User)
 	k PLIST
 	Set $ZT="ERRORSave"
	s flag=0
	s (Keeper,TLocationDR,BrandDR,ManageLocDR,CountryDR,PurposeTypeDR,BuyTypeDR)=""  //modified By zc0125 2022-11-14 增加国别、用途和采购方式的初始化
	s Keeper= $p(val,"^",1)
	s TLocationDR=$p(val,"^",2)
	// Mozy0247	1190758	2020-02-17	增加凭证号AccountNo更新
	s AccountNo=$p(val,"^",3)
	s UserDR=$p(val,"^",4)  //Modify by zx 2020-08-18 ZX0102
	s BrandDR=$p(val,"^",5) //Add By QW20220426 BUG:QW0159
	s ManageLocDR=$p(val,"^",6) //Add By MYL20220816 2843995
	//Modified By zc0125 2022-11-14 增加国别、用途和采购方式的更新 begin
	s CountryDR=$p(val,"^",7) 
	s PurposeTypeDR=$p(val,"^",8) 
	s BuyTypeDR=$p(val,"^",9) 
	//Modified By zc0125 2022-11-14 增加国别、用途和采购方式的更新	end
	if ((Keeper="")&&(TLocationDR="")&&(AccountNo="")&&(UserDR="")&&(BrandDR="")&&(ManageLocDR="")&&(CountryDR="")&&(PurposeTypeDR="")&&(BuyTypeDR="")) q "无修改参数" //modified By zc0125 2022-11-14 增加国别、用途和采购方式的判断
	i Keeper'="" s PLIST(67) =Keeper	;Keeper  //保管人
	i TLocationDR'="" s PLIST(73) = TLocationDR
	i AccountNo'="" s PLIST(91) = AccountNo
	i UserDR'="" s PLIST(111) = UserDR
	i BrandDR'="" s PLIST(95) = BrandDR //Add By QW20220426 BUG:QW0159
	i ManageLocDR'="" s PLIST(18) = ManageLocDR //Add By QW20220426 BUG:QW0159
	//Modified By zc0125 2022-11-14 增加国别、用途和采购方式的更新 begin
	i CountryDR'="" s PLIST(17) = CountryDR 
	i PurposeTypeDR'="" s PLIST(66) = PurposeTypeDR 
	i BuyTypeDR'="" s PLIST(24) = BuyTypeDR 
	//Modified By zc0125 2022-11-14 增加国别、用途和采购方式的更新	end
	TStart
	s Length=$l(RowIDs,",")
	for i=1:1:Length
	{
		q:flag'=0
		s rowid=$p(RowIDs,",",i)
		i (rowid'="") 
		{
		 	s PLIST(56) = User
		 	s PLIST(57) = +$H
		 	s PLIST(58) = $P($H,",",2)
		 	&SQL(Update SQLUSER.DHC_EQEquip Values :PLIST() where EQ_RowID = :rowid)
		}
		if SQLCODE  
		{	
			TRollBack
			Set flag=SQLCODE 
		}
		if flag=0
		{
			k PL
			s Date=+$H
			s Time=$p($H,",",2)
			s PL(2)=rowid
			s PL(3)=$p(val,"^",3)
			s PL(4)=2
			s PL(6)=Date
			s PL(11)="N"
			;s PL(17)=User
			;s PL(18)=Date
			;s PL(19)=Time
			&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
			if SQLCODE  
			{	
				TRollBack
				Set flag=SQLCODE 
			}
		}
	}
 TCommit
 q flag
ERRORSave 
 	TROLLBACK		         //回滚事务
   	Set ErrorMsg=$ZE
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// Add By ZC 2019-12-02  zc0054
/// 描述:生成设备属性关键字列表内容
/// EquipID:   设备ID
/// w ##Class(web.DHCEQ.EM.BUSEquip).ReturnJsonEquipAttribute(404)
ClassMethod ReturnJsonEquipAttribute(EquipID As %Library.String = "")
{
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ReturnData="["
	
	s EquipAttributeList=##class(web.DHCEQCommon).GetSysInfo("990065")
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",5)="Y")
	.s EALGroup = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",3)
	.q:((","_EquipAttributeList_",")'[(","_EALGroup_","))
	.s EALName = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",2)
	.s Lrowid=0
	.s EALFlag=""
	.if (EquipID'="")  d
	..f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"AttributeSource",rowid,3,EquipID,Lrowid)) quit:Lrowid=""  d
	...s EALFlag="true"
	.if ReturnData'="["  d
	..s ReturnData=ReturnData_","
	.s ReturnData=ReturnData_"{text:'"_EALName_"',id:'id"_rowid_"',selected:'"_EALFlag_"'}"
	s ReturnData=ReturnData_"]"
	d ReturnInfo.%Set("Data",ReturnData)
	q ReturnInfo.%ToJSON()
}

ClassMethod TransDateFormat(fromvalue As %String, vtype As %String)
{
	i fromvalue="" q ""
	q $zd(fromvalue,3)
	s fromvalue=##class(websys.Conversions).DateLogicalToHtml(fromvalue) 
	if $l(fromvalue)=8 
	{
		q $E(fromvalue,1,6)_"19"_$E(fromvalue,7,8)}
	else
	{
		q fromvalue

	}
}

/// Creator:add by czf 20200911 CZF0128
/// Description:自动生成设备档案号并更新
ClassMethod UpdateFileNo(rowid, curdate)
{
	new fileno
	i rowid="" q 0
	i curdate="" s curdate=+$H
	s EquipTypeID=$p($g(^DHCEQEquip(rowid)),"^",63)  //类组
    s EquipCatID=$p($g(^DHCEQEquip(rowid)),"^",4)  //分类
	s StatCatID=$p($g(^DHCEQEquip(rowid)),"^",75)  //类型
    s UseLocID=$p($g(^DHCEQEquip(rowid)),"^",67)  //使用科室
    s Equipecatno=##class(web.DHCEQEquip).GetEquipeCatCode(EquipCatID)
	s fileno=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQEquip_FileNo",curdate,UseLocID,EquipTypeID,EquipCatID,Equipecatno)
	i fileno="" q ""
	&SQL(Update SQLUSER.DHC_EQEquip set EQ_FileNo=:fileno Where EQ_RowID=:rowid)
	if SQLCODE q SQLCODE
	q 0
}

/// d ##Class(%ResultSet).RunQuery("web.DHCEQOpenCheckRequest","GetEquipNew","")
Query GetEquipNew(CurGroupID As %Library.String = "", CommonName As %Library.String = "", StoreLocDR As %Library.String = "", EquipTypeDR As %Library.String = "", StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TCommonName:%String,TGuaranteePeriodNum:%String,TModel:%String,TEquipType:%String,TOriginalFee:%String,TStoreLoc:%String,TOpenCheckDate:%String")
{
}

ClassMethod GetEquipNewExecute(ByRef qHandle As %Binary, CurGroupID As %Library.String = "", CommonName As %Library.String = "", StoreLocDR As %Library.String = "", EquipTypeDR As %Library.String = "", StartDate As %String = "", EndDate As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CurDate=+$H
	s rowid=0
	i StartDate=""  s StartDate=0 
 	e  s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	i EndDate=""  s EndDate=+$H
 	e  s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	d BuildDataGetEquipNew
	Quit $$$OK
BuildDataGetEquipNew
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid)) quit:rowid=""  d
	.d ResetVariablesGetEquipNew
	.s TRowID=rowid
	.s EquipData=$g(^DHCEQEquip(rowid))
	.s TCommonName = $ZCONVERT($p(EquipData,"^",1),"U")
	.q:(CommonName'="")&(TCommonName'[CommonName) 
	.s TModelDR = $p(EquipData,"^",3)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TEquipTypeDR=$p(EquipData,"^",63)
	.q:(EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR) 
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))	
	.i TEquipTypeDR '="" d
	..s TEquipType = $P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	.s TOriginalFee = $p(EquipData,"^",27)
	.s TStoreLocDR = $p(EquipData,"^",67)
	.q:(StoreLocDR'="")&(StoreLocDR'=TStoreLocDR) 
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TOpenCheckDate= $p(EquipData,"^",12)
	.s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
	.q:(TOpenCheckDate>EndDate)||(TOpenCheckDate<StartDate)
	.s TGuaranteePeriodNum = $p(EquipData,"^",73)
	
	.d OutputRowGetEquipNew
	quit
OutputRowGetEquipNew
	s Data=$lb(TCommonName,TGuaranteePeriodNum,TModel,TEquipType,TOriginalFee,TStoreLoc,TOpenCheckDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipNew
	s (TRowID,TCommonName,TGuaranteePeriodNum,TModel,TEquipType,TOriginalFee,TStoreLoc,TOpenCheckDate)=""
	quit
}

ClassMethod GetEquipNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipNewExecute ]
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

ClassMethod GetEquipNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by czf 20201118
/// 微信端台账信息修改
/// w ##Class(web.DHCEQ.EM.BUSEquip).SaveEquipInfo("{""EQRowID"":""7"",""EquipNo"":""2201002000001"",""ViewType"":""1"",""QXType"":""0"",""EQNo"":""2201002000001"",""EQName"":""格力空调"",""EQModelDR_MDesc"":""KFR-32GW/(32592)nHaA"",""EQLeaveFactoryNo"":""CCBH2020071002"",""EQFileNo"":""DAH2020071002"",""EQRegistrationNo"":""reg20201085"",""EQLocationDR_LDesc"":""门诊楼15楼"",""EQKeeperDR_SSUSRName"":""李永宣"",""EQProviderDR_VName"":""合江县辰逸科技电脑有限公司"",""EQManuFactoryDR_VName"":""深圳市天方达健信科技股份有限公司"",""EQLimitYearsNum"":""6"",""UserID"":""78"",""GroupID"":""85"",""LocID"":""202"",""User"":""%E8%AE%BE%E5%A4%87%E8%B5%84%E4%BA%A7"",""Group"":""%E8%AE%BE%E5%A4%87%E8%B5%84%E4%BA%A7%28%E7%AE%A1%E7%90%86%E5%91%98%29"",""Loc"":""%E5%8C%BB%E7%96%97%E8%AE%BE%E5%A4%87%E7%A7%91"",""HospitalID"":""2"",""appId"":""wx095cb776a15d8fb0"",""timestamp"":""1606125794"",""nonceStr"":""CvtbRDIDN5O57QNL"",""signature"":""926942a1167eb8a7df50bb87d7efbc263c94bc7f"",""domainName"":""http://sbgly.jiankangle.com:81/"",""project"":""DHCEQWechat"",""ChatUserID"":""CZF"",""isCP"":"""",""EQRemark"":""111""}","","78")
ClassMethod SaveEquipInfo(DataList As %Library.String = "", EquipAttributeList As %Library.String = "", UserID As %Library.String = "")
{
	i DataList="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","无更新数据!")
	//i User'="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",User)
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	s DataJson=##class(web.DHCEQ.Plat.JsonObject).FromJSON(DataList)
	s RowID = DataJson.%Get("EQRowID")
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","编号无效!")
	
	s Location=DataJson.%Get("EQLocationDR_LDesc")
	s LocationDR=DataJson.%Get("EQLocationDR")
	s Model=DataJson.%Get("EQModelDR_MDesc")
	s ModelDR=DataJson.%Get("EQModelDR")
	s ItemDR=$p($g(^DHCEQEquip(RowID)),"^",7)
	
	i Location'=""
	{
		s LocationDR=##Class(web.DHCEQCLocation).UpdLocation(##class(web.DHCEQCHanZiEncoding).GetEncoding(Location,4,"","U")_"^"_Location)
		i LocationDR<0
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","自动更新存放地点失败!")
		}
	}
	i Model'="" 
	{
		s ModelDR=##Class(web.DHCEQCModel).UpdModel(Model,ItemDR)
		i ModelDR<0
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","自动更新规格型号失败!")
		}
	}
	d DataJson.%Set("EQLocationDR",LocationDR)
	d DataJson.%Set("EQModelDR",ModelDR)
	
	s DataInfo=DataJson.%ToJSON()
	q ##Class(web.DHCEQ.EM.BUSEquip).SaveData(DataInfo,EquipAttributeList,UserID)
}

/// 批量设备修改
/// add by czf 1967013 2021-06-07
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSEquip","GetEQModify","2440","78")
Query GetEQModify(Job As %String = "", User As %String = "") As %Query(ROWSPEC = "Job:%String,TEquipID:%String,TEquipName:%String,TEquipNo:%String,TValueType:%String,TOldValue:%String,TNewValue:%String")
{
}

ClassMethod GetEQModifyExecute(ByRef qHandle As %Binary, Job As %String = "", User As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s index=2
	s (TotalQyt,TotalOriginalFee,TotalNetFee,TotalDepreFee)=0
	
    i $Data(^TempDHCEQ("ImportEquipModify",User,Job))
    {
        s TEquipID=0
        f  s TEquipID=$o(^TempDHCEQ("ImportEquipModify",User,Job,TEquipID)) q:TEquipID=""  d
        .s TValueTypeID=0
        .f  s TValueTypeID=$o(^TempDHCEQ("ImportEquipModify",User,Job,TEquipID,TValueTypeID)) q:TValueTypeID=""  d
        ..d ResetVariableGetEQModify
        ..s TNewValue=$g(^TempDHCEQ("ImportEquipModify",User,Job,TEquipID,TValueTypeID))
		..s TEquipName=$p($g(^DHCEQEquip(TEquipID)),"^",1)
		..s TEquipNo=$p($g(^DHCEQEquip(TEquipID)),"^",71)
		..i TValueTypeID="name" d 
		...s TValueType="资产名称"
		...s TOldValue=TEquipName
		..e  i TValueTypeID="model" d
		...s TValueType="型号"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",3)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("model",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("model",TNewValue)
		..e  i TValueTypeID="equipcat" d
		...s TValueType="资产分类"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",4)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TNewValue)
		..e  i TValueTypeID="uom" d
		...s TValueType="单位"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",5)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("uom",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("uom",TNewValue)
		..e  i TValueTypeID="code" d
		...s TValueType="代码"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",6)
		..e  i TValueTypeID="installloc" d
		...s TValueType="安装科室"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",8)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("dept",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("dept",TNewValue)
		..e  i TValueTypeID="installdate" d
		...s TValueType="安装日期"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",9)
		...s TOldValue=##class(web.DHCEQCommon).TransValueToPage(TOldValue,"date")
		...;s TNewValue=##class(web.DHCEQCommon).TransValueToPage(TNewValue,"date")
		..e  i TValueTypeID="leavefactoryno" d
		...s TValueType="出厂编号"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",10)
		..e  i TValueTypeID="leavefactorydate" d
		...s TValueType="出厂日期"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",11)
		...s TOldValue=##class(web.DHCEQCommon).TransValueToPage(TOldValue,"date")
		...;s TNewValue=##class(web.DHCEQCommon).TransValueToPage(TNewValue,"date")
		..e  i TValueTypeID="opencheckdate" d
		...s TValueType="开箱日期"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",12)
		...s TOldValue=##class(web.DHCEQCommon).TransValueToPage(TOldValue,"date")
		...;s TNewValue=##class(web.DHCEQCommon).TransValueToPage(TNewValue,"date")
		..e  i TValueTypeID="checkdate" d
		...s TValueType="验收日期"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",13)
		...s TOldValue=##class(web.DHCEQCommon).TransValueToPage(TOldValue,"date")
		...;s TNewValue=##class(web.DHCEQCommon).TransValueToPage(TNewValue,"date")
		..e  i TValueTypeID="makedate" d
		...s TValueType="制造日期"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",14)
		...s TOldValue=##class(web.DHCEQCommon).TransValueToPage(TOldValue,"date")
		...;s TNewValue=##class(web.DHCEQCommon).TransValueToPage(TNewValue,"date")
		..e  i TValueTypeID="country" d
		...s TValueType="国别"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",16)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("country",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("country",TNewValue)
		..e  i TValueTypeID="manageloc" d
		...s TValueType="管理部门"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",17)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("dept",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("dept",TNewValue)
		..e  i TValueTypeID="origin" d
		...s TValueType="设备来源"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",20)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("origin",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("origin",TNewValue)
		..e  i TValueTypeID="fromdept" d
		...s TValueType="来源部门"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",21)
		...i TOldValueID'="" s TOldValue=$p($g(^DHCEQCCode("DHCEQCFromToDept",TOldValueID)),"^",2)
		...i TNewValue'="" s TNewValue=$p($g(^DHCEQCCode("DHCEQCFromToDept",TNewValue)),"^",2)
		..e  i TValueTypeID="todept" d
		...s TValueType="去向部门"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",22)
		...i TOldValueID'="" s TOldValue=$p($g(^DHCEQCCode("DHCEQCFromToDept",TOldValueID)),"^",2)
		...i TNewValue'="" s TNewValue=$p($g(^DHCEQCCode("DHCEQCFromToDept",TNewValue)),"^",2)
		..e  i TValueTypeID="buytype" d
		...s TValueType="采购方式"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",23)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("buytype",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("buytype",TNewValue)
		..e  i TValueTypeID="provider" d
		...s TValueType="供应商"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",25)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("prov",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("prov",TNewValue)
		..e  i TValueTypeID="manufactory" d
		...s TValueType="生产厂商"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",26)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TNewValue)
		..e  i TValueTypeID="limityearsnum" d
		...s TValueType="折旧年限"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",31)
		..e  i TValueTypeID="hold5" d
		...s TValueType="使用年限"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",80)
		..e  i TValueTypeID="depremethod" d
		...s TValueType="折旧方法"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",33)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("depremethod",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("depremethod",TNewValue)
		..e  i TValueTypeID="manageuser" d
		...s TValueType="管理人"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",39)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("user",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("user",TNewValue)
		..e  i TValueTypeID="providerhandler" d
		...s TValueType="供方联系人"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",41)
		..e  i TValueTypeID="providertel" d
		...s TValueType="供方电话"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",42)
		..e  i TValueTypeID="purchasetype" d
		...s TValueType="申购类别"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",64)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("purchasetype",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("purchasetype",TNewValue)
		..e  i TValueTypeID="purposetype" d
		...s TValueType="用途"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",65)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("purposetype",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("purposetype",TNewValue)
		..e  i TValueTypeID="keeper" d
		...s TValueType="保管人"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",66)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("user",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("user",TNewValue)
		..e  i TValueTypeID="service" d
		...s TValueType="服务商"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",69)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("service",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("service",TNewValue)
		..e  i TValueTypeID="location" d
		...s TValueType="存放地点"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",72)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("location",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("location",TNewValue)
		..e  i TValueTypeID="guanranteenum" d
		...s TValueType="保修期"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",73)
		..e  i TValueTypeID="contractno" d
		...s TValueType="合同号"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",76)
		..e  i TValueTypeID="fileno" d
		...s TValueType="档案号"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",85)
		..e  i TValueTypeID="accountno" d
		...s TValueType="凭证号"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",90)
		..e  i TValueTypeID="registerno" d
		...s TValueType="注册证号"
		...s TOldValue=$p($g(^DHCEQEquip(TEquipID)),"^",92)
		..e  i TValueTypeID="brand" d
		...s TValueType="品牌"
		...s TOldValueID=$p($g(^DHCEQEquip(TEquipID)),"^",94)
		...s TOldValue=##class(web.DHCEQCommon).GetTrakNameByID("brand",TOldValueID)
		...s TNewValue=##class(web.DHCEQCommon).GetTrakNameByID("brand",TNewValue)
		..d OutputRowGetEQModify
	}
	
	Quit $$$OK
	
OutputRowGetEQModify
	s Data=$lb(Job,TEquipID,TEquipName,TEquipNo,TValueType,TOldValue,TNewValue)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariableGetEQModify
	s (TValueType,TEquipName,TEquipNo,TOldValueID,TOldValue,TNewValue)=""
	quit
}

ClassMethod GetEQModifyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEQModifyExecute ]
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

ClassMethod GetEQModifyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEQModifyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:	add by czf 2021-06-08
/// Description:批量导入台账修改信息
/// Input:		val:EquipID1^ToLocID1^ReceiverID1^LocationID1$$EquipID2^ToLocID2^ReceiverID2^LocationID2
/// Command:	w ##Class(web.DHCEQ.EM.BUSEquip).ImportEquipModify(3816,1)
ClassMethod ImportEquipModify(Job, val)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
    k ^TempDHCEQ("ImportEquipModify",User)
	new EquipNo,EquipIDs,EquipID,EquipTypeID,StoreLocID,InStockListID,Len,i,Flag
	s Flag=0
	s ErrMsgs=""
	s Len=$L(val,"$$")
	for i=1:1:Len
	{
		s EquipInfo=$p(val,"$$",i)
		continue:EquipInfo=""
		s EquipID=$p(EquipInfo,"^",1)
		continue:EquipID=""
		s ValueType=$p(EquipInfo,"^",2)
		continue:ValueType=""
		s NewValue=$p(EquipInfo,"^",3)
 		
        s ^TempDHCEQ("ImportEquipModify",User,Job,EquipID,ValueType)=NewValue
	}
	q Flag_"^"_ErrMsgs
}

/// Creator:	add by czf 2021-06-08
/// Description:执行台账修改信息
/// Input:		vJob
/// Command:	w ##Class(web.DHCEQ.EM.BUSEquip).ImportEquipModify(46096)
ClassMethod ModifyEquipInfo(vJob)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s ErrorFlag=0	//保存有错时返回代码
	s ErrorMsg=""
	
	i (vJob="") q "-1^没有数据!"
    i '$Data(^TempDHCEQ("ImportEquipModify",User,vJob)) q "-1^没有数据!"
    s TEquipID=0
    f  s TEquipID=$o(^TempDHCEQ("ImportEquipModify",User,vJob,TEquipID)) q:TEquipID=""  d
    .s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()
    .s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
    .s OldObject=##Class(User.DHCEQEquip).%OpenId(TEquipID)
    .s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
    .s TValueTypeID=0
    .f  s TValueTypeID=$o(^TempDHCEQ("ImportEquipModify",User,vJob,TEquipID,TValueTypeID)) q:TValueTypeID=""  d
    ..s TEquipNo=$p($g(^DHCEQEquip),"^",71)
    ..s TNewValue=$g(^TempDHCEQ("ImportEquipModify",User,vJob,TEquipID,TValueTypeID))
	..k EQPLIST
	..i TValueTypeID="name" d
	...s TValueType="资产名称"
	...s EQPLIST(2)=TNewValue
	...s NewObj.EQName=TNewValue
	..e  i TValueTypeID="model" d
	...s TValueType="规格型号"
	...s EQPLIST(4)=TNewValue
	...s NewObj.EQModelDR=TNewValue
	..e  i TValueTypeID="equipcat" d
	...s TValueType="资产分类"
	...s EQPLIST(5)=TNewValue
	...s NewObj.EQEquiCatDR=TNewValue
	..e  i TValueTypeID="uom" d
	...s TValueType="单位"
	...s EQPLIST(6)=TNewValue
	...s NewObj.EQUnitDR=TNewValue
	..e  i TValueTypeID="code" d
	...s TValueType="代码"
	...s EQPLIST(7)=TNewValue
	...s NewObj.EQCode=TNewValue
	..e  i TValueTypeID="installloc" d
	...s TValueType="安装科室"
	...s EQPLIST(9)=TNewValue
	...s NewObj.EQInstallLocDR=TNewValue
	..e  i TValueTypeID="installdate" d
	...s TValueType="安装日期"
	...s EQPLIST(10)=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	...s NewObj.EQInstallDate=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	..e  i TValueTypeID="leavefactoryno" d
	...s TValueType="出厂编号"
	...s EQPLIST(11)=TNewValue
	...s NewObj.EQLeaveFactoryNo=TNewValue
	..e  i TValueTypeID="leavefactorydate" d
	...s TValueType="出厂日期"
	...s EQPLIST(12)=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	...s NewObj.EQLeaveFactoryDate=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	..e  i TValueTypeID="opencheckdate" d
	...s TValueType="开箱日期"
	...s EQPLIST(13)=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	...s NewObj.EQOpenCheckDate=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	..e  i TValueTypeID="checkdate" d
	...s TValueType="验收日期"
	...s EQPLIST(14)=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	...s NewObj.EQCheckDate=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	..e  i TValueTypeID="makedate" d
	...s TValueType="制造日期"
	...s EQPLIST(15)=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	...s NewObj.EQMakeDate=##class(web.DHCEQCommon).TransValueFromPage(TNewValue,"date")
	..e  i TValueTypeID="country" d
	...s TValueType="国别"
	...s EQPLIST(17)=TNewValue
	...s NewObj.EQCountryDR=TNewValue
	..e  i TValueTypeID="manageloc" d
	...s TValueType="管理部门"
	...s EQPLIST(18)=TNewValue
	...s NewObj.EQManageLocDR=TNewValue
	..e  i TValueTypeID="origin" d
	...s TValueType="设备来源"
	...s EQPLIST(21)=TNewValue
	...s NewObj.EQOriginDR=TNewValue
	..e  i TValueTypeID="fromdept" d
	...s TValueType="来源部门"
	...s EQPLIST(22)=TNewValue
	...s NewObj.EQFromDeptDR=TNewValue
	..e  i TValueTypeID="todept" d
	...s TValueType="去向部门"
	...s EQPLIST(23)=TNewValue
	...s NewObj.EQToDeptDR=TNewValue
	..e  i TValueTypeID="buytype" d
	...s TValueType="采购方式"
	...s EQPLIST(24)=TNewValue
	...s NewObj.EQBuyTypeDR=TNewValue
	..e  i TValueTypeID="provider" d
	...s TValueType="供应商"
	...s EQPLIST(26)=TNewValue
	...s NewObj.EQProviderDR=TNewValue
	..e  i TValueTypeID="manufactory" d
	...s TValueType="生产厂商"
	...s EQPLIST(27)=TNewValue
	...s NewObj.EQManuFactoryDR=TNewValue
	..e  i TValueTypeID="limityearsnum" d
	...s TValueType="折旧年限"
	...s EQPLIST(32)=TNewValue
	...s NewObj.EQLimitYearsNum=TNewValue
	..e  i TValueTypeID="hold5" d
	...s TValueType="使用年限"
	...s EQPLIST(81)=TNewValue
	...s NewObj.EQHold5=TNewValue
	..e  i TValueTypeID="depremethod" d
	...s TValueType="折旧方法"
	...s EQPLIST(34)=TNewValue
	...s NewObj.EQDepreMethodDR=TNewValue
	..e  i TValueTypeID="manageuser" d
	...s TValueType="管理人"
	...s EQPLIST(40)=TNewValue
	...s NewObj.EQManageUserDR=TNewValue
	..e  i TValueTypeID="providerhandler" d
	...s TValueType="供方联系人"
	...s EQPLIST(42)=TNewValue
	...s NewObj.EQProviderHandler=TNewValue
	..e  i TValueTypeID="providertel" d
	...s TValueType="供方电话"
	...s EQPLIST(43)=TNewValue
	...s NewObj.EQProviderTel=TNewValue
	..e  i TValueTypeID="purchasetype" d
	...s TValueType="申购类别"
	...s EQPLIST(65)=TNewValue
	...s NewObj.EQPurchaseTypeDR=TNewValue
	..e  i TValueTypeID="purposetype" d
	...s TValueType="用途"
	...s EQPLIST(66)=TNewValue
	...s NewObj.EQPurposeTypeDR=TNewValue
	..e  i TValueTypeID="keeper" d
	...s TValueType="保管人"
	...s EQPLIST(67)=TNewValue
	...s NewObj.EQKeeperDR=TNewValue
	..e  i TValueTypeID="service" d
	...s TValueType="服务商"
	...s EQPLIST(70)=TNewValue
	...s NewObj.EQServiceDR=TNewValue
	..e  i TValueTypeID="location" d
	...s TValueType="存放地点"
	...s EQPLIST(73)=TNewValue
	...s NewObj.EQLocationDR=TNewValue
	..e  i TValueTypeID="guanranteenum" d
	...s TValueType="保修期"
	...s EQPLIST(74)=TNewValue
	...s NewObj.EQGuaranteePeriodNum=TNewValue
	..e  i TValueTypeID="contractno" d
	...s TValueType="合同号"
	...s EQPLIST(77)=TNewValue
	...s NewObj.EQContractNo=TNewValue
	..e  i TValueTypeID="fileno" d
	...s TValueType="档案号"
	...s EQPLIST(86)=TNewValue
	...s NewObj.EQFileNo=TNewValue
	..e  i TValueTypeID="accountno" d
	...s TValueType="凭证号"
	...s EQPLIST(91)=TNewValue
	...s NewObj.EQAccountNo=TNewValue
	..e  i TValueTypeID="registerno" d
	...s TValueType="注册证号"
	...s EQPLIST(93)=TNewValue
	...s NewObj.EQRegistrationNo=TNewValue
	..e  i TValueTypeID="brand" d
	...s TValueType="品牌"
	...s EQPLIST(95)=TNewValue
	...s NewObj.EQBrand=TNewValue
	..&SQL(Update SQLUSER.DHC_EQEquip Values :EQPLIST() where EQ_RowID = :TEquipID)
	..i SQLCODE s ErrorFlag=SQLCODE,ErrorMsg=ErrorMsg_";"_TEquipNo_"更新"_TValueType_"失败!错误代码:"_SQLCODE
	..q:SQLCODE'=0
	.;记录更新日志
	.s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQEquip","User.DHCEQEquip",TEquipID,"U",NewObj.%ToJSON(),OldObj.%ToJSON(),User,"")
	
    i ErrorFlag=0 k ^TempDHCEQ("ImportEquipModify",User)
	q ErrorFlag_"^"_ErrorMsg
}

/// Add BY czf 2021-08-11
/// 根据设备ID自动保存设备规格型号
/// 入参：val：EquipID^Model
/// 返回：规格型号ID
ClassMethod SaveEQModel(val)
{
	s EquipID=$p(val,"^",1)
	s Model=$p(val,"^",2)
	i EquipID="" q ""
	i Model="" q ""
	s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
	s JsonStr=##class(web.DHCEQ.Plat.CTModel).UpdModel(Model,ItemID)
	q JsonStr
}

/// 修改:czf 2022-05-11
/// 描述:获取设备档案资料数量
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSEquip","GetFile",24613)
Query GetFile(EquipDR As %String, CurGroupID As %String = "") As %Query(ROWSPEC = "TRow:%String,TFileName:%String,TFileNum:%String,TRemark:%String,TEQNo:%String,TEQName:%String,TEQStoreLoc:%String") [ SqlProc ]
{
}

ClassMethod GetFileExecute(ByRef qHandle As %Binary, EquipDR As %String, CurGroupID As %String = "") As %Status [ ProcedureBlock = 1 ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	i EquipDR="" Quit $$$OK
	
	s TEQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	s TEQName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s TEQModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	s TEQModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TEQModelDR)
	i TEQModel'="" s TEQName=TEQName_"("_TEQModel_")"
	s TEQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	s TEQStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TEQStoreLocDR)
	
	d BuildDataGetPicture
	d BuildDataGetDoc
	Quit $$$OK
	
BuildDataGetPicture
	//图片资料
	s PicTypeDRs=##Class(web.DHCEQ.Plat.LIBPicture).GetPicTypeBySource("52","0",CurGroupID)
	s result=##class(%ResultSet).%New("web.DHCEQ.Process.DHCEQPicture:GetPicture")
	d result.Execute("52",EquipDR,"^^^^^"_PicTypeDRs_"^^^^^^^^")
	while(result.Next()){
		d ResetVariablesGetFile
		s TFileName=result.GetDataByName("TPicName")
		;s TFileNum=result.GetDataByName("TPicNum")
		i (TFileName ="发票")||(TFileName ="设备照片") s TFileNum = result.GetDataByName("TPicNum")
		  e  s TFileNum=1
		d OutputRowGetFile
	}
	quit
BuildDataGetDoc
	//相关文件
	s CheckListDR=$p($g(^DHCEQEquip(EquipDR)),"^",77)
	s EQParentDR=$p($g(^DHCEQEquip(EquipDR,"OtherInfo")),"^",24)
	s docresult=##class(%ResultSet).%New("web.DHCEQDoc:GetDoc")
	d docresult.Execute(EquipDR,"",EQParentDR)
	while(docresult.Next()){
		d ResetVariablesGetFile
		s TFileName=docresult.GetDataByName("TDocName")
		s TFileNum=docresult.GetDataByName("TShareNum")
		s TRemark=docresult.GetDataByName("TRemark")
		d OutputRowGetFile	
	}
	quit
OutputRowGetFile
	s TRow=TRow+1
	s Data=$lb(TRow,TFileName,TFileNum,TRemark,TEQNo,TEQName,TEQStoreLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFile
	s (TFileName,TFileNum,TRemark)=""
	quit
}

ClassMethod GetFileFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFileExecute ]
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

ClassMethod GetFileClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFileExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:    add by ZY 2022-09-14
/// Description:台账界面闲置非闲置状态修改
/// Input:      RowID 设备ID
///             value  状态值
/// Command:    w ##Class(web.DHCEQ.EM.BUSEquip).UpdateIdleFlag(46096)
ClassMethod UpdateIdleFlag(RowID, value)
{
    new SQLCODE
    s SQLCODE=0
    s value=##Class(web.DHCEQCommon).TransValueFromPage(value,"bool")
    &SQL(Update SQLUSER.DHC_EQEquip set EQ_IdleFlag=:value Where EQ_RowID=:RowID)
    if SQLCODE q SQLCODE
	q SQLCODE
}

/// add by jyp 2022-08-29
/// 打印临时码
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetTempBarCode("10")
ClassMethod GetTempBarCode(Num As %Library.String = "")
{
	s CodeStrings=""
	if (Num="")
	{
		q "请输入数量"
	}else{
		for templength=1:1:Num
		{
			if (CodeStrings=""){
				s CodeStrings=##class(web.DHCEQCCounter).GetNextNo("DHC_EQTempCode",+$h,"1","","","","","","")
			}else{
				s CodeStrings=CodeStrings_","_##class(web.DHCEQCCounter).GetNextNo("DHC_EQTempCode",+$h,"1","","","","","","")
			}
		}
	}
	q CodeStrings
}

/// add by ZY 20220926 2757106
/// 在台账扩展节点记录用来记录占用的业务单据信息
/// 入参：equipIDs ：设备id串
///       BussType ：业务类型代码  22：转移  23 退货
///       BussID   ：业务明细id
///       opt      ：操作类型  0  保存  1 删除
/// 返回值：  0  成功
/// w ##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(46096)
ClassMethod TieUpEquipByBuss(equipIDs, BussType, BussID, opt)
{
    new ListCount,j,EquipID
    if equipIDs="" s equipIDs=##Class(web.DHCEQ.EM.BUSEquip).GetEquipIDsByBussType(BussType,BussID)
    s ListCount=$L(equipIDs,",")
    for j=1:1:ListCount
    {
        s EquipID=$p(equipIDs,",",j)
        i opt=0
        {
            ///保存的时候判断是否不存在
            i '$Data(^DHCEQEquip(EquipID,"TIEUP",BussType,BussID)) s ^DHCEQEquip(EquipID,"TIEUP",BussType,BussID)=""
        }
        else
        {
            ///保存的时候判断是否存在
            i $Data(^DHCEQEquip(EquipID,"TIEUP",BussType,BussID)) k ^DHCEQEquip(EquipID,"TIEUP",BussType,BussID)
        }
    }
    q 0
}

/// add by ZY 20220926 2757106
/// 在台账扩展节点记录用来记录占用的业务单据信息
/// 入参：
///       BussType ：业务类型代码  22：转移  23 退货
///       BussID   ：业务明细id
///       opt      ：操作类型  0  保存  1 删除
/// 返回值：  equipIDs  业务对应设备ID字符串
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetEquipIDsByBussType(22，43)
ClassMethod GetEquipIDsByBussType(BussType, BussID)
{
    new equipIDs
    s equipIDs=""
    if BussType="22"
    {
        s MXRowID=0
        f  s MXRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,MXRowID))  quit:(MXRowID="")  d
        .i equipIDs=""  d
        ..s equipIDs= $g(^DHCEQStoreMoveList(MXRowID,"EX","RowIDs"))
        .e   d
        ..s equipIDs=equipIDs_","_$g(^DHCEQStoreMoveList(MXRowID,"EX","RowIDs"))
    }
    elseif BussType="23"
    {
        s MXRowID=0
        f  s MXRowID=$o(^DHCEQReturnList(0,"Return",BussID,MXRowID))  quit:(MXRowID="")  d
        .i equipIDs=""  d
        ..s equipIDs= $g(^DHCEQReturnList(MXRowID,"EX","RowIDs"))
        .e   d
        ..s equipIDs=equipIDs_","_$g(^DHCEQReturnList(MXRowID,"EX","RowIDs"))
    }
    elseif BussType="34"
    {
        s KindFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",44)
        if KindFlag=0
        {
            s equipIDs=$p($g(^DHCEQDisuseRequest(BussID)),"^",1)
        }
        elseif KindFlag=1
        {
            s equipIDs=$g(^DHCEQDisuseRequest(BussID,"EX"))
        }
        elseif KindFlag=2
        {
            s MXRowID=0
            f  s MXRowID=$o(^DHCEQDisuseList(0,"Request",BussID,MXRowID)) q:(MXRowID="")  d
            .s MXEquipIDs=""
            .i $p(^DHCEQDisuseList(MXRowID),"^",2)=0  d
            ..s MXEquipIDs= $P(^DHCEQDisuseList(MXRowID),"^",3)
            .e  d
            ..s MXEquipIDs=$g(^DHCEQDisuseList(MXRowID,"EX"))
            .q:MXEquipIDs=""
            .i equipIDs=""  d
            ..s equipIDs= MXEquipIDs
            .e   d
            ..s equipIDs=equipIDs_","_MXEquipIDs
        }
    }
    q equipIDs
}

/// add by ZY 20220926 2757106
/// 获取设备扩展节点记录的占用业务数据
/// 入参：equipID ：设备id串
/// 返回值：  result  信息描述
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetTieUpEquipInfo(46096)
ClassMethod GetTieUpEquipInfo(equipID)
{
    new BussType,BussID,BussInfo,result,No
    s result=""
    i '$Data(^DHCEQEquip(equipID,"TIEUP")) q ""
    s BussType=0
    f  s BussType=$o(^DHCEQEquip(equipID,"TIEUP",BussType)) q:BussType=""
    .s BussTypeDesc=##Class(web.DHCEQFind).GetBussTypeDesc(BussType)
    .s BussID=0
    .f  s BussID=$o(^DHCEQEquip(equipID,"TIEUP",BussType,BussID)) q:BussID=""
    ..s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussType,BussID)
    ..i result=""  d
    ...s result=BussTypeDesc_":"_$p(BussInfo,"^",1)
    ..e  d
    ...s result=result_","_BussTypeDesc_":"_$p(BussInfo,"^",1)
    q result
}

/// modified by ZY20221206 bug:3081274
/// 将台帐查询中的查询结果,按科室汇总整理,
/// 现主要用于按使用科室批量打印条码
/// modified by csj 2020-07-27 添加SortType排序参数
/// SortType 1:按科室排序后的顺序位置 2、根据设备名称、编号排序后的顺序位置 3、按科室排序、设备名称、设备编号排序后的顺序
/// modified by csj 2020-03-01 添加Job参数
/// w ##Class(web.DHCEQ.EM.BUSEquip).LocPrintEquip(46096)
ClassMethod LocPrintEquip(Job, curuser As %String = "", SortType As %String = "3")
{
    i curuser="" s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    k ^TempDHCEQ("LocPrintEquipTemp",curuser)
    k ^TempDHCEQ("LocPrintEquip",curuser)
    if SortType="1"
    {
        s rowid=0
        f  s rowid=$o(^TempDHCEQ("EquipList",+$h,Job,curuser,rowid)) q:rowid=""  d      //modified by czf 2020-05-09
        .s EQRowID=$p($g(^TempDHCEQ("EquipList",+$h,Job,curuser,rowid)),"^",64)
        .q:EQRowID<1
        .s Name=$p($g(^DHCEQEquip(EQRowID)),"^",1)
        .s EquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
        .s LocDR=$p($g(^DHCEQEquip(EQRowID)),"^",67)
        .s DeptCode=""  
        .i LocDR'="" s DeptCode=$p(^DHCEQCCode("DHCEQCDepartment",LocDR),"^",1)
        .i DeptCode="" s DeptCode=0
        .i LocDR="" s LocDR=0
        .s ^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,rowid)=EQRowID_"^"_EquipNo_"^"_Name
        
        s DeptCode=""
        s Count=1
        f  s DeptCode=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode))  q:DeptCode=""  d
        .s rowid=0
        .f  s rowid=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,rowid))  q:rowid=""  d
        ..s ^TempDHCEQ("LocPrintEquip",curuser,Count)=$g(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,rowid))
        ..s Count=Count+1
    }
    elseif SortType="2"{
        s rowid=0
        f  s rowid=$o(^TempDHCEQ("EquipList",+$h,Job,curuser,rowid)) q:rowid=""  d  
        .s EQRowID=$p($g(^TempDHCEQ("EquipList",+$h,Job,curuser,rowid)),"^",64)
        .q:EQRowID<1
        .s Name=$p($g(^DHCEQEquip(EQRowID)),"^",1)
        .s EquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
        .s ^TempDHCEQ("LocPrintEquipTemp",curuser,Name,EquipNo,rowid)=EQRowID_"^"_EquipNo_"^"_Name
        
        s Name=""
        s Count=1
        f  s Name=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,Name))  q:Name=""  d
        .s EquipNo=""
        .f  s EquipNo=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,Name,EquipNo))  q:EquipNo=""  d
        ..s rowid=0
        ..f  s rowid=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,Name,EquipNo,rowid))  q:rowid=""  d
        ...s ^TempDHCEQ("LocPrintEquip",curuser,Count)=$g(^TempDHCEQ("LocPrintEquipTemp",curuser,Name,EquipNo,rowid))
        ...s Count=Count+1
    }
    elseif SortType="3"{
        s rowid=0
        f  s rowid=$o(^TempDHCEQ("EquipList",+$h,Job,curuser,rowid)) q:rowid=""  d  
        .s EQRowID=$p($g(^TempDHCEQ("EquipList",+$h,Job,curuser,rowid)),"^",64)
        .q:EQRowID<1
        .s Name=$p($g(^DHCEQEquip(EQRowID)),"^",1)
        .s EquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
        .s LocDR=$p($g(^DHCEQEquip(EQRowID)),"^",67)
        .s DeptCode=""
        .i LocDR'="" s DeptCode=$p(^DHCEQCCode("DHCEQCDepartment",LocDR),"^",1)
        .i DeptCode="" s DeptCode=0
        .i LocDR="" s LocDR=0
        .s ^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo,rowid)=EQRowID_"^"_EquipNo_"^"_Name
        
        s DeptCode=""
        s Count=1
        f  s DeptCode=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode))  q:DeptCode=""  d
        .s Name="" 
        .f  s Name=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,Name))  q:Name=""  d
        ..s EquipNo=""
        ..f  s EquipNo=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo))  q:EquipNo=""  d
        ...s rowid=0
        ...f  s rowid=$o(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo,rowid))  q:rowid=""  d
        ....s ^TempDHCEQ("LocPrintEquip",curuser,Count)=$g(^TempDHCEQ("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo,rowid))
        ....s Count=Count+1
    }
    q 1
}

/// modified by ZY20221206 bug:3081274
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetLocPrintList(46096)
ClassMethod GetLocPrintList(gnum)
{
    s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s str=$g(^TempDHCEQ("LocPrintEquip",curuser,gnum))
    q str
}

/// modified by ZY20221206 bug:3081274
/// 用于获取检索台帐后,该编号设备所在位置
/// Type: 0:根据台帐检索顺序  1:按科室排序后的顺序位置
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetNextNum(46096)
ClassMethod GetNextNum(Ejob, curuser As %String = "", SortType, ID)
{
    i curuser="" s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s BeginNum=1
    ;
    if SortType=0  d
    .s Num=0
    .f  s Num=$o(^TempDHCEQ("EquipList",+$h,Ejob,curuser,Num)) q:((Num="")||(BeginNum'=1))  d       //modified by czf 2020-05-09
    ..s EquipID=$p(^TempDHCEQ("EquipList",+$h,Ejob,curuser,Num),"^",64)
    ..i EquipID=ID s BeginNum=Num
    e  d
    .s Num=0
    .f  s Num=$o(^TempDHCEQ("LocPrintEquip",curuser,Num)) q:((Num="")||(BeginNum'=1))  d
    ..s EquipID=$p(^TempDHCEQ("LocPrintEquip",curuser,Num),"^",1)
    ..i EquipID=ID s BeginNum=Num
    q BeginNum
}

/// modified by zc0133 2023-4-12
/// 判断设备的年限类型
/// w ##Class(web.DHCEQ.EM.BUSEquip).CheckEquipInUsedYear(1)
ClassMethod CheckEquipInUsedYear(UEquipDR)
{
    s UsedYear=$p($g(^DHCEQEquip(UEquipDR)),"^",80)
    i UsedYear="" s UsedYear=$p($g(^DHCEQEquip(UEquipDR)),"^",31)
    s UEQTransAssetDate=$p($g(^DHCEQEquip(UEquipDR)),"^",45)
    s UEQTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(UEQTransAssetDate,"date")
    s UEndDate=##class(web.DHCEQCommon).DateAdd("YYYY",UsedYear,UEQTransAssetDate)
    s UEndDate=##Class(web.DHCEQCommon).TransValueFromPage(UEndDate,"date")
    i UEndDate-(+$h)<0 q 2
    q 1
}

}
