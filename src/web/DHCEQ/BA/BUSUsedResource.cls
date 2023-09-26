/// Add by ZY0247 20201222
Class web.DHCEQ.BA.BUSUsedResource Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 写每月消耗材料的成本数据
/// d ##class(web.DHCEQ.BA.BUSUsedResource).SaveUsedResource("2017","7","2","13383","12","200")
ClassMethod SaveUsedResource(Year, Month, SourceType, SourceID, dataList, InputFlag)
{
	new SQLCODE
	s SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)
		q:valList=""
		s SQLCODE=##Class(web.DHCEQ.BA.BUSUsedResource).SaveData(Year, Month, SourceType, SourceID,valList,InputFlag)
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,SQLCODE)
}

/// w ##Class(web.DHCEQ.BA.BUSUsedResource).SaveData("2019","11",1,496,"")
ClassMethod SaveData(Year, Month, SourceType, SourceID, datalist, InputFlag, RowID As %String = "", DelIs As %String = "")
{
	new JsonData,SQLCODE,ResourceTypeDR,RowidFind,URRowID
	s SQLCODE=0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	if (DelIs=1)
	{
	 	&SQL(delete from SQLUSER.DHC_EQUsedResource where UR_RowID = :RowID) 
	}
	else
	{
		k URLIST
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(datalist)
	 	s URRowID=JsonData.TRowID
		
		//取材料成本类型ID
		s ResourceTypeDR=""
	 	s ResourceTypeCode=JsonData.TTypeCode
		&SQL(select RT_RowID into :ResourceTypeDR from SQLUSER.DHC_EQCResourceType where RT_Code=:ResourceTypeCode and RT_InvalidFlag<>'Y')
		i ResourceTypeDR="" q "-1000"
	 	s URLIST(2)=Year
	 	s URLIST(3)=Month
	 	s URLIST(4)=SourceType
	 	s URLIST(5)=SourceID
	 	s URLIST(6)=ResourceTypeDR
	 	i InputFlag="Y" 
	 	{
			s URLIST(10)=JsonData.TAmount	
		}
		else
		{
			s URLIST(10)=##Class(web.DHCEQ.BA.BUSUsedResource).GetResourceDataByCode(ResourceTypeCode,SourceID,Year,Month)
		}
	 	
	 	s URLIST(12)=Date
	 	s URLIST(13)=Time
	 	s URLIST(14)=User
		s URLIST(19)=2
	 	s URLIST(31)=InputFlag		//czf 2022-01-28
	 	//s URLIST(32)=PayAmount
	 	s RowidFind=""
		&SQL(select UR_RowID into :RowidFind from SQLUSER.DHC_EQUsedResource where UR_Year=:Year and UR_Month=:Month and UR_SourceType=:SourceType and UR_SourceID=:SourceID and UR_ResourceTypeDR=:ResourceTypeDR)
		i URRowID=""
		{
			i (RowidFind="")
			{
			 	&SQL(Insert into SQLUSER.DHC_EQUsedResource Values :URLIST())
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQUsedResource Values :URLIST() where UR_RowID = :RowidFind)
			}
		}
		else
		{
			i ((RowidFind="")||(RowidFind=URRowID))
			{
				&SQL(Update SQLUSER.DHC_EQUsedResource Values :URLIST() where UR_RowID = :URRowID)
			}
			else
			{
				s SQLCODE="-1001"
			}
		}
		i SQLCODE=100 s SQLCODE=0
	}
	q SQLCODE
}

/// Add by ZY0285 20211201
/// 写入设备使用资源数据到DHC_EQUsedResource
/// 入参：Year
/// 	  Month
/// 	  SourceType  		1,设备
/// 	  SourceID	    	设备ID
/// 	  ResourceTypeID	资源类型ID
/// 	  Amount			金额
/// 	  PayAmount			金额
/// 	返回：SQLCODE  0  成功
/// d ##class(web.DHCEQ.BA.BUSUsedResource).SaveUsedResource("2017","7","2","13383","12","200")
ClassMethod SaveUsedResourceDate(Year, Month, SourceType, SourceID, ResourceTypeID, Amount, PayAmount As %String = 0)
{
	new SQLCODE,RowidFind
	s SQLCODE=0
	k URLIST
 	s URLIST(2)=Year
 	s URLIST(3)=Month
 	s URLIST(4)=SourceType
 	s URLIST(5)=SourceID
 	s URLIST(6)=ResourceTypeID
 	s URLIST(10)=Amount
	s URLIST(19)=2
 	s URLIST(32)=PayAmount
 	s RowidFind=""
	&SQL(select UR_RowID into :RowidFind from SQLUSER.DHC_EQUsedResource where UR_Year=:Year and UR_Month=:Month and UR_SourceType=:SourceType and UR_SourceID=:SourceID and UR_ResourceTypeDR=:ResourceTypeDR)
	
	i (RowidFind="") d
	.&SQL(Insert into SQLUSER.DHC_EQUsedResource Values :URLIST())
	e  d
	.&SQL(Update SQLUSER.DHC_EQUsedResource Values :URLIST() where UR_RowID = :RowidFind)
	.i SQLCODE=100 s SQLCODE=0
	q SQLCODE
}

/// Modifiedby ZY0285 20211201
/// Add by ZY0247 20201222
/// 根据资源代码Code,获取支出费用
/// 入参：ResourceTypeCode	资源代码 这个是DHC_EQCResourceType表的固定值
/// 	  EquipID	设备ID
/// 	  Year	年度
/// 	  Month	月份
/// 	返回：该设备该月份指定资源类型的费用和业务次数  100^10
/// w ##Class(web.DHCEQ.BA.BUSUsedResource).GetResourceDataByCode("05",496,"2019","11")
ClassMethod GetResourceDataByCode(ResourceTypeCode, EquipID, Year, Month)
{
	new Result,MonthStr,StartDate,EndDate
	s MonthStr=Year_"-"_Month
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(##Class(web.DHCEQReport).GetMonthDate(MonthStr,1),"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(##Class(web.DHCEQReport).GetMonthDate(MonthStr,2),"date")
	
	//取材料成本类型ID
	s ResourceTypeDR=""
	&SQL(select RT_RowID into :ResourceTypeDR from SQLUSER.DHC_EQCResourceType where RT_Code=:ResourceTypeCode and RT_InvalidFlag<>'Y')
	s StoreLocDR=$p($g(^DHCEQEquip(EquipID)),"^",67)
	
	s Result=0
	
	if ResourceTypeCode="01"	//人员工资
	{
		s Result=##Class(web.DHCEQ.BA.BUSResourceAllot).GetAllotFee(ResourceTypeDR,EquipID,Year, Month) //modified by wy 2023-03-24 3382287传参错误 begin
	}
	elseif ResourceTypeCode="02"	//培训
	{
		s Result=##Class(web.DHCEQ.BA.BUSResourceAllot).GetAllotFee(ResourceTypeDR,EquipID,Year, Month)
	}
	elseif ResourceTypeCode="03"	//水
	{
		s Result=##Class(web.DHCEQ.BA.BUSResourceAllot).GetAllotFee(ResourceTypeDR,EquipID,Year, Month)
	}
	elseif ResourceTypeCode="04"	//电
	{
		s Result=##Class(web.DHCEQ.BA.BUSResourceAllot).GetAllotFee(ResourceTypeDR,EquipID,Year, Month) //modified by wy 2023-03-24 3382287传参错误 end
	}
	elseif ResourceTypeCode="05"
	{
		s Result=##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"35","","","")
	}
	elseif ResourceTypeCode="07"
	{
		s Result=##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"31","","","")
	}
	elseif ResourceTypeCode="08"
	{
		s Result=##Class(web.DHCEQ.BA.BUSUsedResource).GetGuaranteeFee(EquipID,StartDate,EndDate)
	}
	/// modified by ZY0283 20211117
	///32:保养;  33:MaintTypeDR=4  巡检, MaintTypeDR=5 计量
	elseif ResourceTypeCode="09"
	{
		s Result=##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"32","","","")
	}
	elseif ResourceTypeCode="10"
	{
		s Result=##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"33","","","",4)
	}
	elseif ResourceTypeCode="11"
	{
		s Result=##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"33","","","",5)
	}
	elseif ResourceTypeCode="14"
	{
	 	s RowidFind=""
	 	&SQL(select UC_RowID into :RowidFind from SQLUSER.DHC_EQUseContext where UC_Year=:Year and UC_Month=:Month and UC_EquipDR=:EquipID)
	 	i RowidFind'="" s Result=$p($g(^DHCEQUseContext(RowidFind)),"^",46)	// modifeid by ZY0296 
	}
	q Result
}

/*
/// 方法位置移动到##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo()
/// modified by ZY0283 20211117
/// Add by ZY0247 20201222
/// 根据声明周期信息,获取支出费用
/// 入参：EquipDR	要获取费用的设备
/// 	  StartDate	费用开始日期
/// 	  EndDate	费用结束日期
/// 	  SourceType	费用类型  31:维修、32保养、33检查、35折旧
/// 	  MaintTypeDR  =4  巡检, MaintTypeDR=5 计量	
/// 	返回：该设备该日期段支出该项费用
/// w ##Class(web.DHCEQ.BA.BUSUsedResource).GetOutFeeByLifeInfo("05",496,"2019","11")
ClassMethod GetOutFeeByLifeInfo(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", SourceType As %String = "", MaintType As %String = "")
{
	n Start,End,LIRowID,Amount,rate
	i (EquipDR="")||(StartDate="")||(EndDate="")||(SourceType="") q 0
	i StartDate>EndDate q 0
	s Amount=0
	//add by zx 2015-10-21 判断机组,取机组整体折旧等费用 Bug ZX0047
	s EquipGroupID=##class(web.DHCEQBenefitAnalyReport).CheckGroupEquip(EquipDR)  //27834
	
	i EquipGroupID=0
	{
		s rate=1
		s Start=StartDate-1
		d SumAmount
	}
	else
	{
		s GroupListID=0
		f  s GroupListID=$o(^DHCEQGroupList(0,"Group",EquipGroupID,GroupListID)) q:GroupListID=""  d
		.s EquipDR=$p($g(^DHCEQGroupList(GroupListID)),"^",2)
		.s rate=$p($g(^DHCEQGroupList(GroupListID)),"^",9)
		.s Start=StartDate-1
		.d SumAmount
	}
	
	q Amount
SumAmount
	///modified by ZY0255 20210228
	s End=EndDate
	;^DHCEQLifeInfo(0,"EquipSourceDate",{LI_EquipDR},{LI_SourceType},{LI_ChangeDate},{LI_RowID})
	f  s Start=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start)) q:(Start="")||(Start>End)  d
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start,LIRowID))  q:LIRowID=""  d
	..q:(MaintType=4)&&($p($g(^DHCEQLifeInfo(LIRowID)),"^",13)="巡检")
	..q:(MaintType=5)&&($p($g(^DHCEQLifeInfo(LIRowID)),"^",13)="计量")
	..s Amount=Amount+($p($g(^DHCEQLifeInfo(LIRowID)),"^",17)*rate)	;Fee
	q
}
*/
/// Add by ZY0247 20201222
/// 描述:增加获取保修合同费
/// 入参：SourceID	要获取费用的设备
/// 	  StartDate	费用开始日期
/// 	  EndDate	费用结束日期
/// w ##Class(web.DHCEQ.BA.BUSUsedResource).GetGuaranteeFee(116,+$H,+$H)
ClassMethod GetGuaranteeFee(SourceID, StartDate, EndDate)
{
	new Months,GFSumFee,CTLRowID,GFSumFee
	i (SourceID="")||(StartDate="")||(EndDate="") q 0
	i StartDate>EndDate q 0
	
	s Months=##Class(web.DHCEQ.BA.BUSUsedResource).GetMonthNum(StartDate,EndDate)
	
	s GFSumFee=0
	
	s CTLRowID=0
	f  s CTLRowID=$o(^DHCEQContractList(0,"SourceID",2,SourceID,CTLRowID)) q:CTLRowID=""  d
	.s CTRowID=$p($g(^DHCEQContractList(CTLRowID)),"^",1)
	.s TotalFee=$p($g(^DHCEQContractList(CTLRowID)),"^",8)
	.s ContractType=$p($g(^DHCEQContract(CTRowID)),"^",39)   //0:采购，1：保修
	.q:ContractType'=1
	.s Status=$p($g(^DHCEQContract(CTRowID)),"^",24)
	.q:Status'=2
	.s GFStartDate=$p($g(^DHCEQContract(CTRowID)),"^",49)  //保修开始日期
	.q:GFStartDate=""
	.s GFEndDate=$p($g(^DHCEQContract(CTRowID)),"^",50)    //保修结束日期
	.q:GFEndDate=""
	.s GFTotalFee=$p($g(^DHCEQContract(CTRowID)),"^",5)    //保修费用
	.q:(GFTotalFee=0)||(GFTotalFee="")
	.s CTLTotalFee=0
	.s RowID=0
	.f  s RowID=$o(^DHCEQContractList(0,"Contract",CTRowID,RowID)) q:RowID=""  d
	..s CTLTotalFee=CTLTotalFee+$p($g(^DHCEQContractList(RowID)),"^",8)   //合同设备总价
	.q:CTLTotalFee=0
	.s GFStartDate=$ZDH($E($ZD(GFStartDate,3),1,7)_"-01",3)
	.s GFEndDate=$ZDH($E($ZD(GFEndDate,3),1,7)_"-01",3)
	.f Num=0:1:Months  d
	..s YearMonth=##Class(web.DHCEQCommon).GetYearMonth(StartDate,Num)
	..s CurYearMonth=$ZDH(YearMonth_"-01",3)
	..s GFFee=0
	..i (CurYearMonth>=GFStartDate)&&(CurYearMonth<GFEndDate)  d
	...s TotalMonth=##Class(web.DHCEQ.BA.BUSUsedResource).GetMonthNum(GFStartDate,GFEndDate)+1
	...s GFFee=(GFTotalFee/TotalMonth)*(TotalFee/CTLTotalFee)
	..s GFSumFee=GFSumFee+GFFee            //modified by czf 393720 end
		
	q GFSumFee
}

/// Add by ZY0247 20201222
/// w ##Class(web.DHCEQ.BA.BUSUsedResource).GetMonthNum("62000","62030")
ClassMethod GetMonthNum(StartDate, EndDate)
{
	new vStartDate,vEndDate,SYear,SMonth,EYear,EMonth,Return
	s vStartDate=$ZD(StartDate,3)
	s vEndDate=$ZD(EndDate,3)
	s SYear=+$p(vStartDate,"-",1)
	s SMonth=+$p(vStartDate,"-",2)
	s EYear=+$p(vEndDate,"-",1)
	s EMonth=+$p(vEndDate,"-",2)
	s Return=(EYear-SYear)*12+EMonth-SMonth
	q Return
}

/// Add by ZY0285 20211201
/// 判断设备是否可以使用资源类型
/// 入参：ResourceTypeID	资源类型ID
/// 	  EquipID	设备ID
/// flag：1,使用;0,不使用
/// w ##Class(web.DHCEQ.BA.BUSUsedResource).CheckCanUseResource
ClassMethod CheckCanUseResource(ResourceTypeID, EquipID)
{
	s flag=0
	s SourceID=0
	f  s SourceID=$o(^DHCEQEquipConsumable(0,"Source",1,SourceID)) q:(SourceID="")||(flag'=0)  d
	.s ECRowID=0
	.f  s ECRowID=$o(^DHCEQEquipConsumable(0,"Source",1,SourceID,ResourceTypeID,ECRowID))  q:(ECRowID="")||(flag'=0)  d
	..s InvalidFlag=$p($g(^DHCEQEquip(SourceID)),"^",59)
	..q:InvalidFlag="Y"
	..s flag=1
	i flag'=0 q flag
	
	//设备项
	s SourceID=0
	f  s SourceID=$o(^DHCEQEquipConsumable(0,"Source",2,SourceID)) q:(SourceID="")||(flag'=0)  d
	.s ECRowID=0
	.f  s ECRowID=$o(^DHCEQEquipConsumable(0,"Source",2,SourceID,ResourceTypeID,ECRowID))  q:(ECRowID="")||(flag'=0)  d
	..s Model=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",9)
	..s UseLocDR=0
	..f  s UseLocDR=$o(^DHCEQEquip(0,"LocItem",UseLocDR))  q:(UseLocDR="")||(flag'=0)  d
	...s EQRowID=0
	...f  s EQRowID=$o(^DHCEQEquip(0,"LocItem",UseLocDR,SourceID,EQRowID))  q:(EQRowID="")||(flag'=0)  d
	....s InvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	....q:InvalidFlag="Y"
	....s flag=1
	
	q flag
}

}
