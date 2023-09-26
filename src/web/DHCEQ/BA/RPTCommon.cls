/// Creator:add by czf
/// CreateDate:2021-08-31
/// Descrition:通用效益分析方法
Class web.DHCEQ.BA.RPTCommon Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取一个设备一段时间内的使用数据
/// add by zy 2020-02-18
/// w ##Class(web.DHCEQ.BA.RPTCommon).EquipUseContext()
ClassMethod EquipUseContext(EquipDR As %String = "", Type As %String = "", StartDate As %String = "", EndDate As %String = "")
{
	new start,end,Year,Month,MonthDate,rowid,datalist,value
	i EquipDR=""  q ""
	i $ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3) q 0
	i StartDate=""  d
	.s start=0
	e  d
	.s start=$ZDH(StartDate_"-01",3)
	s end=$ZDH(EndDate_"-01",3)
	s (Year,value)=0
 	f  s Year=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year)) q:Year=""  d
 	.s Month=0
 	.f  s Month=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year,Month)) q:Month=""  d
	..s MonthDate=$ZDH(Year_"-"_Month_"-01",3)
	..q:(start>MonthDate)||(end<MonthDate)
 	..s rowid=0
 	..f  s rowid=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year,Month,rowid)) q:rowid=""  d
 	...s datalist=$g(^DHCEQUseContext(rowid))
 	...q:$p(datalist,"^",44)="Y"
 	...i Type="InCome" d
 	....s value=value+$p(datalist,"^",19)
 	...e  i Type="Workload"  d
 	....s value=value+$p(datalist,"^",21)
 	
 	q value
}

/// 获取一个设备一段时间内的消耗资源费
/// add by zy 2020-02-18
/// w ##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(23223,"","2019-07","2019-12","web.DHCEQ.BA.RPTEchart_GetEquipBenefit",72912,12214)
ClassMethod EquipResourceFee(EquipDR As %String = "", ResourceType As %String = "", StartDate As %String = "", EndDate As %String = "", nodestr As %String = "", Job As %String = "", CurUserID As %String = "")
{
	new start,end,Year,Month,MonthDate,rowid,datalist
	i EquipDR=""  q ""
	i $ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3) q 0
	i StartDate=""  d
	.s start=0
	e  d
	.s start=$ZDH(StartDate_"-01",3)
	s end=$ZDH(EndDate_"-01",3)
	s Date=+$h
	i Job="" s Job=$J
	
	i nodestr'="" d
	.k ^TempDHCEQ(nodestr,"EQResource")
	.i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	s (Year,value)=0
	f  s Year=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year))  q:(Year="")  d
	.s Month=0
	.f  s Month=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year,Month)) q:Month=""  d
	..s MonthDate=$ZDH(Year_"-"_Month_"-01",3)
	..q:(start>MonthDate)||(end<MonthDate)
	..s rowid=0
	..f  s rowid=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year,Month,rowid))  q:rowid=""  d
	...s Find=0
	...;s UseLoc=$p($g(^DHCEQUsedResource(rowid)),"^",10)
	...;i UseLoc'=""  d
	...;.s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc,CTLocID,CurGroupID)
	...;q:Find'=0
	...s RSTDR=$p($g(^DHCEQUsedResource(rowid)),"^",5)
	...s RSTCode=""							//czf 2021-09-19 begin
	...i RSTDR'="" s RSTCode=$p($g(^DHCEQCCode("DHCEQCResourceType",RSTDR)),"^",1)
	...i nodestr'="" d
	....i RSTCode="" s RSTCode="other"		//其他
	....s EQResourceValue=$p($g(^DHCEQUsedResource(rowid)),"^",9)
	....i $d(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,RSTCode)) d		//按设备项汇总每月效益分析信息
	.....s EQResourceValue=$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,RSTCode))+EQResourceValue
	....s ^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,RSTCode)=EQResourceValue		//czf 2021-09-19 end
	...i (ResourceType'="")&&((RSTCode="")||($e(RSTCode,1,$l(ResourceType))'=ResourceType)) s Find=1
	...q:Find'=0
	...s value=value+$p($g(^DHCEQUsedResource(rowid)),"^",9)
	q value
}

/// modified by ZY0279 20210907 从旧类移过来,同时增加业务次数的输出
/// Modified by JDL JDL0079 优化效率 2011-04-19
/// 根据声明周期信息,获取支出费用
/// 入参：EquipDR	要获取费用的设备
/// 		 StartDate	YYYY-MM
/// 		 EndDate	YYYY-MM
/// 		 SourceType	费用类型  31:维修、32保养、33检查、35折旧
/// 		 QXType		权限类型,和CTLocID，CurGroupID一起控制可访问范围
/// 		 CTLocID	当前科室
/// 		 CurGroupID	当前安全组
/// 	  	MaintTypeDR  =4  巡检, MaintTypeDR=5 计量	
/// 	返回：该设备该日期段支出该项费用^业务次数
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo()
ClassMethod GetOutFeeByLifeInfo(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", SourceType As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "", MaintType As %String = "")
{
	n Start,End,LIRowID,Find,ToStoreLoc,Amount,Month,Tims
	i EquipDR=""  q ""
	i SourceType="" q ""
	s Start=##Class(web.DHCEQCommon).MonthFirstDate(StartDate)
	s End=##Class(web.DHCEQCommon).MonthLastDate(EndDate)
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	s (Amount,Tims)=0
	//add by zx 2015-10-21 判断机组,取机组整体折旧等费用 Bug ZX0047
	s EquipGroupID=##class(web.DHCEQBenefitAnalyReport).CheckGroupEquip(EquipDR)  //27834
	;^DHCEQLifeInfo(0,"EquipSourceDate",{LI_EquipDR},{LI_SourceType},{LI_ChangeDate},{LI_RowID})
	
	i EquipGroupID=0
	{
		s rate=1
		///modified by ZY0296 20220309
		//s Start=StartDate-1
		d SumAmount
	}
	else
	{
		s GroupListID=0
		f  s GroupListID=$o(^DHCEQGroupList(0,"Group",EquipGroupID,GroupListID)) q:GroupListID=""  d
		.s EquipDR=$p($g(^DHCEQGroupList(GroupListID)),"^",2)
		.s rate=$p($g(^DHCEQGroupList(GroupListID)),"^",9)
		.;s Start=StartDate-1	//modified by ZY0296 20220309
		.d SumAmount
	}
	
	//add by zy 2014-09-15  ZY0117
	//折旧费用这块,如果生命周期中取不到费用,直接到折旧明细中取数据.  （廊坊管道局折旧是导入的，写在折旧明细表中。）
	//modified by zy 2014-9-18
	i (Amount=0)&(SourceType="35")
	{
		s Start=##Class(web.DHCEQCommon).MonthFirstDate(StartDate)
		s Amount=0
		s Month=0
		f  s Month=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,Month))  q:Month=""  d
		.s CurDate=$ZDH(Month_"-01",3)
		.q:(Start>CurDate)||(End<CurDate)
		.s MonthDepreID=0
		.f  s MonthDepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipDR,Month,MonthDepreID))  q:MonthDepreID=""  d
		..s MonthDepre=$g(^DHCEQMonthDepre(MonthDepreID))
		..q:$p(MonthDepre,"^",3)'="Y"
		..s MDStatus=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",20)	//DJ0136
		..q:MDStatus="3"
		..s Amount=Amount+$p(MonthDepre,"^",14)	;Fee
		..s Tims=Tims+1
	}
	q Amount_"^"_Tims
	
SumAmount
	///modified by ZY0296 20220309
	//s End=EndDate
	s Start=Start-1
	;^DHCEQLifeInfo(0,"EquipSourceDate",{LI_EquipDR},{LI_SourceType},{LI_ChangeDate},{LI_RowID})
	f  s Start=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start)) q:(Start="")||(Start>End)  d
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EquipDR,SourceType,Start,LIRowID))  q:LIRowID=""  d
	..s Find=0 //2010-10-29 DJ begin
	..s ToStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	..i ToStoreLoc'=""  d
	...i CTLocID'="" s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,ToStoreLoc,CTLocID,CurGroupID)	//czf 2021-01-28 执行任务时不需要过滤当前科室权限 1754433
	..q:Find'=0 //2010-10-29 DJ end
	..q:(MaintType=4)&&($p($g(^DHCEQLifeInfo(LIRowID)),"^",13)="巡检")
	..q:(MaintType=5)&&($p($g(^DHCEQLifeInfo(LIRowID)),"^",13)="计量")
	..s Amount=Amount+($p($g(^DHCEQLifeInfo(LIRowID)),"^",17)*rate)	;Fee
	..s Tims=Tims+1
	q
}

/// w ##Class(web.DHCEQ.BA.RPTCommon).GetBAEquipList("","RunStat^65988,62871^1532")
ClassMethod GetBAEquipList(vData As %String = "", NodeStr As %String = "")
{
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set EquipDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipDR")
 	Set ItemDR=##class(web.DHCEQCommon).GetDataByName(vData,"ItemDR")
 	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set EquipCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
 	Set EquipName=##class(web.DHCEQCommon).GetDataByName(vData,"EquipName")
 	Set Model=##class(web.DHCEQCommon).GetDataByName(vData,"Model")
 	Set ManuFactory=##class(web.DHCEQCommon).GetDataByName(vData,"ManuFactory")
 	
	s Node=$p(NodeStr,"^",1)
	s CurTime=$p(NodeStr,"^",2)
	s Job=$p(NodeStr,"^",3)
	
 	if EquipDR'=""
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(0,"Equip",EquipDR,rowid)) q:rowid=""  d
	 	.d BAEquipList
	}
 	else
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(rowid)) q:rowid=""  d
	 	.d BAEquipList
	}
	q 0
BAEquipList 	
 	s BenefitEquipListData=$g(^DHCEQBenefitEquipList(rowid))
 	s TRowID=rowid
 	s TEquipDR=$p(BenefitEquipListData,"^",1)
 	s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)		             //设备名称
	q:(EquipName'="")&(TEquipName'[EquipName)
 	s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)		                 //规格型号
 	s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	q:(Model'="")&(TModel'[Model)
	s TEquiCatDR = $p($g(^DHCEQEquip(TEquipDR)),"^",4)
	q:(EquipCatDR'="")&&(EquipCatDR'=TEquiCatDR)&&(##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,TEquiCatDR)=0)
 	s TEquiCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquiCatDR)
	
 	s TUseLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",67)
 	q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
 	s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
 	s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	q:(ManuFactory'="")&(TManuFactory'[ManuFactory)
 	s ^TempDHCEQ(Node,CurTime,Job,TRowID)=TEquipDR
}

/// Creator:add by czf 2021-08-31
/// Descrition:将效益分析数据存在临时global中，^TempDHCEQ(nodestr,"BenefitEQSummary",Date,Job,CurUserID)记录设备汇总效益信息
/// Input：
/// 	nodestr:临时global节点名，不同界面应用不用的nodestr
/// 	Job:
/// 	StartDate:开始月份
/// 	EndDate:结束月份
/// 	PeriodType:期间类型(YearFlag:年度 HalfYear:半年度 Quarter:季度 MonthFlag:月度)
/// Output:
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetBenefitAnalyInfo("3188","2020-01","2020-08","78","202","85")
ClassMethod GetBenefitAnalyInfo(nodestr, Job As %String = "", StartDate As %String = "", EndDate As %String = "", CurUserID As %String = "", CurLocID As %String = "", CurGroupID As %String = "", PeriodType As %String = "", QXType As %String = "")
{
	i nodestr="" Quit ""
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	
	s Date=+$h
	i Job="" s Job=$J
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurUserID="" Quit ""
	i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
	
	i (StartDate="")||(EndDate="") Quit ""
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) Quit ""
	
	s (FactualWorkLoadAmount,WorkLoadAmount,InComeAmount,ConsumableFeeAmount,PersonFeeAmount,WaterFeeAmount,ElectricFeeAmount,WEFeeAmount,HouseFeeAmount,MaintFeeAmount,MaintainFeeAmount,InSpectFeeAmount,MaintenanceFeeAmount,DepreFeeAmount,OutFeeAmount,InComeAmount,NumAmount,OriginalFeeAmount)=0
 	s (DaysNum,OtherIncomeAmount,OtherIncomeAmount,OutIncomeAmount,InIncomeAmount,EmergencyAmount,NewBornAmount,HealthAmount,PerDayInCome,PerDayOutFee,InOutRate,CheckPerson,ExposureNum,PerDayCheckPerson)=0
 	s (ServeConsumeAmount,ConsumeMaterialAmount,TrainFeeAmount,MeasureFeeAmount,QualityControlAmount)=0		//czf 2021-11-04
 	s DaysNum=##Class(web.DHCEQCommon).GetMonthDateNum(StartDate,EndDate,"1")
 	
 	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
	.s StoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	.q:StoreLocDR=""
	.q:##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR,CurLocID,CurGroupID)'=0
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s EQItemDR=$p($g(^DHCEQEquip(rowid)),"^",7)
	.q:EQItemDR=""
	.s TIsStandard=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQItemDR)),"^",21)	//czf 2021-10-13 begin 标准设备项
	.i TIsStandard="N"  d
	..s MIEQItemDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQItemDR)),"^",22)
	..i MIEQItemDR'="" s EQItemDR=MIEQItemDR	//czf 2021-10-13 end
	.s EQStatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	.q:EQStatCatDR=""
	.s EquipCatDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	.q:EquipCatDR=""
	.s EQOriginalFee=$fn($p($g(^DHCEQEquip(rowid)),"^",27),"",2)
	.s EQNum=1
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.RPTCommon).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..s TWorkLoadPerMonth=+$p($g(^DHCEQEquip(rowid)),"^",84)
	..s TStandUseRate=$fn(+$p($g(^DHCEQEquip(rowid)),"^",92),"",2)
	..s TUseRate=0
	..i TWorkLoadPerMonth'=0  d
	...s TUseRate=$fn((TFactualWorkLoad/TWorkLoadPerMonth)*100,"",2)
	..s TIncomeInfo=##Class(web.DHCEQ.BA.RPTCommon).AllInCome(rowid,TMonth,TMonth,"",CurLocID,CurGroupID)
	..s TInCome=+$p(TIncomeInfo,"^",1)		;总收入
	..s TOtherIncome=+$p(TIncomeInfo,"^",2)	;其他收入
	..s TOutIncome=+$p(TIncomeInfo,"^",3)	;门诊收入
	..s TInIncome=+$p(TIncomeInfo,"^",4)		;住院收入
	..s TEmergencyIncome=+$p(TIncomeInfo,"^",5)	;急诊收入
	..s TNewBornIncome=+$p(TIncomeInfo,"^",6)	;
	..s THealthIncome=+$p(TIncomeInfo,"^",7)	;体检收入
	..s TCheckPerson=+$p(TIncomeInfo,"^",8)		;人次
	..s TExposureNum=+$p(TIncomeInfo,"^",9)		;曝光次数
	..s TPositiveNum=+$p(TIncomeInfo,"^",10)	;阳性例数
	..s TServeConsumeFee=+$p(TIncomeInfo,"^",11)	;服务使用消耗
	..i DaysNum=0 s TPerDayIncome=0
	..e  s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/DaysNum,"",2)	;日均收入
	..;s TInCome=+##Class(web.DHCEQ.BA.RPTCommon).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..s TResourceInfo=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"",TMonth,TMonth,nodestr,Job,CurUserID)
	..s TConsumeMaterialFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"13"))	//消耗性材料
	..s TConsumableFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"14"))	//+..EquipResourceFee(rowid,"14",TMonth,TMonth)	//资源消耗耗材费
	..s TSumConsumableFee=TConsumableFee+TConsumeMaterialFee+TServeConsumeFee			//耗材费=资源消耗耗材+消耗性材料+服务项消耗
	..s TPersonFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"01"))		//+..EquipResourceFee(rowid,"01",TMonth,TMonth)	//人员工资
	..s TTrainFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"02"))			//培训费
	..s TPersonnelCost=TPersonFee+TTrainFee		//人员经费
	..s TWaterFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"03"))			//+..EquipResourceFee(rowid,"03",TMonth,TMonth)	//水费
	..s TElectricFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"04"))		//+..EquipResourceFee(rowid,"04",TMonth,TMonth)	//电费
	..s TWEFee=TWaterFee+TElectricFee	//水电
	..s THouseFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"06"))			//+..EquipResourceFee(rowid,"06",TMonth,TMonth)		//房屋折旧
	..s TMaintFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"07"))			//+..EquipResourceFee(rowid,"07",TMonth,TMonth)		//维修
	..i TMaintFee=0 s TMaintFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"31", "",CurLocID,CurGroupID)
	..s TMaintainFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"09"))		//+..EquipResourceFee(rowid,"09",TMonth,TMonth)	//保养
	..i TMaintainFee=0 s TMaintainFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"32", "",CurLocID,CurGroupID)
	..s TInSpectFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"10"))		//+..EquipResourceFee(rowid,"10",TMonth,TMonth)	//检查
	..i TInSpectFee=0 s TInSpectFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33", "",CurLocID,CurGroupID,"4")
	..s TMeasureFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"11"))		//计量费
	..i TMeasureFee=0 s TMeasureFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33", "",CurLocID,CurGroupID,"5")
	..s TQualityControlFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"12"))	//质控费
	..s TMaintenanceFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"08"))	//维保费	
	..s TSumMaintenanceFee=TMaintenanceFee+TMaintFee+TMaintainFee+TInSpectFee+TMeasureFee+TQualityControlFee	//总维保费=资源消耗维保费+维修费+保养+计量+检查+质控费
	..s TDepreFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,CurUserID,"05"))			//+..EquipResourceFee(rowid,"05",TMonth,TMonth)
	..i TDepreFee=0 s TDepreFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"35", "",CurLocID,CurGroupID)
	..s TEquipResourceFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"",TMonth,TMonth,"",Job,CurUserID)	//总资源费
	..s TOutFee=TSumConsumableFee+TPersonnelCost+TWEFee+THouseFee+TSumMaintenanceFee+TDepreFee	//总支出=总耗材费+人员经费+水电+房屋折旧+维保费+折旧费
	..i DaysNum=0 s TPerDayOutFee=0
	..e  s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/DaysNum,"",2)	;日均支出
	..;s (TConsumableRate,TPersonRate,TWERate,TMaintRate,TMaintainRate,TInSpectRate,TDepreRate,THouseRate,TInOutRate,TPositiveRate)=0
	..;i TOutFee'=0  d
	...;s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee/TOutFee,"",2)
	...;s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonFee/TOutFee,"",2)
	...;s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWEFee/TOutFee,"",2)
	...;s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintFee/TOutFee,"",2)
	...;s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee/TOutFee,"",2)
	...;s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee/TOutFee,"",2)
	...;s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreFee/TOutFee,"",2)
	...;s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseFee/TOutFee,"",2)
	...;s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)		//收支比
	..;i +TCheckPerson'=0 s TPositiveRate=##Class(web.DHCEQCommon).FormatNumber(TPositiveNum/TCheckPerson,"",2)	;阳性率
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	..s BenefitList=TFactualWorkLoad_"^"_TWorkLoadPerMonth_"^"_TInCome_"^"_TConsumableFee_"^"_TPersonFee_"^"_TWEFee_"^"_THouseFee_"^"_TMaintFee_"^"_TMaintainFee_"^"_TInSpectFee_"^"_TMaintenanceFee_"^"_TDepreFee_"^"_TOutFee_"^"_EQOriginalFee_"^"_EQNum_"^"_TWaterFee_"^"_TElectricFee_"^"_TOtherIncome_"^"_TOutIncome_"^"_TInIncome_"^"_TEmergencyIncome_"^"_TNewBornIncome_"^"_THealthIncome_"^"_TCheckPerson_"^"_TExposureNum_"^"_TPositiveNum_"^"_TServeConsumeFee_"^"_TConsumeMaterialFee_"^"_TTrainFee_"^"_TMeasureFee_"^"_TQualityControlFee
	..i $d(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUserID,EQItemDR,TMonth)) d		//按设备项汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUserID,EQItemDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUserID,EQItemDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUserID,EQItemDR,TMonth)=BenefitList
	..i $d(^TempDHCEQ(nodestr,"EquipBenefit",Date,Job,CurUserID,rowid,TMonth)) d		//按设备汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"EquipBenefit",Date,Job,CurUserID,rowid,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"EquipBenefit",Date,Job,CurUserID,rowid,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"EquipBenefit",Date,Job,CurUserID,rowid,TMonth)=BenefitList
	..i $d(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUserID,StoreLocDR,TMonth)) d		//按科室汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUserID,StoreLocDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUserID,StoreLocDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUserID,StoreLocDR,TMonth)=BenefitList
	..i $d(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUserID,EQStatCatDR,TMonth)) d		//按设备类型汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUserID,EQStatCatDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUserID,EQStatCatDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUserID,EQStatCatDR,TMonth)=BenefitList
	..i $d(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUserID,EquipCatDR,TMonth)) d		//按设备分类汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUserID,EquipCatDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUserID,EquipCatDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUserID,EquipCatDR,TMonth)=BenefitList
	..s FactualWorkLoadAmount=FactualWorkLoadAmount+TFactualWorkLoad
	..s WorkLoadAmount=WorkLoadAmount+TWorkLoadPerMonth
	..s InComeAmount=InComeAmount+TInCome
	..s OtherIncomeAmount=OtherIncomeAmount+TOtherIncome
	..s OutIncomeAmount=OutIncomeAmount+TOutIncome
	..s InIncomeAmount=InIncomeAmount+TInIncome
	..s EmergencyAmount=EmergencyAmount+TEmergencyIncome
	..s NewBornAmount=NewBornAmount+TNewBornIncome
	..s HealthAmount=HealthAmount+THealthIncome
	..s CheckPerson=CheckPerson+TCheckPerson
	..s ExposureNum=ExposureNum+TExposureNum
	..s ServeConsumeAmount=ServeConsumeAmount+TServeConsumeFee	//服务项消耗
	..s ConsumeMaterialAmount=ConsumeMaterialAmount+TConsumeMaterialFee	//消耗性材料
	..s ConsumableFeeAmount=ConsumableFeeAmount+TConsumableFee	//资源消耗
	..s PersonFeeAmount=PersonFeeAmount+TPersonFee				//人工工资
	..s TrainFeeAmount=TrainFeeAmount+TTrainFee					//培训费
	..s WaterFeeAmount=WaterFeeAmount+TWaterFee
	..s ElectricFeeAmount=ElectricFeeAmount+TElectricFee
	..s WEFeeAmount=WEFeeAmount+TWEFee				//水电
	..s HouseFeeAmount=HouseFeeAmount+THouseFee		//房屋折旧
	..s MaintFeeAmount=MaintFeeAmount+TMaintFee		//维修
	..s MaintainFeeAmount=MaintainFeeAmount+TMaintainFee	//保养
	..s InSpectFeeAmount=InSpectFeeAmount+TInSpectFee		//巡检
	..s MeasureFeeAmount=MeasureFeeAmount+TMeasureFee		//计量
	..s QualityControlAmount=QualityControlAmount+TQualityControlFee	//质控费
	..s MaintenanceFeeAmount=MaintenanceFeeAmount+TMaintenanceFee		//维保费
	..s DepreFeeAmount=DepreFeeAmount+TDepreFee
	..s OutFeeAmount=OutFeeAmount+TOutFee
	.s NumAmount=NumAmount+1
	.s OriginalFeeAmount=OriginalFeeAmount+EQOriginalFee
	
	;效益分析汇总信息
	s OriginalFeeAmount=##Class(web.DHCEQCommon).FormatNumber(OriginalFeeAmount,"",2)
	i DaysNum'=0 d
	.s PerDayInCome=##Class(web.DHCEQCommon).FormatNumber(InComeAmount/DaysNum,"",2)	//日均收入
	.s PerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(OutFeeAmount/DaysNum,"",2)	//日均支出
	.s PerDayCheckPerson=##Class(web.DHCEQCommon).FormatNumber(CheckPerson/DaysNum,"",2)	//日均服务人次
	i OutFeeAmount'=0 s InOutRate=##Class(web.DHCEQCommon).FormatNumber(InComeAmount/OutFeeAmount,"",2)	//收支比
	
	;同比、环比
	s (InComeChainRatio,OutFeeChainRatio,InComeYearOnYearRate,OutFeeYearOnYearRate)="--"
	s (LastSPeriod,LastEPeriod)=""
	i (PeriodType="YearFlag")		//年度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,EndDate)
	}
	elseif (PeriodType="HalfYear")	//半年度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-6,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-6,EndDate)
	}
	elseif (PeriodType="Quarter")	//季度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-3,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-3,EndDate)
	}
	elseif (PeriodType="MonthFlag")	//月度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,EndDate)
	}
	i PeriodType'=""
	{
		;环比
		s LastRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastSPeriod,LastEPeriod,"","","","","")
		s LastInCome=$p(LastRtnStr,"^",3)
		s LastOutFee=$p(LastRtnStr,"^",13)
		i +LastInCome'=0 s InComeChainRatio=##Class(web.DHCEQCommon).FormatNumber(((InComeAmount-LastInCome)/$ZABS(LastInCome)*100),"",2)_"%"
		i +LastOutFee'=0 s OutFeeChainRatio=##Class(web.DHCEQCommon).FormatNumber(((OutFeeAmount-LastOutFee)/$ZABS(LastOutFee)*100),"",2)_"%"
		
		;同比
		s LastYOYSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,StartDate)
		s LastYOYEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,EndDate)
		s LastYOYRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastYOYSPeriod,LastYOYEPeriod,"","","","","")
		s LastYOYInCome=$p(LastYOYRtnStr,"^",3)
		s LastYOYOutFee=$p(LastYOYRtnStr,"^",13)
		i +LastYOYInCome'=0 s InComeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(((InComeAmount-LastYOYInCome)/$ZABS(LastYOYInCome)*100),"",2)_"%"
		i +LastYOYOutFee'=0 s OutFeeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(((OutFeeAmount-LastYOYOutFee)/$ZABS(LastYOYOutFee)*100),"",2)_"%"
	}
	s InComeAmount=##Class(web.DHCEQCommon).FormatNumber(InComeAmount,"",2)
	s OutFeeAmount=##Class(web.DHCEQCommon).FormatNumber(OutFeeAmount,"",2)
	
	//																	1						2				3					4						5					6				7					8					9					10						11						12				13					14				15				16					17						18					19					20					21					22				23				24				25					26			27				28					29					30					31							32						33						34					35							36				37						38
	s ^TempDHCEQ(nodestr,"BenefitEQSummary",Date,Job,CurUserID)=FactualWorkLoadAmount_"^"_WorkLoadAmount_"^"_InComeAmount_"^"_ConsumableFeeAmount_"^"_PersonFeeAmount_"^"_WEFeeAmount_"^"_HouseFeeAmount_"^"_MaintFeeAmount_"^"_MaintainFeeAmount_"^"_InSpectFeeAmount_"^"_MaintenanceFeeAmount_"^"_DepreFeeAmount_"^"_OutFeeAmount_"^"_OriginalFeeAmount_"^"_NumAmount_"^"_WaterFeeAmount_"^"_ElectricFeeAmount_"^"_OtherIncomeAmount_"^"_OutIncomeAmount_"^"_InIncomeAmount_"^"_EmergencyAmount_"^"_NewBornAmount_"^"_HealthAmount_"^"_PerDayInCome_"^"_PerDayOutFee_"^"_InOutRate_"^"_CheckPerson_"^"_ExposureNum_"^"_InComeChainRatio_"^"_OutFeeChainRatio_"^"_InComeYearOnYearRate_"^"_OutFeeYearOnYearRate_"^"_PerDayCheckPerson_"^"_ServeConsumeAmount_"^"_ConsumeMaterialAmount_"^"_TrainFeeAmount_"^"_MeasureFeeAmount_"^"_QualityControlAmount

	Quit ""
	
GetBenefitSummary
	s $p(BenefitInfo,"^",1)=$p(BenefitInfo,"^",1)+TFactualWorkLoad	//实际工作量
	s $p(BenefitInfo,"^",2)=$p(BenefitInfo,"^",2)+TWorkLoadPerMonth	//总工作量
	s $p(BenefitInfo,"^",3)=$p(BenefitInfo,"^",3)+TInCome			//收入
	s $p(BenefitInfo,"^",4)=$p(BenefitInfo,"^",4)+TConsumableFee	//耗材
	s $p(BenefitInfo,"^",5)=$p(BenefitInfo,"^",5)+TPersonFee		//人员
	s $p(BenefitInfo,"^",6)=$p(BenefitInfo,"^",6)+TWEFee			//水电
	s $p(BenefitInfo,"^",7)=$p(BenefitInfo,"^",7)+THouseFee			//房屋折旧
	s $p(BenefitInfo,"^",8)=$p(BenefitInfo,"^",8)+TMaintFee			//维修
	s $p(BenefitInfo,"^",9)=$p(BenefitInfo,"^",9)+TMaintainFee		//保养
	s $p(BenefitInfo,"^",10)=$p(BenefitInfo,"^",10)+TInSpectFee		//巡检
	s $p(BenefitInfo,"^",11)=$p(BenefitInfo,"^",11)+TMaintenanceFee	//维保
	s $p(BenefitInfo,"^",12)=$p(BenefitInfo,"^",12)+TDepreFee		//折旧费
	s $p(BenefitInfo,"^",13)=$p(BenefitInfo,"^",13)+TOutFee			//支出
	s $p(BenefitInfo,"^",14)=$p(BenefitInfo,"^",14)+EQOriginalFee	//金额
	s $p(BenefitInfo,"^",15)=$p(BenefitInfo,"^",15)+EQNum			//数量
	s $p(BenefitInfo,"^",16)=$p(BenefitInfo,"^",16)+TWaterFee		//水
	s $p(BenefitInfo,"^",17)=$p(BenefitInfo,"^",17)+TElectricFee	//电
	s $p(BenefitInfo,"^",18)=$p(BenefitInfo,"^",18)+TOtherIncome	//其他收入
	s $p(BenefitInfo,"^",19)=$p(BenefitInfo,"^",19)+TOutIncome		//门诊收入
	s $p(BenefitInfo,"^",20)=$p(BenefitInfo,"^",20)+TInIncome		//住院收入
	s $p(BenefitInfo,"^",21)=$p(BenefitInfo,"^",21)+TEmergencyIncome	//急诊收入
	s $p(BenefitInfo,"^",22)=$p(BenefitInfo,"^",22)+TNewBornIncome	//
	s $p(BenefitInfo,"^",23)=$p(BenefitInfo,"^",23)+THealthIncome	//体检收入
	s $p(BenefitInfo,"^",24)=$p(BenefitInfo,"^",24)+TCheckPerson	//人次
	s $p(BenefitInfo,"^",25)=$p(BenefitInfo,"^",25)+TExposureNum	//曝光次数
	s $p(BenefitInfo,"^",26)=$p(BenefitInfo,"^",26)+TPositiveNum	//阳性例数
	s $p(BenefitInfo,"^",27)=$p(BenefitInfo,"^",27)+TServeConsumeFee	//服务使用消耗 czf 20211104
	s $p(BenefitInfo,"^",28)=$p(BenefitInfo,"^",28)+TConsumeMaterialFee	//消耗性材料
	s $p(BenefitInfo,"^",29)=$p(BenefitInfo,"^",29)+TTrainFee			//培训
	s $p(BenefitInfo,"^",30)=$p(BenefitInfo,"^",30)+TMeasureFee			//计量
	s $p(BenefitInfo,"^",31)=$p(BenefitInfo,"^",31)+TQualityControlFee	//质控
	quit
}

/// Creator:add by czf 2021-08-31
/// Descrition:根据条件获取效益分析信息
/// Input： StartDate:开始月份yyyy-mm
/// 		EndDate:结束月份yyyy-mm
/// OutPut: 	s BenefitStr=FactualWorkLoadAmount_"^"_WorkLoadAmount_"^"_InComeAmount_"^"_ConsumableFeeAmount_"^"_PersonFeeAmount_"^"_WEFeeAmount_"^"_HouseFeeAmount_"^"_MaintFeeAmount_"^"_MaintainFeeAmount_"^"_InSpectFeeAmount_"^"_MaintenanceFeeAmount_"^"_DepreFeeAmount_"^"_OutFeeAmount_"^"_OriginalFeeAmount_"^"_NumAmount_"^"_WaterFeeAmount_"^"_ElectricFeeAmount_"^"_OtherIncomeAmount_"^"_OutIncomeAmount_"^"_InIncomeAmount_"^"_EmergencyAmount_"^"_NewBornAmount_"^"_HealthAmount_"^"_PerDayInCome_"^"_PerDayOutFee_"^"_InOutRate_"^"_CheckPerson_"^"_ExposureNum
/// 		实际工作量^工作量^总收入^总耗材费^人工费^水电费^房屋折旧^维修费^保养费^巡检费^维保费^折旧费^总支出^总金额^效益分析设备数量^水费^电费^其他收入^门诊收入^住院收入^急诊收入^新生儿收入^体检收入^日均收入^日均支出^收支比^服务人次^曝光次数
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr("2021-01","2021-01","","","","","")
ClassMethod GetBenefitStr(StartDate As %String = "", EndDate As %String = "", EquipID As %String = "", LocID As %String = "", StatCatID As %String = "", ItemID As %String = "", EquipCatID As %String = "", CurUserID As %String = "", CurLocID As %String = "", CurGroupID As %String = "")
{
	n (StartDate,EndDate,EquipID,LocID,StatCatID,ItemID,EquipCatID,CurUserID,CurLocID,CurGroupID,%session)
	i (StartDate="")||(EndDate="") q ""
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) q ""
	n BenefitStr,FactualWorkLoadAmount,WorkLoadAmount,InComeAmount,ConsumableFeeAmount,PersonFeeAmount,WaterFeeAmount,ElectricFeeAmount,WEFeeAmount,HouseFeeAmount,MaintFeeAmount,MaintainFeeAmount,InSpectFeeAmount,MaintenanceFeeAmount,DepreFeeAmount,OutFeeAmount,InComeAmount,NumAmount,OriginalFeeAmount
 	n DaysNum,OtherIncomeAmount,OtherIncomeAmount,OutIncomeAmount,InIncomeAmount,EmergencyAmount,NewBornAmount,HealthAmount,PerDayInCome,PerDayOutFee,InOutRate,CheckPerson,ExposureNum
	
	//i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//i CurUserID="" q ""
	//i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	//i CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
	
	s BenefitStr=""
	s (FactualWorkLoadAmount,WorkLoadAmount,InComeAmount,ConsumableFeeAmount,PersonFeeAmount,WaterFeeAmount,ElectricFeeAmount,WEFeeAmount,HouseFeeAmount,MaintFeeAmount,MaintainFeeAmount,InSpectFeeAmount,MaintenanceFeeAmount,DepreFeeAmount,OutFeeAmount,InComeAmount,NumAmount,OriginalFeeAmount)=0
 	s (DaysNum,OtherIncomeAmount,OtherIncomeAmount,OutIncomeAmount,InIncomeAmount,EmergencyAmount,NewBornAmount,HealthAmount,PerDayInCome,PerDayOutFee,InOutRate,CheckPerson,ExposureNum)=0
	s (ServeConsumeAmount,ConsumeMaterialAmount,TrainFeeAmount,MeasureFeeAmount,QualityControlAmount)=0		//czf 2021-11-04
	
	s DaysNum=##Class(web.DHCEQCommon).GetMonthDateNum(StartDate,EndDate,"1")
	
	s belrowid=0
	f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  q:belrowid=""  d
	.s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	.s rowid=$p(Datalist,"^",1)
 	.q:(EquipID'="")&&(EquipID'=rowid)
	.s StoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	.q:StoreLocDR=""
	.q:(LocID'="")&&(LocID'=StoreLocDR)
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s EQItemDR=$p($g(^DHCEQEquip(rowid)),"^",7)
	.q:EQItemDR=""
	.q:(ItemID'="")&&(ItemID'=EQItemDR)
	.s EQStatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	.q:EQStatCatDR=""
	.q:(StatCatID'="")&&(StatCatID'=EQStatCatDR)
	.s EquipCatDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	.q:EquipCatDR=""
	.q:(EquipCatID'="")&&(EquipCatID'=EquipCatDR)
	.s EQOriginalFee=$fn($p($g(^DHCEQEquip(rowid)),"^",27),"",2)
	.s EQNum=1
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.RPTCommon).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..s TWorkLoadPerMonth=+$p($g(^DHCEQEquip(rowid)),"^",84)
	..s TStandUseRate=$fn(+$p($g(^DHCEQEquip(rowid)),"^",92),"",2)
	..s TUseRate=0
	..i TWorkLoadPerMonth'=0  d
	...s TUseRate=$fn((TFactualWorkLoad/TWorkLoadPerMonth)*100,"",2)
	..s TIncomeInfo=##Class(web.DHCEQ.BA.RPTCommon).AllInCome(rowid,TMonth,TMonth)
	..s TInCome=+$p(TIncomeInfo,"^",1)		;总收入
	..s TOtherIncome=+$p(TIncomeInfo,"^",2)	;其他收入
	..s TOutIncome=+$p(TIncomeInfo,"^",3)	;门诊收入
	..s TInIncome=+$p(TIncomeInfo,"^",4)		;住院收入
	..s TEmergencyIncome=+$p(TIncomeInfo,"^",5)	;急诊收入
	..s TNewBornIncome=+$p(TIncomeInfo,"^",6)	;
	..s THealthIncome=+$p(TIncomeInfo,"^",7)	;体检收入
	..s TCheckPerson=+$p(TIncomeInfo,"^",8)		;人次
	..s TExposureNum=+$p(TIncomeInfo,"^",9)		;曝光次数
	..s TServeConsumeFee=+$p(TIncomeInfo,"^",11)	;服务消耗
	..;s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..s TConsumeMaterialFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"13",TMonth,TMonth)	//消耗性材料
	..s TConsumableFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"14",TMonth,TMonth)	//资源消耗耗材费
	..s TSumConsumableFee=TConsumableFee+TConsumeMaterialFee+TServeConsumeFee						//耗材费=资源消耗耗材+消耗性材料+服务项消耗
	..s TPersonFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"01",TMonth,TMonth)		//人员工资
	..s TTrainFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"02",TMonth,TMonth)			//培训费
	..s TPersonnelCost=TPersonFee+TTrainFee		//人工费
	..s TWaterFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"03",TMonth,TMonth)		//水费
	..s TElectricFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"04",TMonth,TMonth)	//电费
	..s TWEFee=TWaterFee+TElectricFee			//水电
	..s THouseFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"06",TMonth,TMonth)		//房屋折旧
	..s TMaintFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"07",TMonth,TMonth)		//维修
	..i TMaintFee=0 s TMaintFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"31","",CurLocID,CurGroupID)
	..s TMaintainFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"09",TMonth,TMonth)	//保养
	..i TMaintainFee=0 s TMaintainFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"32","",CurLocID,CurGroupID)
	..s TInSpectFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"10",TMonth,TMonth)	//检查
	..i TInSpectFee=0 s TInSpectFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33","",CurLocID,CurGroupID,"4")
	..s TMeasureFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"11",TMonth,TMonth)		//计量费
	..i TMeasureFee=0 s TMeasureFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33","",CurLocID,CurGroupID,"5")
	..s TQualityControlFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"12",TMonth,TMonth)	//质控费
	..s TMaintenanceFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"08",TMonth,TMonth)	//维保费	
	..s TSumMaintenanceFee=TMaintenanceFee+TMaintFee+TMaintainFee+TInSpectFee+TMeasureFee+TQualityControlFee	//维保费=资源消耗维保费+维修费+保养+计量+检查+质控费
	..s TDepreFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"05",TMonth,TMonth)
	..i TDepreFee=0 s TDepreFee=+..GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"35", "",CurLocID,CurGroupID)
	..s TResourceFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"",TMonth,TMonth)
	..s TOutFee=TSumConsumableFee+TPersonnelCost+TWEFee+THouseFee+TSumMaintenanceFee+TDepreFee	//总支出=耗材费+人员经费+水电+房屋折旧+维保费+折旧费
	..;s (TConsumableRate,TPersonRate,TWERate,TMaintRate,TMaintainRate,TInSpectRate,TDepreRate,THouseRate,TInOutRate)=0
	..;i TOutFee'=0  d
	...;s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee/TOutFee,"",2)
	...;s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonFee/TOutFee,"",2)
	...;s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWEFee/TOutFee,"",2)
	...;s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintFee/TOutFee,"",2)
	...;s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee/TOutFee,"",2)
	...;s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee/TOutFee,"",2)
	...;s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreFee/TOutFee,"",2)
	...;s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseFee/TOutFee,"",2)
	...;s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)		//收支比
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	..;s BenefitList=TFactualWorkLoad_"^"_TWorkLoadPerMonth_"^"_TInCome_"^"_TConsumableFee_"^"_TPersonFee_"^"_TWEFee_"^"_THouseFee_"^"_TMaintFee_"^"_TMaintainFee_"^"_TInSpectFee_"^"_TMaintenanceFee_"^"_TDepreFee_"^"_TOutFee_"^"_EQOriginalFee_"^"_EQNum_"^"_TWaterFee_"^"_TElectricFee
	..s FactualWorkLoadAmount=FactualWorkLoadAmount+TFactualWorkLoad
	..s WorkLoadAmount=WorkLoadAmount+TWorkLoadPerMonth
	..s InComeAmount=InComeAmount+TInCome
	..s OtherIncomeAmount=OtherIncomeAmount+TOtherIncome
	..s OutIncomeAmount=OutIncomeAmount+TOutIncome
	..s InIncomeAmount=InIncomeAmount+TInIncome
	..s EmergencyAmount=EmergencyAmount+TEmergencyIncome
	..s NewBornAmount=NewBornAmount+TNewBornIncome
	..s HealthAmount=HealthAmount+THealthIncome
	..s CheckPerson=CheckPerson+TCheckPerson
	..s ExposureNum=ExposureNum+TExposureNum
	..s ServeConsumeAmount=ServeConsumeAmount+TServeConsumeFee	//服务项消耗
	..s ConsumeMaterialAmount=ConsumeMaterialAmount+TConsumeMaterialFee	//消耗性材料
	..s ConsumableFeeAmount=ConsumableFeeAmount+TConsumableFee
	..s PersonFeeAmount=PersonFeeAmount+TPersonFee
	..s TrainFeeAmount=TrainFeeAmount+TTrainFee					//培训费
	..s WaterFeeAmount=WaterFeeAmount+TWaterFee
	..s ElectricFeeAmount=ElectricFeeAmount+TElectricFee
	..s WEFeeAmount=WEFeeAmount+TWEFee
	..s HouseFeeAmount=HouseFeeAmount+THouseFee
	..s MaintFeeAmount=MaintFeeAmount+TMaintFee
	..s MaintainFeeAmount=MaintainFeeAmount+TMaintainFee
	..s InSpectFeeAmount=InSpectFeeAmount+TInSpectFee
	..s MeasureFeeAmount=MeasureFeeAmount+TMeasureFee	//计量
	..s QualityControlAmount=QualityControlAmount+TQualityControlFee	//质控费
	..s MaintenanceFeeAmount=MaintenanceFeeAmount+TMaintenanceFee	//维保费
	..s DepreFeeAmount=DepreFeeAmount+TDepreFee
	..s OutFeeAmount=OutFeeAmount+TOutFee
	.s NumAmount=NumAmount+1
	.s OriginalFeeAmount=OriginalFeeAmount+EQOriginalFee
	
	;效益分析汇总信息
	s OriginalFeeAmount=##Class(web.DHCEQCommon).FormatNumber(OriginalFeeAmount,"",2)
	i DaysNum'=0 d
	.s PerDayInCome=##Class(web.DHCEQCommon).FormatNumber(InComeAmount/DaysNum,"",2)
	.s PerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(OutFeeAmount/DaysNum,"",2)
	i OutFeeAmount'=0 s InOutRate=##Class(web.DHCEQCommon).FormatNumber(InComeAmount/OutFeeAmount,"",2)	//收支比
	s InComeAmount=##Class(web.DHCEQCommon).FormatNumber(InComeAmount,"",2)
	s OutFeeAmount=##Class(web.DHCEQCommon).FormatNumber(OutFeeAmount,"",2)
	//						1						2				3					4						5				6				7					8					9					10						11						12				13					14				15				16					17						18					19					20					21					22				23				24				25					26			27				28					29						30						31						32						33	
	s BenefitStr=FactualWorkLoadAmount_"^"_WorkLoadAmount_"^"_InComeAmount_"^"_ConsumableFeeAmount_"^"_PersonFeeAmount_"^"_WEFeeAmount_"^"_HouseFeeAmount_"^"_MaintFeeAmount_"^"_MaintainFeeAmount_"^"_InSpectFeeAmount_"^"_MaintenanceFeeAmount_"^"_DepreFeeAmount_"^"_OutFeeAmount_"^"_OriginalFeeAmount_"^"_NumAmount_"^"_WaterFeeAmount_"^"_ElectricFeeAmount_"^"_OtherIncomeAmount_"^"_OutIncomeAmount_"^"_InIncomeAmount_"^"_EmergencyAmount_"^"_NewBornAmount_"^"_HealthAmount_"^"_PerDayInCome_"^"_PerDayOutFee_"^"_InOutRate_"^"_CheckPerson_"^"_ExposureNum_"^"_ServeConsumeAmount_"^"_ConsumeMaterialAmount_"^"_TrainFeeAmount_"^"_MeasureFeeAmount_"^"_QualityControlAmount
	
	q BenefitStr
}

/// add by czf 2021-09-03
/// 设备总收入及各项收入,设备耗材费汇总获取
/// OutPut:总收入^其他收入^门诊收入^住院收入^急诊收入^新生儿收入^体检收入^服务人次^曝光次数^阳性次数^耗材费^工作量^
/// w ##Class(web.DHCEQ.BA.RPTCommon).AllInCome("6","2021-01","2021-01","","202","85")
ClassMethod AllInCome(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "")
{
	n (EquipDR,StartDate,EndDate,QXType,CurLocID,CurGroupID)
	n SYear,EYear,SMonth,EMonth,YearLen,MonthLen,Month
	n TotalFee,URFee,WorkLoadNum,PURFee
	n URSRowID,UseLoc,Month,Year,ConsumableValue
	i EquipDR=""  q ""
	s EQItem=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	s SYear=$p(StartDate,"-",1)
	s EYear=$p(EndDate,"-",1)
	s SMonth=$p(StartDate,"-",2)
	s EMonth=$p(EndDate,"-",2)
	n AllIncome,OtherIncome,OutPatientIncome,InPatientIncome,EmergencyIncome,NewBornIncome,HealthIncome,CheckPerson,ExposureNum,PositiveNum,URFee,PURFee,WorkLoadNum
	s (AllIncome,OtherIncome,OutPatientIncome,InPatientIncome,EmergencyIncome,NewBornIncome,HealthIncome,CheckPerson,ExposureNum,PositiveNum,URFee,PURFee,WorkLoadNum)=0
	;i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))

	s Year=0
	f  s Year=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year)) quit:(Year="")  d
	.q:(Year<SYear)||(Year>EYear)
	.s Month=0
	.f  s Month=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year,Month)) quit:Month=""  d
	..q:(SYear=Year)&(Month<SMonth)
	..q:(EYear=Year)&(Month>EMonth)
	..s URSRowID=0
	..f  s URSRowID=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year,Month,URSRowID))  q:URSRowID=""  d
	...s DataList=$g(^DHCEQUseRecordStat(URSRowID))
	...s UseLocID=$p(DataList,"^",5)
	...;q:(UseLocID'="")&&(##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLocID,CurLocID,CurGroupID)'=0)
	...s UCRIncome=$p($g(^DHCEQUseRecordStat(URSRowID)),"^",7)
	...s WorkLoadNum=WorkLoadNum+$p($g(^DHCEQUseRecordStat(URSRowID)),"^",8)
	...s ConsumableValue=..GetUseRecordConsumableFee(URSRowID)
	...s URFee=+$p(ConsumableValue,"^",1)+URFee
	...s PURFee=+$p(ConsumableValue,"^",2)+PURFee
	...s AllIncome=AllIncome+UCRIncome
	...s AdmissionType=$p(DataList,"^",18)
	...i AdmissionType="O" s OutPatientIncome=OutPatientIncome+UCRIncome	;门诊收入outpatients
	...e  i AdmissionType="I" s InPatientIncome=InPatientIncome+UCRIncome	;住院收入inpatients
	...e  i AdmissionType="E" s EmergencyIncome=EmergencyIncome+UCRIncome	;急诊收入Emergency
	...e  i AdmissionType="N" s NewBornIncome=NewBornIncome+UCRIncome		;新生儿科收入NewBorn
	...e  i AdmissionType="H" s HealthIncome=HealthIncome+UCRIncome	;体检收入HealthPromotion
	...e  s OtherIncome=OtherIncome+UCRIncome	;其他收入
	...s CheckPerson=CheckPerson+$p($g(^DHCEQUseRecordStat(URSRowID)),"^",15)	;人次
	...s ExposureNum=ExposureNum+$p($g(^DHCEQUseRecordStat(URSRowID)),"^",17)	;曝光次数
	...s PositiveNum=PositiveNum+$p($g(^DHCEQUseRecordStat(URSRowID)),"^",23)	;阳性例数
	
	//czf 取手工维护的设备服务消耗信息
	i StartDate=""  d
	.s start=0
	e  d
	.s start=$ZDH(StartDate_"-01",3)
	i EndDate="" s end=+$h
	e  s end=##Class(web.DHCEQCommon).DateAddInt("M",1,$ZDH(EndDate_"-01",3))-1
	
	s URFee=0
	s URRowID=0
	f  s URRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID)) q:URRowID=""  d
	.s UCIRowID=0
	.f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID,UCIRowID)) q:UCIRowID=""  d
	..s DataList=$g(^DHCEQUseConsumableItem(UCIRowID))
	..s UseDate=$p(DataList,"^",16)
	..q:(start>UseDate)||(end<UseDate)
	..s ConsumableItemID=$p(DataList,"^",2)
	..s TSourceType=$p($g(^DHCEQUseRecord(URRowID)),"^",1)
	..s TSourceID=$p($g(^DHCEQUseRecord(URRowID)),"^",2)
	..q:(TSourceType=1)&&(EquipDR'=TSourceID)
	..q:(TSourceType=2)&&(EQItem'=TSourceID)
	..q:(TSourceType'=1)&&(TSourceType'=2)
	..;s ECIrowid =$o(^DHCEQEquipConsumableItem(0,"ConsumableItemDR",ConsumableItemID,EquipDR,0))
	..;s Rate=+$p($g(^DHCEQEquipConsumableItem(ECIrowid)),"^",3)
	..s Amount=+$p(DataList,"^",6)
	..;i Rate'=0 s Amount=Amount*Rate  //取设备占用费用的分配比例
	..s URFee=URFee+Amount
	
	q AllIncome_"^"_OtherIncome_"^"_OutPatientIncome_"^"_InPatientIncome_"^"_EmergencyIncome_"^"_NewBornIncome_"^"_HealthIncome_"^"_CheckPerson_"^"_ExposureNum_"^"_PositiveNum_"^"_URFee_"^"_WorkLoadNum_"^"_PURFee
}

/// add by zy 2013-05-29 ZY0107
/// 根据使用记录获取对应消耗项目费用
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetUseRecordConsumableFee("80")
ClassMethod GetUseRecordConsumableFee(UseRecordStatID As %String = "")
{
	i UseRecordStatID=""  q ""
	s URCFee=0
	s UCSRowID=0
	s PURCFee=0
	f  s UCSRowID=$o(^DHCEQUseConsumableStat(0,"UseRecordstat",UseRecordStatID,UCSRowID))  q:UCSRowID=""  d
	.s UCSFee=$p($g(^DHCEQUseConsumableStat(UCSRowID)),"^",6)
	.s URCFee=URCFee+UCSFee
	.s PUCSFee=$p($g(^DHCEQUseConsumableStat(UCSRowID)),"^",16) //add by zx 2014-09-27
	.s PURCFee=PURCFee+PUCSFee
	q URCFee_"^"_PURCFee
}

/// Description：获取环比信息_其他收入环比_
/// Input：StartDate:开始月份，EndDate:结束月份
/// 		BenefitInfo:对应条件下效益分析信息串
/// 		PeriodType:期间类型
/// OutPut：总收入环比_"^"_总支出环比_"^""^"_门诊收入环比_"^"_住院收入环比_"^"_急诊收入环比_"^"_新生儿收入环比_"^"_体检收入环比
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetBAQoQRate("2021-01","2021-09","","1","","","","0","0","")
ClassMethod GetBAQoQRate(StartDate As %String = "", EndDate As %String = "", EquipID As %String = "", LocID As %String = "", StatCatID As %String = "", ItemID As %String = "", EquipCatID As %String = "", BenefitInfo As %String = "", PeriodType As %String = "")
{
	//s ^tempczf("assd")=$lb(StartDate,EndDate,EquipID,LocID,StatCatID,ItemID,EquipCatID,BenefitInfo,PeriodType)
	n (StartDate,EndDate,EquipID,LocID,StatCatID,ItemID,EquipCatID,BenefitInfo,PeriodType)
	i (StartDate="")||(EndDate="") q ""
	n InComeChainRatio,OutFeeChainRatio,OtherIncomeRatio,OutPatientIncomeRatio,InPatientIncomeRatio,EmergencyIncomeRatio,NewBornIncomeRatio,HealthIncomeRatio
	s (InComeChainRatio,OutFeeChainRatio,OtherIncomeRatio,OutPatientIncomeRatio,InPatientIncomeRatio,EmergencyIncomeRatio,NewBornIncomeRatio,HealthIncomeRatio)=""
	
	i (PeriodType="YearFlag")		//年度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,EndDate)
	}
	elseif (PeriodType="HalfYear")	//半年度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-6,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-6,EndDate)
	}
	elseif (PeriodType="Quarter")	//季度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-3,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-3,EndDate)
	}
	elseif (PeriodType="MonthFlag")	//月度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,EndDate)
	}
	i PeriodType'=""
	{
		s CurInCome=$p(BenefitInfo,"^",3)
		s CurOutFee=$p(BenefitInfo,"^",13)
		s CurOtherInCome=$p(BenefitInfo,"^",18)
		s CurOutPatientIncome=$p(BenefitInfo,"^",19)
		s CurInPatientIncome=$p(BenefitInfo,"^",10)
		s CurEmergencyIncome=$p(BenefitInfo,"^",21)
		s CurNewBornIncome=$p(BenefitInfo,"^",22)
		s CurHealthIncome=$p(BenefitInfo,"^",23)
		
		;环比
		s LastRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastSPeriod,LastEPeriod,EquipID,LocID,StatCatID,ItemID,EquipID)
		s LastInCome=$p(LastRtnStr,"^",3)
		s LastOutFee=$p(LastRtnStr,"^",13)
		s LastOtherIncome=$p(LastRtnStr,"^",18)
		s LastOutPatientIncome=$p(LastRtnStr,"^",19)
		s LastInPatientIncome=$p(LastRtnStr,"^",20)
		s LastEmergencyIncome=$p(LastRtnStr,"^",21)
		s LastNewBornIncome=$p(LastRtnStr,"^",22)
		s LastHealthIncome=$p(LastRtnStr,"^",23)
		
		i +LastInCome'=0 s InComeChainRatio=##Class(web.DHCEQCommon).FormatNumber(((CurInCome-LastInCome)/$ZABS(LastInCome)*100),"",2)
		i +LastOutFee'=0 s OutFeeChainRatio=##Class(web.DHCEQCommon).FormatNumber(((CurOutFee-LastOutFee)/$ZABS(LastOutFee)*100),"",2)
		i +LastOtherIncome'=0 s OtherIncomeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurOtherInCome-LastOtherIncome)/$ZABS(LastOtherIncome)*100),"",2)
		i +LastOutPatientIncome'=0 s OutPatientIncomeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurOutPatientIncome-LastOutPatientIncome)/$ZABS(LastOutPatientIncome)*100),"",2)
		i +LastInPatientIncome'=0 s InPatientIncomeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurInPatientIncome-LastInPatientIncome)/$ZABS(LastInPatientIncome)*100),"",2)
		i +LastEmergencyIncome'=0 s EmergencyIncomeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurEmergencyIncome-LastEmergencyIncome)/$ZABS(LastEmergencyIncome)*100),"",2)
		i +LastNewBornIncome'=0 s NewBornIncomeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurNewBornIncome-LastNewBornIncome)/$ZABS(LastNewBornIncome)*100),"",2)
		i +LastHealthIncome'=0 s HealthIncomeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurHealthIncome-LastHealthIncome)/$ZABS(LastHealthIncome)*100),"",2)
	}

	q InComeChainRatio_"^"_OutFeeChainRatio_"^"_OtherIncomeRatio_"^"_OutPatientIncomeRatio_"^"_InPatientIncomeRatio_"^"_EmergencyIncomeRatio_"^"_NewBornIncomeRatio_"^"_HealthIncomeRatio
}

/// Description：获取同比信息
/// OutPut：总收入同比_"^"_总支出环比_"^"_其他收入同比_"^"_门诊收入同比_"^"_住院收入同比_"^"_急诊收入同比_"^"_新生儿收入同比_"^"_体检收入同比
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetInOutQoYRate("2021-01","2021-09","","1","","","","0","0","")
ClassMethod GetBAYoYRate(StartDate As %String = "", EndDate As %String = "", EquipID As %String = "", LocID As %String = "", StatCatID As %String = "", ItemID As %String = "", EquipCatID As %String = "", BenefitInfo As %String = "", PeriodType As %String = "")
{
	n (StartDate,EndDate,EquipID,LocID,StatCatID,ItemID,EquipCatID,BenefitInfo,PeriodType)
	i (StartDate="")||(EndDate="") q ""
	n InComeYOYRate,OutFeeYOYRate,OtherIncomeYOY,OutPatientIncomeYOY,InPatientIncomeYOY,EmergencyIncomeYOY,NewBornIncomeYOY,HealthIncomeYOY
	s (InComeYOYRate,OutFeeYOYRate,OtherIncomeYOY,OutPatientIncomeYOY,InPatientIncomeYOY,EmergencyIncomeYOY,NewBornIncomeYOY,HealthIncomeYOY)=""
	
	s CurInCome=$p(BenefitInfo,"^",3)
	s CurOutFee=$p(BenefitInfo,"^",13)
	s CurOtherInCome=$p(BenefitInfo,"^",18)
	s CurOutPatientIncome=$p(BenefitInfo,"^",17)
	s CurInPatientIncome=$p(BenefitInfo,"^",20)
	s CurEmergencyIncome=$p(BenefitInfo,"^",21)
	s CurNewBornIncome=$p(BenefitInfo,"^",22)
	s CurHealthIncome=$p(BenefitInfo,"^",23)
	
	;同比
	s LastYOYSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,StartDate)
	s LastYOYEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,EndDate)
	s LastYOYRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastYOYSPeriod,LastYOYEPeriod,EquipID,LocID,StatCatID,ItemID,EquipID)
	s LastYOYInCome=$p(LastYOYRtnStr,"^",3)
	s LastYOYOutFee=$p(LastYOYRtnStr,"^",13)
	s LastYOYOtherIn=$p(LastYOYRtnStr,"^",18)
	s LastYOYOutPatientIn=$p(LastYOYRtnStr,"^",19)
	s LastYOYInPatientIn=$p(LastYOYRtnStr,"^",20)
	s LastYOYEmergencyIn=$p(LastYOYRtnStr,"^",21)
	s LastYOYNewBornIn=$p(LastYOYRtnStr,"^",22)
	s LastYOYHealthIn=$p(LastYOYRtnStr,"^",23)
	i +LastYOYInCome'=0 s InComeYOYRate=##Class(web.DHCEQCommon).FormatNumber(((CurInCome-LastYOYInCome)/$ZABS(LastYOYInCome)*100),"",2)
	i +LastYOYOutFee'=0 s OutFeeYOYRate=##Class(web.DHCEQCommon).FormatNumber(((CurOutFee-LastYOYOutFee)/$ZABS(LastYOYOutFee)*100),"",2)
	i +LastYOYOtherIn'=0 s OtherIncomeYOY=##Class(web.DHCEQCommon).FormatNumber(((CurOtherInCome-LastYOYOtherIn)/$ZABS(LastYOYOtherIn)*100),"",2)
	i +LastYOYOutPatientIn'=0 s OutPatientIncomeYOY=##Class(web.DHCEQCommon).FormatNumber(((CurOutPatientIncome-LastYOYOutPatientIn)/$ZABS(LastYOYOutPatientIn)*100),"",2)
	i +LastYOYInPatientIn'=0 s InPatientIncomeYOY=##Class(web.DHCEQCommon).FormatNumber(((CurInPatientIncome-LastYOYInPatientIn)/$ZABS(LastYOYInPatientIn)*100),"",2)
	i +LastYOYEmergencyIn'=0 s EmergencyIncomeYOY=##Class(web.DHCEQCommon).FormatNumber(((CurEmergencyIncome-LastYOYEmergencyIn)/$ZABS(LastYOYEmergencyIn)*100),"",2)
	i +LastYOYNewBornIn'=0 s NewBornIncomeYOY=##Class(web.DHCEQCommon).FormatNumber(((CurNewBornIncome-LastYOYNewBornIn)/$ZABS(LastYOYNewBornIn)*100),"",2)
	i +LastYOYHealthIn'=0 s HealthIncomeYOY=##Class(web.DHCEQCommon).FormatNumber(((CurHealthIncome-LastYOYHealthIn)/$ZABS(LastYOYHealthIn)*100),"",2)
	
	q InComeYOYRate_"^"_OutFeeYOYRate_"^"_OtherIncomeYOY_"^"_OutPatientIncomeYOY_"^"_InPatientIncomeYOY_"^"_EmergencyIncomeYOY_"^"_NewBornIncomeYOY_"^"_HealthIncomeYOY
}

/// 根据开始日期，结束日期和周期类型获取上一周期的日期区间
/// w ##class(web.DHCEQ.BA.RPTCommon).GetPeriodDate("2021-01","2021-09","YearFlag")
ClassMethod GetPeriodDate(StartDate As %String = "", EndDate As %String = "", PeriodType As %String = "")
{
	n (StartDate,EndDate,PeriodType)
	i (StartDate="")||(EndDate="") q ""
	s (LastSPeriod,LastEPeriod)=""
	
	if (PeriodType="HalfYear")	//半年度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-6,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-6,EndDate)
	}
	elseif (PeriodType="Quarter")	//季度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-3,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-3,EndDate)
	}
	elseif (PeriodType="MonthFlag")	//月度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,EndDate)
	}
	else	//"YearFlag"		//年度
	{
		s LastSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,StartDate)
		s LastEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,EndDate)
	}
	q LastSPeriod_"^"_LastEPeriod
}

/// add by ZY0271 20210918
/// 统计医生开单阳性率
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetBAEquipList("","RunStat^65988,62871^1532")
ClassMethod GetDoctorPositiveNum(vData As %String = "", NodeStr As %String = "")
{
	new Node,CurTime,Job
 	s vData=##class(web.DHCEQCommon).UnEscape(vData)
 	s DoctoreDR=##class(web.DHCEQCommon).GetDataByName(vData,"DoctorDR")
 	s RequestDeptDR=##class(web.DHCEQCommon).GetDataByName(vData,"RequestDeptDR")
 	
	s Node=$p(NodeStr,"^",1)
	s CurTime=$p(NodeStr,"^",2)
	s Job=$p(NodeStr,"^",3)
	k ^TempDHCEQ(Node)
	
	s URSRowID=0
	f  s URSRowID=$o(^DHCEQUseRecordStat(URSRowID)) Q:URSRowID=""  d
	.s DataList=$g(^DHCEQUseRecordStat(URSRowID))
	.s TDoctoreDR=+$p(DataList,"^",21)
	.q:(DoctoreDR'="")&&(DoctoreDR'=TDoctoreDR)
	.s TRequestDeptDR=$p(DataList,"^",22)
	.q:(RequestDeptDR'="")&&(RequestDeptDR'=TRequestDeptDR)
	.s TmpDataList=$g(^TempDHCEQ(Node,CurTime,Job,TDoctoreDR))
	.s $p(TmpDataList,"^",1)=$p(TmpDataList,"^",1)+$p(DataList,"^",8)
	.s $p(TmpDataList,"^",2)=$p(TmpDataList,"^",2)+$p(DataList,"^",23)
	.s ^TempDHCEQ(Node,CurTime,Job,TDoctoreDR)=TmpDataList
	q 0
}

/// add by ZY0271 20210918
/// 统计同一天同一个病人检查用时
/// URExType,StartDate,SourceType,SourceID,PatientID
/// w ##Class(web.DHCEQ.BA.RPTCommon).GetBAEquipList("","RunStat^65988,62871^1532")
ClassMethod GetPersonTimes(vData As %String = "", NodeStr As %String = "")
{
	new Node,CurTime,Job
 	s vData=##class(web.DHCEQCommon).UnEscape(vData)
 	s EquipID=##class(web.DHCEQCommon).GetDataByName(vData,"EquipID")
 	i EquipID="" q ""
 	s StartDate=##class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
 	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	s EndDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
 	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	
	s Node=$p(NodeStr,"^",1)
	s CurTime=$p(NodeStr,"^",2)
	s Job=$p(NodeStr,"^",3)
	k ^TempDHCEQ(Node)
	
	s vDate=StartDate-1
	f  s vDate=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,vDate)) Q:(vDate="")||(vDate>EndDate)  d
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,vDate,URRowID)) Q:URRowID=""  d
	..s DataList=$g(^DHCEQUseRecord(URRowID))
	..s PatientID=$p(DataList,"^",10)
	..s RegTime=$p(DataList,"^",60)
	..s ReportTime=$p(DataList,"^",62)
	..s OneTime=(ReportTime-RegTime)/60
	..i OneTime<10 s OneTime=10
	..s Month=$p($zd(vDate,3),"-",1,2)
	..s totalOneTime=""  //add by wy 2021-10-9
	..i PatientID'="" d
	...s totalOneTime=$g(^TempDHCEQ(Node,CurTime,Job,Month,vDate,PatientID))
	...s totalOneTime=totalOneTime+OneTime
	...s ^TempDHCEQ(Node,CurTime,Job,Month,vDate,PatientID)=totalOneTime
	
	q 0
}

/// czf 2021-09-20
/// 获取效益分析同类设备维修信息
/// 临时global记录同一标准设备项，同一厂家，同一型号的设备维修数量及对应数量
/// Input：
/// 	nodestr:临时global节点名，不同界面应用不用的nodestr
/// 	ItemDR:设备项ID
/// 	StartDate:开始月份
/// 	EndDate:结束月份
/// d ##Class(web.DHCEQ.BA.RPTCommon).GetSameEQMaintInfo("web.DHCEQ.BA.RPTCommon_GetSameEQMaintInfo","263","2019-01","2019-12","","","12214","202","85")
ClassMethod GetSameEQMaintInfo(nodestr, ItemDR As %String = "", StartDate As %String = "", EndDate As %String = "", Job As %String = "", QXType As %String = "", CurUserID As %String = "", CurLocID As %String = "", CurGroupID As %String = "")
{
	n (nodestr,ItemDR,StartDate,EndDate,Job,QXType,CurUserID,CurLocID,CurGroupID)
	i nodestr="" q ""
	k ^TempDHCEQ(nodestr,"MaintInfo")
	s Date=+$h
	i Job=""  s Job=$J
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurUserID="" Quit ""
	i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
	
	i StartDate'="" Set StartDate=$zdh(StartDate_"-01",3)
 	e  s StartDate=0
 	i EndDate'="" Set EndDate=##Class(web.DHCEQCommon).DateAddInt("M",1,$zdh(EndDate_"-01",3))-1
	e  s EndDate=+$h
	i StartDate>EndDate Quit ""
	
	s rowid=0
	f  s rowid=$o(^DHCEQBenefitEquipList(rowid))  q:rowid=""  d
	.s EquipID=$p($g(^DHCEQBenefitEquipList(rowid)),"^",1)
	.q:EquipID=""
	.s TStoreLocDR=$p($g(^DHCEQEquip(EquipID)),"^",67)
	.q:TStoreLocDR=""
	.q:##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID)'=0
	.s TInvalidFlag=$p($g(^DHCEQEquip(EquipID)),"^",59)="Y"
	.s StockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s TStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)
	.q:TStatus'=1
	.s TItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
	.q:TItemDR=""
	.s TIsStandard=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",21)
	.i TIsStandard="N"  d
	..s MIEQItemDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",22)
	..i MIEQItemDR'="" s TItemDR=MIEQItemDR		//czf 2022-03-18
	.q:(ItemDR'="")&&(TItemDR'=ItemDR)
	.s TStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(EquipID)),"^",26)
	.;q:(TManuFactoryDR="")
	.s TModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)
	.;q:(TModelDR="")
	.s TBrandDR=$p($g(^DHCEQEquip(EquipID)),"^",94)
	.;q:(TBrandDR="")
	.s ExObjDR=$o(^DHCEQMExObj(0,"ExID",1,EquipID,""))
	.s (MaintCount,MaintTimeCost)=0
	.i ExObjDR'=""  d
	..s TMaintRequestDR=0
	..f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(0,"Source",1,ExObjDR,TMaintRequestDR)) q:TMaintRequestDR=""  d
	...q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57)="Y")
	...q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",41)'="2")
	...s TEndDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",16)
	...q:(StartDate'="")&&(TEndDate<StartDate)
	...q:(EndDate'="")&&(TEndDate>EndDate)
	...s MaintCount=MaintCount+1
	...s WorkHour=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",39)
	...s MaintTimeCost=MaintTimeCost+WorkHour
	.s EquipConut=1
	.s EQMaintReqInfo=MaintCount_"^"_EquipConut_"^"_MaintTimeCost
	.i ('$d(^TempDHCEQ(nodestr,"MaintInfo",Date,Job,CurUserID,TItemDR,+TManuFactoryDR,+TModelDR)))  d
	..s ^TempDHCEQ(nodestr,"MaintInfo",Date,Job,CurUserID,TItemDR,+TManuFactoryDR,+TModelDR)=EQMaintReqInfo
	.e  d
	..s EQMaintReqInfo=$g(^TempDHCEQ(nodestr,"MaintInfo",Date,Job,CurUserID,TItemDR,+TManuFactoryDR,+TModelDR))
	..s $p(EQMaintReqInfo,"^",1)=$p(EQMaintReqInfo,"^",1)+MaintCount		//维修次数
	..s $p(EQMaintReqInfo,"^",2)=$p(EQMaintReqInfo,"^",2)+EquipConut		
	..s $p(EQMaintReqInfo,"^",3)=$p(EQMaintReqInfo,"^",3)+MaintTimeCost		//维修时长
}

/// czf 2021-09-20
/// 获取效益分析同类设备维修信息
/// 临时global记录同一标准设备项，同一厂家，同一型号的设备收支信息
/// Input：
/// 	nodestr:临时global节点名，不同界面应用不用的nodestr
/// 	ItemDR:设备项ID
/// 	StartDate:开始月份
/// 	EndDate:结束月份
/// d ##Class(web.DHCEQ.BA.RPTCommon).GetSameEQBenefitInfo("web.DHCEQ.BA.RPTCommon_GetSameEQBenefitInfo","","2019-01","2019-12","","","12214","202","85")
ClassMethod GetSameEQBenefitInfo(nodestr, ItemDR As %String = "", StartDate As %String = "", EndDate As %String = "", Job As %String = "", QXType As %String = "", CurUserID As %String = "", CurLocID As %String = "", CurGroupID As %String = "")
{
	n (nodestr,ItemDR,StartDate,EndDate,Job,QXType,CurUserID,CurLocID,CurGroupID)
	i nodestr="" q ""
	k ^TempDHCEQ(nodestr,"Benefit")
	i (StartDate="")||(EndDate="") q ""
	s Date=+$h
	i Job=""  s Job=$J
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurUserID="" q ""
	i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) Quit ""
	
	s rowid=0
	f  s rowid=$o(^DHCEQBenefitEquipList(rowid))  q:rowid=""  d
	.s EquipID=$p($g(^DHCEQBenefitEquipList(rowid)),"^",1)
	.q:EquipID=""
	.s TStoreLocDR=$p($g(^DHCEQEquip(EquipID)),"^",67)
	.q:TStoreLocDR=""
	.q:##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID)'=0
	.s TInvalidFlag=$p($g(^DHCEQEquip(EquipID)),"^",59)="Y"
	.s StockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s TStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)
	.q:TStatus'=1
	.s TItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
	.q:TItemDR=""
	.s TIsStandard=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",21)
	.i TIsStandard="N"  d
	..s TItemDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",22)
	.e  d
	..s TItemDR=TItemDR
	.q:(ItemDR'="")&&(TItemDR'=ItemDR)
	.s TStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(EquipID)),"^",26)
	.;q:(TManuFactoryDR="")
	.s TModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)
	.;q:(TModelDR="")
	.s TBrandDR=$p($g(^DHCEQEquip(EquipID)),"^",94)
	.;q:(TBrandDR="")
	.s (InComeTotal,OutFeeTotal)=0
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TIncomeInfo=##Class(web.DHCEQ.BA.RPTCommon).AllInCome(EquipID,TMonth,TMonth,"",CurLocID,CurGroupID)
	..s TInCome=+$p(TIncomeInfo,"^",1)
	..s TOutFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(EquipID,"",TMonth,TMonth,"",Job,CurUserID)
	..s InComeTotal=InComeTotal+TInCome
	..s OutFeeTotal=OutFeeTotal+TOutFee
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	.s EquipConut=1
	.;同一厂家不同型号的设备项效益汇总
	.s EQItemBenetitInfo=InComeTotal_"^"_OutFeeTotal_"^"_EquipConut
	.i ('$d(^TempDHCEQ(nodestr,"Benefit",Date,Job,CurUserID,TItemDR,+TManuFactoryDR,+TModelDR)))  d
	..s ^TempDHCEQ(nodestr,"Benefit",Date,Job,CurUserID,TItemDR,+TManuFactoryDR,+TModelDR)=EQItemBenetitInfo
	.e  d
	..s EQItemBenetitInfo=$g(^TempDHCEQ(nodestr,"Benefit",Date,Job,CurUserID,TItemDR,+TManuFactoryDR,+TModelDR))
	..s $p(EQItemBenetitInfo,"^",1)=$p(EQItemBenetitInfo,"^",1)+InComeTotal
	..s $p(EQItemBenetitInfo,"^",2)=$p(EQItemBenetitInfo,"^",2)+OutFeeTotal
	..s $p(EQItemBenetitInfo,"^",3)=$p(EQItemBenetitInfo,"^",3)+EquipConut
	.;科室效益汇总
	.s LocEQItemBAInfo=InComeTotal_"^"_OutFeeTotal_"^"_EquipConut
	.i ('$d(^TempDHCEQ(nodestr,"LocItemBenefit",Date,Job,CurUserID,TItemDR,TStoreLocDR)))  d
	..s ^TempDHCEQ(nodestr,"LocItemBenefit",Date,Job,CurUserID,TItemDR,TStoreLocDR)=LocEQItemBAInfo
	.e  d
	..s LocEQItemBAInfo=$g(^TempDHCEQ(nodestr,"LocItemBenefit",Date,Job,CurUserID,TItemDR,TStoreLocDR))
	..s $p(LocEQItemBAInfo,"^",1)=$p(LocEQItemBAInfo,"^",1)+InComeTotal
	..s $p(LocEQItemBAInfo,"^",2)=$p(LocEQItemBAInfo,"^",2)+OutFeeTotal
	..s $p(LocEQItemBAInfo,"^",3)=$p(LocEQItemBAInfo,"^",3)+EquipConut
}

/// Add By czf 2021-09-20
/// 描述:获取效益设备的设备项关键词列表
/// 入参:vSQLCODE 错误代码
/// 	vData 错误信息
/// 返回值:JSON格式串{"SQLCODE":错误代码,"Data":错误信息}
/// w ##class(web.DHCEQ.BA.RPTCommon).GetBAEQItemKeyWords()
ClassMethod GetBAEQItemKeyWords(AllFlag As %String = "")
{
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ReturnData="["
	s node="web.DHCEQ.BA.RPTCommon_GetBAEQItemKeyWords"
	s Date=+$h
	s Job=$J
	k ^TempDHCEQ(node)
	
	s rowid=0
	f  s rowid=$o(^DHCEQBenefitEquipList(rowid))  q:rowid=""  d
	.s EquipID=$p($g(^DHCEQBenefitEquipList(rowid)),"^",1)
	.q:EquipID=""
	.s TStoreLocDR=$p($g(^DHCEQEquip(EquipID)),"^",67)
	.q:TStoreLocDR=""
	.;q:##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID)'=0
	.s TInvalidFlag=$p($g(^DHCEQEquip(EquipID)),"^",59)="Y"
	.s StockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s TStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)
	.q:TStatus'=1
	.s TItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
	.q:TItemDR=""
	.s TIsStandard=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",21)
	.i TIsStandard="N"  d
	..s TItemDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",22)
	.e  d
	..s TItemDR=TItemDR
	.s ^TempDHCEQ(node,Date,Job,TItemDR)=""
	
	s CommonSItemIDs=##class(web.DHCEQCommon).GetSysInfo("990088")
	s CountNum=0
	s TItemDR=""
	f  s TItemDR=$o(^TempDHCEQ(node,Date,Job,TItemDR)) q:TItemDR=""  d
	.;q:CountNum>20
	.q:(AllFlag'="Y")&&((","_CommonSItemIDs_",")'[(","_TItemDR_","))
	.s CountNum=CountNum+1
	.s TItem=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
	.i ReturnData'="["  d
	..s ReturnData=ReturnData_","
	.s ReturnData=ReturnData_"{text:'"_TItem_"',id:'"_TItemDR_"'}"
	
	s ReturnData=ReturnData_"]"
	d ReturnInfo.%Set("Data",ReturnData)
	q ReturnInfo.%ToJSON()
}

/// Add By ZX 2021-09-22
/// 获取设备经济预测信息
/// Input：ECEquipID:设备id, ECMonth:统计月份
/// 	nodestr:临时global节点名，不同界面应用不用的nodestr
/// w ##class(web.DHCEQ.BA.RPTCommon).GetEconCalc("13","2021")
ClassMethod GetEconCalc(ECEquipID, ECYear)
{
	s (ECWorkLoadNum,ECServiceIncome,ECMaterialIncome,ECMaintFee,ECFeeOfEmployee,ECMaterialFee)=0
	s BuyRequestListID=""
	s OpenCheckListID=$p($g(^DHCEQEquip(ECEquipID)),"^",77)  //1:合同 2:招标 3:计划
	i OpenCheckListID="" q "0^0^0^0^0" //无验收单为导入设备
	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",63)  //来源类型
	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",64)  //来源ID
	i OCLSourceID="" q "0^0^0^0^0"
	i OCLSourceType="3" d
	.//来源采购计划
	.s BuyPlanListID=OCLSourceID
	.d GetEconCalcByBuyPlan
	i OCLSourceType="2" d
	.//来源招标
	.s IFBBagID=OCLSourceID
	.d GetEconCalcByIFB
	i OCLSourceType="1" d
	.//来源合同
	.s ContractListID=OCLSourceID
	.d GetEconCalcByContract
	
	i BuyRequestListID'="" d
	.s EconCalcID=0
	.f  s EconCalcID=$o(^DHCEQEconCalc(0,"Source","1",BuyRequestListID,"Y",EconCalcID)) q:EconCalcID=""  d
	..q:$p($g(^DHCEQEconCalc(EconCalcID)),"^",5)'=ECYear
	..s ECWorkLoadNum=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEconCalc(EconCalcID)),"^",8)/12,"",2)
	..s ECServiceIncome=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEconCalc(EconCalcID)),"^",6)/12,"",2)
	..s ECMaterialIncome=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEconCalc(EconCalcID)),"^",7)/12,"",2)
	..s ECMaintFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEconCalc(EconCalcID)),"^",15)/12,"",2)
	..s ECFeeOfEmployee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEconCalc(EconCalcID)),"^",9)/12,"",2)
	..s ECMaterialFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEconCalc(EconCalcID)),"^",10)/12,"",2)
	q ECWorkLoadNum_"^"_ECServiceIncome_"^"_ECMaterialIncome_"^"_ECMaintFee_"^"_ECFeeOfEmployee_"^"_ECMaterialFee
	
GetEconCalcByContract
	s ConListSourceType=$p($g(^DHCEQContractList(ContractListID)),"^",5)
	s ConListSourceID=$p($g(^DHCEQContractList(ContractListID)),"^",17)
	i ConListSourceType="1" d
	.//1:计划
	.d GetEconCalcByBuyPlan
	e  i ConListSourceType=2 d
	.//2:招标
	.d GetEconCalcByIFB
	quit
	
GetEconCalcByIFB
	s IFBSourceType=$p($g(^DHCEQIFBBag(IFBBagID)),"^",9)
	s IFBSourceID=$p($g(^DHCEQIFBBag(IFBBagID)),"^",10)
	i IFBSourceType="" d
	.//1:采购申请
	.s BuyRequestListID=IFBSourceID
	e  i IFBSourceType=2 d
	.//2:采购计划
	.s BuyPlanListID=IFBSourceID
	.d GetEconCalcByBuyPlan
	quit
	
GetEconCalcByBuyPlan
	s BuyPlanID=$p($g(^DHCEQBuyPlanList(BuyPlanListID)),"^",1)
	q:(BuyPlanID'="")&&($p($g(^DHCEQBuyPlan(BuyPlanID)),"^",46)="Y")	
	s BuyRequestListID=$p($g(^DHCEQBuyPlanList(BuyPlanListID)),"^",10)
	quit
}

}
