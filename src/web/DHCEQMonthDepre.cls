Class web.DHCEQMonthDepre Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetMonth(monthStr)
{
	s $p(monthStr,"-",2)=$Extract("00",1,2-$LENGTH($p(monthStr,"-",2)))_$p(monthStr,"-",2)
	q monthStr
}

/// ********************************************************
/// ------------------------------------------
/// add by jdl 2010-4-29
/// 重新整理折旧相关信息
/// ------------------------------------------
/// ***********************************************************
/// add by jdl 2010-5-5
/// 获取设备折旧信息
/// SourceType:0 设备   1 分类
/// SourceID：对应的ID
/// DepreTypeDR：1固定的系统主折旧  其他对应的折旧类型ID
/// w ##Class(web.DHCEQMonthDepre).GetDepreSetID(StartDate, EndDate)
ClassMethod GetDepreSetID(SourceType, SourceID, DepreTypeDR)
{
	n (SourceType,SourceID,DepreTypeDR)
	i DepreTypeDR="" q ""
	i SourceType="" q ""
	i SourceID="" q ""
	
	s depreSetID=$o(^DHCEQDepreSet(0,"Source",DepreTypeDR,SourceType,SourceID,0))
	;i (SourceType=0)&&(SourceID>150) b
	i depreSetID=""
	{
		//为设备时，取其分类中的折旧设置
		i SourceType=0
		{			
			s SourceType=1
			s SourceID=$p($g(^DHCEQEquip(SourceID)),"^",4)			
			s depreSetID=..GetDepreSetID(SourceType, SourceID, DepreTypeDR)
		}
		elseif SourceType=1		//当当前分类上未定义折旧设置，则取其父分类上的折旧设置
		{
			s SourceID=$P(^DHCEQCCode("DHCEQCEquipeCat",SourceID),"^",2)
			i +SourceID>0 s depreSetID=..GetDepreSetID(SourceType, SourceID, DepreTypeDR)
		}
	}
	q depreSetID
}

/// add by jdl 2010-5-10
/// 获取两个日期相差的月份(根据会计周期来算)
/// StartDate, EndDate格式：数字
/// w ##Class(web.DHCEQMonthDepre).GetMonthDiffrent(StartDate, EndDate)
ClassMethod GetMonthDiffrent(StartDate, EndDate)
{
	n (StartDate,EndDate)
	
	s $ZT="ErrTrap"
	
	;日期格式需转换为 MM/DD/YYYY,如"7/15/2010"
	s StartDate=$ZD(StartDate,1)	
	i $l(StartDate)=8 s $p(StartDate,"/",3)="19"_$p(StartDate,"/",3)	;Mozy0086
	s StartDate=##Class(web.DHCEQMonthDepre).GetAccountMonth(StartDate)
	s EndDate=$ZD(EndDate,1)
	i $l(EndDate)=8 s $p(EndDate,"/",3)="19"_$p(EndDate,"/",3)	;Mozy0086
	s EndDate=##Class(web.DHCEQMonthDepre).GetAccountMonth(EndDate)
	s qty=##Class(web.DHCEQCommon).DateDiff("m",StartDate,EndDate)
	q qty
ErrTrap
	q ""
}

/// add by jdl 2010-5-10
/// 根据日期获得该日期所在的会计期间
/// vDate格式为 MM/DD/YYYY
/// w ##Class(web.DHCEQMonthDepre).GetAccountMonth("1/27/2010")
ClassMethod GetAccountMonth(vDate)
{
	n (vDate)
	s endDateValue=##class(web.DHCEQCommon).GetSysInfo("901002")
	s startDateValue=##class(web.DHCEQCommon).GetSysInfo("901001")
	s day=##Class(web.DHCEQCommon).DatePart("d",vDate)
	s month=##Class(web.DHCEQCommon).DatePart("m",vDate)
	s year=##Class(web.DHCEQCommon).DatePart("yyyy",vDate)
	i day<startDateValue s month=month-1
	i startDateValue>endDateValue s month=month+1
	i month>12
	{
		s year=year+1
		s month=month-12
	}
	elseif (month<1)
	{
		s year=year-1
		s month=month+12
	}
	q month_"/1/"_year
}

/// modified by ZY0250 20200106  
/// 根据参数PreDepreFlag，进行预折旧计算
/// 生成一个设备在月度折旧
/// EquipID:设备id
/// Month：折旧月份格式（2006-06）
/// DepreMonthDate：折旧月份日期，格式为数字  
/// DepreTypeDR：1固定的系统主折旧  其他对应的折旧类型ID
/// UseTrans: 使用事务 "Y" "N"
/// DepreType 0:正常按月计提1:设备报废一次性计提2:设备附件报废一次性计提附件未计提值
/// AffixID: 附件ID，用于附件报废时，一次性计提附件未提折旧
/// DepreDate：计提日期
/// DepreTime：计提时间
/// 返回值：result:0 成功  	
/// 		-1001(没有对应的折旧设置)；-1002(设置的折旧方法无效)；-1003(设置的折旧年限或折旧率无效)
/// 		-1004插入月度折旧失败;-1005更新折旧设置失败;-1006更新设备台帐失败
/// 		-1007插入生命周期信息失败；-1008插入折旧分摊信息失败
ClassMethod GenerateMonthDepre(EquipID, Month, DepreMonthDate, DepreTypeDR, UseTrans, DepreType, AffixID, PreDepreFlag As %String = "")
{
	s User=1 // ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	n (User,EquipID,Month,DepreMonthDate ,DepreTypeDR, UseTrans, DepreType, AffixID,PreDepreFlag)
	
	;获取设备折旧设置信息
	s vDate=Month_"-01"
	s vDate=$zdh(vDate,3)	
	s DepreSetInfo=..GetDepreSetInfo(EquipID, vDate, DepreTypeDR,"0")
	s FundsDepreInfo=$p(DepreSetInfo,"&",2)
	s DepreSetInfo=$p(DepreSetInfo,"&",1)
	i DepreSetInfo<0 q DepreSetInfo
	
	s depreSetID=$p(DepreSetInfo,"^",2)
	s mainFlag="N"
	i DepreTypeDR =1 s mainFlag="Y"
	i depreSetID="" q "-1001"
	
	s depreMethodType=$p(DepreSetInfo,"^",5)
	s depreMethodDR=$p(DepreSetInfo,"^",6)
	s years=$p(DepreSetInfo,"^",7)
	s rate=$p(DepreSetInfo,"^",8)
	s depreTotal=$p(DepreSetInfo,"^",9)
	s depreTotalFee=$p(DepreSetInfo,"^",10)		//累计折旧总费用
	s depreFee=$p(DepreSetInfo,"^",3)
	;DepreMonths折旧月份不为1，不需折旧
	i $p(DepreSetInfo,"^",4)'=1 q 0	;DepreMonths
		
	s curDate=+$H
	s curTime=$P($H,",",2)
	
	s originalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)		//原值
	s netFee=$p($g(^DHCEQEquip(EquipID)),"^",28)			//净值
	s netRemainFee=$p($g(^DHCEQEquip(EquipID)),"^",29)	//净残值
		
	//设备报废一次性计提
	i (DepreType=1)
	{
		//当折旧方法为平均年限法时计提
		i (depreMethodType=1) s depreFee=originalFee-netRemainFee-depreTotalFee
		i depreFee<0 s depreFee=0		
	}
	elseif ((DepreType=2))	//报废附件一次性计提
	{
		//当折旧方法为平均年限法时计提
		i (depreMethodType=1)	s depreFee=..GetAffixDepreAmount(AffixID,years,depreTotal)
	}
	else   //正常计提
	{
		//当月尚未计提才计提
		i (Month'="2019-01")&($o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,0))'="") q 0  //modify by lmm 2018-12-07
		i (Month="2019-01")
		{
			s CurMDID=$o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,0))
			i CurMDID'=""
			{
				s CurMDRemark=$p($g(^DHCEQMonthDepre(CurMDID)),"^",21)
				i CurMDRemark'="新财务制度补提折旧" q 0
				i $o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,CurMDID))'="" q 0
			}
		}
	}
	i depreFee>0 
	{
		s depreFee=$Number(depreFee,2)
	}
	else
	{
		q depreFee
	}
	
	//获取当月工作量
	s totalworkload=..GetTotalWorkLoad(EquipID,Month)
	//准备折旧数据
	s PLIST(2)=EquipID
	s PLIST(3)=depreSetID
	s PLIST(4)=mainFlag
	s PLIST(5)=depreMethodDR
	s PLIST(6)=originalFee
	s PLIST(7)=Month
	s PLIST(8)=$p(^DHCEQEquip(EquipID),"^",36) // 工作总量
	s PLIST(9)=$p(^DHCEQEquip(EquipID),"^",37) //单位
	s PLIST(10)=years
	s depreTotal=depreTotal+1
	s PLIST(11)=depreTotal //总折旧月份
	//s PLIST(12)=
	s depreTotalFee=depreTotalFee+depreFee
	s PLIST(13)=depreTotalFee
	s PLIST(14)=totalworkload
	s PLIST(15)=depreFee
	
	;Modified by jdl 增加一种折旧设置 2011-8-1 JDL0088
	;s PLIST(18)=netFee //$p(result,"^",28) //设备净值
	s PLIST(18)=originalFee-depreTotalFee
	
	s PLIST(19)=netRemainFee //设备净残值
	s PLIST(20)="N"
	s PLIST(21)="1" //状态
	//modified by ZY0271 20210914
	s PLIST(22)=$p($g(^DHCEQDepreSet(depreSetID)),"^",8)
	//s PLIST(23)=User
	s PLIST(24)=curDate
	s PLIST(25)=curTime
	//s PLIST(26)=User
	s PLIST(27)=curDate
	s PLIST(28)=curTime
	//s PLIST(29)=User
	s PLIST(30)=curDate
	s PLIST(31)=curTime
	s PLIST(32)=DepreType
	s PLIST(33)=AffixID
	
	s PLIST(34)=$p(^DHCEQEquip(EquipID),"^",67)	///StoreLocDR
	s PLIST(35)=$p(^DHCEQEquip(EquipID),"^",82)	///CommonFlag共用标志
	//s PLIST(36)= 	///AllotType分摊方式
	s PLIST(37)=DepreTypeDR		///DepreTypeDR折旧类型(主折旧、修购基金、核算折旧等)
	s PLIST(38)=rate			///DepreRate折旧率
	s PLIST(39)=$p(^DHCEQEquip(EquipID),"^",17)	///ManageLocDR管理部门
	//add by ZY0271 20210914
	s PLIST(40)=""	//Hold1
	s PLIST(42)=""	//Hold2
	s PLIST(43)=""	//Hold3
	s PLIST(44)=$p($g(^DHCEQDepreSet(depreSetID)),"^",26)	//Hold4
	s PLIST(45)=""	//Hold5
	
	//开始事务
	i UseTrans="Y"	{TSTART}
	///modified by ZY0250 20200106 
	//生成月度折旧
	i PreDepreFlag="Y" 
	{
		&SQL(Insert Into SQLUSER.DHC_EQPreMonthDepre Values :PLIST())
	}
	else
	{
		&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
	}
	
	i SQLCODE
	{
		i UseTrans="Y"	{TROLLBACK}
		q -1004
	}
	s MonthDepreDR=$G(%ROWID)
	//Modified By ZY0250 预折旧不写折旧设置表
	i PreDepreFlag'="Y" 
	{
		//更新折旧设置表中的上次折旧月份
		&SQL(update sqluser.DHC_EQDepreSet set DS_PreDepreMonth=:Month,DS_DepreTotal=:depreTotal,DS_DepreTotalFee=:depreTotalFee where DS_RowID=:depreSetID)
		i SQLCODE 
		{
			i UseTrans="Y"	{TROLLBACK}
			q "-1005"
		}
		//更新设备折旧信息表  czf 2020-06-02 begin
		&SQL(update sqluser.DHC_EQDepreInfo set DI_PreDepreFee=:depreFee where DI_EquipDR=:EquipID)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE 
		{
			i UseTrans="Y"	{TROLLBACK}
			q "-1005"
		}
		;^DHCEQEquipShadow("RecordEQCurDepre")记录设备当前折旧月_"^"_折旧期数_"^"_当前月折旧额，用于台账检索取值
		s ^DHCEQEquipShadow("RecordEQCurDepre",EquipID)=Month_"^"_depreTotal_"^"_depreFee
		//modified by czf 2020-06-02 end
	}
	s FTRowID=0
	s CADError=0
	k CAD
	;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
	;资金折旧信息,没有资金折旧信息的,则将折旧信息均记录在自有资金上
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	//Modified By ZY0250 资金来源核算项目及功能分类
	s UseFinaceItemType=+##class(web.DHCEQCommon).GetSysInfo("990076")
	s SelfFinaceItemFlag=##class(web.DHCEQCommon).GetSysInfo("990070")
	s SelfFunctionCatFlag=##class(web.DHCEQCommon).GetSysInfo("990071")
	s NewFundsDepreInfo=FundsDepreInfo
	i NewFundsDepreInfo=""  d
	.s NewFundsDepreInfo="^"_SelfFundsType_"^"_depreFee_"^^"_originalFee_"^"_SelfFinaceItemFlag_"^"_SelfFunctionCatFlag
	s Len=$l(NewFundsDepreInfo,"#")
	;获取共用分摊设置ID
	s CostRowID=""	
	//i $p(^DHCEQEquip(EquipID),"^",82)="Y"  d
	s CostRowID=$o(^DHCEQCostAllot(0,"EquipType",EquipID,1,0))
	;折旧分摊
	s CAD(2)=1
	s CAD(3)=MonthDepreDR
	
	for i=1:1:Len  q:(CADError'=0)  d
	.;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee_"^"_FundsFee
	.s FundsInfo=$p(NewFundsDepreInfo,"#",i)
	.s FTRowID=$p(FundsInfo,"^",2)
	.s FundsDepreFee=$p(FundsInfo,"^",3)
	.s FundsDepreTotalFee=$p(FundsInfo,"^",4)		//Add By DJ 2015-11-18
	.s FundsFee=$p(FundsInfo,"^",5)
	.//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.s FinaceItemID=$p(FundsInfo,"^",6)
	.s FunctionCatID=$p(FundsInfo,"^",7)
	.s RemainFundsDepreFee=FundsDepreFee
	.
	.s CAD(7)=FundsFee
	.s CAD(8)=FTRowID
	.s CAD(9)=FundsDepreTotalFee		//Add By DJ 2015-11-18
	.//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.s CAD(10)=FinaceItemID			//add by zy20190917
	.s CAD(11)=FunctionCatID		//add by zy20190917
	.s CostListCount=0
	.;为共用设备，且存在折旧分摊设置
	.i CostRowID'=""  d
	..s CostListID=0
	..f  s CostListID=$o(^DHCEQCostAllotList(0,"CostAllotDR",CostRowID,CostListID)) q:(CostListID="")||(CADError'=0)  d
	...s CostListCount=CostListCount+1
	...s CostType=$p($g(^DHCEQCostAllot(CostRowID)),"^",2)		//Add By DJ 2016-08-11 begin czf 2023-02-22
	...s CostValueCount=$p($g(^DHCEQCostAllot(CostRowID)),"^",16)	//分摊总和
	...s CostLoc=$p($g(^DHCEQCostAllotList(CostListID)),"^",2)
	...i CostType=0  d
	....s CostRate=$p($g(^DHCEQCostAllotList(CostListID)),"^",3)
	...e  d
	....s CostValue=$p($g(^DHCEQCostAllotList(CostListID)),"^",5)
	....s CostRate=$fn((CostValue/CostValueCount)*100,"",2)		//Add By DJ 2016-08-11 end
	...s CAD(4)=CostLoc
	...s CAD(5)=CostRate
	...;非最后一条的,直接按比例计算，否则取剩余资金折旧
	...i $o(^DHCEQCostAllotList(0,"CostAllotDR",CostRowID,CostListID))'=""  d
	....s CAD(6)=##Class(web.DHCEQCommon).FormatNumber((FundsDepreFee*(CostRate/100)),"",2)
	....s RemainFundsDepreFee=RemainFundsDepreFee-CAD(6)
	...e  d
	....s CAD(6)=RemainFundsDepreFee
	...q:CAD(6)'>0
	...i PreDepreFlag="Y"  d
	....&SQL(Insert Into SQLUSER.DHC_EQPreCostAllotDetail Values :CAD())
	...e  d
	....&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	...i SQLCODE s CADError=1
	.;1.非共用设备 2无分摊设置 3.有分摊折旧设置却无分摊明细的
	.;以上3种直接计入各资金来源对应的折旧中
	.i CostListCount=0  d
	..s CAD(4)=$p(^DHCEQEquip(EquipID),"^",67)
	..s CAD(6)=##Class(web.DHCEQCommon).FormatNumber((FundsDepreFee),"",2)
	..i PreDepreFlag="Y"  d
	...&SQL(Insert Into SQLUSER.DHC_EQPreCostAllotDetail Values :CAD())
	..e  d
	...&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	..i SQLCODE s CADError=1
		
	;"插入折旧分摊明细失败"
	i CADError'=0
	{
		i UseTrans="Y"	{TROLLBACK}
		q -1008
	}
	
	//Modified By ZY0250 预折旧不写台账和生命周期
	i (mainFlag="Y")&&(PreDepreFlag'="Y")
	{
		/****************************************************************/  //2009-08-10 党军 begin DJ0023
		s LI(2)=EquipID  //设备
		s LI(4)=$p($g(^DHCEQEquip(EquipID)),"^",19)   //原使用科室
		s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) //原管理科室
		s LI(6)=$p($g(^DHCEQEquip(EquipID)),"^",67)  //原库房
		s LI(7)=originalFee  //原值
		s LI(8)=netFee  //原净值
		s LI(16)=curDate	//变动日期
		s LI(17)=curTime	//变动时间
		s LI(18)=depreFee //折旧费用 //2009-08-13 党军
		s LI(19)="P"	//生命周期类型
		s LI(20)=35	//来源类型
		s LI(21)=MonthDepreDR	//来源ID
		//s LI(27)=User	//更新人
		s LI(28)=curDate	//更新日期
		s LI(29)=curTime	//更新时间
		
		//更新设备的净值、累计折旧
		s hasdepreflag="N"
		s netFee=netFee-depreFee
		i netFee<netRemainFee s netFee=netRemainFee
		i netFee'>netRemainFee s hasdepreflag="Y"
		
		&SQL(update sqluser.DHC_EQEquip set EQ_NetFee=:netFee,EQ_DepreTotalFee=:depreTotalFee,EQ_HasDepreFlag=:hasdepreflag where EQ_RowID=:EquipID)
		i SQLCODE 
		{
			i UseTrans="Y"	{TROLLBACK}
			q "-1006"
		}
		/***************************************************************/
		s LI(9)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //变动后使用科室
		s LI(10)=$p($g(^DHCEQEquip(LI(2))),"^",17) //变动后管理科室
		s LI(11)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //变动后库房
		s LI(12)=originalFee  //变动后原值
		s LI(13)=netFee  //变动后净值
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		i SQLCODE
		{
			i UseTrans="Y" {TRollBack}
			q "-1007"
		}
	}
	//Modified By ZY0250 预折旧新写资金信息表
	;modified by zy 2013-07-30 zy0108
	;有其他折旧类型的秀还DHCEQFundsDepreInfo中的累计折旧;
	;更新资金来源对应的累计折旧
	i FundsDepreInfo'=""
	{
		s errFunds=0
		s Len=$l(FundsDepreInfo,"#")
		for i=1:1:Len
		{
			;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
			s FundsInfo=$p(FundsDepreInfo,"#",i)
			s FundsID=$p(FundsInfo,"^",1)
			s FundsDepreFee=$p(FundsInfo,"^",3)
			s FundsDepreTotalFee=$p(FundsInfo,"^",4)
			
			//modify by lmm 2018-01-31 LMM0033
			i DepreTypeDR'="1" d
			.s FundsDepreInfoID=$o(^DHCEQFundsDepreInfo(0,"DepreTypeFunds",DepreTypeDR,FundsID,""))
			.i FundsDepreInfoID'=""  d
			..&SQL(update sqluser.DHC_EQFundsDepreInfo set FD_DepreTotalFee=:FundsDepreTotalFee where FD_RowID=:FundsDepreInfoID)
			.e  d
			..&SQL(insert into sqluser.DHC_EQFundsDepreInfo set FD_FundsDR=:FundsID,FD_DepreTypeDR=:DepreTypeDR,FD_DepreTotalFee=:FundsDepreTotalFee)
			e  d
			.i PreDepreFlag="Y"  d
			..k FPLIST
			..s FundsData=$g(^DHCEQFunds(FundsID))
			..s FPLIST(2)=$p(FundsData,"^",1)
			..s FPLIST(3)=$p(FundsData,"^",2)
			..s FPLIST(4)=$p(FundsData,"^",3)
			..s FPLIST(7)=$p(FundsData,"^",6)
			..;s PLIST(8) =User
			..s FPLIST(9) =+$H
			..s FPLIST(10) = $P($H,",",2)
			..s FPLIST(11) =$p(FundsData,"^",10)
			..s FPLIST(14) = FundsDepreTotalFee
			..s FPLIST(15) =$p(FundsData,"^",14)
			..s FPLIST(16) =$p(FundsData,"^",15)
			..s FPLIST(21) =$p(FundsData,"^",20)
			..s FPLIST(22) =$p(FundsData,"^",21)
			..&SQL(Insert Into SQLUSER.DHC_EQPreFunds Values :FPLIST())
			.e  d
			..&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:FundsDepreTotalFee where F_RowID=:FundsID)
			i SQLCODE s errFunds=errFunds+1
		}
		;"修改资金来源信息对应的累积折旧数据失败"
		i errFunds'=0
		{
			i UseTrans="Y"	{TROLLBACK}
			q -1010
		}
	}
	//Modified By ZY0250 预折旧不写
	if PreDepreFlag'="Y"
	{
		;Mozy0089	2012-10-17
		Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(10, MonthDepreDR)
		If SQLCODE
		{
			If UseTrans="Y" {TRollBack}
			Quit "-1007"
		}
	}
	i UseTrans="Y" {TCOMMIT}
	q 0
}

/// add by jdl 2010-5-18
/// 获取附件的未提折旧金额
ClassMethod GetAffixDepreAmount(AffixID, Years, DepreTotal)
{
	n (AffixID,Years,DepreTotal)	
	s qty=$p(^DHCEQAffix(AffixID),"^",7)
	s amount=$p(^DHCEQAffix(AffixID),"^",11)
	if (amount=""||amount'>0) q 0
	if (years=""||years'>0) q 0
	i +qty<1 s qty=1
	s amount=amount*qty
	s depreFee=amount-$Number((amount*DepreTotal/12/Years),0)
	if depreFee'>0 q 0
	q depreFee
}

/// 提取设备的月度折旧
/// 返回值：返回计提出错和折旧未正确设置的设备条数。
/// w ##class(web.DHCEQMonthDepre).GetMonthDepre("2010-08")
/// 
/// 该月应提折旧的设备明细
/// select eq_originalfee,eq_netfee,eq_netremainfee,eq_instocklistdr->isl_instockdr->is_billauditdate,eq_invalidflag,eq_stockstatus,eq_status,eq_depremethoddr,eq_limityearsnum, * from dhc_eqequip 
/// where eq_invalidflag='No' and eq_status<>'报废' and eq_stockstatus<>'出库' and eq_stockstatus<>'新增' and eq_netfee>0 and eq_instocklistdr->isl_instockdr->is_billauditdate<'9/1/2010'
/// 该月应提折旧在折旧表中未提的记录
/// select eq_originalfee,eq_netfee,eq_netremainfee,eq_instocklistdr->isl_instockdr->is_billauditdate,eq_invalidflag,eq_stockstatus,eq_status,eq_depremethoddr,eq_limityearsnum, * from dhc_eqequip 
/// where eq_invalidflag='No' and eq_status<>'报废' and eq_stockstatus<>'出库' and eq_stockstatus<>'新增' and eq_netfee>0 and eq_instocklistdr->isl_instockdr->is_billauditdate<'9/1/2010' and eq_rowid not in (select md_equipdr from dhc_eqmonthdepre where md_depremonth='2010-12')
/// w ##class(web.DHCEQMonthDepre).GenerateMonthDepre(rowid, DepreMonth, +$H, DepreTypeDR, "N", "0", "")
/// w ##class(web.DHCEQMonthDepre).GenerateMonthDepre(160, "2010-12", +$H, 1, "N", "0", "")
ClassMethod GetMonthDepre(DepreMonth As %Library.String = "", EquipTypeIDS As %Library.String = "", DepreTypeDR As %Library.String = "1")
{
	new (DepreMonth,EquipTypeIDS,DepreTypeDR)
	
	//自动执行的时候设置执行日期为每月的25号到月底间执行
	if DepreMonth=""  d
	.s CurDate=$ZD($H,3)
	.s DepreMonth=$p(CurDate,"-",1,2)

	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	s DepreFlag=##class(web.DHCEQCommon).GetSysInfo("990021")
	i EquipTypeIDS'="" s EquipTypeIDS=","_EquipTypeIDS_","
	s Times=$o(^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,""),-1)
	s Times=Times+1
	s ^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,Times,"Begin")=$H
	
	s errCount=0
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
	.q:..CheckNeedDepre(rowid,EquipTypeIDS,DepreFlag,DepreTypeDR)=0
	.
	.;add by jdl 增加一种折旧设置,用于计算科室成本,仅在用时提取 2011-8-1 JDL0088
	.q:(DepreTypeDR=2)&&(+$p(^DHCEQEquip(rowid),"^",38)'=1)
	.
	.;计提折旧
	.s result=..GenerateMonthDepre(rowid, DepreMonth, +$H, DepreTypeDR, "N", "0", "")
	.
	.s node="Success"
	.i result'=0  d
	..s node="Error"
	..s errCount=errCount+1
	.s ^DHCEQTemp("MonthDepreLog",DepreMonth,node,rowid,DepreTypeDR)=$H_"^"_result
	.
	.s ^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,Times,node,rowid)=$H_"^"_result
	s ^DHCEQLog(0,"MonthDepreLog",DepreMonth,DepreTypeDR,Times,"End")=$H
	q errCount
}

/// 初始化计提折旧
/// 入参：vDate,初始化折旧到该日期（格式为数字），即计算累计折旧 从入库日期开始至该日期。
/// 		EquipTypeIDS,	初始化的类组串，其中类组间用","分割
/// 		StoreLocDR	库房：要初始化的库房及其所管理的科室
/// 		DepreTypeDR	折旧类型，默认为主折旧，1
/// 		KeepDepreFee  是否保留原累计折旧 0或空，不保留 1保留 
/// 		MinEquipID   	开始设备ID  不传默认0
/// 		MaxEquipID   	结束设备ID  不传默认0
/// 		DepreMonthNum   补提折旧月数  不传默认0  所有的折旧都补提传999
/// 		AdjustFlag   是否写数据调整记录，记到新增数据调整中
/// 		InputFlag   是否只初始化导入的台帐，默认Y，只初时候导入的数据，改成N，就初始化所有的
/// 返回：初始化失败的条目，0为成功，大于0有失败的记录。
/// 多资金来源的设备中，提供的资金来源串中存在累计折旧为0的情况，需要另外处理 如：自有资金=2348000:2156853.72,财政专项=2000:0
/// w ##Class(web.DHCEQMonthDepre).InitEquipDepre(66077,"","","1","0",397,397,36,"N","Y")
ClassMethod InitEquipDepre(vDate As %Library.String = "", EquipTypeIDS As %Library.String = "", StoreLocDR As %Library.String = "", DepreTypeDR As %Library.String = "1", KeepDepreFee As %Library.String = "", MinEquipID As %Library.String = "0", MaxEquipID As %Library.String = "0", DepreMonthNum As %Library.String = "0", AdjustFlag As %Library.String = "", InputFlag As %Library.String = "")
{
	new (vDate,EquipTypeIDS,StoreLocDR,DepreTypeDR,KeepDepreFee,MinEquipID,MaxEquipID,DepreMonthNum,AdjustFlag,InputFlag)
	if vDate=""  d
	.s vDate=+$H
	s curDate=+$H
	s curTime=$P($H,",",2)
	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	s DepreFlag=##class(web.DHCEQCommon).GetSysInfo("990021")
	i EquipTypeIDS'="" s EquipTypeIDS=","_EquipTypeIDS_","	
	s errCount=0
	s (ErrDesc,AdjustID)=""
	
	if AdjustFlag="Y"
	{
		s PLIST(2)=2 //新增数据
		s PLIST(3)="Y"	//reportFlag
		s PLIST(4)=curDate
		s PLIST(5)=curTime
		s PLIST(6)="MinEquipID="_MinEquipID_",MaxEquipID="_MaxEquipID
		s PLIST(7)=""
		s PLIST(8)="追加导入资产台帐"
		s PLIST(9)=""	//RequestUser
		//s PLIST(10)=User
		s PLIST(11)=""	//remark
		s PLIST(12)="0"
		s PLIST(13)="Y"	//DisplayFlag
		s PLIST(14)=""
		s PLIST(15)=curDate
		s PLIST(16)=curTime
		//s PLIST(17)=InvalidUserDR
		//s PLIST(18)=InvalidDate
		//s PLIST(19)=InvalidTime
		//s PLIST(20)=InvalidReason
		s PLIST(21)=1
		s PLIST(22)=""
		s PLIST(23)=""
		s PLIST(24)=""
		s PLIST(25)=""
		&SQL(insert into sqluser.DHC_EQAdjustData values :PLIST())
		s AdjustID=$g(%ROWID)
	}
	s rowid=MinEquipID
	i MinEquipID>0 s rowid=MinEquipID-1
	i +MaxEquipID=0 s MaxEquipID=$g(^DHCEQEquip(0))
	f  s rowid=$o(^DHCEQEquip(rowid))  q:(rowid>MaxEquipID)||(rowid="")  d
	.s EquipData=$g(^DHCEQEquip(rowid))
	.q:(InputFlag="Y")&&($P(EquipData,"^",47)'="Y")
	.q:(StoreLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ("1",$P(EquipData,"^",67),StoreLocDR,0)))
	.q:(EquipTypeIDS'="")&&(EquipTypeIDS'[(","_$P(EquipData,"^",63)_","))
	.d DoInitOneEquipDepre
	
	q errCount
DoInitOneEquipDepre
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	q:..CheckNeedDepre(rowid,EquipTypeIDS,DepreFlag,DepreTypeDR)=0
	
	;0^DepreSetID^DepreFee^DepreMonths^DepreMethodType^DepreMethodDR^Years^Rate^DepreTotal^DepreTotalFee
	s DepreSetInfo=##Class(web.DHCEQMonthDepre).GetDepreSetInfo(rowid,vDate,DepreTypeDR,"1")
	s FundsDepreInfo=$p(DepreSetInfo,"&",2)
	s DepreSetInfo=$p(DepreSetInfo,"&",1)
	
	i DepreSetInfo<0  d
	.s errCount=errCount+1
	.s ErrDesc=ErrDesc_"&"_rowid
	q:DepreSetInfo<0
	
	s DepreSetID=$p(DepreSetInfo,"^",2)
	s DepreFee=$p(DepreSetInfo,"^",3)
	s DepreMonths=$p(DepreSetInfo,"^",4)
	q:DepreMonths=0
	s DepreMethodType=$p(DepreSetInfo,"^",5)
	;s DepreMethodDR=$p(DepreSetInfo,"^",6)
	;s Years=$p(DepreSetInfo,"^",7)
	s Rate=$p(DepreSetInfo,"^",8)
	;s DepreTotal=$p(DepreSetInfo,"^",9)
	;s DepreTotalFee=$p(DepreSetInfo,"^",10)
	s MainFlag=$p(DepreSetInfo,"^",11) //add by lmm 2018-01-10
	
	s DepreTotalFee=DepreFee
	s DepreTotal=DepreMonths
	
	s OriginalFee = $p(EquipData,"^",27)
	s NetRemainFee = $p(EquipData,"^",29)
	s EquipNetFee=OriginalFee-DepreTotalFee
	s HasdDepreFlag="N"
	i EquipNetFee'>NetRemainFee s HasdDepreFlag="Y"
	
	;日期格式需转换为 MM/DD/YYYY,如"7/15/2010"
	s DepreDate=##Class(web.DHCEQMonthDepre).GetAccountMonth($ZD(vDate,1))
	s DepreDate=$zd($zdh(DepreDate,1),3)		//modified by czf 2020-06-03
	s DepreMonth=$p(DepreDate,"-",1,2)
	
	i KeepDepreFee'="1"
	{
		i MainFlag="Y"
		{
			;w rowid_","_OriginalFee_","_$ZD(StartDate,1)_","_OriginalFee_","_DepreFee,!
			&SQL(update sqluser.DHC_EQEquip set EQ_NetFee=:EquipNetFee,EQ_DepreTotalFee=:DepreFee,EQ_HasDepreFlag=:HasdDepreFlag where EQ_RowID=:rowid)
			i SQLCODE 
			{
				s errCount=errCount+1
				q
			}
		}
	}
	else
	{
		s DepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
		;MZY0058	1549257		2020-10-18	导入已折旧月数
		s DepreTotal=+$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)	
		if (DepreTotalFee>0)&&(DepreTotal=0)
		{
			s DepreMethodType=$p(DepreSetInfo,"^",5)
			i DepreMethodType=1
			{
				s Years=$p(DepreSetInfo,"^",7)
				s DepreTotal=(DepreTotalFee/(OriginalFee/(Years*12)))
				s DepreTotal=$fn(DepreTotal,"",0)
			}
			elseif DepreMethodType=4
			{
				s DepreTotal=1
			}
		}
	}
	&SQL(update sqluser.DHC_EQDepreSet set DS_PreDepreMonth=:DepreMonth,DS_DepreTotal=:DepreTotal,DS_DepreTotalFee=:DepreTotalFee where DS_RowID=:DepreSetID)
	i SQLCODE s errCount=errCount+1
	;初始化资金来源表里的各项资金的累计折旧金额
	i FundsDepreInfo'=""
	{
		d SaveFundsInfo
	}
	///追加导入写数据调整记录
	if (AdjustFlag="Y")&&(AdjustID'="")
	{
		d SaveAdjustList
	}
	///补提历史折旧记录
	if (DepreMethodType=1)&&(DepreMonthNum>0)
	{
		d SaveMonthDepreList
	}
	q
SaveFundsInfo
	s Len=$l(FundsDepreInfo,"#")
	for i=1:1:Len
	{
		;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
		s FundsInfo=$p(FundsDepreInfo,"#",i)
		s FundsID=$p(FundsInfo,"^",1)
		s FundsDepreFee=$p(FundsInfo,"^",3)
		s FundsDepreTotalFee=$p(FundsInfo,"^",4)
		s FundsFee=$p(FundsInfo,"^",5)
		//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
		s FinaceItemID=$p(FundsInfo,"^",6)
		s FunctionCatID=$p(FundsInfo,"^",7)
		i KeepDepreFee="1"
		{
			i (i=Len)
			{
				s FundsDepreTotalFee=DepreTotalFee
			}
			else
			{
				//多资金来源的设备中，提供的资金来源串中存在累计折旧为0的情况，需要另外处理 如：自有资金=2348000:2156853.72,财政专项=2000:0
				i $p($g(^DHCEQFunds(FundsID)),"^",13)=0 s FundsDepreTotalFee=DepreTotalFee*(FundsFee/OriginalFee) //modify by mwz 20210710 MWZ0052
				e  s FundsDepreTotalFee=$p($g(^DHCEQFunds(FundsID)),"^",13)  //资金来源表累计折旧
				s FundsDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(FundsDepreTotalFee,"",2)
				s DepreTotalFee=DepreTotalFee-FundsDepreTotalFee
			}
		}
		;add by zy 2013-07-30 zy0108
		i MainFlag="Y"		//主折旧对应资金的折旧信息记录在DHC_EQFunds
		{
			//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
			&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:FundsDepreTotalFee,F_Hold4=:FinaceItemID,F_Hold5=:FunctionCatID where F_RowID=:FundsID)
		}
		else		//非主折旧对应资金的折旧信息记录在DHC_EQFundsDepreInfo
		{
			s FDRowID=$o(^DHCEQFundsDepreInfo(0,"DepreTypeFunds",DepreTypeDR,FundsID,0))
			i FDRowID=""
			{
				&SQL(insert into sqluser.DHC_EQFundsDepreInfo set FD_FundsDR=:FundsID,FD_DepreTypeDR=:DepreTypeDR,FD_DepreTotalFee=:FundsDepreTotalFee)
			}
			else
			{
				&SQL(update sqluser.DHC_EQFundsDepreInfo set FD_DepreTotalFee=:FundsDepreTotalFee where FD_RowID=:FDRowID)
			}
		}
		i SQLCODE s errCount=errCount+1
	}
	q
	
SaveAdjustList
	k AdPLIST
	s AdPLIST(2)=AdjustID   //ADL_AdjustDataDR
	
	s AdjustType=$p($g(^DHCEQAdjustData(AdjustID)),"^",1)
	
	s AdPLIST(3)=rowid   //ADL_EquipDR
	s AdPLIST(4)=""   //ADL_FromLocDR
	s AdPLIST(5)=""   //ADL_FromEquipTypeDR
	s AdPLIST(6)=""   //ADL_FromStatCatDR
	s AdPLIST(7)=""   //ADL_FromOriginDR
	s AdPLIST(8)=""   //ADL_FromInfo
	s AdPLIST(9)=$p(EquipData,"^",67)   //ADL_ToLocDR
	s AdPLIST(10)=$p(EquipData,"^",63)   //ADL_ToEquipTypeDR
	s AdPLIST(11)=$p(EquipData,"^",75)   //ADL_ToStatCatDR
	s AdPLIST(12)=$p(EquipData,"^",20)   //ADL_ToOriginDR
	s AdPLIST(13)=""   //ADL_ToInfo
	s AdPLIST(14)=$p(EquipData,"^",38)   //ADL_EQStatus
	s AdPLIST(15)=$p(EquipData,"^",27)   //ADL_OriginalFee
	s AdPLIST(16)=$p(EquipData,"^",35)   //ADL_DepreTotal
	s AdPLIST(17)=$p(EquipData,"^",28)   //ADL_NetFee
	&SQL(insert into sqluser.DHC_EQAdjustDataList values :AdPLIST())
	q
		
SaveMonthDepreList
	s EquipDR=$p($g(^DHCEQDepreSet(DepreSetID)),"^",1)
	s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
	s DepreMethodDR=$p($g(^DHCEQDepreSet(DepreSetID)),"^",2)
	s mainFlag=$p($g(^DHCEQDepreSet(DepreSetID)),"^",3)
	s DepreTotal=$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)
	s DepreTotalFee=$p($g(^DHCEQDepreSet(DepreSetID)),"^",23)
	s Years=$p($g(^DHCEQDepreSet(DepreSetID)),"^",24)
	k PLIST
	s PLIST(2)=EquipDR
	s PLIST(3)=DepreSetID
	s PLIST(4)=mainFlag
	s PLIST(5)=DepreMethodDR
	s PLIST(6)=OriginalFee
	
	s PLIST(10)=Years
	//s PLIST(12)=
	//s PLIST(14)=totalworkload
	s PLIST(19)=$p(EquipData,"^",29) //设备净残值
	s PLIST(20)="N"
	s PLIST(21)="1" //状态
	s PLIST(22)=$p($g(^DHCEQDepreSet(DepreSetID)),"^",8)
	//s PLIST(23)=User
	s PLIST(24)=curDate
	s PLIST(25)=curTime
	//s PLIST(26)=User
	s PLIST(27)=curDate
	s PLIST(28)=curTime
	//s PLIST(29)=User
	s PLIST(30)=curDate
	s PLIST(31)=curTime
	s PLIST(32)=0	//0:正常按月计提1:设备报废一次性计提2:设备附件报废一次性计提附件未计提值
	s PLIST(33)=""	//附件ID，用于附件报废时，一次性计提附件未提折旧
	
	s PLIST(34)=$p(EquipData,"^",67)	///StoreLocDR
	s PLIST(35)=$p(EquipData,"^",82)	///CommonFlag共用标志
	//s PLIST(36)= 	///AllotType分摊方式
	s PLIST(37)=DepreTypeDR		///DepreTypeDR折旧类型(主折旧、修购基金、核算折旧等)
	s PLIST(38)=Rate			///DepreRate折旧率
	s PLIST(39)=$p(EquipData,"^",17)	///ManageLocDR管理部门
	//add by ZY0271 20210914
	s PLIST(40)=""	//Hold1
	s PLIST(42)=""	//Hold2
	s PLIST(43)=""	//Hold3
	s PLIST(44)=$p($g(^DHCEQDepreSet(DepreSetID)),"^",26)	//Hold4
	s PLIST(45)=""	//Hold5
	
	//累积折旧直接算到已折旧月数
	if (DepreTotal<=DepreMonthNum) s CurDepreMonthNum=DepreTotal
	//累积折旧只能取需要补提的占比DepreMonthNum
	s NewDepreTotalFee=$fn((DepreTotalFee*(CurDepreMonthNum/DepreTotal)),"",2)
	s initDepreTotalFee=DepreTotalFee-NewDepreTotalFee
	s initDepreTotal=DepreTotal-CurDepreMonthNum
			
	s DepreDateFlag=##class(web.DHCEQCommon).GetSysInfo("990061")
	i DepreDateFlag=1
	{
		s StartDate=$P(EquipData,"^",44)	///启用日期  modified by czf 20170828
	}
	elseif (DepreDateFlag="0")||(DepreDateFlag="")	
	{
		s StartDate=$P(EquipData,"^",45)	///转资日期  modified by czf 2010828
	}
	s DepreDate=##Class(web.DHCEQMonthDepre).GetAccountMonth($ZD(StartDate,1))
	s DepreDate=$zd($zdh(DepreDate,1),3)
	s initYear=$p(DepreDate,"-",1)
	s initMonth=+$p(DepreDate,"-",2)
	s initYear=initYear+((initMonth+initDepreTotal)\12)
	s initMonth=(initMonth+initDepreTotal)#12
	i initMonth=0 d
	.s initYear=initYear-1
	.s initMonth=12
	
	for j=1:1:CurDepreMonthNum
	{
		s vYear=initYear+((initMonth+j-1)\12)
		s vMonth=(initMonth+j-1)#12
		i vMonth=0 d
		.s vYear=vYear-1
		.s vMonth=12
		i vMonth<10 s vMonth="0"_vMonth
		s MonthStr=vYear_"-"_vMonth
		
		s PLIST(7)=MonthStr
		s PLIST(11)=initDepreTotal+j //总折旧月份
		if (CurDepreMonthNum=j) d
		.s depreFee=OriginalFee-initDepreTotalFee
		e  d
		.s depreFee=$fn(((OriginalFee-initDepreTotalFee)/(Years*12-initDepreTotal-j+1)),"",2)
		.i (initDepreTotalFee=DepreTotalFee) s depreFee=0	//如果累计折旧与台帐一致后，月折旧设置成0
		s initDepreTotalFee=initDepreTotalFee+depreFee	//每月累加只到初始化月份
		//最后一个月(初始化月份)累积折旧与初始化的累积折旧不一致,需要处理四舍五入问题
		s DiffFee=initDepreTotalFee-DepreTotalFee
		if (CurDepreMonthNum=j)&&(DiffFee'=0)
		{
			s initDepreTotalFee=DepreTotalFee
			s depreFee=depreFee-DiffFee
		}
		s PLIST(13)=initDepreTotalFee
		s PLIST(15)=depreFee
		s PLIST(18)=OriginalFee-initDepreTotalFee
		
		&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
	}
	q
}

ClassMethod GetInStockDate(instocklistdr, isnum)
{
	n InDate,ISID
	s InDate=""
	i instocklistdr'="" d
	.s ISID=$p(^DHCEQInStockList(instocklistdr),"^",1)
	.s InDate = $p($g(^DHCEQInStock(ISID)),"^",13)
	.i isnum'=1 s InDate=$ZD(InDate,3)
	q InDate
}

ClassMethod GetTotalWorkLoad(EquipID, DepreMonth)
{
	s Total=0
	i (DepreMonth="") q 0
	s DepreDate=$ZDH(DepreMonth_"-01",3)
	;&sql(select sum(UR_WorkLoadNum) into:Total from SQLUSER.DHC_EQUseRecord 
	;where UR_SourceType=1 and UR_SourceID=:EquipID and UR_UseDate>=:DepreDate and UR_UseDate<DateAdd('mm',1,:DepreDate))
	i Total="" s Total=0
	q Total
}

/// modified by zy zy 2013-06-04 zy0107
/// 增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
/// 检测设备是否在本次折旧范围
/// 入参：EquipID	设备ID
/// 		 EquipTypeIDS：设备类组
/// 		 DepreFlag：预报废设备折旧标识:0:计提;1:不计提
/// 返回：1要折旧
/// 		 0不折旧
/// w ##Class(web.DHCEQMonthDepre).CheckNeedDepre(2,"","0")
ClassMethod CheckNeedDepre(EquipID, EquipTypeIDS, DepreFlag As %Library.String = "", DepreTypeDR As %Library.String = "1")
{
	n EquipType,EQStatus,DisuseDate
	//Add By DJ 2016-01-28 begin
	s DepreBussIDs=","_##class(web.DHCEQCommon).GetSysInfo("990041")_","
	s EQStatus=+$p(^DHCEQEquip(EquipID),"^",38)
	s EQStockStatus=+$p(^DHCEQEquip(EquipID),"^",60)
	i ((EQStatus=0)&&(EQStockStatus=0)) q 0   //验收设备不计提折旧
	s DepreSetID=$o(^DHCEQDepreSet(0,"Source",DepreTypeDR,0,EquipID,0))
	i DepreSetID="" q 0		//折旧设置不存在不折旧 czf 2023-02-22 begin
	s StartDepreDate=$p($g(^DHCEQDepreSet(DepreSetID)),"^",25)
	s DepreStatus=$p($g(^DHCEQDepreSet(DepreSetID)),"^",26)
	i DepreStatus="false" q 0	//不启用折旧
	
	//modified by czf 20170828
	//增加参数判断折旧日期以转资日期还是启用日期为准
	s DepreDateFlag=##class(web.DHCEQCommon).GetSysInfo("990061")
	i DepreDateFlag=2	//折旧开始日期
	{
		i StartDepreDate="" q 0
	}
	elseif DepreDateFlag=1	//启用日期 czf 2023-02-22 end
	{
		i ((EQStatus=0)&&(EQStockStatus=1)) q 0   //在库设备不计提折旧    //modified by czf 20170828
	}
	else	//转资日期
	{
		i ($p(^DHCEQEquip(EquipID),"^",45)="") q 0   //未入账设备不计提折旧    //Mozy	2017-10-12 464480
	}
	
	s EQInvalidFlag=$p(^DHCEQEquip(EquipID),"^",59)
	//退货,减少--1当月退货不提，4当月减少不提
	//Modify DJ  2017-12-08
	i EQStockStatus=3
	{
		i ((DepreBussIDs[",1,")&&(DepreBussIDs[",4,")) q 0
		i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,23)) q 0
		s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,23,""),-1)
		i 0=##Class(web.DHCEQReport).IsCurReportMonth(LIDate) q 0
		i ((DepreBussIDs[",1,")||(DepreBussIDs[",4,"))		//1当月退货不提，4当月减少不提
		{
			s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,23,LIDate,0))
			s LISourceID=$p($g(^DHCEQLifeInfo(LIRowID)),"^",20)
			s RRowID=$p($g(^DHCEQReturnList(LISourceID)),"^",1)
			s ReturnTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",17)
			s ReturnTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",ReturnTypeDR)),"^",1)
			i (DepreBussIDs[",1,")&&(ReturnTypeCode="TH") q 0
			i (DepreBussIDs[",4,")&&(ReturnTypeCode'="TH") q 0
		}
	}
	//报废---3非当月报废不提
	i EQStatus=3
	{
		i (DepreBussIDs[",3,") q 0
		s DisuseDate=$p(^DHCEQEquip(EquipID),"^",89)
		//i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,34)) q 0
		//s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,34,""),-1)
		i 0=##Class(web.DHCEQReport).IsCurReportMonth(DisuseDate) q 0
	}
	//数据调整--2当月删除数据类型的数据调整不提
	i EQInvalidFlag="Y"
	{
		i (DepreBussIDs[",2,") q 0
		s ADFlag=0
		i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,61)) q 0
		s LIDate=0
		f  s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,61,LIDate))  q:(LIDate="")||(ADFlag'=0)  d
		.q:##Class(web.DHCEQReport).IsCurReportMonth(LIDate)=0
		.s LIRowID=0
		.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipID,61,LIDate,LIRowID))  q:(LIRowID="")||(ADFlag'=0)  d
		..s LISourceID=$p($g(^DHCEQLifeInfo(LIRowID)),"^",20)
		..s ADRowID=$p($g(^DHCEQAdjustDataList(LISourceID)),"^",1)
		..s ADType=$p($g(^DHCEQAdjustData(ADRowID)),"^",1)
		..q:ADType'=3   //删除数据
		..s ADReportFlag=$p($g(^DHCEQAdjustData(ADRowID)),"^",2)    //modified by czf 2017-05-25 是否影响报表
		..q:ADReportFlag'="Y"
		..s ADFlag=1
		
		q ADFlag
	}
	;过滤掉类组
	s EquipType=$p(^DHCEQEquip(EquipID),"^",63) 
	i (EquipTypeIDS'="")&&(EquipTypeIDS'[(","_EquipType_",")) q 0
	;过滤掉不计提的??
	;s GuaranteeFlag=$p(^DHCEQEquip(rowid),"^",46)
	;q:GuaranteeFlag="N"
	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	//midified by zy 2015-7-1 ZY0134 
	//modify by zx 2019-12-10 ZX0071 逻辑运算符号修改
	i (DepreFlag=1)&&($p(^DHCEQEquip(EquipID),"^",93)="2")
	{
		;根据系统参数，预报废是否计提折旧，如不计提，则不提
		;待确定 预报废当月是否计提
		q 0
	}
	/*
	;报废状态的过滤
	i (+$p(^DHCEQEquip(EquipID),"^",38))>2 q 0
	
	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	i (DepreFlag=1)&($p(^DHCEQEquip(EquipID),"^",93)="Y") q 0
	*/
	s DSStatus=""
	s DSRowID=##Class(web.DHCEQMonthDepre).GetDepreSetID(0,EquipID,DepreTypeDR)
	i DSRowID'="" s DSStatus=$p($g(^DHCEQDepreSet(DSRowID)),"^",9)
	i (DepreTypeDR=2)&&(DSStatus'=2) q 0
	q 1
}

/// modified by ZY02169 20210615
/// 增加参数，用于修改入库日期测算折旧数据
/// Add by JDL 2011-2-22
/// 根据设备ID及折旧类型获取折旧信息
/// 入参：	EquipID:设备ID
/// 			vDate：要折旧的日期
/// 			DepreTypeDR：折旧类型，1为系统主折旧，其他为其他的折旧
/// 			TotalFlag：0:取vDate当月折旧，1:取vDate以前所有折旧(主要用于初始化折旧数据用)
/// 返回值：正确返回：0^DepreSetID^DepreFee^DepreMonths^DepreMethodType^DepreMethodDR^Years^Rate^DepreTotal^DepreTotalFee
/// 		失败返回如下：
/// 		-1001(没有对应的折旧设置)；
/// 		-1002(设置的折旧方法无效)；
/// 		-1003(设置的折旧年限或折旧率无效)
/// w ##class(web.DHCEQMonthDepre).GetDepreSetInfo(26230,+$h,1,"0","0")		
ClassMethod GetDepreSetInfo(EquipID, vDate As %Library.String = "", DepreTypeDR As %Library.String = "1", TotalFlag As %Library.String = "0", ModifyFlag As %Library.String = "0")
{
	n (EquipID,vDate,DepreTypeDR,TotalFlag,ModifyFlag)
	;n DepreSetID,DepreMethodDR,DepreMethodType
	//modified by czf 20170828
	//增加参数判断折旧日期以转资日期还是启用日期为准
	s DepreDateFlag=##class(web.DHCEQCommon).GetSysInfo("990061")
	;取该设备的对应的相应的折旧设置
	s DepreSetID=$o(^DHCEQDepreSet(0,"Source",DepreTypeDR,0,EquipID,0))
	;没有相应的折旧设置
	i DepreSetID="" q -1001
	
	;获取折旧方法信息
	s DepreMethodDR=$p($g(^DHCEQDepreSet(DepreSetID)),"^",2)
	i DepreMethodDR="" q -1002
	s DepreMethodType=+$p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",1)
	s DepreTotal=$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)
	s DepreTotalFee=$p($g(^DHCEQDepreSet(DepreSetID)),"^",23)
	s Years=$p($g(^DHCEQDepreSet(DepreSetID)),"^",24)
	s MainFlag=$p($g(^DHCEQDepreSet(DepreSetID)),"^",3)  //add by lmm 2018-01-10
	s StartDepreDate=$p($g(^DHCEQDepreSet(DepreSetID)),"^",25)	//czf 2023-02-22
	s DepreStatus=$p($g(^DHCEQDepreSet(DepreSetID)),"^",26)	
	s Rate=""
	
	//报废设备折旧 czf 2023-03-02 begin
	s DisDepreFlag=##class(web.DHCEQCommon).GetSysInfo("601001")
	s EQStatus=+$p(^DHCEQEquip(EquipID),"^",38)
	i (EQStatus=3)&&(TotalFlag="0")
	{
		//非初始化,正常折舊
		s DisuseDate=$p(^DHCEQEquip(EquipID),"^",89)
		i +DisDepreFlag=0 d
		.s DepreMethodType=2		//不計提折舊
		e  d
		.i 1=##Class(web.DHCEQReport).IsCurReportMonth(DisuseDate) s DepreMethodType=4 //報廢當月一次性計提折舊
		.e  s DepreMethodType=2		//非當月不計提折舊
	}
	//报废设备折旧 czf 2023-03-02 end
	
	s FundsDepreInfo=""
	
	;初始化，恢复累计折旧为0
	i TotalFlag="1"
	{
		s DepreTotal=0
		s DepreTotalFee=0
	}
	
	;获取设备原值信息
	s OriginalFee = $p($g(^DHCEQEquip(EquipID)),"^",27)
	s NetRemainFee = $p($g(^DHCEQEquip(EquipID)),"^",29)
	i DepreDateFlag=2	//折旧开始日期 czf 2023-02-22
	{
		s StartDate=StartDepreDate
	}
	elseif DepreDateFlag=1
	{
		s StartDate=$P(^DHCEQEquip(EquipID),"^",44)	///启用日期  modified by czf 20170828
	}
	else
	{
		s StartDate=$P(^DHCEQEquip(EquipID),"^",45)	///转资日期  modified by czf 2010828
	}
	/// modified by ZY02169 20210615
	i ModifyFlag=1
	{
		s (InStockDR,NewInDate)=""
		s InStockDR=$p($g(^DHCEQInStockList($p($g(^DHCEQEquip(EquipID)),"^",70))),"^",1)
		if InStockDR'="" s NewInDate=$g(^DHCEQInStock(InStockDR,"EX","NewInDate"))
		s StartDate=##class(web.DHCEQCommon).TransValueFromPage(NewInDate,"date")
	}
	s UsedMonths=##Class(web.DHCEQMonthDepre).GetMonthDiffrent(StartDate,vDate)
	/// add by ZY0298 20220304 手工折旧 周期计算可能存在-1
	i UsedMonths<0 s UsedMonths=0
	if TotalFlag="0"
	{
		s DepreMonths=1
	}
	else
	{
		s DepreMonths=UsedMonths
	}
	
	s DepreFee=0
	s HasDepreFlag="N"
	
	;获取剩余需要计提的净值
	s DepreNetFee=OriginalFee-NetRemainFee-DepreTotalFee
	;计提完成的返回折旧费0
	i DepreNetFee'>0 q 0_"^"_DepreSetID_"^"_DepreFee_"^0"
	
	;Modified By JDL 20150811 ZX0024 计算折旧月份时，无形资产因入库当月计提，应增加一个月
	s EquipTypeDR=","_$p($g(^DHCEQEquip(EquipID)),"^",63)_","  //add by zx 2015-04-28 昆医附一无形资产折旧
	//add by lmm 2018-12-07 begin
	s SysDepreMethod=##class(web.DHCEQCommon).GetSysInfo("990066")  ;折旧计提方式	0:固定资产次月折旧 1:固定资产当月折旧
	if (SysDepreMethod=0)
	{
		s WXEquipTypeDRs=","_##class(web.DHCEQCommon).GetSysInfo("990023")_","
		if WXEquipTypeDRs[EquipTypeDR 
		{
			s UsedMonths=UsedMonths+1
			i TotalFlag'="0"
			{
				s DepreMonths=UsedMonths
			}
		}
	}
	elseif (SysDepreMethod=1)
	{
		s UsedMonths=UsedMonths+1
		i TotalFlag'="0"
		{
			s DepreMonths=UsedMonths
		}
		
	}
	//add by lmm 2018-12-07 end
	;折旧月份比入库月份大,才计算折旧金额,即入库下月才开始计提
	if UsedMonths>0
	{
		if DepreMethodType=1
		{
			;1:平均年限法(基于净值)
			;设置的使用年限无效
			i +Years'>0 q -1003
			///modified by ZY0242 2020-09-08
			//add by zy 20150610 ZY0128  //增加的折旧月份数
			;s ChangeAccountInfo=##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(EquipID,vDate)
			;s AddDepreMonths=$p(ChangeAccountInfo,"^",1)
			//s PreOriginalFee=$p(ChangeAccountInfo,"^",2)
			;s Months=12*Years-DepreTotal+AddDepreMonths
			s Months=12*Years-DepreTotal
			;s Months=12*Years-DepreTotal
			
			i Months<1 s Months=1			
			
			i DepreMonths>Months s DepreMonths=Months
			s DepreFee=DepreNetFee*DepreMonths/Months
			i DepreFee>DepreNetFee s DepreFee=DepreNetFee
		}
		elseif DepreMethodType="2" 
		{
			;2:不计提折旧
			;s DepreFee=0
			s DepreMonths=0
		}
		elseif DepreMethodType="3" 
		{
			;3:根据折旧率计提			
			;获取对应的折旧率			
			i UsedMonths>0
			{
				s DetailID=0
				f  s DetailID=$o(^DHCEQDepreSetDetail(0,"DepreSet",DepreSetID,DetailID))  quit:((DetailID="")||(Rate'=""))  d
				.s FromYear=$p($g(^DHCEQDepreSetDetail(DetailID)),"^",3)
				.q:(UsedMonths<(FromYear*12))
				.s ToYear=$p($g(^DHCEQDepreSetDetail(DetailID)),"^",4)
				.q:(UsedMonths>(ToYear*12))&&(ToYear'="")
				.s Rate=$p($g(^DHCEQDepreSetDetail(DetailID)),"^",5)
			}
			;折旧率设置无效
			i Rate="" q -1003
			
			s DepreFee=OriginalFee*Rate*DepreMonths/100
			i DepreFee>DepreNetFee
			{
				s DepreFee=DepreNetFee
				s DepreMonths=DepreFee\(OriginalFee*Rate/100)
				i (DepreFee#(OriginalFee*Rate/100))'=0 s DepreMonths=1+DepreMonths 
			}			
		}
		elseif DepreMethodType="4" 
		{
			;4:一次性计提
			s DepreMonths=1
			s DepreFee=DepreNetFee
		}
		elseif DepreMethodType="5"		//平均年限法(基于原值) add by czf 2020-02-20 CZF0053
		{
			///modified by ZY0242 2020-09-08
			//s Months=12*Years
			//i DepreMonths>Months s DepreMonths=Months
			//s DepreFee=OriginalFee*DepreMonths/Months
			//i DepreFee>DepreNetFee s DepreFee=DepreNetFee
			
			;5:苏州科技城根据用友财务软件提出的折旧率计提
			;获取对应的折旧率
			;设置的使用年限无效
			i +Years'>0 q -1003
			//add by zy 20150610 ZY0128  //增加的折旧月份数
			s ChangeAccountInfo=##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(EquipID,vDate)
			s AddDepreMonths=0	;$p(ChangeAccountInfo,"^",1)
			s PreOriginalFee=$p(ChangeAccountInfo,"^",2)
			s Months=12*Years+AddDepreMonths
			s Rate=##Class(web.DHCEQCommon).FormatNumber((1/Months),"1",4)
			
			i PreOriginalFee'="" s OriginalFee=PreOriginalFee
			
			;折旧率设置无效
			i Rate="" q -1003
			s DepreFee=OriginalFee*Rate
			s DepreFee=$Number(DepreFee,2)
			
			if DepreMonths=1
			{
				//最后一个月时直接取净值
				i (DepreTotal+DepreMonths)=Months s DepreFee=DepreNetFee
				//当净值比月折旧少时直接取净值  因为有可能提前折旧完毕
				i DepreFee>DepreNetFee s DepreFee=DepreNetFee
			}
			else
			{
				//初始化时直接计算
				s DepreFee=DepreFee*DepreMonths
				//如果过期的设备就直接取净值
				i (DepreTotal+DepreMonths)>=Months s DepreFee=DepreNetFee
			}
		}
		else
		{
			//设置的折旧方法无效
			q -1002
		}
	}
		
	i DepreFee>0
	{
		s DepreFee=$Number(DepreFee,2)
		i +DepreFee=+DepreNetFee s HasDepreFlag="Y"
		d GetFundsInfo
	}
	else
	{
		s DepreFee=0
		s DepreFee=$Number(DepreFee,2)		
	}
	
	q 0_"^"_DepreSetID_"^"_DepreFee_"^"_DepreMonths_"^"_DepreMethodType_"^"_DepreMethodDR_"^"_Years_"^"_Rate_"^"_DepreTotal_"^"_DepreTotalFee_"^"_MainFlag_"&"_FundsDepreInfo
GetFundsInfo
	s FundsID=0
	s RemainDepreFee=DepreFee
	f  s FundsID=$o(^DHCEQFunds(0,"Source",1,EquipID,FundsID)) q:(FundsID="")  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.s FundsType=$p(^DHCEQFunds(FundsID),"^",2)
	.;i FundsType="" s FundsType=SelfFundsType
	.s FundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.s FundsDepreTotalFee=+$p($g(^DHCEQFunds(FundsID)),"^",13)
	.///modified by ZY0242 2020-09-08
	.//如果默认写0 会导致报表查询不出数据
	.///报表处理这里还是需要增加控制输出
	.//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.s FinaceItemID=$p($g(^DHCEQFunds(FundsID)),"^",20)
	.s FunctionCatID=$p($g(^DHCEQFunds(FundsID)),"^",21)
	.
	.;add by zy 2013-07-30 zy0108
	.;有其他折旧类型的取DHCEQFundsDepreInfo中的记录;
	.i MainFlag'="Y" d
	..s FundsDepreInfoID=$o(^DHCEQFundsDepreInfo(0,"DepreTypeFunds",DepreTypeDR,FundsID,0))
	..i FundsDepreInfoID'="" s FundsDepreTotalFee=+$p($g(^DHCEQFundsDepreInfo(FundsDepreInfoID)),"^",3)
	..i FundsDepreInfoID="" s FundsDepreTotalFee=0  //add by lmm 2018-02-08 LMM0033	
	.
	.;初始化,恢复该资金累计折旧金额为0
	.i TotalFlag="1"  d
	..s FundsDepreTotalFee=0
	.
	.;Modified by JDL 2012-3-8 JDL0121  处理资金来源分配折旧不准确的问题
	.s FundsNetFee=FundsFee-FundsDepreTotalFee
	.i FundsNetFee<0 s FundsNetFee=0
	.
	.;最后一个资金来源时,取剩余折旧额,作为该资金来源的折旧金额
	.i $o(^DHCEQFunds(0,"Source",1,EquipID,FundsID))=""  d
	..s FundsDepreFee=RemainDepreFee
	.e  d
	..i DepreMethodType=1  d
	...;平均年限法
	...i HasDepreFlag="Y"  d
	....s FundsDepreFee=FundsNetFee		;Modified by JDL 2012-3-8 JDL0121
	...e  d
	....s FundsDepreFee=FundsNetFee*DepreMonths/Months	;Modified by JDL 2012-3-8 JDL0121
	..e  i DepreMethodType=2  d
	...;不计提折旧
	..e  i DepreMethodType=3  d
	...;3:根据折旧率计提
	...i HasDepreFlag="Y"  d
	....s FundsDepreFee=FundsNetFee		;Modified by JDL 2012-3-8 JDL0121
	...e  d
	....s FundsDepreFee=FundsFee*DepreMonths*Rate/100
	..e  i DepreMethodType=4  d
	...;4:一次性计提
	...s FundsDepreFee=FundsFee
	..i DepreMethodType=5  d	//add by czf 2020-02-20 CZF0053
	...;平均年限法(基于原值)
	...i HasDepreFlag="Y"  d
	....s FundsDepreFee=FundsNetFee
	...e  d
	....s FundsDepreFee=FundsFee*DepreMonths/Months
	.s FundsDepreFee=$Number(FundsDepreFee,2) 
	.s RemainDepreFee=RemainDepreFee-FundsDepreFee
	.s FundsDepreTotalFee=FundsDepreTotalFee+FundsDepreFee
	.i FundsDepreInfo'="" s FundsDepreInfo=FundsDepreInfo_"#"
	.s FundsDepreInfo=FundsDepreInfo_FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee_"^"_FundsFee_"^"_FinaceItemID_"^"_FunctionCatID		//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	
	q
}

/// 20140429  Mozy0129
/// d ##class(%ResultSet).RunQuery("web.DHCEQMonthDepre","GetEquipDepreDetail","1")
Query GetEquipDepreDetail(EquipDR As %Library.String = "", LocDR As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TNo:%String,TName:%String,TModel:%String,TLoc:%String,TEQStatus:%String,TOriginalFee:%String,TDepreMonth:%String,TDepreFee:%String,TNetFee:%String,TPreTotalDepreFee:%String,TNetRemainFee:%String")
{
}

ClassMethod GetEquipDepreDetailExecute(ByRef qHandle As %Binary, EquipDR As %Library.String = "", LocDR As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If EquipDR="" Quit $$$OK
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	Set TotalFee=0
 	Kill ^DHCEQTemp("GetEquipDepreDetail",+$H,User)
 	
 	;排序
 	Set rowid=0
	For  Set rowid=$Order(^DHCEQMonthDepre(0,"Equip",EquipDR,rowid)) Quit:rowid=""  Do
 	.Set TLocDR = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",33)
	.Quit:(LocDR'="")&(LocDR'=TLocDR)
 	.Set TPreTotalDepreFee = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",12)
 	.
 	.;过滤旧折旧记录和冲负记录
 	.Set TNetFee = +$Piece($Get(^DHCEQMonthDepre(rowid)),"^",17)
 	.Quit:TNetFee<0
 	.Set THold1 = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",39)		;Hold1
 	.If THold1'="" Kill ^DHCEQTemp("GetEquipDepreDetail",+$H,User,TPreTotalDepreFee,THold1)
 	.
 	.Set ^DHCEQTemp("GetEquipDepreDetail",+$H,User,TPreTotalDepreFee,rowid)=""
 	
 	;设备信息
 	Set TNo = $Piece($Get(^DHCEQEquip(EquipDR)),"^",71)
	Set TName = $Piece($Get(^DHCEQEquip(EquipDR)),"^",1)
	Set TModelDR = $Piece($Get(^DHCEQEquip(EquipDR)),"^",3)
	If TModelDR'="" Set TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model", TModelDR)
	Set TEQStatus = $Piece($Get(^DHCEQEquip(EquipDR)),"^",38)
	Set TEQStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TEQStatus)
	
	Set index=2
	Set TPreTotalDepreFee=0
	For  Set TPreTotalDepreFee=$Order(^DHCEQTemp("GetEquipDepreDetail",+$H,User,TPreTotalDepreFee)) Quit:TPreTotalDepreFee=""  Do
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQTemp("GetEquipDepreDetail",+$H,User,TPreTotalDepreFee,rowid)) Quit:rowid=""  Do
	..Do ResetVariablesGetEquipDepreDetail
	..Set TRowID = rowid
	..Set TOriginalFee = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",5)
	..Set TDepreMonth = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",6)
	..Set TDepreFee = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",14)
	..Set TNetFee = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",17)
	..Set TNetRemainFee = $Piece($Get(^DHCEQMonthDepre(rowid)),"^",18)
	..Set TLocDR=$Piece($Get(^DHCEQMonthDepre(rowid)),"^",33)
	..;If TLocDR'="" Set TLoc = $Piece($Get(^CTLOC(TLocDR)),"^",2)  //modify by jyp 2019-10-18 CTLOC调整
	..If TLocDR'="" Set TLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)  //modify by jyp 2019-10-18 CTLOC调整
	..If TLoc'="" Set TLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag(TLoc,"-")
	..Set TotalFee=TotalFee+TDepreFee
	..
	..Do OutputRowGetEquipDepreDetail
	
	Set (TRowID,TNo,TName,TModel,TLoc,TEQStatus,TOriginalFee,TDepreMonth,TDepreFee,TNetFee,TPreTotalDepreFee,TNetRemainFee)=""
	Set TName="合计"
	Set TDepreFee=TotalFee
	Set index=1
	Do OutputRowGetEquipDepreDetail
	
	Quit $$$OK

OutputRowGetEquipDepreDetail
	Set Data=$lb(TRowID,TNo,TName,TModel,TLoc,TEQStatus,TOriginalFee,TDepreMonth,TDepreFee,TNetFee,TPreTotalDepreFee,TNetRemainFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetEquipDepreDetail
	Set (TRowID,TLoc,TOriginalFee,TDepreMonth,TDepreFee,TNetFee,TNetRemainFee)=""
	Quit
}

ClassMethod GetEquipDepreDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipDepreDetailExecute ]
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

ClassMethod GetEquipDepreDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipDepreDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQMonthDepre).ExecuteAdjustData("11096",282)
ClassMethod ExecuteAdjustData(MDIDs As %Library.String = "", ToLocDR As %Library.String = "")
{
	If (MDIDs="")||(ToLocDR="") Quit 0
	
	Set curDate=+$H
	Set curTime=$Piece($H,",",2)
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	Set SQLCODE=0
	TSTART
	
	Set MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	Set len=$L(MDIDs,"^")
	For i=1:1:len
	{
		Set MDID=$Piece(MDIDs,"^",i)
		Kill PLIST
		Set PLIST(2)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",1)
		Set PLIST(3)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",2)
		Set PLIST(4)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",3)
		Set PLIST(5)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",4)
		Set PLIST(6)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",5)
		Set PLIST(7)=MonthStr
		Set PLIST(8)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",7)
		Set PLIST(9)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",8)
		Set PLIST(10)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",9)
		Set PLIST(11)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",10) 	//总折旧月份
		Set PLIST(14)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",13)
		Set PLIST(19)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",18) 	//设备净残值
		Set PLIST(20)="N"
		Set PLIST(21)="1"
		Set PLIST(24)=curDate
		Set PLIST(25)=curTime
		Set PLIST(27)=curDate
		Set PLIST(28)=curTime
		Set PLIST(30)=curDate
		Set PLIST(31)=curTime
		Set PLIST(32)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",31)
		Set PLIST(33)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",32)
		Set PLIST(35)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",34)	//CommonFlag共用标志
		Set PLIST(37)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",36)
		Set PLIST(38)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",37)	//DepreRate折旧率
		Set PLIST(39)=$Piece(^DHCEQEquip($Piece($Get(^DHCEQMonthDepre(MDID)),"^",1)),"^",17)	//ManageLocDR管理部门
		Set PLIST(40)=MDID											// 冲负记录
		
		If (ToLocDR'=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",33))
		{
			;冲负
			Set PLIST(13)=-$Piece($Get(^DHCEQMonthDepre(MDID)),"^",12)	;MDPreTotalDepreFee
			Set PLIST(15)=-$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)	;MDDepreFee
			Set PLIST(18)=-$Piece($Get(^DHCEQMonthDepre(MDID)),"^",17)	;MDNetFee
			Set PLIST(34)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",33)	;MDLocDR
			&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
			Quit:SQLCODE'=0
			//20140506  Mozy0130
			Kill CAD
			Set SQLCODE=0
			Set CAD(2)=1
			Set CAD(3)=$Get(%ROWID)
			;Set CAD(6)=-$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)	;MDDepreFee
			Set CADID=0
			For  Set CADID=$Order(^DHCEQCostAllotDetail(0,"SourceID",MDID,CADID)) Quit:(CADID="")||(SQLCODE'=0)  Do
			.Set CAD(4)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",3)
			.Set CAD(6)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",5)
			.Set CAD(7)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",6)
			.Set CAD(8)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",7)
			.&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
			Quit:SQLCODE'=0
			
			;调正
			Set PLIST(13)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",12)	;MDPreTotalDepreFee
			Set PLIST(15)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)	;MDDepreFee
			Set PLIST(18)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",17)	;MDNetFee
			Set PLIST(34)=ToLocDR	;MDLocDR
			&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
			Quit:SQLCODE'=0
			//20140506  Mozy0130
			Kill CAD
			Set SQLCODE=0
			Set CAD(2)=1
			Set CAD(3)=$Get(%ROWID)
			Set CAD(4)=ToLocDR
			;Set CAD(6)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)	;MDDepreFee
			Set CADID=0
			For  Set CADID=$Order(^DHCEQCostAllotDetail(0,"SourceID",MDID,CADID)) Quit:(CADID="")||(SQLCODE'=0)  Do
			.Set CAD(6)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",5)
			.Set CAD(7)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",6)
			.Set CAD(8)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",7)
			.&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
		}
		Quit:SQLCODE'=0
	}
	If SQLCODE
 	{
		TROLLBACK
		Quit SQLCODE
 	}
	
	TCOMMIT
	
	Quit 0
}

/// Add By DJ 2016-01-28
/// 描述:下账业务是否计提折旧
/// 返回值:0表示不计提 1 表示计提
ClassMethod ReduceBussDepreFlag(vEquipDR As %String = "")
{
	i vEquipDR="" q 0
	s DepreBussIDs=","_##class(web.DHCEQCommon).GetSysInfo("990041")_","
	s EQStatus=+$p(^DHCEQEquip(EquipID),"^",38)
	s EQStockStatus=+$p(^DHCEQEquip(vEquipDR),"^",60)
	s EQInvalidFlag=$p(^DHCEQEquip(vEquipDR),"^",59)
	//退货,减少
	i (EQStatus=2)&&(EQStockStatus=3)
	{
		i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,23)) q 0
		s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,23,""),-1)
		i 0=##Class(web.DHCEQReport).IsCurReportMonth(LIDate) q 0
		i ((DepreBussIDs[",1,")||(DepreBussIDs[",4,"))		//1退货不提，4减少不提
		{
			s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,23,LIDate,0))
			s LISourceID=$p($g(^DHCEQLifeInfo(LIRowID)),"^",20)
			s RRowID=$p($g(^DHCEQReturnList(LISourceID)),"^",1)
			s ReturnTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",17)
			s ReturnTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",ReturnTypeDR)),"^",1)
			i (DepreBussIDs[",1,")&&(ReturnTypeCode="TH") q 0
			i (DepreBussIDs[",4,")&&(ReturnTypeCode'="TH") q 0
		}
	}
	//报废
	i EQStatus=3
	{
		i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,34)) q 0
		s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,34,""),-1)
		i 0=##Class(web.DHCEQReport).IsCurReportMonth(LIDate) q 0
		i (DepreBussIDs[",3,") q 0
	}
	//数据调整
	i EQInvalidFlag="Y"
	{
		s ADFlag=1
		i '$D(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,61)) q 0
		s LIDate=0
		f  s LIDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,61,LIDate))  q:(LIDate="")||(ADFlag=0)  d
		.q:##Class(web.DHCEQReport).IsCurReportMonth(LIDate)=0
		.s LIRowID=0
		.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,61,LIDate,LIRowID))  q:(LIRowID="")||(ADFlag=0)  d
		..s LISourceID=$p($g(^DHCEQLifeInfo(LIRowID)),"^",20)
		..s ADRowID=$p($g(^DHCEQAdjustDataList(LISourceID)),"^",1)
		..s ADType=$p($g(^DHCEQAdjustData(ADRowID)),"^",1)
		..q:ADType'=3
		..s ADReportFlag=$p($g(^DHCEQAdjustData(ADRowID)),"^",1)
		..q:ADReportFlag'="Y"
		..i (DepreBussIDs[",2,") s ADFlag=0
		
		q ADFlag
	}
	
	q 1
}

/// Creator:add by CZF0086  添加退货,科室调整,折旧年限调整,折旧方法调整 2020-03-06
/// 			modified by lmm 添加入库日期调整处理
/// 			modified by zc 添加报废恢复
/// 描述：资产折旧调整
///       本方法只提供设备折旧数据调整，调整类型为退货和科室变动时，需首先修改相关入出库记录，否则调整中新生成的月结数据有误
/// 入参：val:设备ID^调整类型^调整后的值^调整理由^调整人
/// 		  DepreTypeDR:折旧类型(默认主折旧1)
/// 出参: 0:成功 其他:失败
/// 命令: w ##Class(web.DHCEQMonthDepre).ExecuteAdjustDataNew("333^3^10^年限调整^xxx",1)
ClassMethod ExecuteAdjustDataNew(val As %Library.String = "", DepreTypeDR As %Library.String = "1")
{
	new EquipID,Type,CurValue,Reason,AdjustUser,result
	set EquipID=$p(val,"^",1)
	set Type=$p(val,"^",2)		//调整类型 1：退货 2:科室调整 3:折旧年限调整 4:折旧方法调整  5.入库日期修改   6:报废恢复  //Modefied by  zc0056  添加类型  6:报废恢复 
	set CurValue=$p(val,"^",3)	//调整后的值
	set Reason=$p(val,"^",4)
	set AdjustUser=$p(val,"^",5)
	If (EquipID="")||(Type="") Quit 0
	Set curDate=+$H
	Set curTime=$Piece($H,",",2)
	Set User=1 //%session.Get("LOGON.USERID")
	Set SQLCODE=0
	s result=0 //Modefied by  zc0056 初始化result
	Set TotalFlag=0
	k ^TempMonthDepre
	k ^TempFundsDepre
	
	//add by lmm 2020-01-20 begin
	if (Type=5)
	{
		s SQLCODE=0
		s changeaccountid=0
		f  s changeaccountid=$o(^DHCEQChangeAccount(0,"Equip",EquipID,changeaccountid)) q:changeaccountid=""  d
		.s Status=$Piece($Get(^DHCEQChangeAccount(changeaccountid)),"^",11)
		.q:(Status'=2)
		.s SQLCODE=1
		if (SQLCODE=1)
		{
			q -1111
			TRollBack
		}
	}
		//add by lmm 2020-01-20 end
	//add by lmm 2020-03-18 LMM0063
	s SelfFinaceItemFlag=##class(web.DHCEQCommon).GetSysInfo("990070")
	s SelfFunctionCatFlag=##class(web.DHCEQCommon).GetSysInfo("990071")	

	TSTART
	;取该设备的对应的相应的折旧设置
	s DepreSetID=$o(^DHCEQDepreSet(0,"Source",DepreTypeDR,0,EquipID,0))
	;没有相应的折旧设置
	i DepreSetID="" q -1001
	s MinusType=0			
	//退货
	if (Type=1)
	{
		//modify by lmm 2020-02-19 begin
		s MDIDN=""
		f  s MDIDN=$o(^DHCEQMonthDepre(0,"Equip",EquipID,MDIDN)) q:MDIDN=""  d
		.s ^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDIDN)=""		
		
		s MDID=""
		f  s MDID=$o(^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDID)) q:MDID=""  d
		.d DepreMinus
		.q:SQLCODE
		k ^TempMonthDepre
		//modify by lmm 2020-02-19 end
		
		if SQLCODE
		{
			q SQLCODE
			TRollBack
		}
		//更新折旧设置表
		Set MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
		Set DepreTotal=0
		Set DepreTotalFee=0
		&SQL(update sqluser.DHC_EQDepreSet set DS_PreDepreMonth=NULL,DS_DepreTotal=:DepreTotal,DS_DepreTotalFee=:DepreTotalFee where DS_RowID=:DepreSetID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		//更新台账表
		Set OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
		Set NewRemainFee=$p($g(^DHCEQEquip(EquipID)),"^",29)  //modify by lmm 2020-02-19
		Set NetFee=OriginalFee-NewRemainFee
		
		//modified by czf 1247213 退货中处理设备状态
		&SQL(update sqluser.DHC_EQEquip set EQ_NetFee=:NetFee,EQ_DepreTotalFee=:DepreTotalFee where EQ_RowID=:EquipID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		//更新当前资金来源
		&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=0 where F_SourceType=1 and F_SourceID=:EquipID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		//更新月结  //modified by czf 1247213 恢复月报折旧信息，无需重新生成月报，只要修改月报折旧信息即可
		/*
		s TransAssetDate=$Piece($Get(^DHCEQEquip(EquipID)),"^",45)
		s EquipTypeDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
		s FromMonthStr=$p($zd(TransAssetDate,3),"-",1,2)
		s ToMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$h)	
		s result=##Class(web.DHCEQJob).insertMonthReport(FromMonthStr,ToMonthStr,EquipTypeDR)	
		i result
		{
			q result
			TRollBack
		}
		*/
	}
	//科室调整
	if (Type=2)
	{
		//modify by lmm 2020-02-19 begin
		s MDIDN=""
		f  s MDIDN=$o(^DHCEQMonthDepre(0,"Equip",EquipID,MDIDN)) q:MDIDN=""  d
		.s ^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDIDN)=""		
		
		s MDID=""
		f  s MDID=$o(^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDID)) q:MDID=""  d
		.;折旧冲负后调正
		.s MinusType=1
		.d DepreMinus
		.q:SQLCODE
		k ^TempMonthDepre
		
		//modify by lmm 2020-02-19 end
		
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		//更新台账表
		Set Status=$p($g(^DHCEQEquip(EquipID)),"^",38)
		Set UseLoc=CurValue
		if Status=0 Set UseLoc=""
		&SQL(update sqluser.DHC_EQEquip set EQ_StoreLocDR=:CurValue,EQ_UseLocDR=:UseLoc where EQ_RowID=:EquipID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		//更新月结
		s TransAssetDate=$Piece($Get(^DHCEQEquip(EquipID)),"^",45)
		s EquipTypeDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
		s FromMonthStr=$p($zd(TransAssetDate,3),"-",1,2)
		s ToMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$h)	
		s result=##Class(web.DHCEQJob).insertMonthReport(FromMonthStr,ToMonthStr,EquipTypeDR)	
		i result
		{
			q result
			TRollBack
		}
	}
	//折旧年限或折旧方法调整
	if (Type=3)||(Type=4)
	{
		s OriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
		s NetFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",28)
		s DepreTotalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",35)
		s EquipTypeDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
		s DepreTotal=$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",22)
		s LimitYears=$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",31)
		s DepreMethod=$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",2)
		s (DepreFeeAmount,DepreMonths)=0
		
		s MDIDN=""
		f  s MDIDN=$o(^DHCEQMonthDepre(0,"Equip",EquipID,MDIDN)) q:MDIDN=""  d
		.s ^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDIDN)=""		
		.s CADID=""
		.f  s CADID=$o(^DHCEQCostAllotDetail(0,"SourceID",MDIDN,CADID)) q:(CADID="")  d
		..s FundsType=$p($g(^DHCEQCostAllotDetail(CADID)),"^",7)
		..s FundsDepre=$p($g(^DHCEQCostAllotDetail(CADID)),"^",5)
		..;modify by lmm 2020-03-10 LMM0063
		..s (FinaceItemID,FunctionCatID)=""
		..s FinaceItemID=$p($g(^DHCEQCostAllotDetail(CADID)),"^",9)
		..s FunctionCatID=$p($g(^DHCEQCostAllotDetail(CADID)),"^",10)
		..i FinaceItemID="" s FinaceItemID=SelfFinaceItemFlag
		..i FunctionCatID="" s FunctionCatID=SelfFunctionCatFlag
		..i '$d(^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)) d
		...s ^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)=FundsDepre
		..e  d
		...s ^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)=$p($g(^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)),"^",1)+FundsDepre
		
		s MDID=""
		f  s MDID=$o(^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDID)) q:MDID=""  d
		.s DepreMonth=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",6)
		.s DepreFeeAmount=DepreFeeAmount+$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)
		.s DepreMonths=DepreMonths+1
		.s NetRemainFee=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",18)
		.d DepreMinus
		.q:SQLCODE
		k ^TempMonthDepre
		
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		k EQ
		k DS
		k F       //add by lmm 2019-11-28
		s NetFee=NetFee+DepreFeeAmount
		s DepreTotalFee=DepreTotalFee-DepreFeeAmount   //modify by lmm 2019-11-28
		s DepreTotal=DepreTotal-DepreMonths
		i DepreTotal<0 s DepreTotal=0  //add by lmm 2019-11-28
		s EQ(28)=OriginalFee
		s EQ(29)=NetFee
		s EQ(36)=DepreTotalFee
		s EQ(32)=LimitYears
		s EQ(34)=DepreMethod
		i Type=3 s EQ(32)=CurValue
		i Type=4 s EQ(34)=CurValue
		//恢复设备累计折旧信息
		&SQL(update sqluser.DHC_EQEquip values:EQ() where EQ_RowID=:EquipID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		s DS(6)=""
		//s DS(3)=DepreMethod   //modify by lmm 2019-12-02
		s DS(23)=DepreTotal
		s DS(24)=DepreTotalFee
		s DS(25)=LimitYears
		i Type=3 s DS(25)=CurValue
		i Type=4 s DS(20)=CurValue
		//恢复设备折旧设置
		&SQL(update sqluser.DHC_EQDepreSet values:DS() where DS_RowID=:DepreSetID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		
		//更新当前资金来源
		s FRowID=""
		f  s FRowID=$o(^DHCEQFunds("0","Source",1,EquipID,FRowID)) q:(FRowID="")||(SQLCODE'=0)  d
		.s FundsType=$p($g(^DHCEQFunds(FRowID)),"^",2)   //modify by lmm 2020-02-20
		.s FundsFee=$p($g(^DHCEQFunds(FRowID)),"^",3)
		.;modify by lmm 2020-03-10 LMM0063
		.s (FinaceItemID,FunctionCatID)=""
		.s FinaceItemID=$p($g(^DHCEQFunds(FRowID)),"^",20)
		.s FunctionCatID=$p($g(^DHCEQFunds(FRowID)),"^",21)
		.i FinaceItemID="" s FinaceItemID=SelfFinaceItemFlag
		.i FunctionCatID="" s FunctionCatID=SelfFunctionCatFlag
		.s ChangedDepre=$p($g(^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)),"^",1)
		.s FundsDepreTotalFee=$p($g(^DHCEQFunds(FRowID)),"^",13)
		.s NewFundsDepreTotalFee=FundsDepreTotalFee-ChangedDepre
		.&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:NewFundsDepreTotalFee where F_RowID=:FRowID)
		.q:SQLCODE
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		k ^TempFundsDepre
		//生成新折旧
		d GeneratrDepreNew
		i result
		{
			q result
			TRollBack
		}
	}
	if (Type=5)
	{
		
		s OriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
		s NetFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",28)
		s DepreTotalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",35)
		//modify by lmm 2019-11-28 begin
		s EquipTypeDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
		s TransAssetDateOld=$Piece($Get(^DHCEQEquip(EquipID)),"^",45)
		s TransAssetDateNew=CurValue
		s DepreTotal=$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",22)
		s LimitYears=$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",31)
		s DepreMethod=$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",33)
		s (DepreFeeAmount,DepreMonths)=0
		
		s MDIDN=""
		f  s MDIDN=$o(^DHCEQMonthDepre(0,"Equip",EquipID,MDIDN)) q:MDIDN=""  d
		.s ^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDIDN)=""		
		.s CADID=""
		.f  s CADID=$o(^DHCEQCostAllotDetail(0,"SourceID",MDIDN,CADID)) q:(CADID="")  d
		..s FundsType=$p($g(^DHCEQCostAllotDetail(CADID)),"^",7)
		..s FundsDepre=$p($g(^DHCEQCostAllotDetail(CADID)),"^",5)
		..;modify by lmm 2020-03-10 LMM0063
		..s (FinaceItemID,FunctionCatID)=""
		..s FinaceItemID=$p($g(^DHCEQCostAllotDetail(CADID)),"^",9)
		..s FunctionCatID=$p($g(^DHCEQCostAllotDetail(CADID)),"^",10)
		..i FinaceItemID="" s FinaceItemID=SelfFinaceItemFlag
		..i FunctionCatID="" s FunctionCatID=SelfFunctionCatFlag
		..i '$d(^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)) d
		...s ^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)=FundsDepre
		..e  d
		...s ^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)=$p($g(^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)),"^",1)+FundsDepre
		..;modify by lmm 2020-03-10 LMM0063
		
		s MDID=""
		f  s MDID=$o(^TempMonthDepre("MonthDepre",0,"Equip",EquipID,MDID)) q:MDID=""  d
		.s DepreFeeAmount=DepreFeeAmount+$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)
		.s DepreMonths=DepreMonths+1
		.s NetRemainFee=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",18)
		.s MinusType=0
		.d DepreMinus
		.q:SQLCODE
		k ^TempMonthDepre		
		
		
		
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		k EQ
		k DS
		k F       //add by lmm 2019-11-28
		s NetFee=NetFee+DepreFeeAmount
		s DepreTotalFee=DepreTotalFee-DepreFeeAmount   //modify by lmm 2019-11-28
		s DepreTotal=DepreTotal-DepreMonths
		i DepreTotal<0 s DepreTotal=0  //add by lmm 2019-11-28
		s EQ(28)=OriginalFee
		s EQ(29)=NetFee
		s EQ(36)=DepreTotalFee
		i Type=5 s EQ(46)=CurValue
		//恢复设备累计折旧信息
		&SQL(update sqluser.DHC_EQEquip values:EQ() where EQ_RowID=:EquipID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		s DS(23)=DepreTotal
		s DS(24)=DepreTotalFee
		//add by lmm 2019-11-28 begin
		s PreDepreMonth=$p($zd(CurValue,3),"-",1,2)
		s DS(6)=PreDepreMonth
		//恢复设备折旧设置
		&SQL(update sqluser.DHC_EQDepreSet values:DS() where DS_RowID=:DepreSetID)
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		
		//更新当前资金来源
		s FRowID=""
		f  s FRowID=$o(^DHCEQFunds("0","Source",1,EquipID,FRowID)) q:(FRowID="")||(SQLCODE'=0)  d
		.s FundsType=$p($g(^DHCEQFunds(FRowID)),"^",2)   //modify by lmm 2020-02-20
		.s FundsFee=$p($g(^DHCEQFunds(FRowID)),"^",3)
		.;modify by lmm 2020-03-10 LMM0063
		.s (FinaceItemID,FunctionCatID)=""
		.s FinaceItemID=$p($g(^DHCEQFunds(FRowID)),"^",20)
		.s FunctionCatID=$p($g(^DHCEQFunds(FRowID)),"^",21)
		.i FinaceItemID="" s FinaceItemID=SelfFinaceItemFlag
		.i FunctionCatID="" s FunctionCatID=SelfFunctionCatFlag
		.s ChangedDepre=$p($g(^TempFundsDepre(0,"FundsDepre","1",EquipID,FundsType,+FinaceItemID,+FunctionCatID)),"^",1)
		.s FundsDepreTotalFee=$p($g(^DHCEQFunds(FRowID)),"^",13)
		.s NewFundsDepreTotalFee=FundsDepreTotalFee-ChangedDepre
		.&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:NewFundsDepreTotalFee where F_RowID=:FRowID)
		.q:SQLCODE
		i SQLCODE 
		{
			q SQLCODE
			TRollBack
		}
		k ^TempFundsDepre
		
		//生成新折旧
		d GeneratrDepreNew
		i result
		{
			q result
			TRollBack
		}
		//add by lmm 2019-11-28 begin
	
		d UpdateInStockDate
		i result
		{
			q result
			TRollBack
		}	
		i (TransAssetDateOld<TransAssetDateNew)
		{
			s FromMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(TransAssetDateOld)
		}
		else
		{
			s FromMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(TransAssetDateNew)
		}	
		s ToMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$h)	
		s result=##Class(web.DHCEQJob).insertMonthReport(FromMonthStr,ToMonthStr,EquipTypeDR)	
		i result
		{
			q result
			TRollBack
		}
		//add by lmm 2019-11-28 end
	}
	elseif (Type=6)     //Modefied by  zc0056 报废设备折旧  begin
	{
		d GeneratrDepreNew
		i result
		{
			q result
			TRollBack
		}
	}
	//Modefied by  zc0056 报废设备折旧  begin
	TCommit	
	q 0

	//更新月结表中的折旧信息
UpdMonthReportList
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(DepreMonth,"Equip")
	s Year=$p(DepreMonth,"-",1)
	s Month=+$p(DepreMonth,"-",2)
	i ((SnapID'="")&&($d(^DHCEQSnapShot(SnapID,"Equip",EquipID)))) 
	{
		s SnapInfo=$g(^DHCEQSnapShot(SnapID,"Equip",EquipID))
		s Status=$p(SnapInfo,"^",38)
		s EQStoreLocDR=$p(SnapInfo,"^",67)
		s EquipTypeDR=$p(SnapInfo,"^",63)
		s StatCatDR=$p(SnapInfo,"^",75)
		s OriginDR=$p(SnapInfo,"^",20)
		i OriginDR="" s OriginDR=0
		s rowid=0
		f  s rowid=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)) q:rowid=""  d
		.;modify by lmm 2020-03-15 LMM0063 begin
		.s FSnapInfo=^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)
		.s FundsTypeDR=$p(FSnapInfo,"^",2)
		.s FinaceItem=$p(FSnapInfo,"^",20)
		.s FunctionCat=$p(FSnapInfo,"^",21)
		.;防止资金来源与月报为空数值不一致情况
		.i FinaceItem="" s FinaceItem=0
		.i FunctionCat="" s FunctionCat=0
		.s MRListID=0
		.f  s MRListID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeDR,Year,Month,StatCatDR,EQStoreLocDR,MRListID)) q:MRListID=""  d
		..s MRLFinaceItem=$p($g(^DHCEQMonthReportList(MRListID)),"^",41)
		..i MRLFinaceItem="" s MRLFinaceItem=0
		..s MRLFunctionCat=$p($g(^DHCEQMonthReportList(MRListID)),"^",42)
		..i MRLFunctionCat="" s MRLFunctionCat=0
		..q:MRLFinaceItem'=FinaceItem
		..q:MRLFunctionCat'=FunctionCat
		..s OriginID=$p($g(^DHCEQMonthReportList(MRListID)),"^",26)  
		..q:OriginID'=OriginDR
		..s MRLTotalDepre=$p($g(^DHCEQMonthReportList(MRListID)),"^",28)   
		..s MRLDepre=$p($g(^DHCEQMonthReportList(MRListID)),"^",29)
		..s MRLNetFee=$p($g(^DHCEQMonthReportList(MRListID)),"^",33)		//modified by czf 2020-04-27 begin
		..;modify by lmm 2020-03-15 LMM0063 end
		..s NewMRLTotalDepre=MRLTotalDepre
		..s NewMRLDepre=MRLDepre
		..s NewNetFee=MRLNetFee
		..s CADID=0
		..f CADID=$o(^DHCEQCostAllotDetail(0,"SourceID",UpdMDID,CADID)) q:(CADID="")  d
		...q:$p($g(^DHCEQCostAllotDetail(CADID)),"^",7)'=FundsTypeDR
		...s FDepre=$p($g(^DHCEQCostAllotDetail(CADID)),"^",5)
		...s NewMRLTotalDepre=NewMRLTotalDepre+FDepre
		...s NewMRLDepre=NewMRLDepre+FDepre
		...s NewNetFee=NewNetFee-FDepre
		..&sql(Update SQLUSER.DHC_EQMonthReportList Set MRL_TotalDepre=:NewMRLTotalDepre,MRL_Depre=:NewMRLDepre,MRL_NetFee=:NewNetFee where MRL_RowID=:MRListID) //modified by czf 2020-04-27 end
		..q:SQLCODE
	}
	quit
	
DepreMinus
	//折旧冲负
	K PLIST
	Set PLIST(2)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",1)	//MD_EquipDR
	Set PLIST(3)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",2) //MD_DepreSetDR
	Set PLIST(4)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",3)	//MD_MainFlag
	Set PLIST(5)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",4) //MD_DepreMethodDR
	Set PLIST(6)=-1*$Piece($Get(^DHCEQMonthDepre(MDID)),"^",5)	//MD_OriginalFee   //modify by lmm 2019-11-18
	Set PLIST(7)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",6)	//MD_Month
	Set DepreMonth=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",6)
	Set PLIST(8)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",7) //MD_WorkLoadNum
	Set PLIST(9)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",8) //MD_WorkLoadUnitDR
	Set PLIST(10)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",9) //MD_LimityearsNum
	Set PLIST(11)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",10) 	//MD_DepreMonthNum
	Set PLIST(12)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",11)	//MDPreTotalWorkLoadFee
	Set PLIST(14)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",13)	//MDWorkLoadNum
	Set PLIST(19)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",18) 	//设备净残值
	Set PLIST(20)="N"	//MDAllotFlag
	Set PLIST(21)="1"	//MDStatus
	Set PLIST(23)=User
	Set PLIST(24)=curDate
	Set PLIST(25)=curTime
	Set PLIST(26)=User
	Set PLIST(27)=curDate
	Set PLIST(28)=curTime
	Set PLIST(29)=User
	Set PLIST(30)=curDate
	Set PLIST(31)=curTime
	Set PLIST(32)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",31)	//MD_DepreType
	Set PLIST(33)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",32)	//MD_AffixDR
	Set PLIST(35)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",34)	//CommonFlag共用标志
	Set PLIST(37)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",36)	//MD_DepreTypeDR
	Set PLIST(38)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",37)	//DepreRate折旧率
	Set PLIST(39)=$Piece(^DHCEQEquip($Piece($Get(^DHCEQMonthDepre(MDID)),"^",1)),"^",17)	//ManageLocDR
	Set PLIST(40)=MDID
	Set PLIST(41)=Reason
	Set PLIST(42)=AdjustUser
	Set PLIST(13)=-1*$Piece($Get(^DHCEQMonthDepre(MDID)),"^",12)	;MDPreTotalDepreFee
	Set PLIST(15)=-1*$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)	;MDDepreFee
	Set PLIST(18)=-1*$Piece($Get(^DHCEQMonthDepre(MDID)),"^",17)	;MDNetFee
	Set PLIST(34)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",33)	;MDLocDR
	&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
	if SQLCODE q SQLCODE
	s MonthDepreID=$Get(%ROWID)

	//分摊表冲负
	Kill CAD
	Set SQLCODE=0
	Set CAD(2)=1
	Set CAD(3)=MonthDepreID
	Set CADID=0
	For  Set CADID=$Order(^DHCEQCostAllotDetail(0,"SourceID",MDID,CADID)) Quit:(CADID="")||(SQLCODE'=0)  Do
	.Set CAD(4)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",3)
	.Set CAD(5)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",4)
	.Set CAD(6)=-$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",5)
	.Set CAD(7)=-$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",6)  
	.Set CAD(8)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",7)
	.Set CAD(9)=-$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",8)
	.;modify by lmm 2020-03-10 LMM0063
	.Set CAD(10)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",9)
	.Set CAD(11)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",10)
	.&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	if SQLCODE q SQLCODE
	
	//生命周期
	Kill LI
	s OldLIRowID=""
	//modify by lmm 2019-11-28 begin
	s equipID=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",1)
	s OldLIRowID=$o(^DHCEQLifeInfo(0,"EquipSource",35,equipID,MDID,OldLIRowID))
	i OldLIRowID="" quit -101
	//modify by lmm 2019-11-28 end
	s LI(2)=$p(^DHCEQLifeInfo(OldLIRowID),"^",1)  //设备
	s LI(4)=$p(^DHCEQLifeInfo(OldLIRowID),"^",3)   //原使用科室
	s LI(5)=$p(^DHCEQLifeInfo(OldLIRowID),"^",4) //原管理科室
	s LI(6)=$p(^DHCEQLifeInfo(OldLIRowID),"^",5)  //原库房
	s LI(7)=$p(^DHCEQLifeInfo(OldLIRowID),"^",6)  //原值
	s LI(8)=$p(^DHCEQLifeInfo(OldLIRowID),"^",7)  //原净值
	s LI(16)=curDate	//变动日期
	s LI(17)=curTime	//变动时间
	s LI(18)=-1*$p(^DHCEQLifeInfo(OldLIRowID),"^",17) //折旧费用
	s LI(19)="P"	//生命周期类型
	s LI(20)=35	//来源类型
	s LI(21)=MonthDepreID	//来源ID
	s LI(27)=User	//更新人
	s LI(28)=curDate	//更新日期
	s LI(29)=curTime	//更新时间
	s LI(9)=$p(^DHCEQLifeInfo(OldLIRowID),"^",8)  	 //变动后使用科室
	s LI(10)=$p(^DHCEQLifeInfo(OldLIRowID),"^",9) 	//变动后管理科室
	s LI(11)=$p(^DHCEQLifeInfo(OldLIRowID),"^",10)  //变动后库房
	s LI(12)=$p(^DHCEQLifeInfo(OldLIRowID),"^",11)  //变动后原值
	s LI(13)=$p(^DHCEQLifeInfo(OldLIRowID),"^",12)+$p(^DHCEQLifeInfo(OldLIRowID),"^",17) //变动后净值  //modify by lmm 2019-11-18
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	if SQLCODE q SQLCODE
	
	//月结折旧冲负
	//add by czf 20200206
	if ((Type=3)||(Type=4)||(Type=1))	//modified by czf 1247213 恢复月报折旧信息
	{
		//modify by lmm 2020-03-15 LMM0063
		s UpdMDID=MonthDepreID
		d UpdMonthReportList
		if SQLCODE q SQLCODE
	}
	;调正
	if MinusType=1
	{
		if (Type=2)
		{
			Set PLIST(6)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",5)	;OriginalFee  ;add by lmm 2020-03-15 LMM0063
			Set PLIST(13)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",12)	;MDPreTotalDepreFee
			Set PLIST(15)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",14)	;MDDepreFee
			Set PLIST(18)=$Piece($Get(^DHCEQMonthDepre(MDID)),"^",17)	;MDNetFee
			Set PLIST(34)=CurValue	;MDLocDR
			&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
			if SQLCODE q SQLCODE
			s NewMonthDepreID=$Get(%ROWID)
			
			Kill CAD
			Set CAD(2)=1
			Set CAD(3)=NewMonthDepreID
			Set CAD(4)=CurValue
			Set CADID=0
			For  Set CADID=$Order(^DHCEQCostAllotDetail(0,"SourceID",MDID,CADID)) Quit:(CADID="")||(SQLCODE'=0)  Do
			.Set CAD(5)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",4)
			.Set CAD(6)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",5)
			.Set CAD(7)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",6)
			.Set CAD(8)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",7)
			.Set CAD(9)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",8)
			.;modify by lmm 2020-03-10 LMM0063
			.Set CAD(10)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",9)
			.Set CAD(11)=$Piece($Get(^DHCEQCostAllotDetail(CADID)),"^",10)
			.&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
			if SQLCODE q SQLCODE
			
			s LI(6)=CurValue  //原库房
			s LI(18)=$p(^DHCEQLifeInfo(OldLIRowID),"^",17) //折旧费用
			s LI(9)=CurValue
			&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
			if SQLCODE q SQLCODE
		}
	}
	
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(DepreMonth,"Equip")
	//modify by lmm 2019-12-03
	i ((SnapID'="")&&($d(^DHCEQSnapShot(SnapID,"Equip",EquipID)))) 
	{
		s SnapInfo=$g(^DHCEQSnapShot(SnapID,"Equip",EquipID))
		if (Type=1)
		{
			//更新设备快照
			s $p(SnapInfo,"^",28)=$p(SnapInfo,"^",27)	//EQNetFee
			s $p(SnapInfo,"^",35)=0		//EQDepreTotalFee
			s ^DHCEQSnapShot(SnapID,"Equip",EquipID)=SnapInfo
			
			//更新资金来源快照
			s rowid=0
			f  s rowid=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)) q:rowid=""  d
			.s FSnapInfo=$p($g(^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)),"^",13)
			.s $p(FSnapInfo,"^",13)=0
			.s ^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)=FSnapInfo
		}
		if (Type=2)
		{
			//更新设备快照
			s UseLoc=CurValue
			i $p($g(^DHCEQEquip(EquipID)),"^",38)=0 s UseLoc=""
			s $p(SnapInfo,"^",19)=UseLoc		//EQUseLoc
			s $p(SnapInfo,"^",67)=CurValue		//EQStockLocDR
			s ^DHCEQSnapShot(SnapID,"Equip",EquipID)=SnapInfo
		}
	}
	quit

	
GeneratrDepreNew
	//重计算月折旧
	//调账记录不可用下面方法---
	s DepreDateFlag=##class(web.DHCEQCommon).GetSysInfo("990061")	//折旧依据日期
	i DepreDateFlag=1
	{
		s StartDate=$P(^DHCEQEquip(EquipID),"^",44)	///启用日期
	}
	elseif (DepreDateFlag="0")||(DepreDateFlag="")	
	{
		s StartDate=$P(^DHCEQEquip(EquipID),"^",45)	///转资日期
	}
	i StartDate'=""
	{
		//add by lmm 2019-11-29
		i (Type=5)
		{
		
			s SnapID=0
			f  s SnapID=$o(^DHCEQSnapShot(SnapID)) q:(SnapID="")  d
			.s SnapDate=+$g(^DHCEQSnapShot(SnapID,"Equip",0,"Begin"))	;快照日期
			.q:(SnapDate>(StartDate-1))
			.q:('$d(^DHCEQSnapShot(SnapID,"Equip",EquipID)))
			.s $p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",59)="Y"
			.s OldFundsID=1
			.f  s OldFundsID=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID,OldFundsID)) q:(OldFundsID="")  d
			..q:('$d(^DHCEQSnapShot(SnapID,"Funds",EquipID,OldFundsID)))
			..s $p(^DHCEQSnapShot(SnapID,"Funds",EquipID,OldFundsID),"^",10)="Y"
			
			s vMonthStr=$p($zd(StartDate,3),"-",1,2)
			s vNxetMonthStr=##Class(web.DHCEQCommon).MonthStrAdd("M",1,vMonthStr)	//下月月份
			s vDate=$zdh(vNxetMonthStr_"-01",3)-1	
			
			s CurMonth=$p($zd(CurValue,3),"-",1,2)
			s CurDate=$zdh(CurMonth_"-01",3)
		}
		elseif (Type=3)||(Type=4)
		{
			s SnapID=""
			s RowID=0
			s result=0
			s InputFlag=$P(^DHCEQEquip(EquipID),"^",47)
			i InputFlag="Y" s RowID=1	//导入数据RowID=1时为初始化快照
			f  s RowID=$o(^DHCEQSnapShot(RowID)) q:(RowID="")||(SnapID'="")  d
			.i $d(^DHCEQSnapShot(RowID,"Equip",EquipID)) s SnapID=RowID
			s SnapDate=+$g(^DHCEQSnapShot(SnapID,"Equip",0,"Begin"))	;快照日期
			s vDate=SnapDate-1
			s vMonthStr=$p($zd(vDate,3),"-",1,2)			
		}
		elseif (Type=6)   //Modefied by  zc0056 报废设备折旧  begin
		{
			s CurMonth=$p($zd(CurValue,3),"-",1,2)
			s CurDate=$zdh(CurMonth_"-01",3)
			s DSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(CurMonth)
			i DSnapID="" q 0    //Modefied by  zc0133 不存在快照直接退出
			s SnapDate=+$g(^DHCEQSnapShot(DSnapID,"Equip",0,"Begin"))	;快照日期
			s vMonthStr=CurMonth
			s vDate=SnapDate-1
		}
		//Modefied by  zc0056 报废设备折旧  end
		//Modefied by  zc0056 SnapDate已转换成非空值
		i (SnapDate>0)
		{
			s MonthSnapDate=1+##Class(web.DHCEQReport).GetReportDate(vMonthStr,"2","")
			s ToDepreMonth=$p($zd(+$h,3),"-",1,2)
			s toDepreDate=$zdh(ToDepreMonth_"-01",3)
			s fromDepreDate=$zdh(vMonthStr_"-01",3)
			s EquipIDNew=EquipID		
			//s vDate=SnapDate-1
			//s vMonthStr=$p($zd(vDate,3),"-",1,2)
			//s MonthSnapDate=1+##Class(web.DHCEQReport).GetReportDate(vMonthStr,"2","")
			//s ToDepreMonth=$p($zd(+$h,3),"-",1,2)
			//Modefied by  zc0056 增加类型6 报废恢复
			i ((Type=5)||(((Type=3)||(Type=4)||(Type=6))&&(SnapDate=MonthSnapDate)))
			{
				while (fromDepreDate<toDepreDate)   //modify by lmm 2019-11-29
				{
					s EquipID=EquipIDNew     //modify by lmm 2019-11-29
					s vDate=##Class(web.DHCEQReport).GetReportDate(vMonthStr,"2","")
					//生成新折旧
					s result=##class(web.DHCEQMonthDepre).RebuildGenerateMonthDepre(EquipID,vMonthStr,vDate,DepreTypeDR,"Y","0","","Y")
					
					i $p(result,"^",1)'=0 break
					//更新月结折旧信息
					//add by czf 20200206
					i (Type=3)||(Type=4)
					{
						s DepreMonth=vMonthStr
						s UpdMDID=$p(result,"^",2)
						d UpdMonthReportList
						q:SQLCODE
					}
					//更新设备快照
					s NewSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(vMonthStr,"Equip")
					//modify by lmm 2019-11-29
					i (NewSnapID'="")&&($d(^DHCEQSnapShot(NewSnapID,"Equip",EquipID)))
					{					
							
							s SnapInfo=$g(^DHCEQSnapShot(NewSnapID,"Equip",EquipID))
							s $p(SnapInfo,"^",28)=$p($g(^DHCEQEquip(EquipID)),"^",28)	//EQNetFee
							s $p(SnapInfo,"^",31)=$p($g(^DHCEQEquip(EquipID)),"^",31)	//EQLimitYearsNum
							s $p(SnapInfo,"^",33)=$p($g(^DHCEQEquip(EquipID)),"^",33)	//EQDepreMethod
							s $p(SnapInfo,"^",35)=$p($g(^DHCEQEquip(EquipID)),"^",35)	//EQDepreTotalFee
							//modify by lmm 2019-11-29 begin
							s $p(SnapInfo,"^",59)="N"	                                //EQInvaildFlag	
							s $p(SnapInfo,"^",45)=$p($g(^DHCEQEquip(EquipID)),"^",45)	//EQTransAssetDate	
							s ^DHCEQSnapShot(NewSnapID,"Equip",EquipID)=SnapInfo
							
							//Modefied by  zc0056 begin 报废设备台账信息恢复
							i Type=6 d
							.s SnapOtherInfo=$g(^DHCEQSnapShot(NewSnapID,"Equip",EquipID,"OtherInfo"))
							.s SnapEXInfo=$g(^DHCEQSnapShot(NewSnapID,"Equip",EquipID,"EX"))
							.s $p(SnapInfo,"^",38)=$p($g(^DHCEQEquip(EquipID)),"^",38)	//EQStatus
							.s $p(SnapInfo,"^",89)=$p($g(^DHCEQEquip(EquipID)),"^",89)	//EQDisuseDate
							.s $p(SnapInfo,"^",93)=$p($g(^DHCEQEquip(EquipID)),"^",93)	//EQAdvanceDisFlag
							.s $p(SnapOtherInfo,"^",9)=$p($g(^DHCEQEquip(EquipID,"OtherInfo")),"^",9)	//EQHold1
							.s $p(SnapEXInfo,"^",31)=##Class(web.DHCEQEquip).GetEquipStatusDisplay($p($g(^DHCEQEquip(EquipID)),"^",38))
							.s ^DHCEQSnapShot(NewSnapID,"Equip",EquipID,"EX")=SnapEXInfo
							.s ^DHCEQSnapShot(NewSnapID,"Equip",EquipID,"OtherInfo")=SnapOtherInfo
							//Modefied by  zc0056 end 报废设备台账信息恢复
							
							s ^DHCEQSnapShot(NewSnapID,"Equip",EquipID)=SnapInfo
							s FundsID=0
							f  s FundsID=$o(^DHCEQSnapShot(NewSnapID,"Funds",EquipID,FundsID)) q:(FundsID="")  d
							.s SnapFundsInfo=$g(^DHCEQSnapShot(NewSnapID,"Funds",EquipID,FundsID))
							.s $p(SnapFundsInfo,"^",10)="N"	                                //FInvaildFlag
							.s $p(SnapFundsInfo,"^",13)=$p($g(^DHCEQFunds(FundsID)),"^",13)	//FDepreTotal
							.s ^DHCEQSnapShot(NewSnapID,"Funds",EquipID,FundsID)=SnapFundsInfo									
											
							//modify by lmm 2019-11-29 end
					}
					elseif ((NewSnapID'="")&&('$d(^DHCEQSnapShot(NewSnapID,"Equip",EquipID)))&&(Type=5))
					{
						s ^DHCEQSnapShot(NewSnapID,"Equip",EquipID)=^DHCEQEquip(EquipID)
						s SnapInfo=$g(^DHCEQSnapShot(NewSnapID,"Equip",EquipID))
						s $p(SnapInfo,"^",19)=""
						//s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
						//modify by lmm 2020-01-20 begin
						s StoreLocDR=""
						s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
						s rowid=0
						f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:rowid=""  d
						.q:(($p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",19))="Y") 
						.s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",13)
						.q:(NotUse="Y")	
						.s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",18)
						.q:(+DATo'=0)&&(+DATo<+$H)
						.q:('$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,rowid)))
						.s StoreLocDR=rowid
										
						if (StoreLocDR'="")
						{
							s $p(SnapInfo,"^",67)=StoreLocDR
							s $p(SnapInfo,"^",19)=""
							s $p(SnapInfo,"^",38)="0"
							s $p(SnapInfo,"^",60)="1"
						}
						s ^DHCEQSnapShot(NewSnapID,"Equip",EquipID)=SnapInfo
						//modify by lmm 2020-01-20 end
						s ^DHCEQSnapShot(NewSnapID,"Equip",EquipID,"OtherInfo")=$g(^DHCEQEquip(EquipID,"OtherInfo"))
						s EquipIDNew=EquipID
						s tmp=##Class(web.DHCEQEquip).GetEquipByID("","",EquipIDNew)
						s tmp=$PIECE(tmp,"^",##Class(web.DHCEQEquip).GetGlobalLen(),$l(tmp,"^"))
						s ^DHCEQSnapShot(NewSnapID,"Equip",EquipIDNew,"EX")=tmp
						
						s OldFundsID=0
						f  s OldFundsID=$o(^DHCEQFunds("0","Source","1",EquipIDNew,OldFundsID))  quit:OldFundsID=""  d
						.s ^DHCEQSnapShot(NewSnapID,"Funds",EquipIDNew,OldFundsID)=$g(^DHCEQFunds(OldFundsID))
										
					}					
							
					s vMonthStr=##Class(web.DHCEQCommon).MonthStrAdd("M",1,vMonthStr)	//下月月份
					s fromDepreDate=$zdh(vMonthStr_"-01",3)  //modify by lmm 2019-11-29
				}
				i result q result
			}
			
		}
	}
	quit
	
UpdateInStockDate
	s InStockListID=$p($g(^DHCEQEquip(EquipID)),"^",70)
	//add by lmm 2020-01-21 begin 导入设备无入库单修改
	if (InStockListID="")
	{
		q 0
	}
	//add by lmm 2020-01-21 end
	s instockid=$p($g(^DHCEQInStockList(InStockListID)),"^",1)
	&SQL(update sqluser.DHC_EQInStock set IS_BillAuditDate=:CurValue where IS_RowID=:instockid)
	i SQLCODE 
	{
		q SQLCODE
	}	
	quit
}

/// 生成一个设备在月度折旧
/// EquipID:设备id
/// Month：折旧月份格式（2006-06）
/// DepreMonthDate：折旧月份日期，格式为数字  
/// DepreTypeDR：1固定的系统主折旧  其他对应的折旧类型ID
/// UseTrans: 使用事务 "Y" "N"
/// DepreType 0:正常按月计提1:设备报废一次性计提2:设备附件报废一次性计提附件未计提值
/// AffixID: 附件ID，用于附件报废时，一次性计提附件未提折旧
/// DepreDate：计提日期
/// DepreTime：计提时间
/// 返回值：result:0 成功  	
/// 		-1001(没有对应的折旧设置)；-1002(设置的折旧方法无效)；-1003(设置的折旧年限或折旧率无效)
/// 		-1004插入月度折旧失败;-1005更新折旧设置失败;-1006更新设备台帐失败
/// 		-1007插入生命周期信息失败；-1008插入折旧分摊信息失败
ClassMethod RebuildGenerateMonthDepre(EquipID, Month, DepreMonthDate, DepreTypeDR, UseTrans, DepreType, AffixID, AddFlag As %String = "")
{
	s User=1 // ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//modify by lmm 2019-11-20
	n (User,EquipID,Month,DepreMonthDate ,DepreTypeDR, UseTrans, DepreType, AffixID,AddFlag)
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(Month,"Equip")
	s (UseLocDR,WorkTotal,UnitDR,StoreLocDR,CommonFlag,ManageLocDR)=""
	if (SnapID'="")&&($d(^DHCEQSnapShot(SnapID,"Equip",EquipID)))
	{
		s UseLocDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EquipID)),"^",19)
		s WorkTotal=$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",36) // 工作总量
		s UnitDR=$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",37) //单位
		s StoreLocDR=$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",67)
		s CommonFlag=$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",82)
		s ManageLocDR=$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",17)
	}
	else
	{
		s StoreLocDR=$p(^DHCEQEquip(EquipID),"^",67)
		s WorkTotal=$p(^DHCEQEquip(EquipID),"^",36) // 工作总量
		s UseLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)
		s UnitDR=$p(^DHCEQEquip(EquipID),"^",37) //单位
		s CommonFlag=$p(^DHCEQEquip(EquipID),"^",82)
		s ManageLocDR=$p(^DHCEQEquip(EquipID),"^",17)
		
		//modify by lmm 2020-01-20 begin
		s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:rowid=""  d
		.q:(($p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",19))="Y") 
		.s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",13)
		.q:(NotUse="Y")	
		.s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",18)
		.q:(+DATo'=0)&&(+DATo<+$H)
		.q:('$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,rowid)))
		.s StoreLocDR=rowid
		.s UseLocDR=""
		
		//modify by lmm 2020-01-20 end
	}
	
	;获取设备折旧设置信息
	s vDate=Month_"-01"
	s vDate=$zdh(vDate,3)	
	s DepreSetInfo=..GetDepreSetInfo(EquipID, vDate, DepreTypeDR,"0")
	s FundsDepreInfo=$p(DepreSetInfo,"&",2)
	s DepreSetInfo=$p(DepreSetInfo,"&",1)
	i DepreSetInfo<0 q DepreSetInfo
	
	s depreSetID=$p(DepreSetInfo,"^",2)
	s mainFlag="N"
	i DepreTypeDR =1 s mainFlag="Y"
	i depreSetID="" q "-1001"
	
	s depreMethodType=$p(DepreSetInfo,"^",5)
	s depreMethodDR=$p(DepreSetInfo,"^",6)
	s years=$p(DepreSetInfo,"^",7)
	s rate=$p(DepreSetInfo,"^",8)
	s depreTotal=$p(DepreSetInfo,"^",9)
	s depreTotalFee=$p(DepreSetInfo,"^",10)		//累计折旧总费用
	s depreFee=$p(DepreSetInfo,"^",3)
	;DepreMonths折旧月份不为1，不需折旧
	i $p(DepreSetInfo,"^",4)'=1 q 0	;DepreMonths
		
	s curDate=##class(web.DHCEQCommon).TransValueFromPage(##Class(web.DHCEQReport).GetReportDate(Month,"2"),"date")  //Modefied by  zc0056 修改去当前日期折旧月份一致的问题
	s curTime=$P($H,",",2)
	
	s originalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)		//原值
	s netFee=$p($g(^DHCEQEquip(EquipID)),"^",28)			//净值
	s netRemainFee=$p($g(^DHCEQEquip(EquipID)),"^",29)	//净残值
		
	//设备报废一次性计提
	i (DepreType=1)
	{
		//当折旧方法为平均年限法时计提
		i (depreMethodType=1) s depreFee=originalFee-netRemainFee-depreTotalFee
		i depreFee<0 s depreFee=0		
	}
	elseif ((DepreType=2))	//报废附件一次性计提
	{
		//当折旧方法为平均年限法时计提
		i (depreMethodType=1)	s depreFee=..GetAffixDepreAmount(AffixID,years,depreTotal)
	}
	else   //正常计提
	{
		if (AddFlag="")   //add by lmm 2019-11-20 用于重新生成折旧
		{
			//当月尚未计提才计提
			i (Month'="2019-01")&($o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,0))'="") q 0  //modify by lmm 2018-12-07
			i (Month="2019-01")
			{
				s CurMDID=$o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,0))
				i CurMDID'=""
				{
					s CurMDRemark=$p($g(^DHCEQMonthDepre(CurMDID)),"^",21)
					i CurMDRemark'="新财务制度补提折旧" q 0
					i $o(^DHCEQMonthDepre(0,"SetMonth",depreSetID,Month,CurMDID))'="" q 0
				}
			}
		}
	}
	i depreFee>0 
	{
		s depreFee=$Number(depreFee,2)
	}
	else
	{
		q depreFee
	}
	
	//获取当月工作量
	s totalworkload=..GetTotalWorkLoad(EquipID,Month)
	//准备折旧数据
	s PLIST(2)=EquipID
	s PLIST(3)=depreSetID
	s PLIST(4)=mainFlag
	s PLIST(5)=depreMethodDR
	s PLIST(6)=originalFee
	s PLIST(7)=Month
	s PLIST(8)=WorkTotal  //$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",36) // 工作总量
	s PLIST(9)=UnitDR  //$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",37) //单位
	s PLIST(10)=years
	s depreTotal=depreTotal+1
	s PLIST(11)=depreTotal //总折旧月份
	//s PLIST(12)=
	s depreTotalFee=depreTotalFee+depreFee
	s PLIST(13)=depreTotalFee
	s PLIST(14)=totalworkload
	s PLIST(15)=depreFee
	
	;Modified by jdl 增加一种折旧设置 2011-8-1 JDL0088
	;s PLIST(18)=netFee //$p(result,"^",28) //设备净值
	s PLIST(18)=originalFee-depreTotalFee
	
	s PLIST(19)=netRemainFee //设备净残值
	s PLIST(20)="N"
	s PLIST(21)="1" //状态
	//s PLIST(22)="计提折旧产生"
	//s PLIST(23)=User
	s PLIST(24)=curDate
	s PLIST(25)=curTime
	//s PLIST(26)=User
	s PLIST(27)=curDate
	s PLIST(28)=curTime
	//s PLIST(29)=User
	s PLIST(30)=curDate
	s PLIST(31)=curTime
	s PLIST(32)=DepreType
	s PLIST(33)=AffixID
	
	s PLIST(34)=StoreLocDR  //$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",67)	///StoreLocDR
	s PLIST(35)=CommonFlag  //$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",82)	///CommonFlag共用标志
	//s PLIST(36)= 	///AllotType分摊方式
	s PLIST(37)=DepreTypeDR		///DepreTypeDR折旧类型(主折旧、修购基金、核算折旧等)
	s PLIST(38)=rate			///DepreRate折旧率
	s PLIST(39)=ManageLocDR  //$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",17)	///ManageLocDR管理部门
	
	
	//开始事务
	i UseTrans="Y"	{TSTART}
	//生成月度折旧
	&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
	i SQLCODE 
	{
		i UseTrans="Y"	{TROLLBACK}
		q -1004
	}
	s MonthDepreDR=$G(%ROWID)
	//更新折旧设置表中的上次折旧月份
	&SQL(update sqluser.DHC_EQDepreSet set DS_PreDepreMonth=:Month,DS_DepreTotal=:depreTotal,DS_DepreTotalFee=:depreTotalFee where DS_RowID=:depreSetID)
	i SQLCODE 
	{
		i UseTrans="Y"	{TROLLBACK}
		q "-1005"
	}
	s FTRowID=0
	s CADError=0
	k CAD
	;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
	;资金折旧信息,没有资金折旧信息的,则将折旧信息均记录在自有资金上
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	s NewFundsDepreInfo=FundsDepreInfo
	i NewFundsDepreInfo=""  d
	.s NewFundsDepreInfo="^"_SelfFundsType_"^"_depreFee_"^^"_originalFee
	s Len=$l(NewFundsDepreInfo,"#")
	;获取共用分摊设置ID
	s CostRowID=""	
	i CommonFlag="Y"  d
	.s CostRowID=$o(^DHCEQCostAllot(0,"EquipType",EquipID,1,0))
	;折旧分摊
	s CAD(2)=1
	s CAD(3)=MonthDepreDR
	
	for i=1:1:Len  q:(CADError'=0)  d
	.;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee_"^"_FundsFee
	.s FundsInfo=$p(NewFundsDepreInfo,"#",i)
	.s FTRowID=$p(FundsInfo,"^",2)
	.s FundsDepreFee=$p(FundsInfo,"^",3)
	.s FundsDepreTotalFee=$p(FundsInfo,"^",4)		//Add By DJ 2015-11-18
	.s FundsFee=$p(FundsInfo,"^",5)
	.//Modified By lmm 20200210 lmm0063 资金来源核算项目及功能分类
	.s FinaceItemID=$p(FundsInfo,"^",6)
	.s FunctionCatID=$p(FundsInfo,"^",7)
	.s RemainFundsDepreFee=FundsDepreFee
	.
	.s CAD(7)=FundsFee
	.s CAD(8)=FTRowID
	.s CAD(9)=FundsDepreTotalFee		//Add By DJ 2015-11-18
	.//Modified By lmm 20200310 lmm0063 资金来源核算项目及功能分类
	.s CAD(10)=FinaceItemID			
	.s CAD(11)=FunctionCatID	
	.s CostListCount=0
	.;为共用设备，且存在折旧分摊设置
	.i CostRowID'=""  d
	..s CostListID=0
	..f  s CostListID=$o(^DHCEQCostAllotList(0,"CostAllotDR",CostRowID,CostListID)) q:(CostListID="")||(CADError'=0)  d
	...s CostListCount=CostListCount+1
	...s CostType=$p($g(^DHCEQCostAllot(CostRowID)),"^",2)		//Add By DJ 2016-08-11 begin czf 2023-02-22
	...s CostValueCount=$p($g(^DHCEQCostAllot(CostRowID)),"^",16)	//分摊总和
	...s CostLoc=$p($g(^DHCEQCostAllotList(CostListID)),"^",2)
	...i CostType=0  d
	....s CostRate=$p($g(^DHCEQCostAllotList(CostListID)),"^",3)
	...e  d
	....s CostValue=$p($g(^DHCEQCostAllotList(CostListID)),"^",5)
	....s CostRate=$fn((CostValue/CostValueCount)*100,"",2)		//Add By DJ 2016-08-11 end
	...s CAD(4)=CostLoc
	...s CAD(5)=CostRate
	...;非最后一条的,直接按比例计算，否则取剩余资金折旧
	...i $o(^DHCEQCostAllotList(0,"CostAllotDR",CostRowID,CostListID))'=""  d
	....s CAD(6)=##Class(web.DHCEQCommon).FormatNumber((FundsDepreFee*(CostRate/100)),"",2)
	....s RemainFundsDepreFee=RemainFundsDepreFee-CAD(6)
	...e  d
	....s CAD(6)=RemainFundsDepreFee
	...q:CAD(6)'>0
	...&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	...i SQLCODE s CADError=1
	.;1.非共用设备 2无分摊设置 3.有分摊折旧设置却无分摊明细的
	.;以上3种直接计入各资金来源对应的折旧中
	.i CostListCount=0  d
	..s CAD(4)=StoreLocDR //$p(^DHCEQSnapShot(SnapID,"Equip",EquipID),"^",67)
	..s CAD(6)=##Class(web.DHCEQCommon).FormatNumber((FundsDepreFee),"",2)
	..&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	..i SQLCODE s CADError=1
		
	;"插入折旧分摊明细失败"
	i CADError'=0
	{
		i UseTrans="Y"	{TROLLBACK}
		q -1008
	}
	
	i (mainFlag="Y")
	{
		/****************************************************************/  //2009-08-10 党军 begin DJ0023
		s LI(2)=EquipID  //设备
		s LI(4)=UseLocDR  //$p($g(^DHCEQSnapShot(SnapID,"Equip",EquipID)),"^",19)   //原使用科室
		s LI(5)=ManageLocDR //$p($g(^DHCEQSnapShot(SnapID,"Equip",EquipID)),"^",17) //原管理科室
		s LI(6)=StoreLocDR  //$p($g(^DHCEQSnapShot(SnapID,"Equip",EquipID)),"^",67)  //原库房
		s LI(7)=originalFee  //原值
		s LI(8)=netFee  //原净值
		s LI(16)=curDate	//变动日期
		s LI(17)=curTime	//变动时间
		s LI(18)=depreFee //折旧费用 //2009-08-13 党军
		s LI(19)="P"	//生命周期类型
		s LI(20)=35	//来源类型
		s LI(21)=MonthDepreDR	//来源ID
		//s LI(27)=User	//更新人
		s LI(28)=curDate	//更新日期
		s LI(29)=curTime	//更新时间
		
		//更新设备的净值、累计折旧
		s hasdepreflag="N"
		s netFee=netFee-depreFee
		i netFee<netRemainFee s netFee=netRemainFee
		i netFee'>netRemainFee s hasdepreflag="Y"
		
		&SQL(update sqluser.DHC_EQEquip set EQ_NetFee=:netFee,EQ_DepreTotalFee=:depreTotalFee,EQ_HasDepreFlag=:hasdepreflag where EQ_RowID=:EquipID)
		i SQLCODE 
		{
			i UseTrans="Y"	{TROLLBACK}
			q "-1006"
		}
		/***************************************************************/
		s LI(9)=UseLocDR  //变动后使用科室
		s LI(10)=ManageLocDR //$p($g(^DHCEQSnapShot(SnapID,"Equip",LI(2))),"^",17) //变动后管理科室
		s LI(11)=StoreLocDR  //$p($g(^DHCEQSnapShot(SnapID,"Equip",LI(2))),"^",67)  //变动后库房
		s LI(12)=originalFee  //变动后原值
		s LI(13)=netFee  //变动后净值
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		i SQLCODE
		{
			i UseTrans="Y" {TRollBack}
			q "-1007"
		}
		
	}
	;modified by zy 2013-07-30 zy0108
	;有其他折旧类型的秀还DHCEQFundsDepreInfo中的累计折旧;
	;更新资金来源对应的累计折旧
	i FundsDepreInfo'=""
	{
		s Len=$l(FundsDepreInfo,"#")
		for i=1:1:Len
		{
			;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
			s FundsInfo=$p(FundsDepreInfo,"#",i)
			s FundsID=$p(FundsInfo,"^",1)
			s FundsDepreFee=$p(FundsInfo,"^",3)
			s FundsDepreTotalFee=$p(FundsInfo,"^",4)
			
			//modify by lmm 2018-01-31 LMM0033
			i DepreTypeDR'="1" d
			.s FundsDepreInfoID=$o(^DHCEQFundsDepreInfo(0,"DepreTypeFunds",DepreTypeDR,FundsID,""))
			.i FundsDepreInfoID'=""  d
			..&SQL(update sqluser.DHC_EQFundsDepreInfo set FD_DepreTotalFee=:FundsDepreTotalFee where FD_RowID=:FundsDepreInfoID)
			.e  d
			..&SQL(insert into sqluser.DHC_EQFundsDepreInfo set FD_FundsDR=:FundsID,FD_DepreTypeDR=:DepreTypeDR,FD_DepreTotalFee=:FundsDepreTotalFee)
			e  d
			.&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:FundsDepreTotalFee where F_RowID=:FundsID)
			i SQLCODE s errCount=errCount+1
		}
	}
	;Mozy0089	2012-10-17
	Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(10, MonthDepreDR)
	If SQLCODE
	{
		If UseTrans="Y" {TRollBack}
		Quit "-1007"
	}
	i UseTrans="Y" {TCOMMIT}
	;modify by lmm 2020-03-15 LMM0063
	q 0_"^"_MonthDepreDR
}

/// w ##Class(web.DHCEQMonthDepre).GetFundsAmountInfo(7674)
ClassMethod GetFundsAmountInfo(EquipID)
{
		s SQLCODE=0
		s changeaccountid=0
		f  s changeaccountid=$o(^DHCEQChangeAccount(0,"Equip",EquipID,changeaccountid)) q:changeaccountid=""  d
		.s Status=$Piece($Get(^DHCEQChangeAccount(changeaccountid)),"^",11)
		.q:(Status'=2)
		.s SQLCODE=1
		q SQLCODE
}

/// add by ZY0250 20200106   
/// 预折旧
/// 数据写在DHC_EQPreFunds,DHC_EQPreMonthDepre,DHC_EQPreCostAllotDetail
/// w ##class(web.DHCEQMonthDepre).GetPreMonthDepre("2020-12")
ClassMethod GetPreMonthDepre(DepreMonth As %Library.String = "", EquipTypeIDS As %Library.String = "", DepreTypeDR As %Library.String = "1")
{
	new (DepreMonth,EquipTypeIDS,DepreTypeDR)
	i DepreMonth'=##Class(web.DHCEQReport).GetReportMonthByDate(+$H) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1001,"预折旧月份与当前会计周期不一致,不能预折旧!")
	k ^DHCEQPreFunds
	k ^DHCEQPreMonthDepre
	k ^DHCEQPreCostAllotDetail
	//k ^DHCEQLog(0,"PreMonthDepreLog")
	
	//modified by zy 2013-06-04 zy0107
	//增加参数判断折旧是否包含预报废设备，直接取EQ_Hold8字段的值来判断
	s DepreFlag=##class(web.DHCEQCommon).GetSysInfo("990021")
	i EquipTypeIDS'="" s EquipTypeIDS=","_EquipTypeIDS_","
	
	s Times=$o(^DHCEQLog(0,"PreMonthDepreLog",DepreMonth,DepreTypeDR,""),-1)
	s Times=Times+1
	s ^DHCEQLog(0,"PreMonthDepreLog",DepreMonth,DepreTypeDR,Times,"Begin")=$H
	
	s errCount=0
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
	.q:##Class(web.DHCEQMonthDepre).CheckNeedDepre(rowid,EquipTypeIDS,DepreFlag,DepreTypeDR)=0
	.
	.;add by jdl 增加一种折旧设置,用于计算科室成本,仅在用时提取 2011-8-1 JDL0088
	.q:(DepreTypeDR=2)&&(+$p(^DHCEQEquip(rowid),"^",38)'=1)
	.
	.;计提折旧
	.s result=##Class(web.DHCEQMonthDepre).GenerateMonthDepre(rowid, DepreMonth, +$H, DepreTypeDR, "N", "0", "","Y")
	.
	.s node="Success"
	.i result'=0  d
	..s node="Error"
	..s errCount=errCount+1
	.s ^DHCEQTemp("PreMonthDepreLog",DepreMonth,node,rowid,DepreTypeDR)=$H_"^"_result
	.
	.s ^DHCEQLog(0,"PreMonthDepreLog",DepreMonth,DepreTypeDR,Times,node,rowid)=$H_"^"_result
	s ^DHCEQLog(0,"PreMonthDepreLog",DepreMonth,DepreTypeDR,Times,"End")=$H
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(errCount)
}

/// add by ZY0298 20220304 
/// 撤销最新一个月的折旧数据
/// DepreMonth：折旧月份格式（2006-06）
/// DepreTypeDR：1固定的系统主折旧  其他对应的折旧类型ID
/// 返回值：result:0 成功  	
/// w ##Class(web.DHCEQMonthDepre).CancelMonthDepre("2022-02")
ClassMethod CancelMonthDepre(DepreMonth, DepreTypeDR As %Library.String = "1")
{
	new (DepreMonth,EquipTypeIDS,DepreTypeDR)
	s SQLOCDE=0
	if DepreMonth="" q ""
	s node="Success"
	if '$Data(^DHCEQTemp("MonthDepreLog",DepreMonth,node)) q ""
	s EquipID=0
	f  s EquipID=$o(^DHCEQTemp("MonthDepreLog",DepreMonth,node,EquipID)) q:(EquipID="")||(SQLOCDE'=0)  d
	.q:'$Data(^DHCEQTemp("MonthDepreLog",DepreMonth,node,EquipID,DepreTypeDR))
	.s SQLOCDE=##Class(web.DHCEQMonthDepre).CancelOneEquipMonthDepre(EquipID,DepreMonth,DepreTypeDR)
	q SQLOCDE
}

/// add by ZY0298 20220304 
/// 撤销一个设备的折旧数据
/// EquipID：设备ID
/// DepreMonth：折旧月份格式（2006-06）
/// DepreTypeDR：1固定的系统主折旧  其他对应的折旧类型ID
/// 返回值：result:0 成功  	
/// w ##Class(web.DHCEQMonthDepre).CancelOneEquipMonthDepre(4414,"2022-02")
ClassMethod CancelOneEquipMonthDepre(EquipID, DepreMonth, DepreTypeDR As %Library.String = "1")
{
	new (EquipID,DepreMonth,DepreTypeDR)
	
	s PreMonth=##class(web.DHCEQReport).GetPreMonth(DepreMonth)
	s SQLOCDE=0
	//找到DepreMonth对应的折旧记录ID
	s FindMDRowID=""
	s MDRowID=0
	f  s MDRowID=$order(^DHCEQMonthDepre(0,"EquipMonth",EquipID,DepreMonth,MDRowID))  q:(MDRowID="")||(FindMDRowID'="")  d
	.s MonthDepreDataList=$g(^DHCEQMonthDepre(MDRowID))
	.s TDepreTypeDR= $p(MonthDepreDataList,"^",36)
	.q:DepreTypeDR'=TDepreTypeDR
	.s FindMDRowID=MDRowID
	i FindMDRowID="" q ""
	
	s MonthDepreDataList=$g(^DHCEQMonthDepre(FindMDRowID))
	s DepreSetID=$p(MonthDepreDataList,"^",2)
	s originalFee=$p(MonthDepreDataList,"^",5)
	s depreTotal=$p(MonthDepreDataList,"^",10)
	s depreTotalFee=$p(MonthDepreDataList,"^",12)
	s depreFee= $p(MonthDepreDataList,"^",14)
	s netFee= $p(MonthDepreDataList,"^",17)
	//计算折旧之前的折旧月数,净值,累计折旧
	s preDepreTotal=depreTotal-1
	s preNetFee=netFee+depreFee
	s preDepreTotalFee=depreTotalFee-depreFee
	//改回台帐
	&SQL(update sqluser.DHC_EQEquip set EQ_NetFee=:preNetFee,EQ_DepreTotalFee=:preDepreTotalFee,EQ_HasDepreFlag='N' where EQ_RowID=:EquipID)
	i SQLCODE'=0 q SQLCODE
	
	//改回资金来源表
	;&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:FundsDepreTotalFee where F_RowID=:FundsID)
	s RemainDepreFee=depreFee
	s FundsID=0
	f  s FundsID=$o(^DHCEQFunds(0,"Source",1,EquipID,FundsID)) q:(FundsID="")||(SQLCODE'=0)  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.;s FundsType=$p(^DHCEQFunds(FundsID),"^",2)
	.s FundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.s FundsDepreTotalFee=+$p($g(^DHCEQFunds(FundsID)),"^",13)
	.;s FinaceItemID=$p($g(^DHCEQFunds(FundsID)),"^",20)
	.;s FunctionCatID=$p($g(^DHCEQFunds(FundsID)),"^",21)
	.;最后一个资金来源时,取剩余折旧额,作为该资金来源的折旧金额
	.i $o(^DHCEQFunds(0,"Source",1,EquipID,FundsID))=""  d
	..s preFundsDepreFee=RemainDepreFee
	.e  d
	..s preFundsDepreFee=$Number(depreFee*(FundsFee/originalFee),2)
	.s RemainDepreFee=RemainDepreFee-preFundsDepreFee
	.s FundsDepreTotalFee=FundsDepreTotalFee-preFundsDepreFee
	.i FundsDepreTotalFee<0 s FundsDepreTotalFee=0
	.&SQL(update sqluser.DHC_EQFunds set F_DepreTotal=:FundsDepreTotalFee where F_RowID=:FundsID)
	i SQLCODE'=0 q SQLCODE
	
	//找到前一个月折旧记录ID
	s FindPreMDRowID=""
	s PreMDRowID=0
	f  s PreMDRowID=$order(^DHCEQMonthDepre(0,"EquipMonth",EquipID,PreMonth,PreMDRowID))  q:(PreMDRowID="")||(FindPreMDRowID'="")  d
	.s MonthDepreDataList=$g(^DHCEQMonthDepre(PreMDRowID))
	.s TDepreTypeDR= $p(MonthDepreDataList,"^",36)
	.q:DepreTypeDR'=TDepreTypeDR
	.s FindPreMDRowID=PreMDRowID
	s PreDepreFee=""
	i FindPreMDRowID'=""  d
	.s PreDepreFee=$p($g(^DHCEQMonthDepre(FindPreMDRowID)),"^",14)
	e  d
	.s PreMonth=""
	//改回折旧设置
	&SQL(update sqluser.DHC_EQDepreSet set DS_PreDepreMonth=:PreMonth,DS_DepreTotal=:preDepreTotal,DS_DepreTotalFee=:preDepreTotalFee where DS_RowID=:DepreSetID)
	i SQLCODE'=0 q SQLCODE
	
	//更新设备折旧信息表
	&SQL(update sqluser.DHC_EQDepreInfo set DI_PreDepreMonth=:PreMonth,DI_DepreTotal=:preDepreTotal,DI_PreDepreFee=:PreDepreFee where DI_EquipDR=:EquipID)
	i SQLCODE'=0 q SQLCODE
	
	;^DHCEQEquipShadow("RecordEQCurDepre")记录设备当前折旧月_"^"_折旧期数_"^"_当前月折旧额，用于台账检索取值
	s ^DHCEQEquipShadow("RecordEQCurDepre",EquipID)=PreMonth_"^"_preDepreTotal_"^"_PreDepreFee
	//删除记录:分摊，折旧记录，生命周期，
	&SQL(delete from SQLUSER.DHC_EQCostAllotDetail where CAD_SourceID=:FindMDRowID)	
	i SQLCODE'=0 q SQLCODE
	&SQL(delete from SQLUSER.DHC_EQMonthDepre where MD_RowID=:FindMDRowID)
	i SQLCODE'=0 q SQLCODE
	&sql(delete from SQLUSER.DHC_EQLifeInfo where LI_SourceType='35' and LI_SourceID=:FindMDRowID)
	i SQLCODE'=0 q SQLCODE
	&SQL(delete from SQLUSER.DHC_EQBillInfo where BI_SourceType='10' and BI_SourceID=:FindMDRowID)
	q SQLCODE
}

/// add by ZY0307 2760310增加折旧明细导入的功能
/// w ##Class(web.DHCEQTest).InsertMonthDepre()
ClassMethod InsertMonthDepre()
{
	s CADError=0
	s RowID=0
	f  s RowID=$o(^DHCEQImportMonthDepre(RowID))  q:(RowID="")||(CADError'=0)  d
	.s DataList=$g(^DHCEQImportMonthDepre(RowID))
	.s EquipNo=$p(DataList,"^",1)
	.s EquipID=""
	.&SQL(select EQ_RowID Into :EquipID from  SQLUSER.DHC_EQEquip where EQ_OldNo=:EquipNo and EQ_InvalidFlag<>'Y')
	.q:EquipID=""
	.s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p(DataList,"^",2),"",2)
	.s LimitYearNum=$p(DataList,"^",3)
	.q:LimitYearNum=0
	.s LimitYearNum=LimitYearNum/12
	.s DepreMonthNum=$p(DataList,"^",4)
	.s DepreMonthNum=##Class(web.DHCEQCommon).FormatNumber(DepreMonthNum,"",0)
	.s MonthStr=$p(DataList,"^",5)
	.s DepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p(DataList,"^",6),"",2)
	.q:$p(DataList,"^",7)=0
	.s DepreFee=##Class(web.DHCEQCommon).FormatNumber($p(DataList,"^",7),"",2)
	.s NetFee=##Class(web.DHCEQCommon).FormatNumber($p(DataList,"^",8),"",2)
	.s DepreData=$p(DataList,"^",9)
	.s DepreData=##class(web.DHCEQCommon).TransValueFromPage(DepreData,"date")
	.s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(DepreData)
	.
	.s DepreTypeDR=1
	.s DepreSetInfo=##Class(web.DHCEQMonthDepre).GetDepreSetInfo(EquipID, DepreData, DepreTypeDR,"0")
	.s FundsDepreInfo=$p(DepreSetInfo,"&",2)
	.s DepreSetInfo=$p(DepreSetInfo,"&",1)
	.
	.q:DepreSetInfo<0
	.
	.s depreSetID=$p(DepreSetInfo,"^",2)
	.s mainFlag="N"
	.i DepreTypeDR =1 s mainFlag="Y"
	.q:depreSetID=""
	.
	.s depreMethodType=$p(DepreSetInfo,"^",5)
	.s depreMethodDR=$p(DepreSetInfo,"^",6)
	.q:depreMethodDR=3
	.s years=$p(DepreSetInfo,"^",7)
	.s rate=$p(DepreSetInfo,"^",8)
	.s depreTotal=$p(DepreSetInfo,"^",9)
	.s depreTotalFee=$p(DepreSetInfo,"^",10)		//累计折旧总费用
	.s depreFee=$p(DepreSetInfo,"^",3)
	.	
	.s curDate=DepreData
	.s curTime=$P($H,",",2)
	.
	.s PLIST(2)=EquipID
	.s PLIST(3)=depreSetID
	.s PLIST(4)=mainFlag
	.s PLIST(5)=depreMethodDR
	.s PLIST(6)=OriginalFee
	.s PLIST(7)=MonthStr
	.s PLIST(10)=LimitYearNum
	.s PLIST(11)=DepreMonthNum //总折旧月份
	.s PLIST(13)=DepreTotalFee
	.s PLIST(15)=DepreFee
	.s PLIST(18)=NetFee
	.
	.s PLIST(19)=0 //设备净残值
	.s PLIST(20)="N"
	.s PLIST(21)="1" //状态
	.;s PLIST(22)=$p($g(^DHCEQDepreSet(depreSetID)),"^",8)
	.s PLIST(24)=curDate
	.s PLIST(25)=curTime
	.//s PLIST(26)=User
	.s PLIST(27)=curDate
	.s PLIST(28)=curTime
	.//s PLIST(29)=User
	.s PLIST(30)=curDate
	.s PLIST(31)=curTime
	.s PLIST(32)=0
	.;s PLIST(33)=AffixID
	.
	.s PLIST(34)=$p(^DHCEQEquip(EquipID),"^",67)	///StoreLocDR
	.s PLIST(35)=$p(^DHCEQEquip(EquipID),"^",82)	///CommonFlag共用标志
	.//s PLIST(36)= 	///AllotType分摊方式
	.s PLIST(37)=DepreTypeDR		///DepreTypeDR折旧类型(主折旧、修购基金、核算折旧等)
	.;s PLIST(38)=rate			///DepreRate折旧率
	.s PLIST(39)=$p(^DHCEQEquip(EquipID),"^",17)	///ManageLocDR管理部门
	.//add by ZY0271 20210914
	.;s PLIST(40)=""	//Hold1
	.;s PLIST(42)=""	//Hold2
	.;s PLIST(43)=""	//Hold3
	.;s PLIST(44)=$p($g(^DHCEQDepreSet(depreSetID)),"^",26)	//Hold4
	.;s PLIST(45)=""	//Hold5
	.;b ////insert5
	.&SQL(Insert Into SQLUSER.DHC_EQMonthDepre Values :PLIST())
	.s CADError=SQLCODE
	.s MonthDepreDR=$G(%ROWID)
	.q:MonthDepreDR=""
	.q:CADError'=0
	.k CAD
	.s CAD(2)=1
	.s CAD(3)=MonthDepreDR
	.;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee
	.;资金折旧信息,没有资金折旧信息的,则将折旧信息均记录在自有资金上
	.s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	.//Modified By ZY0250 资金来源核算项目及功能分类
	.s UseFinaceItemType=+##class(web.DHCEQCommon).GetSysInfo("990076")
	.s SelfFinaceItemFlag=##class(web.DHCEQCommon).GetSysInfo("990070")
	.s SelfFunctionCatFlag=##class(web.DHCEQCommon).GetSysInfo("990071")
	.s NewFundsDepreInfo=FundsDepreInfo
	.i NewFundsDepreInfo=""  d
	..s NewFundsDepreInfo="^"_SelfFundsType_"^"_DepreFee_"^^"_OriginalFee_"^"_SelfFinaceItemFlag_"^"_SelfFunctionCatFlag
	.s Len=$l(NewFundsDepreInfo,"#")
	.for i=1:1:Len  q:(CADError'=0)  d
	..;FundsID_"^"_FundsType_"^"_FundsDepreFee_"^"_FundsDepreTotalFee_"^"_FundsFee
	..s FundsInfo=$p(NewFundsDepreInfo,"#",i)
	..s FTRowID=$p(FundsInfo,"^",2)
	..;s FundsDepreFee=$p(FundsInfo,"^",3)
	..;s FundsDepreTotalFee=$p(FundsInfo,"^",4)		//Add By DJ 2015-11-18
	..;s FundsFee=$p(FundsInfo,"^",5)
	..//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	..s FinaceItemID=$p(FundsInfo,"^",6)
	..s FunctionCatID=$p(FundsInfo,"^",7)
	..
	..s CAD(4)=$p(^DHCEQEquip(EquipID),"^",67)
	..;s CAD(5)=CostRate
	..s CAD(6)=DepreFee
	..s CAD(7)=OriginalFee
	..s CAD(8)=FTRowID
	..s CAD(9)=DepreTotalFee		//Add By DJ 2015-11-18
	..//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	..s CAD(10)=FinaceItemID			//add by zy20190917
	..s CAD(11)=FunctionCatID		//add by zy20190917
	..
	..q:CAD(6)'>0
	..;b ///:CAD
	..&SQL(Insert Into SQLUSER.DHC_EQCostAllotDetail Values :CAD())
	..s CADError=SQLCODE
	
	q CADError
}

}
