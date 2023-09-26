/// -------------------------------
/// 修改: DJ 2012-02-01 DJ0103
/// 描述:月报调整数据取值节点错误及缺少调整数据汇总
/// -------------------------------
/// 修改：jdl 2009-08-4 JDL0021
/// 增加方法:SaveStatNew,FillStatListInfo,SaveStatListInfoNew
/// 修改方法：
/// 描述:重新整理设备月结
/// -------------------------------
Class web.DHCEQReport Extends (%Library.RegisteredObject, web.DHCEQCommon) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 585;

/// listInfo=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_ChangeAccount
Parameter ListInfoInit = "0^0^0^0^0^0^0^0^0^0^0^0^0^0^0";

/*
ClassMethod GetOneLocUsedDetail(StartDate, EndDate, ValStatCat, Loc)
{
	//s StartDate=..GetReportDate(MonthStr,1)
	//s EndDate=..GetReportDate(MonthStr,2)
	new StatCatValue
	s i=$L(ValStatCat,",")
	s StatCatValue=0
	s ReturnValue=0
	s DRValue=0
	for j=1:1:i-1
	{
		s StatCatValue=StatCatValue_",0"
	}
	for Date=StartDate:1:EndDate
	{
		s SMRowID=0
		f  s SMRowID=$o(^DHCEQStoreMove(0,"ToLocInDate",Loc,Date,"0","3",SMRowID))  q:SMRowID=""  d
		.s StatCat=$p(^DHCEQStoreMove(SMRowID),"^",17)
		.s StatCatValue=..UpdateStatCatValue(StatCatValue,ValStatCat,StatCat,SMRowID)
		s SMRowID=0
		f  s SMRowID=$o(^DHCEQStoreMove(0,"ToLocInDate",Loc,Date,"1","3",SMRowID))  q:SMRowID=""  d
		.s StatCat=$p(^DHCEQStoreMove(SMRowID),"^",17)
		.s StatCatValue=..UpdateStatCatValue(StatCatValue,ValStatCat,StatCat,SMRowID)
		s SMRowID=0
		f  s SMRowID=$o(^DHCEQStoreMove(0,"FromLocInDate",Loc,Date,"3","3",SMRowID))  q:SMRowID=""  d
		.s ReturnValue=ReturnValue+..GetSMTotalFee(SMRowID)
		s DRRowID=0
		f  s DRRowID=$o(^DHCEQDisuseRequest(0,"RequestLocDate",Loc,Date,"2",DRRowID)) q:DRRowID=""  d
		.
		.s EquipFee=##Class(web.DHCEQDisuseRequest).GetDisuseFeeByRequest(DRRowID)
		.
		.///s EquipID=$P(^DHCEQDisuseRequest(DRRowID),"^",1)
		.///s EquipFee=$P(^DHCEQEquip(EquipID),"^",27)
		.///i EquipFee="" S EquipFee=0
		.s DRValue=DRValue+EquipFee
	}
	s StatCatValue=..StatCatValueAddAppendFee(StartDate, EndDate, Loc, StatCatValue, ValStatCat)
	q StatCatValue_"^"_DRValue_"^"_ReturnValue
}

ClassMethod StatCatValueAddAppendFee(StartDate, EndDate, Loc, StatCatValue, ValStatCat)
{
	new OutAppendFee,i,j,k,StatCatID
	s i=$L(ValStatCat,",")
	s k=0
	for j=1:1:i
	{
		s StatCatID=$P(ValStatCat,",",j)
		s OutAppendFee=..GetMonthAppendFee(StartDate, EndDate,StatCatID ,Loc,"2")
		s StatCatValue=..UpdateStatCatValueByFee(StatCatValue,ValStatCat,StatCatID,OutAppendFee)
	}
	q StatCatValue
}

/// 根据增加金额修改
ClassMethod UpdateStatCatValueByFee(StatcatValue, ValStatCat, StatCat, Fee)
{
	new i,j,k,ValCat
	s i=$L(ValStatCat,",")
	s k=0
	for j=1:1:i
	{
		s ValCat=$P(ValStatCat,",",j)
		i ValCat=StatCat s k=j
	}
	i k>0
	{
		s $P(StatCatValue,",",k)=$P(StatCatValue,",",k)+Fee
	}
	q StatCatValue
}

/// 得到统计分类的金额
ClassMethod UpdateStatCatValue(StatCatValue, ValStatCat, StatCat, SMRowID)
{
	new TotalFee
	s TotalFee=..GetSMTotalFee(SMRowID)
	s StatCatValue=..UpdateStatCatValueByFee(StatCatValue,ValStatCat,StatCat,TotalFee)
	q StatCatValue
}
*/
/// 得到转移单据总金额
ClassMethod GetSMTotalFee(SMRowID)
{
	s SMLRowID=0
	i SMRowID="" q ""
	s Fee=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:SMLRowID=""  d
	.s QuantityNum=$P(^DHCEQStoreMoveList(SMLRowID),"^",8)
	.s OriginalFee=$P(^DHCEQStoreMoveList(SMLRowID),"^",7)
	.s Fee=Fee+(QuantityNum*OriginalFee)
	q Fee
}

/*

/// MonthStr月份,Type=1返回开始日期,Type=2返回结束日期
/// w ##Class(web.DHCEQReport).GetReportDate("2008-01",1)
ClassMethod GetReportDateOld(MonthStr, Type)
{
	new EndDateValue,Year,Month,EndDate,StartDate
	i (($p(MonthStr,"^",6)?4N1"-"1(2N,1N))&&($P($p(MonthStr,"^",6),"-",2)<=12)&&($P($p(MonthStr,"^",6),"-",2)>0)) q ""
	s MonthStr=##class(web.DHCEQMonthDepre).GetMonth(MonthStr)
	s EndDateValue=##class(web.DHCEQCommon).GetSysInfo("901002")
	s StartDateValue=##class(web.DHCEQCommon).GetSysInfo("901001")
	s Year=$P(MonthStr,"-",1)
	s Month=$P(MonthStr,"-",2)
	s EndDate=MonthStr_"-"_EndDateValue
	i Month="01"
	{
		s Year=Year-1
		s Month=12
	}
	else
	{
		s Month=Month-1
	}
	s StartDate=Year_"-"_Month_"-"_StartDateValue
	i Type=2
	{
		if EndDateValue="" q ..GetMonthDate(MonthStr,Type)
		q $ZD($ZDH(EndDate,3),4)
	}
	i Type=1 
	{
		if StartDateValue="" q ..GetMonthDate(MonthStr,Type)
		q $ZD($ZDH(StartDate,3),4)
	}
}
*/
/// MonthStr月份,Type=1返回开始日期,Type=2返回结束日期
/// w ##Class(web.DHCEQReport).GetMonthDate("2008-01",1)
ClassMethod GetMonthDate(MonthStr, Type)
{
	new getdate
	s Year=$P(MonthStr,"-",1)
	s Month=$P(MonthStr,"-",2)
	if (Type=1)
	{
		s getdate=Year_"-"_Month_"-01"
		s getdate=$ZDH(getdate,3)
	}
	else
	{
		if (Month=12)
		{
			s Year=+Year+1
			s Month="1"
		}
		else
		{
			s Month=+Month+1
		}
		s getdate=Year_"-"_Month_"-01"
		s getdate=$ZDH(getdate,3)-1
	}
	q $ZD(getdate,4)
}

/*
/// 得到领用明细的列表
Query GetUsedDetailMonthReport(ValStatCat, StartDate, EndDate, MonthStr) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,CatVal:%String,DRVal:%String,ReturnVal:%String,DepreFee:%String")
{
}

ClassMethod GetUsedDetailMonthReportExecute(ByRef qHandle As %Binary, ValStatCat, StartDate, EndDate, MonthStr) As %Status
{
 	new repid, index,rowid,DRValTotal,ReturnValTotal,CatValTotal,DepreTotal
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set MonthStr=##class(web.DHCEQMonthDepre).GetMonth(MonthStr)
 	s CatValTotal=0
 	s DRValTotal=0
 	s ReturnValTotal=0
 	s DepreTotal=0
 	s i=$l(ValStatCat,",")
 	for j=1:1:i-1
	{
		s CatValTotal=CatValTotal_",0"
	}
 	d ..KillTempGlobal("UsedDetail")
	s index=1
	s rowid=0
	d BuildDataGetUsedDetailMonthReport
	Quit $$$OK
BuildDataGetUsedDetailMonthReport
	q:(StartDate="")&&(EndDate="")
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.d ResetVariablesGetUsedDetailMonthReport
	.d GetOneUsedDetailMonthReport
	s LocID=0
	s LocDesc="总计:"
	s CatVal=CatValTotal
	s DRVal=DRValTotal
	s ReturnVal=ReturnValTotal
	s DepreVal=DepreTotal
	s ^DHCEQTemp("UsedDetail",+$H,$J,LocID)=LocDesc_"^"_CatVal_"^"_DRVal_"^"_ReturnVal_"^"_DepreVal
	d OutputRowGetUsedDetailMonthReport
	quit
GetOneUsedDetailMonthReport
	s LocID=rowid
	s LocDesc=..GetTrakNameByID("dept",LocID)
	s Val=..GetOneLocUsedDetail(StartDate, EndDate, ValStatCat, LocID)
	s CatVal=$p(Val,"^",1)
	s DRVal=$p(Val,"^",2)
	s DRValTotal=DRValTotal+DRVal
	s ReturnVal=$p(Val,"^",3)
	s ReturnValTotal=ReturnValTotal+ReturnVal
	s CatAddVal=0
	for j=1:1:i
	{
		s CatAddVal=CatAddVal+$p(CatVal,",",j)
		s $P(CatValTotal,",",j)=$P(CatValTotal,",",j)+$p(CatVal,",",j)
	}
	s DepreVal=..GetLocMonthDepreFee(LocID,MonthStr,"")
	s DepreTotal=DepreTotal+DepreVal
	q:(CatAddVal+DRVal+ReturnVal+DepreVal)=0
	s Val=LocDesc_"^"_Val_"^"_DepreVal
	s ^DHCEQTemp("UsedDetail",+$H,$J,LocID)=Val
	d OutputRowGetUsedDetailMonthReport
	quit
OutputRowGetUsedDetailMonthReport
	s Data=$lb(LocID,LocDesc,CatVal,DRVal,ReturnVal,DepreVal)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUsedDetailMonthReport
	s (Val,LocID,LocDesc,CatVal,DRVal,ReturnVal,DepreVal)=""
	quit
}

ClassMethod GetUsedDetailMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUsedDetailMonthReportExecute ]
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
*/
ClassMethod GetLocID()
{
	s LocIDs=""
	s LocID=0
	f  s LocID=$o(^DHCEQTemp("UsedDetail",+$H,$J,LocID)) q:LocID=""  d
	.s LocIDs=LocIDs_"^"_LocID
	s LocIDs=LocIDs_"^0"
	q $P(LocIDs,"^",2,$L(LocIDs,"^"))
}

ClassMethod GetOneDetail(LocID)
{
	i LocID="" q ""
	q $g(^DHCEQTemp("UsedDetail",+$H,$J,LocID))
}

ClassMethod GetOneStatCatReport(StatCatID)
{
	i StatCatID="" q ""
	q $g(^DHCEQTemp("StatMonth",+$H,$J,StatCatID))
}

/*
ClassMethod GetUsedDetailMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUsedDetailMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
/// 根据月份得到上一月份
/// w ##Class(web.DHCEQReport).GetPreMonth("2022-04-25")
ClassMethod GetPreMonth(MonthStr)
{
	new Month,Year,PreMonth
	s Year=$P(MonthStr,"-",1)
	s Month=$P(MonthStr,"-",2)
	i Month="01"
	{
		s Year=Year-1
		s Month=12
	}
	else
	{
		s Month=Month-1
	}
	s PreMonth=Year_"-"_Month
	s PreMonth=##class(web.DHCEQMonthDepre).GetMonth(PreMonth)
	q PreMonth
}

/*
/// 根据月份得到结存ID
ClassMethod GetSMSRowID(Month, ValStatCat)
{
	new SMSRowID
	i ValStatCat="" q ""
	s SMSRowID=$o(^DHCEQStoreMonthStat(0,"MonthStr",Month,ValStatCat,0))
	q SMSRowID
}

/// 根据月份，统计分类得到在库期初Type=1，在用期初Type=2
ClassMethod GetStatCatOpenFee(ValStatCat, Month, StatCatID, Type)
{
	new PreMonth,SMSLRowID,StockOpenFee,SMSRowID,UsedOpenFee
	s PreMonth=..GetPreMonth(Month)
	s SMSRowID=..GetSMSRowID(PreMonth,ValStatCat)
	i SMSRowID="" q 0
	s SMSLRowID=0
	s OpenFee=0
	s SMSLRowID=$o(^DHCEQStoreMonthStatList(0,"StoreMonthStatCat",PreMonth,StatCatID,0))
	if SMSLRowID="" q OpenFee
	if Type="1" 
	{
		s OpenFee=$P(^DHCEQStoreMonthStatList(SMSLRowID),"^",8)
	}
	if Type="2" 
	{
		s OpenFee=$P(^DHCEQStoreMonthStatList(SMSLRowID),"^",13)
	}
	i OpenFee="" s OpenFee=0
	q OpenFee
}

/// 判断该月份得报表是否保存2:已保存  1:上月保存  0:都未保存
ClassMethod DepreReportIsHad(Month, ValEquipType)
{
	new PreMonth,DMRID
	s DMRID=..GetDMRID(Month,ValEquipType)
	i DMRID'="" q 2
	s PreMonth=..GetPreMonth(Month)
	s DMRID=..GetDMRID(PreMonth,ValEquipType)
	i DMRID'="" q 1
	q 0
}

/// 判断该月份得报表是否保存2:已保存  1:上月保存  0:都未保存
ClassMethod IsHadFlagOld(Month, ValStatCat)
{
	new PreMonth,SMSRowID
	s SMSRowID=..GetSMSRowID(Month,ValStatCat)
	i SMSRowID'="" q 2
	s PreMonth=..GetPreMonth(Month)
	s SMSRowID=..GetSMSRowID(PreMonth,ValStatCat)
	i SMSRowID'="" q 1
	q 0
}

/// 判断该月份得报表是否保存2:已保存  1:上月保存  0:都未保存
ClassMethod IsHadFlag(Month, ValStatCat)
{
	new Year,Mon,PreYear,PreMonth
	s Year=+$p(Month,"-",1)
	s Mon=+$p(Month,"-",2)
	i $o(^DHCEQMonthReportList(0,"StatCat",Year,Mon,0))'="" q 2
	if (Mon=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Mon-1}
	i $o(^DHCEQMonthReportList(0,"StatCat",PreYear,PreMonth,0))'="" q 1	
	q 0
}

/// 得到折旧月报ID
ClassMethod GetDMRID(Month, ValEquipType)
{
	new DMRID
	s DMRID=$o(^DHCEQDepreMonthReport(0,"Month",Month,ValEquipType,0))
	q DMRID
}

ClassMethod GetDepreReportDate(Month, Type, ValEquipType)
{
	new PreMonth,DMRID,Date
	s Month=##class(web.DHCEQMonthDepre).GetMonth(Month)
	s DMRID=..GetDMRID(Month,ValEquipType)
	i DMRID=""
	{
		i Type="2" q ..GetReportDate(Month,Type)
		s PreMonth=..GetPreMonth(Month)
		s DMRID=..GetDMRID(PreMonth,ValEquipType)
		i DMRID="" q ..GetReportDate(Month,Type)
		s Date=$p(^DHCEQDepreMonthReport(DMRID),"^",3)
		s Date=Date+1
	}
	else
	{
		i Type="2"
		{
			s Date=$P(^DHCEQDepreMonthReport(DMRID),"^",3)
		}
		i Type="1"
		{
			s Date=$P(^DHCEQDepreMonthReport(DMRID),"^",2)
		}
	}
	q $ZD(Date,4)
}

/// 得到结存月报的起始日期Type=1开始日期，Type=2结束日期
ClassMethod GetPreEndDate(Month, Type, ValStatCat)
{
	new PreMonth,SMSRowID,StartDate
	s SMSRowID=..GetSMSRowID(Month,ValStatCat)
	i SMSRowID=""
	{
		i Type="2" q ..GetReportDate(Month,Type)
		i Type="1"
		{
			s PreMonth=..GetPreMonth(Month)
			s SMSRowID=..GetSMSRowID(PreMonth,ValStatCat)
			i SMSRowID="" q ..GetReportDate(Month,Type)
			s StartDate=$P(^DHCEQStoreMonthStat(SMSRowID),"^",3)
			s StartDate=StartDate+1
			q $ZD(StartDate,4)
		}
	}
	else
	{
		i Type="2"
		{
			s EndDate=$P(^DHCEQStoreMonthStat(SMSRowID),"^",3)
			q $ZD(EndDate,4)
		}
		i Type="1"
		{
			s StartDate=$P(^DHCEQStoreMonthStat(SMSRowID),"^",2)
			q $ZD(StartDate,4)
		}
	}
}
*/
/// 根据入库ID得到入库总金额
ClassMethod GetInStockTotalFee(ISRowID)
{
	new ISLRowID,Fee
	s ISLRowID=0
	i ISRowID="" q ""
	s Fee=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
	.s QuantityNum=$P(^DHCEQInStockList(ISLRowID),"^",8)
	.s OriginalFee=$P(^DHCEQInStockList(ISLRowID),"^",7)
	.s Fee=Fee+(QuantityNum*OriginalFee)
	q Fee
}

/*
/// 得到结存月报的本期入库
ClassMethod GetStatCatInFee(StartDate, EndDate, StatCatID, EquipTypeID)
{
	new Date,ISRowID,InFee,InsertStep,StatCat
	s InsertStep=##class(web.DHCEQCommon).GetSysInfo("901003")
	i InsertStep="0" d
	.s DateType="AuditDateStat"
	.s Step="2"
	i InsertStep="1" d
	.s DateType="BillDate"
	.s Step="3"
	s InFee=0
	for Date=StartDate:1:EndDate
	{
		i StatCatID'=""
		{
			s ISRowID=0
			f  s ISRowID=$o(^DHCEQInStock(0,DateType,Date,StatCatID,ISRowID)) q:ISRowID=""  d
			.s Status=$P(^DHCEQInStock(ISRowID),"^",10)
			.q:Status<Step
			.s InFee=InFee+..GetInStockTotalFee(ISRowID)
		}
		else
		{
			s StatCat=0
			f  s StatCat=$o(^DHCEQInStock(0,DateType,Date,StatCat)) q:StatCat=""  d
			.s ISRowID=0
			.f  s ISRowID=$o(^DHCEQInStock(0,DateType,Date,StatCat,ISRowID)) q:ISRowID=""  d
			..s Status=$P(^DHCEQInStock(ISRowID),"^",10)
			..q:Status<Step
			..s EquipType=$P(^DHCEQInStock(ISRowID),"^",20)
			..q:EquipType'=EquipTypeID
			..s InFee=InFee+..GetInStockTotalFee(ISRowID)
		}
	}
	q InFee
}
*/
/// 根据退货ID得到退货总金额
ClassMethod GetReturnTotalFee(RRowID)
{
	new RLRowID,Fee
	i RRowID="" q 0
	s RLRowID=0
	s Fee=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID)) q:RLRowID=""  d
	.s QuantityNum=$P(^DHCEQReturnList(RLRowID),"^",5)
	.s OriginalFee=$P(^DHCEQReturnList(RLRowID),"^",6)
	.s Fee=Fee+(QuantityNum*OriginalFee)
	q Fee
}

/*
/// 得到结存月报的本期退货
ClassMethod GetStatCatReturnFee(StartDate, EndDate, StatCatID, EquipTypeID)
{
	new Date,RRowID,ReturnFee,StatCat
	s ReturnFee=0
	for Date=StartDate:1:EndDate
	{
		i StatCatID'=""
		{
			s RRowID=0
			f  s RRowID=$o(^DHCEQReturn(0,"AckDateStat","3",Date,StatCatID,RRowID)) q:RRowID=""  d
			.s ReturnFee=ReturnFee+..GetReturnTotalFee(RRowID)
		}
		else
		{
			s StatCat=0
			f  s StatCat=$o(^DHCEQReturn(0,"AckDateStat","3",Date,StatCat)) q:StatCat=""  d
			.s RRowID=0
			.f  s RRowID=$o(^DHCEQReturn(0,"AckDateStat","3",Date,StatCat,RRowID)) q:RRowID=""  d
			..s EquipType=$p($g(^DHCEQReturn(RRowID)),"^",15)
			..q:EquipType'=EquipTypeID
			..s ReturnFee=ReturnFee+..GetReturnTotalFee(RRowID)
		}
	}
	q ReturnFee
}

/// 得到结存月报的本期报损
ClassMethod GetStatCatDRFee(StartDate, EndDate, StatCatID, EquipTypeID)
{
	new Date,DRRowID,DRFee,EquipID,EquipStat,EquipFee
	s DRFee=0
	for Date=StartDate:1:EndDate
	{
		s DRRowID=0
		f  s DRRowID=$O(^DHCEQDisuseRequest(0,"AuditDateStatus",Date,"2",DRRowID)) q:DRRowID=""  d
		.s EquipID=$p(^DHCEQDisuseRequest(DRRowID),"^",1)
		.i EquipID'=""  d
		..d AddDisuseFee
		.e  d
		..s DRListRowID=0
		..f  s DRListRowID=$O(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRListRowID)) q:DRListRowID=""  d
		...s EquipID=$p(^DHCEQDisuseRequestList(DRListRowID),"^",2)
		...i EquipID'=""  d AddDisuseFee
	}
	q DRFee
AddDisuseFee
	s EquipCatID=$p(^DHCEQEquip(EquipID),"^",75)
	q:(StatCatID'="")&&(EquipCatID'=StatCatID)
	s EquipType=$p(^DHCEQEquip(EquipID),"^",63)
	q:(EquipTypeID'="")&&(EquipType'=EquipTypeID)
	s EquipFee=$P(^DHCEQEquip(EquipID),"^",27)
	i EquipFee="" S EquipFee=0
	s DRFee=DRFee+EquipFee
	q
}

/// 得到折旧报表的报损折旧
ClassMethod GetDRDepreFee(StartDate, EndDate, Month, EquipTypeID)
{
	new Date,DRRowID,DRDepreFee,EquipID,EquipStat,OneDepreFee
	s DRDepreFee=0
	for Date=StartDate:1:EndDate
	{
		s DRRowID=0
		f  s DRRowID=$O(^DHCEQDisuseRequest(0,"AuditDateStatus",Date,"2",DRRowID)) q:DRRowID=""  d
		.s EquipID=$p(^DHCEQDisuseRequest(DRRowID),"^",1)
		.s EquipType=$p(^DHCEQEquip(EquipID),"^",63)
		.q:EquipTypeID'=EquipType
		.s MDID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipID,Month,0))
		.s OneDepreFee=$p(DHCEQMonthDepre(MDID),"^",14)
		.s DRDepreFee=DRDepreFee+OneDepreFee
	}
	q DRDepreFee
}

/// 得到结存月报的本期出库(在用领用)
ClassMethod GetStatCatOutFee(StartDate, EndDate, StatCatID)
{
	new Date,SMRowID,OutFee
	s OutFee=0
	for Date=StartDate:1:EndDate
	{
		s SMRowID=0
		f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat","3",Date,StatCatID,"0",SMRowID)) q:SMRowID=""  d
		.s OutFee=OutFee+..GetSMTotalFee(SMRowID)
	}
	q OutFee
}

/// 得到结存月报的本期退库(在用退库)
ClassMethod GetStatCatRefundFee(StartDate, EndDate, StatCatID)
{
	new Date,SMRowID,RefundFee
	s RefundFee=0
	for Date=StartDate:1:EndDate
	{
		s SMRowID=0
		f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat","3",Date,StatCatID,"3",SMRowID)) q:SMRowID=""  d
		.s RefundFee=RefundFee+..GetSMTotalFee(SMRowID)
	}
	q RefundFee
}

/// 得到结存月报的在库期末
ClassMethod GetStoreEndFee(StoreOpenFee, InFee, OutFee, RefundFee, ReturnFee)
{
	//StoreOpenFee期初、InFee入库、OutFee出库、RefundFee退库、ReturnFee退货、
	new EndFee
	s EndFee=StoreOpenFee+InFee-OutFee+RefundFee-ReturnFee
	q EndFee
}

/// 得到结存月报的在用期末
ClassMethod GetUsedEndFee(UsedOpenFee, OutFee, DRFee, RefundFee)
{
	//UsedOpenFee期初、OutFee领用、DRFee报损、RefundFee退库
	new EndFee
	s EndFee=UsedOpenFee+OutFee-DRFee-RefundFee
	q EndFee
}

/// 得到结存月报期末总计
ClassMethod GetTotalEndFee(StoreEndFee, UsedEndFee)
{
	new EndFee
	s EndFee=StoreEndFee+UsedEndFee
	q EndFee
}

/// 得到结存月报的列表
Query GetStatMonthReport(ValStatCat, StartDate, EndDate, MonthStr) As %Query(ROWSPEC = "StatCatID:%String,StatCat:%String,StoreOpenFee:%String,InFee:%String,OutFee:%String,RefundFee:%String,ReturnFee:%String,StoreEndFee:%String,UsedOpenFee:%String,DRFee:%String,UsedEndFee:%String,TotalEndFee:%String,MonthStr:%String,StartDate:%String,EndDate:%String")
{
}

ClassMethod GetStatMonthReportExecute(ByRef qHandle As %Binary, ValStatCat, StartDate, EndDate, MonthStr) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ..KillTempGlobal("StatMonth")
 	s (StoreOpenFeeTotal,InFeeTotal,OutFeeTotal,RefundFeeTotal,ReturnFeeTotal)=0
	s (StoreEndFeeTotal,UsedOpenFeeTotal,DRFeeTotal,UsedEndFeeTotal,TotalEndFeeTotal)=0
	s index=1
	s rowid=0
	d BuildDataGetStatMonthReport
	Quit $$$OK
BuildDataGetStatMonthReport
	q:(StartDate="")&&(EndDate="")
	q:MonthStr=""
	s SMSID=$o(^DHCEQStoreMonthStat(0,"MonthStr",MonthStr,ValStatCat,0))
	i SMSID=""
	{
		if ValStatCat=""
		{
			f  s rowid=$o(^DHCEQCCode("DHCEQCStatCat",rowid)) q:rowid=""  d
			.s Flag=$p(^DHCEQCCode("DHCEQCStatCat",rowid),"^",4)
			.q:Flag="Y"
			.d ResetVariablesGetStatMonthReport
			.d GetOneStatMonthReport
		}
		else
		{
			s i=$L(ValStatCat,",")
			for j=1:1:i
			{
				s rowid=$p(ValStatCat,",",j)
				d ResetVariablesGetStatMonthReport
				d GetOneStatMonthReport
			}
		}
	}
	else
	{
		s SMSLID=0
		f  s SMSLID=$o(^DHCEQStoreMonthStatList(0,"StoreMonth",SMSID,SMSLID)) q:SMSLID=""  d
		.d ResetVariablesGetStatMonthReport
		.d GetOneStatMonthReportBySMSL
	}
	s StatCatID=0
	s StatCat="总计:"
	s StoreOpenFee=StoreOpenFeeTotal
	s InFee=InFeeTotal
	s OutFee=OutFeeTotal
	s RefundFee=RefundFeeTotal
	s ReturnFee=ReturnFeeTotal
	s StoreEndFee=StoreEndFeeTotal
	s UsedOpenFee=UsedOpenFeeTotal
	s DRFee=DRFeeTotal
	s UsedEndFee=UsedEndFeeTotal
	s TotalEndFee=TotalEndFeeTotal
	d SetGlobal
	quit
GetOneStatMonthReportBySMSL
	s StatCatID=$P(^DHCEQStoreMonthStatList(SMSLID),"^",2)
	s StatCat=$P(^DHCEQCCode("DHCEQCStatCat",StatCatID),"^",2)
	s StoreOpenFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",3)
	s InFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",4)
	s OutFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",5)
	s RefundFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",7)
	s ReturnFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",6)
	s StoreEndFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",8)
	s UsedOpenFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",9)
	s DRFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",11)
	s UsedEndFee=$P(^DHCEQStoreMonthStatList(SMSLID),"^",13)
	s TotalEndFee=..GetTotalEndFee(StoreEndFee, UsedEndFee)
	d SetTotalFee
	d SetGlobal
	quit
GetOneStatMonthReport
	s StatCatID=rowid
	s StatCat=$P(^DHCEQCCode("DHCEQCStatCat",StatCatID),"^",2)
	s StoreOpenFee=..GetStatCatOpenFee(ValStatCat,MonthStr, StatCatID, "1")
	s InFee=..GetStatCatInFee(StartDate, EndDate, StatCatID,"")+..GetMonthAppendFee(StartDate, EndDate,StatCatID ,"","1")
	s OutFee=..GetStatCatOutFee(StartDate, EndDate, StatCatID)+..GetMonthAppendFee(StartDate, EndDate,StatCatID ,"","2")
	s RefundFee=..GetStatCatRefundFee(StartDate, EndDate, StatCatID)
	s ReturnFee=..GetStatCatReturnFee(StartDate, EndDate, StatCatID,"")
	s StoreEndFee=..GetStoreEndFee(StoreOpenFee, InFee, OutFee, RefundFee, ReturnFee)
	s UsedOpenFee=..GetStatCatOpenFee(ValStatCat,MonthStr, StatCatID, "2")
	s DRFee=..GetStatCatDRFee(StartDate, EndDate, StatCatID,"")
	s UsedEndFee=..GetUsedEndFee(UsedOpenFee, OutFee, DRFee, RefundFee)
	s TotalEndFee=..GetTotalEndFee(StoreEndFee, UsedEndFee)
	d SetTotalFee
	d SetGlobal
	quit
SetTotalFee
	s StoreOpenFeeTotal=StoreOpenFeeTotal+StoreOpenFee
	s InFeeTotal=InFeeTotal+InFee
	s OutFeeTotal=OutFeeTotal+OutFee
	s RefundFeeTotal=RefundFeeTotal+RefundFee
	s ReturnFeeTotal=ReturnFeeTotal+ReturnFee
	s StoreEndFeeTotal=StoreEndFeeTotal+StoreEndFee
	s UsedOpenFeeTotal=UsedOpenFeeTotal+UsedOpenFee
	s DRFeeTotal=DRFeeTotal+DRFee
	s UsedEndFeeTotal=UsedEndFeeTotal+UsedEndFee
	s TotalEndFeeTotal=TotalEndFeeTotal+TotalEndFee
	quit
SetGlobal
	s val=StatCat_"^"_StoreOpenFee_"^"_InFee_"^"_OutFee_"^"_RefundFee_"^"_ReturnFee_"^"_StoreEndFee
	s val=val_"^"_UsedOpenFee_"^"_OutFee_"^"_DRFee_"^"_RefundFee_"^"_UsedEndFee_"^"_TotalEndFee
	s ^DHCEQTemp("StatMonth",+$H,$J,StatCatID)=val
	d OutputRowGetStatMonthReport
	quit
OutputRowGetStatMonthReport
	s Data=$lb(StatCatID,StatCat,StoreOpenFee,InFee,OutFee,RefundFee,ReturnFee,StoreEndFee,UsedOpenFee,DRFee,UsedEndFee,TotalEndFee,MonthStr,StartDate,EndDate)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStatMonthReport
	s (StatCatID,StatCat,StoreOpenFee,InFee,OutFee,RefundFee,ReturnFee,StoreEndFee,UsedOpenFee,DRFee,UsedEndFee,TotalEndFee)=""
	quit
}

ClassMethod GetStatMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatMonthReportExecute ]
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

ClassMethod GetStatMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
ClassMethod ChangeDateMask(Date)
{
	//s Date=$ZDH(Date,4)
	//s Date=$ZD(Date,3)
	// 日期格式统一调整 mwz 2017-3-2
	s Date=##class(web.DHCEQCommon).TransValueFromPage(Date,"date")
	s Date=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	q Date
}

/*
/// 结存月报保存
ClassMethod SaveStatReport(MonthStr, StartDate, EndDate, StatCatVal)
{
	new PLIST
	s SMSID=0
	s MonthStr=##class(web.DHCEQMonthDepre).GetMonth(MonthStr)
	s SMSID=$o(^DHCEQStoreMonthStat(0,"MonthStr",MonthStr,StatCatVal,0))
	s StartDate=$ZDH(StartDate,4)
	s EndDate=$ZDH(EndDate,4)
	s PLIST(2)=MonthStr
	s PLIST(3)=StartDate
	s PLIST(4)=EndDate
	s PLIST(5)=+$H
	s PLIST(7)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s PLIST(11)=StatCatVal
	s i=$L(StatCatVal,",")
	TSTART
	i SMSID=""
	{
		&SQL(insert into sqluser.DHC_EQStoreMonthStat values PLIST())
		s SMSRowID=$G(%ROWID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		for j=1:1:i
		{
			s StatCatID=$P(StatCatVal,",",j)
			s val=$G(^DHCEQTemp("StatMonth",+$H,$J,StatCatID))
			s SMSL(2)=SMSRowID              //结存ID
			s SMSL(3)=StatCatID             //分类ID
			s SMSL(4)=$P(val,"^",2)         //OpenNum
			s SMSL(5)=$P(val,"^",3)         //StockInNum
			s SMSL(6)=$P(val,"^",4)         //StockOutNum
			s SMSL(7)=$P(val,"^",6)         //StockReturnNum
			s SMSL(8)=$P(val,"^",5)         //StockRefundNum
			s SMSL(9)=$P(val,"^",7)         //StockEndNum
			s SMSL(10)=$P(val,"^",8)        //UsedOpenNum
			s SMSL(11)=$P(val,"^",9)        //UsedConsumNum
			s SMSL(12)=$P(val,"^",10)       //UsedLossNum
			s SMSL(13)=$P(val,"^",11)       //UsedRefundNum
			s SMSL(14)=$P(val,"^",12)       //UsedEndNum
			&SQL(insert into sqluser.DHC_EQStoreMonthStatList values SMSL())
			i SQLCODE q
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		&SQL(update sqluser.DHC_EQStoreMonthStat values PLIST() where SMS_RowID=:SMSID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		for j=1:1:i
		{
			s StatCatID=$P(StatCatVal,",",j)
			s val=$G(^DHCEQTemp("StatMonth",+$H,$J,StatCatID))
			s SMSL(2)=SMSID                 //结存ID
			s SMSL(3)=StatCatID             //分类ID
			s SMSL(4)=$P(val,"^",2)         //OpenNum
			s SMSL(5)=$P(val,"^",3)         //StockInNum
			s SMSL(6)=$P(val,"^",4)         //StockOutNum
			s SMSL(7)=$P(val,"^",6)         //StockReturnNum
			s SMSL(8)=$P(val,"^",5)         //StockRefundNum
			s SMSL(9)=$P(val,"^",7)         //StockEndNum
			s SMSL(10)=$P(val,"^",8)        //UsedOpenNum
			s SMSL(11)=$P(val,"^",9)        //UsedConsumNum
			s SMSL(12)=$P(val,"^",10)       //UsedLossNum
			s SMSL(13)=$P(val,"^",11)       //UsedRefundNum
			s SMSL(14)=$P(val,"^",12)       //UsedEndNum
			s SMSLID=$o(^DHCEQStoreMonthStatList(0,"StoreMonthStatCat",SMSID,StatCatID,0))
			i SMSLID=""
			{
				&SQL(insert into sqluser.DHC_EQStoreMonthStatList values SMSL())
			}
			else
			{
				&SQL(update sqluser.DHC_EQStoreMonthStatList values SMSL() where SMSL_RowID=:SMSLID)
			}
			i SQLCODE q
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
	q 0
}

/// 折旧月报保存
ClassMethod SaveDepreMonthReport(MonthStr, StartDate, EndDate, ValEquipType)
{
	new PLIST,SMSID,i,DMRLPL
	s SMSID=0
	s i=$l(ValEquipType,",")
	s MonthStr=##class(web.DHCEQMonthDepre).GetMonth(MonthStr)
	s SMSID=..GetDMRID(MonthStr,ValEquipType)
	s PLIST(2)=MonthStr
	//s val=$G(^DHCEQTemp("DepreMonthReport",+$H,$J,MonthStr))
	//^DHCEQTemp("DepreMonthReport",+$H,$J,MonthStr)=StartDate_"^"_EndDate_"^"_TUseTotalFee_"^"_TNewDepreFee_"^"_TDisDepreFee_"^"_TDepreTotalFee
	s PLIST(3)=$ZDH(StartDate,4)
	s PLIST(4)=$ZDH(StartDate,4)
	s PLIST(5)=+$H
	s PLIST(7)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s PLIST(8)=ValEquipType
	TSTART
	i SMSID=""
	{
		d InSertData
	}
	else
	{
		&SQL(delete from sqluser.DHC_EQDepreMonthReport where DMR_RowID=:SMSID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(delete from sqluser.DHC_EQDepreMonReportList where DMRL_DepreMonthReportDR=:SMSID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		d InSertData
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
InSertData
	&SQL(insert into sqluser.DHC_EQDepreMonthReport values PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s DMRID=$G(%ROWID)
	for j=1:1:i
	{
		s EquipTypeID=$p(ValEquipType,",",j)
		s val=$G(^DHCEQTemp("DepreMonthReport",+$H,$J,EquipTypeID))
		s DMRLPL(2)=DMRID
		s DMRLPL(3)=EquipTypeID
		s DMRLPL(4)=$p(val,"^",2)
		s DMRLPL(5)=$p(val,"^",3)
		s DMRLPL(6)=$p(val,"^",4)
		s DMRLPL(7)=$p(val,"^",5)
		&SQL(insert into sqluser.DHC_EQDepreMonReportList values DMRLPL())
		q:SQLCODE
	}
}


/// 本月新增折旧（应为上月入库设备）
/// MonthStr月份格式为2006-11
ClassMethod GetMonthNewDepreTotal(MonthStr, EquipTypeID)
{
	s PreMonthStr=..GetPreMonth(MonthStr)
	s StartDate=##class(web.DHCEQReport).GetReportDate(PreMonthStr,"1")
	s EndDate=##class(web.DHCEQReport).GetReportDate(PreMonthStr,"2")
	s StartDate=$ZDH(StartDate,4)
	s EndDate=$ZDH(EndDate,4)
	new Date,ISRowID,DepreFee,InsertStep,Flag,Step
	s InsertStep=##class(web.DHCEQCommon).GetSysInfo("901003")
	i InsertStep="0" d
	.s DateType="AuditDateStat"
	.s Step="2"
	i InsertStep="1" d
	.s DateType="BillDate"
	.s Step="3"
	s DepreFee=0
	for Date=StartDate:1:EndDate
	{
		s StatCatID=0
		f  s StatCatID=$o(^DHCEQInStock(0,DateType,Date,StatCatID)) q:(StatCatID="")  d
		.s ISRowID=0
		.f  s ISRowID=$o(^DHCEQInStock(0,DateType,Date,StatCatID,ISRowID)) q:(ISRowID="")  d
		..s Status=$P(^DHCEQInStock(ISRowID),"^",10)
		..q:Status<Step
		..s EquipType=$P(^DHCEQInStock(ISRowID),"^",20)
		..q:EquipType'=EquipTypeID
		..s OneFee=..GetOneInStockDepreTotal(ISRowID,MonthStr)
		..s DepreFee=DepreFee+OneFee
	}
	q DepreFee
}


ClassMethod GetOneInStockDepreTotal(ISRowID, MonthStr)
{
	new ISLID,YearNum,DepreTotal,OneDepre,Price
	s ISLID=0
	s DepreTotal=0
	f  s ISLID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLID)) q:ISLID=""  d
	.s YearNum=$p(^DHCEQInStockList(ISLID),"^",15)
	.i YearNum="" d
	..w ISRowID_"^"_ISLID,!
	.q:YearNum=""
	.s Price=$p(^DHCEQInStockList(ISLID),"^",7)
	.s Num=$p(^DHCEQInStockList(ISLID),"^",8)
	.s OneDepre=(Price/(YearNum*12))*Num
	.s DepreTotal=DepreTotal+OneDepre
	q DepreTotal
}

ClassMethod GetOneInStockDepreTotal(ISRowID, MonthStr)
{
	new ISLRowID,OneDepreFee,OneFlag,Price,UseYear,QuantityNum
	s OneDepreFee=0
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:(ISLRowID="")  d
	.s OneDepreFee=OneDepreFee+..GetOneListDepreFee(ISLRowID,MonthStr)
	q OneDepreFee
}

ClassMethod GetOneListDepreFee(ISLRowID, MonthStr)
{
	new CSRowID,EquipID,DepreTotalFee,MonthDepreID
	s CSRowID=0
	s DepreTotalFee=0
	f  s CSRowID=$o(^DHCEQChangeStock(0,"Source","0",ISLRowID,CSRowID)) q:CSRowID=""  d
	.s EquipID=$p(^DHCEQChangeStock(CSRowID),"^",1)
	.s MonthDepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipID,MonthStr,0))
	.q:MonthDepreID=""
	.s DepreTotalFee=DepreTotalFee+$p(^DHCEQMonthDepre(MonthDepreID),"^",14)
	q DepreTotalFee
}

ClassMethod GetReducesDepreFee(MonthStr)
{
	s StartDate=##class(web.DHCEQReport).GetReportDate(MonthStr,"1")
	s EndDate=##class(web.DHCEQReport).GetReportDate(MonthStr,"2")
	s StartDate=$ZDH(StartDate,4)
	s EndDate=$ZDH(EndDate,4)
	new DRID,EquipID,MonthDepreID,ReducesDepreFee,UseYears
	s DRID=0
	s ReducesDepreFee=0
	s Flag="N"
	for Date=StartDate:1:EndDate
	{
		f  s DRID=$o(^DHCEQDisuseRequest(0,"AuditDateStatus",Date,"2",DRID)) q:(DRID="")||(Flag="Y")  d
		.s EquipID=$p(^DHCEQDisuseRequest(DRID),"^",1)
		.s NetFee=$p(^DHCEQEquip(EquipID),"^",28)
		.s MonthDepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipID,MonthStr,0))
		.//q:MonthDepreID=""
		.i MonthDepreID="" d
		..s OriginalFee=$p(^DHCEQEquip(EquipID),"^",27)
		..s UseYears=$p(^DHCEQEquip(EquipID),"^",31)
		..i UseYears="" s Flag="Y"
		..q:Flag="Y"
		..s DepreFee=((OriginalFee/UseYears)/12)
		..i NetFee<DepreFee s DepreFee=NetFee
		..s ReducesDepreFee=ReducesDepreFee+DepreFee
		.q:Flag="Y"
		.e  d
		..s DepreFee=$p(^DHCEQMonthDepre(MonthDepreID),"^",14)
		..i NetFee<DepreFee s DepreFee=NetFee
		..s ReducesDepreFee=ReducesDepreFee+DepreFee
	}
	i Flag="Y" q -1001
	q ReducesDepreFee
}

/// 得到科室月折旧金额
ClassMethod GetLocMonthDepreFee(LocID, Month, EquipTypeID)
{
	new MDID,DepreFee,LFID,FeeType,LFLocID,OneFee
	s FeeType=##class(web.DHCEQMaint).GetFeeType("6")
	s DepreFee=0
	s MDID=0
	f  s MDID=$o(^DHCEQMonthDepre(0,"Month",Month,MDID)) q:MDID=""  d
	.s MDStatus=$p($g(^DHCEQMonthDepre(MDID)),"^",20)	//DJ0136
	.q:MDStatus="3"
	.s EquipID=$p(^DHCEQMonthDepre(MDID),"^",1)
	.s EquipType=$p(^DHCEQEquip(EquipID),"^",63)
	.q:(EquipTypeID'="")&&(EquipType'=EquipTypeID)
	.s LFID=$o(^DHCEQLifeFee(0,"Source",FeeType,MDID,0))
	.q:LFID=""
	.s LFLocID=$p(^DHCEQLifeFee(LFID),"^",6)
	.q:(LocID'="")&&(LFLocID'=LocID)
	.s OneFee=$p(^DHCEQMonthDepre(MDID),"^",14)
	.s DepreFee=DepreFee+OneFee
	q DepreFee
}

/// 得到当月在用总的设备金额
ClassMethod GetEquipTotalFee(MonthStr, StartDate, EndDate, ValEquipType, EquipTypeID)
{
	new TotalFee,InFee,ReturnFee,DisFee,PreMonth
	s PreMonth=..GetPreMonth(MonthStr)
	s TotalFee=..GetPreEquipFee(PreMonth,ValEquipType,EquipTypeID)
	s InFee=..GetStatCatInFee(StartDate,EndDate,"",EquipTypeID)
	s ReturnFee=..GetStatCatReturnFee(StartDate,EndDate,"",EquipTypeID)
	s DisFee=..GetStatCatDRFee(StartDate,EndDate,"",EquipTypeID)
	s TotalFee=TotalFee+InFee-ReturnFee-DisFee
	q TotalFee
}

/// 判断是否本月报表后报废设备  N本月前报废  Y本月后报废
ClassMethod MonthLateDis(Date, EQID)
{
	new DisDate,DisID
	s DisID=$o(^DHCEQDisuseRequest(0,"Equip",EQID,0))
	i DisID="" q "N"
	s DisDate=$p(^DHCEQDisuseRequest(DisID),"^",21)
	i DisDate="" q "N"
	i DisDate>Date q "Y"
	q "N"
}

/// 判断是否本月报表后入库设备  N本月前入库  Y本月后入库
ClassMethod MonthLateInStock(Date, EQID)
{
	new rowid,CSID,BillDate
	s rowid=$p(^DHCEQEquip(EQID),"^",70)
	i rowid="" q "N"
	s CSID=0
	s CSID=$o(^DHCEQChangeStock(0,"Source","0",rowid,0))
	i CSID="" q "N"
	s BillDate=$p(^DHCEQChangeStock(CSID),"^",9)
	i BillDate>Date q "Y"
	q "N"
}

/// 判断是否本月报表后出库设备  N本月前出库  Y本月后出库
ClassMethod MonthLateReturn(Date, EQID)
{
	new CSID,Flag,ChangeType,BillDate
	s Flag="N"
	s CSID=0
	f  s CSID=$o(^DHCEQChangeStock(0,"Equip",EQID,CSID)) q:(CSID="")||(Flag="Y")  d
	.s ChangeType=$p(^DHCEQChangeStock(CSID),"^",5)
	.q:+ChangeType<2
	.s BillDate=$p(^DHCEQChangeStock(CSID),"^",6)
	.q:BillDate=""
	.s Flag="Y"
	i BillDate>Date q "Y"
	q "N"
}

ClassMethod GetPreEquipFee(Month, ValEquipType, EquipTypeID)
{
	new DMRID,TotalFee
	s TotalFee=0
	s DMRID=..GetDMRID(Month,ValEquipType)
	i DMRID'=""
	{
		s DMRLID=0
		f  s DMRLID=$o(^DHCEQDepreMonReportList(0,"Month",DMRID,DMRLID)) q:DMRLID=""  d
		.s EquipType=$p(^DHCEQDepreMonReportList(DMRLID),"^",2)
		.q:EquipType'=EquipTypeID
		.s TotalFee=$p(^DHCEQDepreMonReportList(DMRLID),"^",3)
	}
	q TotalFee
}

/// 得到折旧月报的列表
Query GetDepreMothReport(ValEquipType, StartDate, EndDate, MonthStr) As %Query(ROWSPEC = "TEquipTypeDR:%String,TEquipType:%String,TUseTotalFee:%String,TNewDepreFee:%String,TDisDepreFee:%String,TDepreTotalFee:%String")
{
}

ClassMethod GetDepreMothReportExecute(ByRef qHandle As %Binary, ValEquipType, StartDate, EndDate, MonthStr) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ..KillTempGlobal("DepreMonthReport")
 	s index=1
	d BuildDataGetDepreMothReport
	Quit $$$OK
BuildDataGetDepreMothReport
	q:(StartDate="")&&(EndDate="")
	q:MonthStr=""
	s DMRID=..GetDMRID(MonthStr,ValEquipType)
	d ResetVariablesGetDepreMothReport
	i DMRID=""
	{
		s j=$l(ValEquipType,",")
		for i=1:1:j
		{
			s TEquipTypeDR=$p(ValEquipType,",",i)
			i TEquipTypeDR'="" d
			.s TEquipType=$p(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
			.s TUseTotalFee=..GetEquipTotalFee(MonthStr,StartDate,EndDate,ValEquipType,TEquipTypeDR)
			.s TNewDepreFee=..GetMonthNewDepreTotal(MonthStr,TEquipTypeDR)
			.s TDisDepreFee=..GetDRDepreFee(StartDate,EndDate,MonthStr,TEquipTypeDR)
			.s TDepreTotalFee=..GetLocMonthDepreFee("",MonthStr,TEquipTypeDR)
			.d OutputRowGetDepreMothReport
		}
	}
	else
	{
		s DMRLID=0
		f  s DMRLID=$o(^DHCEQDepreMonReportList(0,"Month",DMRID,DMRLID)) q:DMRLID=""  d
		.s TEquipTypeDR=$p(^DHCEQDepreMonReportList(DMRLID),"^",2)
		.i TEquipTypeDR'="" d
		..s TEquipType=$p(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
		.s TUseTotalFee=$p(^DHCEQDepreMonReportList(DMRLID),"^",3)
		.s TNewDepreFee=$p(^DHCEQDepreMonReportList(DMRLID),"^",4)
		.s TDisDepreFee=$p(^DHCEQDepreMonReportList(DMRLID),"^",5)
		.s TDepreTotalFee=$p(^DHCEQDepreMonReportList(DMRLID),"^",6)
		.d OutputRowGetDepreMothReport
	}
	
	quit
OutputRowGetDepreMothReport
	s Data=$lb(TEquipTypeDR,TEquipType,TUseTotalFee,TNewDepreFee,TDisDepreFee,TDepreTotalFee)
  	s ^DHCEQTemp("DepreMonthReport",+$H,$J,TEquipTypeDR)=TEquipType_"^"_TUseTotalFee_"^"_TNewDepreFee_"^"_TDisDepreFee_"^"_TDepreTotalFee
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDepreMothReport
	s (TEquipTypeDR,TEquipType,TUseTotalFee,TNewDepreFee,TDisDepreFee,TDepreTotalFee)=""
	quit
}

ClassMethod GetDepreMothReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepreMothReportExecute ]
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

ClassMethod GetDepreMothReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepreMothReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
ClassMethod CheckMonth(MonthStr)
{
	i ((MonthStr?4N1"-"1(2N,1N))&&($P(MonthStr,"-",2)<=12)&&($P(MonthStr,"-",2)>0)) q "0"
	q "1"
}

/*
/// Type=1为入库增加的  Type=2为出库增加
ClassMethod GetMonthAppendFee(StartDate, EndDate, StatCatID, UseLocID, Type)
{
	new OneFee,AddInFee,ReduceInFee,Date,Flag,UpDate,AddDate
	new AddOutFee,ReduceOutFee,OutTotal,EquipID,AFID,StatCat
	s AddInFee=0,AddOutFee=0
	s ReduceInFee=0,ReduceOutFee=0
	for Date=StartDate:1:EndDate
	{
		s AFID=0
		f  s AFID=$o(^DHCEQAppendFee(0,"AddDate",Date,AFID)) q:AFID=""  d
		.s OneFee=$p(^DHCEQAppendFee(AFID),"^",3)
		.s Flag=$p(^DHCEQAppendFee(AFID),"^",16)
		.s EquipID=$p(^DHCEQAppendFee(AFID),"^",1)
		.s StatCat=$p(^DHCEQEquip(EquipID),"^",75)
		.q:(StatCatID'="")&&(StatCatID'=StatCat)
		.s UseLoc=$p(^DHCEQEquip(EquipID),"^",19)
		.q:(UseLocID'="")&&(UseLocID'=UseLoc)
		.i Flag'="Y" d
		..i Type="1" s AddInFee=AddInFee+OneFee
		..i Type="2" d
		...s OutTotal=..GetOutTotal(EquipID,EndDate)
		...s AddOutFee=AddOutFee+(OutTotal*OneFee)
		.e  d
		..s UpDate=$p(^DHCEQAppendFee(AFID),"^",13)
		..i UpDate>EndDate d
		...i Type="1" s AddInFee=AddInFee+OneFee
		...i Type="2" d
		....s OutTotal=..GetOutTotal(EquipID,EndDate)
		....s AddOutFee=AddOutFee+(OutTotal*OneFee)
		s AFID=0
		f  s AFID=$o(^DHCEQAppendFee(0,"UpdateDate",Date,"Y",AFID)) q:AFID=""  d
		.s AddDate=$p(^DHCEQAppendFee(AFID),"^",10)
		.q:AddDate'<StartDate
		.s EquipID=$p(^DHCEQAppendFee(AFID),"^",1)
		.s StatCat=$p(^DHCEQEquip(EquipID),"^",75)
		.q:(StatCatID'="")&&(StatCatID'=StatCat)
		.s UseLoc=$p(^DHCEQEquip(EquipID),"^",19)
		.q:(UseLocID'="")&&(UseLocID'=UseLoc)
		.s OneFee=$p(^DHCEQAppendFee(AFID),"^",3)
		.i Type="1" s ReduceInFee=ReduceInFee+OneFee
		.i Type="2" d
		..s OutTotal=..GetOutTotal(EquipID,EndDate)
		..s ReduceOutFee=ReduceOutFee+(outTotal*OneFee)
	}
	i Type="1" q AddInFee-ReduceInFee
	i Type="2" q AddOutFee-ReduceOutFee
}

/// 得到出库次数以及退库次数的差值
ClassMethod GetOutTotal(Equip, EndDate)
{
	new CSID,Total,ChangeType,SourceID,MoveType,BillDate,Flag
	s Total=0
	///以下为了防止没有入库直接导入的在用设备
	s Flag="N"
	s CSID=0
	f  s CSID=$o(^DHCEQChangeStock(0,"Equip",Equip,CSID)) q:(CSID="")||(Flag="Y")  d
	.s ChangeType=$p(^DHCEQChangeStock(CSID),"^",5)
	.q:ChangeType'="0"
	.s BillDate=$p(^DHCEQChangeStock(CSID),"^",8)
	.q:BillDate=""
	.q:BillDate>EndDate
	.s Flag="Y"
	i Flag="N" s Total=1
	///以下Flag标志防止了导入的库存没有插入入库记录直接分配上面Total＋1的问题
	s CSID=0
	s Flag="N"
	f  s CSID=$o(^DHCEQChangeStock(0,"Equip",Equip,CSID)) q:CSID=""  d
	.s ChangeType=$p(^DHCEQChangeStock(CSID),"^",5)
	.i ChangeType="0" s Flag="Y"
	.q:ChangeType'="1"
	.s BillDate=$p(^DHCEQChangeStock(CSID),"^",8)
	.q:BillDate=""
	.q:BillDate>EndDate
	.s SourceID=$p(^DHCEQChangeStock(CSID),"^",4)
	.s MoveType=$p(^DHCEQStoreMove(SourceID),"^",12)
	.i MoveType="0" d
	..i Flag="Y" s Total=Total+1
	..s Flag="Y"
	.e  i MoveType="3" d
	..s Total=Total-1
	q Total
}
*/

/*
/// 得到结存月报的列表
Query GetStatMonthReportNew(ValStatCat, StartDate, EndDate, MonthStr, LocDR As %String = "", EquipTypeIDs As %Library.String = "") As %Query(ROWSPEC = "StatCatID:%String,StatCat:%String,StockBegin:%String,StockIn:%String,StockReturn:%String,StockReduce:%String,StockMoveOut:%String,StockMoveIn:%String,StockEnd:%String,UsedBegin:%String,UsedIn:%String,UsedReturn:%String,UsedMoveIn:%String,UsedMoveOut:%String,Disused:%String,UsedEnd:%String,StartDate:%String,EndDate:%String,MonthStr:%String,TotalEnd:%String,ChangeAccount:%String,Origin:%String,EquipType:%String,Job:%String,TotalDepre:%String,Depre:%String,StockDisused:%String,StoreMoveIn:%String,StoreMoveOut:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReport","GetStatMonthReportNew","","2008-03-01","2008-03-31","2008-03")
ClassMethod GetStatMonthReportNewExecute(ByRef qHandle As %Binary, ValStatCat, StartDate, EndDate, MonthStr, LocDR As %String = "", EquipTypeIDs As %Library.String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
 	
 	new Year,Month,PreYear,PreMonth,Loc,StatCat,BillDate,type,tmpfee,StoreLoc,Origin
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount
 	new TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut
 	new i,suminfo
 	s (Year,Month,PreYear,PreMonth,Loc,StatCat)=""
 	s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
 	s (TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut)=0
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	;s User=1
 	s Date=+$H
	s Time=$p($H,",",2)
	
	s ^DHCEQTemp("MonthReport")="ValStatCat:"_ValStatCat_",StartDate:"_StartDate_",EndDate:"_EndDate_",MonthStr:"_MonthStr_",LocDR:"_LocDR_",EquipTypeIDs:"_EquipTypeIDs
	///s StockBegin=StartDate
	///d OutputRowStatReportNew
	///q $$$OK
	
	q:(StartDate="")&&(EndDate="") $$$OK
	q:MonthStr="" $$$OK
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	if (Month=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Month-1}
		
	//(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat))
 	k ^DHCEQTemp("MonthReport","Stat",User,$j,Year,Month)
	
	;b  	//'$d(^DHCEQMonthReportList(0,"Loc",Year,Month))
	i '$d(^DHCEQMonthReportList(0,"Loc",Year,Month))
	{		
		d ..FillStatListInfo(User,Year,Month,StartDate,EndDate,EquipTypeIDs) 
		
		s EquipType=0
		f  s EquipType=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s Loc=0
		.f  s Loc=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:Loc=""  d
		..q:((LocDR'="")&&(LocDR'=Loc))
		..s StatCat=0
		..f  s StatCat=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:StatCat=""  d
		...q:((ValStatCat'="")&&((","_ValStatCat_",")'[(","_StatCat_",")))
		...
		...s Origin=""
		...f  s Origin=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:Origin=""  d
		....s listInfo=$g(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin))
		....d AddStatInfoN
	}
	else
	{
		s EquipType=0
		f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s StatCat=0
		.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat)) q:StatCat=""  d
		..s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
		..s Loc=0
		..f  s Loc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc)) q:Loc=""  d
		...q:((LocDR'="")&&(LocDR'=Loc))
		...s rowid=0
		...f  s rowid=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc,rowid)) q:rowid=""  d
		....;s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
		....s listInfo=$g(^DHCEQMonthReportList(rowid)) //2011-01-10 DJ
		....;s StockBegin=+$p(listInfo,"^",6)
		....;s StockIn=+$p(listInfo,"^",7)
		....;s StockReturn=+$p(listInfo,"^",8)
		....;s StockReduce=+$p(listInfo,"^",9)
		....;s StockMoveOut=+$p(listInfo,"^",10)
		....;s StockMoveIn=+$p(listInfo,"^",11)
		....;s StockEnd=+$p(listInfo,"^",12)
		....;s UsedBegin=+$p(listInfo,"^",13)
		....;s UsedIn=+$p(listInfo,"^",14)
		....;s UsedReturn=+$p(listInfo,"^",15)
		....;s UsedMoveIn=+$p(listInfo,"^",16)
		....;s UsedMoveOut=+$p(listInfo,"^",17)
		....;s Disused=+$p(listInfo,"^",18)
		....;s UsedEnd=+$p(listInfo,"^",19)
		....
		....;s ChangeAccount=+$p(listInfo,"^",25)
		....s Origin=$p(listInfo,"^",26)
		....
		....;s TotalDepre=$p(listInfo,"^",26)
		....;s Depre=$p(listInfo,"^",26)
		....;s StockDisused=$p(listInfo,"^",26)
		....;s StoreMoveIn=$p(listInfo,"^",26)
		....;s StoreMoveOut=$p(listInfo,"^",26)
		....
		....s listInfo=$p(listInfo,"^",6,19)_"^"_$p(listInfo,"^",25)_"^"_$p(listInfo,"^",28,32)
		....
		....;s listInfo=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_ChangeAccount
		....d AddStatInfoN
	}
	
	s (StockBeginSum,StockInSum,StockReturnSum,StockReduceSum,StockMoveOutSum,StockMoveInSum,StockEndSum,UsedBeginSum,UsedInSum,UsedReturnSum,UsedMoveInSum,UsedMoveOutSum,DisusedSum,UsedEndSum,ChangeAccountSum)=0
	
	s EquipType=0
	s ETIDS=##Class(web.DHCEQCommon).GetEquipTypesByGroup("")
	s ETIDS="^"_ETIDS_"^"
	f  s EquipType=$o(^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,EquipType)) q:EquipType=""  d
	.q:ETIDS'[("^"_EquipType_"^") //2011-01-10 DJ
	.s StatCat=0
	.f  s StatCat=$o(^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,EquipType,StatCat)) q:StatCat=""  d
	..q:((ValStatCat'="")&&((","_ValStatCat_",")'[(","_StatCat_",")))
	..s Origin=""
	..f  s Origin=$o(^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,EquipType,StatCat,Origin)) q:Origin=""  d
	...s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
	...s listInfo=$g(^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,EquipType,StatCat,Origin))
	...s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
	...//b
	...i listInfo'=""  d
	....s suminfo=$g(^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,0))
	....i suminfo=""  d
	.....s ^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,0)=listInfo
	....e  d
	.....for i=1:1:20  d
	......s $p(suminfo,"^",i)=+$p(suminfo,"^",i)+$p(listInfo,"^",i)
	.....s ^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,0)=suminfo
	.....
	....;s StockBegin=$p(listInfo,"^",1)
	....;s StockIn=$p(listInfo,"^",2)
	....;s StockReturn=$p(listInfo,"^",3)
	....;s StockReduce=$p(listInfo,"^",4)
	....;s StockMoveOut=$p(listInfo,"^",5)
	....;s StockMoveIn=$p(listInfo,"^",6)
	....;s StockEnd=$p(listInfo,"^",7)		
	....;s UsedBegin=$p(listInfo,"^",8)
	....;s UsedIn=$p(listInfo,"^",9)
	....;s UsedReturn=$p(listInfo,"^",10)
	....;s UsedMoveIn=$p(listInfo,"^",11)
	....;s UsedMoveOut=$p(listInfo,"^",12)
	....;s Disused=$p(listInfo,"^",13)
	....;s UsedEnd=$p(listInfo,"^",14)
	....;
	....;s ChangeAccount=$p(listInfo,"^",15)
	....
	....;s StockBeginSum=StockBeginSum+StockBegin
	....;s StockInSum=StockInSum+StockIn
	....;s StockReturnSum=StockReturnSum+StockReturn
	....;s StockReduceSum=StockReduceSum+StockReduce
	....;s StockMoveOutSum=StockMoveOutSum+StockMoveOut
	....;s StockMoveInSum=StockMoveInSum+StockMoveIn
	....;s StockEndSum=StockEndSum+StockEnd
	....;s UsedBeginSum=UsedBeginSum+UsedBegin
	....;s UsedInSum=UsedInSum+UsedIn
	....;s UsedReturnSum=UsedReturnSum+UsedReturn
	....;s UsedMoveInSum=UsedMoveInSum+UsedMoveIn
	....;s UsedMoveOutSum=UsedMoveOutSum+UsedMoveOut
	....;s DisusedSum=DisusedSum+Disused
	....;s UsedEndSum=UsedEndSum+UsedEnd
	....;s ChangeAccountSum=ChangeAccountSum+ChangeAccount
	...i Origin'="" s OriginDesc=$p($g(^DHCEQCCode("DHCEQCOrigin",Origin)),"^",2)
	...d OutputRowStatReportN
	
	s EquipType=0
	s StatCat=0
	s OriginDesc=""
	s StatCatDesc="总计:"
	s listInfo=$g(^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,0))
	d OutputRowStatReportN
	
	Quit $$$OK
	
AddStatInfoN
	s statInfo=$g(^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,EquipType,StatCat,Origin))
	if statInfo=""
	{
		s statInfo=listInfo
	}
	else
	{
		for i=1:1:20  s $p(statInfo,"^",i)=+$p(listInfo,"^",i)+$p(statInfo,"^",i)

		//s $p(statInfo,"^",1)=+$p(listInfo,"^",1)+$p(statInfo,"^",1)
		//s $p(statInfo,"^",2)=+$p(listInfo,"^",2)+$p(statInfo,"^",2)
		//s $p(statInfo,"^",3)=+$p(listInfo,"^",3)+$p(statInfo,"^",3)
		//s $p(statInfo,"^",4)=+$p(listInfo,"^",4)+$p(statInfo,"^",4)
		//s $p(statInfo,"^",5)=+$p(listInfo,"^",5)+$p(statInfo,"^",5)
		//s $p(statInfo,"^",6)=+$p(listInfo,"^",6)+$p(statInfo,"^",6)
		//s $p(statInfo,"^",7)=+$p(listInfo,"^",7)+$p(statInfo,"^",7)
		
		//s $p(statInfo,"^",8)=+$p(listInfo,"^",8)+$p(statInfo,"^",8)
		//s $p(statInfo,"^",9)=+$p(listInfo,"^",9)+$p(statInfo,"^",9)
		//s $p(statInfo,"^",10)=+$p(listInfo,"^",10)+$p(statInfo,"^",10)
		//s $p(statInfo,"^",11)=+$p(listInfo,"^",11)+$p(statInfo,"^",11)
		//s $p(statInfo,"^",12)=+$p(listInfo,"^",12)+$p(statInfo,"^",12)
		//s $p(statInfo,"^",13)=+$p(listInfo,"^",13)+$p(statInfo,"^",13)
		//s $p(statInfo,"^",14)=+$p(listInfo,"^",14)+$p(statInfo,"^",14)
		//s $p(statInfo,"^",15)=+$p(listInfo,"^",15)+$p(statInfo,"^",15)		
	}
	s ^DHCEQTemp("MonthReport","Stat",User,$J,Year,Month,EquipType,StatCat,Origin)=statInfo
	quit

OutputRowStatReportN
	q:listInfo=""
	s StockBegin=$p(listInfo,"^",1)
	s StockIn=$p(listInfo,"^",2)
	s StockReturn=$p(listInfo,"^",3)
	s StockReduce=$p(listInfo,"^",4)
	s StockMoveOut=$p(listInfo,"^",5)
	s StockMoveIn=$p(listInfo,"^",6)
	s StockEnd=$p(listInfo,"^",7)		
	s UsedBegin=$p(listInfo,"^",8)
	s UsedIn=$p(listInfo,"^",9)
	s UsedReturn=$p(listInfo,"^",10)
	s UsedMoveIn=$p(listInfo,"^",11)
	s UsedMoveOut=$p(listInfo,"^",12)
	s Disused=$p(listInfo,"^",13)
	s UsedEnd=$p(listInfo,"^",14)
	
	s ChangeAccount=$p(listInfo,"^",15)

	s TotalDepre=$p(listInfo,"^",16)
	s Depre=$p(listInfo,"^",17)
	s StockDisused=$p(listInfo,"^",18)
	s StoreMoveIn=$p(listInfo,"^",19)
	s StoreMoveOut=$p(listInfo,"^",20)	
	
	s TotalEnd=+StockEnd+UsedEnd
	s Data=$lb(StatCat,StatCatDesc,StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,$ZD(StartDate,4),$ZD(EndDate,4),MonthStr,TotalEnd,ChangeAccount,OriginDesc,EquipType,$J,TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetStatMonthReportNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatMonthReportNewExecute ]
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

ClassMethod GetStatMonthReportNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatMonthReportNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveStat(ValStatCat, StartDate, EndDate, MonthStr, EquipTypeIDs As %Library.String = "")
{
	i (StartDate="") q 0
	i (EndDate="") q 0
	i MonthStr="" q 0
	s StartDate=$ZDH(StartDate,4)
	s EndDate=$ZDH(EndDate,4)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	d ..FillStatListInfo(User, Year, Month, StartDate, EndDate,EquipTypeIDs)
	q ..SaveStatListInfo(User, Year, Month, StartDate, EndDate, MonthStr,EquipTypeIDs)
}

/// 保存StatList
ClassMethod SaveStatListInfo(User, Year, Month, StartDate, EndDate, MonthStr, EquipTypeIDs As %Library.String = "")
{
	new Loc,StatCat,listInfo,PreYear,PreMonth
	new Date,Time
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd
 	
 	s Date=+$H
	s Time=$p($H,",",2)
	
	k PLIST
	s PLIST(2) = Year
	s PLIST(3) = Month
	///s PLIST(4) = Loc
	s PLIST(5) = MonthStr
	///s PLIST(6) = StatCat
	
	s PLIST(21) = StartDate
	s PLIST(22) = EndDate
	s PLIST(23) = Date
	s PLIST(24) = Time
	s PLIST(25) = User
	
	TStart
	s SQLCODE=0
	///保存当月有业务数据变化的
	s EquipType=0
	f  s EquipType=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType)) q:((EquipType="")||(SQLCODE'=0))  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s Loc=0
	.f  s Loc=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:((Loc="")||(SQLCODE'=0))  d
	..s StatCat=0
	..f  s StatCat=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:((StatCat="")||(SQLCODE'=0))  d
	...s Origin=""
	...f  s Origin=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:((Origin="")||(SQLCODE'=0))  d
	....s listInfo=$g(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin))
	....s PLIST(4) = Loc
	....s PLIST(6) = StatCat
	....f i=1:1:14 d
	.....s PLIST(6+i) = $p(listInfo,"^",i)
	....s PLIST(26)=$p(listInfo,"^",15)		///原值变动
	....s PLIST(27)=Origin		///来源
	....s PLIST(28)=EquipType	///类组
	....s ReportListID=0
	....s HadSave=0
	....f  s ReportListID=$o(^DHCEQMonthReportList(0,"StatCat",Year,Month,StatCat,Loc,ReportListID)) q:ReportListID=""  d
	.....i Origin=$p($g(^DHCEQMonthReportList(ReportListID)),"^",26)  d
	......i EquipType=$p($g(^DHCEQMonthReportList(ReportListID)),"^",27) s HadSave=1
	....i HadSave=0  d
	.....&SQL(Insert Into SQLUSER.DHC_EQMonthReportList Values :PLIST())
	.....q:SQLCODE'=0 
	
	i SQLCODE'=0
	{	TRollBack}
	else
	{	TCommit}
	q SQLCODE
}
*/
/// modified by ZY0293 2022-02-10 增加参数控制
/// ----------------------------------
/// Modified by jdl 2011-12-28 JDL0107
/// 
/// ----------------------------------
/// 创建：jdl 2009-08-4 JDL0021
/// 描述：根据起始终止日期汇总当月月结数据记录在^TempDHCEQ("MonthReport","List",User,$J,Year,Month)
/// 访问表:无
/// 输入：User:操作员
/// 	  Year:年
/// 	  Month:月
/// 	  StartDate:开始日期
/// 	  EndDate:结束日期
/// 	  EquipTypeIDs:类组Ids
/// 输出：无
/// 返回：成功返回空，否则返回出错信息
/// 备注：
/// d ##Class(web.DHCEQReport).FillStatListInfo(1,"2017","08",64496,64526,"1","","1")
/// d ##Class(web.DHCEQReport).FillStatListInfo(1,2022,5,66230,66260,"","",0,35)
ClassMethod FillStatListInfo(User, Year, Month, StartDate, EndDate, EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", AccountShape As %String = "0", APRowID As %String = "")
{
	new PreYear,PreMonth,Loc,StatCat,BillDate,type,tmpfee,StoreLoc,listInfo
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd
 	new ChangeAccount,Origin,EquipType
 	;折旧总额,当月折旧,在库报废,库房转移(入),库房转移(出)
 	new TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut
 	new StockStatus,MonthDepreID,MonthStr
 	new ListRowID,OutType,OutTypeCode,EquipID,InStockListID
 	new NetFee
 	
 	;Add by JDL 2011-6-22 JDL0086
 	new StockChangeAccount,UsedReduce,StockOther,UsedOther
 	new AdjustType
 	
 	;Add by JDL 2011-12-28 JDL0107
 	new FundsType,SelfFundsType,FundsID,RemainOriginalFee,RemainDepreTotal,RemainNetFee,FundsFee
 	new SourceType,SourceID
 	;Add By DJ 2015-01-21 DJ0135
 	new StockCATotalDepre,UsedCATotalDepre
 	new FinaceItem,FunctionCat  // Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
 	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	
	k ^TempDHCEQ("MonthReport","List",User,$J,Year,Month)
	;s ^TempDHCEQ("jdl")=User_","_ Year_","_ Month_","_ StartDate_","_ EndDate_","_ EquipTypeIDs_","_ FundsTypeDR	
	if (Month=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Month-1}
	//modify by lmm 2019-12-3 begin
	i Month<10
	{	s MonthStr=Year_"-0"_Month}
	else
	{	s MonthStr=Year_"-"_Month}
	
	s NewSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr,"Equip")
	//i NewSnapID="" q ""			//Add By DJ 2020-03-28   modify by lmm 2020-12-30
	//modify by lmm 2019-12-3 end
	
	;0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
	s SourceType="3"
	//汇总入库信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.i AccountShape="1" s BillDate=0
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")  d
	...s ISInvalidFlag=$p($g(^DHCEQInStock(rowid)),"^",25)   //Add By CZF 2016-12-07 begin
	...q:ISInvalidFlag="Y"
	...s ISStatus=$p($g(^DHCEQInStock(rowid)),"^",10)
	...q:ISStatus'=2		//Add By CZF 2016-12-07 end
	...s ISNo=$p($g(^DHCEQInStock(rowid)),"^",14) //2011-07-22 DJ
	...q:ISNo="" //2011-07-22 DJ
	...//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的入库单
	...q:(AccountShape=1)&&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	...//modified by ZY0293 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"21",rowid)
	...q:$p(result,"^",1)'=0
	...s StoreLoc=$p($g(^DHCEQInStock(rowid)),"^",2)
	...s Origin=$p($g(^DHCEQInStock(rowid)),"^",15)
	...s ListRowID=0
	...d InitStatInfoVariant
	...f  s ListRowID=$o(^DHCEQInStockList(0,"InStock",rowid,ListRowID)) q:(ListRowID="")  d
	....q:$p($g(^DHCEQInStockList(ListRowID)),"^",22)'=""	// Mozy0217  2018-11-01	过滤设备配置的入库明细
	....s StatCat=$p($g(^DHCEQInStockList(ListRowID)),"^",17)
	....i StatCat="" s StatCat=$p($g(^DHCEQInStock(rowid)),"^",21)
	....
	....s SourceID=ListRowID
	....s RemainOriginalFee=($p($g(^DHCEQInStockList(ListRowID)),"^",7)*$p($g(^DHCEQInStockList(ListRowID)),"^",8))
	....d SplitFunds
	
	s SourceType="5"
	//汇总减少信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQReturn(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s OutType=0
	.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType)) q:OutType=""  d
	..//增加入账形式的参数，退货业务的数据都是没有入账的，都不需要处理
	..q:(OutType=1)&(AccountShape=1)
	..s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",1)
	..s BillDate=StartDate-1
	..
	..//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	..i AccountShape="1" s BillDate=0
	..
	..f  s BillDate=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate,rowid)) q:(rowid="")  d
	....s RInvalidFlag=$p($g(^DHCEQReturn(rowid)),"^",28)    //Add By CZF 2016-12-07 begin
	....q:RInvalidFlag="Y"
	....s RStatus=$p($g(^DHCEQReturn(rowid)),"^",13)
	....q:RStatus'=2		//Add By CZF 2016-12-07 end
	....//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的入库单,同时减少类型不是退货的时候
	....q:(AccountShape=1)&&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	....//modified by ZY0293 2022-01-27
	....s result=0
	....i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"23",rowid)
	....q:$p(result,"^",1)'=0
	....;当期减少金额
	....s StoreLoc=$p($g(^DHCEQReturn(rowid)),"^",2)
	....s ListRowID=0
	....d InitStatInfoVariant
	....f  s ListRowID=$o(^DHCEQReturnList(0,"Return",rowid,ListRowID)) q:(ListRowID="")  d
	.....q:($p($g(^DHCEQReturnList(ListRowID)),"^",12)'="")		// Mozy0217  2018-11-01	过滤设备配置的退货明细
	.....s EquipID=$p($g(^DHCEQReturnList(ListRowID)),"^",4)
	.....s InStockListID=$p($g(^DHCEQReturnList(ListRowID)),"^",3)
	.....d GetStatOtherInfo
	.....
	.....s SourceID=ListRowID
	.....s RemainOriginalFee=($p($g(^DHCEQReturnList(ListRowID)),"^",5)*$p($g(^DHCEQReturnList(ListRowID)),"^",6))
	.....d SplitFunds
	
	s SourceType="4"
	//汇总转移信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQStoreMove(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.i AccountShape="1" s BillDate=0
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")  d
	...s SMInvalidFlag=$p($g(^DHCEQStoreMove(rowid)),"^",27)    //Add By CZF 2016-12-07 begin
	...q:SMInvalidFlag="Y"
	...s SMStatus=$p($g(^DHCEQStoreMove(rowid)),"^",13)
	...q:SMStatus'=2		//Add By CZF 2016-12-07 end
	...//增加入账形式的参数，当AccountShape=1的时候只显示已经入账的转移单
	...q:(AccountShape=1)&&(##Class(web.DHCEQAccountList).AccountFlag(rowid,SourceType,StartDate,EndDate)=0)
	...//modified by ZY0293 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"22",rowid)
	...q:$p(result,"^",1)'=0
	...s ListRowID=0
	...d InitStatInfoVariant
	...f  s ListRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,ListRowID)) q:(ListRowID="")  d
	....q:$p($g(^DHCEQStoreMoveList(ListRowID)),"^",15)'="" // Mozy0217  2018-11-01	过滤设备配置的转移明细
	....s EquipID=$p($g(^DHCEQStoreMoveList(ListRowID)),"^",2)
	....s InStockListID=$p($g(^DHCEQStoreMoveList(ListRowID)),"^",4)
	....d GetStatOtherInfo
	....;add by lmm 2019-11-22 begin
	....s (InStockID,AdjustInStockDate,AdjustStoreMoveDate)=""
	....i EquipID'=""  d
	.....s InStockListID=$p($g(^DHCEQEquip(EquipID)),"^",70)
	....i InStockListID'=""  d
	.....s InStockID=$p($g(^DHCEQInStockList(InStockListID)),"^",1)
	....i InStockID'=""  d
	.....s AdjustInStockDate=$p($g(^DHCEQInStock(InStockID)),"^",13)
	.....s AdjustStoreMoveDate=BillDate
	....;modify by lmm 2019-11-22 end
	....s SourceID=ListRowID
	....s RemainOriginalFee=$p($g(^DHCEQStoreMoveList(ListRowID)),"^",7)*$p($g(^DHCEQStoreMoveList(ListRowID)),"^",8)
	....d SplitFunds
	
	s SourceType="7"
	//汇总当期原值变动信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...s CAStatus=$p($g(^DHCEQChangeAccount(rowid)),"^",11)    //Add By CZF 2016-12-07
	...q:CAStatus'=2
	...s EquipID=$p($g(^DHCEQChangeAccount(rowid)),"^",1)
	...q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的调账	//modified by lmm 2020-12-30
	...//modified by ZY0293 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"52",rowid)
	...q:$p(result,"^",1)'=0
	...d InitStatInfoVariant
	...d GetStatOtherInfo
	...
	...s SourceID=rowid
	...s RemainOriginalFee=$p($g(^DHCEQChangeAccount(rowid)),"^",2)
	...d SplitFunds
	
	
	s SourceType="6"
	//汇总当期设备报废信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)    //Add By CZF 2016-12-07 begin
	...q:DRInvalidFlag="Y"
	...s DRStatus=$p($g(^DHCEQDisuseRequest(rowid)),"^",10)
	...q:DRStatus'=2			//Add By CZF 2016-12-07 end
	...;Modified By JDL 2011-9-16 JDL0096
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",10)'=2
	...s ListRowID=0
	...;Modified by JDL 2012-3-27 JDL0127 改用库房而非申请科室
	...s StoreLoc=$p($g(^DHCEQDisuseRequest(rowid)),"^",34)
	...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) q:(ListRowID="")  d
	....d InitStatInfoVariant
	....s EquipID=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的报废 //modified by lmm 2020-12-30
	....//modified by ZY0293 2022-01-27
	....s result=0
	....i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"34",rowid)
	....q:$p(result,"^",1)'=0
	....d GetStatOtherInfo
	....
	....s SourceID=ListRowID
	....s RemainOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27) //modified by lmm 2020-12-30
	....d SplitFunds
	
	s SourceType="1"
	//汇总当期设备折旧信息
	s StockStatus=0
	//add by lmm 2020-02-04 begin
	;modify by lmm 2021-01-21
	if ((NewSnapID'="")&&($d(^DHCEQSnapShot(NewSnapID,"Equip"))))
	{
		s rowid=0
		f  s rowid=$o(^DHCEQSnapShot(NewSnapID,"Equip",rowid)) q:(rowid="")  d	
		.s EquipData=$g(^DHCEQSnapShot(NewSnapID,"Equip",rowid))
		.d GetEquip
	}
	else
	{
		
		f  s StockStatus=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus)) q:StockStatus=""  d
		.;过滤尚未入库的
		.q:StockStatus="0"
		.
		.;Modified by JDL 2012-3-19 JDL0123
		.;月结中折旧应计算在折旧科室，而并非月末设备所在科室,并应记录净值
		.s StoreLocDR=0
		.f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocDR)) q:StoreLocDR=""  d
		..
		..s EquipType=0
		..f  s EquipType=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocDR,EquipType)) q:EquipType=""  d
		...q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		...s rowid=0
		...f  s rowid=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocDR,EquipType,rowid)) q:rowid=""  d
		....s EquipData=$g(^DHCEQEquip(rowid))
		....d GetEquip
	
	
	}
	;modify by lmm 2021-01-21
	
	
	;Modified By JDL 2012-3-22 JDL0126
	s SourceType="9"
	;Add by JDL 2011-6-22 JDL0086
	;汇总处理其他调整的数据,只取影响报表数据的
	s BillDate=StartDate-1	
	f  s BillDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	.s AdjustType=0
	.f  s AdjustType=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType)) q:((AdjustType=""))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType,rowid)) q:((rowid=""))  d
	...s ADStatus=$p($g(^DHCEQAdjustData(rowid)),"^",11) /// add by zy 2011-09-25 ZY0080
	...quit:ADStatus'="1"
	...//modified by ZY0293 2022-01-27
	...s result=0
	...i APRowID'="" s result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,"99",rowid)
	...q:$p(result,"^",1)'=0
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,ListRowID)) q:((ListRowID=""))  d
	....d InitStatInfoVariant
	....s EquipID=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的数据调整统计 //modified by lmm 2020-12-30
	....;Modified By JDL 2012-3-22 JDL0126
	....s SourceID=ListRowID
	....s RemainOriginalFee=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)
	....s RemainDepreTotal=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",15)
	....d SplitFunds
	....
	....;Modified By DJ0114 2013-2-26 调整数据重复计算
	....q
	....
	....;1:调整数据 2:新增数据 3:删除数据 4.取消报废 9.其他调整
	....;从From减少数据
	....i (AdjustType="1")||(AdjustType="3")  d
	.....s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4)  //2012-02-01 DJ0103
	.....s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",3) //2012-02-01 DJ0103
	.....s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",5)
	.....s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",6)
	.....i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)="1"  d
	......s UsedOther=-$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)
	......s StockOther=0
	.....e  d
	......s UsedOther=0
	......s StockOther=-$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)
	.....d AddStatListInfoNew
	....;从To增加数据
	....i (AdjustType="1")||(AdjustType="2")||(AdjustType="4")  d
	.....s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9) //2012-02-01 DJ0103
	.....s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8) //2012-02-01 DJ0103
	.....s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
	.....s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",11)
	.....i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)="1"  d
	......s UsedOther=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)
	......s StockOther=0
	.....e  d
	......s UsedOther=0
	......s StockOther=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",14)
	.....d AddStatListInfoNew
		
	////取当月没有数据，但是上月有的作为本期的期初和期末
	s EquipType=0
	f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s StatCat=0
	.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat)) q:StatCat=""  d
	..s Loc=0
	..f  s Loc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat,Loc)) q:Loc=""  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat,Loc,rowid)) q:rowid=""  d
	....s listInfo=$g(^DHCEQMonthReportList(rowid))
	....//增加入账形式的参数与报表类型的判断
	....s ReportType=+$p(listInfo,"^",46)
	....q:((AccountShape=1)&&(AccountShape'=ReportType))
	....q:((AccountShape=0)&&(ReportType'=0)&&(ReportType'=""))
	....
	....s Origin=$p(listInfo,"^",26)			///Hold1原值变动 Hold2-->Origin    Used by DT
	....i Origin="" s Origin=0
	....s EquipType=$p(listInfo,"^",27)
	....s FundsType=$p(listInfo,"^",38)
	....i FundsType="" s FundsType=SelfFundsType
	....i FundsType="" s FundsType=0
	....//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	....s FinaceItem=$p(listInfo,"^",41)
	....i FinaceItem="" s FinaceItem=0
	....s FunctionCat=$p(listInfo,"^",42)
	....i FunctionCat="" s FunctionCat=0
	....q:$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType,FinaceItem,FunctionCat))'=""
	....//End By QW 20190410 BUG:QW0027
	....d InitStatInfoVariant
	....s StoreLoc=Loc
	....d AddStatListInfoNew
	
		
	quit
	;add by lmm 2020-02-21
GetEquip
		q:($p(EquipData,"^",59)'="N")
		s StockStatus=$p(EquipData,"^",60)
		q:(StockStatus="0")
		s StoreLocDR=$p(EquipData,"^",67)
		s EquipType=$p(EquipData,"^",63)
		s JYEquipTypeDR=##class(web.DHCEQCommon).GetSysInfo("990053")	;获取系统中简易类组配置
		//q:(JYEquipTypeDR'="")&&(JYEquipTypeDR=EquipType)
		q:(JYEquipTypeDR'="")&&((","_JYEquipTypeDR_",")[(","_EquipType_","))  // MZY0127	2642233		2022-06-15
		q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		d InitStatInfoVariant
		s EquipID=rowid
		q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的折旧
		;Modified by JDL 2012-3-19 JDL0123 净值取设备台帐中对应的科室
		s StoreLoc=StoreLocDR
		d GetStatOtherInfo
		;非报废,非无效,非退货减少 才取期末净值
		i (($p(EquipData,"^",38)'=3)&&($p(EquipData,"^",59)'="Y")&&(StockStatus'="3"))  d
		.s SourceID=rowid
		.s RemainOriginalFee=$p(EquipData,"^",27)
		.s RemainDepreTotal=$p(EquipData,"^",35)
		.s RemainNetFee=$p(EquipData,"^",28)
		.d SplitFunds
		;Modified by JDL JDL0111	修正错误	月结统计中净值计算有误
		s NetFee=0
		s MonthDepreID=0
		f  s MonthDepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipID,MonthStr,MonthDepreID)) q:MonthDepreID=""  d
		.q:$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",43)="Y"		;过滤无效折旧记录 czf 2020-12-29
		.q:$p(^DHCEQMonthDepre(MonthDepreID),"^",3)'="Y"
		.s MDStatus=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",20)	//DJ0136
		.q:MDStatus="3"
		.;折旧分摊
		.s CADRowID=0
		.s CADFlag=0
		.s CADDepreFee=0
		.;Modified By JDL 2011-9-16 JDL0096
		.f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",MonthDepreID,CADRowID)) q:CADRowID=""  d
		..q:$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",11)="Y" ;过滤无效记录 czf 2020-12-29
		..s CADFlag=CADFlag+1
		..s FundsType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
		..i FundsType="" s FundsType=SelfFundsType
		..q:(FundsTypeDR'="")&&(FundsType'=FundsTypeDR)
		..s Depre=+$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
		..;Modified by JDL 2012-3-19 JDL0123 取折旧分配明细中对应的科室
		..s StoreLoc=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
		..//Modify by zx 2021-07-31 获取折旧分摊表的核算项目信息 BUG ZX0138
		..s FinaceItem=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",9)
		..s FunctionCat=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",10)
		..d AddStatListInfoNew
		.i CADFlag=0  d
		..q:(FundsTypeDR'="")&&(SelfFundsFlag'=FundsTypeDR)
		..s Depre=$p(^DHCEQMonthDepre(MonthDepreID),"^",14)
		..
		..;Modified by JDL 2012-3-19 JDL0123 取折旧表中对应的科室
		..s StoreLoc=$p(^DHCEQMonthDepre(MonthDepreID),"^",33)
		..
		..d AddStatListInfoNew
	quit
	;add by lmm 2020-02-21
AddStatListInfoNew
	;Modified by jdl 2011-3-31 jdl0076
	s (StockBegin,UsedBegin)=0
	
	i FundsType="" s FundsType=SelfFundsType
	i FundsType="" s FundsType=0
	i (FundsTypeDR'="")&&(FundsType'=FundsTypeDR) q
	
	i Origin="" s Origin=0
	//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	i FinaceItem=""  s FinaceItem=0
	i FunctionCat="" s FunctionCat=0
	//End By QW BUG:QW0027 资金来源核算项目及功能分类
	s listInfo=$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin,FundsType,FinaceItem,FunctionCat))  //Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s StockEnd=StockBegin+StockIn-StockMoveOut-StockReturn-StockReduce+StockMoveIn
	;增加 库房转移(入),库房转移(出)
	s StockEnd=StockEnd+StoreMoveIn-StoreMoveOut
	s UsedEnd=UsedBegin+UsedIn-UsedReturn+UsedMoveIn-UsedMoveOut-Disused+ChangeAccount
	
	;Add by JDL 2011-6-22 JDL0086
	s StockEnd=StockEnd-StockDisused+StockChangeAccount+StockOther
	s UsedEnd=UsedEnd-UsedReduce+UsedOther
	
	if listInfo=""
	{
		s TotalDepre=0
		s preRowId=0
		f  s preRowId=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat,StoreLoc,preRowId)) q:preRowId=""  d
		.q:(Origin'=$p($g(^DHCEQMonthReportList(preRowId)),"^",26))
		.q:(EquipType'=$p($g(^DHCEQMonthReportList(preRowId)),"^",27))
		.q:(FundsType'=$p($g(^DHCEQMonthReportList(preRowId)),"^",38))
		.//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
		.q:(FinaceItem'=$p($g(^DHCEQMonthReportList(preRowId)),"^",41))
		.q:(FunctionCat'=$p($g(^DHCEQMonthReportList(preRowId)),"^",42))
		.//End By QW 20190410 BUG:QW0027
		.////增加入账形式的参数与报表类型的判断
		.s preMRLAccountShape=+$p($g(^DHCEQMonthReportList(preRowId)),"^",46)
		.q:(AccountShape=1)&&(AccountShape'=preMRLAccountShape)
		.q:(AccountShape=0)&&(preMRLAccountShape'="")&&(preMRLAccountShape'=0)
		.s StockBegin=+StockBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",12)	///在库 上月期末为本月期初
		.s UsedBegin=+UsedBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",19)	///在用 上月期末为本月期初
		.s StockEnd=+StockEnd+StockBegin
		.s UsedEnd=+UsedEnd+UsedBegin
		.;累计折旧取上期累计折旧+本期折旧
		.s TotalDepre=+$p($g(^DHCEQMonthReportList(preRowId)),"^",28)
		s TotalDepre=+Depre+TotalDepre

		;Modified by JDL 2011-6-22 JDL0086
		s listInfo=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_ChangeAccount_"^"_TotalDepre_"^"_Depre_"^"_StockDisused_"^"_StoreMoveIn_"^"_StoreMoveOut_"^"_NetFee_"^"_StockChangeAccount_"^"_UsedReduce_"^"_StockOther_"^"_UsedOther_"^"_StockCATotalDepre_"^"_UsedCATotalDepre
		
	}
	else
	{
		s $p(listInfo,"^",1)=+$p(listInfo,"^",1)+StockBegin
		s $p(listInfo,"^",2)=+$p(listInfo,"^",2)+StockIn
		s $p(listInfo,"^",3)=+$p(listInfo,"^",3)+StockReturn
		s $p(listInfo,"^",4)=+$p(listInfo,"^",4)+StockReduce
		s $p(listInfo,"^",5)=+$p(listInfo,"^",5)+StockMoveOut
		s $p(listInfo,"^",6)=+$p(listInfo,"^",6)+StockMoveIn
		s $p(listInfo,"^",7)=+$p(listInfo,"^",7)+StockEnd
		
		s $p(listInfo,"^",8)=+$p(listInfo,"^",8)+UsedBegin
		s $p(listInfo,"^",9)=+$p(listInfo,"^",9)+UsedIn
		s $p(listInfo,"^",10)=+$p(listInfo,"^",10)+UsedReturn
		s $p(listInfo,"^",11)=+$p(listInfo,"^",11)+UsedMoveIn
		s $p(listInfo,"^",12)=+$p(listInfo,"^",12)+UsedMoveOut
		s $p(listInfo,"^",13)=+$p(listInfo,"^",13)+Disused
		s $p(listInfo,"^",14)=+$p(listInfo,"^",14)+UsedEnd
		
		s $p(listInfo,"^",15)=+$p(listInfo,"^",15)+ChangeAccount
		
		;增加 库房转移(入),库房转移(出)
		;Modified By JDL 2013-5-27 JDL0132 调整数据中 新增及减少 需要计算累计折旧，即如果有累计折旧变动，需在funds里有。
		;
		i SourceType=9
		{
			s $p(listInfo,"^",16)=+$p(listInfo,"^",16)+DepreTotal		;TotalDepre
		}
		else
		{
			s $p(listInfo,"^",16)=+$p(listInfo,"^",16)+Depre		;TotalDepre
		}
		s $p(listInfo,"^",17)=+$p(listInfo,"^",17)+Depre
		s $p(listInfo,"^",18)=+$p(listInfo,"^",18)+StockDisused
		s $p(listInfo,"^",19)=+$p(listInfo,"^",19)+StoreMoveIn
		s $p(listInfo,"^",20)=+$p(listInfo,"^",20)+StoreMoveOut
		s $p(listInfo,"^",21)=+$p(listInfo,"^",21)+NetFee
		
		;Add by JDL 2011-6-22 JDL0086
		s $p(listInfo,"^",22)=+$p(listInfo,"^",22)+StockChangeAccount
		s $p(listInfo,"^",23)=+$p(listInfo,"^",23)+UsedReduce
		s $p(listInfo,"^",24)=+$p(listInfo,"^",24)+StockOther
		s $p(listInfo,"^",25)=+$p(listInfo,"^",25)+UsedOther
		;Add By DJ 2015-01-21 DJ0135
		s $p(listInfo,"^",26)=+$p(listInfo,"^",26)+StockCATotalDepre
		s $p(listInfo,"^",27)=+$p(listInfo,"^",27)+UsedCATotalDepre
	}
	s ^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin,FundsType,FinaceItem,FunctionCat)=listInfo  //Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	quit
InitStatInfoVariant
	s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
	s (TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut)=0	
	s NetFee=0
	;Add by JDL 2011-6-22 JDL0086
	s (StockChangeAccount,UsedReduce,StockOther,UsedOther)=0
	
	s (RemainOriginalFee,RemainDepreTotal,RemainNetFee,FundsFee)=0
	;Add By DJ 2015-01-21 DJ0135
	s (StockCATotalDepre,UsedCATotalDepre)=0
	q
GetStatOtherInfo	;根据InStockListID和EquipID获取信息:StatCat,Origin
	;modify by lmm 2021-01-21
	i EquipID'=""  d
	.if ((NewSnapID'="")&&($d(^DHCEQSnapShot(NewSnapID,"Equip"))))  d
	..s Origin=$p($g(^DHCEQSnapShot(NewSnapID,"Equip",EquipID)),"^",20) //modified by lmm 2019-11-22
	..s StatCat=$p($g(^DHCEQSnapShot(NewSnapID,"Equip",EquipID)),"^",75)
	.e  d
	..s Origin=$p($g(^DHCEQEquip(EquipID)),"^",20)
	..s StatCat=$p($g(^DHCEQEquip(EquipID)),"^",75)
	e  d
	.s Origin=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",15)
	.;Mozy0077	2012-2-21	从设备表中获取设备类型
	.Set StatCat= ..GetEquipTypeByInStockList(InStockListID,NewSnapID)      //modify by lmm 2019-11-25
	.If StatCat'="" Do
	..Set StatCat=$Piece(StatCat,"^",2)
	.Else  Do
	..s StatCat=$p($g(^DHCEQInStockList(InStockListID)),"^",17)
	..i StatCat="" s StatCat=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",21)
	q
SplitFunds
	;modify by lmm 2020-01-20
	if ((SourceType="1")&&(NewSnapID'="")&&($d(^DHCEQSnapShot(NewSnapID,"Funds",SourceID))))
	{
		s FundsID=0
		f  s FundsID=$o(^DHCEQSnapShot(NewSnapID,"Funds",SourceID,FundsID)) q:(FundsID="")  d	
		.s FundsData=$g(^DHCEQSnapShot(NewSnapID,"Funds",SourceID,FundsID))
		.d GetFunds
		
	}else
	{
		s FundsID=0
		f  s FundsID=$o(^DHCEQFunds(0,"Source",SourceType,SourceID,FundsID)) q:(FundsID="")  d
		.;Modify by zx 2021-07-07 BUG ZX0136
		.;s FundsData=$g(^DHCEQFunds(0,"Source",SourceType,SourceID,FundsID))
		.s FundsData=$g(^DHCEQFunds(FundsID))
		.d GetFunds
	}
	
	;Modify by zx 2021-07-31 退出循环后执行 BUG ZX0138
	;如果有剩余金额,记在系则统参数设置中的默认资金来源中
	i RemainOriginalFee'=0  d
	.s FundsType=SelfFundsType
	.s FundsFee=RemainOriginalFee
	.i SourceType="1"  d
	..s NetFee=RemainNetFee
	..s DepreTotal=RemainDepreTotal
	.;Modified By JDL 2012-3-22 JDL0126 调整数据时,要根据情况处理累计折旧
	.i SourceType="9"  d
	..s DepreTotal=RemainDepreTotal
	.d AddFundsInfo
	q
GetFunds
	q:$p(FundsData,"^",10)="Y"		;F_InvalidFlag
	q:$p(FundsData,"^",6)="2"		;F_OperFlag
	s FundsType=$p(FundsData,"^",2)
	i FundsType="" s FundsType=SelfFundsType
	//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s FinaceItem=$p(FundsData,"^",20)
	s FunctionCat=$p(FundsData,"^",21)
	i FinaceItem=""  s FinaceItem=0
	i FunctionCat="" s FunctionCat=0
	//End By QW 20190410 BUG:QW0027
	s FundsFee=+$p(FundsData,"^",3)
	s DepreTotalFundsFee=+$p(FundsData,"^",13)	//DJ0135
	s RemainOriginalFee=RemainOriginalFee-FundsFee
	;根据设备获取 净值等信息
	i SourceType="1"  d
	.s DepreTotal=$p(FundsData,"^",13)
	.s RemainDepreTotal=RemainDepreTotal-DepreTotal
	.s NetFee=FundsFee-DepreTotal
	.;Modified by JDL 2012-1-17 JDL0112 修改调账相关程序 净值不能小于0
	.i NetFee<0 s NetFee=0
	.s RemainNetFee=RemainNetFee-NetFee
	d AddFundsInfo
	//Modify by zx 2021-08-01 净值等汇总bug BUG ZX0138
	;modify by lmm 2020-01-20
	;如果有剩余金额,则记在系统参数设置中的默认 资金来源中
	/*i RemainOriginalFee'=0  d
	.s FundsType=SelfFundsType
	.s FundsFee=RemainOriginalFee
	.i SourceType="1"  d
	..s NetFee=RemainNetFee
	..s DepreTotal=RemainDepreTotal
	.;Modified By JDL 2012-3-22 JDL0126 调整数据时,要根据情况处理累计折旧
	.i SourceType="9"  d
	..s DepreTotal=RemainDepreTotal
	.d AddFundsInfo*/
	
	q
AddFundsInfo
	i SourceType="1"  d
	.;获取当前的净值信息   原值(根据期初和变动计算)、累计折旧(上期累计+本期折旧)
	.
	else  if SourceType="3"  d
	.;当期入库金额
	.s StockIn=FundsFee
	else  if SourceType="4"  d
	.;modify by lmm 2019-11-25 begin 增加记录差异记录
	.s (FromStatus,ToStatus,FromLoc,ToLoc,FromOringinalFee,ToOringinalFee,FromDepreTotalFee,ToDepreTotalFee,FromNetFee,ToNetFee)=""
	.;当期转移
	.;0:库房分配|1:科室间调配|2:报废转废品库|3:科室退库|4:库房转移
	.s StatCat=$p($g(^DHCEQEquip(+$g(^DHCEQStoreMoveList(ListRowID,"EX","RowIDs")))),"^",75)	// MZY0127	2642233		2022-06-15
	.if $p($g(^DHCEQStoreMove(rowid)),"^",12)="0"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s StockMoveOut=FundsFee
	..s UsedIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s StockMoveOut=0
	..s UsedIn=FundsFee
	..s FromStatus=0
	..s ToStatus=1
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="1"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s UsedMoveOut=FundsFee
	..s UsedMoveIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s UsedMoveOut=0
	..s UsedMoveIn=FundsFee
	..s FromStatus=1
	..s ToStatus=1
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="3"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s UsedReturn=FundsFee
	..s StockMoveIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s UsedReturn=0
	..s StockMoveIn=FundsFee
	..s FromStatus=1
	..s ToStatus=0
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="4"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s StoreMoveIn=0
	..s StoreMoveOut=FundsFee
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s StoreMoveIn=FundsFee
	..s StoreMoveOut=0
	..s FromStatus=1
	..s ToStatus=1
	.s FromLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	.s ToLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	.s ToOringinalFee=FundsFee
	.s FromOringinalFee=FundsFee
	.s ToDepreTotalFee=DepreTotalFundsFee
	.s FromDepreTotalFee=DepreTotalFundsFee
	.s ToNetFee=FundsFee-DepreTotalFundsFee
	.s FromNetFee=FundsFee-DepreTotalFundsFee
	.i (AdjustInStockDate>AdjustStoreMoveDate)  d
	..s ^DHCEQDiffentInfo("SourceType",SourceType,rowid)=SourceType_"^"_rowid_"^"_FromStatus_"^"_ToStatus_"^"_FromLoc_"^"_ToLoc_"^"_FromOringinalFee_"^"_ToOringinalFee_"^"_FromDepreTotalFee_"^"_ToDepreTotalFee_"^"_FromNetFee_"^"_ToNetFee
	.;modify by lmm 2019-11-25 end
	else  if SourceType="5"  d
	.;当期退货及减少
	.i OutTypeCode="TH" d
	..s StockReturn=FundsFee	;退货费用
	.e  d
	..;根据减少单是否有使用科室,来区分是在库减少、在用减少
	..i $p($g(^DHCEQReturn(rowid)),"^",24)="" d
	...s StockReduce=FundsFee	;其他减少费用
	..e  d
	...s StoreLoc=$p($g(^DHCEQReturn(rowid)),"^",24)
	...s UsedReduce=FundsFee	;其他减少费用
	.s StatCat=$p($g(^DHCEQEquip(+$g(^DHCEQReturnList(ListRowID,"EX","RowIDs")))),"^",75)	// MZY0127	2642233		2022-06-15
	else  if SourceType="6"  d
	.;当期报废的
	.;Hold1区分在库的和在用的
	.//midified by zy 2015-7-1 ZY0134 
	.//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	.//i ($p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)="1")||($p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)="2")  d
	.i $p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)'="0"  d
	..s Disused=FundsFee
	.e  d
	..s StockDisused=FundsFee	;报废为在库的
	.s StatCat=$p($g(^DHCEQEquip(+$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2))),"^",75)	// MZY0127	2642233		2022-06-15
	else  if SourceType="7"  d
	.;当期调账的
	.;Hold1区分在库的和在用的调账
	.//midified by zy 2015-7-1 ZY0134 
	.//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	.i ($p($g(^DHCEQChangeAccount(rowid)),"^",32)'="0")  d
	..s ChangeAccount=FundsFee
	..s UsedCATotalDepre=DepreTotalFundsFee		//DJ0135
	.e  d
	..s StockChangeAccount=FundsFee
	..s StockCATotalDepre=DepreTotalFundsFee		//DJ0135
	.s StoreLoc=$p($g(^DHCEQChangeAccount(rowid)),"^",28)
	.s StatCat=$p($g(^DHCEQChangeAccount(rowid)),"^",31)	// MZY0127	2642233		2022-06-15
	else  if SourceType="9"  d
	.;Modified By JDL 2012-3-22 JDL0126 调整数据时,要根据情况处理原值及累计折旧
	.;当期后台调整的数据
	.;1:调整数据 2:新增数据 3:删除数据 4.取消报废 9.其他调整
	.;从From减少数据
	.i (AdjustType="1")||(AdjustType="3")  d
	..s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4)  //2012-02-01 DJ0103
	..s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",3) //2012-02-01 DJ0103
	..s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",5)
	..s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",6)
	..;调整数据 累计折旧减少
	..s DepreTotal=-DepreTotal
	..i (AdjustType="3") s DepreTotal=0
	..//midified by zy 2015-7-1 ZY0134 
	..//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	..i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
	...s UsedOther=-FundsFee
	...s StockOther=0
	..e  d
	...s UsedOther=0
	...s StockOther=-FundsFee
	..d AddStatListInfoNew
	.;从To增加数据
	.i (AdjustType="1")||(AdjustType="2")||(AdjustType="4")  d
	..s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9) //2012-02-01 DJ0103
	..s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8) //2012-02-01 DJ0103
	..s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
	..s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",11)
	..i (AdjustType="4") s DepreTotal=0
	..//midified by zy 2015-7-1 ZY0134 
	..//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	..i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)'="0"  d
	...s UsedOther=FundsFee
	...s StockOther=0
	..e  d
	...s UsedOther=0
	...s StockOther=FundsFee
	..d AddStatListInfoNew
	s DepreTotal=0
	if SourceType'="9" d AddStatListInfoNew
	q
}

/// ##Class(web.DHCEQReport).GetOneStatCatReportNew(1,"2008-04","",5)
ClassMethod GetOneStatCatReportNew(StatCat, MonthStr, LocDR As %String = "", PreOrigin As %String = "", Job As %String = "")
{
	i StatCat="" q ""
	i MonthStr="" q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
	s Result=""
	s HasResult=0
	s curOrigin=""
	
	s EquipType=0
	f  s EquipType=$o(^DHCEQTemp("MonthReport","Stat",User,Job,Year,Month,EquipType)) q:(EquipType="")||(HasResult=1)  d
	.q:(..EquipTypeIsIn(EquipType))
	.s Origin=$o(^DHCEQTemp("MonthReport","Stat",User,Job,Year,Month,EquipType,StatCat,PreOrigin))
	.if (Origin'="")  d
	..s HasResult=1
	..s curOrigin=Origin
	..s OriginDesc=$p($g(^DHCEQCCode("DHCEQCOrigin",curOrigin)),"^",2)
	..s Result=$g(^DHCEQTemp("MonthReport","Stat",User,Job,Year,Month,EquipType,StatCat,Origin))
	i HasResult=0 q ""
	if Result="" s Result=..#ListInfoInit
	q Result_"^"_StatCatDesc_"^"_curOrigin_"^"_OriginDesc
}

/// 得到结存月报的列表
Query GetStatLocChange(ValStatCat, StartDate, EndDate, MonthStr, LocDR As %String = "") As %Query(ROWSPEC = "LocDR:%String,Loc:%String,StockBegin:%String,StockIn:%String,StockReturn:%String,StockReduce:%String,StockMoveOut:%String,StockMoveIn:%String,StockEnd:%String,UsedBegin:%String,UsedIn:%String,UsedReturn:%String,UsedMoveIn:%String,UsedMoveOut:%String,Disused:%String,UsedEnd:%String,StartDate:%String,EndDate:%String,MonthStr:%String,TotalEnd:%String,ChangeAccount:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReport","GetStatLocChange","","2008-03-01","2008-03-31","2008-03")
ClassMethod GetStatLocChangeExecute(ByRef qHandle As %Binary, ValStatCat, StartDate, EndDate, MonthStr, LocDR As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
 	
 	new Year,Month,PreYear,PreMonth,Loc,StatCat,BillDate,type,tmpfee,StoreLoc
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount
 	new EquipType
 	s (Year,Month,PreYear,PreMonth,Loc,StatCat)=""
 	s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0 	
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s Date=+$H
	s Time=$p($H,",",2)
	
	///s StockBegin=StartDate
	///d OutputRowStatReportNew
	///q $$$OK
	
	q:(StartDate="")&&(EndDate="") $$$OK
	q:MonthStr="" $$$OK
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	if (Month=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Month-1}
		
	
 	k ^TempDHCEQ("MonthReport","StatLoc",User,Year,Month)
	
	i '$d(^DHCEQMonthReportList(0,"Loc",Year,Month))
	{	
		
		d ..FillStatListInfo(User,Year,Month,StartDate,EndDate) 
		
		k ^TempDHCEQ("MonthReport","StatLoc",User,Year,Month)
		
		s EquipType=0
		f  s EquipType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType)) q:EquipType=""  d
		.;User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin
		.s Loc=0
		.f  s Loc=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:Loc=""  d
		..q:((LocDR'="")&&(LocDR'=Loc))
		..
		..s StatCat=0
		..f  s StatCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:StatCat=""  d
		...q:((ValStatCat'="")&&((","_ValStatCat_",")'[(","_StatCat_",")))
		...s Origin=""
		...f  s Origin=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:Origin=""  d
		....
		....;Modified by jdl 2011-12-28 JDL0107
		....s FundsType=""
		....f  s FundsType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:FundsType=""  d
		.....s listInfo=$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType))
		.....d AddStatLocInfo
		
		/*
		s StatCat=0
		f  s StatCat=$o(^DHCEQCCode("DHCEQCStatCat",StatCat)) q:StatCat=""  d
		.q:((ValStatCat'="")&&((","_ValStatCat_",")'[(","_StatCat_",")))
		.s listInfo=$g(^TempDHCEQ("MonthReport","Stat",User,Year,Month,StatCat))
		.s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
		.i listInfo=""  d
		..s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd)=0
		..///////取上期期末作为本期期初
		..s Loc=0
		..f  s Loc=$o(^DHCEQMonthReportList(0,"StatCat",PreYear,PreMonth,StatCat,Loc)) q:Loc=""  d
		...q:((LocDR'="")&&(LocDR'=Loc))
		...s preRowId=0
		...f  s preRowId=$o(^DHCEQMonthReportList(0,"StatCat",PreYear,PreMonth,StatCat,Loc,preRowId)) q:preRowId=""  d
		....s StockBegin=+StockBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",12)
		....s UsedBegin=+UsedBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",19)
		....s StockEnd=StockBegin
		....s UsedEnd=UsedBegin
		..s listInfo=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd
		..d AddStatLocInfo
		*/
		/*
		.e  d
		..s StockBegin=$p(listInfo,"^",1)
		..s StockIn=$p(listInfo,"^",2)
		..s StockReturn=$p(listInfo,"^",3)
		..s StockReduce=$p(listInfo,"^",4)
		..s StockMoveOut=$p(listInfo,"^",5)
		..s StockMoveIn=$p(listInfo,"^",6)
		..s StockEnd=$p(listInfo,"^",7)		
		..s UsedBegin=$p(listInfo,"^",8)
		..s UsedIn=$p(listInfo,"^",9)
		..s UsedReturn=$p(listInfo,"^",10)
		..s UsedMoveIn=$p(listInfo,"^",11)
		..s UsedMoveOut=$p(listInfo,"^",12)
		..s Disused=$p(listInfo,"^",13)
		..s UsedEnd=$p(listInfo,"^",14)
		.d OutputRowStatReportNew	*/			
	}
	else
	{
		s Loc=0
		f  s Loc=$o(^DHCEQMonthReportList(0,"Loc",Year,Month,Loc)) q:Loc=""  d
		.q:((LocDR'="")&&(LocDR'=Loc))
		.s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
		.s StatCat=0
		.f  s StatCat=$o(^DHCEQCCode("DHCEQCStatCat",StatCat)) q:StatCat=""  d
		..s rowid=0
		..f  s rowid=$o(^DHCEQMonthReportList(0,"Loc",Year,Month,Loc,StatCat,rowid)) q:rowid=""  d
		...s listInfo=$g(^DHCEQMonthReportList(rowid))
		...s StockBegin=+StockBegin+$p(listInfo,"^",6)
		...s StockIn=+StockIn+$p(listInfo,"^",7)
		...s StockReturn=+StockReturn+$p(listInfo,"^",8)
		...s StockReduce=+StockReduce+$p(listInfo,"^",9)
		...s StockMoveOut=+StockMoveOut+$p(listInfo,"^",10)
		...s StockMoveIn=+StockMoveIn+$p(listInfo,"^",11)
		...s StockEnd=+StockEnd+$p(listInfo,"^",12)
		...s UsedBegin=+UsedBegin+$p(listInfo,"^",13)
		...s UsedIn=+UsedIn+$p(listInfo,"^",14)
		...s UsedReturn=+UsedReturn+$p(listInfo,"^",15)
		...s UsedMoveIn=+UsedMoveIn+$p(listInfo,"^",16)
		...s UsedMoveOut=+UsedMoveOut+$p(listInfo,"^",17)
		...s Disused=+Disused+$p(listInfo,"^",18)
		...s UsedEnd=+UsedEnd+$p(listInfo,"^",19)
		...
		...s ChangeAccount=+ChangeAccount+$p(listInfo,"^",25)
		.s listInfo=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_ChangeAccount
		.d AddStatLocInfo
		.///d OutputRowStatReportNew
	}
	
	
	s StatCat=0
	f  s StatCat=$o(^DHCEQCCode("DHCEQCStatCat",StatCat)) q:StatCat=""  d
	
	s (StockBeginSum,StockInSum,StockReturnSum,StockReduceSum,StockMoveOutSum,StockMoveInSum,StockEndSum,UsedBeginSum,UsedInSum,UsedReturnSum,UsedMoveInSum,UsedMoveOutSum,DisusedSum,UsedEndSum,ChangeAccountSum)=0
	s Loc=0
	f  s Loc=$o(^TempDHCEQ("MonthReport","StatLoc",User,Year,Month,Loc)) q:Loc=""  d
	.q:((ValStatCat'="")&&((","_ValStatCat_",")'[(","_StatCat_",")))
	.s listInfo=$g(^TempDHCEQ("MonthReport","StatLoc",User,Year,Month,Loc))
	.///s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
	.s LocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",Loc)
	.s StockBegin=$p(listInfo,"^",1)
	.s StockIn=$p(listInfo,"^",2)
	.s StockReturn=$p(listInfo,"^",3)
	.s StockReduce=$p(listInfo,"^",4)
	.s StockMoveOut=$p(listInfo,"^",5)
	.s StockMoveIn=$p(listInfo,"^",6)
	.s StockEnd=$p(listInfo,"^",7)		
	.s UsedBegin=$p(listInfo,"^",8)
	.s UsedIn=$p(listInfo,"^",9)
	.s UsedReturn=$p(listInfo,"^",10)
	.s UsedMoveIn=$p(listInfo,"^",11)
	.s UsedMoveOut=$p(listInfo,"^",12)
	.s Disused=$p(listInfo,"^",13)
	.s UsedEnd=$p(listInfo,"^",14)
	.s ChangeAccount=$p(listInfo,"^",15)
	.
	.s StockBeginSum=StockBeginSum+StockBegin
	.s StockInSum=StockInSum+StockIn
	.s StockReturnSum=StockReturnSum+StockReturn
	.s StockReduceSum=StockReduceSum+StockReduce
	.s StockMoveOutSum=StockMoveOutSum+StockMoveOut
	.s StockMoveInSum=StockMoveInSum+StockMoveIn
	.s StockEndSum=StockEndSum+StockEnd
	.s UsedBeginSum=UsedBeginSum+UsedBegin
	.s UsedInSum=UsedInSum+UsedIn
	.s UsedReturnSum=UsedReturnSum+UsedReturn
	.s UsedMoveInSum=UsedMoveInSum+UsedMoveIn
	.s UsedMoveOutSum=UsedMoveOutSum+UsedMoveOut
	.s DisusedSum=DisusedSum+Disused
	.s UsedEndSum=UsedEndSum+UsedEnd
	.
	.s ChangeAccountSum=ChangeAccountSum+ChangeAccount
	.d OutputRowStatLocChange
	
	s Loc=0
	s LocDesc="总计:"
	s StockBegin=StockBeginSum
	s StockIn=StockInSum
	s StockReturn=StockReturnSum
	s StockReduce=StockReduceSum
	s StockMoveOut=StockMoveOutSum
	s StockMoveIn=StockMoveInSum
	s StockEnd=StockEndSum
	s UsedBegin=UsedBeginSum
	s UsedIn=UsedInSum
	s UsedReturn=UsedReturnSum
	s UsedMoveIn=UsedMoveInSum
	s UsedMoveOut=UsedMoveOutSum
	s Disused=DisusedSum
	s UsedEnd=UsedEndSum
	s ChangeAccount=ChangeAccountSum
	// 日期格式统一调整 mwz 2017-3-2
	s StartDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	d OutputRowStatLocChange
	
	Quit $$$OK
	
AddStatLocInfo
	s statInfo=$g(^TempDHCEQ("MonthReport","StatLoc",User,Year,Month,Loc))
	if statInfo=""
	{
		s statInfo=listInfo
	}
	else
	{
		s $p(statInfo,"^",1)=+$p(listInfo,"^",1)+$p(statInfo,"^",1)
		s $p(statInfo,"^",2)=+$p(listInfo,"^",2)+$p(statInfo,"^",2)
		s $p(statInfo,"^",3)=+$p(listInfo,"^",3)+$p(statInfo,"^",3)
		s $p(statInfo,"^",4)=+$p(listInfo,"^",4)+$p(statInfo,"^",4)
		s $p(statInfo,"^",5)=+$p(listInfo,"^",5)+$p(statInfo,"^",5)
		s $p(statInfo,"^",6)=+$p(listInfo,"^",6)+$p(statInfo,"^",6)
		s $p(statInfo,"^",7)=+$p(listInfo,"^",7)+$p(statInfo,"^",7)
		
		s $p(statInfo,"^",8)=+$p(listInfo,"^",8)+$p(statInfo,"^",8)
		s $p(statInfo,"^",9)=+$p(listInfo,"^",9)+$p(statInfo,"^",9)
		s $p(statInfo,"^",10)=+$p(listInfo,"^",10)+$p(statInfo,"^",10)
		s $p(statInfo,"^",11)=+$p(listInfo,"^",11)+$p(statInfo,"^",11)
		s $p(statInfo,"^",12)=+$p(listInfo,"^",12)+$p(statInfo,"^",12)
		s $p(statInfo,"^",13)=+$p(listInfo,"^",13)+$p(statInfo,"^",13)
		s $p(statInfo,"^",14)=+$p(listInfo,"^",14)+$p(statInfo,"^",14)
		s $p(statInfo,"^",15)=+$p(listInfo,"^",15)+$p(statInfo,"^",15)		 
	}
	s ^TempDHCEQ("MonthReport","StatLoc",User,Year,Month,Loc)=statInfo
	quit

OutputRowStatLocChange
	s TotalEnd=+StockEnd+UsedEnd
	s Data=$lb(Loc,LocDesc,StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,StartDate,EndDate,MonthStr,TotalEnd,ChangeAccount)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetStatLocChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatLocChangeExecute ]
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

ClassMethod GetStatLocChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatLocChangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOneStatLocChange(Loc, MonthStr)
{
	i MonthStr="" q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	s Loc=$o(^TempDHCEQ("MonthReport","StatLoc",User,Year,Month,Loc))
	i Loc="" q ""
	s LocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",Loc)	
	q ^TempDHCEQ("MonthReport","StatLoc",User,Year,Month,Loc)_"^"_LocDesc_"^"_Loc
}

/// 
/// Modified By Jdl 2011-12-27 JDL0107
/// 初始化数据增加资金来源
/// -----------------------------------
/// 重新整理 2010-10-27
/// 根据系统现有数据对系统初始化月结：
/// 入参：IsCurMonth   0:上月  1:当月
/// 	  EquipTypeIDS 设备类组串，以","分割，为空表示全部初始化
/// 	  StoreLocDR	库房：要初始化的库房及其所管理的科室
/// w ##Class(web.DHCEQReport).InitReport(0)
ClassMethod InitReport(IsCurMonth, EquipTypeIDS As %Library.String = "", StoreLocDR As %Library.String = "", vMonthStr As %Library.String = "")
{
	new Loc,EquipType,StatCat,RowId
	new User,Year,Month,Origin
	new StockEnd,UsedEnd,DepreTotal,NetFee
	
	new FundsID,FundsType,SelfFundsType,FinaceItem,FunctionCat //Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类 
	new RemainOriginalFee,RemainDepreTotal,RemainNetFee,Fee
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	
	k ^TempDHCEQ("InitMonthReport",$j)
	i EquipTypeIDS'="" s EquipTypeIDS=","_EquipTypeIDS_","
	///s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vMonthStr'=""		//modified by lmm 2019-11-22
	{
		s Year=$p(vMonthStr,"-",1)
		s Month=$p(vMonthStr,"-",2)
	}
	else
	{
		s Year=+$p($ZD($H,3),"-",1)
		s Month=+$p($ZD($H,3),"-",2)
	}
	k PLIST
	s PLIST(2) = Year
	s PLIST(3) = Month
	///s PLIST(4) = Loc
	s PLIST(5) =Year_"-"_Month   //$p($ZD($H,3),"-",1,2)
	
	i IsCurMonth=0
	{
		i +PLIST(3)>1
		{
			s PLIST(3)=PLIST(3)-1
		}
		else
		{
			s PLIST(2)=PLIST(2)-1
			s PLIST(3)=12
		}
		i PLIST(3)<10 s PLIST(3)="0"_PLIST(3)
		s PLIST(5)=PLIST(2)_"-"_PLIST(3)
	}
	///s PLIST(6) = StatCat
	s PLIST(21) = 1			;StartDate
	s PLIST(22) = +$H		;EndDate
	
	for i=7:1:20  s PLIST(i)=0
	s CountNum=0
	s SQLCODE=0
	//add by lmm 2019-11-24 begin
	//s vMonthStr="2019-05"
	//vNextMonthStr=
	s NewSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(vMonthStr,"Equip")
	i NewSnapID="" s NewSnapID=1
	s RowId=0
	f  s RowId=$o(^DHCEQSnapShot(NewSnapID,"Equip",RowId)) q:((RowId="")||(SQLCODE'=0))  d
	.s Loc=$p(^DHCEQSnapShot(NewSnapID,"Equip",RowId),"^",67)
	.q:(StoreLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ("1",Loc,StoreLocDR,0)))
	.s EquipType=$p(^DHCEQSnapShot(NewSnapID,"Equip",RowId),"^",63)
	.q:(EquipTypeIDS'="")&&(EquipTypeIDS'[(","_EquipType_","))
	.///过滤出库状态、未入库状态、无效标志、报废设备
	.s StatCat=$p(^DHCEQSnapShot(NewSnapID,"Equip",RowId),"^",75)
	.s StockStatus=$p(^DHCEQSnapShot(NewSnapID,"Equip",RowId),"^",60)
	.q:StockStatus="3"
	.q:StockStatus="0"
	.s InvalidFlag=$p(^DHCEQSnapShot(NewSnapID,"Equip",RowId),"^",59)
	.q:InvalidFlag="Y"
	.;报废状态的过滤
	.q:(+$p(^DHCEQSnapShot(NewSnapID,"Equip",RowId),"^",38))>2
	.
	.s RemainDepreTotal=+$p($g(^DHCEQSnapShot(NewSnapID,"Equip",RowId)),"^",35)
	.s RemainNetFee=+$p($g(^DHCEQSnapShot(NewSnapID,"Equip",RowId)),"^",28)
	.s RemainOriginalFee=+$p($g(^DHCEQSnapShot(NewSnapID,"Equip",RowId)),"^",27)
	.s FundsID=0
	.f  s FundsID=$o(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID)) q:((FundsID="")||(SQLCODE'=0))  d
	..s (FinaceItem,FunctionCat)=""  //add by lmm 2020-02-21
	..q:$p(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID),"^",10)="Y"		;F_InvalidFlag
	..q:$p(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID),"^",6)="2"		;F_OperFlag
	..s FundsType=$p(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID),"^",2)
	..i FundsType="" s FundsType=SelfFundsType
	..//Add By lmm 2020-02-21 LMM0063 资金来源核算项目及功能分类
	..s FinaceItem=$p(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID),"^",20)  //$p(^DHCEQFunds(FundsID),"^",20)
	..s FunctionCat=$p(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID),"^",21)  //$p(^DHCEQFunds(FundsID),"^",21)
	..//Add By lmm 2020-02-21 LMM0063 
	..
	..s Fee=+$p($g(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID)),"^",3)
	..s DepreTotal=+$p($g(^DHCEQSnapShot(NewSnapID,"Funds",RowId,FundsID)),"^",13)
	..s RemainDepreTotal=RemainDepreTotal-DepreTotal
	..s NetFee=Fee-DepreTotal
	..s RemainNetFee=RemainNetFee-NetFee
	..s RemainOriginalFee=RemainOriginalFee-Fee
	..d AddInitReportInfo
	.;其他未计入资金来源的,计入系统参数设置中的自有资金来源
	.i (RemainOriginalFee'=0)||(RemainDepreTotal'=0)  d
	..s FundsType=SelfFundsType
	..s Fee=+RemainOriginalFee
	..s DepreTotal=RemainDepreTotal
	..s NetFee=RemainNetFee
	..d AddInitReportInfo
	
	/*	
	s Loc=0
	f  s Loc=$o(^DHCEQEquip(0,"StoreLocStatCat",Loc)) q:((Loc="")||(SQLCODE'=0))  d
	.q:(StoreLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ("1",Loc,StoreLocDR,0)))
	.s EquipType=0
	.f  s EquipType=$o(^DHCEQEquip(0,"StoreLocStatCat",Loc,EquipType)) q:((EquipType="")||(SQLCODE'=0))  d
	..q:(EquipTypeIDS'="")&&(EquipTypeIDS'[(","_EquipType_","))
	..s StatCat=0
	..f  s StatCat=$o(^DHCEQEquip(0,"StoreLocStatCat",Loc,EquipType,StatCat)) q:((StatCat="")||(SQLCODE'=0))  d
	...s RowId=0
	...f  s RowId=$o(^DHCEQEquip(0,"StoreLocStatCat",Loc,EquipType,StatCat,RowId)) q:((RowId="")||(SQLCODE'=0))  d
	....///过滤出库状态、未入库状态、无效标志、报废设备
	....s StockStatus=$p(^DHCEQEquip(RowId),"^",60)
	....q:StockStatus="3"
	....q:StockStatus="0"
	....s InvalidFlag=$p(^DHCEQEquip(RowId),"^",59)
	....q:InvalidFlag="Y"
	....;报废状态的过滤
	....q:(+$p(^DHCEQEquip(RowId),"^",38))>2
	....
	....s RemainDepreTotal=+$p($g(^DHCEQEquip(RowId)),"^",35)
	....s RemainNetFee=+$p($g(^DHCEQEquip(RowId)),"^",28)
	....s RemainOriginalFee=+$p($g(^DHCEQEquip(RowId)),"^",27)
	....s FundsID=0
	....;MODIFY BY LMM 2020-03-18 LMM0063
	....f  s FundsID=$o(^DHCEQFunds(0,"Equip",RowId,FundsID)) q:((FundsID="")||(SQLCODE'=0))  d
	.....q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.....q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.....s FundsType=$p(^DHCEQFunds(FundsID),"^",2)
	.....i FundsType="" s FundsType=SelfFundsType
	.....//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.....s FinaceItem=$p(^DHCEQFunds(FundsID),"^",20)
	.....s FunctionCat=$p(^DHCEQFunds(FundsID),"^",21)
	.....//End By QW 20190410 BUG:QW0027  
	.....s Fee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.....s DepreTotal=+$p($g(^DHCEQFunds(FundsID)),"^",13)
	.....s RemainDepreTotal=RemainDepreTotal-DepreTotal
	.....s NetFee=Fee-DepreTotal
	.....s RemainNetFee=RemainNetFee-NetFee
	.....s RemainOriginalFee=RemainOriginalFee-Fee
	.....d AddInitReportInfo
	....;其他未计入资金来源的,计入系统参数设置中的自有资金来源
	....i (RemainOriginalFee'=0)||(RemainDepreTotal'=0)  d
	.....s FundsType=SelfFundsType
	.....s Fee=+RemainOriginalFee
	.....s DepreTotal=RemainDepreTotal
	.....s NetFee=RemainNetFee
	.....d AddInitReportInfo
	*/
	
	TStart
	s Loc=0
	f  s Loc=$o(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc)) q:((Loc="")||(SQLCODE'=0))  d
	.s PLIST(4)=Loc
	.s EquipType=0
	.f  s EquipType=$o(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType)) q:((EquipType="")||(SQLCODE'=0))  d
	..s PLIST(28)=EquipType
	..s StatCat=0
	..f  s StatCat=$o(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat)) q:((StatCat="")||(SQLCODE'=0))  d
	...s PLIST(6) = StatCat
	...s Origin=""
	...f  s Origin=$o(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin)) q:((Origin="")||(SQLCODE'=0))  d
	....s PLIST(27)=Origin
	....s FundsType=""
	....f  s FundsType=$o(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType)) q:((FundsType="")||(SQLCODE'=0))  d
	.....
	.....s PLIST(39)=FundsType
	.....//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.....s FinaceItem=""
	.....f  s FinaceItem=$o(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem)) q:((FinaceItem="")||(SQLCODE'=0))  d
	......
	......s PLIST(42)=FinaceItem
	......s FunctionCat=""
	......f  s FunctionCat=$o(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem,FunctionCat)) q:((FunctionCat="")||(SQLCODE'=0))  d
	.......
	.......s PLIST(43)=FunctionCat
	.......
	.......s PLIST(13)=$p(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem,FunctionCat),"^",1)
	.......s PLIST(20)=$p(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem,FunctionCat),"^",2)
	.......s PLIST(29)=$p(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem,FunctionCat),"^",3)
	.......s PLIST(34)=$p(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem,FunctionCat),"^",4)
	.......///i Loc=24 b  ///StockEnd  UsedEnd
	.......&SQL(Insert Into SQLUSER.DHC_EQMonthReportList Values :PLIST())
	.......q:SQLCODE'=0
	.......//QW 20190410 BUG:QW002709
	i SQLCODE'=0
	{
		TRollBack
		q "Error:"_" StatCat="_StatCat_" Loc="_Loc_"  SQLCODE="_SQLCODE
	}
	else
	{
		//modifeid by ZY0298 2022-03-14
		w "报表初始化成功!",!
		s SQLCODE=##Class(web.DHCEQInit).InitAccountPeriod(PLIST(5), PLIST(21), PLIST(22), NewSnapID)
		i SQLCODE'=0
		{
			TRollBack
			q "Error:"_" 会计周期记录表初始化失败,  SQLCODE="_SQLCODE
		}
		else
		{
			TCommit
			k ^TempDHCEQ("InitMonthReport",$j)
			q "会计周期记录初始化成功!"
		}
	}
	
AddInitReportInfo
	s StockEnd=0
	s UsedEnd=0
	//midified by zy 2015-7-1 ZY0134 
	//修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
	if $p($g(^DHCEQSnapShot(NewSnapID,"Equip",RowId)),"^",38)'="0"	//modified by lmm 2019-11-22
		{	s UsedEnd=Fee}
	else
		{	s StockEnd=Fee}	
	s Origin=$p($g(^DHCEQSnapShot(NewSnapID,"Equip",RowId)),"^",20)	//modified by lmm 2019-11-22
	i Origin="" s Origin=0
	s CountNum=CountNum+1
	
	i FundsType="" s FundsType=SelfFundsType
	i FundsType="" s FundsType=0
	//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	i FinaceItem=""  s FinaceItem=0
	i FunctionCat=""  s FunctionCat=0
	//End By QW 20190410 BUG:QW0027 
	s ListInfo=$g(^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem,FunctionCat))
	if ListInfo'=""
	{
		s StockEnd=+$p(ListInfo,"^",1)+StockEnd
		s UsedEnd=+$p(ListInfo,"^",2)+UsedEnd
		s DepreTotal=+$p(ListInfo,"^",3)+DepreTotal
		s NetFee=+$p(ListInfo,"^",4)+NetFee
	}
	s ^TempDHCEQ("InitMonthReport",$j,Year,Month,Loc,EquipType,StatCat,Origin,FundsType,FinaceItem,FunctionCat)=StockEnd_"^"_UsedEnd_"^"_DepreTotal_"^"_NetFee
	q
}

/// 得到结存月报的列表
/// add by jdl 2010-10-27
/// 入参：StartMonth:YYYY-MM  该参数必需
/// 	  EndMonth:YYYY-MM	该参数可选，为空时表示与StartMonth一致
Query MonthReport(StartMonth, EndMonth, LocDR As %String = "", EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", AccountShape As %String = "0") As %Query(ROWSPEC = "StatCatID:%String,StatCat:%String,StockBegin:%String,StockIn:%String,StockReturn:%String,StockReduce:%String,StockMoveOut:%String,StockMoveIn:%String,StockEnd:%String,UsedBegin:%String,UsedIn:%String,UsedReturn:%String,UsedMoveIn:%String,UsedMoveOut:%String,Disused:%String,UsedEnd:%String,StartDate:%String,EndDate:%String,MonthStr:%String,TotalEnd:%String,ChangeAccount:%String,Origin:%String,EquipType:%String,Job:%String,TotalDepre:%String,Depre:%String,StockDisused:%String,StoreMoveIn:%String,StoreMoveOut:%String,NetFee:%String,StockChangeAccount:%String,UsedReduce:%String,StockOther:%String,UsedOther:%String,FinanceTypeID:%String,FinanceType:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReport","MonthReport","2008-03","2008-03")
ClassMethod MonthReportExecute(ByRef qHandle As %Binary, StartMonth, EndMonth, LocDR As %String = "", EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", AccountShape As %String = "0") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	new Year,Month,PreYear,PreMonth,Loc,StatCat,Origin,EquipType,StatCatDesc,OriginDesc,EquipTypeDesc
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount
 	new TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut,NetFee
 	new ListInfo,i,SumInfo,StartDate,EndDate,BeginYear,BeginMonthNum,EndYear,EndMonthNum,MonthStr,Date
 	new FirstFlag,LastFlag
 	
 	;Add by JDL 2011-6-22 JDL0086
 	new StockChangeAccount,UsedReduce,StockOther,UsedOther
 	
 	;s (Year,Month,PreYear,PreMonth,Loc,StatCat)=""
 	;s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
 	;s (TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut)=0
 	s User=CurUserID
 	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	
 	s Date=+$H
	s Time=$p($H,",",2)
	
	s TempNode="Report.MonthReport"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	
	s ^TempDHCEQ("MonthReport")="StartMonth:"_StartMonth_",EndMonth:"_EndMonth_",LocDR:"_LocDR_",EquipTypeIDs:"_EquipTypeIDs
	
	if EquipTypeIDs="" s EquipTypeIDs=##Class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID)
	s EquipTypeIDs= ##Class(web.DHCEQCommon).Replace(EquipTypeIDs,"^",",")
	i EquipTypeIDs="" s EquipTypeIDs=0
	
	;开始月份为空则返回
	q:(StartMonth="") $$$OK
	;终止月份为空表示，只获取开始月份一个月的数据
	i EndMonth="" s EndMonth=StartMonth
	;modify by lmm 2019-01-04 begin
	i (StartMonth'="2019-0")&&(..CheckMonth(StartMonth)="1") q $$$OK
	i (EndMonth'="2019-0")&&(..CheckMonth(EndMonth)="1") q $$$OK
	;modify by lmm 2019-01-04 end
	s BeginYear=+$p(StartMonth,"-",1)
	s BeginMonthNum=+$p(StartMonth,"-",2)
	s EndYear=+$p(EndMonth,"-",1)
	s EndMonthNum=+$p(EndMonth,"-",2)	
	q:((BeginYear_$E("00",1,2-$L(BeginMonthNum))_BeginMonthNum)>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum)) $$$OK
	
	s Year=BeginYear
	s Month=BeginMonthNum
	s FirstFlag="1"
	s LastFlag="0"
	while ((Year_$E("00",1,2-$L(Month))_Month)'>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum))
	{
		if (Month=1)
		{	s PreYear=Year-1
			s PreMonth=12}
		else
		{	s PreYear=Year
			s PreMonth=Month-1}
		s MonthStr=Year_$E("-00",1,3-$L(Month))_Month
		if (Year_$E("00",1,2-$L(Month))_Month)=(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum) s LastFlag=1
		d AddOneMonthTempData
		s FirstFlag="0"
		s Month=Month+1
		i Month>12
		{
			s Year=Year+1
			s Month=1
		}
	}	
	s (StartDate,EndDate)=""
	s EquipType=0
	f  s EquipType=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType)) q:EquipType=""  d
	.s EquipTypeDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	.s StatCat=0
	.s StatCatDesc=""
	.;modify by lmm 2019-01-07 begin
	.f  s StatCat=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat)) q:StatCat=""  d
	..;s Origin=""
	..;f  s Origin=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,Origin)) q:Origin=""  d
	..s ListInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat))
	..s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
	..i ListInfo'=""  d
	...s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum"))
	...i SumInfo=""  d
	....s ^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum")=ListInfo
	...e  d
	....for i=1:1:25  d //2012-02-01 DJ0103
	.....s $p(SumInfo,"^",i)=+$p(SumInfo,"^",i)+$p(ListInfo,"^",i)
	....s ^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum")=SumInfo
	..s OriginDesc=""
	..;i Origin'="" s OriginDesc=$p($g(^DHCEQCCode("DHCEQCOrigin",Origin)),"^",2)
	..d OutputRowMonthReport
	..;modify by lmm 2019-01-07 end
	/*		//润乾报表取消合计行输出
	s EquipType=0
	s StatCat=0
	s OriginDesc=""
	s EquipTypeDesc="总计:"
	s ListInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum"))
	d OutputRowMonthReport
	*/
	k ^TempDHCEQ(TempNode,Date,$j,"Temp")
	
	Quit $$$OK
AddOneMonthTempData
	;逐月汇总数据，临时存储在^TempDHCEQ(TempNode,Date,$j,"Temp"下
	i '$d(^DHCEQMonthReportList(0,"Loc",Year,Month))
	{
		;尚未月结的月份则，到业务表中获取
		s StartDate=##Class(web.DHCEQReport).GetReportDate(Year_"-"_Month,"","")
		s EndDate=$p(StartDate,"^",2)
		s StartDate=$p(StartDate,"^",1)
		
		d ..FillStatListInfo(User,Year,Month,StartDate,EndDate,EquipTypeIDs,FundsTypeDR,AccountShape) 
		
		s EquipType=0
		f  s EquipType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s Loc=0
		.f  s Loc=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:Loc=""  d
		..q:((LocDR'="")&&(LocDR'=Loc))
		..s StatCat=0
		..f  s StatCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:StatCat=""  d
		...s Origin=""
		...f  s Origin=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:Origin=""  d
		....
		....;Modified by jdl 2011-12-28 JDL0107
		....s FundsType=""
		....f  s FundsType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:FundsType=""  d
		.....;modify by lmm 2020-01-20
		.....s FinaceItem=-1
		.....f  s FinaceItem=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType,FinaceItem)) q:FinaceItem=""  d
		......s FunctionCat=-1
		......f  s FunctionCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType,FinaceItem,FunctionCat)) q:FunctionCat=""  d
		.......s ListInfo=$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType,FinaceItem,FunctionCat))
		.......d BuildMonthReportTemp
		.......;modify by lmm 2020-01-20
	}
	else
	{
		;已经月结的月份则，到月结表中获取
		s EquipType=0
		f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s StatCat=0
		.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat)) q:StatCat=""  d
		..s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
		..s FinanceTypeID=$p($g(^DHCEQCCode("DHCEQCFinanceType",StatCat)),"^",12)
		..s FinanceType=""
		..i FinanceTypeID'="" s FinanceType=$p($g(^DHCEQCCode("DHCEQCFinanceType",FinanceTypeID)),"^",2)
		..s Loc=0
		..f  s Loc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc)) q:Loc=""  d
		...q:((LocDR'="")&&(LocDR'=Loc))
		...s rowid=0
		...f  s rowid=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc,rowid)) q:rowid=""  d
		....s ListInfo=$g(^DHCEQMonthReportList(rowid))
		....;add by lmm 2017-01-09 468730 begin
		....//增加报表类型的判断,如果AccountShape=1 就查询财务月报的数据
		....s ReportType=+$p(ListInfo,"^",46)
		....q:(AccountShape'="")&(ReportType'=AccountShape)
		....;add by lmm 2018-01-09 468730 end
		....q:(FundsTypeDR'="")&&(FundsTypeDR'=$p(ListInfo,"^",38))
		....s Origin=$p(ListInfo,"^",26)
		....;Modified by JDL 2011-6-22 JDL0086
		....s ListInfo=$p(ListInfo,"^",6,19)_"^"_$p(ListInfo,"^",25)_"^"_$p(ListInfo,"^",28,37)
		....d BuildMonthReportTemp
	}
	quit
BuildMonthReportTemp
	;s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,Origin))
	s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat))
	;非第一个月，则不取期初
	i FirstFlag'="1"
	{
		s $p(ListInfo,"^",1)=0	;StockBegin
		s $p(ListInfo,"^",8)=0	;UsedBegin		
	}
	i LastFlag'="1"
	{
		s $p(ListInfo,"^",7)=0	;StockEnd
		s $p(ListInfo,"^",14)=0	;UsedEnd
		s $p(ListInfo,"^",16)=0	;TotalDepre
		s $p(ListInfo,"^",21)=0	;NetFee
	}
	
	if SumInfo=""
	{		
		s SumInfo=ListInfo
	}
	else
	{
		;Modified by JDL 2011-6-22 JDL0086
		for i=1:1:25  s $p(SumInfo,"^",i)=+$p(ListInfo,"^",i)+$p(SumInfo,"^",i)
	}
	;s ^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,Origin)=SumInfo
	s ^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat)=SumInfo
	
	quit

OutputRowMonthReport
	q:ListInfo=""
	s StockBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",1),"",2)
	s StockIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",2),"",2)
	s StockReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",3),"",2)
	s StockReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",4),"",2)
	s StockMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",5),"",2)
	s StockMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",6),"",2)
	s StockEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",7),"",2)		
	s UsedBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",8),"",2)
	s UsedIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",9),"",2)
	s UsedReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",10),"",2)
	s UsedMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",11),"",2)
	s UsedMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",12),"",2)
	s Disused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",13),"",2)
	s UsedEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",14),"",2)
	
	s ChangeAccount=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",15),"",2)

	s TotalDepre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",16),"",2)
	s Depre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",17),"",2)
	s StockDisused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",18),"",2)
	s StoreMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",19),"",2)
	s StoreMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",20),"",2)
		
	s NetFee=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",21),"",2)	
	
	;Add by JDL 2011-6-22 JDL0086
	s StockChangeAccount=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",22),"",2)
	s UsedReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",23),"",2)
	s StockOther=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",24),"",2)
	s UsedOther=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",25),"",2)
	
	s TotalEnd=+StockEnd+UsedEnd
	s TotalEnd=##Class(web.DHCEQCommon).FormatNumber(TotalEnd,"",2)
	
	s Data=$lb(StatCat,StatCatDesc,StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,StartDate,EndDate,MonthStr,TotalEnd,ChangeAccount,OriginDesc,EquipTypeDesc,$J,TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut,NetFee,StockChangeAccount,UsedReduce,StockOther,UsedOther,FinanceTypeID,FinanceType)
	s ^TempDHCEQ(TempNode,Date,$j,index)=StatCat_"^"_StatCatDesc_"^"_StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_StartDate_"^"_EndDate_"^"_MonthStr_"^"_TotalEnd_"^"_ChangeAccount_"^"_OriginDesc_"^"_EquipTypeDesc_"^"_$J_"^"_TotalDepre_"^"_Depre_"^"_StockDisused_"^"_StoreMoveIn_"^"_StoreMoveOut_"^"_NetFee_"^"_StockChangeAccount_"^"_UsedReduce_"^"_StockOther_"^"_UsedOther
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthReportExecute ]
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

ClassMethod MonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 得到结存科室月报(未测试)
/// add by jdl 2010-10-27
/// 入参：StartMonth:YYYY-MM  该参数必需
/// 	  EndMonth:YYYY-MM	该参数可选，为空时表示与StartMonth一致
Query MonthReportLoc(StartMonth, EndMonth, LocDR As %String = "", EquipTypeIDs As %Library.String = "") As %Query(ROWSPEC = "LocDR:%String,Loc:%String,StockBegin:%String,StockIn:%String,StockReturn:%String,StockReduce:%String,StockMoveOut:%String,StockMoveIn:%String,StockEnd:%String,UsedBegin:%String,UsedIn:%String,UsedReturn:%String,UsedMoveIn:%String,UsedMoveOut:%String,Disused:%String,UsedEnd:%String,StartDate:%String,EndDate:%String,MonthStr:%String,TotalEnd:%String,ChangeAccount:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReport","MonthReportLoc","2008-03","2008-03")
ClassMethod MonthReportLocExecute(ByRef qHandle As %Binary, StartMonth, EndMonth, LocDR As %String = "", EquipTypeIDs As %Library.String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
 	
 	new Year,Month,PreYear,PreMonth,Loc,StatCat,Origin,EquipType
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount
 	new TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut
 	new ListInfo,i,SumInfo,StartDate,EndDate,BeginYear,BeginMonthNum,EndYear,EndMonthNum,MonthStr,Date
 	new FirstFlag,LastFlag
 	
 	;s (Year,Month,PreYear,PreMonth,Loc,StatCat)=""
 	;s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0 	
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s Date=+$H
	s Time=$p($H,",",2)
	
	s TempNode="Report.MonthReportLoc"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	
 	;开始月份为空则返回
	q:(StartMonth="") $$$OK
	;终止月份为空表示，只获取开始月份一个月的数据
	i EndMonth="" s EndMonth=StartMonth
	i ..CheckMonth(StartMonth)="1" q $$$OK
	i ..CheckMonth(EndMonth)="1" q $$$OK	
	s BeginYear=+$p(StartMonth,"-",1)
	s BeginMonthNum=+$p(StartMonth,"-",2)
	s EndYear=+$p(EndMonth,"-",1)
	s EndMonthNum=+$p(EndMonth,"-",2)	
	q:((BeginYear_$E("00",1,2-$L(BeginMonthNum))_BeginMonthNum)>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum)) $$$OK
	
	s Year=BeginYear
	s Month=BeginMonthNum
	s FirstFlag="1"
	s LastFlag="0"
	while ((Year_$E("00",1,2-$L(Month))_Month)'>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum))
	{
		if (Month=1)
		{	s PreYear=Year-1
			s PreMonth=12}
		else
		{	s PreYear=Year
			s PreMonth=Month-1}
		s MonthStr=Year_$E("-00",1,3-$L(Month))_Month
		if (Year_$E("00",1,2-$L(Month))_Month)=(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum) s LastFlag=1
		d AddOneMonthLocTempData
		s FirstFlag="0"
		s Month=Month+1
		i Month>12
		{
			s Year=Year+1
			s Month=1
		}
	}
	
	s Loc=0
	f  s Loc=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",Loc)) q:Loc=""  d
	.s ListInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",Loc))
	.i ListInfo'=""  d
	..s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum"))
	..i SumInfo=""  d
	...s ^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum")=ListInfo
	..e  d
	...for i=1:1:20  d
	....s $p(SumInfo,"^",i)=+$p(SumInfo,"^",i)+$p(ListInfo,"^",i)
	...s ^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum")=SumInfo
	.s LocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",Loc)
	.d OutputRowMonthReportLoc
	
	s Loc=0
	s LocDesc="总计:"
	s ListInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",0,"Sum"))
	d OutputRowMonthReportLoc
	
	k ^TempDHCEQ(TempNode,Date,$j,"Temp")
	
	Quit $$$OK

AddOneMonthLocTempData
	;逐月汇总数据，临时存储在^TempDHCEQ(TempNode,Date,$j,"Temp"下
	i '$d(^DHCEQMonthReportList(0,"YearMonth",Year,Month))
	{
		;尚未月结的月份则，到业务表中获取
		s StartDate=##Class(web.DHCEQReport).GetReportDate(Year_"-"_Month,"","")
		s EndDate=$p(StartDate,"^",2)
		s StartDate=$p(StartDate,"^",1)
		
		d ..FillStatListInfo(User,Year,Month,StartDate,EndDate,EquipTypeIDs) 
		
		s EquipType=0
		f  s EquipType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s Loc=0
		.f  s Loc=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:Loc=""  d
		..q:((LocDR'="")&&(LocDR'=Loc))
		..s StatCat=0
		..f  s StatCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:StatCat=""  d
		...s Origin=""
		...f  s Origin=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:Origin=""  d
		....
		....;Modified by jdl 2011-12-28 JDL0107
		....s FundsType=""
		....f  s FundsType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:FundsType=""  d
		.....s ListInfo=$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType))
		.....d AddMonthReportLoc
	}
	else
	{
		;已经月结的月份则，到月结表中获取
		s Loc=0
		f  s Loc=$o(^DHCEQMonthReportList(0,"LocType",Year,Month,Loc)) q:Loc=""  d
		.q:((LocDR'="")&&(LocDR'=Loc))
		.s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
		.s EquipType=0
		.f  s EquipType=$o(^DHCEQMonthReportList(0,"LocType",Year,Month,Loc,EquipType)) q:EquipType=""  d
		..s rowid=0
		..f  s rowid=$o(^DHCEQMonthReportList(0,"LocType",Year,Month,Loc,EquipType,rowid)) q:rowid=""  d
		...s ListInfo=$g(^DHCEQMonthReportList(rowid))
		...s Origin=$p(ListInfo,"^",26)
		...s StatCat=$p(ListInfo,"^",5)
		...s ListInfo=$p(ListInfo,"^",6,19)_"^"_$p(ListInfo,"^",25)_"^"_$p(ListInfo,"^",28,32)
		...d AddMonthReportLoc		
	}
	quit	
AddMonthReportLoc
	s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",Loc))
	;非第一个月，则不取期初
	i FirstFlag'="1"
	{
		s $p(ListInfo,"^",1)=0	;StockBegin
		s $p(ListInfo,"^",8)=0	;UsedBegin		
	}
	i LastFlag'="1"
	{
		s $p(ListInfo,"^",7)=0	;StockEnd
		s $p(ListInfo,"^",14)=0	;UsedEnd
		s $p(ListInfo,"^",16)=0	;TotalDepre
	}
	
	if SumInfo=""
	{		
		s SumInfo=ListInfo
	}
	else
	{
		for i=1:1:20  s $p(SumInfo,"^",i)=+$p(ListInfo,"^",i)+$p(SumInfo,"^",i)
	}
	s ^TempDHCEQ(TempNode,Date,$j,"Temp",Loc)=SumInfo
	
	quit
OutputRowMonthReportLoc
	q:ListInfo=""
	s StockBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",1),"",2)
	s StockIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",2),"",2)
	s StockReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",3),"",2)
	s StockReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",4),"",2)
	s StockMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",5),"",2)
	s StockMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",6),"",2)
	s StockEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",7),"",2)		
	s UsedBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",8),"",2)
	s UsedIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",9),"",2)
	s UsedReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",10),"",2)
	s UsedMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",11),"",2)
	s UsedMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",12),"",2)
	s Disused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",13),"",2)
	s UsedEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",14),"",2)
	
	s ChangeAccount=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",15),"",2)

	s TotalDepre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",16),"",2)
	s Depre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",17),"",2)
	s StockDisused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",18),"",2)
	s StoreMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",19),"",2)
	s StoreMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",20),"",2)	
	
	s TotalEnd=+StockEnd+UsedEnd
	s TotalEnd=##Class(web.DHCEQCommon).FormatNumber(TotalEnd,"",2)
	
	s Data=$lb(Loc,LocDesc,StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,$ZD(StartDate,4),$ZD(EndDate,4),MonthStr,TotalEnd,ChangeAccount)
	s ^TempDHCEQ(TempNode,Date,$j,index)=Loc_"^"_LocDesc_"^"_StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_$ZD(StartDate_"^"_4)_"^"_$ZD(EndDate_"^"_4)_"^"_MonthStr_"^"_TotalEnd_"^"_ChangeAccount
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MonthReportLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthReportLocExecute ]
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

ClassMethod MonthReportLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified by zy 2014-09-15  ZY0117  不去取会计周期，加一个flag
/// 返回报表的会计周期：
/// 入参：MonthStr:月份，格式为"YYYY-MM"
/// 	  Type：1获取开始日期，2获取结束日期，其他返回 开始日期^结束日期
/// 	  Format:返回日期格式，3:YYYY-MM-DD 4:DD/MM/YYYY 0:日期的数字格式
/// 返回:Type：1获取开始日期，2获取结束日期，其他返回 开始日期^结束日期
/// 	 MonthStr不正确则返回 ""
/// w ##Class(web.DHCEQReport).GetReportDate("2008-01","","4")
ClassMethod GetReportDate(MonthStr, Type As %String = "", Format As %String = "4", flag As %String = "")
{
	new Year,Month,StartDate,EndDate,ReportDate
	s Year=$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	i Year<1900 q ""
	i (Month<1)||(Month>12) q ""
	
	s ReportDate=""
	i Type'=2
	{
		s StartDate=##class(web.DHCEQCommon).GetSysInfo("901001")
		i flag'="" s StartDate=""
		i StartDate'=""
		{
			if (+Month=1)
			{	s StartDate=(Year-1)_"-12-"_StartDate}
			else
			{	s StartDate=Year_"-"_(Month-1)_"-"_StartDate}
			s StartDate=$ZDH(StartDate,3)
		}
		else
		{
			s StartDate=Year_"-"_(Month)_"-1"
			s StartDate=$ZDH(StartDate,3)
		}		
		i Format'="" s StartDate=$ZD(StartDate,Format)
		s ReportDate=StartDate
	}
	i Type'=1
	{
		s EndDate=##class(web.DHCEQCommon).GetSysInfo("901002")
		i flag'="" s EndDate=""
		i EndDate'=""
		{
			s EndDate=Year_"-"_Month_"-"_EndDate
			s EndDate=$ZDH(EndDate,3)
		}
		else
		{
			if (+Month=12)
			{	s EndDate=(Year+1)_"-01-01"			}
			else
			{	s EndDate=Year_"-"_(Month+1)_"-1"	}			
			s EndDate=$ZDH(EndDate,3)
			s EndDate=EndDate-1
		}
		i Format'="" s EndDate=$ZD(EndDate,Format)
		i ReportDate'="" s ReportDate=ReportDate_"^"
		s ReportDate=ReportDate_EndDate
	}
	q ReportDate
}

/// modified by ZY0293 2022-01-27 手工月结时起止时间从表中取，同时增加APRowID参数
/// w ##class(web.DHCEQReport).SaveMonthReport("2022-05","")
ClassMethod SaveMonthReport(MonthStr, EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", AccountShape As %String = "0", APRowID As %String = "")
{
	new StartDate,EndDate,Year,Month,User
	i MonthStr="" q 0

	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	
	///modified by ZY0298 写入会计周期记录
	i APRowID=""
	{
		s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr,"Equip")
		s Year=$p(MonthStr,"-",1)
		s Month=$p(MonthStr,"-",2)
		s Date=+$H
		s APRowID=$o(^DHCEQAccountPeriod(0,"YearMonth",$p(MonthStr,"-",1),$p(MonthStr,"-",2),""))
		i APRowID'=""
		{
			//已存在记录
			&SQL(UPDATE SQLUSER.DHC_EQAccountPeriod(AP_Year,AP_Month,AP_StartDate,AP_EndDate,AP_SnapID,AP_Date,AP_ReportStat,AP_DepreStat,AP_Remark,AP_InvalidFlag) values (:Year,:Month,:StartDate,:EndDate,:SnapID,:Date,'0','0','','N') where AP_RowID=:APRowID)
		}
		else
		{
			&SQL(INSERT INTO SQLUSER.DHC_EQAccountPeriod(AP_Year,AP_Month,AP_StartDate,AP_EndDate,AP_SnapID,AP_Date,AP_ReportStat,AP_DepreStat,AP_Remark,AP_InvalidFlag) values (:Year,:Month,:StartDate,:EndDate,:SnapID,:Date,'0','0','','N'))
		}
		i SQLCODE q SQLCODE
		s APRowID=$G(%ROWID)
	}
	i APRowID'=""  d
	.s StartDate=$p($g(^DHCEQAccountPeriod(APRowID)),"^",3)
	.s EndDate=$p($g(^DHCEQAccountPeriod(APRowID)),"^",5)
	
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s User=1
	
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	d ..FillStatListInfo(User, Year, Month, StartDate, EndDate,EquipTypeIDs,FundsTypeDR,AccountShape,APRowID)
	
	
	q ..SaveMonthReportList(User, Year, Month, StartDate, EndDate, MonthStr,EquipTypeIDs,AccountShape,APRowID)
}

/// modified by ZY0293 2022-01-27 手工月结时起止时间从表中取，同时增加APRowID参数
/// 保存StatList
ClassMethod SaveMonthReportList(User, Year, Month, StartDate, EndDate, MonthStr, EquipTypeIDs As %Library.String = "", AccountShape As %Library.String = "0", APRowID As %String = "")
{
	new EquipType,Loc,StatCat,Origin,listInfo,PreYear,PreMonth
	new Date,Time
 	new FundsType
 	
 	s Date=+$H
	s Time=$p($H,",",2)
	
	k PLIST
	s PLIST(2) = Year
	s PLIST(3) = Month
	///s PLIST(4) = Loc
	s PLIST(5) = MonthStr
	///s PLIST(6) = StatCat
	
	s PLIST(21) = StartDate
	s PLIST(22) = EndDate
	s PLIST(23) = Date
	s PLIST(24) = Time
	s PLIST(25) = User
	s PLIST(47) =AccountShape	//MRL_ReportType  0，实物月结;1，财务月结
	///modified by ZY0293 2022-01-27
	i APRowID="" d
	.Set $ZT="ETSaveMonthReportList"
	.TStart
	s SQLCODE=0
	///保存当月有业务数据变化的
	s EquipType=0
	f  s EquipType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType)) q:((EquipType="")||(SQLCODE'=0))  d
	.//q:$d(^DHCEQMonthReportList(0,"YearMonth",Year,Month,EquipType))
	.q:$d(^DHCEQMonthReportList(0,"ReportType",+AccountShape,Year,Month,EquipType))
	.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.s Loc=0
	.f  s Loc=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:((Loc="")||(SQLCODE'=0))  d
	..s StatCat=0
	..f  s StatCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:((StatCat="")||(SQLCODE'=0))  d
	...s Origin=""
	...f  s Origin=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:((Origin="")||(SQLCODE'=0))  d
	....
	....;Modified by jdl 2011-12-28 JDL0107
	....s FundsType=""
	....f  s FundsType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:((FundsType="")||(SQLCODE'=0))  d
	.....//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.....s FinaceItem=""
	.....f  s FinaceItem=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType,FinaceItem)) q:((FinaceItem="")||(SQLCODE'=0))  d
	......s FunctionCat=""
	......f  s FunctionCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType,FinaceItem,FunctionCat)) q:((FunctionCat="")||(SQLCODE'=0))  d
	.......s listInfo=$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType,FinaceItem,FunctionCat))
	.......s PLIST(4) = Loc
	.......s PLIST(6) = StatCat
	.......f i=1:1:14 d
	........s PLIST(6+i) = $p(listInfo,"^",i)
	.......s PLIST(26)=$p(listInfo,"^",15)		///原值变动
	.......s PLIST(27)=Origin		///来源
	.......s PLIST(28)=EquipType	///类组
	.......s PLIST(39)=FundsType	///类组
	.......s PLIST(42)=FinaceItem	
	.......s PLIST(43)=FunctionCat	
	.......;Modified by JDL 2011-6-22 JDL0086
	.......f i=16:1:25 d
	........s PLIST(13+i) = $p(listInfo,"^",i)
	.......;Add By DJ 2015-01-21 DJ0135
	.......f i=26:1:27 d
	........s PLIST(14+i) = $p(listInfo,"^",i)
	.......&SQL(Insert Into SQLUSER.DHC_EQMonthReportList Values :PLIST())
	.......q:SQLCODE'=0
	//End By QW 20190410 BUG:QW0027
	///modified by ZY0293 2022-01-27
	i SQLCODE'=0
	{
		i APRowID="" TRollBack}
	else
	{	i APRowID="" TCommit}
	q SQLCODE
ETSaveMonthReportList
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-1^"_ErrorMsg     //返回错误消息 ;
}

/// 返回该日期所属的会计月份：
/// 入参：ReportDate:报表日期,传入的日期格式为数字
/// 返回会计月份,格式为"YYYY-MM"
/// w ##Class(web.DHCEQReport).GetReportMonthByDate(62195)
ClassMethod GetReportMonthByDate(ReportDate)
{
	s StartDate=##class(web.DHCEQCommon).GetSysInfo("901001")
	
	s Year=$p($zd(ReportDate,3),"-",1)
	s Month=$p($zd(ReportDate,3),"-",2)
	s Day=$p($zd(ReportDate,3),"-",3)
	;如果会计周期设置有起始日期,即非自然月
	i (StartDate'="")
	{
		;如果日期 不小于 起始日期,则算在下一周期中
		i (Day'<StartDate)
		{
			s Month=Month+1
			i Month>12
			{
				s Year=Year+1
				s Month=1
			}
		}
	}
	s Month="00"_Month
	s Month=$e(Month,$l(Month)-1,$l(Month))
	q Year_"-"_Month
}

/// MZY0077	1863622		2021-05-27	增加类型编码StatCode输出
/// 得到结存月报资金来源的列表
/// add by jdl 2012-01-18 JDL0112
/// 入参：StartMonth:YYYY-MM  该参数必需
/// 	  EndMonth:YYYY-MM	该参数可选，为空时表示与StartMonth一致	
/// modify by  mwz 2017-06-30  改为润乾报表  增加资金来源‘其它’																												EquipType,EquipTypeDesc,StatCat,StatCatDesc,ListInfo,$J
/// d ##class(%ResultSet).RunQuery("web.DHCEQReport","MonthReportFunds","2012-01","2012-01","","","","","","85","429","","1")
Query MonthReportFunds(StartMonth As %String = "", EndMonth As %String = "", LocDR As %String = "", EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", HospitalID As %Library.String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", AccountShape As %String = "0") As %Query(ROWSPEC = "EquipTypeID:%String,EquipType:%String,StatCatID:%String,StatCat:%String,ListInfo:%String,Job:%String,TRow:%String,StatCode:%String") [ SqlProc ]
{
}

ClassMethod MonthReportFundsExecute(ByRef qHandle As %Binary, StartMonth As %String = "", EndMonth As %String = "", LocDR As %String = "", EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", HospitalID As %Library.String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", AccountShape As %String = "0") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s TRow=0
 	s index=1
 	new Year,Month,PreYear,PreMonth,Loc,StatCode,StatCat,Origin,EquipType,StatCatDesc,OriginDesc,EquipTypeDesc
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount
 	new TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut,NetFee
 	new ListInfo,i,SumInfo,StartDate,EndDate,BeginYear,BeginMonthNum,EndYear,EndMonthNum,MonthStr,Date
 	new FirstFlag,LastFlag
 	
 	;Add by JDL 2011-6-22 JDL0086
 	new StockChangeAccount,UsedReduce,StockOther,UsedOther
 	
 	;s (Year,Month,PreYear,PreMonth,Loc,StatCat)=""
 	;s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
 	;s (TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut)=0
 	s User=CurUserID
 	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	;s User=1
 	s Date=+$H
	s Time=$p($H,",",2)
	
	s TempNode="Report.MonthReportFunds"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	
 	;定义资金来源的数量，资金信息里包含有信息列数
 	new FundsCount,FundsInfoLen
 	s FundsCount=4
 	;增加小计一项
 	s FundsCount=1+FundsCount
 	s FundsInfoLen=6
 	
	s ^TempDHCEQ("MonthReportFunds")="StartMonth:"_StartMonth_",EndMonth:"_EndMonth_",LocDR:"_LocDR_",EquipTypeIDs:"_EquipTypeIDs
	
	if EquipTypeIDs="" s EquipTypeIDs=##Class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID)
	s EquipTypeIDs= ##Class(web.DHCEQCommon).Replace(EquipTypeIDs,"^",",")
	i EquipTypeIDs="" s EquipTypeIDs=0
	
	i (StartMonth="")  d
	.s StartMonth=$zd(+$h,3)               //add by mwz 2017-08-29 解决报表初始化加载月份为空问题
	.s StartMonth=+$p(StartMonth,"-",1)_"-"_+$p(StartMonth,"-",2)
	;开始月份为空则返回
	q:(StartMonth="") $$$OK
	;终止月份为空表示，只获取开始月份一个月的数据
	i EndMonth="" s EndMonth=StartMonth
	;modify by lmm 2019-01-04 begin
	i (StartMonth'="2019-0")&&(..CheckMonth(StartMonth)="1") q $$$OK
	i (EndMonth'="2019-0")&&(..CheckMonth(EndMonth)="1") q $$$OK
	;modify by lmm 2019-01-04 end
	
	s BeginYear=+$p(StartMonth,"-",1)
	s BeginMonthNum=+$p(StartMonth,"-",2)
	s EndYear=+$p(EndMonth,"-",1)
	s EndMonthNum=+$p(EndMonth,"-",2)	
	q:((BeginYear_$E("00",1,2-$L(BeginMonthNum))_BeginMonthNum)>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum)) $$$OK
	
	s Year=BeginYear
	s Month=BeginMonthNum
	s FirstFlag="1"
	s LastFlag="0"
	while ((Year_$E("00",1,2-$L(Month))_Month)'>(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum))
	{
		if (Month=1)
		{	s PreYear=Year-1
			s PreMonth=12}
		else
		{	s PreYear=Year
			s PreMonth=Month-1}
		s MonthStr=Year_$E("-00",1,3-$L(Month))_Month
		if (Year_$E("00",1,2-$L(Month))_Month)=(EndYear_$E("00",1,2-$L(EndMonthNum))_EndMonthNum) s LastFlag=1
		d AddOneMonthFundsTempData
		s FirstFlag="0"
		s Month=Month+1
		i Month>12
		{
			s Year=Year+1
			s Month=1
		}
	}	
	s (StartDate,EndDate)=""
	s EquipType=0
	f  s EquipType=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType)) q:EquipType=""  d
	.s EquipTypeDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	.s StatCat=0
	.f  s StatCat=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat)) q:StatCat=""  d
	..;s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
	..s FundsType=""
	..f  s FundsType=$o(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,FundsType)) q:FundsType=""  d
	...;s FundsTypeDesc=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsType)),"^",2)
	...s ListInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,FundsType))
	...q:ListInfo=""
	...d ResetFunsInfo
	
	;Modified by JDL 2012-01-31 JDL0114 资金来源月结报表中合计有误
	s SumInfo=""
	
	s EquipType=0
	f  s EquipType=$o(^TempDHCEQ(TempNode,Date,$j,"TempNew",EquipType)) q:EquipType=""  d
	.s EquipTypeDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	.s StatCat=0
	.f  s StatCat=$o(^TempDHCEQ(TempNode,Date,$j,"TempNew",EquipType,StatCat)) q:StatCat=""  d
	..s StatCode=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",1)		// MZY0077	1863622		2021-05-27
	..s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
	..s ListInfo=$g(^TempDHCEQ(TempNode,Date,$j,"TempNew",EquipType,StatCat))
	..s Len=FundsCount*FundsInfoLen
	..for i=1:1:Len  d
	...s $p(SumInfo,"^",i)=+$p(SumInfo,"^",i)+$p(ListInfo,"^",i)
	..s TRow=TRow+1
	..d OutputRowMonthReportFunds
	
#;	
#;	s EquipType=0
#;	s StatCat=0
#;	s TRow="总计:"
#;	s StatCatDesc=""
#;	s OriginDesc=""
#;	s EquipTypeDesc=""
#;	s ListInfo=SumInfo
#;	d OutputRowMonthReportFunds
	
	k ^TempDHCEQ(TempNode,Date,$j,"Temp")
	k ^TempDHCEQ(TempNode,Date,$j,"TempNew")
	
	Quit $$$OK
AddOneMonthFundsTempData
	;逐月汇总数据，临时存储在^TempDHCEQ(TempNode,Date,$j,"Temp"下
	i '$d(^DHCEQMonthReportList(0,"Loc",Year,Month))
	{
		;尚未月结的月份则，到业务表中获取
		s StartDate=##Class(web.DHCEQReport).GetReportDate(Year_"-"_Month,"","")
		s EndDate=$p(StartDate,"^",2)
		s StartDate=$p(StartDate,"^",1)
		
		d ..FillStatListInfo(User,Year,Month,StartDate,EndDate,EquipTypeIDs,FundsTypeDR,AccountShape) 
		
		s EquipType=0
		f  s EquipType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s Loc=0
		.f  s Loc=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:Loc=""  d
		..q:((LocDR'="")&&(LocDR'=Loc))
		..;q:(HospitalID'="")&&(HospitalID'=$p($g(^CTLOC(Loc)),"^",22))   //modify by jyp 2019-10-18 CTLOC调整
		..q:(HospitalID'="")&&(HospitalID'=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(Loc))  //modify by jyp 2019-10-18 CTLOC调整
		..s StatCat=0
		..f  s StatCat=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:StatCat=""  d
		...s Origin=""
		...f  s Origin=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:Origin=""  d
		....
		....;Modified by jdl 2011-12-28 JDL0107
		....s FundsType=""
		....f  s FundsType=$o(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:FundsType=""  d
		.....
		.....s ListInfo=$g(^TempDHCEQ("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType))
		.....d BuildMonthReportFundsTemp
	}
	else
	{
		;已经月结的月份则，到月结表中获取
		s EquipType=0
		f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
		.s StatCat=0
		.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat)) q:StatCat=""  d
		..s StatCode=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",1)		// MZY0077	1863622		2021-05-27
		..s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
		..s Loc=0
		..f  s Loc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc)) q:Loc=""  d
		...q:((LocDR'="")&&(LocDR'=Loc))
		...;q:(HospitalID'="")&&(HospitalID'=$p($g(^CTLOC(Loc)),"^",22))    //modify by jyp 2019-10-18 CTLOC调整
		...q:(HospitalID'="")&&(HospitalID'=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(Loc))    //modify by jyp 2019-10-18 CTLOC调整
		...s rowid=0
		...f  s rowid=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc,rowid)) q:rowid=""  d
		....s ListInfo=$g(^DHCEQMonthReportList(rowid))
		....;add by lmm 2017-01-09 469305 begin
		....//增加报表类型的判断,如果AccountShape=1 就查询财务月报的数据
		....s ReportType=+$p(ListInfo,"^",46)
		....q:(AccountShape'="")&(ReportType'=AccountShape)
		....;add by lmm 2018-01-09 469305 end
		....s Origin=$p(ListInfo,"^",26)
		....s FundsType=$p(ListInfo,"^",38)
		....s ListInfo=$p(ListInfo,"^",6,19)_"^"_$p(ListInfo,"^",25)_"^"_$p(ListInfo,"^",28,37)
		....d BuildMonthReportFundsTemp
	}
	quit
BuildMonthReportFundsTemp
	s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,FundsType))
	;s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType))
	;非第一个月，则不取期初
	i FirstFlag'="1"
	{
		s $p(ListInfo,"^",1)=0	;StockBegin
		s $p(ListInfo,"^",8)=0	;UsedBegin		
	}
	i LastFlag'="1"
	{
		s $p(ListInfo,"^",7)=0	;StockEnd
		s $p(ListInfo,"^",14)=0	;UsedEnd
		s $p(ListInfo,"^",16)=0	;TotalDepre
		s $p(ListInfo,"^",21)=0	;NetFee
	}
	
	if SumInfo=""
	{		
		s SumInfo=ListInfo
	}
	else
	{
		;Modified by JDL 2011-6-22 JDL0086
		for i=1:1:25  s $p(SumInfo,"^",i)=+$p(ListInfo,"^",i)+$p(SumInfo,"^",i)
	}
	s ^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType,StatCat,FundsType)=SumInfo
	;s ^TempDHCEQ(TempNode,Date,$j,"Temp",EquipType)=SumInfo
	
	quit
ResetFunsInfo
	s StockBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",1),"",2)	
	s StockIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",2),"",2)
	
	s StockReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",3),"",2)
	s StockReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",4),"",2)
	s StockMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",5),"",2)
	
	s StockMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",6),"",2)
	s StockEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",7),"",2)		
	s UsedBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",8),"",2)	
	s UsedIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",9),"",2)
	
	s UsedReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",10),"",2)
	
	s UsedMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",11),"",2)
	
	s UsedMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",12),"",2)
	s Disused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",13),"",2)
	s UsedEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",14),"",2)
	
	s ChangeAccount=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",15),"",2)

	s TotalDepre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",16),"",2)
	s Depre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",17),"",2)
	s StockDisused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",18),"",2)
	s StoreMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",19),"",2)
	s StoreMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",20),"",2)
		
	s NetFee=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",21),"",2)	
	
	;Add by JDL 2011-6-22 JDL0086
	s StockChangeAccount=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",22),"",2)
	s UsedReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",23),"",2)
	s StockOther=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",24),"",2)
	s UsedOther=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",25),"",2)
	
	;期初期末
	s TotalBegin=+StockBegin+UsedBegin
	s TotalEnd=+StockEnd+UsedEnd
	
	;本期增加
	s TotalAdd=+StockIn	
	;属于转移类
	s TotalAdd=+TotalAdd+StoreMoveIn	;库房转移入
	
	;s TotalAdd=+TotalAdd+StockMoveIn+UsedIn	;返库,领用
	;s TotalAdd=+TotalAdd+UsedMoveIn	;转移入
	
	i ChangeAccount>0 s TotalAdd=TotalAdd+ChangeAccount
	i StockChangeAccount>0 s TotalAdd=TotalAdd+StockChangeAccount
	i StockOther>0 s TotalAdd=TotalAdd+StockOther
	i UsedOther>0 s TotalAdd=TotalAdd+UsedOther
	
	;本期减少
	s TotalReduce=+StockReturn+StockReduce+Disused+StockDisused+UsedReduce
	;属于转移类
	s TotalReduce=+TotalReduce+StoreMoveOut	;库房转移出
	;s TotalReduce=+TotalReduce+StockMoveOut+UsedReturn  ;出库,退库
	;s TotalReduce=+TotalReduce+UsedMoveOut  ;转移出
		
	;返库,退库
	if StockMoveIn>UsedReturn
	{
		s TotalAdd=+TotalAdd+StockMoveIn-UsedReturn		
	}
	else
	{
		s TotalReduce=+TotalReduce+UsedReturn-StockMoveIn
	}
		
	;领用,出库
	if UsedIn>StockMoveOut
	{
		s TotalAdd=+TotalAdd+UsedIn-StockMoveOut		
	}
	else
	{
		s TotalReduce=+TotalReduce+StockMoveOut-UsedIn
	}
	
	;转移入,转移出
	if UsedMoveIn>UsedMoveOut
	{
		s TotalAdd=+TotalAdd+UsedMoveIn-UsedMoveOut		
	}
	else
	{
		s TotalReduce=+TotalReduce+UsedMoveOut-UsedMoveIn
	}
	// Mozy0081	2012-4-1
	i ChangeAccount<0 s TotalReduce=TotalReduce-ChangeAccount
	i StockChangeAccount<0 s TotalReduce=TotalReduce-StockChangeAccount
	i StockOther<0 s TotalReduce=TotalReduce-StockOther
	i UsedOther<0 s TotalReduce=TotalReduce-UsedOther
	
	//add by lmm 2019-01-08 begin  衔接报表本月增加减少只体现本月调整数据
	if ((StartMonth="2019-0")&&(EndMonth="2019-0"))
	{
		s (TotalAdd,TotalReduce)=0
		if (StockOther>0) s TotalAdd=StockOther
		if (UsedOther>0) s TotalAdd=TotalAdd+UsedOther
		if (StockOther<0) s TotalReduce=-StockOther
		if (UsedOther<0) s TotalReduce=TotalReduce-UsedOther
	}
	
	//add by lmm 2019-01-08 end
	s i=+$p($g(^DHCEQCCode("DHCEQCFundsType",FundsType)),"^",1)-1
	s SumInfo=$g(^TempDHCEQ(TempNode,Date,$j,"TempNew",EquipType,StatCat))
	s $p(SumInfo,"^",(i*FundsInfoLen+1))=+TotalBegin+$p(SumInfo,"^",(i*FundsInfoLen+1))
	s $p(SumInfo,"^",(i*FundsInfoLen+2))=+TotalAdd+$p(SumInfo,"^",(i*FundsInfoLen+2))
	s $p(SumInfo,"^",(i*FundsInfoLen+3))=+TotalReduce+$p(SumInfo,"^",(i*FundsInfoLen+3))
	s $p(SumInfo,"^",(i*FundsInfoLen+4))=+TotalEnd+$p(SumInfo,"^",(i*FundsInfoLen+4))
	
	s $p(SumInfo,"^",(i*FundsInfoLen+5))=+Depre+$p(SumInfo,"^",(i*FundsInfoLen+5))
	s $p(SumInfo,"^",(i*FundsInfoLen+6))=+TotalDepre+$p(SumInfo,"^",(i*FundsInfoLen+6))
	;增加小计
	s i=FundsCount-1
	s $p(SumInfo,"^",(i*FundsInfoLen+1))=+TotalBegin+$p(SumInfo,"^",(i*FundsInfoLen+1))
	s $p(SumInfo,"^",(i*FundsInfoLen+2))=+TotalAdd+$p(SumInfo,"^",(i*FundsInfoLen+2))
	s $p(SumInfo,"^",(i*FundsInfoLen+3))=+TotalReduce+$p(SumInfo,"^",(i*FundsInfoLen+3))
	s $p(SumInfo,"^",(i*FundsInfoLen+4))=+TotalEnd+$p(SumInfo,"^",(i*FundsInfoLen+4))
	
	s $p(SumInfo,"^",(i*FundsInfoLen+5))=+Depre+$p(SumInfo,"^",(i*FundsInfoLen+5))
	s $p(SumInfo,"^",(i*FundsInfoLen+6))=+TotalDepre+$p(SumInfo,"^",(i*FundsInfoLen+6))
	
	s ^TempDHCEQ(TempNode,Date,$j,"TempNew",EquipType,StatCat)=SumInfo
	
	quit

OutputRowMonthReportFunds	
	q:ListInfo=""
	s Len=FundsCount*FundsInfoLen
	
	for i=1:1:Len  d
	.s $p(ListInfo,"^",i)=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",i),"",2)
	// MZY0077	1863622		2021-05-27	
	s Data=$lb(EquipType,EquipTypeDesc,StatCat,StatCatDesc,ListInfo,$J,TRow,StatCode)
	s ^TempDHCEQ(TempNode,Date,$j,index)=EquipType_"^"_EquipTypeDesc_"^"_StatCat_"^"_StatCatDesc_"^"_ListInfo_"^"_StatCode
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MonthReportFundsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthReportFundsExecute ]
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

ClassMethod MonthReportFundsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportFundsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 	Add By JDL 20150811 JDL0
/// 判断该日期是否是会计月份的最后一天：
/// 入参：ReportDate:报表日期,传入的日期格式为数字
/// 返回：0，不是最后一天  1：是最后一天
/// w ##Class(web.DHCEQReport).IsLastReportDate(62195)
ClassMethod IsLastReportDate(ReportDate)
{
	if ##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate)'=##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate+1)
	{	q 1	}
	else
	{	q 0 }
}

/// 	Add By JDL 20150811 JDL0
/// 判断该日期是否是在当前会计月份中：
/// 入参：ReportDate:报表日期,传入的日期格式为数字
/// 返回：0，不在当前会计月  1：在当前会计月
/// w ##Class(web.DHCEQReport).IsCurReportMonth(62195)
ClassMethod IsCurReportMonth(ReportDate)
{
	if ##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate)=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	{	q 1	}
	else
	{	q 0 }
}

/// Function:Funds	2012-2-28 生成资金来源信息
/// Mozy0077	2012-1-17
/// w ##class(web.DHCEQReport).GetEquipTypeByInStockList(917,6)
ClassMethod GetEquipTypeByInStockList(TInStockListDR, NewSnapID)
{
	new StoreLocDR,RowID
	Set RowID=0
	Set StoreLocDR=0
	For  Set StoreLocDR=$Order(^DHCEQEquip(0,"InStockList",TInStockListDR,StoreLocDR)) Quit:(StoreLocDR="")||(RowID>0)  Do
	.Set RowID=$Order(^DHCEQEquip(0,"InStockList",TInStockListDR,StoreLocDR,0))
	//modify by lmm 2020-01-21
	i ((NewSnapID'="")&&($d(^DHCEQSnapShot(NewSnapID,"Equip",RowID))))
	{
		If RowID>0 Quit $Piece(^DHCEQSnapShot(NewSnapID,"Equip",RowID),"^",63)_"^"_$Piece(^DHCEQSnapShot(NewSnapID,"Equip",RowID),"^",75)
	}
	else
	{
		If RowID>0 Quit $Piece(^DHCEQEquip(RowID),"^",63)_"^"_$Piece(^DHCEQEquip(RowID),"^",75)
	}
	
	Quit ""
}

}
