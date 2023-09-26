/// add by ZY0208 2020-02-27
Class web.DHCEQ.BA.BUSBenefitEquipList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitEquipList","GetBenefitEquipList","")
/// modified by czf 2021-03-09 1789983 增加出参THold1_DeptDesc
Query GetBenefitEquipList(vItemDR As %String = "", vNo As %String = "", vUseLocDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", QXType As %String = "", CLOCID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquip:%String,TInitYear:%String,TPreWorkLoad:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TOtherTasks:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TModel:%String,TLeaveFactoryNo:%String,TUseLoc:%String,TOriginalFee:%String,TLimitYearsNum:%String,TStartDate:%String,TTransAssetDate:%String,TNo:%String,THold1_DeptDesc:%String")
{
}

ClassMethod GetBenefitEquipListExecute(ByRef qHandle As %Binary, vItemDR As %String = "", vNo As %String = "", vUseLocDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", QXType As %String = "", CLOCID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i vFromOriginalFee'="" s vFromOriginalFee=##Class(web.DHCEQCommon).FormatNumber(vFromOriginalFee,"1") // add by sjh SJH0045 2021-02-20
	i vToOriginalFee'="" s vToOriginalFee=##Class(web.DHCEQCommon).FormatNumber(vToOriginalFee,"1") // add by sjh SJH0045 2021-02-20
	s rowid=0
	f  s rowid=$o(^DHCEQBenefitEquipList(rowid))  quit:rowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(rowid))
	.d BuildBenefitEquipListDate
	quit $$$OK
BuildBenefitEquipListDate
    s (TRowID,TEquipDR,TEquip,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5)=""
    s (TModel,TLeaveFactoryNo,TUseLoc,TOriginalFee,TLimitYearsNum,TStartDate,TTransAssetDate,TNo,THold1DeptDesc)=""
    s TRowID=rowid
    s TEquipDR=$p(Datalist,"^",1)
    //设备基本信息
    s EquipData=$g(^DHCEQEquip(TEquipDR))
    s TEquip=$p(EquipData,"^",1)
    q:(vItemDR'="")&&(vItemDR'=$p(EquipData,"^",7))
    s TNo = $p(EquipData,"^",71)
    q:(vNo'="")&&(vNo'=TNo)
	s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",$p(EquipData,"^",3))
	s TLeaveFactoryNo = $p(EquipData,"^",10)
	s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(EquipData,"^",19))
	q:((QXType=2)&&($p(EquipData,"^",19)'=CLOCID))
	q:((vUseLocDR'="")&&($p(EquipData,"^",19)'=vUseLocDR))
	s TOriginalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"1")
    q:((TOriginalFee<vFromOriginalFee)&&(vFromOriginalFee'=""))||((TOriginalFee>vToOriginalFee)&&(vToOriginalFee'=""))  //modified by myl 1813220 2021-3-31
	s TLimitYearsNum = $p(EquipData,"^",31)
	s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
	s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
	s TNo = $p(EquipData,"^",71)
    s TInitYear=$p(Datalist,"^",2)
    s TPreWorkLoad=$p(Datalist,"^",3)
    s TNewFunction=$p(Datalist,"^",4)
    s TSpecialService=$p(Datalist,"^",5)
    s TOtherSocial=$p(Datalist,"^",6)
    s TGraduateNum=$p(Datalist,"^",7)
    s TStaffNum=$p(Datalist,"^",8)
    s TOtherTasks=$p(Datalist,"^",9)
    s THold1=$p(Datalist,"^",10)
    s THold2=$p(Datalist,"^",11)
    s THold3=$p(Datalist,"^",12)
    s THold4=$p(Datalist,"^",13)
    s THold5=$p(Datalist,"^",14)
    s THold1DeptDesc=##class(web.DHCEQCommon).GetLocDescByIDs(THold1)	//czf 2021-07-08 1880419
	d OutputRowBenefitEquipList	
	quit
OutputRowBenefitEquipList
	s Data=$lb(TRowID,TEquipDR,TEquip,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5,TModel,TLeaveFactoryNo,TUseLoc,TOriginalFee,TLimitYearsNum,TStartDate,TTransAssetDate,TNo,THold1DeptDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitEquipListExecute ]
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

ClassMethod GetBenefitEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.BA.BUSBenefitEquipList).GetOneEquipList(1)
ClassMethod GetOneEquipList(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneEquipList"
	s ObjEquipList=##Class(User.DHCEQBenefitEquipList).%OpenId(RowID)
	s EquipList=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjEquipList)
	d EquipList.%Set("RowID",RowID)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,EquipList)
ERRORGetOneEquipList
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.BA.BUSBenefitEquipList).SaveData("10","1","","","","")
/// data,"0",DeviceMapdataList,UseContextYeardataList,UseContextMonthdataList,ResearchdataList
ClassMethod SaveData(data, DelIs, DeviceMapdataList As %Library.String = "", UseContextYeardataList As %Library.String = "", UseContextMonthdataList As %Library.String = "", ResearchdataList As %Library.String = "")
{
	new RowID,User,Date,Time,EquipID
	s $ZT="ERRORSaveData"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	TSTART
	if DelIs=1
	{
		/////modified by ZY0255 20210301
		s RowID=data
		i (RowID'="")
		{
			s EquipDR=$p($g(^DHCEQBenefitEquipList(RowID)),"^",1)
			&SQL(delete sqluser.DHC_EQBenefitEquipList where BEL_RowID = :RowID)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			&SQL(delete sqluser.DHC_EQDeviceMap where DM_EquipDR = :EquipDR)
			i SQLCODE=100 s SQLCODE=0
		    //add by wy 2022-7-11 2756907 更新无效对应设备的效益设备属性 begin
			s SourceType ="3"
			s EARowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code","41",0))
			&SQL(Update SQLUSER.DHC_EQEquipAttributeList set EAL_InvalidFlag ='Y' where EAL_SourceType =:SourceType AND EAL_SourceID=:EquipDR and EAL_EquipAttributeDR=:EARowid )	
			i SQLCODE=100 s SQLCODE=0	///add by ZY0265 20210526
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		TCOMMIT
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		///modified end by ZY0255 20210301
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBenefitEquipList",JsonData,.PLIST)
	    s RowID = JsonData.BELRowID
	    ///modified by ZY0254 20210203
	    s EquipID=JsonData.BELEquipDR
	    if EquipID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","设备不能为空")
	    s tmpRowID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID,0))
	    s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	    if ((tmpRowID'="")&&(tmpRowID'=RowID)) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",EquipNo_"设备不能重复添加!")
		s PLIST(17) = "0"	;Status
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQBenefitEquipList Values :PLIST() where BEL_RowID = :RowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQBenefitEquipList Values :PLIST())
			s RowID=$g(%ROWID)
			/// add by ZY0260 20210428
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			s SQLCODE=##class(web.DHCEQ.BA.BUSBenefitEquipList).TranDataFromBuyArg(RowID)
		}
	}
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s EquipID=$p($g(^DHCEQBenefitEquipList(RowID)),"^",1)
	//add by wy 2020-6-25 新增效益设备属性
	i (EquipID'="")&&(##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute(3,EquipID,41)=0)
	{
		    //modified by wy 2022-6-29 效益设备属性生成 2756907
		    //modified by wy 2022-7-11 去除多余判断条件 2756907
			s EARowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code","41",0))
			s PLIST(2)=EARowid
			s PLIST(3)=3
			s PLIST(4)=EquipID
			&SQL(insert into SQLUSER.DHC_EQEquipAttributeList Values :PLIST())
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
	}
	i DeviceMapdataList'=""
	{
		s SQLCODE=##Class(web.DHCEQ.BA.BUSDeviceMap).SaveDeviceMapDataList(DeviceMapdataList,EquipID)
		If SQLCODE
		{
			TROLLBACK
			/// modified by ZY0259 20210420  返回值处理
			s SQLCODE=$p(SQLCODE,"^",1)
			i SQLCODE="-1000" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"仪器已经对照在其他设备上,不能重复对照.")
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	i UseContextYeardataList'=""
	{
		s SQLCODE=##Class(web.DHCEQ.BA.BUSUseContext).SaveUseContextDataList(UseContextYeardataList,EquipID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	i UseContextMonthdataList'=""
	{
		s SQLCODE=##Class(web.DHCEQ.BA.BUSUseContext).SaveUseContextDataList(UseContextMonthdataList,EquipID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//modified by ZY0217 2020-04-08
	i ResearchdataList'=""
	{
		s SQLCODE=0
		Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
		s Length=$L(ResearchdataList,SplitRowCode)
		for i=1:1:Length
		{
			q:SQLCODE'=0
			s valList=$p(ResearchdataList,SplitRowCode,i)
			q:valList=""
			s SQLCODE=##Class(web.DHCEQ.EM.BUSResearch).SaveDataList(valList,0)
		}
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORSaveData
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ErrorMsg)
}

/// modified by ZY0279 20210907
/// 设备使用信息采集，一般每天凌晨采集前一天的数据
/// 先获取接口类型,然后循环MonthStr 月份内的每一天采集数据
/// w ##Class(web.DHCEQ.BA.BUSBenefitEquipList).GatherData(1,1,"DHC-HIS","2020-01-01","2020-01-31")
/// w ##Class(web.DHCEQ.BA.BUSBenefitEquipList).GatherData(1,2,"DHC-RIS","2019-01-01","2020-06-10")
ClassMethod GatherData(vSourceType, vSourceID, vInterfaceType, vStartDate, vEndDate, updateFlag As %Library.String = "")
{
	new Result,Date,LISVersion,RISVersion,CurMonthStr
	s vStartDate=##class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	s vEndDate=##class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	i vStartDate>vEndDate Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","开始日期不能比结束日期大!")
	
	
	s Result=0
	if vSourceType=1
	{
		f Date=(vStartDate-1):1:vEndDate
		{
			q:Result'=0
			if (vInterfaceType="DHC-HIS")
			{
				//s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCHIS(Date)
				s Result= ##Class(web.DHCEQ.BA.BUSGather).GatherDHCHISNew(Date)
			}
			elseif (vInterfaceType="DHC-LIS")
			{
				s LISVersion=##class(web.DHCEQCommon).GetSysInfo("992001")
				if (LISVersion=0)
				{
					//现在使用旧LIS的医院比较少，暂时不改造接口
					//s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCLIS(Date)
				}
				elseif (LISVersion=1)
				{
					s Result= ##Class(web.DHCEQ.BA.BUSGather).GatherDHCLISNew(Date,vSourceID)	
				}
			}
			elseif (vInterfaceType="DHC-RIS")
			{
				s RISVersion=##class(web.DHCEQCommon).GetSysInfo("992002")
				if (RISVersion=0)
				{
					//现在使用旧LIS的医院比较少，暂时不改造接口
					//s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCRIS(Date)
				}
				elseif (RISVersion=1)
				{
					s Result= ##Class(web.DHCEQ.BA.BUSGather).GatherDHCRISNew(Date,vSourceID)	
				}
				elseif (RISVersion=9)
				{
					s Result=##Class(web.DHCEQ.BA.BUSGather).GatherThirdParty(Date,"Ris",vSourceID)
				}
			}
		}
		///采集完使用记录,直接汇总每月数据到UseContext中
		if Result=0
		{
			s CurMonthStr=$E($ZD(+$H,3),1,7)
			f Date=vStartDate:1:vEndDate
			{
				q:Result'=0
				s Year=+$E($ZD(Date,3),1,4)
				s Month=+$E($ZD(Date,3),6,7)
				i Month<10 s Month="0"_Month
				s MonthStr=Year_"-"_Month
				q:CurMonthStr=MonthStr
				//汇总Stat表
				s Result=##Class(web.DHCEQ.BA.BUSUseRecordStat).GatherUseRecordStat(MonthStr,vSourceType, vSourceID)
				q:Result'=0
				s Result=##Class(web.DHCEQ.BA.BUSUseContext).AutoCreateUseContext(MonthStr,vSourceID,updateFlag)
				i Month=12  d
				.s Year=Year+1
				.s Month=1
				e  d
				.s Month=Month+1
				s Date=$ZDH(Year_"-"_Month_"-01",3) - 1
			}
		}
	}
	else
	{
		
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Result)
}

/// add by wy 2020-6-25 保存效益设备
/// 入参：设备ID串EquipIDs
/// 输出:Num_"^"_ErrorMess
/// w ##Class(web.DHCEQ.BA.BUSBenefitEquipList).SaveEquipData("5")
ClassMethod SaveEquipData(EquipIDs As %String = "")
{
	new EquipDR,ErrorFlag
	s ErrorMess=""
	s Num=0
	s Len=$l(EquipIDs,",")
 	f i=1:1:Len d
 	.s EquipDR=$p(EquipIDs,",",i) 
 	.s EquipDR="{""BELEquipDR"":"""_EquipDR_"""}"
    .s result=##class(web.DHCEQ.BA.BUSBenefitEquipList).SaveData(EquipDR,"0","","","","")	//更新
 	.s result=##class(web.DHCEQ.Plat.JsonObject).FromJSON(result)		//CZF0131 2021-01-20
 	.if result.%Get("SQLCODE")=0 d
 	..s Num=Num+1
 	..s ErrorFlag=result.%Get("SQLCODE")
 	.e  d
 	..s ErrorFlag=result.%Get("SQLCODE")
 	..i ErrorMess="" d
 	...s ErrorMess=$p($g(^DHCEQEquip(EquipDR)),"^",71)
 	..e  d
 	...s ErrorMess=ErrorMess_","_$p($g(^DHCEQEquip(EquipDR)),"^",71)
 	q Num_"^"_ErrorMess
}

/// add by wy 2020-6-25 保存效益设备
/// 入参：设备ID串EquipIDs
/// "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TServiceHandler:%String,TServiceTel:%String,TStatCatDR:%String,TStatCat:%String,TModelDR:%String,TEquiCatDR:%String,TUnitDR:%String,TCountryDR:%String,TManageLocDR:%String,TManageLevelDR:%String,TWorkLoadUnitDR:%String,TUseLocDR:%String,TOriginDR:%String,TFromDeptDR:%String,TToDeptDR:%String,TBuyTypeDR:%String,TEquipTechLevelDR:%String,TProviderDR:%String,TManuFactoryDR:%String,TKeeperDR:%String,TEquipTypeDR:%String,TPurchaseTypeDR:%String,TPurposeTypeDR:%String"
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitEquipList","GetBenefitEquip","",0)
Query GetBenefitEquip(Data As %String, ReadOnly) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TManuFactoryNo:%String,TManuFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%Float,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TLocation:%String,TGuaranteePeriodNum:%String,TStatCatDR:%String,TStatCat:%String,TFundsFee:%String,TFileNo:%String,TRentLocDR:%String,TRentStatus:%String,TFaultStatus:%String,TDisuseDate:%String,TAccountNo:%String,Thold6:%String,Thold7:%String,Thold8:%String,Thold9:%String,Thold10:%String,TAdvanceDisFlag:%String,TInStockNo:%String,TCommonName:%String,TFundsInfo:%String,TPayNo:%String,TUnusualRemark:%String,TRow:%String,TContractNo:%String,TBackColor:%String,TStartDateFlag:%String,THasDoc:%String,THasFile:%String,TReciveDate:%String,TConfigFlag:%String,TCurDepreFee:%String,TDepreMonths:%String,TReDepreMonths:%String")
{
}

ClassMethod GetBenefitEquipExecute(ByRef qHandle As %Binary, vData As %String, ReadOnly) As %Status
{
	Set curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	Set CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	Set CurGroupID=%session.Get("LOGON.GROUPID")
 	new repid, index,rowid,vStoreLocDR,TotalNum,TotalFee,TTotalFundsFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set InitFlag=##class(web.DHCEQCommon).GetDataByName(vData,"InitFlag")
 	if InitFlag="Y" Quit $$$OK
 	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set No=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"No"),"U")
 	Set Name=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Name"),"U")
 	Set Status=##class(web.DHCEQCommon).GetDataByName(vData,"Status")
 	Set MinValue=##class(web.DHCEQCommon).GetDataByName(vData,"MinValue")
 	Set MaxValue=##class(web.DHCEQCommon).GetDataByName(vData,"MaxValue")
 	Set ProviderDR=##class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
 	Set EquipTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
 	Set QXType=##class(web.DHCEQCommon).GetDataByName(vData,"QXType")
	Set MIHold1=##class(web.DHCEQCommon).GetDataByName(vData,"MIHold1")
	Set Name=##Class(web.DHCEQCommon).Trim(Name)
	Set EquipAttributeString=##class(web.DHCEQCommon).GetDataByName(vData,"EquipAttributeString")  //add by csj 20191129 
	Set index=2
	Set rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))	q:rowid=""  d
	.d ResetVariablesBenefitEquip
	.d BuildBenefitEquipDate
	quit $$$OK
BuildBenefitEquipDate
    s TRowID=rowid
	s EquipData=$g(^DHCEQEquip(rowid))
	s TName = $ZCONVERT($p(EquipData,"^",1),"U")  // 设备名称
	q:(Name'="")&&(TName'[Name)
   	s TUseLocDR = $p(EquipData,"^",19)
	q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)  //
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
    s TProviderDR = $p(EquipData,"^",25)
	q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
	i TProviderDR '=""  d
	.s TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    s TOriginalFee = $p(EquipData,"^",27)
	q:(MinValue'="")&&(MinValue>TOriginalFee)	
	q:(MaxValue'="")&&(MaxValue<TOriginalFee)
    s TStatus = $p(EquipData,"^",38)  //modify by lmm 2018-09-14 684036
	q:((Status'="")&&(Status'=TStatus))||(TStatus=3)
    s TEquipTypeDR = $p(EquipData,"^",63)
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	q:(EquipTypeDR="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID,"",""))
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    s TNo = $p(EquipData,"^",71)
	q:(No'="")&&(TNo'=No)
	s hasFlag=1
	i $o(^DHCEQBenefitEquipList(0,"Equip",rowid,0))="" s hasFlag=0
	q:hasFlag'=0 
	
	s TABCType = $p(EquipData,"^",2)
	s TModelDR = $p(EquipData,"^",3)
	s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	s TEquiCatDR = $p(EquipData,"^",4)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	s TUnitDR = $p(EquipData,"^",5)
	i TUnitDR '=""  d
	.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TInstallLocDR = $p(EquipData,"^",8)
	i TInstallLocDR '=""  d
	.s TInstallLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TInstallLocDR)
	s TInstallDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",9),"date")
	s TLeaveFactoryNo = $p(EquipData,"^",10)
	s TLeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11),"date")
	s TOpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",12),"date")
	s TCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",13),"date")
	s TMakeDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",14),"date")
	s TComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(rowid)    //modify by jyp 2019-09-01    设备属性相关调整
	s TCountryDR = $p(EquipData,"^",16)
	i TCountryDR '=""  d
	.s TCountry = ##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	s TManageLocDR = $p(EquipData,"^",17)
	i TManageLocDR '=""  d
	.s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	s TManageLevelDR = $p(EquipData,"^",18)
	i TManageLevelDR '=""  d
	.s TManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",TManageLevelDR)),"^",2)

	s TOriginDR = $p(EquipData,"^",20)
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	s TFromDeptDR = $p(EquipData,"^",21)
	i TFromDeptDR '=""  d
	.s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	s TToDeptDR = $p(EquipData,"^",22)
	i TToDeptDR '=""  d
	.s TToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TToDeptDR)),"^",2)
	s TBuyTypeDR = $p(EquipData,"^",23)
	i TBuyTypeDR '=""  d
	.s TBuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	s TEquipTechLevelDR = $p(EquipData,"^",24)
	i TEquipTechLevelDR '=""  d
	.s TEquipTechLevel = $p($g(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	s TManuFactoryDR = $p(EquipData,"^",26)
	i TManuFactoryDR '=""  d
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	s TQuantity=1
	s TNetFee = $p(EquipData,"^",28)
	s TNetRemainFee = $p(EquipData,"^",29)
	s TGroupDR = $p(EquipData,"^",30)
	i TGroupDR '=""  d
	.s TGroup =$p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TLimitYearsNum = $p(EquipData,"^",31)
	s TContractListDR = $p(EquipData,"^",32)
	i TContractListDR '=""  d
	.s TContractList = $p($g(^DHCEQContractList(TContractListDR)),"^",1)
	s TDepreMethodDR = $p(EquipData,"^",33)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TRemark = $p(EquipData,"^",34)
	s TDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",35),"")
	s TDesignWorkLoadNum = $p(EquipData,"^",36)
	s TWorkLoadUnitDR = $p(EquipData,"^",37)
	i TWorkLoadUnitDR '=""  d
	.s TWorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	s TDisplayStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStatusDisplay(TStatus)
	s TManageUserDR = $p(EquipData,"^",39)
	i TManageUserDR '=""  d
	.s TManageUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	s TMaintUserDR = $p(EquipData,"^",40)
	i TMaintUserDR '=""  d
	.s TMaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	s TProviderHandler = $p(EquipData,"^",41)
	s TProviderTel = $p(EquipData,"^",42)	
	s TAppendFeeTotalFee = $p(EquipData,"^",43)
	s TStartDateFlag=$p(EquipData,"^",44)
	s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
	s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
	s TGuaranteeFlag = $p(EquipData,"^",46)
	s TInputFlag = $p(EquipData,"^",47)
	s TTestFlag = $p(EquipData,"^",48)
	s TMedicalFlag = $p(EquipData,"^",49)
	s TGuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",50),"date")
	s TGuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",51),"date")
	s TAddUserDR = $p(EquipData,"^",52)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",53),"date")
	s TAddTime = $p(EquipData,"^",54)
	s TUpdateUserDR = $p(EquipData,"^",55)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",56),"date")
	s TUpdateTime = $p(EquipData,"^",57)
	s TCurrencyDR = $p(EquipData,"^",58)
	i TCurrencyDR '=""  d
	.s TCurrency = ##class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	s TInvalidFlag = $p(EquipData,"^",59)
	s TStockStatus=$p(EquipData,"^",60) //判断是否还未入库
	q:TStockStatus="0"    

	s TDisplayStockStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStockStatusDisplay(TStockStatus)
	;s TMemoryCode = $p(EquipData,"^",61)
	s TUrgencyFlag = $p(EquipData,"^",62)
	s TPurchaseTypeDR = $p(EquipData,"^",64)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TPurposeTypeDR = $p(EquipData,"^",65)
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TKeeperDR = $p(EquipData,"^",66)
	i TKeeperDR '=""  d
	.s TKeeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	s TStoreLocDR = $p(EquipData,"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s TStartDepreMonth = $p(EquipData,"^",68)
	s TServiceDR = $p(EquipData,"^",69)
	i TServiceDR '=""  d
	.s TService = ##Class(web.DHCEQCommon).GetTrakNameByID("cservice",TServiceDR) //$p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1) //CZF0093
	s TInStockListDR = $p(EquipData,"^",70)
	i TTransAssetDate="" d //2009-09-19 党军 begin 无转资日期显示入库审核日期
	.i TInStockListDR '=""  d
	..s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	..s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TInStockList)),"^",13),"date") //2009-09-19 党军 end
	i TInStockListDR '=""  d
	.s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	.i TInStockList'="" s TInStockList = $p($g(^DHCEQInStock(TInStockList)),"^",14)
	.s TPayNo=##class(web.DHCEQPayRecord).GetPayNo("1",TInStockListDR) //2014-7-18 HZY0056
	s TLocationDR = $p(EquipData,"^",72)
	i TLocationDR'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	
	s TGuaranteePeriodNum = $p(EquipData,"^",73)
	s TStatCatDR=$p(EquipData,"^",75)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TContractNo = $p(EquipData,"^",76)
	//add by jdl 2010-8-24
	s TFileNo=$p(EquipData,"^",85)
	s TRentLocDR=$p(EquipData,"^",86)
	s TRentStatus=$p(EquipData,"^",87)
	s TFaultStatus=$p(EquipData,"^",88)
	s TDisuseDate=$p(EquipData,"^",89)
	i TDisuseDate'="" s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
	s TAccountNo=$p(EquipData,"^",90)
	s Thold6=$p(EquipData,"^",91) //2011-08-08 DJ begin
	s Thold7=$p(EquipData,"^",92)
	s Thold8=$p(EquipData,"^",93)
	s TUnusualRemark=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",9)
	s Thold9=$p(EquipData,"^",94)
	i Thold9'="" s Thold9=$p($g(^DHCEQCCode("DHCEQCBrand",Thold9)),"^",3)
	s Thold10=$p(EquipData,"^",95) //2011-08-08 DJ end
	s TFundsInfo=##Class(web.DHCEQ.EM.BUSEquip).GetFundsInfo(TRowID) //2014-6-20 HZY0055 增加资金来源描述信息的显示
	;文本资料和电子资料标记
	s THasDoc=##Class(web.DHCEQDoc).HasDoc(TRowID)
	s THasFile=##Class(web.DHCEQDoc).HasFile(TRowID)
	s TReciveDate=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",8)
	i TReciveDate'="" s TReciveDate=##Class(web.DHCEQCommon).TransValueToPage(TReciveDate,"date")
	i $p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",24)'="" s TConfigFlag="Y"	; Mozy	754500	2018-12-6
	s TCurDepreFee=##Class(web.DHCEQ.EM.BUSEquip).GetCurMonthDepre(rowid)
	s TDepreSetDR=$o(^DHCEQDepreSet(0,"Equip",rowid,""))
	i TDepreSetDR'="" d
	.s TDepreMonths=+$p($g(^DHCEQDepreSet(TDepreSetDR)),"^",22)
	.s TReDepreMonths=TLimitYearsNum*12-TDepreMonths
	.i TReDepreMonths<0 s TReDepreMonths=0
	.d OutputRowBenefitEquip	
	quit
OutputRowBenefitEquip
	s Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TBackColor,TStartDateFlag,THasDoc,THasFile,TReciveDate,TConfigFlag,TCurDepreFee,TDepreMonths,TReDepreMonths)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
ResetVariablesBenefitEquip
	s (TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TBackColor,TStartDateFlag,THasDoc,THasFile,TReciveDate,TConfigFlag,TCurDepreFee,TDepreMonths,TReDepreMonths)=""
	quit
}

ClassMethod GetBenefitEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
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

ClassMethod GetBenefitEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by ZY0260 20210428
/// w ##class(web.DHCEQ.BA.BUSBenefitEquipList).TranDataFromBuyArg(14)
ClassMethod TranDataFromBuyArg(BELRowID)
{
	new EquipID,CTListSourceType,CTListSourceID,BYID,BPID,IFBID,BYListID,IFBSourceType,IFBSourceID,SQLCODE
	s SQLCODE=0
	s EquipID=$p($g(^DHCEQBenefitEquipList(BELRowID)),"^",1)
	s ContractListID=$p($g(^DHCEQEquip(EquipID)),"^",32)
	s (CTListSourceType,CTListSourceID,BYID,BPID,IFBID,BYListID,IFBSourceType,IFBSourceID)=""	
	i ContractListID'="" d
	.s CTListSourceType=$p($g(^DHCEQContractList(ContractListID)),"^",5)
	.s CTListSourceID=$p($g(^DHCEQContractList(ContractListID)),"^",17)
	.//CTListSourceType:1-计划;  2-招标
	.i CTListSourceType=1 d
	..s BPID=$p($g(^DHCEQBuyPlanList(CTListSourceID)),"^",1)
	..s BYListID=$p($g(^DHCEQBuyPlanList(CTListSourceID)),"^",10)
	.e  i CTListSourceType=2 d
	..s IFBID=$p($g(^DHCEQIFBBag(CTListSourceID)),"^",1)
	..s IFBSourceType=$p($g(^DHCEQIFBBag(CTListSourceID)),"^",9)
	..s IFBSourceID=$p($g(^DHCEQIFBBag(CTListSourceID)),"^",10)
	..//IFBSourceType:1-申请;  2-计划
	..i IFBSourceType=1 d
	...s BYID=$p($g(^DHCEQBuyRequestList(IFBSourceID)),"^",1)
	..e  i IFBSourceType=2 d
	...s BPID=$p($g(^DHCEQBuyPlanList(IFBSourceID)),"^",1)
	...s BYListID=$p($g(^DHCEQBuyPlanList(IFBSourceID)),"^",10)
	i BYListID="" q 0
	//i BYListID'="" s BYID=$p($g(^DHCEQBuyRequestList(BYListID)),"^",1)
	
	s ESServiceID=0
	f  s ESServiceID=$o(^DHCEQEquipService(0,"BussSource",1,3,BYListID,ESServiceID))  q:(ESServiceID="")||(SQLCODE'=0)  d
	.s ESRowID=0
	.f  s ESRowID=$o(^DHCEQEquipService(0,"BussSource",1,3,BYListID,ESServiceID,ESRowID))  q:(ESRowID="")||(SQLCODE'=0)  d
	..s ESInvalidFlag=$p($g(^DHCEQEquipService(ESRowID)),"^",9)
	..q:ESInvalidFlag="Y"
	..k ESPLIST
	..&SQL(select * into :ESPLIST() from sqluser.DHC_EQEquipService Where ES_RowID=:ESRowID)
	..s ESPLIST(1)=""                         //RowID置空
	..s ESPLIST(2)="1"                      	//源类型:1:设备 2:设备项 3：采购申请明细/论证模板明细
	..s ESPLIST(3)=EquipID
	..s ESPLIST(11)="0"
	..&SQL(Insert Into SQLUSER.DHC_EQEquipService Values :ESPLIST())
	..i SQLCODE=100 s SQLCODE=0
	
	s SICRowID=0
	f  s SICRowID=$o(^DHCEQCServiceConsumable(0,"BussSource",1,3,BYListID,SICRowID))  q:(SICRowID="")||(SQLCODE'=0)  d
	.k SCPLIST
	.&SQL(select * into :SCPLIST() from sqluser.DHC_EQCServiceConsumable Where SIC_RowID=:SICRowID)
	.s SCPLIST(1)=""                         //RowID置空
	.s SCPLIST(2)="1"                      	//源类型:1:设备 2:设备项 3：采购申请明细/论证模板明细
	.s SCPLIST(3)=EquipID
	.s SCPLIST(20)="0"
	.&SQL(Insert Into SQLUSER.DHC_EQCServiceConsumable Values :SCPLIST())
	.i SQLCODE=100 s SQLCODE=0
	
	s RRowID=0
	f  s RRowID=$o(^DHCEQResearch(0,"SourceType",1,1,BYListID,RRowID))  q:(RRowID="")||(SQLCODE'=0)  d
	.k SCPLIST
	.&SQL(select * into :RPLIST() from sqluser.DHC_EQResearch Where R_RowID=:RRowID)
	.s RPLIST(1)=""                         //RowID置空
	.s RPLIST(2)="0"
	.s RPLIST(3)="2"						//业务类型(暂定为1)  2 设备  3  年度评价表
	.s RPLIST(4)=EquipID                      	//业务ID(指向BuyRequest)  DHC_EQEquip   DHC_EQUseContext
	.&SQL(Insert Into SQLUSER.DHC_EQResearch Values :RPLIST())
	.i SQLCODE=100 s SQLCODE=0
	///add by ZY 20211009
	s ECRowID=0
	f  s ECRowID=$o(^DHCEQEconCalc(0,"Source",1,BYListID,"Y",ECRowID))  q:(ECRowID="")||(SQLCODE'=0)  d
	.k ECPLIST
	.&SQL(select * into :ECPLIST() from sqluser.DHC_EQEconCalc Where EC_RowID=:ECRowID)
	.s ECPLIST(1)=""                         //RowID置空
	.s ECPLIST(2)=""						//业务类型(暂定为1)  采购申请明细ID
	.s ECPLIST(3)=""						//业务类型(暂定为1)  2 设备  3  年度评价表
	.s ECPLIST(4)=EquipID                   //DHC_EQEquip
	.&SQL(Insert Into SQLUSER.DHC_EQEconCalc Values :ECPLIST())
	.i SQLCODE=100 s SQLCODE=0
	
	q SQLCODE
}

/// czf 2021-03-09 1789983
/// w ##Class(web.DHCEQ.BA.BUSBenefitEquipList).SaveDataList("")
ClassMethod SaveDataList(data As %String = "", DelFlag As %String = "")
{
	s length=$l(data,"&")
	s Flag=0
	f i=1:1:length d
	.q:Flag'=0
	.s list=$p(data,"&",i)
	.s TRowID=$p(list,"^",1)
	.q:TRowID=""
	.s THold1=$p(list,"^",2)
	.&SQL(Update SQLUSER.DHC_EQBenefitEquipList set BEL_Hold1=:THold1 where BEL_RowID=:TRowID)
	.i SQLCODE s Flag=SQLCODE
	.q:SQLCODE
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Flag)
}

}
