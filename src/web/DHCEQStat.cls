/// ----------------------------------------------------
/// 修改人：ZY	2010-07-05 No ZY0023
/// 修改目的：增加设备分布统计
/// 修改内容：增加方法：StatisticalAnalysis
/// ----------------------------------------------------
/// 修改人：ZY	2009-05-19
/// 修改目的：增加设备分布统计报表ZY0002
/// 修改内容：增加方法：EquipDistribution，GetEquipDistributionReport
/// -----------------------------------------------
/// 修改人：MWZ 2017-05-09
/// 修改目的：增加设备完好率故障率润乾报表(按时间统计)
/// 修改内容：增加方法：FailureRate ,GetTimeByDateType
/// -----------------------------------------------
/// 创建人:jdl	2009-05-15  设备统计报表统一用类
Class web.DHCEQStat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 16;

/// ----------------------------------------------------
/// 修改人：ZY	2010-07-05 No ZY0023
/// 修改目的：增加设备分类包含子类的查找
/// ----------------------------------------------------
/// w ##class(web.DHCEQStat).StatisticalAnalysisByType(36,"FailureRateByTime","","","")
ClassMethod StatisticalAnalysisByType(EquipID, Type, Date, BeginDate, EndDate)
{
	///设备完好率，设备故障率计算方法更新 需求号：263510  Modify by MWZ 2016-09-28 Begin 
	s Num=""
	s Time=""
	if Type="Availability"
	{
		s SourceID=0
		f  s SourceID=$o(^DHCEQMMaintRequest(0,"Source","1",SourceID))  q:(SourceID="")||(Num'="")  d
		.s EQRowID=$Piece($Get(^DHCEQMExObj(SourceID)),"^",5)
		.q:EQRowID'=EquipID
		.s MRRowID=0
	    .f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source","1",SourceID,MRRowID)) q:(MRRowID="")||(Num'="")  d
		..s MRFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)  //InvalidFlag 
		..q:MRFlag="Y"
		..s Num=0
		
		i Num="" s Num=1
	}
	elseif Type="FailureRate"
	{
		s SourceID=0
		f  s SourceID=$o(^DHCEQMMaintRequest(0,"Source","1",SourceID))  q:SourceID=""  d
		.s EQRowID=$Piece($Get(^DHCEQMExObj(SourceID)),"^",5)
		.q:EQRowID'=EquipID
	    .s MRRowID=0
	    .f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source","1",SourceID,MRRowID)) q:MRRowID=""  d
	    ..s MaintDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",24)   //维修时间
	    ..s MRFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
	    ..q:MRFlag="Y"
	    ..q:(BeginDate'="")&&(MaintDate<BeginDate)
		..q:(EndDate'="")&&(MaintDate>EndDate)	
		..s Num=Num+1      //每台设备符合时间条件的维修次数 						
	}
	elseif Type="FailureRateByTime"   ///add by mwz 2017-05-09 增加统计故障时间和故障次数
	{
	    s SourceID=0
	    f  s SourceID=$o(^DHCEQMMaintRequest(0,"Source","1",SourceID))  q:SourceID=""  d
		.s EQRowID=$Piece($Get(^DHCEQMExObj(SourceID)),"^",5)
		.q:EQRowID'=EquipID
	    .s MRRowID=0
		.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source","1",SourceID,MRRowID)) q:MRRowID=""  d
		..s StartDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",43)    //modify by mwz 需求号：796234
		..s StartTime=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",44)   //modify by mwz 需求号：796234
		..s FinishDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",16)  //完成日期
		..s FinishTime=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",17)  //完成时间
		..s MRTime=##Class(web.DHCEQCommon).TimeDiff(StartDate,StartTime,FinishDate,FinishTime)
		..s MRTime=$p(MRTime,",",1)\3600
		..i (MRTime<1)&&(MRTime>=0) s MRTime=1     //add by mwz 2020-03-31 MWZ0031
		..s MRFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
		..q:MRFlag="Y"
		..q:(BeginDate'="")&&(StartDate<BeginDate)
		..q:(EndDate'="")&&(FinishDate>EndDate)
		..q:(FinishDate="")||(FinishTime="")
	    ..s Time=Time+MRTime
	    ..s Num=Num+1
	}
	elseif (Date'="")&((Type="InLimitYearsRate")||(Type="OverLimitYearsRate"))
	{
		s LimitYearsNum=$p($g(^DHCEQEquip(EquipID)),"^", 31) //使用年限
		;s Date=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
		s Date=$ZD(Date,4)
		s (Year,Month,Day,CurYear,CurMonth,CurDay,flag)=""
		s Day=$p(Date,"/",1)
		s Month=$p(Date,"/",2)
		s Year=$p(Date,"/",3)
		s New=$ZD($h,4)
		s CurDay=$p(New,"/",1)
		s CurMonth=$p(New,"/",2)
		s CurYear=$p(New,"/",3)
		s flag=LimitYearsNum*12-((CurYear-Year)*12+(CurMonth-Month))
		if (Type="InLimitYearsRate")&(flag>=0) s Num=1	//役龄设备;
		if (Type="OverLimitYearsRate")&(flag<0) s Num=1	//逾龄设备;
	}
	q Num_"^"_Time
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQStat","FailureRate","","","","","","","","","","2017-05-01","","")
Query FailureRate(QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", BeginDate As %String = "", EndDate As %String = "", DateFlag As %String = "", Type As %String = "") As %Query(ROWSPEC = "TUseLoc:%String,TEquipName:%String,TSumTime:%String,TTotalTime:%String,TNum:%String,TEQNo:%String") [ SqlProc ]
{
}

ClassMethod FailureRateExecute(ByRef qHandle As %Binary, QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", BeginDate As %String = "", EndDate As %String = "", DateFlag As %String = "", Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)	
	s Date=0
 	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")  
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  
 	i BeginDate="" s BeginDate=0
 	i EndDate="" s EndDate=+$H
	s Type="FailureRateByTime"
	i DateFlag'="" s DateFlag=##class(web.DHCEQCommon).TransValueFromPage(DateFlag,"bool")
	s rowid=0
	s CTBeginDate="" // add  by wl 2020-02-20 WL0055
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesFailureRate
	.i CTBeginDate'=""  s BeginDate=CTBeginDate  // add  by wl 2020-02-20 WL0055
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^", 59)		
	.q:InvalidFlag="Y"
	.s MasterItem=$p($g(^DHCEQEquip(rowid)),"^",7)   ///设备项
	.q:(MasterItemDR'="")&&(MasterItemDR'=MasterItem)
	.s EquipType=$p($g(^DHCEQEquip(rowid)),"^", 63) 	//设备类组
	.q:EquipType=""
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.s StatCat=$p($g(^DHCEQEquip(rowid)),"^", 75) 		//设备类型
	.q:StatCat=""
	.q:(StatCatDR'="")&&(StatCatDR'=StatCat)
	.s EquipCat=$p($g(^DHCEQEquip(rowid)),"^",4)     ///设备分类
	.q:EquipCat=""
	.q:(EquipCatDR'="")&&(EquipCatDR'=EquipCat)		// MZY0157	3455618		2023-03-29
	.q:##Class(web.DHCEQEquip).CheckEquipInBussType(rowid,34)=1    //add by mwz 20171123 需求号468623
	.s TEquipName=$p($g(^DHCEQEquip(rowid)),"^",1)  //设备名称
    .s TEQNo=$p($g(^DHCEQEquip(rowid)),"^",71)     ///设备编号
    .s UseLoc=$p($g(^DHCEQEquip(rowid)),"^", 67) //使用科室
	.q:(UseLocDR'="")&&(UseLocDR'=UseLoc)
	.i UseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	.;start by csj 20190827	统计开始日期小于入库日期则取入库日期 需求号:1006611
	.s InStockDate = $p($g(^DHCEQEquip(rowid)),"^",45)
	.i InStockDate = "" s InStockDate=0
	.s CTBeginDate = BeginDate //add by wl 2020-02-20 WL0055
	.i BeginDate<InStockDate s BeginDate=InStockDate
	.;end by csj 20190827 
	.s Count=""
	.s Count=..StatisticalAnalysisByType(rowid, Type, Date, BeginDate, EndDate)  //根据统计要求调用不同的统计算法
	.s Time=$p(Count,"^",2)  //设备故障时间
	.s TNum=$p(Count,"^",1)  //设备故障台次
	.q:(Time="")||(TNum="")
	.s DateTime=""
    .s DateTime=..GetTimeByDateType(Time, BeginDate, EndDate, DateFlag)
    .s TTotalTime=$p(DateTime,"^",1)
    .s TSumTime=$p(DateTime,"^",2)
	.d OutputRowFailureRate
    quit $$$OK
OutputRowFailureRate
	Set Data=$lb(TUseLoc,TEquipName,TSumTime,TTotalTime,TNum,TEQNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetVariablesFailureRate
	s (TUseLoc,TEquipName,TSumTime,TTotalTime,TNum,TEQNo)=""
	quit
}

ClassMethod FailureRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FailureRateExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FailureRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FailureRateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod EquipDistributionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipDistributionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod EquipDistributionExecute(ByRef qHandle As %Binary, MasterItemDR As %String = "", EquipTypeDR As %String = "", UseLocDR As %String = "", EquipCatDR As %String = "", StatCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", IncludeFlag As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid,RowNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^TEMPDHCEQ("StoreEquipDistribution")               //临时Global
 	k ^TEMPDHCEQ("DHCEQEquipDistribution")
	s index=2
	s rowid=0
	s TRow=0
	s Pnum=1 //临时Global的RowID
	s row=0
	s Count=0 //在用设备总数量
	s Amount=0 //在用设备总金额
	i IncludeFlag'="" s IncludeFlag=##class(web.DHCEQCommon).TransValueFromPage(IncludeFlag,"bool")
	s RowNum=2
	d BuildDataGetEquipDistribution
	Quit $$$OK
BuildDataGetEquipDistribution
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipDistribution
	.s Status=$p($g(^DHCEQEquip(rowid)),"^", 38) //状态
	.q:Status'=1
	.s OriginalFee=$p($g(^DHCEQEquip(rowid)),"^", 27) //设备原值
	.q:(MinValue'="")&&(OriginalFee<MinValue)
	.q:(MaxValue'="")&&(OriginalFee>MaxValue)
	.s UseLoc=$p($g(^DHCEQEquip(rowid)),"^", 19) //使用科室
	.q:(UseLocDR'="")&&(UseLocDR'=UseLoc)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc))) //2010-10-29 DJ
	.s EquipType=$p($g(^DHCEQEquip(rowid)),"^", 63) //设备类组
	.s EquipTypeIDS=##Class(web.DHCEQCommon).GetEquipTypesByGroup("")
	.s EquipTypeIDS="^"_EquipTypeIDS_"^"
	.q:EquipTypeIDS'[("^"_EquipType_"^")
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:EquipType=""
	.s StatCat=$p($g(^DHCEQEquip(rowid)),"^", 75) //设备类型
	.q:(StatCatDR'="")&&(StatCatDR'=StatCat)
	.q:StatCat=""
	.s EquipCat=$p($g(^DHCEQEquip(rowid)),"^",4)     ///设备分类
	.q:EquipCat=""
	.s passed=0
	.i (EquipCatDR'="")&(EquipCatDR'=EquipCat) d
	..i (IncludeFlag'="Y") d
	...s passed=0
	..e  d
	...s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,EquipCat)
	.e  d
	..s passed=1
	.q:passed=0
	.s MasterItem=$p($g(^DHCEQEquip(rowid)),"^",7)   ///设备项
	.q:(MasterItemDR'="")&&(MasterItemDR'=MasterItem)
	.s Count=Count+1
	.s Amount=Amount+OriginalFee
	.s data=$g(^TEMPDHCEQ("DHCEQEquipDistribution",$J,UseLoc,EquipType,StatCat))
	.s Qty=1+$p(data,"^",1)
	.s OriginalFee=OriginalFee+$p(data,"^",2)
	.s ^TEMPDHCEQ("DHCEQEquipDistribution",$J,UseLoc,EquipType,StatCat)=Qty_"^"_OriginalFee
	s UseLoc=""
	f  s UseLoc=$o(^TEMPDHCEQ("DHCEQEquipDistribution",$J,UseLoc)) quit:UseLoc=""  d
	.s EquipType=""
	.f  s EquipType=$o(^TEMPDHCEQ("DHCEQEquipDistribution",$J,UseLoc,EquipType)) quit:EquipType=""  d
	..s StatCat=""
	..f  s StatCat=$o(^TEMPDHCEQ("DHCEQEquipDistribution",$J,UseLoc,EquipType,StatCat)) quit:StatCat=""  d
	...s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...s TEquipType=$p($g( ^DHCEQCCode("DHCEQCEquipType",EquipType)),"^", 2)
	...s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^", 2)
	...s TCount=$p($g(^TEMPDHCEQ("DHCEQEquipDistribution",$J,UseLoc,EquipType,StatCat)),"^", 1)      //设备数量
	...s TCountPercent=##Class(web.DHCEQCommon).FormatNumber(TCount/Count*100,"",2)_"%"                          //设备数量占比
	...s TAmountFee=$p($g(^TEMPDHCEQ("DHCEQEquipDistribution",$J,UseLoc,EquipType,StatCat)),"^", 2)    //设备金额
	...s TAmountFee=##Class(web.DHCEQCommon).FormatNumber(TAmountFee,"",2)
	...s TAmountFeePercent=##Class(web.DHCEQCommon).FormatNumber(TAmountFee/Amount*100,"",2)_"%"
	...Set TRow=TRow+1
	...d OutputRowGetEquipDistribution
	d ResetVariablesGetEquipDistribution
	s index=1
	s RowNum=1
	s TRow="合计:"
	s TCount=Count
	s TAmountFee=##Class(web.DHCEQCommon).FormatNumber(Amount,"",2)
	;s TCountPercent="100%"
    ;s TAmountFeePercent="100%"
	d OutputRowGetEquipDistribution
	quit
OutputRowGetEquipDistribution
	s Data=$lb(TRowID,TUseLoc,TEquipType,TStatCat,TCount,TCountPercent,TAmountFee,TAmountFeePercent,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
    s ^TEMPDHCEQ("StoreEquipDistribution",User,$J,RowNum)=TRowID_"^"_TUseLoc_"^"_TEquipType_"^"_TStatCat_"^"_TCount_"^"_TCountPercent_"^"_TAmountFee_"^"_TAmountFeePercent_"^"_TRow
    s RowNum=RowNum+1
	quit
ResetVariablesGetEquipDistribution
	s (TRowID,TUseLoc,TEquipType,TStatCat,TCount,TCountPercent,TAmountFee,TAmountFeePercent)=""
	quit
}

ClassMethod EquipDistributionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipDistributionExecute ]
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

Query EquipDistribution(MasterItemDR As %String = "", EquipTypeDR As %String = "", UseLocDR As %String = "", EquipCatDR As %String = "", StatCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", IncludeFlag As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TUseLoc:%String,TEquipType:%String,TStatCat:%String,TCount:%String,TCountPercent:%String,TAmountFee:%String,TAmountFeePercent:%String,TRow:%String")
{
}

/***打印报表取数据**/
ClassMethod GetEquipDistributionReport(RowNum)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i RowNum=0 q $o(^TEMPDHCEQ("StoreEquipDistribution",User,$J,""),-1)
	q $g(^TEMPDHCEQ("StoreEquipDistribution",User,$J,RowNum))
}

/// ----------------------------------------------------
/// 修改人：ZY	2010-07-05 No ZY0023
/// 修改目的：增加设备分布统计
/// 修改内容：增加方法：StatisticalAnalysis
/// 设备完好率,设备故障率,逾龄设备率,役龄设备率
/// ----------------------------------------------------
Query StatisticalAnalysis(UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TUseLoc:%String,TQuantity:%String,TTotal:%String,TRate:%String,TRow:%String")
{
}

ClassMethod StatisticalAnalysisExecute(ByRef qHandle As %Binary, UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid,RowNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ##class(web.DHCEQCommon).KillTempGlobal("StatisticalAnalysis")               //临时Global
	s TRow=0
	s index=2
	s Quantity=0 	//统计的设备总数
	s Total=0 		//设备总数量
	i IncludeFlag'="" s IncludeFlag=##class(web.DHCEQCommon).TransValueFromPage(IncludeFlag,"bool")
	d BuildDataStatisticalAnalysis
	Quit $$$OK
BuildDataStatisticalAnalysis
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesStatisticalAnalysis
	.q:##Class(web.DHCEQEquip).CheckEquipInBussType(rowid,34)=1    //add by mwz 20171123 需求号468623
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^", 59)		//Add By DJ 2016-12-05
	.q:InvalidFlag="Y"
	.s Status=$p($g(^DHCEQEquip(rowid)),"^", 38) //状态
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^", 60)
	.q:'((StockStatus="1")&&(Status<=2))
	.s UseLoc=$p($g(^DHCEQEquip(rowid)),"^", 67) //使用科室
	.q:(UseLocDR'="")&&(UseLocDR'=UseLoc)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc))) //2010-10-29 DJ
	.s MasterItem=$p($g(^DHCEQEquip(rowid)),"^",7)   ///设备项
	.q:(MasterItemDR'="")&&(MasterItemDR'=MasterItem)
	.s OriginalFee=$p($g(^DHCEQEquip(rowid)),"^", 27) //设备原值
	.q:(MinValue'="")&&(OriginalFee<MinValue)
	.q:(MaxValue'="")&&(OriginalFee>MaxValue)
	.s EquipType=$p($g(^DHCEQEquip(rowid)),"^", 63) 	//设备类组
	.q:EquipType=""
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType)=1)
	.s StatCat=$p($g(^DHCEQEquip(rowid)),"^", 75) 		//设备类型
	.q:StatCat=""
	.q:(StatCatDR'="")&&(StatCatDR'=StatCat)
	.s EquipCat=$p($g(^DHCEQEquip(rowid)),"^",4)     ///设备分类
	.q:EquipCat=""
	.s passed=0
	.i (EquipCatDR'="")&(EquipCatDR'=EquipCat) d
	..i (IncludeFlag'="Y") d
	...s passed=0
	..e  d
	...s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,EquipCat)
	.e  d
	..s passed=1
	.q:passed=0
	.s TransAssetDate=$p($g(^DHCEQEquip(rowid)),"^", 45) //转资日期
	.s AddDate=$p($g(^DHCEQEquip(rowid)),"^", 53) //新增日期
	.s Date=""
	.s Date=TransAssetDate
	.i Date="" s Date=AddDate
	.q:(BeginInStockDate'="")&&(Date<BeginInStockDate)
	.q:(EndInStockDate'="")&&(Date>EndInStockDate)
	.s Total=Total+1								    //设备总数
	.s data=$g(^DHCEQTemp("StatisticalAnalysis",+$H,$J,Type,UseLoc))
	.s Qty=1+$p(data,"^",1)							    //单个科室的设备总数
	.s Count=""
	.s Count=+..StatisticalAnalysisByType(rowid, Type, Date, BeginDate, EndDate)  //根据统计要求调用不同的统计算法
	.s Quantity=Quantity+Count							//统计的设备总数
	.s QtyNum=$p(data,"^",2)+Count						//单个科室的统计设备数
	.s ^DHCEQTemp("StatisticalAnalysis",+$H,$J,Type,UseLoc)=Qty_"^"_QtyNum
	
	s UseLoc=""
	f  s UseLoc=$o(^DHCEQTemp("StatisticalAnalysis",+$H,$J,Type,UseLoc)) quit:UseLoc=""  d
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	.s TTotal=$p($g(^DHCEQTemp("StatisticalAnalysis",+$H,$J,Type,UseLoc)),"^", 1)        //单个科室的设备数
	.s TQuantity=$p($g(^DHCEQTemp("StatisticalAnalysis",+$H,$J,Type,UseLoc)),"^", 2)     //单个科室的统计设备数
	.i TTotal>0 s TRate=##Class(web.DHCEQCommon).FormatNumber(TQuantity/TTotal*100,"",2)_"%"                      //设备占比
	.Set TRow=TRow+1
	.d OutputRowStatisticalAnalysis
	
	d ResetVariablesStatisticalAnalysis
	s index=1
	s TRow="合计:"
	s TQuantity=Quantity
	s TTotal=Total
	i TTotal>0 s TRate=##Class(web.DHCEQCommon).FormatNumber(TQuantity/TTotal*100,"",2)_"%"
	d OutputRowStatisticalAnalysis
	quit
OutputRowStatisticalAnalysis
	Set Data=$lb(TUseLoc,TQuantity,TTotal,TRate,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesStatisticalAnalysis
	s (TUseLoc,TQuantity,TTotal,TRate)=""
	quit
}

ClassMethod StatisticalAnalysisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatisticalAnalysisExecute ]
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

ClassMethod StatisticalAnalysisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatisticalAnalysisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQStat","SubjectDetails","","","","")
Query SubjectDetails(EquipTypeDR As %String = "", BeginDate As %String = "", EndDate As %String = "", MinAmount As %String = "", MaxAmount As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TAuditDate:%String,TNo:%String,TEquipType:%String,TOriginalFee:%String,TQuantityNum:%String,TAmount:%String,TReturnNum:%String,TReturnOriginalFee:%String,TReturnEquipIDs:%String,TNum:%String,TEQOriginalFee:%String,TInEquipIDs:%String,TJob:%String")
{
}

ClassMethod SubjectDetailsExecute(ByRef qHandle As %Binary, EquipTypeDR As %String = "", BeginDate As %String = "", EndDate As %String = "", MinAmount As %String = "", MaxAmount As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ##Class(web.DHCEQCommon).KillTempGlobal("SubjectDetails")
	Set index=1
	Set PNum=1
	Set TJob=$J
	if BeginDate="" Set BeginDate=0
	if EndDate="" Set EndDate=+$h
	if MinAmount="" Set MinAmount=0
	
	//入库单
	Set ISNo=0
	For  Set ISNo=$Order(^DHCEQInStock(0,"InStockNo",ISNo))  Quit:ISNo=""  Do
	.Set ISID=0
	.For  Set ISID=$Order(^DHCEQInStock(0,"InStockNo",ISNo,ISID))  Quit:ISID=""  Do
	..set Status=$Piece($Get(^DHCEQInStock(ISID)),"^",10)
	..q:Status'=2	//modified by zy 2011-02-18 ZY0058
	..Set TAuditDate=$Piece($Get(^DHCEQInStock(ISID)),"^",13)
	..quit:(TAuditDate<BeginDate)||(TAuditDate>EndDate)
	..if TAuditDate'="" Set TAuditDate=##class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	..Set TNo=$Piece($Get(^DHCEQInStock(ISID)),"^",14)
	..Set TEquipTypeID=$Piece($Get(^DHCEQInStock(ISID)),"^",20)
	..quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeID)
	..if TEquipTypeID'=""  set TEquipType=$p($g( ^DHCEQCCode("DHCEQCEquipType",TEquipTypeID)),"^", 2)
	..Set ISLID=0
	..For  Set ISLID=$Order(^DHCEQInStockList(0,"InStock",ISID,ISLID))  Quit:ISLID=""  Do
	...Do ResetVariablesSubjectDetails
	...Set TRowID = ISLID
	...Set TEquipName=$Piece($Get(^DHCEQInStockList(ISLID)),"^",5)
	...Set TOriginalFee=$Piece($Get(^DHCEQInStockList(ISLID)),"^",7)
	...Set TQuantityNum=$Piece($Get(^DHCEQInStockList(ISLID)),"^",8)
	...Set TAmount=TOriginalFee*TQuantityNum
	...Quit:((MaxAmount'="")&&(TAmount>MaxAmount))||(TAmount<MinAmount)
	...if $D(^DHCEQReturnList(0,"InStockList",ISLID))'=0 d
	....Set ReturnListDR=$order(^DHCEQReturnList(0,"InStockList",ISLID,""))
	....Set ReturnQtyNum=$Piece($Get(^DHCEQReturnList(ReturnListDR)),"^",5)			//批量退货数量
	....Set ReturnQtyFee=$Piece($Get(^DHCEQReturnList(ReturnListDR)),"^",6)			//批量退货金额
	...
	...Set EquipInfo=..GetEquipInfo(ISLID)
	...Set ReturnInfo=$Piece($Get(EquipInfo),"@",1)
	...Set InUsedInfo=$Piece($Get(EquipInfo),"@",2)
	...if ReturnInfo'="" do 	//退货的设备
	....//ReturnNum_"^"_ReturnOriginalFee_"^"_ReturnEquipID
	....Set TReturnNum=$Piece($Get(ReturnInfo),"^",1)
	....Set TReturnOriginalFee=$Piece($Get(ReturnInfo),"^",2)
	....Set TReturnEquipIDs=$Piece($Get(ReturnInfo),"^",3)
	...quit:(TQuantityNum=TReturnNum)&&(TAmount=TReturnOriginalFee)		//去掉入库明细和退货明细相等的
	...if InUsedInfo'="" do 	//在库的设备
	....//Num_"^"_OriginalFee_"^"_InEquipID
	....Set TNum=$Piece($Get(InUsedInfo),"^",1)
	....Set TEQOriginalFee=$Piece($Get(InUsedInfo),"^",2)
	....Set TInEquipIDs=$Piece($Get(InUsedInfo),"^",3)
	...Do OutputRowSubjectDetails
	
	//调账
	Set EquipID=0
	For  Set EquipID=$order(^DHCEQChangeAccount(0,"Equip",EquipID)) quit:EquipID=""  d
	.Set TEquipName=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
	.Set TEquipTypeID=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
	.quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeID)
	.if TEquipTypeID'=""  set TEquipType=$p($g( ^DHCEQCCode("DHCEQCEquipType",TEquipTypeID)),"^", 2)
	.Set CAID=0
	.For  Set CAID=$order(^DHCEQChangeAccount(0,"Equip",EquipID,CAID)) quit:CAID=""  d
	..Do ResetVariablesSubjectDetails
	..Set Stauts=$Piece($Get(^DHCEQChangeAccount(CAID)),"^",11)
	..quit:Stauts'="2"
	..Set TRowID=CAID
	..Set TNo=$Piece($Get(^DHCEQEquip(EquipID)),"^",71)
	..Set TEQOriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
		..Set TOriginalFee=$Piece($Get(^DHCEQChangeAccount(CAID)),"^",2)
		..Set TempTAmount=##class(web.DHCEQCommon).Abs(TOriginalFee)
	..Quit:((MaxAmount'="")&&(TempTAmount>MaxAmount))||(TempTAmount<MinAmount)
	..Set AuditDate=$Piece($Get(^DHCEQChangeAccount(CAID)),"^",22)
	..quit:(AuditDate<BeginDate)||(AuditDate>EndDate)
	..if AuditDate'="" Set TAuditDate=##class(web.DHCEQCommon).TransValueToPage(AuditDate,"date")
	..Set TQuantityNum="调账"
	..Do OutputRowSubjectDetails
	Quit $$$OK
OutputRowSubjectDetails
	Set Data=$lb(TRowID,TEquipName,TAuditDate,TNo,TEquipType,TOriginalFee,TQuantityNum,TAmount,TReturnNum,TReturnOriginalFee,TReturnEquipIDs,TNum,TEQOriginalFee,TInEquipIDs,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("SubjectDetails",+$H,TJob,PNum)=TEquipName_"^"_TAuditDate_"^"_TNo_"^"_TEquipType_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TAmount_"^"_TReturnNum_"^"_TReturnOriginalFee_"^"_TNum_"^"_TEQOriginalFee
	Set PNum=PNum+1
	Set index=index+1
	Quit
ResetVariablesSubjectDetails
	Set (TRowID,TOriginalFee,TQuantityNum,TAmount,TReturnNum,TReturnOriginalFee,TReturnEquipIDs,TNum,TOriginalFee,TInEquipIDs,ReturnQtyNum,ReturnQtyFee,TEQOriginalFee)=""
	Quit
}

ClassMethod SubjectDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SubjectDetailsExecute ]
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

ClassMethod SubjectDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SubjectDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQStat).GetEquipInfo(44)
ClassMethod GetEquipInfo(instocklistdr)
{
	new LocID,EquipID,ReturnNum,ReturnOriginalFee,ReturnEquipID,Num,InOriginalFee,InEquipID,OriginalFee,StockStatus
	if instocklistdr="" q ""
	set (ReturnNum,ReturnOriginalFee,ReturnEquipID,Num,InOriginalFee,InEquipID,OriginalFee,StockStatus)=""
	Set LocID=0
	for  Set LocID=$order(^DHCEQEquip(0,"InStockList",instocklistdr,LocID)) quit:LocID=""  d
	.s EquipID=0
	.for  Set EquipID=$order(^DHCEQEquip(0,"InStockList",instocklistdr,LocID,EquipID)) quit:EquipID=""  d
	..Set OriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
	..Set StockStatus=$Piece($Get(^DHCEQEquip(EquipID)),"^",60)
	..if StockStatus="3" do 			//出库||3
	...;if $D(^DHCEQReturnList(0,"Equip",EquipID,0))'=0  do
	...Set ReturnNum=ReturnNum+1
	...Set ReturnOriginalFee=ReturnOriginalFee+OriginalFee
	...Set ReturnEquipID=ReturnEquipID_","_EquipID
	..else  do
	...set Num=Num+1
	...set InOriginalFee=InOriginalFee+OriginalFee
	...Set InEquipID=InEquipID_","_EquipID
	
	q ReturnNum_"^"_ReturnOriginalFee_"^"_ReturnEquipID_"@"_Num_"^"_InOriginalFee_"^"_InEquipID
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQStat","SubjectDetailsList","","","","")
Query SubjectDetailsList(EquipIDs As %String = "", EquipTypeDR As %String = "", BeginDate As %String = "", EndDate As %String = "", MinAmount As %String = "", MaxAmount As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TAuditDate:%String,TNo:%String,TEquipType:%String,TOriginalFee:%String,TQuantityNum:%String,TAmount:%String,TReturnNum:%String,TReturnOriginalFee:%String,TReturnEquipIDs:%String,TNum:%String,TEQOriginalFee:%String,TInEquipIDs:%String,TJob:%String")
{
}

ClassMethod SubjectDetailsListExecute(ByRef qHandle As %Binary, EquipIDs As %String = "", EquipTypeDR As %String = "", BeginDate As %String = "", EndDate As %String = "", MinAmount As %String = "", MaxAmount As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
 	d ##Class(web.DHCEQCommon).KillTempGlobal("SubjectDetailsList")
	Set PNum=1
	Set TJob=$J
	if BeginDate="" Set BeginDate=0
	if EndDate="" Set EndDate=+$h
	if MinAmount="" Set MinAmount=0
	if EquipIDs'=""
	{
		Set Len=$l(EquipIDs,",")
		For i=1:1:Len do
		.Set EquipID=$Piece(EquipIDs,",",i)
		.Set (TAuditDate,TNo,TQuantityNum,TAmount,TReturnNum,TReturnOriginalFee,TReturnEquipIDs,TInEquipIDs)=""
		.Do ResetVariablesSubjectDetailsList
		.Quit:EquipID=""
		.Set TRowID=EquipID
		.Set TQuantityNum=1
		.Set TNum=1
		.Set TEquipName=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
		.Set TEQOriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
		.Set TAuditDate=$Piece($Get(^DHCEQEquip(EquipID)),"^",53)
		.if TAuditDate'="" Set TAuditDate=##class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
		.Set TEquipTypeID=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
		.quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeID)
		.if TEquipTypeID'=""  set TEquipType=$p($g( ^DHCEQCCode("DHCEQCEquipType",TEquipTypeID)),"^", 2)
		.Set TInStockListDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",70)
		.if TInStockListDR'="" Set TOriginalFee=$Piece($Get(^DHCEQInStockList(TInStockListDR)),"^",7)
		.Set TNo=$Piece($Get(^DHCEQEquip(EquipID)),"^",71)
		.Do OutputRowSubjectDetailsList
	}
	else
	{
		//入库单
		Set ISNo=0
		For  Set ISNo=$Order(^DHCEQInStock(0,"InStockNo",ISNo))  Quit:ISNo=""  Do
		.Set ISID=0
		.For  Set ISID=$Order(^DHCEQInStock(0,"InStockNo",ISNo,ISID))  Quit:ISID=""  Do
		..set Status=$Piece($Get(^DHCEQInStock(ISID)),"^",10)
		..q:Status'=2 	//modified by zy 2011-02-18 ZY0058
		..Set TAuditDate=$Piece($Get(^DHCEQInStock(ISID)),"^",13)
		..quit:(TAuditDate<BeginDate)||(TAuditDate>EndDate)
		..if TAuditDate'="" Set TAuditDate=##class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
		..Set TNo=$Piece($Get(^DHCEQInStock(ISID)),"^",14)
		..Set TEquipTypeID=$Piece($Get(^DHCEQInStock(ISID)),"^",20)
		..quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeID)
		..if TEquipTypeID'=""  set TEquipType=$p($g( ^DHCEQCCode("DHCEQCEquipType",TEquipTypeID)),"^", 2)
		..Set ISLID=0
		..For  Set ISLID=$Order(^DHCEQInStockList(0,"InStock",ISID,ISLID))  Quit:ISLID=""  Do
		...Do ResetVariablesSubjectDetailsList
		...Set TOriginalFee=$Piece($Get(^DHCEQInStockList(ISLID)),"^",7)
		...Set TQuantityNum=$Piece($Get(^DHCEQInStockList(ISLID)),"^",8)
		...if $D(^DHCEQReturnList(0,"InStockList",ISLID))'=0 d
		....Set ReturnListDR=$order(^DHCEQReturnList(0,"InStockList",ISLID,""))
		....Set ReturnQtyNum=$Piece($Get(^DHCEQReturnList(ReturnListDR)),"^",5)			//批量退货数量
		....Set ReturnQtyFee=$Piece($Get(^DHCEQReturnList(ReturnListDR)),"^",6)			//批量退货金额
		...Set EquipInfo=..GetEquipInfo(ISLID)
		...Set ReturnInfo=$Piece($Get(EquipInfo),"@",1)
		...Set InUsedInfo=$Piece($Get(EquipInfo),"@",2)
		...if ReturnInfo'="" do 	//退货的设备
		....//ReturnNum_"^"_ReturnOriginalFee_"^"_ReturnEquipID
		....Set TReturnNum=$Piece($Get(ReturnInfo),"^",1)
		....Set TReturnOriginalFee=$Piece($Get(ReturnInfo),"^",2)
		...quit:(TQuantityNum=TReturnNum)&&(TAmount=TReturnOriginalFee)		//去掉入库明细和退货明细相等的
		...if InUsedInfo'="" do 	//在库的设备
		....//Num_"^"_OriginalFee_"^"_InEquipID
		....Set TNum=$Piece($Get(InUsedInfo),"^",1)
		....Set EquipIDs=$Piece($Get(InUsedInfo),"^",3)
		....Set Len=$l(EquipIDs,",")
		....For i=1:1:Len do
		.....Set EquipID=$Piece(EquipIDs,",",i)
		.....Set (TRowID,TQuantityNum,TAmount)=""
		.....Set TQuantityNum=1
		.....Quit:EquipID=""
		.....Set TRowID=EquipID
		.....Set TNum=1
		.....Set TEquipName=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
		.....Set TEQOriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
		.....Quit:((MaxAmount'="")&&(TEQOriginalFee>MaxAmount))||(TEQOriginalFee<MinAmount)
		.....Set TNo=$Piece($Get(^DHCEQEquip(EquipID)),"^",71)
		.....Do OutputRowSubjectDetailsList
		
		//调账
		Set EquipID=0
		For  Set EquipID=$order(^DHCEQChangeAccount(0,"Equip",EquipID)) quit:EquipID=""  d
		.Set TEquipName=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
		.Set TEquipTypeID=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
		.quit:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeID)
		.if TEquipTypeID'=""  set TEquipType=$p($g( ^DHCEQCCode("DHCEQCEquipType",TEquipTypeID)),"^", 2)
		.Set CAID=0
		.For  Set CAID=$order(^DHCEQChangeAccount(0,"Equip",EquipID,CAID)) quit:CAID=""  d
		..Do ResetVariablesSubjectDetailsList
		..Set Stauts=$Piece($Get(^DHCEQChangeAccount(CAID)),"^",11)
		..quit:Stauts'="2" 
		..Set TNo=$Piece($Get(^DHCEQEquip(EquipID)),"^",71)
		..Set TEQOriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
		..Set TOriginalFee=$Piece($Get(^DHCEQChangeAccount(CAID)),"^",2)
		..Set TempTAmount=##class(web.DHCEQCommon).Abs(TOriginalFee)
		..Quit:((MaxAmount'="")&&(TempTAmount>MaxAmount))||(TempTAmount<MinAmount)
		..Set AuditDate=$Piece($Get(^DHCEQChangeAccount(CAID)),"^",22)
		..quit:(AuditDate<BeginDate)||(AuditDate>EndDate)
		..if AuditDate'="" Set TAuditDate=##class(web.DHCEQCommon).TransValueToPage(AuditDate,"date")
		..Set TQuantityNum="调账"
		..Do OutputRowSubjectDetailsList
	}
	Quit $$$OK
OutputRowSubjectDetailsList
	Set Data=$lb(TRowID,TEquipName,TAuditDate,TNo,TEquipType,TOriginalFee,TQuantityNum,TAmount,TReturnNum,TReturnOriginalFee,TReturnEquipIDs,TNum,TEQOriginalFee,TInEquipIDs,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("SubjectDetailsList",+$H,TJob,PNum)=TEquipName_"^"_TAuditDate_"^"_TNo_"^"_TEquipType_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TAmount_"^"_TReturnNum_"^"_TReturnOriginalFee_"^"_TNum_"^"_TEQOriginalFee
	Set PNum=PNum+1
	Set index=index+1
	Quit
ResetVariablesSubjectDetailsList
	Set (TRowID,TOriginalFee,TQuantityNum,TAmount,TReturnNum,TReturnOriginalFee,TReturnEquipIDs,TNum,TOriginalFee,TInEquipIDs,ReturnQtyNum,ReturnQtyFee,TEQOriginalFee)=""
	Quit
}

ClassMethod SubjectDetailsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SubjectDetailsListExecute ]
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

ClassMethod SubjectDetailsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SubjectDetailsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSubjectDetails(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("SubjectDetails",+$H,job,""),-1)
	q $g(^DHCEQTemp("SubjectDetails",+$H,job,PNum))
}

ClassMethod GetSubjectDetailsList(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("SubjectDetailsList",+$H,job,""),-1)
	q $g(^DHCEQTemp("SubjectDetailsList",+$H,job,PNum))
}

/// w ##Class(web.DHCEQStat).GetTimeByDateType("1723596","","","")
ClassMethod GetTimeByDateType(SumTime, BeginDate, EndDate, DateFlag)
{
    s FindDate=(EndDate-BeginDate+1)*24  //统计时间（小时）	MZY0119	2559041		2022-04-07
	i DateFlag="Y" d
	.s FindDate=EndDate-BeginDate   //统计时间（天数）
	.i SumTime#24'=0  s SumTime=SumTime\24+1
	.e  s SumTime=SumTime\24
	q FindDate_"^"_SumTime
}

/// 台账/快照导出 润乾/Kattle使用 
/// add by mwz 20210714 
/// 入参：pMonthStr 快照月份格式：yyyy-mm
/// d ##class(%ResultSet).RunQuery("web.DHCEQStat","SnapAllRunQian","2021-02")
/// Moedfied by zc0125 2022-11-17 增加TContratNo,TInvoiceNo,TOpenCheckRemark,TInStockRemark,TStoreMoveRemark输出
Query SnapAllRunQian(pMonthStr As %String = "") As %Query(ROWSPEC = "TRowID:%String,UseLocDR:%String,TUseLoc:%String,TEquipName:%String,TNum:%String,TEQNo:%String,TModel:%String,TCode:%String,TLimitYearsNum:%String,TOriginalFee:%String,TNetFee:%String,Tremainnetfee:%String,TDepreTotalFee:%String,TProvider:%String,TTransAssetDate:%String,TEquipType:%String,TBrand:%String,TEquipCat:%String,TStatCat:%String,TStartDate:%String,TEquipCat:%String,DepreTotal:%String,TUnit:%String,TDepreMethod:%String,TManuFactory:%String,TLeaveFactoryDate:%String,TLeaveFactoryNo:%String,TOrigin:%String,TCountry:%String,TManageUser:%String,TKeeper:%String,TRemark:%String,TPurposeType:%String,TServiceHandler:%String,TFundsStr:%String,TStatus:%String,TFileNo:%String,TBlank:%String,TLocType:%String,TMasterItem:%String,TFromDept:%String,TMemoryCode:%String,TAccountNo:%String,TOldLoc:%String,TRegisterNo:%String,TExpenditures:%String,TGuaranteePeriodNum:%String,TLiuBaMa:%String,THospital:%String,TContratNo:%String,TInvoiceNo:%String,TOpenCheckRemark:%String,TInStockRemark:%String,TStoreMoveRemark:%String") [ SqlProc ]
{
}

ClassMethod SnapAllRunQianExecute(ByRef qHandle As %Binary, pMonthStr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)	
 	s SnapID=""
 	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(pMonthStr)

 	s rowid=""
 	i SnapID=""  d
 	.f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
 	..d ResetVariablesSnapAllRunQian
 	..s EquipData=$g(^DHCEQEquip(rowid))
 	..d BuildDataList
 	e  d
 	.f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  q:rowid=""  d
 	..d ResetVariablesSnapAllRunQian
 	..s EquipData=$g(^DHCEQSnapShot(SnapID,"Equip",rowid))
 	..d BuildDataList
 	quit $$$OK
BuildDataList
	s TTransAssetDate=$p(EquipData,"^",45)   //入库日期
	s TTransAssetDate=$zd(TTransAssetDate,3)
	s TRowID=rowid
	s InvalidFlag=$p(EquipData,"^", 59)		
	q:InvalidFlag="Y"
	s TStatus=$p(EquipData,"^",38)
	q:(TStatus>2)
	s TStatus = $CASE(TStatus,"0":"在库","1":"启用","2":"停用","":"空")
	s TStockStatus=$p(EquipData,"^",60)
	q:(TStockStatus'=1)
	s Model=$p(EquipData,"^",3) 	//机型
	i Model'=""  s TModel=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	s TNum=1
	s TEQNo=$p(EquipData,"^",71) 		//设备编号
	s TCode=$p(EquipData,"^",6)		//编码(拼音码)
	s TEquipName=$p(EquipData,"^",1)  //设备名称
	s MasterItemDR=$p(EquipData,"^",7)
	s TMasterItem=##class(web.DHCEQCommon).GetTrakNameByID("masteritem", MasterItemDR)
	s TEquipTypeDR=$p(EquipData,"^", 63) //设备类组
	i TEquipTypeDR'="" s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatCatDR=$p(EquipData,"^", 75) //设备类型
	i TStatCatDR'="" s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipCatDR=$p(EquipData,"^",4)     //设备分类
	i TEquipCatDR'="" s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
 	s TOriginalFee=$p(EquipData,"^",27)		//原值
 	s TNetFee=$p(EquipData,"^",28)		//净值
 	s Tremainnetfee=$p(EquipData,"^",29)		//净残值
 	s TDepreTotalFee=$p(EquipData,"^",35)	//累计折旧
    s UseLocDR=$p(EquipData,"^", 67) //使用科室
    i UseLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
    s THospital=##Class(web.DHCEQCommon).GetHospitalDesc(UseLocDR)  //$p($g(^CTLOC(UseLoc)),"^",22)
    s TProviderDR=$p(EquipData,"^",25)	//供应商
    i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    s TLimitYearsNum=$p(EquipData,"^",31)	//使用年限
    s TBrandDR=$p(EquipData,"^",94)
	i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
	s DepreSetID=$o(^DHCEQDepreSet(0,"Source",1,0,rowid,0))   //默认主折旧
	s DepreTotal=$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)  //已折旧月数
	s TUnitDR = $p(EquipData,"^",5)
	i TUnitDR '=""  s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)  //单位
	s TStartDate=$p(EquipData,"^",44)   //启用日期
	s TStartDate=$zd(TStartDate,3)
	s TDepreMethodDR = $p(EquipData,"^",33)  //折旧方法
	i TDepreMethodDR '=""  s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TManuFactoryDR = $p(EquipData,"^",26)   //生产厂商
	i TManuFactoryDR '=""  s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	s TLeaveFactoryDate =$p(EquipData,"^",11)
	i TLeaveFactoryDate'="" s TLeaveFactoryDate=$zd(TLeaveFactoryDate,3)
	s TLeaveFactoryNo=$p(EquipData,"^",10)  //出厂日期
	s TOriginDR = $p(EquipData,"^",20)
	s TOrigin=""
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	s TCountryDR = $p(EquipData,"^",16)
	i TCountryDR '=""  d
	.s TCountry = ##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)  	
	s TManageUserDR = $p(EquipData,"^",39)
	i TManageUserDR '=""  d
	.s TManageUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	s TKeeperDR = $p(EquipData,"^",66)
	i TKeeperDR '=""  d
	.s TKeeper = $p($g(^SSU("SSUSR",TKeeperDR)),"^",2)
	s TRemark = $p(EquipData,"^",34)
	s TPurposeTypeDR = $p(EquipData,"^",65)
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TServiceHandler = $p(EquipData,"^",72)
	i TServiceHandler'="" s TServiceHandler=$p($g(^DHCEQCCode("DHCEQCLocation",TServiceHandler)),"^",2)
	s TFileNo=$p(EquipData,"^",85)
	s TFundsStr=..GetFundsInfo(1,rowid)
	s TFromDeptDR = $p(EquipData,"^",21)
	i TFromDeptDR'="" s TFromDept=$p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	s TMemoryCode=$p(EquipData,"^",61)
	s TAccountNo=$p(EquipData,"^",90)  
	s TOldLoc=$p(EquipData,"^",79)  
	s TRegisterNo=$p(EquipData,"^",92)  
	s TExpendituresDR=$p(EquipData,"^",95) 
	i TExpendituresDR'="" s TExpenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TExpendituresDR)),"^",2)
	s TGuaranteePeriodNum = $p(EquipData,"^",73)
	s TLiuBaMa=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",MasterItemDR)),"^",10)
	s TBlank=""
	//Modefied by zc0125 2022-11-17 增加验收备注、入库备注、出库备注、发票号、合同号等信息导出 begin
	s TContratNo=$p(EquipData,"^",76)
	s TInstocklistDR=$p(EquipData,"^",70)
	i TInstocklistDR'="" d
	.s TInvoiceNo=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,TInstocklistDR),"^",1)
	.s TInStockRemark=$p($g(^DHCEQInStockList(TInstocklistDR)),"^",12)
	s TOpenCheckListDR=$p(EquipData,"^",77)
	i TOpenCheckListDR'="" s TOpenCheckRemark=$p($g(^DHCEQOpenCheckList(TOpenCheckListDR)),"^",34)
	s TStoreMoveRemark=##Class(web.DHCEQStat).GetStoreMoveRemark(rowid)
	//Modefied by zc0125 2022-11-17 增加验收备注、入库备注、出库备注、发票号、合同号等信息导出 end
	d OutputRowSnapAllRunQian
	quit
OutputRowSnapAllRunQian
	Set Data=$lb(TRowID,UseLocDR,TUseLoc,TEquipName,TNum,TEQNo,TModel,TCode,TLimitYearsNum,TOriginalFee,TNetFee,Tremainnetfee,TDepreTotalFee,TProvider,TTransAssetDate,TEquipType,TBrand,TEquipCat,TStatCat,TStartDate,TEquipCat,DepreTotal,TUnit,TDepreMethod,TManuFactory,TLeaveFactoryDate,TLeaveFactoryNo,TOrigin,TCountry,TManageUser,TKeeper,TRemark,TPurposeType,TServiceHandler,TFundsStr,TStatus,TFileNo,TBlank,TLocType,TMasterItem,TFromDeptDR,TMemoryCode,TAccountNo,TOldLoc,TRegisterNo,TExpenditures,TGuaranteePeriodNum,TLiuBaMa,THospital,TContratNo,TInvoiceNo,TOpenCheckRemark,TInStockRemark,TStoreMoveRemark)  //Moedfied by zc0125 2022-11-17 增加TContratNo,TInvoiceNo,TOpenCheckRemark,TInStockRemark,TStoreMoveRemark输出
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetVariablesSnapAllRunQian
	s (TRowID,UseLoc,TUseLoc,TEquipName,TNum,TEQNo,TModel,TCode,TLimitYearsNum,TOriginalFee,TNetFee,Tremainnetfee,TDepreTotalFee,TProvider,TTransAssetDate,TEquipType,TBrand,TEquipCat,TStatCat,TStartDate,TEquipCat,DepreTotal,TUnit,TDepreMethod,TManuFactory,TLeaveFactoryDate,TLeaveFactoryNo,TOrigin,TCountry,TManageUser,TKeeper,TRemark,TPurposeType,TServiceHandler,TFundsStr,TStatus,TFileNo,TBlank,TLocType,TMasterItem,TFromDeptDR,TFromDept,TMemoryCode,TAccountNo,TOldLoc,TRegisterNo,TExpendituresDR,TExpenditures,TGuaranteePeriodNum,TLiuBaMa,THospital,TContratNo,TInstocklistDR,TInStockRemark,TInvoiceNo,TOpenCheckListDR,TOpenCheckRemark,TStoreMoveRemark)=""   //Moedfied by zc0125 2022-11-17 增加TContratNo,TInstocklistDR,TInStockRemark,TInvoiceNo,TOpenCheckListDR,TOpenCheckRemark,TStoreMoveRemark初始化
	quit
}

ClassMethod SnapAllRunQianClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SnapAllRunQianExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SnapAllRunQianFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SnapAllRunQianExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据条件获取资金来源的金额
/// 入参:FromType来源类型：1设备  2  附件  
/// 		FromID：对应ID
/// 返回：1资金来源=金额:累计折旧;2资金来源=金额:累计折旧
/// w ##Class(web.DHCEQStat).GetFundsInfo(2,6000)
ClassMethod GetFundsInfo(FromType, FromID)
{
	n (FromType,FromID)
	s FundsStr=""
	s Amount=0
	i FromType=1 s NodeStr="Equip"
	i FromType=2 s NodeStr="Affix"	
	
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	
	s FRowID=0
	f  s FRowID=$o(^DHCEQFunds("0",NodeStr,FromID,FRowID))  q:FRowID=""  d
	.q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
	.s Funds=$p($g(^DHCEQFunds(FRowID)),"^",2)
	.i Funds'=""  d
	..s Funds=$p($g(^DHCEQCCode("DHCEQCFundsType",Funds)),"^",2)
	..s FundsDepre=$p($g(^DHCEQFunds(FRowID)),"^",13)
	..i +FundsDepre'=0 s Funds=Funds_"="_$p($g(^DHCEQFunds(FRowID)),"^",3)_":"_FundsDepre
	..e  s Funds=Funds_"="_$p($g(^DHCEQFunds(FRowID)),"^",3)
	.i FundsStr=""  d
	..s FundsStr=Funds
	.e  d
	..s FundsStr=FundsStr_","_Funds
	
	i FundsStr=""
	{
		s Funds=$p($g(^DHCEQCCode("DHCEQCFundsType",SelfFundsFlag)),"^",2)
		i FromType=1 
		{
			s Fee=$p($g(^DHCEQEquip(FromID)),"^",27)
			s FundsStr=Funds_"="_Fee
		}
		i FromType=2
		{
			s Qty=$p($g(^DHCEQAffix(FromID)),"^",7)
			s Fee=$p($g(^DHCEQAffix(FromID)),"^",11)
			s FundsStr=Funds_"="_(Qty*Fee)_":"
		}
	}
	q FundsStr
}

/// Modefied by zc0125 2022-11-17 获取转移备注
/// w ##Class(web.DHCEQStat).GetStoreMoveRemark("1")
ClassMethod GetStoreMoveRemark(vEquipDR)
{
	i vEquipDR="" q ""
	s MaxSMLRowID=0
	s vCSRowID=0
	f  s vCSRowID=$o(^DHCEQChangeStock(0,"Equip",vEquipDR,vCSRowID)) q:vCSRowID=""  d
	.q:$p($g(^DHCEQChangeStock(vCSRowID)),"^",5)'=1
	.s SMLRowID=$p($g(^DHCEQChangeStock(vCSRowID)),"^",4)
	.s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)'=0
	.i SMLRowID>MaxSMLRowID d
	..s MaxSMLRowID=SMLRowID
	i +MaxSMLRowID=0 q ""
	i +MaxSMLRowID>0 q $p($g(^DHCEQStoreMoveList(MaxSMLRowID)),"^",11)
}

}
