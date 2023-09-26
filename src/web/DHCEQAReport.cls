Class web.DHCEQAReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 配件月报表
/// Modify BY:GBX GBX0017 2014-7-22
/// 入参：StartMonth:YYYY-MM  该参数必需
/// EndMonth:YYYY-MM	该参数可选，为空时表示与StartMonth一致
/// Modify by yh 2019-12-17 修改入参
/// d ##class(%ResultSet).RunQuery("web.DHCEQAReport","AMonthReport","2016-03","2016-03")
Query AMonthReport(StartMonth, EndMonth, EquipTypeIDs As %Library.String = "", LocDR As %Library.String = "", CurUserID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "StockBegin:%String,StockIn:%String,StockReduce:%String,StockEnd:%String,AccessoryTypeDesc:%String,Job:%String,Loc:%String,TRow:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQGBX","AMonthReport","2008-03","2008-03")
ClassMethod AMonthReportExecute(ByRef qHandle As %Binary, StartMonth, EndMonth, EquipTypeIDs As %Library.String = "", paraLocDR As %Library.String = "", CurUserID As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
 	s TRow=0
 	if StartMonth="" q $$$OK	//add by yh 2019-12-17
 	new Year,Month,PreYear,PreMonth,Loc,AccessoryType,AccessoryTypeDesc
 	new StockBegin,StockIn,StockReduce,StockEnd
 	new ListInfo,i,SumInfo,StartDate,EndDate,BeginYear,BeginMonthNum,EndYear,EndMonthNum,MonthStr,Date
 	new FirstFlag,LastFlag
 	
 	new StockChangeAccount,UsedReduce,StockOther,UsedOther
 	
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)	//Modify by yh 2019-12-17
 	s Date=+$H
	s Time=$p($H,",",2)
	
	if EquipTypeIDs="" s EquipTypeIDs=##Class(web.DHCEQACommon).GetAccessorysByGroup(CurGroupID)  //Modify by yh 2019-12-17
	s EquipTypeIDs= ##Class(web.DHCEQCommon).Replace(EquipTypeIDs,"^",",")
	i EquipTypeIDs="" s EquipTypeIDs=0
	
	s TempNode="Report.AMonthReport"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	
	s ^DHCEQTemp("AMonthReport")="StartMonth:"_StartMonth_",EndMonth:"_EndMonth
	
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
	s AccessoryType=0
	f  s AccessoryType=$o(^DHCEQTemp(TempNode,Date,$j,"Temp",AccessoryType)) q:AccessoryType=""  d
	.s AccessoryTypeDesc=$p($g(^DHCEQCCode("DHCEQCAccessoryType",AccessoryType)),"^",2)
	.s LocDR=0
	.f  s LocDR=$o(^DHCEQTemp(TempNode,Date,$j,"Temp",AccessoryType,LocDR)) q:LocDR=""  d
	..q:(paraLocDR'="")&&(paraLocDR'=LocDR)
	..s Loc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	..s ListInfo=$g(^DHCEQTemp(TempNode,Date,$j,"Temp",AccessoryType,LocDR))
	..i ListInfo'=""  d
	...s SumInfo=$g(^DHCEQTemp(TempNode,Date,$j,"Temp",0,"Sum"))
	...i SumInfo=""  d
	....s ^DHCEQTemp(TempNode,Date,$j,"Temp",0,"Sum")=ListInfo
	...e  d
	....for i=1:1:4  d //2012-02-01 DJ0103
	.....s $p(SumInfo,"^",i)=+$p(SumInfo,"^",i)+$p(ListInfo,"^",i)
	....s ^DHCEQTemp(TempNode,Date,$j,"Temp",0,"Sum")=SumInfo
	..s TRow=TRow+1
	..d OutputRowMonthReport
	
	s AccessoryType=0
	s AccessoryTypeDesc=""
	s TRow="总计:"
	s Loc=""
	s ListInfo=$g(^DHCEQTemp(TempNode,Date,$j,"Temp",0,"Sum"))
	
	;d OutputRowMonthReport  //Modify by yh 2019-12-17
	
	k ^DHCEQTemp(TempNode,Date,$j,"Temp")
	
	Quit $$$OK
AddOneMonthTempData
	;逐月汇总数据，临时存储在^DHCEQTemp(TempNode,Date,$j,"Temp"下
	i '$d(^DHCEQAMonthReportList(0,"LocType",Year,Month))		//Modify DJ 2016-04-01 DJ0176
	{
		;尚未月结的月份则，到业务表中获取
		s StartDate=##Class(web.DHCEQReport).GetReportDate(Year_"-"_Month,"","")
		s EndDate=$p(StartDate,"^",2)
		s StartDate=$p(StartDate,"^",1)
		d ..FillAStatListInfo(User,Year,Month,StartDate,EndDate,EquipTypeIDs) 		//Modify DJ 2016-04-01 DJ0176
		
		s AccessoryType=0
		f  s AccessoryType=$o(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType)) q:AccessoryType=""  d
		.s Loc=0
		.f  s Loc=$o(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,Loc)) q:Loc=""  d
		..s ListInfo=$g(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,Loc))
		..// Mozy003008	1268128		2020-04-09 
		..s reducefee=+$p(ListInfo,"^",5) //本期减少
		..s AddFee=0
		..s AddFee=$p(ListInfo,"^",2)+$p(ListInfo,"^",3)+$p(ListInfo,"^",6)-$p(ListInfo,"^",4)	//本期增加数应当减去退货减少数
		..s ListInfo=$p(ListInfo,"^",1)_"^"_AddFee_"^"_reducefee_"^"_$p(ListInfo,"^",7)		//Modify DJ 2016-04-01 DJ0176 end
		..d BuildMonthReportTemp
	}
	else
	{
		s Loc=0
		f  s Loc=$o(^DHCEQAMonthReportList(0,"LocType",Year,Month,Loc)) q:Loc=""  d		//Modify DJ 2016-04-01 DJ0176 begin
		.s AccessoryType=0
		.f  s AccessoryType=$o(^DHCEQAMonthReportList(0,"LocType",Year,Month,Loc,AccessoryType)) q:AccessoryType=""  d
		..s preRowId=0
		..f  s preRowId=$o(^DHCEQAMonthReportList(0,"LocType",Year,Month,Loc,AccessoryType,preRowId)) q:preRowId=""  d
		...s ListInfo=$g(^DHCEQAMonthReportList(preRowId))
		...// Mozy003008	1268128		2020-04-09 
		...s reducefee=+$p(ListInfo,"^",9) //本期减少
		...s AddFee=0
		...s AddFee=$p(ListInfo,"^",6)+$p(ListInfo,"^",7)+$p(ListInfo,"^",10)-$p(ListInfo,"^",8)	//本期增加数应当减去退货减少数
		...s ListInfo=$p(ListInfo,"^",5)_"^"_AddFee_"^"_reducefee_"^"_$p(ListInfo,"^",11)		//Modify DJ 2016-04-01 DJ0176 end
		...//期初  入库  减少  期末
		...d BuildMonthReportTemp
	}
	quit
BuildMonthReportTemp
	s SumInfo=$g(^DHCEQTemp(TempNode,Date,$j,"Temp",AccessoryType,Loc))
	;非第一个月，则不取期初
	i FirstFlag'="1"
	{
		s $p(ListInfo,"^",1)=0	;StockBegin
		;s $p(ListInfo,"^",8)=0	;UsedBegin		
	}
	i LastFlag'="1"
	{
		;s $p(ListInfo,"^",7)=0	;StockEnd
		;s $p(ListInfo,"^",14)=0	;UsedEnd
		;s $p(ListInfo,"^",16)=0	;TotalDepre
		;s $p(ListInfo,"^",21)=0	;NetFee
	}
	
	if SumInfo=""
	{		
		s SumInfo=ListInfo
	}
	else
	{
		for i=1:1:4  s $p(SumInfo,"^",i)=+$p(ListInfo,"^",i)+$p(SumInfo,"^",i)
	}
	s ^DHCEQTemp(TempNode,Date,$j,"Temp",AccessoryType,Loc)=SumInfo
	
	quit

OutputRowMonthReport
	q:ListInfo=""
	s StockBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",1),"",2)
	s StockIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",2),"",2)
	s StockReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",3),"",2)
	s StockEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",4),"",2)
	s Data=$lb(StockBegin,StockIn,StockReduce,StockEnd,AccessoryTypeDesc,$J,Loc,TRow)
	i TRow'="总计:" s ^DHCEQTemp(TempNode,Date,$j,index)=StockBegin_"^"_StockIn_"^"_StockReduce_"^"_StockEnd_"^"_AccessoryTypeDesc_"^"_$J_"^"_Loc
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod AMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AMonthReportExecute ]
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

ClassMethod AMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*// ---------------------------------- Mozy003008	1268128		2020-04-09 注释
/// 描述：根据起始终止日期汇总当月月结数据记录在^DHCEQTemp("AMonthReport","List",User,$J,Year,Month)
/// 访问表:无
/// 输入：User:操作员
/// 	  Year:年
/// 	  Month:月
/// 	  StartDate:开始日期
/// 	  EndDate:结束日期
/// 输出：无
/// 返回：成功返回空，否则返回出错信息
/// 备注：
/// w ##Class(web.DHCEQReportEx).FillStatListInfo()
ClassMethod FillStatListInfo(User, Year, Month, StartDate, EndDate, EquipTypeIDs)
{
	new PreYear,PreMonth,Loc,BillDate,StoreLoc,listInfo
 	new StockBegin,StockIn,StockReduce,StockEnd
 	new AccessoryType
 	;折旧总额,当月折旧,在库报废,库房转移(入),库房转移(出)
 	new MonthStr
 	new ListRowID,OutTypeCode,RemainOriginalFee,FundsFee,SourceType
 	 		
	k ^DHCEQTemp("AMonthReport","List",User,$J,Year,Month)
	if (Month=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Month-1}
	
	;0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
	s SourceType="3"
	//汇总入库信息
	s rowid=0
	f  s rowid=$o(^DHCEQAInStock(rowid)) q:(rowid="")  d
	.s StoreLoc=$p($g(^DHCEQAInStock(rowid)),"^",3) //科室
	.s AccessoryType=$p($g(^DHCEQAInStock(rowid)),"^",2) //配件类组
	.q:##Class(web.DHCEQCommon).IdInIds(AccessoryType,EquipTypeIDs)=0 //判断是否在类组串中
	.s ISNo=$p($g(^DHCEQAInStock(rowid)),"^",6) //入库单号
	.q:ISNo=""
	.s BillDate=$p($g(^DHCEQAInStock(rowid)),"^",24) //审核日期
	.q:(EndDate'="")&(BillDate>EndDate)
	.q:(StartDate'="")&(BillDate<StartDate)
	.s ListRowID=0
	.d InitStatInfoVariant
	.f  s ListRowID=$o(^DHCEQAInStockList(0,"AInStock",rowid,ListRowID)) q:(ListRowID="")  d
	..s RemainOriginalFee=($p($g(^DHCEQAInStockList(ListRowID)),"^",8)*$p($g(^DHCEQAInStockList(ListRowID)),"^",9)) //总价格
	..d SplitFunds
		
	s SourceType="5"
	//汇总减少信息
	s rowid=0
	f  s rowid=$o(^DHCEQAReduce(rowid)) q:(rowid="")  d
	.s StoreLoc=$p($g(^DHCEQAReduce(rowid)),"^",4) //退货科室
	.s AccessoryType=$p($g(^DHCEQAReduce(rowid)),"^",2) //配件类型
	.q:##Class(web.DHCEQCommon).IdInIds(AccessoryType,EquipTypeIDs)=0
	.;s OutType=$p($g(^DHCEQAReduce(rowid)),"^",3) //出库类型
	.s BillDate=$p($g(^DHCEQAReduce(rowid)),"^",16) //审核日期
	.q:(EndDate'="")&(BillDate>EndDate)
	.q:(StartDate'="")&(BillDate<(StartDate-1))
	.s ListRowID=0
	.d InitStatInfoVariant
	.f  s ListRowID=$o(^DHCEQAReduceList(0,"Reduce",rowid,ListRowID)) q:(ListRowID="")  d
	..s RemainOriginalFee=($p($g(^DHCEQAReduceList(ListRowID)),"^",9)*$p($g(^DHCEQAReduceList(ListRowID)),"^",10))
	..d SplitFunds
	
	s SourceType="4"
	//汇总转移信息
	s rowid=0
	f  s rowid=$o(^DHCEQAMoveStock(rowid)) q:rowid=""  d
	.s BillDate=$p($g(^DHCEQAMoveStock(rowid)),"^",17) //确认日期
	.q:(EndDate'="")&(BillDate>EndDate)
	.q:(StartDate'="")&(BillDate<(StartDate-1))
	.s AccessoryType=$p($g(^DHCEQAMoveStock(rowid)),"^",2) //配件类组
	.q:##Class(web.DHCEQCommon).IdInIds(AccessoryType,EquipTypeIDs)=0
	.s ListRowID=0
	.d InitStatInfoVariant
	.f  s ListRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",rowid,ListRowID)) q:(ListRowID="")  d
	..s RemainOriginalFee=$p($g(^DHCEQAMoveStockList(ListRowID)),"^",10)*$p($g(^DHCEQAMoveStockList(ListRowID)),"^",11)
	..d SplitFunds
	
	////取当月没有数据，但是上月有的作为本期的期初和期末
	s StoreLoc=0
	f  s StoreLoc=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc)) q:StoreLoc=""  d
	.s AccessoryType=0
	.f  s AccessoryType=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc,AccessoryType)) q:AccessoryType=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc,AccessoryType,rowid)) q:rowid=""  d
	...s listInfo=$g(^DHCEQAMonthReportList(rowid))
	...s AccessoryType=$p(listInfo,"^",17)
	...q:$g(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,StoreLoc))'=""
	...d InitStatInfoVariant
	...d AddStatListInfoNew
		
	quit

AddStatListInfoNew
	s (StockBegin)=0
	s listInfo=$g(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,StoreLoc))
	s StockEnd=StockBegin+StockIn-StockReduce  //期末
	if listInfo=""
	{
		//从结存明细报表中取数据
		s TotalDepre=0
		s preRowId=0
		f  s preRowId=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc,AccessoryType,preRowId)) q:preRowId=""  d
		.q:(AccessoryType'=$p($g(^DHCEQAMonthReportList(preRowId)),"^",17))
		.q:(StoreLoc'=$p($g(^DHCEQAMonthReportList(preRowId)),"^",3))
		.s StockBegin=+StockBegin+$p($g(^DHCEQAMonthReportList(preRowId)),"^",11)	///在库 上月期末为本月期初
		s listInfo=StockBegin_"^"_StockIn_"^"_StockReduce_"^"_StockEnd
		}
	else
	{
		s $p(listInfo,"^",1)=+$p(listInfo,"^",1)+StockBegin
		s $p(listInfo,"^",2)=+$p(listInfo,"^",2)+StockIn
		;s $p(listInfo,"^",3)=+$p(listInfo,"^",3)+StockReturn
		s $p(listInfo,"^",3)=+$p(listInfo,"^",3)+StockReduce
		s $p(listInfo,"^",4)=+$p(listInfo,"^",4)+StockEnd
	}
	s ^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,StoreLoc)=listInfo
	quit
InitStatInfoVariant
	s (StockBegin,StockIn,StockReduce,StockEnd)=0	
	s (RemainOriginalFee,FundsFee)=0
	q

SplitFunds
	s FundsFee=RemainOriginalFee
	d AddFundsInfo
	q
AddFundsInfo
	i SourceType="3"  d
	.;当期入库金额
	.s StockIn=FundsFee
	else  if SourceType="4"  d
	.;当期转移
	.;0:出库|1:库房调配|2:退库
	.if $p($g(^DHCEQAMoveStock(rowid)),"^",14)="0"  d
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",4)
	..s StockReduce=FundsFee
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",5)
	..s StockReduce=0
	..s StockIn=FundsFee
	.e  i $p($g(^DHCEQAMoveStock(rowid)),"^",14)="2"  d
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",4)
	..;s StockEnd=0
	..s StockReduce=FundsFee
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",5)
	..;s StockEnd=FundsFee
	..s StockIn=FundsFee
	.e  i $p($g(^DHCEQAMoveStock(rowid)),"^",14)="1"  d
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",4)
	..s StockReduce=FundsFee
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",5)
	..s StockIn=FundsFee
	else  if SourceType="5"  d
	.;当期退货及减少
	.s StoreLoc=$p($g(^DHCEQAReduce(rowid)),"^",4)
	.s StockReduce=FundsFee

	if SourceType'="9" d AddStatListInfoNew
	q
}
 Mozy003008	1268128		2020-04-09 注释
*/
ClassMethod CheckMonth(MonthStr)
{
	i ((MonthStr?4N1"-"1(2N,1N))&&($P(MonthStr,"-",2)<=12)&&($P(MonthStr,"-",2)>0)) q "0"
	q "1"
}

ClassMethod GetOneReportInfoDetail(PNum, job)
{
	//s ^DHCEQTemp(TempNode,Date,$j,index)=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockEnd_"^"_AccessoryTypeDesc_"^"_$J_"^"_Loc
	s Date=+$H
	i PNum=0 q $o(^DHCEQTemp("Report.AMonthReport",Date,job,""),-1)
	q $g(^DHCEQTemp("Report.AMonthReport",Date,job,PNum))
}

/// 供应商供货统计
/// modify BY:GBX GBX0016 
/// ValEquipTypes:配件类组串
/// modified by sjh 2019-12-10  将配件类组的形式换回成列表框  BUG00020	
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAReport","AVendorReport","","","","","")
Query AVendorReport(ValEquipTypes, StartDate, EndDate, VendorDR, QXType As %String = "") As %Query(ROWSPEC = "TVendorID:%String,TTotalFee:%String,TInStockAmount:%String,TInStockBillAmount:%String,TInStockBills:%String,TInStockFee:%String,TInvoiceAmount:%String,TNotPaidFee:%String,TPaidFee:%String,TReturnAmount:%String,TReturnBillAmount:%String,TReturnBills:%String,TReturnFee:%String,TVendor:%String,TTotalAmount:%String,TRow:%String")
{
}

ClassMethod AVendorReportExecute(ByRef qHandle As %Binary, ValEquipTypes, StartDate, EndDate, VendorDR, QXType As %String = "") As %Status
{
 	new repid, index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)	
 	s index=1
 	s PNum=1
 	s TRow=0
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("AVendorReport",User)
 	k ^DHCEQTemp("AVendorReportPrint",User)	//打印用的Global
	///更改日期转换方式 modified by sjh 2019-11-7 BUG00015
 	i StartDate="" d
	.s StartDate=0
	e  d
	.Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i ValEquipTypes="" s ValEquipTypes=##Class(web.DHCEQACommon).GetAccessorysByGroup() //modified by sjh 2019-12-10 BUG00020 begin
 	i ValEquipTypes="" Quit $$$OK 
	s ValEquipTypes="^"_ValEquipTypes_"^" //modified by sjh 2019-12-10 BUG00020 end
 	s vendorid=0	//供应商ID,初始化为0
 	s InvoiceDRList="^"  //发票RowID串
 	
 	//获得入库的相关信息
 	d ResetVariablesVendorReport
 	s vendorid=0
 	f  s vendorid=$o(^DHCEQAInStock(0,"Provider",vendorid)) q:vendorid=""  d
 	.s rowid=0
 	.f  s rowid=$o(^DHCEQAInStock(0,"Provider",vendorid,rowid)) q:rowid=""  d
 	..q:$p(^DHCEQAInStock(rowid),"^",16)'=2		// Mozy003008	1266917		2020-04-09 
 	..q:ValEquipTypes'[("^"_$p(^DHCEQAInStock(rowid),"^",2)_"^")  //modified by sjh 2019-12-10 BUG00020
 	..q:(VendorDR'="")&&(vendorid'=VendorDR)
 	..s MakeDate=$p(^DHCEQAInStock(rowid),"^",1)
 	..q:(StartDate'="")&(MakeDate<StartDate)
 	..q:(EndDate'="")&(MakeDate>EndDate)
 	..s StoreLoc=$p(^DHCEQAInStock(rowid),"^",3)
 	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)))
 	..q:(+$p(^DHCEQAInStock(rowid),"^",16)'=2)		//判断入库单是否为审核状态
 	..s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	..s TInStockBills=$p(^DHCEQAInStock(rowid),"^",6)	//入库单号
 	..s TInStockBillAmount=1	//入库单张数
 	..d GetInstockInfo


 	//获得退库的相关信息
 	d ResetVariablesVendorReport
	s rowid=0
	f  s rowid=$o(^DHCEQAReduce(rowid)) q:rowid=""  d
	.q:$p($g(^DHCEQAReduce(rowid)),"^",23)'=2		// Mozy003008	1266917		2020-04-09 
	.q:ValEquipTypes'[("^"_$p(^DHCEQAReduce(rowid),"^",2)_"^") 
 	.s vendorid=$p(^DHCEQAReduce(rowid),"^",6)
 	.;q:vendorid="" //2010-06-29 党军
 	.q:(VendorDR'="")&&(vendorid'=VendorDR)	//供应商
 	.s MakeDate=$p(^DHCEQAReduce(rowid),"^",8)
 	.q:(StartDate'="")&(MakeDate<StartDate)
 	.q:(EndDate'="")&(MakeDate>EndDate)
 	.s StoreLoc=$p(^DHCEQAReduce(rowid),"^",4) 
 	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) 
 	.q:(+$p(^DHCEQAReduce(rowid),"^",3)'=1)    //modified by sjh 2019-11-7 BUG00015      //判断'出库类型'是否为'退货'
 	.s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	.s TReturnBills=$p(^DHCEQAReduce(rowid),"^",1)	//退库单号
 	.s TReturnBillAmount=1		//退库单张数
 	.d GetReturnInfo
 	
 	//输出最终的结果
	s (sumInStockAmount,sumInStockFee,sumReturnAmount,sumReturnFee,sumTotalFee,sumTotalAmount,sumInStockBillAmount,sumReturnBillAmount,sumInvoiceAmount,sumPaidFee,sumNotPaidFee)=0
 	s vendorid=0
 	f  s vendorid=$o(^DHCEQTemp("AVendorReport",User,vendorid)) q:vendorid=""  d
 	.d ResetVariablesVendorReport
 	.s TVendorID=vendorid
 	.s TVendor=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",1)
 	.s TInStockAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",2)
 	.s TInStockFee=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",3)
 	.s TReturnAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",4)
 	.s TReturnFee=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",5)
 	.s TTotalFee=TInStockFee-TReturnFee				//在库金额
 	.s TTotalAmount=TInStockAmount-TReturnAmount	//在库数量
 	.s TInStockBillAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",6)
 	.s TInStockBills=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",7)
 	.s TReturnBillAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",8)
 	.s TReturnBills=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",9)
 	.s TInvoiceAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",10)
 	.s TPaidFee=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",11)
 	.s TNotPaidFee=TTotalFee-TPaidFee		//未付款金额
 	.;得到合计的结果
 	.s sumInStockAmount=sumInStockAmount+TInStockAmount
 	.s sumInStockFee=sumInStockFee+TInStockFee
 	.s sumReturnAmount=sumReturnAmount+TReturnAmount
 	.s sumReturnFee=sumReturnFee+TReturnFee
 	.s sumTotalFee=sumTotalFee+TTotalFee
 	.s sumTotalAmount=sumTotalAmount+TTotalAmount
 	.s sumInStockBillAmount=sumInStockBillAmount+TInStockBillAmount
 	.s sumReturnBillAmount=sumReturnBillAmount+TReturnBillAmount
 	.s sumInvoiceAmount=sumInvoiceAmount+TInvoiceAmount
 	.s sumPaidFee=sumPaidFee+TPaidFee
 	.s sumNotPaidFee=sumNotPaidFee+TNotPaidFee
 	.d OutputRowVendorReport
 	
 	//输出最终的合计
 	d ResetVariablesVendorReport 	
 	s TVendor="合计:"
 	s TInStockAmount=sumInStockAmount
 	s TInStockFee=sumInStockFee
 	s TReturnAmount=sumReturnAmount
 	s TReturnFee=sumReturnFee
 	s TTotalFee=sumTotalFee
 	s TTotalAmount=sumTotalAmount
 	s TInStockBillAmount=sumInStockBillAmount
 	s TReturnBillAmount=sumReturnBillAmount
 	s TInvoiceAmount=sumInvoiceAmount
 	s TPaidFee=sumPaidFee
 	s TNotPaidFee=sumNotPaidFee
 	d OutputRowVendorReport
 	
	Quit $$$OK
		
GetInstockInfo
	s listRowId=0	//入库明细ID
	f  s listRowId=$o(^DHCEQAInStockList(0,"AInStock",rowid,listRowId)) q:listRowId=""  d
	.s TInStockAmount=TInStockAmount+($p($g(^DHCEQAInStockList(listRowId)),"^",9))	//入库数量
	.s TInStockFee=TInStockFee+($p($g(^DHCEQAInStockList(listRowId)),"^",8)*$p($g(^DHCEQAInStockList(listRowId)),"^",9))	//入库金额(设备原值*数量)
 	.s IUMRowID=0
 	.;发票使用对应表  ^DHCEQInvoiceUseMap(0,"Source",{IUM_Type},{IUM_SourceID},{IUM_RowID})
 	.f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",3,listRowId,IUMRowID)) q:IUMRowID=""  d
 	..s InvoiceDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)
 	..i InvoiceDRList'[("^"_InvoiceDR_"^") d
 	...s InvoiceDRList=InvoiceDRList_InvoiceDR_"^"
 	...s TInvoiceAmount=TInvoiceAmount+1
 	.s payrecord=""		//付款记录ID
 	.f  s payrecord=$o(^DHCEQPayRecord(0,"Source",3,listRowId,payrecord))  q:payrecord=""  d
 	..s TPaidFee=TPaidFee+$p($g(^DHCEQPayRecord(payrecord)),"^",3)	//支付金额
 	
 	i ($g(^DHCEQTemp("AVendorReport",User,vendorid))'="") d
 	.s TVendor=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",1)	 //供应商                                             
 	.s TInStockAmount=TInStockAmount+($p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",2))
 	.s TInStockFee=TInStockFee+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",3)
 	.i $p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",7)'[TInStockBills  d
 	..i $p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",7)'=""  d
 	...s TInStockBills=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",7)_","_TInStockBills			//入库单
	..s TInStockBillAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",6)+1		//入库单张数
 	.s TInvoiceAmount=TInvoiceAmount+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",10)	//发票数
 	.s TPaidFee=TPaidFee+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",11)		//已付款金额
 	
 	s ^DHCEQTemp("AVendorReport",User,vendorid)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee
	d ResetVariablesVendorReport
	quit
	
GetReturnInfo
	s listRowId=0
	f  s listRowId=$o(^DHCEQAReduceList(0,"Reduce",rowid,listRowId)) q:listRowId=""  d
	.s TReturnAmount=TReturnAmount+$p($g(^DHCEQAReduceList(listRowId)),"^",10)	//退库数量
	.s TReturnFee=TReturnFee+($p($g(^DHCEQAReduceList(listRowId)),"^",10)*$p($g(^DHCEQAReduceList(listRowId)),"^",9))		//退库金额(退库数量*金额)
	
	i ($g(^DHCEQTemp("AVendorReport",User,vendorid))'="") d
	.s TVendor=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",1)
	.s TInStockAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",2)
 	.s TInStockFee=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",3)
 	.s TReturnAmount=TReturnAmount+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",4)
 	.s TReturnFee=TReturnFee+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",5)
 	.s TInStockBillAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",6)
 	.s TInStockBills=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",7)
 	.i $p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",8)'[TReturnBills  d
 	..s TReturnBillAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",8)+1		//退货单数量
 	..i $p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",9)'=""  d
 	...s TReturnBills=$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",9)_","_TReturnBills	//退货单号
 	.s TInvoiceAmount=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",10)		//发票数
 	.s TPaidFee=+$p($g(^DHCEQTemp("AVendorReport",User,vendorid)),"^",11)
	
	s ^DHCEQTemp("AVendorReport",User,vendorid)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee
	d ResetVariablesVendorReport
	quit
	
ResetVariablesVendorReport
	;s InvoiceDRList="^"
	s (TVendorID,TVendor,TReturnBills,TInStockBills)=""
	s (MakeDate,TTotalFee,TInStockAmount,TInStockBillAmount,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnFee,TTotalAmount)=0	
	quit
OutputRowVendorReport
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
	s TInStockFee=##Class(web.DHCEQCommon).FormatNumber(TInStockFee,"",4)
	s TReturnFee=##Class(web.DHCEQCommon).FormatNumber(TReturnFee,"",4)
	s TPaidFee=##Class(web.DHCEQCommon).FormatNumber(TPaidFee,"",4)
	s TNotPaidFee=##Class(web.DHCEQCommon).FormatNumber(TNotPaidFee,"",4)
	s TRow=TRow+1
	s Data=$lb(TVendorID,TTotalFee,TInStockAmount,TInStockBillAmount,TInStockBills,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnBills,TReturnFee,TVendor,TTotalAmount,TRow)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^DHCEQTemp("AVendorReportPrint",User,PNum)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TTotalAmount_"^"_TTotalFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TNotPaidFee
	s PNum=PNum+1
	quit
}

ClassMethod AVendorReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AVendorReportExecute ]
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

ClassMethod AVendorReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AVendorReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAVendorReport(num)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^DHCEQTemp("AVendorReportPrint",User,num))
}

/// d ##Class(web.DHCEQAVerdorStat).GetAccessoryTypesInfo()
/// 取配件类组
/// Modify BY:GBX 2014-7-24
ClassMethod GetAccessoryTypesInfo()
{
	s infos=""
	new AccessoryTypeDR,AccessoryType
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessoryType",rowid)) q:rowid=""  d
	.s flag=##Class(web.DHCEQACommon).AccessoryTypeIsIn(rowid)
	.q:flag=1
	.i infos'="" s infos=infos_"&"	
	.s infos=infos_$g(^DHCEQCCode("DHCEQCAccessoryType",rowid))_"^"_rowid
	q infos
}

/// Modify By GBX 2014-7-29
/// 供应商供货分组汇总统计查询.
/// modified by sjh 2019-12-10  将配件类组的形式换回成列表框  BUG00020																																		  TVendor	      TVendorID,        TTotalFee,        TInStockAmount,        TInStockBillAmount,        TInStockBills,        TInStockFee,        TInvoiceAmount,        TNotPaidFee,        TPaidFee,        TReturnAmount,        TReturnBillAmount,        TReturnBills,        TReturnFee,        TTotalAmount,        TAccessoryType,        TAccessoryCat,        TAccessory,        TAccessoryTypeDR,       TAccessoryCatDR		
/// 																																		  TVendor	      TVendorID,        TTotalFee,        TInStockAmount,        TInStockBillAmount,        TInStockBills,        TInStockFee,        TInvoiceAmount,        TNotPaidFee,        TPaidFee,        TReturnAmount,        TReturnBillAmount,        TReturnBills,        TReturnFee,        TTotalAmount,        TAccessoryType,        TAccessoryCat,        TAccessory,        TAccessoryTypeDR,       TAccessoryCatDR		
Query GetAVendorStatA(ValEquipTypes, StartDate, EndDate, VendorDR, Vendor, QXType As %String = "") As %Query(ROWSPEC = "TVendor:%String,TVendorID:%String,TTotalFee:%String,TInStockAmount:%String,TInStockBillAmount:%String,TInStockBills:%String,TInStockFee:%String,TInvoiceAmount:%String,TNotPaidFee:%String,TPaidFee:%String,TReturnAmount:%String,TReturnBillAmount:%String,TReturnBills:%String,TReturnFee:%String,TTotalAmount:%String,TAccessoryType:%String,TAccessoryCat:%String,TAccessory:%String,TAccessoryTypeDR:%String,TAccessoryCatDR:%String,TRow:%String")
{
}

ClassMethod GetAVendorStatAExecute(ByRef qHandle As %Binary, ValEquipTypes, StartDate, EndDate, VendorDR, Vendor, QXType As %String = "") As %Status
{
 	new repid, index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)	
 	s index=1
 	s PNum=1
 	s TRow=0
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("AVendorStatA",User)
 	k ^DHCEQTemp("AVendorStatAPrint",User)	//打印用的global
	///更改日期转换方式 modified by sjh 2019-11-7 BUG00015
 	i StartDate="" d
	.s StartDate=0
	e  d
	.Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	i ValEquipTypes="" s ValEquipTypes=##Class(web.DHCEQACommon).GetAccessorysByGroup() //modified by sjh 2019-12-10 BUG00020 begin

 	i ValEquipTypes="" Quit $$$OK    

 	s ValEquipTypes="^"_ValEquipTypes_"^" //modified by sjh 2019-12-10 BUG00020 end
 	s vendorid=0	//供应商ID,初始化为0
 	s InvoiceDRList=""  //发票RowID串
 	s AllInStockBills=""
 	s AllReturnBills=""
 	s AllInvoiceDR=""
 	
 	d ResetVariablesAVendorStatA
 	//获得入库的相关信息
 	s vendorid=0
 	f  s vendorid=$o(^DHCEQAInStock(0,"Provider",vendorid)) q:vendorid=""  d
 	.q:(VendorDR'="")&&(vendorid'=VendorDR)		; Mozy003017	1292794	2020-04-26
 	.s rowid=0
 	.f  s rowid=$o(^DHCEQAInStock(0,"Provider",vendorid,rowid)) q:rowid=""  d
 	..s MakeDate=$p($g(^DHCEQAInStock(rowid)),"^",1)
 	..q:(StartDate'="")&(MakeDate<StartDate)
 	..q:(EndDate'="")&(MakeDate>EndDate)
 	..s StoreLoc=$p($g(^DHCEQAInStock(rowid)),"^",3) //入库科室
 	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) 
 	..q:(+$p($g(^DHCEQAInStock(rowid)),"^",16)'=2)		//判断入库单是否为审核状态
 	..s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
	..;q:TVendor'=Vendor   //add by sjh 2019-11-6 BUG00015	//Modify by yh 2019-12-25
 	..s TInStockBills=$p($g(^DHCEQAInStock(rowid)),"^",6)	//入库单号
 	..s TAccessoryTypeDR=$p($g(^DHCEQAInStock(rowid)),"^",2)  //配件类组
	..q:ValEquipTypes'[("^"_$p(^DHCEQAInStock(rowid),"^",2)_"^") //modified by sjh 2019-12-10 BUG00020
 	..s TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
 	..s TInStockBillAmount=1	//入库单张数
 	..d GetInstockInfoA
 	
  	//获得退库的相关信息
 	d ResetVariablesAVendorStatA
 	s rowid=0
	f  s rowid=$o(^DHCEQAReduce(rowid)) q:rowid=""  d
	.Quit:$Piece($Get(^DHCEQAReduce(rowid)),"^",23)'=2		; Mozy003017	1292794	2020-04-26	审核状态
	.q:ValEquipTypes'[("^"_$p(^DHCEQAReduce(rowid),"^",2)_"^")  //modified by sjh 2019-12-10 BUG00020
 	.s vendorid=$p($g(^DHCEQAReduce(rowid)),"^",6)
 	.q:vendorid="" 
 	.q:(VendorDR'="")&&(vendorid'=VendorDR)	//供应商
 	.s MakeDate=$p($g(^DHCEQAReduce(rowid)),"^",8)
 	.q:(StartDate'="")&(MakeDate<StartDate)
 	.q:(EndDate'="")&(MakeDate>EndDate)
 	.s StoreLoc=$p($g(^DHCEQAReduce(rowid)),"^",4) 
 	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) 
 	.q:(+$p($g(^DHCEQAReduce(rowid)),"^",3)'=1)	  // modified by sjh 2019-10-7 BUG00015      //判断'出库类型'是否为'退货' Modify BY:GBX 2014-7-28 11:27:14
 	.s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
	..;q:TVendor'=Vendor   //add by sjh 2019-11-6 BUG00015	//Modify by yh 2019-12-25
 	.s TReturnBills=$p($g(^DHCEQAReduce(rowid)),"^",1)	//退库单号
 	.s TAccessoryTypeDR=$p($g(^DHCEQAReduce(rowid)),"^",2)  //配件类组
 	.s TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
 	.s TReturnBillAmount=1		//退库单张数
 	.d GetReturnInfoA
 
 	//输出最终的结果
	s (sumInStockAmount,sumInStockFee,sumReturnAmount,sumReturnFee,sumTotalFee,sumTotalAmount,sumInStockBillAmount,sumReturnBillAmount,sumPaidFee,sumNotPaidFee)=0
 	s vendorid=0	//$o(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)) q:vendorid=""  d
 	f  s vendorid=$o(^DHCEQTemp("AVendorStatA",User,vendorid)) q:vendorid=""  d
 	.s AccessoryTypeDR=""
 	.f  s AccessoryTypeDR=$o(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR)) q:AccessoryTypeDR=""  d
 	..s AccessoryCatDR=""
 	..f  s AccessoryCatDR=$o(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR)) q:AccessoryCatDR=""  d
 	...s Accessory=""
 	...f  s Accessory=$o(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)) q:Accessory=""  d
 	....d SetOutputRowAVendorStatA
 	....d OutputRowAVendorStatA
 		
 	//输出最终的合计
 	d ResetVariablesAVendorStatA
 	s TVendor="合计:"
 	s TInStockAmount=sumInStockAmount
 	s TInStockFee=sumInStockFee
 	s TReturnAmount=sumReturnAmount
 	s TReturnFee=sumReturnFee
 	s TTotalFee=sumTotalFee
 	s TTotalAmount=sumTotalAmount
 	s TInStockBillAmount=..GetSubStringNum(AllInStockBills)
 	s TReturnBillAmount=..GetSubStringNum(AllReturnBills)
 	s TInvoiceAmount=..GetSubStringNum(AllInvoiceDR)
 	s TPaidFee=sumPaidFee
 	s TNotPaidFee=sumNotPaidFee

 	d OutputRowAVendorStatA
 	
	Quit $$$OK
		
GetInstockInfoA
	s listRowId=0	//入库明细ID
	f  s listRowId=$o(^DHCEQAInStockList(0,"AInStock",rowid,listRowId)) q:listRowId=""  d
	.s TInStockAmount=$p($g(^DHCEQAInStockList(listRowId)),"^",9)			//入库数量
	.s TInStockFee=$p($g(^DHCEQAInStockList(listRowId)),"^",10)				//入库金额
	.i TInStockFee="" s TInStockFee=$p($g(^DHCEQAInStockList(listRowId)),"^",8)*$p($g(^DHCEQAInStockList(listRowId)),"^",9)	// MZY0037	1400526		2020-07-06
 	.s ItemDR=$p($g(^DHCEQAInStockList(listRowId)),"^",2)
 	.s TAccessoryCatDR=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",15)  //配件分类
 	.i TAccessoryCatDR'="" s TAccessoryCat=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",TAccessoryCatDR)),"^",3) 
 	.s TAccessory=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",2)
 	.
 	.s IUMRowID=0
 	.s InvoiceDRList=""
 	.f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",3,listRowId,IUMRowID)) q:IUMRowID=""  d
 	..s InvoiceDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)	//发票ID
 	..i InvoiceDRList'=""  d
 	...s InvoiceDRList=InvoiceDRList_","_InvoiceDR
 	..e  d
 	...s InvoiceDRList=InvoiceDR
 	.s payrecord=""		//付款记录ID
 	.f  s payrecord=$o(^DHCEQPayRecord(0,"Source",3,listRowId,payrecord))  q:payrecord=""  d
 	..s TPaidFee=TPaidFee+$p($g(^DHCEQPayRecord(payrecord)),"^",3)	//支付金额
 	.
 	.s TInvoiceAmount=InvoiceDRList
 	.
 	.i TAccessoryTypeDR="" s TAccessoryTypeDR=0
 	.i TAccessoryCatDR="" s TAccessoryCatDR=0 //配件分类
 	.i TAccessory="" s TAccessory=0
 	.i ($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory))'="") d
 	..s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	 //供应商                                             
 	..s TInStockAmount=TInStockAmount+($p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",2))
 	..s TInStockFee=TInStockFee+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",3)
 	..i $p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",7)'[TInStockBills d 
 	...i $p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",7)'=""  d
 	....s TInStockBills=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",7)_","_TInStockBills			//入库单
 	...s TInStockBillAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",6)+1		//入库单张数
 	..i InvoiceDRList'=""  d
 	...s TInvoiceAmount=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",10)_","_TInvoiceAmount	//先记录下所有发票的ID,之后再算出发票数
 	..s TPaidFee=TPaidFee+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",11)		//已付款金额
 	.s ^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TAccessoryType_"^"_TAccessoryCat_"^"_TAccessory_"^"_TAccessoryTypeDR_"^"_TAccessoryCatDR
	i InvoiceDRList'="" d 
	.i AllInvoiceDR'=""  d 
	..s AllInvoiceDR=AllInvoiceDR_","_InvoiceDRList
	.e  d
	..s AllInvoiceDR=InvoiceDRList
	d ResetVariablesAVendorStatA
	quit
	
GetReturnInfoA
	s listRowId=0
	f  s listRowId=$o(^DHCEQAReduceList(0,"Reduce",rowid,listRowId)) q:listRowId=""  d
	.s StockDetailDR=$p($g(^DHCEQAReduceList(listRowId)),"^",5)
	.s TAccessory=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",5) 	//配件名称
	.s TReturnAmount=$p($g(^DHCEQAReduceList(listRowId)),"^",10)	//退库数量
	.s TReturnFee=$p($g(^DHCEQAReduceList(listRowId)),"^",11)		//退库金额
	.i TAccessoryTypeDR="" s TAccessoryTypeDR=0
 	.s ItemDR=$p($g(^DHCEQAReduceList(listRowId)),"^",2)
 	.s TAccessoryCatDR=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",15)  //配件分类
 	.i TAccessoryCatDR'="" s TAccessoryCat=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",TAccessoryCatDR)),"^",3) 
 	.s TAccessory=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",2)
 	.i TAccessoryCatDR="" s TAccessoryCatDR=0
 	.i TAccessory="" s TAccessory=0
	.i ($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory))'="") d
	..s TVendor=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",1)
	..s TInStockAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",2)
 	..s TInStockFee=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",3)
 	..s TReturnAmount=TReturnAmount+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",4)
 	..s TReturnFee=TReturnFee+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",5)
 	..s TInStockBillAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",6)
 	..s TInStockBills=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",7)
 	..i $p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",9)'[TReturnBills
 	...s TReturnBillAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",8)+1		//退货单数量
 	...i $p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",9)'=""  d
 	....s TReturnBills=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",9)_","_TReturnBills	//退货单号
 	..s TInvoiceAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",10)		//发票数
 	..s TPaidFee=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",11)
 	..s TAccessoryType=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",12)
 	..s TAccessoryCat=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",13) //配件分类
 	..s TAccessory=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",14)
 	..s TAccessoryTypeDR=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",15)
 	..s TAccessoryCatDR=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)),"^",16) 
	.s ^DHCEQTemp("AVendorStatA",User,vendorid,TAccessoryTypeDR,TAccessoryCatDR,TAccessory)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TAccessoryType_"^"_TAccessoryCat_"^"_TAccessory_"^"_TAccessoryTypeDR_"^"_TAccessoryCatDR
	d ResetVariablesAVendorStatA
	quit
	
ResetVariablesAVendorStatA
	s InvoiceDRList=""
	s (TVendorID,TVendor,TReturnBills,TInStockBills,TAccessoryType,TAccessoryCat,TAccessory,TAccessoryTypeDR,TAccessoryCatDR)=""
	s (TTotalFee,TInStockAmount,TInStockBillAmount,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnFee,TTotalAmount)=0	
	quit
	
SetOutputRowAVendorStatA
 	d ResetVariablesAVendorStatA
 	s TVendorID=vendorid
 	s TVendor=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",1)
 	s TInStockAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",2)
 	s TInStockFee=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",3)
 	s TReturnAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",4)
 	s TReturnFee=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",5)
 	s TTotalFee=TInStockFee-TReturnFee				//在库金额
 	s TTotalAmount=TInStockAmount-TReturnAmount	//在库数量
 	s TInStockBillAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",6)
 	s TInStockBills=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",7)
 	s TReturnBillAmount=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",8)
 	s TReturnBills=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",9)
 	s InvoiceDRs=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",10)
 	s TInvoiceAmount=..GetSubStringNum(InvoiceDRs)	//算出不重复的发票数
 	s TPaidFee=+$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",11)
 	s TNotPaidFee=TTotalFee-TPaidFee		//未付款金额
 	s TAccessoryType=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",12)
 	s TAccessoryCat=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",13)
 	s TAccessory=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",14)
 	s TAccessoryTypeDR=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",15)
 	s TAccessoryCatDR=$p($g(^DHCEQTemp("AVendorStatA",User,vendorid,AccessoryTypeDR,AccessoryCatDR,Accessory)),"^",16)
 	/*
	Mozy003019	1296363	2020-04-28	修正取值拼串
	i AllInStockBills'=""  d
 	.s AllInStockBills=AllInStockBills_","_TInStockBills
 	e  d
 	.s AllInStockBills=TInStockBills
 	i AllReturnBills'=""  d
 	.s AllReturnBills=AllReturnBills_","_TReturnBills
 	e  d
 	.s AllReturnBills=TReturnBills
 	i AllInvoiceDR'=""  d
 	.s AllInvoiceDR=AllInvoiceDR_","_InvoiceDRs
 	e  d
 	.s AllInvoiceDR=InvoiceDRs*/
	i TInStockBills'=""
 	{
 		i AllInStockBills'="" s AllInStockBills=AllInStockBills_","
 		s AllInStockBills=AllInStockBills_TInStockBills
 	}
 	i TReturnBills'=""
 	{
 		i AllReturnBills'="" s AllReturnBills=AllReturnBills_","
 		s AllReturnBills=AllReturnBills_TReturnBills
 	}
 	i InvoiceDRs'=""
 	{
 		i AllInvoiceDR'="" s AllInvoiceDR=AllInvoiceDR_","
 		s AllInvoiceDR=AllInvoiceDR_InvoiceDRs
 	}
 	
 	;以下得到合计的结果
 	s sumInStockAmount=sumInStockAmount+TInStockAmount
 	s sumInStockFee=sumInStockFee+TInStockFee
 	s sumReturnAmount=sumReturnAmount+TReturnAmount
 	s sumReturnFee=sumReturnFee+TReturnFee
 	s sumTotalFee=sumTotalFee+TTotalFee
 	s sumTotalAmount=sumTotalAmount+TTotalAmount
 	;s sumInStockBillAmount=sumInStockBillAmount+TInStockBillAmount
 	;s sumReturnBillAmount=sumReturnBillAmount+TReturnBillAmount
 	s sumPaidFee=sumPaidFee+TPaidFee
 	s sumNotPaidFee=sumNotPaidFee+TNotPaidFee
 	quit
	
	
OutputRowAVendorStatA
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
	s TInStockFee=##Class(web.DHCEQCommon).FormatNumber(TInStockFee,"",4)
	s TReturnFee=##Class(web.DHCEQCommon).FormatNumber(TReturnFee,"",4)
	s TPaidFee=##Class(web.DHCEQCommon).FormatNumber(TPaidFee,"",4)
	s TNotPaidFee=##Class(web.DHCEQCommon).FormatNumber(TNotPaidFee,"",4)
	s TRow=TRow+1
	s Data=$lb(TVendor,TVendorID,TTotalFee,TInStockAmount,TInStockBillAmount,TInStockBills,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnBills,TReturnFee,TTotalAmount,TAccessoryType,TAccessoryCat,TAccessory,TAccessoryTypeDR,TAccessoryCatDR,TRow)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	//打印用^DHCEQTemp("AVendorStatAPrint",User,PNum)
	s ^DHCEQTemp("AVendorStatAPrint",User,PNum)=TVendor_"^"_TAccessoryType_"^"_TAccessoryCat_"^"_TAccessory_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TTotalAmount_"^"_TTotalFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TNotPaidFee
	s PNum=PNum+1
	quit
}

ClassMethod GetAVendorStatAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAVendorStatAExecute ]
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

ClassMethod GetAVendorStatAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAVendorStatAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By HZY 2011-11-25 HZY0020
/// Desc:得到字符串中不重复的子串的个数 (也可以返回不含重复子串的字符串,以","号分隔)
/// w ##Class(web.DHCEQReportEx).GetSubStringNum("2011,2012")
ClassMethod GetSubStringNum(str)
{
	i str="" q 0
	s i=1, tmpStr="", resultStr=",", resultNum=0
	s num=$Length(str,",")
	for i=1:1:num
	{
		s tmpStr=$p(str,",",i)_","
		if (resultStr'[(","_tmpStr))
		{
				s resultStr=resultStr_tmpStr
				s resultNum=resultNum+1
		}
	}
	;q resultStr	//返回不含重复子串的字符串 
	q resultNum		//返回不重复子串的个数
}

ClassMethod GetAVendorAReport(num)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^DHCEQTemp("AVendorStatAPrint",User,num))
}

/// ----------------------------------
/// add by zx 2015-03-24
/// 描述：根据起始终止日期汇总当月月结数据记录在^DHCEQTemp("AMonthReport","List",User,$J,Year,Month)
/// 访问表:无
/// 输入：User:操作员
/// 	  Year:年
/// 	  Month:月
/// 	  StartDate:开始日期
/// 	  EndDate:结束日期
/// 输出：无
/// 返回：成功返回空，否则返回出错信息
/// 备注：
/// w ##Class(web.DHCEQAReport).FillAStatListInfo()
ClassMethod FillAStatListInfo(User, Year, Month, StartDate, EndDate, AccessoryTypeIDs As %Library.String = "")
{
	new PreYear,PreMonth,Loc,BillDate,StoreLoc,listInfo
 	new AStockBegin,AStockIn,AStockReturn,AStockReduce,AStockMoveOut,AStockMoveIn,AStockEnd
 	new AccessoryType
 	
 	new MonthStr
 	new ListRowID,OutTypeCode,OriginalFee,FundsFee,SourceType
 	 		
	k ^DHCEQTemp("AMonthReport","List",User,$J,Year,Month)
	if (Month=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Month-1}
	
	;0:入库明细,1:转移明细,2:退货明细
	s SourceType="0"
	//汇总入库信息
	s AccessoryType=0
	f  s AccessoryType=$o(^DHCEQAInStock(0,"TypeDate",AccessoryType)) q:AccessoryType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(AccessoryType,AccessoryTypeIDs)=0 //判断是否在类组串中
	.s BillDate=StartDate-1 
	.f  s BillDate=$o(^DHCEQAInStock(0,"TypeDate",AccessoryType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQAInStock(0,"TypeDate",AccessoryType,BillDate,rowid)) q:rowid=""  d
	...s ISNo=$p($g(^DHCEQAInStock(rowid)),"^",6) //入库单号
	...q:ISNo=""
	...s StoreLoc=$p($g(^DHCEQAInStock(rowid)),"^",3) //科室
	...s ListRowID=0
	...d InitStatAInfoVariant
	...f  s ListRowID=$o(^DHCEQAInStockList(0,"AInStock",rowid,ListRowID)) q:(ListRowID="")  d
	....s OriginalFee=($p($g(^DHCEQAInStockList(ListRowID)),"^",8)*$p($g(^DHCEQAInStockList(ListRowID)),"^",9)) //总价格
	....d AddAFundsInfo

    s SourceType="1"
    //汇总转移信息
    s rowid=0
	f  s rowid=$o(^DHCEQAMoveStock(rowid)) q:rowid=""  d
	.s BillDate=$p($g(^DHCEQAMoveStock(rowid)),"^",17) //确认日期
	.q:(EndDate'="")&(BillDate>EndDate)
	.q:(StartDate'="")&(BillDate<StartDate)		//Modify DJ 2016-05-10
	.s AccessoryType=$p($g(^DHCEQAMoveStock(rowid)),"^",2) //配件类组
	.q:##Class(web.DHCEQCommon).IdInIds(AccessoryType,AccessoryTypeIDs)=0
	.s ListRowID=0
	.d InitStatAInfoVariant
	.f  s ListRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",rowid,ListRowID)) q:(ListRowID="")  d
	..s OriginalFee=$p($g(^DHCEQAMoveStockList(ListRowID)),"^",10)*$p($g(^DHCEQAMoveStockList(ListRowID)),"^",11)
	..d AddAFundsInfo

    s SourceType="2"
    //汇总退货明细
    s AccessoryType=0
	f  s AccessoryType=$o(^DHCEQAReduce(0,"TypeDate",AccessoryType)) q:AccessoryType=""  d
	.q:##Class(web.DHCEQCommon).IdInIds(AccessoryType,AccessoryTypeIDs)=0 //判断是否在类组串中
	.// Mozy003008	1268128		2020-04-09	补充统计减少单数据
	.s ReduceType=""
	.f  s ReduceType=$o(^DHCEQAReduce(0,"TypeDate",AccessoryType,ReduceType)) q:(ReduceType="")  d
	..s BillDate=StartDate-1   //根据时间 汇总退货信息 潍坊项目不存在报废,耗损等减少类型,取类型为"1"
	..f  s BillDate=$o(^DHCEQAReduce(0,"TypeDate",AccessoryType,ReduceType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
    ...s rowid=0
    ...f  s rowid=$o(^DHCEQAReduce(0,"TypeDate",AccessoryType,ReduceType,BillDate,rowid)) q:rowid=""  d
    ....s StoreLoc=$p($g(^DHCEQAReduce(rowid)),"^",4) //退货科室
    ....s ListRowID=0
	....d InitStatAInfoVariant
	....f  s ListRowID=$o(^DHCEQAReduceList(0,"Reduce",rowid,ListRowID)) q:(ListRowID="")  d
	.....s OriginalFee=($p($g(^DHCEQAReduceList(ListRowID)),"^",9)*$p($g(^DHCEQAReduceList(ListRowID)),"^",10))
	.....d AddAFundsInfo
	
	////取当月没有数据，但是上月有的作为本期的期初和期末
	s StoreLoc=0
	f  s StoreLoc=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc)) q:StoreLoc=""  d
	.s AccessoryType=0
	.f  s AccessoryType=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc,AccessoryType)) q:AccessoryType=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc,AccessoryType,rowid)) q:rowid=""  d
	...s listInfo=$g(^DHCEQAMonthReportList(rowid))
	...s AccessoryType=$p(listInfo,"^",17)
	...q:$g(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,StoreLoc))'=""
	...d InitStatAInfoVariant
	...d AddStatListInfo
		
	quit

AddStatListInfo
	s (AStockBegin)=0
	s listInfo=$g(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,StoreLoc))
	s AStockEnd=AStockBegin+AStockIn-AStockMoveOut+AStockReturn-AStockReduce+AStockMoveIn  //期末
	if listInfo=""
	{
		//从月结表中取数据
		s preRowId=0
		f  s preRowId=$o(^DHCEQAMonthReportList(0,"LocType",PreYear,PreMonth,StoreLoc,AccessoryType,preRowId)) q:preRowId=""  d
		.s AStockBegin=+AStockBegin+$p($g(^DHCEQAMonthReportList(preRowId)),"^",11)	///在库 上月期末为本月期初
		.s AStockEnd=+AStockEnd+AStockBegin
		s listInfo=AStockBegin_"^"_AStockIn_"^"_AStockReturn_"^"_AStockReduce_"^"_AStockMoveOut_"^"_AStockMoveIn_"^"_AStockEnd
	}
	else
	{
		s $p(listInfo,"^",1)=+$p(listInfo,"^",1)+AStockBegin
		s $p(listInfo,"^",2)=+$p(listInfo,"^",2)+AStockIn
		s $p(listInfo,"^",3)=+$p(listInfo,"^",3)+AStockReturn
		s $p(listInfo,"^",4)=+$p(listInfo,"^",4)+AStockReduce
		s $p(listInfo,"^",5)=+$p(listInfo,"^",5)+AStockMoveOut
		s $p(listInfo,"^",6)=+$p(listInfo,"^",6)+AStockMoveIn
		s $p(listInfo,"^",7)=+$p(listInfo,"^",7)+AStockEnd
	}
	s ^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,StoreLoc)=listInfo
	quit
InitStatAInfoVariant
	s (AStockBegin,AStockIn,AStockReturn,AStockReduce,AStockMoveOut,AStockMoveIn,AStockEnd)=0	
	s OriginalFee=0
	q
AddAFundsInfo
	i SourceType="0"  d
	.;当期入库金额
	.s AStockIn=OriginalFee
	else  if SourceType="1"  d
	.;当期转移
	.;s AStockEnd=AStockBegin+AStockIn-AStockMoveOut+AStockMoveIn-AStockReduce+AStockReturn  //期末
	.;0:出库|1:库房调配|2:退库
	.if $p($g(^DHCEQAMoveStock(rowid)),"^",14)="0"  d
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",4)
	..s AStockMoveOut=OriginalFee
	..s AStockMoveIn=0
	..d AddStatListInfo
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",5)
	..s AStockMoveOut=0
	..s AStockMoveIn=OriginalFee
	.e  i $p($g(^DHCEQAMoveStock(rowid)),"^",14)="1"  d
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",4)
	..s AStockMoveOut=OriginalFee
	..s AStockMoveIn=0
	..d AddStatListInfo
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",5)
	..s AStockMoveOut=0
	..s AStockMoveIn=OriginalFee
	.e  i $p($g(^DHCEQAMoveStock(rowid)),"^",14)="2"  d
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",4)
	..s AStockMoveOut=OriginalFee
	..s AStockMoveIn=0
	..d AddStatListInfo
	..s StoreLoc=$p($g(^DHCEQAMoveStock(rowid)),"^",5)
	..s AStockMoveOut=0
	..s AStockMoveIn=OriginalFee
	else  if SourceType="2"  d
	.;当期退货
	.s StoreLoc=$p($g(^DHCEQAReduce(rowid)),"^",4)
	.s AStockReduce=OriginalFee
    d AddStatListInfo
	q
}

/// add by zx 2015-03-24 
/// 配件月结
ClassMethod SaveAMonthReport(MonthStr, AccessoryTypeIDs As %Library.String = "")
{
	new StartDate,EndDate,Year,Month,User
	i MonthStr="" q 0

	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s User=1
	
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	d ..FillAStatListInfo(User, Year, Month, StartDate, EndDate,AccessoryTypeIDs)
	
	
	q ..SaveAMonthReportList(User, Year, Month, StartDate, EndDate, MonthStr,AccessoryTypeIDs)
}

/// add by zx 2015-03-24
/// 保存配件月结数据
ClassMethod SaveAMonthReportList(User, Year, Month, StartDate, EndDate, MonthStr, AccessoryTypeIDs As %Library.String = "")
{
	new AccessoryType,Loc,Origin,listInfo,PreYear,PreMonth
	new Date,Time
 	new FundsType
 	
 	s Date=+$H
	s Time=$p($H,",",2)
	
	k PLIST
	s PLIST(2) = Year
	s PLIST(3) = Month
	s PLIST(5) = MonthStr
	
	s PLIST(13) = StartDate
	s PLIST(14) = EndDate
	s PLIST(15) = Date
	s PLIST(16) = Time
	s PLIST(17) = User
	Set $ZT="ETSaveAMonthReportList"
	TStart
	s SQLCODE=0
	s AccessoryType=0
	f  s AccessoryType=$o(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType)) q:((AccessoryType="")||(SQLCODE'=0))  d
	.q:$d(^DHCEQAMonthReportList(0,"YearMonth",Year,Month,AccessoryType))
	.q:##Class(web.DHCEQCommon).IdInIds(AccessoryType,AccessoryTypeIDs)=0
	.s Loc=0
	.f  s Loc=$o(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,Loc)) q:((Loc="")||(SQLCODE'=0))  d
    ..s listInfo=$g(^DHCEQTemp("AMonthReport","List",User,$J,Year,Month,AccessoryType,Loc))
    ..s PLIST(4) = Loc
    ..s PLIST(18) = AccessoryType
    ..f i=1:1:7 d
    ...s PLIST(5+i)=$p(listInfo,"^",i)
    ..&SQL(Insert Into SQLUSER.DHC_EQAMonthReportList Values :PLIST())
    ..q:SQLCODE'=0 
	
	i SQLCODE'=0
	{	TRollBack}
	else
	{	TCommit}
	q SQLCODE
ETSaveAMonthReportList
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-1^"_ErrorMsg     //返回错误消息 ;
}

/// Add By DJ 2016-02-26
/// 描述:初始化配件库存
/// 入参：IsCurMonth   0:上月  1:当月
/// 	  EquipTypeIDS 设备类组串，以","分割，为空表示全部初始化
/// 	  StoreLocDR	库房：要初始化的库房及其所管理的科室
/// w ##Class(web.DHCEQAReport).InitAccessoryReport(0)
ClassMethod InitAccessoryReport(IsCurMonth, EquipTypeIDS As %Library.String = "", StoreLocDR As %Library.String = "")
{
	//s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s User=1
	s CurMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s CurYear=+$p(CurMonthStr,"-",1)
	s CurMonth=+$p(CurMonthStr,"-",2)
	i IsCurMonth=0
	{
		i CurMonth=1
		{
			s CurMonth=12
			s CurYear=CurYear-1
		}
		else
		{
			s CurMonth=CurMonth-1
		}
		i CurMonth<10 s CurMonth="0"_CurMonth
		s CurMonthStr=CurYear_"-"_CurMonth
	}
	s ReportDate=##Class(web.DHCEQReport).GetReportDate(CurMonthStr,"","")
	K PLIST
	s PLIST(2)=CurYear
	s PLIST(3)=+CurMonth
	s PLIST(5)=CurMonthStr
	s PLIST(6)=0							//StockBegin
	s PLIST(13)=$p(ReportDate,"^",1)		//StartDate
	s PLIST(14)=$p(ReportDate,"^",2)		//EndDate
	s PLIST(15)=+$H							//MakerDate
	s PLIST(16)=$p($H,",",2)				//MakerTime
	s PLIST(17)=User						//MakerUser
	TSTART
	s SQLCODE=0
	s ASLocDR=0
	f  s ASLocDR=$o(^DHCEQAStock(0,"LocType",ASLocDR))  q:(ASLocDR="")||(SQLCODE'=0)  d
	.q:(StoreLocDR'="")&&(StoreLocDR'=ASLocDR)
	.s PLIST(4)=ASLocDR						//Loc
	.s ASType=0
	.f  s ASType=$o(^DHCEQAStock(0,"LocType",ASLocDR,ASType))  q:(ASType="")||(SQLCODE'=0)  d
	..q:(EquipTypeIDS'="")&&((","_EquipTypeIDS_",")'[(","_ASType_","))	 //Mozy003008	1268128		2020-04-09
	..s PLIST(18)=ASType					//AccessoryType
	..s ASAmount=0
	..s ASRowID=0
	..f  s ASRowID=$o(^DHCEQAStock(0,"LocType",ASLocDR,ASType,ASRowID))  q:ASRowID=""  d
	...s Amount=$p($g(^DHCEQAStock(ASRowID)),"^",9)
	...s ASAmount=ASAmount+Amount
	..s PLIST(12)=ASAmount					//StockEnd
	..&SQL(Insert Into SQLUSER.DHC_EQAMonthReportlist Values :PLIST())
	
	i SQLCODE
	{
		TROLLBACK
		q "Error:"_SQLCODE
	}
	TCOMMIT
	q "Success"
}

/// Mozy	2016-1-22
/// 科室领用配件汇总查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","ALocUsedMonthReport")
/// modify by wl 2019-12-09 WL0020 删除合计改为润乾合计
Query ALocUsedMonthReport(MonthStr As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", StartDate As %String = "", EndDate As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TJob:%String,TEquipType:%String,TFromLoc:%String,TToLoc:%String,TQuantityNum:%String,TAmount:%String,TRow:%String,index:%String") [ SqlProc ]
{
}

ClassMethod ALocUsedMonthReportExecute(ByRef qHandle As %Binary, MonthStr As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", StartDate As %String = "", EndDate As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("ALocUsedMonthReport")=MonthStr_","_FromLocDR_","_ToLocDR_","_StartDate_","_EndDate_","_EquipTypeDR
 	;Set StartDate=+StartDate
 	;if (EndDate="") s EndDate=+$H
 	Set Todate=+$H
 	i MonthStr'=""
 	{
 		s StartDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,1)
 		s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 		s EndDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,2)
 		s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	}
 	else
 	{
	 	Quit $$$OK
 	}
 	Set TRow=0
	Set index=2
	Set TJob=$job
	Kill ^DHCEQTemp("ALocUsedMonthReport",TJob)
	Kill ^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob)
	
	Set TToLocDR=0
	For  Set TToLocDR=$Order(^DHCEQAMoveStock(0,"ToLoc",TToLocDR)) Quit:TToLocDR=""  Do
	.Quit:(ToLocDR'="")&(ToLocDR'=TToLocDR)
	.Set SMRowid=0
	.For  Set SMRowid=$Order(^DHCEQAMoveStock(0,"ToLoc",TToLocDR,SMRowid)) Quit:SMRowid=""  Do
	..Set TEquipTypeDR=$p($g(^DHCEQAMoveStock(SMRowid)),"^",2)
	..Quit:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TEquipTypeDR,CurGroupID))
	..Quit:(EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
	..Set TEquipType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TEquipTypeDR)),"^",2)
	..Set TStatus=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",28)
	..Quit:(TStatus'=2)
	..Set TInAckDate=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",17)
	..Quit:(StartDate'="")&(StartDate>TInAckDate)
	..Quit:(EndDate'="")&(TInAckDate>EndDate)
	..Set TFromLocDR=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",4)
	..Quit:(FromLocDR'="")&(FromLocDR'=TFromLocDR)
	..;合计转移单数量及总金额
	..Set SumQty=0
	..Set SumAmount=0
	..Set SMLRowid=0
	..For  Set SMLRowid=$Order(^DHCEQAMoveStockList(0,"MoveStock",SMRowid,SMLRowid)) Quit:SMLRowid=""  Do
	...Set TOriginalFee=$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",10)
	...Set TQuantityNum=$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",11)
	...Set TAmount=$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",12)
	...Set SumQty=SumQty+TQuantityNum
	...Set SumAmount=SumAmount+TAmount
	..
	..Set TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLocDR)
	..Set TFromLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TFromLoc,"-")
	..Set TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLocDR)
	..Set TToLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TToLoc,"-")
	..;转移类型 s TMoveType = $CASE(TMoveType,"0":"出库","1":"库房调配","2":"退库",:"没有定义") 
	..Set TMoveType=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",14)
	..If TMoveType=1 Do
	...;科室调配参照正常出库,不处理调出科室的数据
	..If TMoveType=2 Do
	...;返库
	...Set SumQty=-1*SumQty
	...Set SumAmount=-1*SumAmount
	..
	..If $Data(^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc)) Do
 	...Set Info=$Get(^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc))
 	...Set SumQty=SumQty+$Piece(Info,"^",1)
	...Set SumAmount=SumAmount+$Piece(Info,"^",2)
	..Set ^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc)=SumQty_"^"_SumAmount
	
	;输出
	;^DHCEQTemp("ALocUsedMonthReport","ReportEx",3824,"专用设备","设备仓","CT室")
	Set (SumQty,SumAmount)=0
	Set TEquipType=""
	For  Set TEquipType=$Order(^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob,TEquipType)) Quit:TEquipType=""  Do
	.Set TFromLoc=""
	.For  Set TFromLoc=$Order(^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc)) Quit:TFromLoc=""  Do
	..Set TToLoc=""
	..For  Set TToLoc=$Order(^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc)) Quit:TToLoc=""  Do
	...Set Info=$Get(^DHCEQTemp("ALocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc))
	...Set TQuantityNum=+$Piece(Info,"^",1)
	...Set TAmount=+$Piece(Info,"^",2)
	...Set SumQty=SumQty+TQuantityNum
	...Set SumAmount=SumAmount+TAmount
	...Set TRow=TRow+1
	...Do OutputRowALocUsedMonthReport
	
	Do ResetVariablesALocUsedMonthReport
	
	Quit $$$OK
OutputRowALocUsedMonthReport
	Set TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
	
	Set Data=$lb(TJob,TEquipType,TFromLoc,TToLoc,TQuantityNum,TAmount,TRow,index)
	Set ^DHCEQTemp("ALocUsedMonthReport",TJob,index)=TEquipType_"^"_TFromLoc_"^"_TToLoc_"^"_TQuantityNum_"^"_TAmount
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesALocUsedMonthReport
	Set (TEquipType,TFromLoc,TToLoc,TQuantityNum,TAmount)=""
	Quit
}

ClassMethod ALocUsedMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ALocUsedMonthReportExecute ]
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

ClassMethod ALocUsedMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ALocUsedMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Mozy0242	2020-01-02	1161511		按配件类组统计入库、转移和退货减少业务单数
/// Mozy	2016-1-22
/// 配件入库出库汇总
/// d ##class(%ResultSet).RunQuery("web.DHCEQAReport","AInMoveSum","","","","",85,"",327,2,10248)
/// modify by wl 2019-11-07 WL008 润乾(修改入参、时间、加入过滤)
Query AInMoveSum(MonthStr As %String = "", StartDate As %String = "", EndDate As %String = "", AccessoryTypeDR As %String = "", CurGroupID As %Library.String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRow:%String,TAccessoryType:%String,InSum:%String,MoveSum:%String,InStkCounts:%String,MoveStkCounts:%String,TJob:%String,MoveLocCounts:%String,RedCounts,RedSum") [ SqlProc ]
{
}

ClassMethod AInMoveSumExecute(ByRef qHandle As %Binary, MonthStr As %String = "", StartDate As %String = "", EndDate As %String = "", AccessoryTypeDR As %String = "", CurGroupID As %Library.String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	i MonthStr'=""
 	{
 		s StartDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,1)
 		s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
		s EndDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,2)
 		s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	}
 	else
 	{
	 	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date") // add by sjh 2019-12-10 BUG00020
 		s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") // add by sjh 2019-12-10 BUG00020
	 	;Quit $$$OK
 	}
	// Mozy0242	2020-01-02	1161217
 	if (StartDate="") Set StartDate=0
 	if (EndDate="") s EndDate=+$H
 	Set TRow=0
	Set index=1
	Set TJob=$job
	Set (InSum,MoveSum,RedSum,InStkCounts,MoveStkCounts,RedCounts)=0
	Kill ^DHCEQTemp("AInMoveSum",TJob)
	Kill ^DHCEQTemp("AInMoveSumLoc",TJob)
	
	
	/// 入库	^DHCEQAInStock(0,"TypeDate",1,63936,61)
	Set TType=0
	Set TAccessoryTypeDR=0
	For  Set TAccessoryTypeDR=$Order(^DHCEQAInStock(0,"TypeDate",TAccessoryTypeDR)) Quit:TAccessoryTypeDR=""  Do
	.Quit:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))  // modify by wl 2019-11-07 WL008
	.Quit:(AccessoryTypeDR'="")&(AccessoryTypeDR'=TAccessoryTypeDR)
	.Set TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.
	.Set AuditDate=0
	.For  Set AuditDate=$Order(^DHCEQAInStock(0,"TypeDate",TAccessoryTypeDR,AuditDate)) Quit:AuditDate=""  Do
	..Quit:(StartDate>AuditDate)
	..Quit:(AuditDate>EndDate)
	..
	..Set AInStockDR=0
	..For  Set AInStockDR=$Order(^DHCEQAInStock(0,"TypeDate",TAccessoryTypeDR,AuditDate,AInStockDR)) Quit:AInStockDR=""  Do
	...Set TStatus=$Piece($Get(^DHCEQAInStock(AInStockDR)),"^",16)
	...Quit:(TStatus'=2)
	...Set TLocDR=$Piece($Get(^DHCEQAInStock(AInStockDR)),"^",3)
	...Set TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	...Set FindFlag=0
	...Set rowid=0
	...For  Set rowid=$Order(^DHCEQAInStockList(0,"AInStock",AInStockDR,rowid)) Quit:rowid=""  Do
	....Set TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
	....Set TQuantityNum=$Piece($Get(^DHCEQAInStockList(rowid)),"^",9)
	....Set TAmount=$Piece($Get(^DHCEQAInStockList(rowid)),"^",10)
	....i TAmount="" s TAmount=TPrice*TQuantityNum	// MZY0037	1400526		2020-07-06
	....;Do OutputRowAInMoveSum
	....Set tmpStr=$Get(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType))
	....If tmpStr="" Set tmpStr="^^"	//Mozy	2017-2-2
	....Set $Piece(tmpStr,"^",1)=TAmount+$Piece(tmpStr,"^",1)
	....Set ^DHCEQTemp("AInMoveSum",TJob,TAccessoryType)=tmpStr
	....Set FindFlag=1
	...If FindFlag=1 Set ^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"In")=1+$g(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"In"))	// Mozy0242	2020-01-02	1161511
	
	
	/// 退货减少	^DHCEQAReduce(0,"TypeDate",1,1,63915,1)
	Set TType=1
	Set AReduceDR=0
	For  Set AReduceDR=$Order(^DHCEQAReduce(AReduceDR)) Quit:AReduceDR=""  Do
	.Quit:$Piece($Get(^DHCEQAReduce(AReduceDR)),"^",23)'=2
	.
	.Set TAccessoryTypeDR=$Piece($Get(^DHCEQAReduce(AReduceDR)),"^",2)
	.Quit:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID)) // modify by wl 2019-11-07 WL008
	.Quit:(AccessoryTypeDR'="")&(AccessoryTypeDR'=TAccessoryTypeDR)
	.Set TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.
	.Set AuditDate=$Piece($Get(^DHCEQAReduce(AReduceDR)),"^",16)
	.Quit:(StartDate>AuditDate)
	.Quit:(AuditDate>EndDate)
	.
	.Set TLocDR=$Piece($Get(^DHCEQAReduce(AReduceDR)),"^",4)
	.Set TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.Set RedCounts=RedCounts+1
	.Set FindFlag=0
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQAReduceList(0,"Reduce",AReduceDR,rowid)) Quit:rowid=""  Do
	..Set TPrice=$Piece($Get(^DHCEQAReduceList(rowid)),"^",9)
	..Set TQuantityNum=$Piece($Get(^DHCEQAReduceList(rowid)),"^",10)
	..Set TAmount=$Piece($Get(^DHCEQAReduceList(rowid)),"^",11)
	..If TAmount="" Set TAmount=TPrice*TQuantityNum		; Mozy0244	2020-1-20	1177992
	..;Do OutputRowAInMoveSum
	..Set tmpStr=$Get(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType))
	..//Mozy	2017-2-2
	..If tmpStr="" Set tmpStr="^^"
	..Set $Piece(tmpStr,"^",3)=+$Piece(tmpStr,"^",3)+TAmount
	..Set ^DHCEQTemp("AInMoveSum",TJob,TAccessoryType)=tmpStr
	..Set FindFlag=1
	.If FindFlag=1 Set ^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"Re")=1+$g(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"Re"))	// Mozy0242	2020-01-02	1161511
	
	/// 出库返库
	Set SMRowid=0
	For  Set SMRowid=$Order(^DHCEQAMoveStock(SMRowid)) Quit:SMRowid=""  Do
	.Set TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(SMRowid)),"^",2)
	.Quit:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID)) // modify by wl 2019-11-07 WL008
	.Quit:(AccessoryTypeDR'="")&(AccessoryTypeDR'=TAccessoryTypeDR)         //modify by wl 2019-11-07 WL008 增加过滤
	.Set TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.Set TStatus=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",28)
	.Quit:(TStatus'=2)
	.Set TInAckDate=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",17)
	.Quit:(StartDate'="")&(StartDate>TInAckDate)
	.Quit:(EndDate'="")&(TInAckDate>EndDate)
	.Set TMoveType=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",14)
	.Set MoveStkCounts=MoveStkCounts+1
	.Set FindFlag=0
	.Set SMLRowid=0
	.For  Set SMLRowid=$Order(^DHCEQAMoveStockList(0,"MoveStock",SMRowid,SMLRowid)) Quit:SMLRowid=""  Do
	..Set TPrice=$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",10)
	..Set TQuantityNum=$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",11)
	..Set TAmount=+$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",12)
	..If TMoveType=1 Set TAmount=0
	..If TMoveType=2 Set TAmount=0-TAmount
	..Set tmpStr=$Get(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType))
	..If tmpStr="" Set tmpStr="^"
	..Set $Piece(tmpStr,"^",2)=+$Piece(tmpStr,"^",2)+TAmount
	..Set ^DHCEQTemp("AInMoveSum",TJob,TAccessoryType)=tmpStr
	..Set ^DHCEQTemp("AInMoveLocSum",TJob,TAccessoryType,$p($g(^DHCEQAMoveStock(SMRowid)),"^",5))=""		;领用科室
	..Set FindFlag=1
	.If FindFlag=1 Set ^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"Mo")=1+$g(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"Mo"))	// Mozy0242	2020-01-02	1161511
	
	/*..;	,出库,库房调配,退库		,0,1,2
	..If TMoveType=0 Do
	...Set TType=2
	...Set TLocDR=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",4)
	...Set TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	...Do OutputRowAInMoveSum
	..If TMoveType=2 Do
	...Set TType=3
	...Set TLocDR=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",5)
	...Set TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	...Do OutputRowAInMoveSum
	..If TMoveType=1 Do
	...Set TType=2
	...Set TLocDR=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",4)
	...Set TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	...Do OutputRowAInMoveSum
	...Set TType=3
	...Set TLocDR=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",5)
	...Set TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	...Do OutputRowAInMoveSum*/
	
	
	;输出结果
	Set TAccessoryType=""
	For  Set TAccessoryType=$Order(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType)) Quit:TAccessoryType=""  Do
	.Set InSum=$Piece($Get(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType)),"^",1)
	.Set MoveSum=$Piece($Get(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType)),"^",2)
	.Set RedSum=$Piece($Get(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType)),"^",3)	//Mozy	2017-2-2
	.Set MoveLocCounts=0
	.Set loc=""
	.For  Set loc=$Order(^DHCEQTemp("AInMoveLocSum",TJob,TAccessoryType,loc)) Quit:loc=""  Do
	..Set MoveLocCounts=MoveLocCounts+1
	.// Mozy0242	2020-01-02	1161511
	.Set InStkCounts=+$g(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"In"))
	.Set MoveStkCounts=+$g(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"Mo"))
	.Set RedCounts=+$g(^DHCEQTemp("AInMoveSum",TJob,TAccessoryType,"Re"))
	.Do OutputRowAInMoveSum
	Kill ^DHCEQTemp("AInMoveSum",TJob)
	Kill ^DHCEQTemp("AInMoveLocSum",TJob)
	;s TType = $CASE(TMoveType,"0":"入库","1":"退货减少","2":"出库","4":"退库",:"没有定义")
	
	Quit $$$OK
OutputRowAInMoveSum
	Set TRow=TRow+1
	Set InSum=##Class(web.DHCEQCommon).FormatNumber(InSum,"",2)
	Set MoveSum=##Class(web.DHCEQCommon).FormatNumber(MoveSum,"",2)
	Set RedSum=##Class(web.DHCEQCommon).FormatNumber(RedSum,"",2)
	Set Data=$lb(TRow,TAccessoryType,InSum,MoveSum,InStkCounts,MoveStkCounts,TJob,MoveLocCounts,RedCounts,RedSum)
	Set ^DHCEQTemp("AInMoveSumReport",TJob,index)=TAccessoryType_"^"_InStkCounts_"^"_InSum_"^"_MoveStkCounts_"^"_MoveSum_"^"_MoveLocCounts_"^"_RedCounts_"^"_RedSum
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod AInMoveSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AInMoveSumExecute ]
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

ClassMethod AInMoveSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AInMoveSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQAReport).GetOneAInMoveSumReport(0,3824)
ClassMethod GetOneAInMoveSumReport(PNum As %Library.String = "", job As %Library.String = "")
{
	Quit:(PNum="")||(job="") ""
	
	Quit:PNum=0 $Order(^DHCEQTemp("AInMoveSumReport",job,""),-1)
	Quit $g(^DHCEQTemp("AInMoveSumReport",job,PNum))
}

/// MZY0126	2653210		2022-06-13	输出院区
/// Mozy	2016-4-26	配件入库转移业务单汇总查询
/// Type	业务类型:	0-入库单	1-转移单	2-退货减少单
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAReport","GetInMoveDetail", 0,"","","","85","2")
/// modified by wl 2019-10-11 新增参数CurGroupID 
/// modify by wl 2019-12-31 WL0044 为空判断，加入转移单过滤
Query GetInMoveDetail(Type As %String = "", No As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", MoveType As %String) As %Query(ROWSPEC = "TRow:%String,TSourceType:%String,TSourceNo:%String,TDate:%String,TDepartment:%String,TAmount:%String,TAuditUser:%String,HOSPDESC:%String") [ SqlProc ]
{
}

ClassMethod GetInMoveDetailExecute(ByRef qHandle As %Binary, Type As %String = "", No As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String, MoveType As %String) As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	// MZY0126	2652505		2022-06-13	设置默认日期
 	i StartDate="" d
 	.s StartDate=0
 	e  d
 	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	i EndDate="" d
 	.s EndDate=+$H
 	e  d
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")

	s index=2
	s rowid=0
	s Total=0
	s TotalFee=0
	s TRow=0
	
	i StartDate>EndDate q
	i +Type=0
	{
		s TSourceType = "入库单"
		f  s rowid=$o(^DHCEQAInStock(rowid)) quit:rowid=""  d
		.d ResetVariablesGetInMoveDetail
		.s TAccessoryTypeDR=$p($g(^DHCEQAInStock(rowid)),"^",2)
		.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))
		.s TSourceNo=$p(^DHCEQAInStock(rowid),"^",6)
		.q:(No'="")&(TSourceNo'[No)
		.;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
		.s TStatusDR=$p(^DHCEQAInStock(rowid),"^",16)
		.q:TStatusDR'=2
		.s TDate=$p($g(^DHCEQAInStock(rowid)),"^",1)
		.q:(TDate>EndDate)||(TDate<StartDate)
		.s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		.s TProviderDR=$p($g(^DHCEQAInStock(rowid)),"^",8)
		.;q:(ProviderDR'="")&(TProviderDR'=ProviderDR)
		.s TDepartment=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		.s TAuditUserDR=$p(^DHCEQAInStock(rowid),"^",23)
		.i TAuditUserDR'="" s TAuditUser= ##class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
		.
		.s TAmount=0
		.s lrowid=0
		.f  s lrowid=$o(^DHCEQAInStockList(0,"AInStock",rowid,lrowid)) quit:lrowid=""  d
		..s TAmount=TAmount+$p(^DHCEQAInStockList(lrowid),"^",10)
		..i $p(^DHCEQAInStockList(lrowid),"^",10)="" s TAmount=TAmount+$p(^DHCEQAInStockList(lrowid),"^",8)*$p(^DHCEQAInStockList(lrowid),"^",9)	// MZY0037	1400526		2020-07-06
		.i TAmount'="" s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
		.s Total=Total+1
		.s TotalFee=TotalFee+TAmount
		.s HOSPDESC=##Class(web.DHCEQCommon).GetHospitalDesc(+$p($g(^DHCEQAInStock(rowid)),"^",3))	// MZY0126	2653210		2022-06-13
		.d OutputRowGetInMoveDetail
	}
	i +Type=1
	{
		//转移单过滤
		f  s rowid=$o(^DHCEQAMoveStock(rowid)) quit:rowid=""  d
		.d ResetVariablesGetInMoveDetail
		.s TMoveType=$p(^DHCEQAMoveStock(rowid),"^",14)	; ",出库,库房调配,退库"
		.i MoveType'="" q:(TMoveType'=MoveType) 
		.i TMoveType=0 s TSourceType="转移单--出库"
		.i TMoveType=1 s TSourceType="转移单--库房调配"
		.i TMoveType=2 s TSourceType="转移单--退库"  
		.s TStatusDR=$p($g(^DHCEQAMoveStock(rowid)),"^",28)
		.q:TStatusDR'=2
		.s TSourceNo=$p(^DHCEQAMoveStock(rowid),"^",1)
		.q:(No'="")&(TSourceNo'[No)
		.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(rowid)),"^",2)
		.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))
		.s TDate=$p($g(^DHCEQAMoveStock(rowid)),"^",7)
		.q:(TDate>EndDate)||(TDate<StartDate)
		.s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		.s TToLocDR=$p($g(^DHCEQAMoveStock(rowid)),"^",5)
		.s TDepartment=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
		.s TAuditUserDR=$p(^DHCEQAMoveStock(rowid),"^",16)
		.i TAuditUserDR'="" s TAuditUser= ##class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
		.s TAmount=0
		.s lrowid=0
		.f  s lrowid=$o(^DHCEQAMoveStockList(0,"MoveStock",rowid,lrowid)) quit:lrowid=""  d
		..s TAmount=TAmount+$p(^DHCEQAMoveStockList(lrowid),"^",12)
		.i TAmount'="" s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
		.s Total=Total+1
		.s TotalFee=TotalFee+TAmount
		.s HOSPDESC=##Class(web.DHCEQCommon).GetHospitalDesc($p($g(^DHCEQAMoveStock(rowid)),"^",4))	// MZY0126	2653210		2022-06-13
		.d OutputRowGetInMoveDetail
	}
	i +Type=2
	{
		s TSourceType = "退货减少单"
		f  s rowid=$o(^DHCEQAReduce(rowid)) quit:rowid=""  d
		.d ResetVariablesGetInMoveDetail
		.;s MoveType=$p(^DHCEQAReduce(rowid),"^",3)		;AR_ReduceType
		.;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
		.s TStatusDR=$p($g(^DHCEQAReduce(rowid)),"^",23)
		.q:TStatusDR'=2
		.s TSourceNo=$p(^DHCEQAReduce(rowid),"^",1)
		.q:(No'="")&(TSourceNo'[No)
		.s TAccessoryTypeDR=$p($g(^DHCEQAReduce(rowid)),"^",2)
		.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))
		.s TDate=$p($g(^DHCEQAReduce(rowid)),"^",8)
		.q:(TDate>EndDate)||(TDate<StartDate)
		.s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		.s TProviderDR=$p($g(^DHCEQAReduce(rowid)),"^",6)
		.;q:(ProviderDR'="")&(TProviderDR'=ProviderDR)
		.s TDepartment=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		.s TAuditUserDR=$p(^DHCEQAReduce(rowid),"^",15)
		.i TAuditUserDR'="" s TAuditUser= ##class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
		.s TSourceType = "退货减少单"
		.s TAmount=0
		.s lrowid=0
		.f  s lrowid=$o(^DHCEQAReduceList(0,"Reduce",rowid,lrowid)) quit:lrowid=""  d
		..s TAmount=TAmount+$p(^DHCEQAReduceList(lrowid),"^",11)
		.i TAmount'="" s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
		.s Total=Total+1
		.s TotalFee=TotalFee+TAmount
		.s HOSPDESC=##Class(web.DHCEQCommon).GetHospitalDesc($p($g(^DHCEQAReduce(rowid)),"^",4))	// MZY0126	2653210		2022-06-13
		.d OutputRowGetInMoveDetail
	}
	/*s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s index=1
		i TotalFlag="2" s index=index+1
		d ResetVariablesGetInMoveDetail
		s TRow="合计"
		s TSourceType=Total_" 张"
		s TAmount=TotalFee
		i TAmount'="" s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"1",2)
		Set Data=$lb(TRow,TSourceType,TSourceNo,TDate,TDepartment,TAmount,TAuditUser)
		Set ^CacheTemp(repid,index)=Data
	}*/
	Quit $$$OK

OutputRowGetInMoveDetail
	Set TRow=TRow+1
	Set Data=$lb(TRow,TSourceType,TSourceNo,TDate,TDepartment,TAmount,TAuditUser,HOSPDESC)		// MZY0126	2653210		2022-06-13
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetInMoveDetail
	Set (TSourceNo,TDate,TDepartment,TAmount,TAuditUser)=""
	Quit
}

ClassMethod GetInMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInMoveDetailExecute ]
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

ClassMethod GetInMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInMoveDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##Class(web.DHCEQAInStockDetailFind).TypeList("Type",155)
/// wl 2019-09-27 hisui改造
ClassMethod TypeList(name, width) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   
	w "<option value=></option>"
	//w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=0>入库单</option>"
	w "<option value=1>出库单</option>"
	w "<option value=2>退货减少单</option>"
	w "</select>",!
}

/// Mozy	2016-6-12
/// 来源情况汇总表
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAReport","AVendorReportNew","1","2016-05","")
Query AVendorReportNew(ValEquipTypes As %String = "", MonthStr As %String = "", VendorDR As %String = "") As %Query(ROWSPEC = "TRow:%String,TVendor:%String,TInStockFee:%String,TStoreMoveFee:%String,TBalance:%String,TVendor1:%String,TInStockFee1:%String,TStoreMoveFee1:%String,TBalance1:%String")
{
}

ClassMethod AVendorReportNewExecute(ByRef qHandle As %Binary, ValEquipTypes As %String = "", MonthStr As %String = "", VendorDR As %String = "") As %Status
{
 	new repid, index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	;s ^DHCEQMozy("AVendorReportNew")=ValEquipTypes_","_MonthStr_","_VendorDR
 	Quit:(MonthStr="") $$$OK
 	s index=1
 	s PNum=1
 	s (TRow,sumInStockFee)=0
 	
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("AVendorReportNew",User)
 	k ^DHCEQTemp("AVendorReportNewPrint",User)	//打印用的Global
 	
 	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
 	i ValEquipTypes="" s ValEquipTypes=##Class(web.DHCEQACommon).GetAccessorysByGroup()
 	i ValEquipTypes="" Quit $$$OK 
 	s ValEquipTypes="^"_ValEquipTypes_"^"
 	
 	//获得入库的相关信息
 	s vendorid=0
 	f  s vendorid=$o(^DHCEQAInStock(0,"Provider",vendorid)) q:vendorid=""  d
 	.s rowid=0
 	.f  s rowid=$o(^DHCEQAInStock(0,"Provider",vendorid,rowid)) q:rowid=""  d
 	..q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn($p(^DHCEQAInStock(rowid),"^",2)))	//Mozy	2017-2-2
 	..q:ValEquipTypes'[("^"_$p(^DHCEQAInStock(rowid),"^",2)_"^")
 	..q:(VendorDR'="")&&(vendorid'=VendorDR)
 	..s AISAuditDate=$p(^DHCEQAInStock(rowid),"^",24)
 	..q:(StartDate'="")&(AISAuditDate<StartDate)
 	..q:(EndDate'="")&(AISAuditDate>EndDate)
 	..s StoreLoc=$p(^DHCEQAInStock(rowid),"^",3)
 	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ("",StoreLoc)))
 	..q:(+$p(^DHCEQAInStock(rowid),"^",16)'=2)		//判断入库单是否为审核状态
 	..s ShName=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",11)
 	..s TInStockFee=0
 	..s listRowId=0
	..f  s listRowId=$o(^DHCEQAInStockList(0,"AInStock",rowid,listRowId)) q:listRowId=""  d
	...//入库金额(设备原值*数量)
	...s TInStockFee=TInStockFee+($p($g(^DHCEQAInStockList(listRowId)),"^",8)*$p($g(^DHCEQAInStockList(listRowId)),"^",9))
 	..
 	..i ($g(^DHCEQTemp("AVendorReportNew",User,ShName,vendorid))'="") s TInStockFee=TInStockFee+$g(^DHCEQTemp("AVendorReportNew",User,ShName,vendorid))
 	..s ^DHCEQTemp("AVendorReportNew",User,ShName,vendorid)=TInStockFee
 	
 	//获得退货单的相关信息	//Mozy	2017-2-2
 	; ^DHCEQAReduce(0,"TypeDate",1,1,64280,1) = "" 
 	s TAccessoryTypeDR=""
 	f  s TAccessoryTypeDR=$o(^DHCEQAReduce(0,"TypeDate",TAccessoryTypeDR)) quit:TAccessoryTypeDR=""  d
 	.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR))
 	.q:ValEquipTypes'[("^"_TAccessoryTypeDR_"^")
 	.; ARReduceType为1
 	.s ARAuditDate=""
 	.f  s ARAuditDate=$o(^DHCEQAReduce(0,"TypeDate",TAccessoryTypeDR,1,ARAuditDate)) quit:ARAuditDate=""  d
 	..q:(StartDate'="")&(ARAuditDate<StartDate)
 	..q:(EndDate'="")&(ARAuditDate>EndDate)
 	..s rowid=""
 	..f  s rowid=$o(^DHCEQAReduce(0,"TypeDate",TAccessoryTypeDR,1,ARAuditDate,rowid)) quit:rowid=""  d
 	...s TStatusDR=$p($g(^DHCEQAReduce(rowid)),"^",23)
 	...q:TStatusDR'=2
	...s vendorid=$p($g(^DHCEQAReduce(rowid)),"^",6)
	...q:(VendorDR'="")&&(vendorid'=VendorDR)
	...s ShName=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",11)
	...s StoreLoc=$p(^DHCEQAReduce(rowid),"^",4)
 	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ("",StoreLoc)))
 	...s TInStockFee=0
 	...s lrowid=0
	...f  s lrowid=$o(^DHCEQAReduceList(0,"Reduce",rowid,lrowid)) quit:lrowid=""  d
	....s TInStockFee=TInStockFee-$p(^DHCEQAReduceList(lrowid),"^",11)
	...i ($g(^DHCEQTemp("AVendorReportNew",User,ShName,vendorid))'="") s TInStockFee=TInStockFee+$g(^DHCEQTemp("AVendorReportNew",User,ShName,vendorid))
 	...s ^DHCEQTemp("AVendorReportNew",User,ShName,vendorid)=TInStockFee
 	
 	
 	//输出最终的结果
 	// ^DHCEQTemp("AVendorReportNew",1,"GZYLDZKJYXGS",1753) = 62040 
 	s Count=0
 	s ShName=""
 	f  s ShName=$o(^DHCEQTemp("AVendorReportNew",User,ShName)) q:ShName=""  d
 	.s vendorid=0
 	.f  s vendorid=$o(^DHCEQTemp("AVendorReportNew",User,ShName,vendorid)) q:vendorid=""  d
 	..s Count=Count+1
 	..s tmpFee=+$g(^DHCEQTemp("AVendorReportNew",User,ShName,vendorid))
 	..s sumInStockFee=sumInStockFee+tmpFee		;得到合计的结果
 	..i (Count/2)'=(Count\2) d
 	...s (TVendor,TInStockFee,TStoreMoveFee,TBalance)=""
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)
 	...s TInStockFee=tmpFee
 	...s TStoreMoveFee=tmpFee
 	...s TBalance=0
 	..e  d
 	...s (TVendor1,TInStockFee1,TStoreMoveFee1,TBalance1)=""
 	...s TVendor1=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)
 	...s TInStockFee1=tmpFee
 	...s TStoreMoveFee1=tmpFee
 	...s TBalance1=0
 	...d OutputRowVendorReportNew
 	
 	i (Count/2)'=(Count\2) d
 	.s (TVendor1,TInStockFee1,TStoreMoveFee1,TBalance1)=""
 	.d OutputRowVendorReportNew
 	
 	//输出最终的合计
 	s (TVendor,TInStockFee,TStoreMoveFee,TBalance,TVendor1,TInStockFee1,TStoreMoveFee1,TBalance1)=""
 	s TVendor="合计"
 	s TInStockFee=sumInStockFee
 	s TStoreMoveFee=sumInStockFee
 	s TBalance=0.00
 	d OutputRowVendorReportNew
 	k ^DHCEQTemp("AVendorReportNew",User) 
	Quit $$$OK

OutputRowVendorReportNew
	i TInStockFee'="" s TInStockFee=##Class(web.DHCEQCommon).FormatNumber(TInStockFee,"",2)
	i TStoreMoveFee'="" s TStoreMoveFee=##Class(web.DHCEQCommon).FormatNumber(TStoreMoveFee,"",2)
	i TBalance'="" s TBalance=##Class(web.DHCEQCommon).FormatNumber(TBalance,"",2)
	i TInStockFee1'="" s TInStockFee1=##Class(web.DHCEQCommon).FormatNumber(TInStockFee1,"",2)
	i TStoreMoveFee1'="" s TStoreMoveFee1=##Class(web.DHCEQCommon).FormatNumber(TStoreMoveFee1,"",2)
	i TBalance1'="" s TBalance1=##Class(web.DHCEQCommon).FormatNumber(TBalance1,"",2)
	
	s TRow=TRow+1
	s Data=$lb(TRow,TVendor,TInStockFee,TStoreMoveFee,TBalance,TVendor1,TInStockFee1,TStoreMoveFee1,TBalance1)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^DHCEQTemp("AVendorReportNewPrint",User,PNum)=TVendor_"^"_TInStockFee_"^"_TStoreMoveFee_"^"_TBalance_"^"_TVendor1_"^"_TInStockFee1_"^"_TStoreMoveFee1_"^"_TBalance1
	s PNum=PNum+1
	
	quit
}

ClassMethod AVendorReportNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AVendorReportNewExecute ]
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

ClassMethod AVendorReportNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AVendorReportNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ^DHCEQTemp("AVendorReportNewPrint",2620,1) = "广州金柏医疗科技有限公司^9840.00^9840.00^0.00^广州健成医疗器械维修有限公司^9800.00^9800.00^0.00" 
/// w ##class(web.DHCEQAReport).GetNum("AVendorReportNewPrint")
ClassMethod GetNum(node As %Library.String = "")
{
	i node="" q 0
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s gnum=$o(^DHCEQTemp(node,curuser,""),-1)
 	
  	q gnum
}

/// w ##class(web.DHCEQAReport).GetList("AVendorReportNewPrint",2)
ClassMethod GetList(node As %Library.String = "", gnum As %Library.String = "")
{
	i node="" q ""
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s str=^DHCEQTemp(node,curuser,gnum)
	
  	q str
}

/// 出库分类统计(润乾)
/// Mozy	2016-7-15
/// d ##class(%ResultSet).RunQuery("web.DHCEQAReport","AMoveByCatRpt","","2016-05-01","2016-07-31")
Query AMoveByCatRpt(MonthStr As %String = "", StartDate As %String = "", EndDate As %String = "", AccessoryTypeDR As %String = "", CatDR As %String = "", CurGroupID As %Library.String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TMoveNo:%String,TCat:%String,TAmount:%String") [ SqlProc ]
{
}

ClassMethod AMoveByCatRptExecute(ByRef qHandle As %Binary, MonthStr As %String = "", StartDate As %String = "", EndDate As %String = "", AccessoryTypeDR As %String = "", CatDR As %String = "", CurGroupID As %Library.String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	;s ^DHCEQMozy("AMoveByCatRpt")=MonthStr_","_StartDate_","_EndDate_","_AccessoryTypeDR_",,"_CurGroupID
 	i StartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	i MonthStr'=""
 	{
 		s StartDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,1)
 		s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 		s EndDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,2)
 		s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	}
 	else
 	{
	 	;Quit $$$OK
 	}
	
	
	Set SMRowid=0
	For  Set SMRowid=$Order(^DHCEQAMoveStock(SMRowid)) Quit:SMRowid=""  Do
	.Set TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(SMRowid)),"^",2)
	.Quit:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))
	.Quit:(AccessoryTypeDR'="")&(AccessoryTypeDR'=TAccessoryTypeDR)
	.Set TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.Set TStatus=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",28)
	.Quit:(TStatus'=2)
	.Set TInAckDate=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",17)
	.Quit:(StartDate'="")&(StartDate>TInAckDate)
	.Quit:(EndDate'="")&(TInAckDate>EndDate)
	.Set TMoveNo=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",1)
	.Set TMoveType=$Piece($Get(^DHCEQAMoveStock(SMRowid)),"^",14)	;s TType = $CASE(TMoveType,"0":"出    库","1":"库房调配","2":"退    库",:"没有定义")
	.If TMoveType=0 Do
	..Set flag=1
	.e  d
	..Set flag=-1
	.
	.Set TAmount=0
	.Set SMLRowid=0
	.For  Set SMLRowid=$Order(^DHCEQAMoveStockList(0,"MoveStock",SMRowid,SMLRowid)) Quit:SMLRowid=""  Do
	..Set Accessory=$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",2)
	..Set TCatDR=$p($g(^DHCEQCCode("DHCEQCAccessory",Accessory)),"^",15)
	..Set TCat=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",TCatDR)),"^",3)
	..Set TAmount=flag*$Piece($Get(^DHCEQAMoveStockList(SMLRowid)),"^",12)
	..d OutputRowAMoveByCatRpt
	
	Quit $$$OK

OutputRowAMoveByCatRpt
	i TAmount'="" s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
	
	Set Data=$lb(TMoveNo,TCat,TAmount)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
}

ClassMethod AMoveByCatRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AMoveByCatRptExecute ]
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

ClassMethod AMoveByCatRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AMoveByCatRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
