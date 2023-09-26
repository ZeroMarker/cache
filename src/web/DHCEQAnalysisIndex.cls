Class web.DHCEQAnalysisIndex Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 设备完好率 设备完好率=（1-当月维修时间/当月天数）  
/// 当月维修时间=维修完成日期-维修受理日期。（跨月时，维修时间分开计算）
/// w ##Class(web.DHCEQAnalysisIndex).IntractRate(4,"2015-01")
ClassMethod IntractRate(EquipID, MonthStr)
{
	new MRRowID,MaintDays,MRStart,MREnd,CurMaintDay,flag,IntactRate 
	s startdate=+##Class(web.DHCEQBenefitAnalyReport).StartDate(MonthStr)
	s enddate=+##Class(web.DHCEQBenefitAnalyReport).EndDate(MonthStr)
    s MonthDays=enddate-startdate //总天数
	s (MRRowID,MaintDays)=0 //故障天数
	f  s MRRowID=$o(^DHCEQMaintRequest(0,"Equip",EquipID,MRRowID))  quit:MRRowID=""  d
	.s (MRStart,MREnd,CurMaintDay)=0
	.quit:$p($g(^DHCEQMaintRequest(MRRowID)),"^",47)="Y"
	.s MRStart=+$p($g(^DHCEQMaintRequest(MRRowID)),"^",16)
	.s MREnd=+$p($g(^DHCEQMaintRequest(MRRowID)),"^",11)
	.quit:(MRStart>enddate)||(MREnd<startdate) //过滤维修时间不在这个区间内的
	.s flag=1 //(+1处理维修当天的情况,开始日期和结束日期一样,所以的加一天)
	.i MRStart<=startdate d
	..s MRStart=startdate
	..s flag=0
	.i MREnd>enddate  d
	..s MREnd=enddate
	.s CurMaintDay=MREnd-MRStart+flag 
	.s MaintDays=MaintDays+CurMaintDay
    s IntactRate=##Class(web.DHCEQCommon).FormatNumber((1-(MaintDays/MonthDays))*100,"",2)
    quit IntactRate
}

/// 开机率
/// w ##Class(web.DHCEQAnalysisIndex).StartingRate(4,63552,63583)UtilizationRate
ClassMethod StartingRate(EquipID, MonthStr)
{
	new UsedDays,StartingRate,MonthDays
	s startdate=+##Class(web.DHCEQBenefitAnalyReport).StartDate(MonthStr)
	s enddate=+##Class(web.DHCEQBenefitAnalyReport).EndDate(MonthStr)
    s MonthDays=enddate-startdate //总天数
	s UsedDays=0
	s UseDate=startdate
	f  s UseDate=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,UseDate))  quit:(UseDate="")||(UseDate>enddate)  d
	.s UsedDays=UsedDays+1
	s StartingRate=##Class(web.DHCEQCommon).FormatNumber((UsedDays/MonthDays)*100,"",2)
	q StartingRate
}

/// 功能利用率
/// w ##Class(web.DHCEQAnalysisIndex).UtilizationRate(4,"2014-12")
ClassMethod UtilizationRate(EquipID, MonthStr)
{
	new UsedNums,TotalNum,UtilizationRate,URRowID
	s (UsedNums,TotalNum,UtilizationRate)=0
	s startdate=+##Class(web.DHCEQBenefitAnalyReport).StartDate(MonthStr)
	s enddate=+##Class(web.DHCEQBenefitAnalyReport).EndDate(MonthStr)
	d GetEquipServiceNum
	s UseDate=startdate
	f  s UseDate=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,UseDate))  quit:(UseDate="")||(UseDate>enddate)  d
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,UseDate,URRowID)) quit:URRowID=""  d
	..quit:$p($g(^DHCEQUseRecord(URRowID)),"^",20)="Y"
	..s UsedNums=UsedNums+1
	i TotalNum>0 s UtilizationRate=##Class(web.DHCEQCommon).FormatNumber((UsedNums/TotalNum)*100,"",2)
	q UtilizationRate_"^"_TotalNum_"^"_UsedNums
	
GetEquipServiceNum
	s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
	s ModelID=$p($g(^DHCEQEquip(EquipID)),"^",3)
	s ServiceID=0
	f  s ServiceID=$o(^DHCEQEquipService(0,"SourceService",1,EquipID,ServiceID))  quit:ServiceID=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquipService(0,"SourceService",1,EquipID,ServiceID,rowid))  quit:rowid=""  d
	..s InvalidFlag=$p($g(^DHCEQEquipService(rowid)),"^",9)
	..q:InvalidFlag="Y"
	..s TotalNum=TotalNum+1
	..;s TServiceRowID = rowid	//rowid
	..;s TModel=$p($g(^DHCEQEquipService(rowid)),"^",3)
	..;s TService=$p($g(^DHCEQEquipService(rowid)),"^",4)
	..;s ^DHCEQTemp("EquipService",curuser,TService)=TServiceRowID_"^"_TModel

	i ItemID'="" d
	.s ServiceID=0
	.f  s ServiceID=$o(^DHCEQEquipService(0,"SourceService",2,ItemID,ServiceID))  quit:ServiceID=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQEquipService(0,"SourceService",2,ItemID,ServiceID,rowid))  quit:rowid=""  d
	...s InvalidFlag=$p($g(^DHCEQEquipService(rowid)),"^",9)
	...q:InvalidFlag="Y"
	...s TModel=$p($g(^DHCEQEquipService(rowid)),"^",3)
	...q:(TModel'="")&&(TModel'=ModelDR)
	...s TotalNum=TotalNum+1
	...;q:$g(^DHCEQTemp("EquipServie",curuser,TService))'=""
	...;s TServiceRowID=rowid
	...;s TService=$p($g(^DHCEQEquipService(rowid)),"^",4)
	...;s ^DHCEQTemp("EquipService",curuser,TService)=TServiceRowID_"^"_TModel
	q
}

}
