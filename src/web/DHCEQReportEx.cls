/// Modified By HZY 2011-10-27 HZY0020
/// 修改函数:VendorReport, 
/// 增加函数:GetVendorStatA, GetVendorStatB,  GetSubStringNum,  
/// -----------------------------------------------------
/// Modefied by zc 2014-10-16 ZC0014
/// 注释Modefied by zc 2014-9-28 ZC0008
/// 修改函数：GetSubStringNum
/// 先判断逗号后面是否没空
Class web.DHCEQReportEx Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modified By HZY 2011-10-27 HZY0020
/// Desc:增加参数 VendorDR .(增加'供应商'查询条件.)
/// -------------------------------------
/// 得到折旧月报的列表																						 TVendorID,        TTotalFee,        TInStockAmount,        TInStockBillAmount,        TInStockBills,        TInStockFee,        TInvoiceAmount,        TNotPaidFee,        TPaidFee,        TReturnAmount,        TReturnBillAmount,        TReturnBills,        TReturnFee,        TVendor,        TTotalAmount
Query VendorReport(ValEquipTypes, StartDate, EndDate, VendorDR, QXType As %String = "") As %Query(ROWSPEC = "TVendorID:%String,TTotalFee:%String,TInStockAmount:%String,TInStockBillAmount:%String,TInStockBills:%String,TInStockFee:%String,TInvoiceAmount:%String,TNotPaidFee:%String,TPaidFee:%String,TReturnAmount:%String,TReturnBillAmount:%String,TReturnBills:%String,TReturnFee:%String,TVendor:%String,TTotalAmount:%String,TRow:%String")
{
}

ClassMethod VendorReportExecute(ByRef qHandle As %Binary, ValEquipTypes, StartDate, EndDate, VendorDR, QXType As %String = "") As %Status
{
 	new repid, index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)	
 	s index=1
 	s PNum=1	
 	
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^TempDHCEQ("VendorReport",User)
 	k ^TempDHCEQ("VendorReportPrint",User)	//打印用的Global
 	set StartDate=+StartDate
 	if StartDate>0 s StartDate=StartDate-1
 	if (EndDate="") s EndDate=+$H
 	i ValEquipTypes="" s ValEquipTypes=##Class(web.DHCEQCommon).GetEquipTypesByGroup() //2010-06-29 党军
 	i ValEquipTypes="" Quit $$$OK //2010-06-29 党军
 	s ValEquipTypes="^"_ValEquipTypes_"^"
 	s vendorid=0	//供应商ID,初始化为0
 	s InvoiceDRList="^"  //发票RowID串
 	
 	d ResetVariablesVendorReport
 	//获得入库的相关信息
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s statcat=""
 	.f  s statcat=$o(^DHCEQInStock(0,"BillDate",StockDate,statcat)) q:statcat=""  d
 	..s rowid=0		//入库单rowID
 	..f  s rowid=$o(^DHCEQInStock(0,"BillDate",StockDate,statcat,rowid)) q:rowid=""  d
 	...q:ValEquipTypes'[("^"_$p(^DHCEQInStock(rowid),"^",20)_"^") //2010-06-29 党军
 	...s vendorid=$p(^DHCEQInStock(rowid),"^",17)
 	...q:vendorid="" //2010-06-29 党军
 	...q:(VendorDR'="")&&(vendorid'=VendorDR)	
 	...s StoreLoc=$p(^DHCEQInStock(rowid),"^",2)
 	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) //2010-10-29 DJ
 	...q:(+$p(^DHCEQInStock(rowid),"^",10)'=2)		//判断入库单是否为审核状态
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s TInStockBills=$p(^DHCEQInStock(rowid),"^",14)	//入库单号
 	...s TInStockBillAmount=1	//入库单张数
 	...d GetInstockInfo
 	
 	//获得退库的相关信息
 	d ResetVariablesVendorReport
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s statcat=""
 	.f  s statcat=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,statcat)) q:statcat=""  d
 	..s rowid=0
 	..f  s rowid=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,statcat,rowid)) q:rowid=""  d
 	...q:ValEquipTypes'[("^"_$p(^DHCEQReturn(rowid),"^",15)_"^") //2010-06-29 党军
 	...s vendorid=$p(^DHCEQReturn(rowid),"^",3)
 	...q:vendorid="" //2010-06-29 党军
 	...q:(VendorDR'="")&&(vendorid'=VendorDR)	
 	...s StoreLoc=$p(^DHCEQReturn(rowid),"^",2) //2010-10-29 DJ
 	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) //2010-10-29 DJ
 	...q:(+$p(^DHCEQReturn(rowid),"^",17)'=1)		//判断'出库类型'是否为'退货'
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s TReturnBills=$p(^DHCEQReturn(rowid),"^",1)	//退库单号
 	...s TReturnBillAmount=1		//退库单张数
 	...d GetReturnInfo
 	
 	//输出最终的结果
	s (sumInStockAmount,sumInStockFee,sumReturnAmount,sumReturnFee,sumTotalFee,sumTotalAmount,sumInStockBillAmount,sumReturnBillAmount,sumInvoiceAmount,sumPaidFee,sumNotPaidFee)=0
 	s vendorid=0
 	f  s vendorid=$o(^TempDHCEQ("VendorReport",User,vendorid)) q:vendorid=""  d
 	.d ResetVariablesVendorReport
 	.s TVendorID=vendorid
 	.s TVendor=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",1)
 	.s TInStockAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",2)
 	.s TInStockFee=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",3)
 	.s TReturnAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",4)
 	.s TReturnFee=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",5)
 	.s TTotalFee=TInStockFee-TReturnFee				//在库金额
 	.s TTotalAmount=TInStockAmount-TReturnAmount	//在库数量
 	.s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",6)
 	.s TInStockBills=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",7)
 	.s TReturnBillAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",8)
 	.s TReturnBills=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",9)
 	.s TInvoiceAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",10)
 	.s TPaidFee=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",11)
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
 	Set TRow="合计"
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
	f  s listRowId=$o(^DHCEQInStockList(0,"InStock",rowid,listRowId)) q:listRowId=""  d
	.s TInStockAmount=TInStockAmount+($p($g(^DHCEQInStockList(listRowId)),"^",8))	//入库数量
	.s TInStockFee=TInStockFee+($p($g(^DHCEQInStockList(listRowId)),"^",7)*$p($g(^DHCEQInStockList(listRowId)),"^",8))	//入库金额(设备原值*数量)
 	.s IUMRowID=0
 	.;发票使用对应表  ^DHCEQInvoiceUseMap(0,"Source",{IUM_Type},{IUM_SourceID},{IUM_RowID})
 	.f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",1,listRowId,IUMRowID)) q:IUMRowID=""  d
 	..s InvoiceDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)
 	..i InvoiceDRList'[("^"_InvoiceDR_"^") d
 	...s InvoiceDRList=InvoiceDRList_InvoiceDR_"^"
 	...s TInvoiceAmount=TInvoiceAmount+1
 	.s payrecord=""		//付款记录ID
 	.f  s payrecord=$o(^DHCEQPayRecord(0,"Source",1,listRowId,payrecord))  q:payrecord=""  d
 	..s TPaidFee=TPaidFee+$p($g(^DHCEQPayRecord(payrecord)),"^",3)	//支付金额
 	
 	i ($g(^TempDHCEQ("VendorReport",User,vendorid))'="") d
 	.s TVendor=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",1)	 //供应商                                             
 	.s TInStockAmount=TInStockAmount+($p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",2))
 	.s TInStockFee=TInStockFee+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",3)
 	.i $p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",7)'[TInStockBills  d
 	..i $p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",7)'=""  d
 	...s TInStockBills=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",7)_","_TInStockBills			//入库单
	..s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",6)+1		//入库单张数
 	.s TInvoiceAmount=TInvoiceAmount+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",10)	//发票数
 	.s TPaidFee=TPaidFee+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",11)		//已付款金额
 	
 	s ^TempDHCEQ("VendorReport",User,vendorid)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee
	d ResetVariablesVendorReport
	quit
	
GetReturnInfo
	s listRowId=0
	f  s listRowId=$o(^DHCEQReturnList(0,"Return",rowid,listRowId)) q:listRowId=""  d
	.s TReturnAmount=TReturnAmount+$p($g(^DHCEQReturnList(listRowId)),"^",5)	//退库数量
	.s TReturnFee=TReturnFee+($p($g(^DHCEQReturnList(listRowId)),"^",5)*$p($g(^DHCEQReturnList(listRowId)),"^",6))		//退库金额(退库数量*金额)
	
	i ($g(^TempDHCEQ("VendorReport",User,vendorid))'="") d
	.s TVendor=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",1)
	.s TInStockAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",2)
 	.s TInStockFee=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",3)
 	.s TReturnAmount=TReturnAmount+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",4)
 	.s TReturnFee=TReturnFee+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",5)
 	.s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",6)
 	.s TInStockBills=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",7)
 	.i $p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",8)'[TReturnBills  d
 	..s TReturnBillAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",8)+1		//退货单数量
 	..i $p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",9)'=""  d
 	...s TReturnBills=$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",9)_","_TReturnBills	//退货单号
 	.s TInvoiceAmount=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",10)		//发票数
 	.s TPaidFee=+$p($g(^TempDHCEQ("VendorReport",User,vendorid)),"^",11)
	
	s ^TempDHCEQ("VendorReport",User,vendorid)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee
	d ResetVariablesVendorReport
	quit
	
ResetVariablesVendorReport
	s InvoiceDRList="^"
	s (TVendorID,TVendor,TReturnBills,TInStockBills,TRow)=""
	s (TTotalFee,TInStockAmount,TInStockBillAmount,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnFee,TTotalAmount)=0	
	quit
OutputRowVendorReport
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	s TInStockFee=##Class(web.DHCEQCommon).FormatNumber(TInStockFee,"",2)
	s TReturnFee=##Class(web.DHCEQCommon).FormatNumber(TReturnFee,"",2)
	s TPaidFee=##Class(web.DHCEQCommon).FormatNumber(TPaidFee,"",2)
	s TNotPaidFee=##Class(web.DHCEQCommon).FormatNumber(TNotPaidFee,"",2)
	/// 20150918  Mozy0166
	If TRow="" Set TRow=PNum
	Set TInStockBills=##Class(web.DHCEQCommon).NoToGroupNo(TInStockBills)
	Set TReturnBills=##Class(web.DHCEQCommon).NoToGroupNo(TReturnBills)
	s Data=$lb(TVendorID,TTotalFee,TInStockAmount,TInStockBillAmount,TInStockBills,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnBills,TReturnFee,TVendor,TTotalAmount,TRow)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^TempDHCEQ("VendorReportPrint",User,PNum)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TTotalAmount_"^"_TTotalFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TNotPaidFee_"^"_TRow
	s PNum=PNum+1
	quit
}

ClassMethod VendorReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VendorReportExecute ]
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

ClassMethod VendorReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VendorReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetVendorReport(num)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;s vendorid=$o(^TempDHCEQ("VendorReport",User,prevendorid))
	;if vendorid="" q ""
	;s vendordesc=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",2)
	;s vendordesc=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)
	q $g(^TempDHCEQ("VendorReportPrint",User,num))
}

/// 中国医大折旧报表
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","GetDepreReport","",+$H)
Query GetDepreReport(BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", EquipTypeIDS As %Library.String = "") As %Query(ROWSPEC = "TCode:%String,TDesc:%String,TDepreFee:%String,TOriginalFee:%String,TJob:%String")
{
}

ClassMethod GetDepreReportExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", EquipTypeIDS As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i EquipTypeIDS'="" s EquipTypeIDS=","_EquipTypeIDS_","
	;s ^TempDHCEQ("jdl")=BeginDate_"^"_EndDate_"^"_UseLocDR_"^"_IsMainFlag
	if ((BeginDate="")&&(EndDate="")) Quit $$$OK	
	s job=$j
	k ^TempDHCEQ("MonthDepreReport",job)
	k ^TempDHCEQ("MonthDepreReport","Out",job)
	s start=0
	i BeginDate'="" s start=BeginDate
	s end=+$H
	i EndDate'="" s end=EndDate
	s locdr=0
	f  s locdr=$o(^DHCEQMonthDepre(0,"Loc",locdr))  quit:locdr=""  d
	.q:((UseLocDR'="")&&(UseLocDR'=locdr))
	.s auditdate=start
	.f  s auditdate=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate))  quit:((auditdate="")||(auditdate>end))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate,rowid))  quit:((rowid=""))  d
	..s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	..q:MDStatus="3"
	...s depredata=$g(^DHCEQMonthDepre(rowid))
	...q:($p(depredata,"^",3)'=IsMainFlag)
	...s equipid=$p(depredata,"^",1)
	...s equiptype=$p($g(^DHCEQEquip(equipid)),"^",63)
	...q:(EquipTypeIDS'="")&&(EquipTypeIDS'[(","_equiptype_",")) 
	...
	...s deprefee=+$p(depredata,"^",14)+$p($g(^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr)),"^",1)
	...s originalfee=+$p(depredata,"^",5)+$p($g(^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr)),"^",2)
	...s ^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr)=deprefee_"^"_originalfee
	
	s locdr=0
	f  s locdr=$o(^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr))  quit:locdr=""  d
	.s ContrastID=$o(^DHCEQCCode("DHCEQContrastInfo",0,"SYSID",locdr,0))
	.i ContrastID=""  d
	..s code="00"
	.e  d
	..s code=$p(^DHCEQCCode("DHCEQContrastInfo",ContrastID),"^",6)
	.q:$d(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Total"))
	.s deprefee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr)),"^",1)
	.s originalfee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr)),"^",2)
	.
	.s totaldeprefee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Amount")),"^",1)+$p($g(^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr)),"^",1)
	.s totaloriginalfee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Amount")),"^",2)+$p($g(^TempDHCEQ("MonthDepreReport",job,"LocDR",locdr)),"^",2)
	.
	.s level=$l(code)\2
	.s ^TempDHCEQ("MonthDepreReport",job,"Code",code,"Amount")=totaldeprefee_"^"_totaloriginalfee_"^"_level
	.
	.
	.f i=level-1:-1:1  d
	..s parcode=$e(code,1,i*2)
	..s node="Total"
	..i '$d(^TempDHCEQ("MonthDepreReport",job,"Code",parcode,"Total"))  s node="Amount"
	..s totaldeprefee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",parcode,node)),"^",1)+deprefee
	..s totaloriginalfee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",parcode,node)),"^",2)+originalfee
	..
	..s ^TempDHCEQ("MonthDepreReport",job,"Code",parcode,"Total")=totaldeprefee_"^"_totaloriginalfee_"^"_i
	..

	s num=1
	s code=""
	f  s code=$o(^TempDHCEQ("MonthDepreReport",job,"Code",code))  quit:code=""  d
	.s ContrastID=$o(^DHCEQCCode("DHCEQContrastInfo",0,"ExCode",2,code,0))
	.s level=$l(code)\2
	.s desc=""
	.//b //ContrastID
	.i ContrastID'=""  d
	..s desc=$p(^DHCEQCCode("DHCEQContrastInfo",ContrastID),"^",7)
	..i desc=""  d
	...s locdr=$p(^DHCEQCCode("DHCEQContrastInfo",ContrastID),"^",2)
	...s desc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",locdr)
	.i desc=""  d
	..i code="00"  d
	...s desc="未添加科室!"
	..e  d
	...s desc="该层未定义"
	.
	.f i=2:1:level  d
	..s desc="----"_desc
	.
	.
	.i $d(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Total"))  d
	..s deprefee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Total")),"^",1)
	..s originalfee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Total")),"^",2)
	..
	..s deprefee=##Class(web.DHCEQCommon).FormatNumber(deprefee,"",2)
	..s originalfee=##Class(web.DHCEQCommon).FormatNumber(originalfee,"",2)
	..
	..d OutputRowGetDepreReport
	..
	..s ^TempDHCEQ("MonthDepreReport","Out",job,0,num)=code_"^"_desc_"^"_deprefee_"^"_originalfee
	..s num=num+1
	.
	.i $d(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Amount"))  d
	..s deprefee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Amount")),"^",1)
	..s originalfee=+$p($g(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Amount")),"^",2)
	..
	..s deprefee=##Class(web.DHCEQCommon).FormatNumber(deprefee,"",2)
	..s originalfee=##Class(web.DHCEQCommon).FormatNumber(originalfee,"",2)
	..
	..i $d(^TempDHCEQ("MonthDepreReport",job,"Code",code,"Total")) s desc="  "_desc 
	..d OutputRowGetDepreReport
	..
	..s ^TempDHCEQ("MonthDepreReport","Out",job,0,num)=code_"^"_desc_"^"_deprefee_"^"_originalfee
	..s num=num+1
	
	
	k ^TempDHCEQ("MonthDepreReport",job)
	Quit $$$OK
	
OutputRowGetDepreReport
	s Data=$lb(code,desc,deprefee,originalfee,job)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDepreReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepreReportExecute ]
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

ClassMethod GetDepreReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepreReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","AssetDeal","","","","","","","","","2017-06-26","","","","","","364","85")
/// 资产处理情况表
/// Modify by wy 2017-6-27 改为由润乾展现模式
Query AssetDeal(UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TEquipType:%String,TStatCat:%String,TEquiCat:%String,TDealType:%String,TEqNo:%String,TEquipName:%String,TModel:%String,TStartDate:%String,TQuantity:%String,TOriginalFee:%String,TDepreTotal:%String,TDealFee:%String,TRemainIncome:%String,TUseMonths:%String,TRemainMonths:%String,TDealDate:%String,TDealReason:%String,TJob:%String") [ SqlProc ]
{
}

ClassMethod AssetDealExecute(ByRef qHandle As %Binary, UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s TempNode="ReportEx.AssetDeal"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)               //临时Global
	s index=1
	s TJob=$j
	k ^TempDHCEQ("Report","AssetDeal",TJob)
	s BeginDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	i BeginDate="" s BeginDate=0
 	
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i EndDate="" s EndDate=+$H
	;获取报废设备
	s TDealDate=BeginDate-1	
	s TDealTypeDesc="报废"
	f  s TDealDate=$o(^DHCEQDisuseRequest(0,"AuditDateStatus",TDealDate))  quit:((TDealDate="")||(TDealDate>EndDate))  d
	.s RequestID=0
	.f  s RequestID=$o(^DHCEQDisuseRequest(0,"AuditDateStatus",TDealDate,2,RequestID))  quit:((RequestID=""))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RequestID,rowid))  quit:((rowid=""))  d
	...s EquipID=$p(^DHCEQDisuseRequestList(rowid),"^",2)
	...s TEquipType=$p($g(^DHCEQEquip(EquipID)),"^", 63) 
	...q:(0'=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID))   //Modefied by zc0070类组权限过滤
	...q:((EquipTypeDR'="")&&(EquipTypeDR'=TEquipType))
	...s TDealReason=$p(^DHCEQDisuseRequest(RequestID),"^",7)
	...d BuildTempDataAssetDeal
	
	;获取退货及减少设备	
	s TEquipType=0
	f  s TEquipType=$o(^DHCEQReturn(0,"TypeDate",TEquipType)) q:TEquipType=""  d
	.q:(0'=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID))   //Modefied by zc0070类组权限过滤
	.q:((EquipTypeDR'="")&&(EquipTypeDR'=TEquipType))
	.s TDealType=0
	.f  s TDealType=$o(^DHCEQReturn(0,"TypeDate",TEquipType,TDealType)) q:TDealType=""  d
	..s TDealTypeDesc=$p($g(^DHCEQCCode("DHCEQCOutType",TDealType)),"^",2)
	..s TDealDate=BeginDate-1
	..f  s TDealDate=$o(^DHCEQReturn(0,"TypeDate",TEquipType,TDealType,TDealDate)) q:((TDealDate="")||(TDealDate>EndDate))  d
	...s RequestID=0
	...f  s RequestID=$o(^DHCEQReturn(0,"TypeDate",TEquipType,TDealType,TDealDate,RequestID)) q:(RequestID="")  d
	....;退货明细
	....s ListID=0
	....f  s ListID=$o(^DHCEQReturnList(0,"Return",RequestID,ListID)) q:(ListID="")  d
	.....i TDealType=1 s ChangeType=2     //add by wy 2019-1-16 806891
	.....i TDealType>=3 s ChangeType=3
	.....s rowid=0
	.....f  s rowid=$o(^DHCEQChangeStock(0,"Source",ChangeType,ListID,rowid)) q:(rowid="")  d
	......s EquipID=$p(^DHCEQChangeStock(rowid),"^",1)
	......s TDealReason=""	//modify by wl 2020-02-19 WL0053
	......s RLReturnReasonDR=$p(^DHCEQReturnList(ListID),"^",8)  
	......i RLReturnReasonDR'=""  s TDealReason=$p($g(^DHCEQCCode("DHCEQCReturnReason",RLReturnReasonDR)),"^",2)
	......d BuildTempDataAssetDeal
	
	;排序处理数据
	;^TempDHCEQ("Report","AssetDeal",TJob,TDealType,TEquiCat,EquipID)=TDealDate_"^"_TDealReason
	s SumQty=0
	s SumAmount=0
	s SumDealFee=0
	s SumRemainFee=0
	s SumDepreFee=0
	
	s TEquiCatDR=""
	f  s TEquiCatDR=$o(^TempDHCEQ("Report","AssetDeal",TJob,TEquiCatDR))  quit:(TEquiCatDR="")  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	.s SumQtyCat=0
	.s SumAmountCat=0
	.s SumDealFeeCat=0
	.s SumRemainFeeCat=0
	.s SumDepreFeeCat=0
	.s TDealType=""
	.f  s TDealType=$o(^TempDHCEQ("Report","AssetDeal",TJob,TEquiCatDR,TDealType))  quit:(TDealType="")  d
	..s SumQtyDealType=0
	..s SumAmountDealType=0
	..s SumDealFeeDealType=0
	..s SumRemainFeeDealType=0
	..s SumDepreFeeDealType=0
	..s EquipID=0
	..f  s EquipID=$o(^TempDHCEQ("Report","AssetDeal",TJob,TEquiCatDR,TDealType,EquipID))  quit:(EquipID="")  d
	...d ResetVariablesAssetDeal
	...d GetEquipInfo
	...d OutputRowAssetDeal
	
	k ^TempDHCEQ("Report","AssetDeal",TJob)
	Quit $$$OK
BuildTempDataAssetDeal	
	s TEquiCat=$p($g(^DHCEQEquip(EquipID)),"^",4)
	q:TEquiCat=""
	s ^TempDHCEQ("Report","AssetDeal",TJob,TEquiCat,TDealTypeDesc,EquipID)=TDealDate_"^"_TDealReason
	quit
OutputRowAssetDeal
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	s TDealFee=##Class(web.DHCEQCommon).FormatNumber(TDealFee,"",2)
	s TRemainIncome=##Class(web.DHCEQCommon).FormatNumber(TRemainIncome,"",2)
	s Data=$lb(TEquipType,TStatCat,TEquiCat,TDealType,TEqNo,TEquipName,TModel,TStartDate,TQuantity,TOriginalFee,TDepreTotal,TDealFee,TRemainIncome,TUseMonths,TRemainMonths,TDealDate,TDealReason,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
GetEquipInfo
	s TEquipType=$p(^DHCEQEquip(EquipID),"^",63)
	i TEquipType '=""  s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipType)),"^",2)	
	s TStatCat=$p(^DHCEQEquip(EquipID),"^",75)
	i TStatCat'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCat)),"^",2)
	;s TEquiCat=$p(^DHCEQEquip(EquipID),"^",)
	;s TDealType=$p(^DHCEQEquip(EquipID),"^",)
	s TEqNo=$p(^DHCEQEquip(EquipID),"^",71)
	s TEquipName=$p(^DHCEQEquip(EquipID),"^",1)
	s TModel=$p(^DHCEQEquip(EquipID),"^",3)
	i TModel '="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	s TStartDate=$p($g(^DHCEQEquip(EquipID)),"^",44)
	//i TStartDate'="" s TStartDate=$zd(TStartDate,3)
	// 日期格式统一调整 mwz 2017-3-2
	s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TQuantity=1
	s TOriginalFee=$p(^DHCEQEquip(EquipID),"^",27)
	s TDepreTotal=$p(^DHCEQEquip(EquipID),"^",35)
	s TDealFee=0
	s TRemainIncome=0
	s TMonths=..GetDepreInfo(EquipID)
	s TUseMonths=$p(TMonths,"^",1)_"期"
	s TRemainMonths=$p(TMonths,"^",3)_"期"
		
	s TDealDate=^TempDHCEQ("Report","AssetDeal",TJob,TEquiCatDR,TDealType,EquipID)
	s TDealReason=$p(TDealDate,"^",2)
	s TDealDate=$p(TDealDate,"^",1)
	//s TDealDate=$ZD(TDealDate,3)
	// 日期格式统一调整 mwz 2017-3-2
	s TDealDate=##class(web.DHCEQCommon).TransValueToPage(TDealDate,"date")	
	quit
ResetVariablesAssetDeal
	s (TEquipType,TStatCat,TEqNo,TEquipName,TModel,TStartDate,TQuantity,TOriginalFee,TDepreTotal,TDealFee,TRemainIncome,TUseMonths,TRemainMonths,TDealDate,TDealReason)=""
	quit
}

ClassMethod AssetDealFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetDealExecute ]
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

ClassMethod AssetDealClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetDealExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取折旧信息
/// 入参：EquipID设备id
/// 		 DepreMonth:折旧月份 格式"yyyy-mm"	
/// 返回：使用寿命^折旧寿命^剩余寿命^当月折旧额^当年折旧额
ClassMethod GetDepreInfo(EquipID, CurMonth As %String = "", DepreTypeDR As %String = "1")
{
	n CurDate,Year,DepreMonth,rowid
	n Months,DepreMonths,RemainMonths,DepreFee,DepreYearFee,DepreRate
	if EquipID="" q ""
	s Months=$p($g(^DHCEQEquip(EquipID)),"^",31)*12
	s DepreRate=""
	i Months>0
	{
		s DepreRate=100/Months
		s DepreRate=##Class(web.DHCEQCommon).FormatNumber(DepreRate,"",2)
	}
	s InStockDate=##Class(web.DHCEQEquip).GetInStockDate(EquipID,1)	
	
	i CurMonth=""
	{
		s CurDate=+$H
		s CurMonth=$zd(CurDate,3)
		s CurMonth=$p(CurMonth,"-",1,2)
	}
	else
	{
		s CurDate=CurMonth_"-01"
		s CurDate=$zdh(CurDate,3)
	}
	s Year=$p(CurMonth,"-",1)
	
	s DepreMonths=""
	i InStockDate'="" s DepreMonths=##Class(web.DHCEQCommon).DateDiff("m",$Zd(InStockDate),$Zd(CurDate))
	s RemainMonths=0
	if Months>DepreMonths s RemainMonths=Months-DepreMonths	
	s DepreYearFee=0
	s DepreFee=0
	s DepreMonth=Year_"-"
	f  s DepreMonth=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipID,DepreMonth))  quit:((DepreMonth="")||(DepreMonth>CurMonth))  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMonthDepre(0,"EquipMonth",EquipID,DepreMonth,rowid))  quit:(rowid="")  d
	..s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	..q:MDStatus="3"
	..;过滤非本年的
	..q:DepreMonth'[Year_"-"
	..q:DepreTypeDR'=$p(^DHCEQMonthDepre(rowid),"^",36)
	..i DepreMonth=CurMonth s DepreFee=$p(^DHCEQMonthDepre(rowid),"^",14)
	..;年度折旧总额
	..s DepreYearFee=DepreYearFee+$p(^DHCEQMonthDepre(rowid),"^",14)
	
	q Months_"^"_DepreMonths_"^"_RemainMonths_"^"_DepreFee_"^"_DepreYearFee_"^"_DepreRate
}

/// 	DateDiff("m","7/15/2010","7/23/2009")
ClassMethod DateDiff(interval, date1, date2) As %String [ Language = basic ]
{
	return DateDiff(interval, date1, date2)
}

/// 资产构成分析表(润乾)
/// add by mwz 2017-5-5
Query AssetComposite(QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "") As %Query(ROWSPEC = "TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEqNo:%String,TEquipName:%String,TModel:%String,TStartDate:%String,TQuantity:%String,TOriginalFee:%String,TDepreTotal:%String,TNetFee:%String") [ SqlProc ]
{
}

ClassMethod AssetCompositeExecute(ByRef qHandle As %Binary, QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)	
	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H
	s Date=+$H
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(EquipID))  quit:(EquipID="")  d
	.d ResetVariablesAssetComposite
	.s StockStatus=$p(^DHCEQEquip(EquipID),"^",60)
	.q:((StockStatus="3")||(StockStatus="0"))
	.s Status=$p(^DHCEQEquip(EquipID),"^",38)
	.q:(Status="3")
	.s InvalidFlag=$p(^DHCEQEquip(EquipID),"^",59)
	.q:InvalidFlag="Y"
	.s TOriginalFee=$p(^DHCEQEquip(EquipID),"^",27)
	.q:(MinValue'="")&&(TOriginalFee<MinValue)
	.q:(MaxValue'="")&&(TOriginalFee>MaxValue)
	.s UseLoc=$p($g(^DHCEQEquip(EquipID)),"^", 67) //使用科室
	.q:(UseLocDR'="")&&(UseLocDR'=UseLoc)
	.s TEquipType=$p($g(^DHCEQEquip(EquipID)),"^", 63) 	//设备类组
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipType)
 	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID))		//CZF 2021-05-08
	.i TEquipType '=""  s TEquipType = ##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipType)
	.s TStatCat=$p(^DHCEQEquip(EquipID),"^",75)
	.i TStatCat'="" s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCat)
	.s TEquipCat=$p($g(^DHCEQEquip(EquipID)),"^",4)     ///设备分类
	.q:(EquipCatDR'="")&&(EquipCatDR'=TEquipCat)
	.i TEquipCat'="" s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCat)
	.s TEqNo=$p(^DHCEQEquip(EquipID),"^",71)
	.s TEquipName=$p(^DHCEQEquip(EquipID),"^",1)
	.s TModel=$p(^DHCEQEquip(EquipID),"^",3)
	.i TModel '="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.s TStartDate=$p($g(^DHCEQEquip(EquipID)),"^",44)
	.s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	.s TQuantity=1
	.s TDepreTotal=$p(^DHCEQEquip(EquipID),"^",35)
	.s TNetFee=$p(^DHCEQEquip(EquipID),"^",28)
	.d OutputRowAssetComposite
    QUIT $$$OK
OutputRowAssetComposite
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)
	Set Data=$lb(TEquipType,TStatCat,TEquipCat,TEqNo,TEquipName,TModel,TStartDate,TQuantity,TOriginalFee,TDepreTotal,TNetFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetVariablesAssetComposite
	s (TEquipType,TStatCat,TEquipCat,TEqNo,TEquipName,TModel,TStartDate,TQuantity,TOriginalFee,TDepreTotal,TNetFee)=""
	quit
}

ClassMethod AssetCompositeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetCompositeExecute ]
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

ClassMethod AssetCompositeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetCompositeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产数量统计表
Query AssetCount(UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "") As %Query(ROWSPEC = "TEquipType:%String,TStatCat:%String,TEquiCat:%String,TQuantity:%String,TOriginalFee:%String,TJob:%String")
{
}

ClassMethod AssetCountExecute(ByRef qHandle As %Binary, UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", Type As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s TempNode="ReportEx.AssetCount"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)               //临时Global
	s index=1
	
	s TJob=$j
	k ^TempDHCEQ("Report","AssetCount",TJob)
	s Date=+$H
	
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:(rowid="")  d
	.///出库状态、无效标志
	.s StockStatus=$p(^DHCEQEquip(rowid),"^",60)
	.q:((StockStatus="3")||(StockStatus="0"))
	.;过滤掉报废的
	.s Status=$p(^DHCEQEquip(rowid),"^",38)
	.q:(Status="3")
	.;过滤掉无效的
	.s InvalidFlag=$p(^DHCEQEquip(rowid),"^",59)
	.q:InvalidFlag="Y"
	.s EquipTypeDR=$p(^DHCEQEquip(rowid),"^",63)  //类组 Add By HZY 2013-12-10 HZY0040
	.q:(0'=##class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR))  //过滤类组 Add By HZY 2013-12-10 HZY0040	
	.s TEquiCat=$p(^DHCEQEquip(rowid),"^",4)
	.s TQuantity=1+$p($g(^TempDHCEQ("Report","AssetCount",TJob,TEquiCat)),"^",1)
	.s TOriginalFee=$p(^DHCEQEquip(rowid),"^",27)+$p($g(^TempDHCEQ("Report","AssetCount",TJob,TEquiCat)),"^",2)
	.s ^TempDHCEQ("Report","AssetCount",TJob,TEquiCat)=TQuantity_"^"_TOriginalFee
	
	;排序处理数据
	;^TempDHCEQ("Report","AssetCount",TJob,TDealType,TEquiCat,EquipID)=TDealDate_"^"_TDealReason
	s (SumQty,SumAmount)=0
	
	s TEquiCatDR=""
	f  s TEquiCatDR=$o(^TempDHCEQ("Report","AssetCount",TJob,TEquiCatDR))  quit:(TEquiCatDR="")  d
	.d ResetVariablesAssetCount
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	.s TQuantity=$p(^TempDHCEQ("Report","AssetCount",TJob,TEquiCatDR),"^",1)
	.s TOriginalFee=$p(^TempDHCEQ("Report","AssetCount",TJob,TEquiCatDR),"^",2)
	.s SumQty=SumQty+TQuantity
	.s SumAmount=SumAmount+TOriginalFee
	.d OutputRowAssetCount	
	
	i SumQty>0  d
	.d ResetVariablesAssetCount
	.s TEquiCat="合计"
	.s TQuantity=SumQty
	.s TOriginalFee=SumAmount
	.d OutputRowAssetCount
	
	k ^TempDHCEQ("Report","AssetCount",TJob)
	Quit $$$OK
OutputRowAssetCount
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s Data=$lb(TEquipType,TStatCat,TEquiCat,TQuantity,TOriginalFee,TJob)
	
	s ^TempDHCEQ(TempNode,Date,TJob,index)=TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TQuantity_"^"_TOriginalFee_"^"_TJob
	
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAssetCount
	s (TEquipType,TStatCat,TQuantity,TOriginalFee)=""
	quit
}

ClassMethod AssetCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AssetCountExecute ]
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

ClassMethod AssetCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AssetCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产折旧明细表
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","DepreDetail")
Query DepreDetail(UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", DepreTypeDR As %String = "1") As %Query(ROWSPEC = "TEquipType:%String,TStatCat:%String,TEquiCat:%String,TEqNo:%String,TEquipName:%String,TUseMonths:%String,TUsedMonths:%String,TDepreRate:%String,TQuantity:%String,TOriginalFee:%String,TDepreFee:%String,TDepreYearFee:%String,TDepreTotal:%String,TNetFee:%String,TJob:%String,TRow:%String")
{
}

ClassMethod DepreDetailExecute(ByRef qHandle As %Binary, UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", DepreTypeDR As %String = "1") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i DepreTypeDR="" s DepreTypeDR="1"		//Add By DJ 2015-07-14 DJ0147
 	s TempNode="ReportEx.DepreDetail"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)               //临时Global
	s index=1
	s TRow=0
	s TJob=$j
	k ^TempDHCEQ("Report","DepreDetail",TJob)
	s Date=+$H
	
	s (SumQty,SumAmount,SumDepreFee,SumDepreYearFee,SumDepreTotal,SumNetFee)=0
	
	;Add by jdl 2011-4-15 JDL0078
	;改为从快照获取数据
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	
	s rowid=0
	i SnapID=""  d
	.f  s rowid=$o(^DHCEQEquip(rowid))  quit:(rowid="")  d
	..s gblData=^DHCEQEquip(rowid)
	..d AddDepreDetail
	e  d
	.f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  quit:(rowid="")  d
	..s gblData=^DHCEQSnapShot(SnapID,"Equip",rowid)
	..d AddDepreDetail
	
	i SumQty>0  d
	.d ResetVariablesDepreDetail
	.s TRow="合计"
	.s TQuantity=SumQty
	.s TOriginalFee=SumAmount
	.s TDepreFee=SumDepreFee
	.s TDepreYearFee=SumDepreYearFee
	.s TDepreTotal=SumDepreTotal
	.s TNetFee=SumNetFee
	.d OutputRowDepreDetail
	
	k ^TempDHCEQ("Report","DepreDetail",TJob)
	Quit $$$OK
AddDepreDetail
	///出库状态、无效标志
	s StockStatus=$p(gblData,"^",60)
	;尚未入库的不计入
	q:(StockStatus="0")
	
	s CounterFlag="1"
	;其他退货、报废、无效的，不计入原值、数量，只计入折旧、累计折旧相关数据
	i (StockStatus="3") s CounterFlag="0"
	;过滤掉报废的
	s Status=$p(gblData,"^",38)
	i (Status>"2") s CounterFlag="0"
	q:CounterFlag="0"		;过滤掉无效的
	s InvalidFlag=$p(gblData,"^",59)
	i (InvalidFlag="Y") s CounterFlag="0"
	q:((UseLocDR'="")&&(UseLocDR'=$p(gblData,"^",67)))  ;库房
	q:(EquipTypeDR="")&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn($p(gblData,"^",63)))	;Mozy0070	2011-12-03
	d ResetVariablesDepreDetail
	s EquipID=rowid
	d GetInfoDepreDetail
	s TRow=TRow+1
	d OutputRowDepreDetail
	quit
OutputRowDepreDetail
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	s TDepreYearFee=##Class(web.DHCEQCommon).FormatNumber(TDepreYearFee,"",2)
	s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)
	
	s Data=$lb(TEquipType,TStatCat,TEquiCat,TEqNo,TEquipName,TUseMonths,TUsedMonths,TDepreRate,TQuantity,TOriginalFee,TDepreFee,TDepreYearFee,TDepreTotal,TNetFee,TJob,TRow)
	s ^TempDHCEQ(TempNode,Date,TJob,index)=TEquipType_"^"_TStatCat_"^"_TEquiCat_"^"_TEqNo_"^"_TEquipName_"^"_TUseMonths_"^"_TUsedMonths_"^"_TDepreRate_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
GetInfoDepreDetail
	s TEquipType=$p(gblData,"^",63)
	i TEquipType '=""  s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipType)),"^",2)	
	s TStatCat=$p(gblData,"^",75)
	i TStatCat'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCat)),"^",2)
	;s TEquiCat=$p(gblData,"^",)
	;s TDealType=$p(gblData,"^",)
	s TEqNo=$p(gblData,"^",71)
	s TEquipName=$p(gblData,"^",1)
	s TDepreInfo=..GetDepreInfo(EquipID,MonthStr,DepreTypeDR)
	s TUseMonths=$p(TDepreInfo,"^",1)_"期"
	s TUsedMonths=$p(TDepreInfo,"^",2)_"期"
	
	s TDepreFee=$p(TDepreInfo,"^",4)
	s TDepreYearFee=$p(TDepreInfo,"^",5)
	s TDepreRate=$p(TDepreInfo,"^",6)
	s TQuantity=CounterFlag
	s TOriginalFee=$p(gblData,"^",27)*CounterFlag
	s TDepreTotal=$p(gblData,"^",35)
	s TNetFee=$p(gblData,"^",28)*CounterFlag
	
	s SumQty=SumQty+TQuantity
	s SumAmount=SumAmount+TOriginalFee	
	s SumDepreFee=SumDepreFee+TDepreFee
	s SumDepreYearFee=SumDepreYearFee+TDepreYearFee
	s SumDepreTotal=SumDepreTotal+TDepreTotal
	s SumNetFee=SumNetFee+TNetFee
	
	quit
ResetVariablesDepreDetail
	s (TEquipType,TStatCat,TEquiCat,TEqNo,TEquipName,TUseMonths,TUsedMonths,TDepreRate,TQuantity,TOriginalFee,TDepreFee,TDepreYearFee,TDepreTotal,TNetFee)=""
	quit
}

ClassMethod DepreDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepreDetailExecute ]
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

ClassMethod DepreDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepreDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产折旧分类表
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","DepreCat")
Query DepreCat(UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", DepreTypeDR As %String = "1") As %Query(ROWSPEC = "TEquipType:%String,TEquiCat:%String,TQuantity:%String,TOriginalFee:%String,TDepreFee:%String,TDepreYearFee:%String,TDepreTotal:%String,TNetFee:%String,TJob:%String")
{
}

ClassMethod DepreCatExecute(ByRef qHandle As %Binary, UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", DepreTypeDR As %String = "1") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i DepreTypeDR="" s DepreTypeDR="1"		//Add By DJ 2015-07-14 DJ0147
 	s TempNode="ReportEx.DepreCat"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)               //临时Global
	s index=1
	
	s TJob=$j
	k ^TempDHCEQ("Report","DepreCat",TJob)
	s Date=+$H
	
	s (SumQty,SumAmount,SumDepreFee,SumDepreYearFee,SumDepreTotal,SumNetFee)=0
	
	;Add by jdl 2011-4-15 JDL0078
	;改为从快照获取数据
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	
	s rowid=0
	i SnapID=""  d
	.f  s rowid=$o(^DHCEQEquip(rowid))  quit:(rowid="")  d
	..s gblData=^DHCEQEquip(rowid)
	..d AddDepreCat
	e  d
	.f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  quit:(rowid="")  d
	..s gblData=^DHCEQSnapShot(SnapID,"Equip",rowid)
	..d AddDepreCat

	s TEquipTypeDR=""
	f  s TEquipTypeDR=$o(^TempDHCEQ("Report","DepreCat",TJob,TEquipTypeDR))  quit:(TEquipTypeDR="")  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s (SumQtyType,SumAmountType,SumDepreFeeType,SumDepreYearFeeType,SumDepreTotalType,SumNetFeeType)=0 
	.s TEquiCatDR=""
	.f  s TEquiCatDR=$o(^TempDHCEQ("Report","DepreCat",TJob,TEquipTypeDR,TEquiCatDR))  quit:(TEquiCatDR="")  d
	..s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	..s TempData=$g(^TempDHCEQ("Report","DepreCat",TJob,TEquipTypeDR,TEquiCatDR))
	..s TQuantity=$p(TempData,"^",1)
	..s TOriginalFee=$p(TempData,"^",2)
	..s TDepreFee=$p(TempData,"^",3)
	..s TDepreYearFee=$p(TempData,"^",4)
	..s TDepreTotal=$p(TempData,"^",5)
	..s TNetFee=$p(TempData,"^",6)
	..
	..s SumQtyType=SumQtyType+TQuantity
	..s SumAmountType=SumAmountType+TOriginalFee	
	..s SumDepreFeeType=SumDepreFeeType+TDepreFee
	..s SumDepreYearFeeType=SumDepreYearFeeType+TDepreYearFee
	..s SumDepreTotalType=SumDepreTotalType+TDepreTotal
	..s SumNetFeeType=SumNetFeeType+TNetFee
	..d OutputRowDepreCat
	.s TEquiCat="小计"
	.s TQuantity=SumQtyType
	.s TOriginalFee=SumAmountType
	.s TDepreFee=SumDepreFeeType
	.s TDepreYearFee=SumDepreYearFeeType
	.s TDepreTotal=SumDepreTotalType
	.s TNetFee=SumNetFeeType
	.d OutputRowDepreCat
		
	i SumQty>0  d
	.s TEquipType="合计"
	.s TEquiCat=""
	.s TQuantity=SumQty
	.s TOriginalFee=SumAmount
	.s TDepreFee=SumDepreFee
	.s TDepreYearFee=SumDepreYearFee
	.s TDepreTotal=SumDepreTotal
	.s TNetFee=SumNetFee
	.d OutputRowDepreCat
	
	k ^TempDHCEQ("Report","DepreCat",TJob)
	Quit $$$OK
AddDepreCat
	///出库状态、无效标志
	s StockStatus=$p(gblData,"^",60)
	;尚未入库的不计入
	q:(StockStatus="0")
	
	s CounterFlag="1"
	;其他退货、报废、无效的，不计入原值、数量，只计入折旧、累计折旧相关数据
	i (StockStatus="3") s CounterFlag="0"
	;过滤掉报废的
	s Status=$p(gblData,"^",38)
	i (Status>"2") s CounterFlag="0"
	;过滤掉无效的
	s InvalidFlag=$p(gblData,"^",59)
	i (InvalidFlag="Y") s CounterFlag="0"
	q:((UseLocDR'="")&&(UseLocDR'=$p(gblData,"^",67)))  ;库房
	s EquipID=rowid
	d BuildTempDepreCat
	quit
BuildTempDepreCat
	s TEquipType=$p(gblData,"^",63)
	i TEquipType="" s TEquipType=0
	s TEquiCat=$p(gblData,"^",4)
	i TEquiCat="" s TEquiCat=0
	
	s TDepreInfo=..GetDepreInfo(EquipID,MonthStr,DepreTypeDR)	
	s TDepreFee=$p(TDepreInfo,"^",4)
	s TDepreYearFee=$p(TDepreInfo,"^",5)
	s TOriginalFee=$p(gblData,"^",27)*CounterFlag
	s TDepreTotal=$p(gblData,"^",35)
	s TNetFee=$p(gblData,"^",28)*CounterFlag
	
	s SumQty=SumQty+CounterFlag
	s SumAmount=SumAmount+TOriginalFee	
	s SumDepreFee=SumDepreFee+TDepreFee
	s SumDepreYearFee=SumDepreYearFee+TDepreYearFee
	s SumDepreTotal=SumDepreTotal+TDepreTotal
	s SumNetFee=SumNetFee+TNetFee
	
	s TempData=$g(^TempDHCEQ("Report","DepreCat",TJob,TEquipType,TEquiCat))
	s TQuantity=CounterFlag+$p(TempData,"^",1)
	s TOriginalFee=TOriginalFee+$p(TempData,"^",2)
	s TDepreFee=TDepreFee+$p(TempData,"^",3)
	s TDepreYearFee=TDepreYearFee+$p(TempData,"^",4)
	s TDepreTotal=TDepreTotal+$p(TempData,"^",5)
	s TNetFee=TNetFee+$p(TempData,"^",6)
	s ^TempDHCEQ("Report","DepreCat",TJob,TEquipType,TEquiCat)=TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee
	
	quit
OutputRowDepreCat
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	s TDepreYearFee=##Class(web.DHCEQCommon).FormatNumber(TDepreYearFee,"",2)
	s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)
	
	s Data=$lb(TEquipType,TEquiCat,TQuantity,TOriginalFee,TDepreFee,TDepreYearFee,TDepreTotal,TNetFee,TJob)
	s ^TempDHCEQ(TempNode,Date,TJob,index)=TEquipType_"^"_TEquiCat_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
	
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod DepreCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepreCatExecute ]
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

ClassMethod DepreCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepreCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 资产折旧科室表
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","DepreLoc")
Query DepreLoc(UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", DepreTypeDR As %String = "1") As %Query(ROWSPEC = "TStoreLoc:%String,TQuantity:%String,TOriginalFee:%String,TDepreFee:%String,TDepreYearFee:%String,TDepreTotal:%String,TNetFee:%String,TJob:%String,TRow:%String")
{
}

ClassMethod DepreLocExecute(ByRef qHandle As %Binary, UseLocDR As %String = "", MasterItemDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", MinValue As %String = "", MaxValue As %String = "", BeginDate As %String = "", EndDate As %String = "", BeginInStockDate As %String = "", EndInStockDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", DepreTypeDR As %String = "1") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i DepreTypeDR="" s DepreTypeDR="1"		//Add By DJ 2015-07-14 DJ0147
 	s TempNode="ReportEx.DepreLoc"
 	d ##class(web.DHCEQCommon).KillTempGlobal(TempNode)               //临时Global
	s index=1
	s TRow=0
	s TJob=$j
	k ^TempDHCEQ("Report","DepreLoc",TJob)
	s Date=+$H
	
	s (SumQty,SumAmount,SumDepreFee,SumDepreYearFee,SumDepreTotal,SumNetFee)=0
	
	;Add by jdl 2011-4-15 JDL0078
	;改为从快照获取数据
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	
	s rowid=0
	i SnapID=""  d
	.f  s rowid=$o(^DHCEQEquip(rowid))  quit:(rowid="")  d
	..s gblData=^DHCEQEquip(rowid)
	..d AddDepreLoc
	e  d
	.f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid))  quit:(rowid="")  d
	..s gblData=^DHCEQSnapShot(SnapID,"Equip",rowid)
	..d AddDepreLoc
	
	s TStoreLocDR=""
	f  s TStoreLocDR=$o(^TempDHCEQ("Report","DepreLoc",TJob,TStoreLocDR))  quit:(TStoreLocDR="")  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TempData=$g(^TempDHCEQ("Report","DepreLoc",TJob,TStoreLocDR))
	.s TQuantity=$p(TempData,"^",1)
	.s TOriginalFee=$p(TempData,"^",2)
	.s TDepreFee=$p(TempData,"^",3)
	.s TDepreYearFee=$p(TempData,"^",4)
	.s TDepreTotal=$p(TempData,"^",5)
	.s TNetFee=$p(TempData,"^",6)
	.s TRow=TRow+1
	.d OutputRowDepreLoc	
		
	i SumQty>0  d
	.s TRow="合计"
	.s TStoreLoc=""
	.s TQuantity=SumQty
	.s TOriginalFee=SumAmount
	.s TDepreFee=SumDepreFee
	.s TDepreYearFee=SumDepreYearFee
	.s TDepreTotal=SumDepreTotal
	.s TNetFee=SumNetFee
	.d OutputRowDepreLoc
	
	k ^TempDHCEQ("Report","DepreLoc",TJob)
	Quit $$$OK
AddDepreLoc
	///出库状态、无效标志
	s StockStatus=$p(gblData,"^",60)
	;尚未入库的不计入
	q:(StockStatus="0")
	
	s CounterFlag="1"
	;其他退货、报废、无效的，不计入原值、数量，只计入折旧、累计折旧相关数据
	i (StockStatus="3") s CounterFlag="0"
	;过滤掉报废的
	s Status=$p(gblData,"^",38)
	i (Status>"2") s CounterFlag="0"
	;过滤掉无效的
	s InvalidFlag=$p(gblData,"^",59)
	i (InvalidFlag="Y") s CounterFlag="0"
	q:((UseLocDR'="")&&(UseLocDR'=$p(gblData,"^",67)))  ;库房
	s EquipID=rowid
	s EquipTypeDR=$p(gblData,"^",63)  //类组 Add By HZY 2013-12-10  HZY0040
	q:(0'=##class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR))  //过滤类组 Add By HZY 2013-12-10 HZY0040
	d BuildTempDepreLoc
	quit
BuildTempDepreLoc
	s TStoreLoc=$p(gblData,"^",67)
	i TStoreLoc="" s TStoreLoc=0	
	
	s TDepreInfo=..GetDepreInfo(EquipID,MonthStr,DepreTypeDR)	
	s TDepreFee=$p(TDepreInfo,"^",4)
	s TDepreYearFee=$p(TDepreInfo,"^",5)
	s TOriginalFee=$p(gblData,"^",27)*CounterFlag
	s TDepreTotal=$p(gblData,"^",35)
	s TNetFee=$p(gblData,"^",28)*CounterFlag
	
	
	s SumQty=SumQty+CounterFlag
	s SumAmount=SumAmount+TOriginalFee	
	s SumDepreFee=SumDepreFee+TDepreFee
	s SumDepreYearFee=SumDepreYearFee+TDepreYearFee
	s SumDepreTotal=SumDepreTotal+TDepreTotal
	s SumNetFee=SumNetFee+TNetFee
	
	s TempData=$g(^TempDHCEQ("Report","DepreLoc",TJob,TStoreLoc))
	s TQuantity=CounterFlag+$p(TempData,"^",1)
	s TOriginalFee=TOriginalFee+$p(TempData,"^",2)
	s TDepreFee=TDepreFee+$p(TempData,"^",3)
	s TDepreYearFee=TDepreYearFee+$p(TempData,"^",4)
	s TDepreTotal=TDepreTotal+$p(TempData,"^",5)
	s TNetFee=TNetFee+$p(TempData,"^",6)
	s ^TempDHCEQ("Report","DepreLoc",TJob,TStoreLoc)=TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee
	
	quit
OutputRowDepreLoc
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	s TDepreYearFee=##Class(web.DHCEQCommon).FormatNumber(TDepreYearFee,"",2)
	s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)
	
	s Data=$lb(TStoreLoc,TQuantity,TOriginalFee,TDepreFee,TDepreYearFee,TDepreTotal,TNetFee,TJob,TRow)
	s ^TempDHCEQ(TempNode,Date,TJob,index)=TStoreLoc_"^"_TQuantity_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob
	
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod DepreLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepreLocExecute ]
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

ClassMethod DepreLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepreLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add By HZY 2011-10-27 HZY0020
/// Desc:供应商供货分组汇总统计查询.																																		  TVendor	      TVendorID,        TTotalFee,        TInStockAmount,        TInStockBillAmount,        TInStockBills,        TInStockFee,        TInvoiceAmount,        TNotPaidFee,        TPaidFee,        TReturnAmount,        TReturnBillAmount,        TReturnBills,        TReturnFee,        TTotalAmount,        TEquipType,        TStatCat,        TEquipCat,        TEquipName,        TEquipTypeDR,        TStatCatDR,        TEquipCatDR		
Query GetVendorStatA(ValEquipTypes, StartDate, EndDate, VendorDR, Vendor, QXType As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "") As %Query(ROWSPEC = "TVendor:%String,TVendorID:%String,TTotalFee:%String,TInStockAmount:%String,TInStockBillAmount:%String,TInStockBills:%String,TInStockFee:%String,TInvoiceAmount:%String,TNotPaidFee:%String,TPaidFee:%String,TReturnAmount:%String,TReturnBillAmount:%String,TReturnBills:%String,TReturnFee:%String,TTotalAmount:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEquipName:%String,TEquipTypeDR:%String,TStatCatDR:%String,TEquipCatDR:%String,TRow:%String")
{
}

ClassMethod GetVendorStatAExecute(ByRef qHandle As %Binary, ValEquipTypes, StartDate, EndDate, VendorDR, Vendor, QXType As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "") As %Status
{
 	new repid, index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)	
 	s index=1	
 	s PNum=1
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^TempDHCEQ("VendorStatA",User)
 	k ^TempDHCEQ("VendorStatAPrint",User)	//打印用的global .
 	set StartDate=+StartDate
 	if StartDate>0 s StartDate=StartDate-1
 	if (EndDate="") s EndDate=+$H
 	i ValEquipTypes="" s ValEquipTypes=##Class(web.DHCEQCommon).GetEquipTypesByGroup() 
 	i ValEquipTypes="" Quit $$$OK 
 	s ValEquipTypes="^"_ValEquipTypes_"^"
 	s vendorid=0	//供应商ID,初始化为0
 	s InvoiceDRList=""  //发票RowID串
 	s AllInStockBills=""
 	s AllReturnBills=""
 	s AllInvoiceDR=""
 	
 	d ResetVariablesVendorStatA
 	//获得入库的相关信息
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s statcat=""
 	.f  s statcat=$o(^DHCEQInStock(0,"BillDate",StockDate,statcat)) q:statcat=""  d
 	..s rowid=0		//入库单rowID
 	..f  s rowid=$o(^DHCEQInStock(0,"BillDate",StockDate,statcat,rowid)) q:rowid=""  d
 	...s TEquipTypeDR=$p(^DHCEQInStock(rowid),"^",20)
 	...q:ValEquipTypes'[("^"_TEquipTypeDR_"^") 
 	...s vendorid=$p(^DHCEQInStock(rowid),"^",17)
 	...q:vendorid="" 
 	...q:(VendorDR'="")&&(vendorid'=VendorDR)	
 	...s StoreLoc=$p(^DHCEQInStock(rowid),"^",2)
 	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) 
 	...q:(+$p(^DHCEQInStock(rowid),"^",10)'=2)		//判断入库单是否为审核状态
 	...s TStatCatDR=$p($g(^DHCEQInStock(rowid)),"^",21)
 	...q:(StatCatDR'="")&&(StatCatDR'=TStatCatDR)
 	...s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)	//类型
 	...s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)	//类组
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s TInStockBills=$p(^DHCEQInStock(rowid),"^",14)	//入库单号
 	...s TInStockBillAmount=1	//入库单张数
 	...d GetInstockInfoA
 	
 	//获得退库的相关信息
 	d ResetVariablesVendorStatA
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s statcat=""
 	.f  s statcat=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,statcat)) q:statcat=""  d
 	..s rowid=0
 	..f  s rowid=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,statcat,rowid)) q:rowid=""  d
 	...q:ValEquipTypes'[("^"_$p(^DHCEQReturn(rowid),"^",15)_"^") 
 	...s vendorid=$p(^DHCEQReturn(rowid),"^",3)
 	...q:vendorid="" 
 	...q:(VendorDR'="")&&(vendorid'=VendorDR)	
 	...s StoreLoc=$p(^DHCEQReturn(rowid),"^",2) 
 	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)))		
 	...q:(+$p(^DHCEQReturn(rowid),"^",17)'=1)		//判断'出库类型'是否为'退货'
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s TReturnBills=$p(^DHCEQReturn(rowid),"^",1)	//退库单号
 	...s TReturnBillAmount=1		//退库单张数
 	...s TStatCatDR=$p($g(^DHCEQReturn(rowid)),"^",16)
 	...q:(StatCatDR'="")&&(StatCatDR'=TStatCatDR)
 	...s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)	//类型
 	...s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)	//类组
 	...d GetReturnInfoA
 	
 	//输出最终的结果
	s (sumInStockAmount,sumInStockFee,sumReturnAmount,sumReturnFee,sumTotalFee,sumTotalAmount,sumInStockBillAmount,sumReturnBillAmount,sumPaidFee,sumNotPaidFee)=0
 	s vendorid=0	//$o(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)) q:vendorid=""  d
 	f  s vendorid=$o(^TempDHCEQ("VendorStatA",User,vendorid)) q:vendorid=""  d
 	.s equipTypeDR=""
 	.f  s equipTypeDR=$o(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR)) q:equipTypeDR=""  d
 	..s statCatDR=""
 	..f  s statCatDR=$o(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR)) q:statCatDR=""  d
 	...s equipCatDR=""
 	...f  s equipCatDR=$o(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR)) q:equipCatDR=""  d
 	....s equipName=""
 	....f  s equipName=$o(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)) q:equipName=""  d
 	.....d SetOutputRowVendorStatA
 	.....d OutputRowVendorStatA
 		
 	//输出最终的合计
 	d ResetVariablesVendorStatA 	
 	s TRow="合计"
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

 	d OutputRowVendorStatA
 	
	Quit $$$OK
		
GetInstockInfoA
	s listRowId=0	//入库明细ID
	f  s listRowId=$o(^DHCEQInStockList(0,"InStock",rowid,listRowId)) q:listRowId=""  d
	.s TEquipCatDR=$p($g(^DHCEQInStockList(listRowId)),"^",14)
	.q:(EquipCatDR'="")&&(EquipCatDR'=TEquipCatDR)
	.i TEquipCatDR'="" s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)	//分类
	.s TEquipName=$p($g(^DHCEQInStockList(listRowId)),"^",5)	//设备名称
	.s TInStockAmount=+($p($g(^DHCEQInStockList(listRowId)),"^",8))	//入库数量
	.s TInStockFee=+($p($g(^DHCEQInStockList(listRowId)),"^",7)*$p($g(^DHCEQInStockList(listRowId)),"^",8))	//入库金额=(设备原值*数量)
 	.s IUMRowID=0
 	.s InvoiceDRList=""
 	.f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",1,listRowId,IUMRowID)) q:IUMRowID=""  d
 	..s InvoiceDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)	//发票ID
 	..i InvoiceDRList'=""  d
 	...s InvoiceDRList=InvoiceDRList_","_InvoiceDR
 	..e  d
 	...s InvoiceDRList=InvoiceDR
 	.s payrecord=""		//付款记录ID
 	.f  s payrecord=$o(^DHCEQPayRecord(0,"Source",1,listRowId,payrecord))  q:payrecord=""  d
 	..s TPaidFee=TPaidFee+$p($g(^DHCEQPayRecord(payrecord)),"^",3)	//支付金额
 	.
 	.s TInvoiceAmount=InvoiceDRList
 	.i TEquipTypeDR="" s TEquipTypeDR=0
 	.i TStatCatDR="" s TStatCatDR=0
 	.i TEquipCatDR="" s TEquipCatDR=0
 	.i TEquipName="" s TEquipName=0
 	.i ($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName))'="") d
 	..s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	 //供应商                                             
 	..s TInStockAmount=TInStockAmount+($p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",2))
 	..s TInStockFee=TInStockFee+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",3)
 	..i $p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",7)'[TInStockBills d 
 	...i $p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",7)'=""  d
 	....s TInStockBills=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",7)_","_TInStockBills			//入库单
 	...s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",6)+1		//入库单张数
 	..i InvoiceDRList'=""  d
 	...s TInvoiceAmount=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",10)_","_TInvoiceAmount	//先记录下所有发票的ID,之后再算出发票数  HZY0020
 	..s TPaidFee=TPaidFee+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",11)		//已付款金额
 	.//																							1               2                3                 4               5                  6                    7                   8                  9                 10              11            12            13            14            15              16              17             18      
 	.;w ("Value:"_TEquipTypeDR_","_TStatCatDR_","_TEquipCatDR_","_TEquipName)
 	.s ^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TEquipType_"^"_TStatCat_"^"_TEquipCat_"^"_TEquipName_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TEquipCatDR
	i InvoiceDRList'="" d 
	.i AllInvoiceDR'=""  d 
	..s AllInvoiceDR=AllInvoiceDR_","_InvoiceDRList
	.e  d
	..s AllInvoiceDR=InvoiceDRList
	d ResetVariablesVendorStatA
	quit
	
GetReturnInfoA
	s listRowId=0
	s InStockListDR=0
	s EquipDR=0
	f  s listRowId=$o(^DHCEQReturnList(0,"Return",rowid,listRowId)) q:listRowId=""  d
	.s InStockListDR=$p($g(^DHCEQReturnList(listRowId)),"^",3)
	.i (InStockListDR'="")  d
	..s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
	.e  d
	..s EquipDR=$p($g(^DHCEQReturnList(listRowId)),"^",4)
	..s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
	..s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
	.q:(EquipCatDR'="")&&(EquipCatDR'=TEquipCatDR)
	.i TEquipCatDR'="" s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)	//分类
	.s TEquipName=$p($g(^DHCEQInStockList(InStockListDR)),"^",5)	//设备名称
	.s TReturnAmount=$p($g(^DHCEQReturnList(listRowId)),"^",5)		//退库数量
	.s TReturnFee=($p($g(^DHCEQReturnList(listRowId)),"^",5)*$p($g(^DHCEQReturnList(listRowId)),"^",6))		//退库金额(退库数量*金额)
	.
	.i TEquipTypeDR="" s TEquipTypeDR=0
 	.i TStatCatDR="" s TStatCatDR=0
 	.i TEquipCatDR="" s TEquipCatDR=0
 	.i TEquipName="" s TEquipName=0
	.i ($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName))'="") d
	..s TVendor=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",1)
	..s TInStockAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",2)
 	..s TInStockFee=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",3)
 	..s TReturnAmount=TReturnAmount+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",4)
 	..s TReturnFee=TReturnFee+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",5)
 	..s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",6)
 	..s TInStockBills=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",7)
 	..i $p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",9)'[TReturnBills
 	...s TReturnBillAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",8)+1		//退货单数量
 	...i $p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",9)'=""  d
 	....s TReturnBills=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",9)_","_TReturnBills	//退货单号
 	..s TInvoiceAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",10)		//发票数
 	..s TPaidFee=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",11)
 	..s TEquipType=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",12)
 	..s TStatCat=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",13)
 	..s TEquipCat=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",14)
 	..s TEquipName=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",15)
 	..s TEquipTypeDR=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",16)
 	..s TStatCatDR=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",17)
 	..s TEquipCatDR=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)),"^",18)
	.;w ("Values:"_User_"^"_vendorid_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TEquipCatDR_"^"_TEquipName)  //Test HZY 
	.s ^TempDHCEQ("VendorStatA",User,vendorid,TEquipTypeDR,TStatCatDR,TEquipCatDR,TEquipName)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TEquipType_"^"_TStatCat_"^"_TEquipCat_"^"_TEquipName_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TEquipCatDR
	d ResetVariablesVendorStatA
	quit
	
ResetVariablesVendorStatA
	s InvoiceDRList=""
	s (TVendorID,TVendor,TReturnBills,TInStockBills,TEquipType,TStatCat,TEquipCat,TEquipName,TEquipTypeDR,TStatCatDR,TEquipCatDR,TRow)=""
	s (TTotalFee,TInStockAmount,TInStockBillAmount,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnFee,TTotalAmount)=0	
	quit
	
SetOutputRowVendorStatA 
 	d ResetVariablesVendorStatA
 	s TVendorID=vendorid
 	s TVendor=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",1)
 	s TInStockAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",2)
 	s TInStockFee=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",3)
 	s TReturnAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",4)
 	s TReturnFee=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",5)
 	s TTotalFee=TInStockFee-TReturnFee				//在库金额
 	s TTotalAmount=TInStockAmount-TReturnAmount	//在库数量
 	s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",6)
 	s TInStockBills=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",7)
 	s TReturnBillAmount=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",8)
 	s TReturnBills=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",9)
 	s InvoiceDRs=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",10)
 	s TInvoiceAmount=..GetSubStringNum(InvoiceDRs)	//算出不重复的发票数
 	s TPaidFee=+$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",11)
 	s TNotPaidFee=TTotalFee-TPaidFee		//未付款金额
 	s TEquipType=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",12)
 	s TStatCat=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",13)
 	s TEquipCat=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",14)
 	s TEquipName=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",15)
 	s TEquipTypeDR=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",16)
 	s TStatCatDR=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",17)
 	s TEquipCatDR=$p($g(^TempDHCEQ("VendorStatA",User,vendorid,equipTypeDR,statCatDR,equipCatDR,equipName)),"^",18)
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
 	.s AllInvoiceDR=InvoiceDRs
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
	
	
OutputRowVendorStatA
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	s TInStockFee=##Class(web.DHCEQCommon).FormatNumber(TInStockFee,"",2)
	s TReturnFee=##Class(web.DHCEQCommon).FormatNumber(TReturnFee,"",2)
	s TPaidFee=##Class(web.DHCEQCommon).FormatNumber(TPaidFee,"",2)
	s TNotPaidFee=##Class(web.DHCEQCommon).FormatNumber(TNotPaidFee,"",2)
	/// 20150918  Mozy0166
	If TRow="" Set TRow=PNum
	Set TInStockBills=##Class(web.DHCEQCommon).NoToGroupNo(TInStockBills)
	Set TReturnBills=##Class(web.DHCEQCommon).NoToGroupNo(TReturnBills)
	s Data=$lb(TVendor,TVendorID,TTotalFee,TInStockAmount,TInStockBillAmount,TInStockBills,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnBills,TReturnFee,TTotalAmount,TEquipType,TStatCat,TEquipCat,TEquipName,TEquipTypeDR,TStatCatDR,TEquipCatDR,TRow)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	//打印用^TempDHCEQ("VendorStatAPrint",User,PNum)
	s ^TempDHCEQ("VendorStatAPrint",User,PNum)=TVendor_"^"_TEquipType_"^"_TStatCat_"^"_TEquipCat_"^"_TEquipName_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TTotalAmount_"^"_TTotalFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TNotPaidFee_"^"_TRow
	s PNum=PNum+1
	quit
}

ClassMethod GetVendorStatAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVendorStatAExecute ]
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

ClassMethod GetVendorStatAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVendorStatAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetVendorStatAPrint(num)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^TempDHCEQ("VendorStatAPrint",User,num))
}

/// Add By HZY 2011-11-10 HZY0020
/// Desc:供应商供货明细查询.																																					 							           														TVendor	        TVendorID,        TTotalFee,        TInStockAmount,        TInStockBillAmount,        TInStockBills,        TInStockFee,        TInvoiceAmount,        TNotPaidFee,        TPaidFee,        TReturnAmount,        TReturnBillAmount,        TReturnBills,        TReturnFee,        TTotalAmount,        TEquipType,        TStatCat,        TEquipCat,        TEquipName,        TEquipTypeDR,        TStatCatDR,        TEquipCatDR		  TModel		 TOriginFee
Query GetVendorStatB(StartDate, EndDate, VendorDR, Vendor, QXType As %String = "", ValEquipTypes As %String = "", StatCatDR As %String = "", StatCat As %String = "", EquipCatDR As %String = "", EquipCat As %String = "", EquipName As %String = "") As %Query(ROWSPEC = "TVendor:%String,TVendorID:%String,TTotalFee:%String,TInStockAmount:%String,TInStockBillAmount:%String,TInStockBills:%String,TInStockFee:%String,TInvoiceAmount:%String,TNotPaidFee:%String,TPaidFee:%String,TReturnAmount:%String,TReturnBillAmount:%String,TReturnBills:%String,TReturnFee:%String,TTotalAmount:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEquipName:%String,TEquipTypeDR:%String,TStatCatDR:%String,TEquipCatDR:%String,TModel:%String,TOriginFee:%String,TRow:%String")
{
}

ClassMethod GetVendorStatBExecute(ByRef qHandle As %Binary, StartDate, EndDate, VendorDR, Vendor, QXType As %String = "", ValEquipTypes As %String = "", StatCatDR As %String = "", StatCat As %String = "", EquipCatDR As %String = "", EquipCat As %String = "", EquipName As %String = "") As %Status
{
 	new repid,index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)	
 	s index=1	
 	s PNum=1
 	s totalFlag=0	//判断当前输出是否为合计行
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^TempDHCEQ("VendorStatB",User)
 	k ^TempDHCEQ("VendorStatBPrint",User)	//打印用的global .
 	set StartDate=+StartDate
 	if StartDate>0 s StartDate=StartDate-1
 	if (EndDate="") s EndDate=+$H
 	i ValEquipTypes=""||ValEquipTypes="0" s ValEquipTypes=##Class(web.DHCEQCommon).GetEquipTypesByGroup() 
 	i ValEquipTypes=""||ValEquipTypes="0" Quit $$$OK 
 	s ValEquipTypes="^"_ValEquipTypes_"^"
 	s vendorid=0	//供应商ID,初始化为0
 	s InvoiceDRList=""  //发票RowID串
 	s AllInStockBills=""
 	s AllReturnBills=""
 	s AllInvoiceDR=""
 	
 	d ResetVariablesVendorStatB
 	//获得入库的相关信息
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s statcat=""
 	.f  s statcat=$o(^DHCEQInStock(0,"BillDate",StockDate,statcat)) q:statcat=""  d
 	..s rowid=0		//入库单rowID
 	..f  s rowid=$o(^DHCEQInStock(0,"BillDate",StockDate,statcat,rowid)) q:rowid=""  d
 	...s TEquipTypeDR=$p(^DHCEQInStock(rowid),"^",20)
 	...;q:(EquipTypeDR'="")&&(+EquipTypeDR'=0)&&(EquipTypeDR'=TEquipTypeDR) 
 	...q:ValEquipTypes'[("^"_TEquipTypeDR_"^") 
 	...s vendorid=$p(^DHCEQInStock(rowid),"^",17)
 	...q:vendorid="" 
 	...q:(VendorDR'="")&&(vendorid'=VendorDR)	
 	...s StoreLoc=$p(^DHCEQInStock(rowid),"^",2)
 	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) 
 	...q:(+$p(^DHCEQInStock(rowid),"^",10)'=2)		//判断入库单是否为审核状态
 	...s TStatCatDR=$p($g(^DHCEQInStock(rowid)),"^",21)
 	...q:(StatCatDR'="" )&&(+StatCatDR'=0)&&(StatCatDR'=TStatCatDR)
 	...s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)	//类型
 	...s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)	//类组
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s TInStockBills=$p(^DHCEQInStock(rowid),"^",14)	//入库单号
 	...s TInStockBillAmount=1	//入库单张数
 	...d GetInstockInfoB
 	
 	//获得退库的相关信息
 	d ResetVariablesVendorStatB
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s statcat=""
 	.f  s statcat=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,statcat)) q:statcat=""  d
 	..s rowid=0
 	..f  s rowid=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,statcat,rowid)) q:rowid=""  d
 	...;q:(EquipTypeDR'="")&&(+EquipTypeDR'=0)&&(EquipTypeDR'=$p(^DHCEQReturn(rowid),"^",15))
 	...s TEquipTypeDR=$p(^DHCEQReturn(rowid),"^",15)
 	...q:ValEquipTypes'[("^"_TEquipTypeDR_"^") 
 	...s vendorid=$p(^DHCEQReturn(rowid),"^",3)
 	...q:vendorid="" 
 	...q:(VendorDR'="")&&(vendorid'=VendorDR)	
 	...s StoreLoc=$p(^DHCEQReturn(rowid),"^",2) 
 	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)))		
 	...q:(+$p(^DHCEQReturn(rowid),"^",17)'=1)		//判断'出库类型'是否为'退货'
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s TReturnBills=$p(^DHCEQReturn(rowid),"^",1)	//退库单号
 	...s TReturnBillAmount=1		//退库单张数
 	...s TStatCatDR=$p($g(^DHCEQReturn(rowid)),"^",16)
 	...q:(StatCatDR'="")&&(+StatCatDR'=0)&&(StatCatDR'=TStatCatDR)
 	...s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)	//类型
 	...s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)	//类组
 	...d GetReturnInfoB
 	
 	s (sumInStockAmount,sumInStockFee,sumReturnAmount,sumReturnFee,sumTotalFee,sumTotalAmount,sumInStockBillAmount,sumReturnBillAmount,sumPaidFee,sumNotPaidFee,sumOriginFee)=0
	s InStockListDR=""
	f  s InStockListDR=$o(^TempDHCEQ("VendorStatB",User,InStockListDR)) q:InStockListDR=""  d
	.d ResetVariablesVendorStatB
	.d SetOutputRowVendorStatB
	.d OutputRowVendorStatB
	 		
 	//输出最终的合计
 	d ResetVariablesVendorStatB 	
 	s TRow="合计"
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
 	s TOriginFee=""			//设备原值 	 分组显示时 不做合计
 	s totalFlag=1
 	d OutputRowVendorStatB
 	
	Quit $$$OK
		
GetInstockInfoB
	s listRowId=0	//入库明细ID
	f  s listRowId=$o(^DHCEQInStockList(0,"InStock",rowid,listRowId)) q:listRowId=""  d
	.s TEquipCatDR=$p($g(^DHCEQInStockList(listRowId)),"^",14)
	.q:(EquipCatDR'="")&&(+EquipCatDR'=0)&&(EquipCatDR'=TEquipCatDR)
	.i TEquipCatDR'="" s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)	//分类
	.s TEquipName=$p($g(^DHCEQInStockList(listRowId)),"^",5)	//设备名称
	.q:(EquipName'="")&&(EquipName'="0")&&(EquipName'=TEquipName)
	.s TModelDR=$p($g(^DHCEQInStockList(listRowId)),"^",9)	//设备机型
	.i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TOriginFee=+$p($g(^DHCEQInStockList(listRowId)),"^",7)	//设备原值
	.s TInStockAmount=+($p($g(^DHCEQInStockList(listRowId)),"^",8))	//入库数量
	.s TInStockFee=TOriginFee*TInStockAmount	//入库金额=(设备原值*数量)
 	.s IUMRowID=0
 	.s InvoiceDRList=""
 	.f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",1,listRowId,IUMRowID)) q:IUMRowID=""  d
 	..s InvoiceDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)	//发票ID
 	..i InvoiceDRList'=""  d
 	...s InvoiceDRList=InvoiceDRList_","_InvoiceDR
 	..e  d
 	...s InvoiceDRList=InvoiceDR
 	.
 	.s TInvoiceAmount=InvoiceDRList
 	.s payrecord=""		//付款记录ID
 	.f  s payrecord=$o(^DHCEQPayRecord(0,"Source",1,listRowId,payrecord))  q:payrecord=""  d
 	..s TPaidFee=TPaidFee+$p($g(^DHCEQPayRecord(payrecord)),"^",3)	//支付金额
 	.//												1               2                3                 4               5                  6                    7                   8                  9                 10              11            12            13            14            15              16              17             18             19           20
 	.s ^TempDHCEQ("VendorStatB",User,listRowId)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TEquipType_"^"_TStatCat_"^"_TEquipCat_"^"_TEquipName_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TEquipCatDR_"^"_TModel_"^"_TOriginFee
	i InvoiceDRList'=""  d
	.i AllInvoiceDR'=""  d 
	..s AllInvoiceDR=AllInvoiceDR_","_InvoiceDRList
	.e  d
	..s AllInvoiceDR=InvoiceDRList
	d ResetVariablesVendorStatB
	quit
	
GetReturnInfoB
	s listRowId=0
	s InStockListDR=0
	s EquipDR=0
	f  s listRowId=$o(^DHCEQReturnList(0,"Return",rowid,listRowId)) q:listRowId=""  d
	.s InStockListDR=$p($g(^DHCEQReturnList(listRowId)),"^",3)
	.i (InStockListDR'="")  d
	..s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
	.e  d
	..s EquipDR=$p($g(^DHCEQReturnList(listRowId)),"^",4)
	..s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
	..s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
	.q:(EquipCatDR'="")&&(+EquipCatDR'=0)&&(EquipCatDR'=TEquipCatDR)
	.i TEquipCatDR'="" s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)	//分类
	.s TEquipName=$p($g(^DHCEQInStockList(InStockListDR)),"^",5)	//设备名称
	.q:(EquipName'="")&&(EquipName'="0")&&(EquipName'=TEquipName)
	.
	.s TModelDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",9)	//设备机型
	.i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TOriginFee=+$p($g(^DHCEQInStockList(InStockListDR)),"^",7)	//设备原值
	.s TReturnAmount=$p($g(^DHCEQReturnList(listRowId)),"^",5)	//退库数量
	.s TReturnFee=(TReturnAmount*$p($g(^DHCEQReturnList(listRowId)),"^",6))		//退库金额(退库数量*金额)
	.
	.i ($g(^TempDHCEQ("VendorStatB",User,InStockListDR))'="") d
	..s TInStockAmount=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",2)
 	..s TInStockFee=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",3)
 	..s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",6)
 	..s TInStockBills=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",7)
 	..s TInvoiceAmount=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",10)		//发票
 	..s TPaidFee=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",11)
 	..s TEquipType=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",12)
 	..s TStatCat=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",13)
 	..s TEquipCat=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",14)
 	..s TEquipName=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",15)
 	..s TEquipTypeDR=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",16)
 	..s TStatCatDR=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",17)
 	..s TEquipCatDR=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",18)
 	..s TModel=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",19)
 	..s TOriginFee=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",20)
	.;w ("Values:"_User_"^"_vendorid_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TEquipCatDR_"^"_TEquipName)  //Test HZY 
	.s ^TempDHCEQ("VendorStatB",User,InStockListDR)=TVendor_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TEquipType_"^"_TStatCat_"^"_TEquipCat_"^"_TEquipName_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TEquipCatDR_"^"_TModel_"^"_TOriginFee
	d ResetVariablesVendorStatB
	quit
	
ResetVariablesVendorStatB
	s InvoiceDRList=""
	s (TVendorID,TVendor,TReturnBills,TInStockBills,TEquipType,TStatCat,TEquipCat,TEquipName,TModel,TOriginFee,TEquipTypeDR,TStatCatDR,TEquipCatDR,TRow)=""
	s (TTotalFee,TInStockAmount,TInStockBillAmount,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnFee,TTotalAmount)=0	
	quit
	
SetOutputRowVendorStatB 
 	d ResetVariablesVendorStatB
 	s TVendor=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",1)
 	s TInStockAmount=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",2)
 	s TInStockFee=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",3)
 	s TReturnAmount=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",4)
 	s TReturnFee=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",5)
 	s TTotalFee=TInStockFee-TReturnFee			//在库金额
 	s TTotalAmount=TInStockAmount-TReturnAmount	//在库数量
 	s TInStockBillAmount=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",6)
 	s TInStockBills=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",7)
 	s TReturnBillAmount=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",8)
 	s TReturnBills=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",9)
 	s InvoiceDRs=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",10)	//发票ID串
 	s TInvoiceAmount=..GetSubStringNum(InvoiceDRs)	//算出不重复的发票数
 	s TPaidFee=+$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",11)
 	s TNotPaidFee=TTotalFee-TPaidFee			//未付款金额
 	s TEquipType=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",12)
 	s TStatCat=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",13)
 	s TEquipCat=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",14)
 	s TEquipName=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",15)
 	s TEquipTypeDR=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",16)
 	s TStatCatDR=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",17)
 	s TEquipCatDR=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",18)
 	s TModel=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",19)
 	s TOriginFee=$p($g(^TempDHCEQ("VendorStatB",User,InStockListDR)),"^",20)
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
 	.s AllInvoiceDR=InvoiceDRs
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
	
	
OutputRowVendorStatB
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	s TInStockFee=##Class(web.DHCEQCommon).FormatNumber(TInStockFee,"",2)
	s TReturnFee=##Class(web.DHCEQCommon).FormatNumber(TReturnFee,"",2)
	s TPaidFee=##Class(web.DHCEQCommon).FormatNumber(TPaidFee,"",2)
	s TNotPaidFee=##Class(web.DHCEQCommon).FormatNumber(TNotPaidFee,"",2)
	i totalFlag'=1 s TOriginFee=##Class(web.DHCEQCommon).FormatNumber(TOriginFee,"",2)
	/// 20150918  Mozy0166
	If TRow="" Set TRow=PNum
	Set TInStockBills=##Class(web.DHCEQCommon).NoToGroupNo(TInStockBills)
	Set TReturnBills=##Class(web.DHCEQCommon).NoToGroupNo(TReturnBills)
	s Data=$lb(TVendor,TVendorID,TTotalFee,TInStockAmount,TInStockBillAmount,TInStockBills,TInStockFee,TInvoiceAmount,TNotPaidFee,TPaidFee,TReturnAmount,TReturnBillAmount,TReturnBills,TReturnFee,TTotalAmount,TEquipType,TStatCat,TEquipCat,TEquipName,TEquipTypeDR,TStatCatDR,TEquipCatDR,TModel,TOriginFee,TRow)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	//打印用^TempDHCEQ("VendorStatBPrint",User,PNum)
	s ^TempDHCEQ("VendorStatBPrint",User,PNum)=TVendor_"^"_TEquipType_"^"_TStatCat_"^"_TEquipCat_"^"_TEquipName_"^"_TModel_"^"_TOriginFee_"^"_TInStockAmount_"^"_TInStockFee_"^"_TReturnAmount_"^"_TReturnFee_"^"_TTotalAmount_"^"_TTotalFee_"^"_TInStockBillAmount_"^"_TInStockBills_"^"_TReturnBillAmount_"^"_TReturnBills_"^"_TInvoiceAmount_"^"_TPaidFee_"^"_TNotPaidFee_"^"_TRow
	s PNum=PNum+1
	quit
}

ClassMethod GetVendorStatBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVendorStatBExecute ]
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

ClassMethod GetVendorStatBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVendorStatBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetVendorStatBPrint(num)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^TempDHCEQ("VendorStatBPrint",User,num))
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
		s tmpStr=$p(str,",",i)  //_"," //Modefied by zc 2014-10-16 ZC0014 begin
		if (tmpStr'="")
		{								//Modefied by zc 2014-10-16 ZC0014 end
			s tmpStr=$p(str,",",i)_","
			if (resultStr'[(","_tmpStr))
			{
				s resultStr=resultStr_tmpStr
				s resultNum=resultNum+1
			}
		}
	}
	;q resultStr	//返回不含重复子串的字符串 
	q resultNum		//返回不重复子串的个数
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","GetEquip","电子")
Query GetEquip(EquipName As %String = "", UseLocDR As %String = "") As %Query(ROWSPEC = "TNo:%String,TName:%String,TOriginFee:%String,TUseLoc:%String,TStatus:%String")
{
}

ClassMethod GetEquipExecute(ByRef qHandle As %Binary, EquipName As %String = "", UseLocDR As %String = "") As %Status
{
	new repid,index,rowid,vendorid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	Set RowID=0
 	For  Set RowID=$Order(^DHCEQEquip(RowID)) Quit:RowID=""  Do
 	.Quit:$Piece($Get(^DHCEQEquip(RowID)),"^",59)="Y"
 	.Set TNo=$Piece($Get(^DHCEQEquip(RowID)),"^",71)
 	.Set TName=$Piece($Get(^DHCEQEquip(RowID)),"^",1)
 	.Quit:(EquipName'="")&(TName'[EquipName)
 	.Set TOriginFee=$Piece($Get(^DHCEQEquip(RowID)),"^",27)
 	.Set TOriginFee=##Class(web.DHCEQCommon).FormatNumber(TOriginFee,"",2)
 	.Set TUseLocDR=$Piece($Get(^DHCEQEquip(RowID)),"^",19)
 	.Quit:(UseLocDR'="")&(TUseLocDR'=UseLocDR)
 	.If TUseLocDR'="" Do
 	..Set TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	..Set TUseLoc=$Piece(TUseLoc,"-",2)
 	.Set TStatus=$Piece($Get(^DHCEQEquip(RowID)),"^",38)
 	.If TStatus'="" Set TStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TStatus)
 	.Do OutputRowGetEquip
 	
 	Quit $$$OK
OutputRowGetEquip
 	Set Data=$lb(TNo,TName,TOriginFee,TUseLoc,TStatus)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipExecute ]
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

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2012-11-29
/// 按照资金来源统计累计折旧
/// 0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 9:调整数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","FundsDepreTotalFee","2012-10")
/// TEquipType:%String,TStatCat:%String,TType:%String,TFundsType:%String,TDepreTotalBegin:%String,TDepre:%String,TSMAdd:%String,TSMReduce:%String,TCAAdd:%String,TCAReduce:%String,TRtnReduce:%String,TDisuseReduce:%String,TADAdd:%String,TADReduce:%String,TDepreTotalEnd:%String
Query FundsDepreTotalFee(MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", LocDesc As %String = "", EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", HospitalDR As %Library.String = "", StatCatDR As %Library.String = "", LocTypeDR As %Library.String = "", GROUPID As %String = "", CTLOCID As %String = "") As %Query(ROWSPEC = "TEquipType:%String,TStatCat:%String,TFundsType:%String,TFee:%String") [ SqlProc ]
{
}

ClassMethod FundsDepreTotalFeeExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", LocDesc As %String = "", EquipTypeIDs As %Library.String = "", FundsTypeDR As %String = "", HospitalDR As %Library.String = "", StatCatDR As %Library.String = "", LocTypeDR As %Library.String = "", GROUPID As %String = "", CTLOCID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	Set job=$Job
 	i CTLOCID'="" s CTLOCID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLOCID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
 	Set SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
 	If ((MonthStr="")||(SelfFundsFlag="")) Quit $$$OK
 	Kill ^TempDHCEQ("FundsDepreTotalFee",job)
 	
 	;处理界面上无法清空科室DR值的异常事件
 	If (UseLocDR="null")||(LocDesc="")
 	{
	 	Set UseLocDR=""
 	}
 	Else
 	{
	 	;If ($Piece($Get(^CTLOC(UseLocDR)),"^",1)'=LocDesc)&($Piece($Get(^CTLOC(UseLocDR)),"^",2)'=LocDesc) Set UseLocDR=""   //modify by jyp 2019-10-18 CTLOC调整
 		If (##class(web.DHCEQCommon).GetTrakNameByID("deptcode",UseLocDR)'=LocDesc)&(##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)'=LocDesc) Set UseLocDR=""  //modify by jyp 2019-10-18 CTLOC调整
 	}
 	If (HospitalDR="0") Set HospitalDR=""
 	If (LocTypeDR="0") Set LocTypeDR=""
 	;s ^DHCEQMozy("FundsDepreTotalFee")="^MonthStr="_MonthStr_"^QXType="_QXType_"^UseLocDR="_UseLocDR_"^LocDesc="_LocDesc_"^EquipTypeIDs="_EquipTypeIDs_"^FundsTypeDR="_FundsTypeDR_"^HospitalDR="_HospitalDR_"^StatCatDR="_StatCatDR_"^LocTypeDR="_LocTypeDR_"^GROUPID="_GROUPID_"^CTLOCID="_CTLOCID
 	
 	//根据月报获取期初累计折旧
 	Set MRLYear=+$Piece(MonthStr,"-",1)
 	Set MRLMonth=+$Piece(MonthStr,"-",2)
 	Set StartDate=##Class(web.DHCEQReport).GetReportDate(MRLYear_"-"_MRLMonth,"","")
 	Set EndDate=$Piece(StartDate,"^",2)
	Set StartDate=$Piece(StartDate,"^",1)
	; 2012-10-01之前的系统数据不准确,退出查询
	If (StartDate<62731) Quit $$$OK
 	if MRLMonth=1
 	{
	 	Set MRLMonth=12
	 	Set MRLYear=MRLYear - 1
 	}
 	else
 	{
	 	Set MRLMonth=MRLMonth - 1
 	}
 	
 	
 	// vType="1"  "期初累计折旧"
	s MRLLocDR=0
 	f  s MRLLocDR=$o(^DHCEQMonthReportList(0,"LocType",MRLYear,MRLMonth,MRLLocDR))  q:MRLLocDR=""  d
 	.Quit:(##Class(web.DHCEQCommon).LocIsInEQ(QXType,MRLLocDR,CTLOCID,GROUPID)=1)
 	.Quit:(UseLocDR'="")&(UseLocDR'=MRLLocDR)
 	.
 	.;Mozy	科室类型
	.Set flag=0
	.If (LocTypeDR'="") Do
	..If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,MRLLocDR))=0) Set flag=1
	.Quit:flag'=0
 	.
 	.s MRLEquipTypeDR=0
 	.f  s MRLEquipTypeDR=$o(^DHCEQMonthReportList(0,"LocType",MRLYear,MRLMonth,MRLLocDR,MRLEquipTypeDR))  q:MRLEquipTypeDR=""  d
 	..s MRLRowID=0
 	..Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(MRLEquipTypeDR,GROUPID)=1)
 	..f  s MRLRowID=$o(^DHCEQMonthReportList(0,"LocType",MRLYear,MRLMonth,MRLLocDR,MRLEquipTypeDR,MRLRowID))  q:MRLRowID=""  d
 	...s MRLFundsTypeDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",38)
 	...q:(FundsTypeDR'="")&&(FundsTypeDR'=MRLFundsTypeDR)
 	...;s MRLHospital=$p($g(^CTLOC(MRLLocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
 	...s MRLHospital=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(MRLLocDR)    //modify by jyp 2019-10-18 CTLOC调整
 	...i MRLHospital="" s MRLHospital=0
 	...Quit:(HospitalDR'="")&(HospitalDR'=MRLHospital)
 	...s MRLStatCatDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",5)
 	...s MRLOriginalFee=+$p($g(^DHCEQMonthReportList(MRLRowID)),"^",12)+$p($g(^DHCEQMonthReportList(MRLRowID)),"^",19)
 	...s MRLNetFee=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",33)
 	...s DepreTotalBegin=MRLOriginalFee-MRLNetFee	;银川的累计折旧值为原值-净值
 	...s CurDepreTotalBegin=$g(^TempDHCEQ("FundsDepreTotalFee",job,MRLEquipTypeDR,MRLStatCatDR,MRLFundsTypeDR,"1"))
 	...s ^TempDHCEQ("FundsDepreTotalFee",job,MRLEquipTypeDR,MRLStatCatDR,MRLFundsTypeDR,"1")=CurDepreTotalBegin+DepreTotalBegin
	
	
 	// vType="2"  "本期折旧"
 	s MDRowID=0
 	f  s MDRowID=$o(^DHCEQMonthDepre(0,"Month",MonthStr,MDRowID))  q:MDRowID=""  d
	.s MDStatus=$p($g(^DHCEQMonthDepre(MDRowID)),"^",20)	//DJ0136
	.q:MDStatus="3"
 	.q:$p(^DHCEQMonthDepre(MDRowID),"^",3)'="Y"
 	.
 	.Set BIRowID=$Order(^DHCEQBillInfo(0,"SourceType",10,MDRowID,0))
	.Set MDEquipTypeDR=0
	.Set MDStatCatDR=0
	.If BIRowID'=""  Do
	..Set MDEquipTypeDR=$Piece($Get(^DHCEQBillInfo(BIRowID)),"^",3)
	..Set MDStatCatDR=$Piece($Get(^DHCEQBillInfo(BIRowID)),"^",4)
 	.Else  Do
 	..Set EquipID=$Piece($Get(^DHCEQMonthDepre(MDRowID)),"^",1)
 	..Set MDEquipTypeDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",63)
	..Set MDStatCatDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",75)
 	.Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(MDEquipTypeDR,GROUPID)=1)
 	.
 	.s CADRowID=0
 	.s CADFlag=0	//按照资金来源拆分折旧
	.f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADRowID)) q:CADRowID=""  d
	..s CADFlag=CADFlag+1
	..s FundsType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	..i FundsType="" s FundsType=SelfFundsType
	..q:(FundsTypeDR'="")&&(FundsType'=FundsTypeDR)
	..s Depre=+$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	..s StoreLoc=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	..Quit:(##Class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,CTLOCID,GROUPID)=1)
	..;s MDHospitalDR=$p($g(^CTLOC(StoreLoc)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	..s MDHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(StoreLoc)   //modify by jyp 2019-10-18 CTLOC调整
	..i MDHospitalDR="" s MDHospitalDR=0
	..Quit:(UseLocDR'="")&(UseLocDR'=StoreLoc)
	..Quit:(HospitalDR'="")&(HospitalDR'=MDHospitalDR)
	..
	..;Mozy	科室类型
	..Set flag=0
	..If (LocTypeDR'="") Do
	...If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLoc))=0) Set flag=1
	..Quit:flag'=0
	..
	..s CurDepre=$g(^TempDHCEQ("FundsDepreTotalFee",job,MDEquipTypeDR,MDStatCatDR,FundsType,"2"))
	..s ^TempDHCEQ("FundsDepreTotalFee",job,MDEquipTypeDR,MDStatCatDR,FundsType,"2")=CurDepre+Depre
	.
	.i CADFlag=0  d  //无资金来源拆分时全部以自有资金处理
	..q:(FundsTypeDR'="")&&(SelfFundsFlag'=FundsTypeDR)
	..s Depre=$p(^DHCEQMonthDepre(MDRowID),"^",14)
	..s StoreLoc=$p(^DHCEQMonthDepre(MDRowID),"^",33)
	..Quit:(##Class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,CTLOCID,GROUPID)=1)
	..;s MDHospitalDR=$p($g(^CTLOC(StoreLoc)),"^",22)    //modify by jyp 2019-10-18 CTLOC调整
	..s MDHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(StoreLoc)   //modify by jyp 2019-10-18 CTLOC调整
	..i MDHospitalDR="" s MDHospitalDR=0
	..Quit:(UseLocDR'="")&(UseLocDR'=StoreLoc)
	..
	..;Mozy	科室类型
	..Set flag=0
	..If (LocTypeDR'="") Do
	...If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLoc))=0) Set flag=1
	..Quit:flag'=0
	..
	..s CurDepre=$g(^TempDHCEQ("FundsDepreTotalFee",job,MDEquipTypeDR,MDStatCatDR,FundsType,"2"))
	..s ^TempDHCEQ("FundsDepreTotalFee",job,MDEquipTypeDR,MDStatCatDR,FundsType,"2")=CurDepre+Depre
 	
	
 	// vType="3"  "转移增加"
	// vType="4"  "转移减少"
	Set EquipTypeDR=0
	For  Set EquipTypeDR=$Order(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR)) Quit:EquipTypeDR=""  Do
	.Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GROUPID)=1)
	.Quit:##Class(web.DHCEQCommon).IdInIds(EquipTypeDR,EquipTypeIDs)=0
	.Set BillDate=StartDate-1
	.For  Set BillDate=$Order(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate)) Quit:((BillDate="")||(BillDate>EndDate))  Do
	..Set rowid=0
	..For  Set rowid=$Order(^DHCEQStoreMove(0,"TypeDate",EquipTypeDR,BillDate,rowid)) Quit:(rowid="")  Do
	...Set FromLocDR=$Piece($Get(^DHCEQStoreMove(rowid)),"^",2)
	...;Set FromHospitalDR=$Piece($Get(^CTLOC(FromLocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	...Set FromHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(FromLocDR)  //modify by jyp 2019-10-18 CTLOC调整
	...Set ToLocDR=$Piece($Get(^DHCEQStoreMove(rowid)),"^",3)
	...;Set ToHospitalDR=$Piece($Get(^CTLOC(ToLocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	...Set ToHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(ToLocDR)  //modify by jyp 2019-10-18 CTLOC调整
	...Quit:(UseLocDR'="")&(UseLocDR'=FromLocDR)
	...Quit:(UseLocDR'="")&(UseLocDR'=ToLocDR)
	...Quit:(HospitalDR'="")&(HospitalDR'=FromHospitalDR)
	...Quit:(HospitalDR'="")&(HospitalDR'=ToHospitalDR)
	...
	...;Mozy	科室类型
	...Set flag=0
	...If (LocTypeDR'="") Do
	....If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,FromLocDR))=0) Set flag=1
	....If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,ToLocDR))=0) Set flag=1
	...Quit:flag'=0
	...
	...Set ListRowID=0
	...For  Set ListRowID=$Order(^DHCEQStoreMoveList(0,"StoreMove",rowid,ListRowID)) Quit:(ListRowID="")  Do
	....Set BIRowID=$Order(^DHCEQBillInfo(0,"SourceType",4,ListRowID,0))
	....Set StatCatDR=0
	....If BIRowID'="" Do
	.....Set StatCatDR=$Piece($Get(^DHCEQBillInfo(BIRowID)),"^",4)
	....Else  Do
	.....If $Data(^DHCEQStoreMoveList(ListRowID,"EX","RowIDs")) Do
	......Set EquipID=$Piece($Get(^DHCEQStoreMoveList(ListRowID,"EX","RowIDs")),",",1)
	......Set StatCatDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",75)
	.....
	....Set RowID=0
	....For  Set RowID=$Order(^DHCEQFunds(0,"Source",4,ListRowID,RowID)) Quit:(RowID="")  Do
	.....Set FundsType=$Piece($Get(^DHCEQFunds(RowID)),"^",2)
	.....Set DepreTotal=+$Piece($Get(^DHCEQFunds(RowID)),"^",13)
	.....
	.....Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"3"))
	.....Set ^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"3")=CurDepreTotal+DepreTotal
	.....Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"4"))
	.....Set ^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"4")=CurDepreTotal+DepreTotal
	
	
	// vType="5"  "调账增加"
	// vType="6"  "调账减少"
	Set EquipTypeDR=0
	For  Set EquipTypeDR=$Order(^DHCEQChangeAccount(0,"TypeDate",EquipTypeDR)) Quit:EquipTypeDR=""  Do
	.Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GROUPID)=1)
	.Quit:##Class(web.DHCEQCommon).IdInIds(EquipTypeDR,EquipTypeIDs)=0
	.Set BillDate=StartDate-1
	.For  Set BillDate=$Order(^DHCEQChangeAccount(0,"TypeDate",EquipTypeDR,BillDate)) Quit:((BillDate="")||(BillDate>EndDate))  Do
	..Set rowid=0
	..For  Set rowid=$Order(^DHCEQChangeAccount(0,"TypeDate",EquipTypeDR,BillDate,rowid)) Quit:((rowid=""))  Do
	...Set LocDR=$Piece($Get(^DHCEQChangeAccount(rowid)),"^",29)
	...;Set THospitalDR=$Piece($Get(^CTLOC(LocDR)),"^",22)    //modify by jyp 2019-10-18 CTLOC调整
	...Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)   //modify by jyp 2019-10-18 CTLOC调整
	...Quit:(UseLocDR'="")&(UseLocDR'=LocDR)
	...Quit:(HospitalDR'="")&(HospitalDR'=THospitalDR)
	...
	...;Mozy	科室类型
	...Set flag=0
	...If (LocTypeDR'="") Do
	....If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,LocDR))=0) Set flag=1
	...Quit:flag'=0
	...
	...Set BIRowID=$Order(^DHCEQBillInfo(0,"SourceType",7,rowid,0))
	...Set StatCatDR=0
	...If BIRowID'="" Do
	....Set StatCatDR=$Piece($Get(^DHCEQBillInfo(BIRowID)),"^",4)
	...Else  Do
	....Set EquipID=$Piece($Get(^DHCEQChangeAccount(rowid)),"^",1)
	....Set StatCatDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",75)
	...Set RowID=0
	...For  Set RowID=$Order(^DHCEQFunds(0,"Source",7,rowid,RowID)) Quit:(RowID="")  Do
	....Set FundsType=$Piece($Get(^DHCEQFunds(RowID)),"^",2)
	....Set DepreTotal=+$Piece($Get(^DHCEQFunds(RowID)),"^",13)
	....
	....If DepreTotal>0 Do
	.....Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"5"))
	.....Set ^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"5")=CurDepreTotal+DepreTotal
	....Else  Do
	.....Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"6"))
	.....Set ^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"6")=CurDepreTotal-DepreTotal
	
	
	// vType="7"  "退货减少"
	//汇总减少信息
	Set EquipTypeDR=0
	For  Set EquipTypeDR=$Order(^DHCEQReturn(0,"TypeDate",EquipTypeDR)) Quit:EquipTypeDR=""  Do
	.Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GROUPID)=1)
	.Quit:##Class(web.DHCEQCommon).IdInIds(EquipTypeDR,EquipTypeIDs)=0
	.Set OutType=0
	.For  Set OutType=$Order(^DHCEQReturn(0,"TypeDate",EquipTypeDR,OutType)) Quit:OutType=""  Do
	..Set OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",1)
	..Set BillDate=StartDate-1
	..For  Set BillDate=$Order(^DHCEQReturn(0,"TypeDate",EquipTypeDR,OutType,BillDate)) Quit:((BillDate="")||(BillDate>EndDate))  Do
	...Set rowid=0
	...For  Set rowid=$Order(^DHCEQReturn(0,"TypeDate",EquipTypeDR,OutType,BillDate,rowid)) Quit:(rowid="")  Do
	....Set StoreLoc=$Piece($Get(^DHCEQReturn(rowid)),"^",2)
	....;Set THospitalDR=$Piece($Get(^CTLOC(StoreLoc)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	....Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(StoreLoc)   //modify by jyp 2019-10-18 CTLOC调整
	....Quit:(UseLocDR'="")&(UseLocDR'=StoreLoc)
	....Quit:(HospitalDR'="")&(HospitalDR'=THospitalDR)
	....
	....;Mozy	科室类型
	....Set flag=0
	....If (LocTypeDR'="") Do
	.....If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLoc))=0) Set flag=1
	....Quit:flag'=0
	....
	....Set ListRowID=0
	....For  Set ListRowID=$Order(^DHCEQReturnList(0,"Return",rowid,ListRowID)) Quit:(ListRowID="")  Do
	.....Set BIRowID=$Order(^DHCEQBillInfo(0,"SourceType",5,ListRowID,0))
	.....Set StatCatDR=0
	.....If BIRowID'="" Do
	......Set StatCatDR=$Piece($Get(^DHCEQBillInfo(BIRowID)),"^",4)
	.....Else  Do
	......If $Data(^DHCEQReturnList(ListRowID,"EX","RowIDs")) Do
	.......Set EquipID=$Piece($Get(^DHCEQReturnList(ListRowID,"EX","RowIDs")),",",1)
	.......Set StatCatDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",75)
	.....
	.....Set RowID=0
	.....For  Set RowID=$Order(^DHCEQFunds(0,"Source",5,ListRowID,RowID)) Quit:(RowID="")  Do
	......Set FundsType=$Piece($Get(^DHCEQFunds(RowID)),"^",2)
	......Set DepreTotal=+$Piece($Get(^DHCEQFunds(RowID)),"^",13)
	......
	......Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"7"))
	......Set ^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"7")=CurDepreTotal+DepreTotal
	
	
	// vType="8"  "报废减少"
	Set EquipTypeDR=0
	For  Set EquipTypeDR=$Order(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR)) Quit:EquipTypeDR=""  Do
	.Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GROUPID)=1)
	.Quit:##Class(web.DHCEQCommon).IdInIds(EquipTypeDR,EquipTypeIDs)=0
	.Set BillDate=StartDate-1
	.For  Set BillDate=$Order(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR,BillDate)) Quit:((BillDate="")||(BillDate>EndDate))  Do
	..Set rowid=0
	..For  Set rowid=$Order(^DHCEQDisuseRequest(0,"TypeDate",EquipTypeDR,BillDate,rowid)) Quit:((rowid=""))  Do
	...Quit:$Piece($Get(^DHCEQDisuseRequest(rowid)),"^",10)'=2
	...Set StoreLoc=$Piece($Get(^DHCEQDisuseRequest(rowid)),"^",3)
	...;Set THospitalDR=$Piece($Get(^CTLOC(StoreLoc)),"^",22)  //modify by jyp 2019-10-18 CTLOC调整
	...Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(StoreLoc)    //modify by jyp 2019-10-18 CTLOC调整
	...Quit:(UseLocDR'="")&(UseLocDR'=StoreLoc)
	...Quit:(HospitalDR'="")&(HospitalDR'=THospitalDR)
	...
	...;Mozy	科室类型
	...Set flag=0
	...If (LocTypeDR'="") Do
	....If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLoc))=0) Set flag=1
	...Quit:flag'=0
	...
	...Set ListRowID=0
	...For  Set ListRowID=$Order(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) Quit:(ListRowID="")  Do
	....Set BIRowID=$Order(^DHCEQBillInfo(0,"SourceType",6,ListRowID,0))
	....Set StatCatDR=0
	....If BIRowID'="" Do
	.....Set StatCatDR=$Piece($Get(^DHCEQBillInfo(BIRowID)),"^",4)
	....Else  Do
	.....Set EquipID=$Piece($Get(^DHCEQDisuseRequestList(ListRowID)),"^",2)
	.....Set StatCatDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",75)
	....Set RowID=0
	....For  Set RowID=$Order(^DHCEQFunds(0,"Source",6,ListRowID,RowID)) Quit:(RowID="")  Do
	.....Set FundsType=$Piece($Get(^DHCEQFunds(RowID)),"^",2)
	.....Set DepreTotal=+$Piece($Get(^DHCEQFunds(RowID)),"^",13)
	.....
	.....Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"8"))
	.....Set ^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,FundsType,"8")=CurDepreTotal+DepreTotal
	
	
	// vType="9"  "调整增加"
	// vType="10"  "调整减少"
 	Set BillDate=StartDate-1	
	For  Set BillDate=$Order(^DHCEQAdjustData(0,"FlagDate","Y",BillDate)) Quit:((BillDate="")||(BillDate>EndDate))  Do
	.Set AdjustType=0
	.For  Set AdjustType=$Order(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType)) Quit:((AdjustType=""))  Do
	..Set rowid=0
	..For  Set rowid=$Order(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType,rowid)) Quit:((rowid=""))  Do
	...Set ADStatus=$Piece($Get(^DHCEQAdjustData(rowid)),"^",11)
	...Quit:ADStatus'="1"
	...Set ListRowID=0
	...For  Set ListRowID=$Order(^DHCEQAdjustDataList(0,"AdjustData",rowid,ListRowID)) Quit:((ListRowID=""))  Do
	....Set FromStoreLoc=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",3)
	....Set FromEquipType=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",4)
	....Set FromStatCat=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",5)
	....Set FromOrigin=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",6)
	....Set ToStoreLoc=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",8)
	....Set ToEquipType=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",9)
	....Set ToStatCat=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",10)
	....Set ToOrigin=$Piece($Get(^DHCEQAdjustDataList(ListRowID)),"^",11)
	....Quit:(UseLocDR'="")&(UseLocDR'=FromStoreLoc)
	....Quit:(UseLocDR'="")&(UseLocDR'=ToStoreLoc)
	....
	....;Mozy	科室类型
	....Set flag=0
	....If (LocTypeDR'="") Do
	.....If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,FromStoreLoc))=0) Set flag=1
	.....If ($Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,ToStoreLoc))=0) Set flag=1
	....Quit:flag'=0
	....
	....Set (FromFlag,ToFlag)=1
	....If FromEquipType'="" Set FromFlag=##Class(web.DHCEQCommon).EquipTypeIsIn(FromEquipType,GROUPID)
	....If ToEquipType'="" Set ToFlag=##Class(web.DHCEQCommon).EquipTypeIsIn(ToEquipType,GROUPID)
	....Quit:(FromFlag+ToFlag)=2
	....Set (FromFlag,ToFlag)=0
	....If FromEquipType'="" Set FromFlag=##Class(web.DHCEQCommon).IdInIds(FromEquipType,EquipTypeIDs)
	....If ToEquipType'="" Set ToFlag=##Class(web.DHCEQCommon).IdInIds(ToEquipType,EquipTypeIDs)
	....Quit:(FromFlag+ToFlag)=0
	....;; 1:调整数据 2:新增数据 3:删除数据 4.取消报废 9.其他调整
	....If (AdjustType="1")||(AdjustType="3") Do
	.....;Set FromHospitalDR=$Piece($Get(^CTLOC(FromStoreLoc)),"^",22)    //modify by jyp 2019-10-18 CTLOC调整
	.....Set FromHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(FromStoreLoc)   //modify by jyp 2019-10-18 CTLOC调整
	.....Quit:(HospitalDR'="")&(HospitalDR'=FromHospitalDR)
	.....Set RowID=0
	.....For  Set RowID=$Order(^DHCEQFunds(0,"Source",9,ListRowID,RowID)) Quit:(RowID="")  Do
	......Set FundsType=$Piece($Get(^DHCEQFunds(RowID)),"^",2)
	......Set DepreTotal=+$Piece($Get(^DHCEQFunds(RowID)),"^",13)
	......Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,FromEquipType,FromStatCat,FundsType,"10"))
	......Set ^TempDHCEQ("FundsDepreTotalFee",job,FromEquipType,FromStatCat,FundsType,"10")=CurDepreTotal+DepreTotal
	....
	....If (AdjustType="1")||(AdjustType="2")||(AdjustType="4") Do
	.....;Set ToHospitalDR=$Piece($Get(^CTLOC(ToStoreLoc)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	.....Set ToHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(ToStoreLoc)   //modify by jyp 2019-10-18 CTLOC调整
	.....Quit:(HospitalDR'="")&(HospitalDR'=ToHospitalDR)
	.....For  Set RowID=$Order(^DHCEQFunds(0,"Source",9,ListRowID,RowID)) Quit:(RowID="")  Do
	......Set FundsType=$Piece($Get(^DHCEQFunds(RowID)),"^",2)
	......Set DepreTotal=+$Piece($Get(^DHCEQFunds(RowID)),"^",13)
	......Set CurDepreTotal=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,ToEquipType,ToStatCat,FundsType,"9"))
	......Set ^TempDHCEQ("FundsDepreTotalFee",job,ToEquipType,ToStatCat,FundsType,"9")=CurDepreTotal+DepreTotal
 	
 	
 	//输出
 	Set EquipTypeDR=0
 	For  Set EquipTypeDR=$Order(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR)) Quit:EquipTypeDR=""  Do
 	.Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
 	.Set StatCatDR=""
 	.For  Set StatCatDR=$Order(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR)) Quit:StatCatDR=""  Do
 	..Set TStatCat=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
 	..Set TFundsTypeDR=0
 	..For  Set TFundsTypeDR=$Order(^DHCEQCCode("DHCEQCFundsType",TFundsTypeDR)) Quit:TFundsTypeDR=""  Do
 	...Quit:$Piece($Get(^DHCEQCCode("DHCEQCFundsType",TFundsTypeDR)),"^",4)'="N"
 	...;Set TFundsType=$Piece($Get(^DHCEQCCode("DHCEQCFundsType",TFundsTypeDR)),"^",2)
 	...Set TFundsType=TFundsTypeDR
 	...Set (TDepreTotalBegin, TDepre, TSMAdd, TSMReduce, TCAAdd, TCAReduce, TRtnReduce, TDisuseReduce, TADAdd, TADReduce)=0
 	...
 	...;期初累计折旧
 	...Set TDepreTotalBegin=0
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,1)) Set TDepreTotalBegin=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,1))
 	...
 	...;本期折旧增加
 	...Set TDepre=0
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,2)) Set TDepre=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,2))
 	...
 	...;本期调拨增加
 	...;;=decimal(Report.TSMAdd1)+decimal(Report.TCAAdd1)+decimal(Report.TADAdd1)
  	...Set OtherAdd=0
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,3)) Do
 	....Set TSMAdd=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,3))
 	....Set OtherAdd=TSMAdd
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,5)) Do
 	....Set TCAAdd=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,5))
 	....Set OtherAdd=OtherAdd+TCAAdd
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,9)) Do
 	....Set TADAdd=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,9))
 	....Set OtherAdd=OtherAdd+TADAdd
 	...
 	...;本期报废减少
 	...Set TDisuseReduce=0
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,8)) Set TDisuseReduce=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,8))
 	...
 	...;本期退货减少
 	...Set TRtnReduce=0
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,7)) Set TRtnReduce=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,7))
 	...
 	...;本期调拨减少
 	...;;=decimal(Report.TSMReduce1)+decimal(Report.TCAReduce1)+decimal(Report.TADReduce1)
 	...Set OtherReduce=0
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,4)) Do
 	....Set TSMReduce=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,4))
 	....Set OtherReduce=TSMReduce
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,6)) Do
 	....Set TCAReduce=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,6))
 	....Set OtherReduce=OtherReduce+TCAReduce
 	...If $Data(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,10)) Do
 	....Set TADReduce=+$Get(^TempDHCEQ("FundsDepreTotalFee",job,EquipTypeDR,StatCatDR,TFundsTypeDR,10))
 	....Set OtherReduce=OtherReduce+TADReduce
 	...
 	...;本期累计折旧
 	...Set TDepreTotalEnd=TDepreTotalBegin + TDepre + OtherAdd - TDisuseReduce - TRtnReduce - OtherReduce
 	...
 	...Do OutputRowGetFundsDepreTotalFee
	
 	Kill ^TempDHCEQ("FundsDepreTotalFee",job)
 	
	Quit $$$OK
OutputRowGetFundsDepreTotalFee
	Set TDepreTotalBegin=##Class(web.DHCEQCommon).FormatNumber(TDepreTotalBegin,"",2)
	Set TDepre=##Class(web.DHCEQCommon).FormatNumber(TDepre,"",2)
	Set OtherAdd=##Class(web.DHCEQCommon).FormatNumber(OtherAdd,"",2)
	Set TDisuseReduce=##Class(web.DHCEQCommon).FormatNumber(TDisuseReduce,"",2)
	Set TRtnReduce=##Class(web.DHCEQCommon).FormatNumber(TRtnReduce,"",2)
	Set OtherReduce=##Class(web.DHCEQCommon).FormatNumber(OtherReduce,"",2)
	Set TDepreTotalEnd=##Class(web.DHCEQCommon).FormatNumber(TDepreTotalEnd,"",2)
	Set TFee=TDepreTotalBegin_"^"_TDepre_"^"_OtherAdd_"^"_TDisuseReduce_"^"_TRtnReduce_"^"_OtherReduce_"^"_TDepreTotalEnd
	
	; TEquipType:%String,TStatCat:%String,TType:%String,TFundsType:%String,TDepreTotalBegin:%String,TDepre:%String,TSMAdd:%String,TSMReduce:%String,TCAAdd:%String,TCAReduce:%String,TRtnReduce:%String,TDisuseReduce:%String,TADAdd:%String,TADReduce:%String,TDepreTotalEnd:%String
	Set Data=$lb(TEquipType,TStatCat,TFundsType,TFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod FundsDepreTotalFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FundsDepreTotalFeeExecute ]
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

ClassMethod FundsDepreTotalFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FundsDepreTotalFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

/// Mozy	2013-9-10  Mozy0106
/// 科室领用资产汇总查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","LocUsedMonthReport")
Query LocUsedMonthReport(MonthStr As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", StartDate As %String = "", EndDate As %String = "", EquipTypeDR As %String = "") As %Query(ROWSPEC = "TJob:%String,TEquipType:%String,TFromLoc:%String,TToLoc:%String,TQuantityNum:%String,TAmount:%String,TRow:%String")
{
}

ClassMethod LocUsedMonthReportExecute(ByRef qHandle As %Binary, MonthStr As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", StartDate As %String = "", EndDate As %String = "", EquipTypeDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	Set StartDate=+StartDate
 	if (EndDate="") s EndDate=+$H
 	Set Todate=+$H
 	Set TRow=0
	Set index=2
	Set TJob=$job
	Kill ^TempDHCEQ("LocUsedMonthReport",TJob)
	Kill ^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob)
	
	;;;	设备
	Set TToLocDR=0
	For  Set TToLocDR=$Order(^DHCEQStoreMove(0,"ToLoc",TToLocDR)) Quit:TToLocDR=""  Do
	.Quit:(ToLocDR'="")&(ToLocDR'=TToLocDR)
	.Set SMRowid=0
	.For  Set SMRowid=$Order(^DHCEQStoreMove(0,"ToLoc",TToLocDR,SMRowid)) Quit:SMRowid=""  Do
	..Set TEquipTypeDR=$Piece($Get(^DHCEQStoreMove(SMRowid)),"^",16)
	..Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	..Quit:(EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
	..Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	..Set TStatus=$Piece($Get(^DHCEQStoreMove(SMRowid)),"^",13)
	..Quit:(TStatus'=2)
	..Set TInAckDate=$Piece($Get(^DHCEQStoreMove(SMRowid)),"^",10)
	..Quit:(StartDate'="")&(StartDate>TInAckDate)
	..Quit:(EndDate'="")&(TInAckDate>EndDate)
	..Set TFromLocDR=$Piece($Get(^DHCEQStoreMove(SMRowid)),"^",2)
	..Quit:(FromLocDR'="")&(FromLocDR'=TFromLocDR)
	..;合计转移单数量及总金额
	..Set SumQty=0
	..Set SumAmount=0
	..Set SMLRowid=0
	..For  Set SMLRowid=$Order(^DHCEQStoreMoveList(0,"StoreMove",SMRowid,SMLRowid)) Quit:SMLRowid=""  Do
	...Set TOriginalFee=$Piece($Get(^DHCEQStoreMoveList(SMLRowid)),"^",7)
	...Set TQuantityNum=$Piece($Get(^DHCEQStoreMoveList(SMLRowid)),"^",8)
	...Set TAmount=TOriginalFee*TQuantityNum
	...Set SumQty=SumQty+TQuantityNum
	...Set SumAmount=SumAmount+TAmount
	..
	..Set TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLocDR)
	..Set TFromLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TFromLoc,"-")
	..Set TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLocDR)
	..Set TToLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TToLoc,"-")
	..;转移类型
	..Set TMoveType=$Piece($Get(^DHCEQStoreMove(SMRowid)),"^",12)
	..If TMoveType=1 Do
	...;科室调配参照正常出库,不处理调出科室的数据
	..If TMoveType=3 Do
	...;返库
	...Set SumQty=-1*SumQty
	...Set SumAmount=-1*SumAmount
	..
	..If $Data(^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc)) Do
 	...Set Info=$Get(^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc))
 	...Set SumQty=SumQty+$Piece(Info,"^",1)
	...Set SumAmount=SumAmount+$Piece(Info,"^",2)
	..Set ^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc)=SumQty_"^"_SumAmount
	
	;输出
	;^TempDHCEQ("LocUsedMonthReport","ReportEx",3824,"专用设备","设备仓","CT室")
	Set (SumQty,SumAmount)=0
	Set TEquipType=""
	For  Set TEquipType=$Order(^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob,TEquipType)) Quit:TEquipType=""  Do
	.Set TFromLoc=""
	.For  Set TFromLoc=$Order(^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc)) Quit:TFromLoc=""  Do
	..Set TToLoc=""
	..For  Set TToLoc=$Order(^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc)) Quit:TToLoc=""  Do
	...Set Info=$Get(^TempDHCEQ("LocUsedMonthReport","ReportEx",TJob,TEquipType,TFromLoc,TToLoc))
	...Set TQuantityNum=+$Piece(Info,"^",1)
	...Set TAmount=+$Piece(Info,"^",2)
	...Set SumQty=SumQty+TQuantityNum
	...Set SumAmount=SumAmount+TAmount
	...Set TRow=TRow+1
	...Do OutputRowLocUsedMonthReport
	
	Do ResetVariablesLocUsedMonthReport
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	If TotalFlag="1" Set index=1
	Set TRow="合计"
	Set TAmount=SumAmount
	Set TQuantityNum=SumQty
	Set TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
	Set Data=$lb(TJob,TEquipType,TFromLoc,TToLoc,TQuantityNum,TAmount,TRow)
	Set ^TempDHCEQ("LocUsedMonthReport",TJob,index)="合计^"_TFromLoc_"^"_TToLoc_"^"_TQuantityNum_"^"_TAmount
	Set ^CacheTemp(repid,index)=Data
	
	Quit $$$OK
OutputRowLocUsedMonthReport
	Set TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
	
	Set Data=$lb(TJob,TEquipType,TFromLoc,TToLoc,TQuantityNum,TAmount,TRow)
	Set ^TempDHCEQ("LocUsedMonthReport",TJob,index)=TEquipType_"^"_TFromLoc_"^"_TToLoc_"^"_TQuantityNum_"^"_TAmount
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesLocUsedMonthReport
	Set (TEquipType,TFromLoc,TToLoc,TQuantityNum,TAmount)=""
	Quit
}

ClassMethod LocUsedMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocUsedMonthReportExecute ]
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

ClassMethod LocUsedMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocUsedMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQReportEx).GetOneLocUsedMonthReport(0,3824)
ClassMethod GetOneLocUsedMonthReport(PNum As %Library.String = "", job As %Library.String = "")
{
	Quit:(PNum="")||(job="") ""
	;^TempDHCEQ("LocUsedMonthReport",3824,3) = "专用设备^设备仓^放射科^4^40000.00" 
	Quit:PNum=0 $Order(^TempDHCEQ("LocUsedMonthReport",job,""),-1)
	Quit $g(^TempDHCEQ("LocUsedMonthReport",job,PNum))
}

/// 20140527  Mozy0131  待验证2014-08-07??
/// 资产资金来源折旧科室表
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","FundsDepreLoc")
Query FundsDepreLoc(UseLocDR As %String = "", EquipTypeDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", BeginDate As %String = "", EndDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", LocIncludeFlag As %String = "", FundsTypeDR As %String = "") As %Query(ROWSPEC = "TStoreLoc:%String,TOriginalFee:%String,TDepreFee:%String,TDepreYearFee:%String,TDepreTotal:%String,TNetFee:%String,TJob:%String,TEquipType:%String,TStatCat:%String,TFundsType:%String")
{
}

ClassMethod FundsDepreLocExecute(ByRef qHandle As %Binary, UseLocDR As %String = "", EquipTypeDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", BeginDate As %String = "", EndDate As %String = "", IncludeFlag As %String = "", MonthStr As %String = "", LocIncludeFlag As %String = "", FundsTypeDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	If MonthStr="" Quit $$$OK
 	Set Year=+$Piece(MonthStr,"-",1)
 	Set Month=+$Piece(MonthStr,"-",2)
 	If Month<10
 	{
	 	Set MonthStr=Year_"-0"_Month
 	}
 	Else
 	{
	 	Set MonthStr=Year_"-"_Month
 	}
 	// 取下个月的快照日期(月初)
 	If Month=12
 	{
	 	Set Year=1+Year
	 	Set SnapShotDate=Year_"-01-01"
 	}
 	Else
 	{
	 	Set Month=1+Month
	 	Set SnapShotDate=Year_"-"_Month_"-01"
 	}
 	Set SnapShotDate=$ZDH(SnapShotDate,3)
 	
 	Set SeniorLocFlag=""
 	Set TempNode="ReportEx.FundsDepreLoc"
 	Do ##class(web.DHCEQCommon).KillTempGlobal(TempNode)
 	Set ToDate=+$H
	Set index=2
	Set TJob=$j
	Set EquipTypeIDs=","_EquipTypeIDs_","
	Kill ^TempDHCEQ("ReportEx","FundsDepreLoc",TJob)
	
	Set (SumAmount,SumDepreFee,SumDepreYearFee,SumDepreTotal,SumNetFee)=0
	Set TDepreYearFee=0
	Set TStoreLoc = "zzzz-zzzz"		;排序最末位置
	
	Set SnapShotID=0
	For  Set SnapShotID=$Order(^DHCEQSnapShot(SnapShotID)) Quit:SnapShotID=""  Do
	.Quit:SnapShotDate'=$Piece($Get(^DHCEQSnapShot(SnapShotID,"Begin")),",",1)
	.Set EquipID=0
	.For  Set EquipID=$Order(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)) Quit:EquipID=""  Do
	..;出库状态,无效标志
	..Set StockStatus=$Piece(^DHCEQSnapShot(SnapShotID,"Equip",EquipID),"^",60)
	..Quit:((StockStatus="3")||(StockStatus="0"))
	..;过滤掉报废的
	..Set Status=$Piece(^DHCEQSnapShot(SnapShotID,"Equip",EquipID),"^",38)
	..Quit:(Status="3")
	..;过滤掉无效的
	..Set InvalidFlag=$Piece(^DHCEQSnapShot(SnapShotID,"Equip",EquipID),"^",59)
	..Quit:InvalidFlag="Y"
	..Quit:((UseLocDR'="")&(LocIncludeFlag'="on")&(UseLocDR'=$p(^DHCEQSnapShot(SnapShotID,"Equip",EquipID),"^",67)))  ;库房
	..Quit:(LocIncludeFlag="on")&(UseLocDR'="")&(##Class(web.DHCEQEquip).CheckIsChildLoc(UseLocDR,$Piece(^DHCEQSnapShot(SnapShotID,"Equip",EquipID),"^",67),"1")'="1")
	..
	..Set TEquipTypeDR=$Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)),"^",63)
	..Quit:(EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
	..Quit:(EquipTypeIDs'=",,")&(EquipTypeIDs'[(","_TEquipTypeDR_","))
	..Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	..Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	..Set TStatCatDR=$Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)),"^",75)
	..Set TStatCat=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	..
	..Set TStoreLocDR=$Piece(^DHCEQSnapShot(SnapShotID,"Equip",EquipID),"^",67)
	..If TStoreLocDR'="" d
	...;i (SeniorLocFlag="on") s TStoreLocDR=##Class(web.DHCEQCTreeMap).GetSeniorLoc(TStoreLocDR)
	...;If TStoreLocDR'=0 Set TStoreLoc = $Piece($Get(^CTLOC(TStoreLocDR)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	...If TStoreLocDR'=0 Set TStoreLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)  //modify by jyp 2019-10-18 CTLOC调整
	...
	..;过滤本月入库的设备
	..Set StartDate=$Piece(^DHCEQSnapShot(SnapShotID,"Equip",EquipID),"^",45)	///TransAssetDate	//上账日期(导入数据)
	..Set TInStockListDR = $Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)),"^",70)
	..If TInStockListDR'="" Do
	...Set TInStockDR=$Piece($Get(^DHCEQInStockList(TInStockListDR)),"^",1)
	...Set StartDate=$Piece($Get(^DHCEQInStock(TInStockDR)),"^",13)	//入库账务审核日期
	..;Quit:(StartDate'<$ZDH(MonthStr_"-01",3))
	..
	..Set SnapID=""
	..For  Set SnapID=$Order(^DHCEQSnapShot(SnapShotID,"Funds",EquipID,SnapID)) Quit:(SnapID="")  Do
	...Quit:($Piece(^DHCEQSnapShot(SnapShotID,"Funds",EquipID,SnapID),"^",10)'="N")
	...Set TFundsTypeDR=$Piece(^DHCEQSnapShot(SnapShotID,"Funds",EquipID,SnapID),"^",2)
	...Quit:(FundsTypeDR'="")&(FundsTypeDR'=TFundsTypeDR)
	...Set TOriginalFee=+$Piece(^DHCEQSnapShot(SnapShotID,"Funds",EquipID,SnapID),"^",3)
	...Set TDepreTotal=+$Piece(^DHCEQSnapShot(SnapShotID,"Funds",EquipID,SnapID),"^",13)
	...Set TNetFee=TOriginalFee-TDepreTotal
	...
	...Set TempData=$Get(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,TStoreLoc,TFundsTypeDR))
	...Set TOriginalFee=TOriginalFee+$Piece(TempData,"^",1)
	...Set TDepreFee=+$Piece(TempData,"^",2)
	...Set TDepreYearFee=TDepreYearFee+$Piece(TempData,"^",3)
	...Set TDepreTotal=TDepreTotal+$Piece(TempData,"^",4)
	...Set TNetFee=TNetFee+$Piece(TempData,"^",5)
	...Set ^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,TStoreLoc,TFundsTypeDR,TEquipType,TStatCat)=TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee
	
	;折旧额-取折旧时的数据	20141113  Mozy0146
	;^DHCEQMonthDepre(0,"AuditDate","Y",62536,1)=
	Set TSourceTypeID=0
	Set EquipTypeIDs=","_EquipTypeIDs_","
	Set CADDR=0
	For  Set CADDR=$Order(^DHCEQCostAllotDetail(CADDR)) Quit:CADDR=""  Do
	.Set MonthDepreDR = $Piece($Get(^DHCEQCostAllotDetail(CADDR)),"^",2)
	.Quit:$Piece($Get(^DHCEQMonthDepre(MonthDepreDR)),"^",39)'=""	;冲负记录
	.Quit:(MonthStr '= $Piece($Get(^DHCEQMonthDepre(MonthDepreDR)),"^",6))
	.Set EquipID = $Piece($Get(^DHCEQMonthDepre(MonthDepreDR)),"^",1)
	.;Set MonthStr=$Piece($zd(MDAuditDate,3),"-",1,2)
	.Set SnapShotID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	.Quit:SnapShotID=""
	.Set TEquipTypeDR = $Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)),"^",63)
	.Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	.Quit:(EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
	.Quit:(EquipTypeIDs'=",,")&(EquipTypeIDs'[(","_TEquipTypeDR_","))
	.Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Set TStatCatDR=$Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)),"^",75)
	.Set TStatCat=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.
	.Set TStoreLocDR = $Piece($Get(^DHCEQCostAllotDetail(CADDR)),"^",3)	;提取折旧时的所属科室
	.;Set TUseLocDR = $Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipDR)),"^",67)
	.Quit:(UseLocDR'="")&(UseLocDR'=TStoreLocDR)
	.;If TStoreLocDR'=0 Set TStoreLoc = $Piece($Get(^CTLOC(TStoreLocDR)),"^",2)    //modify by jyp 2019-10-18 CTLOC调整
	.If TStoreLocDR'=0 Set TStoreLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	.Set TFundsTypeDR = $Piece($Get(^DHCEQCostAllotDetail(CADDR)),"^",7)
	.Quit:(FundsTypeDR'="")&(FundsTypeDR'=TFundsTypeDR)
	.Set TDepreFee = +$Piece($Get(^DHCEQCostAllotDetail(CADDR)),"^",5)
	.
	.Set TempData=$Get(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,TStoreLoc,TFundsTypeDR,TEquipType,TStatCat))
	.Set TOriginalFee=+$Piece(TempData,"^",1)
	.Set TDepreFee=TDepreFee+$Piece(TempData,"^",2)
	.Set TDepreYearFee=+$Piece(TempData,"^",3)
	.Set TDepreTotal=+$Piece(TempData,"^",4)
	.Set TNetFee=+$Piece(TempData,"^",5)
	.Set ^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,TStoreLoc,TFundsTypeDR,TEquipType,TStatCat)=TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee
	
	;处理折旧值冲负
	Set MDRowID=0
	For  Set MDRowID=$Order(^DHCEQMonthDepre(0,"Month",MonthStr,MDRowID)) Quit:MDRowID=""  Do
	.s MDStatus=$p($g(^DHCEQMonthDepre(MDRowID)),"^",20)	//DJ0136
	.q:MDStatus="3"
	.Quit:$Piece($Get(^DHCEQMonthDepre(MDRowID)),"^",39)=""
	.;20141113  Mozy0146
	.Set SnapShotID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	.Set EquipID=$Piece($Get(^DHCEQMonthDepre(MDRowID)),"^",2)
	.Set TEquipTypeDR=$Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)),"^",63)
	.Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Set TStatCatDR=$Piece($Get(^DHCEQSnapShot(SnapShotID,"Equip",EquipID)),"^",75)
	.Set TStatCat=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.
	.Set CADRowID=""
	.For  Set CADRowID=$Order(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADRowID)) Quit:(CADRowID="")  Do
	..Set TStoreLocDR = $Piece($Get(^DHCEQCostAllotDetail(CADDR)),"^",3)	;提取折旧时的所属科室
	..;If TStoreLocDR'=0 Set TStoreLoc = $Piece($Get(^CTLOC(TStoreLocDR)),"^",2)    //modify by jyp 2019-10-18 CTLOC调整
	..If TStoreLocDR'=0 Set TStoreLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	..Set TDepreFee = +$Piece($Get(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	..Set TFundsTypeDR=$Piece($Get(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	..
	..Set TempData=$Get(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,TStoreLoc,TFundsTypeDR,TEquipType,TStatCat))
	..Set TOriginalFee=$Piece(TempData,"^",1)
	..Set TDepreYearFee=TDepreFee+$Piece(TempData,"^",3)
	..Set TDepreTotal=TDepreFee+$Piece(TempData,"^",4)
	..Set TDepreFee=TDepreFee+$Piece(TempData,"^",2)
	..Set TNetFee=$Piece(TempData,"^",5)
	..Set ^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,TStoreLoc,TFundsTypeDR,TEquipType,TStatCat)=TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee
	
	Set Loc=""
	For  Set Loc=$Order(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,Loc)) Quit:(Loc="")  Do
	.Set TFundsTypeDR=""
	.For  Set TFundsTypeDR=$Order(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,Loc,TFundsTypeDR)) Quit:(TFundsTypeDR="")  Do
	..Set TFundsType = $Piece($Get(^DHCEQCCode("DHCEQCFundsType",TFundsTypeDR)),"^",2)
	..;20141113  Mozy0146
	..Set TEquipType=""
	..For  Set TEquipType=$Order(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,Loc,TFundsTypeDR,TEquipType)) Quit:(TEquipType="")  Do
	...Set TStatCat=""
	...For  Set TStatCat=$Order(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,Loc,TFundsTypeDR,TEquipType,TStatCat)) Quit:(TStatCat="")  Do
	....Set TempData=$Get(^TempDHCEQ("ReportEx","FundsDepreLoc",TJob,Loc,TFundsTypeDR,TEquipType,TStatCat))
	....Set TOriginalFee=$Piece(TempData,"^",1)
	....Set TDepreFee=$Piece(TempData,"^",2)
	....Set TDepreYearFee=$Piece(TempData,"^",3)
	....Set TDepreTotal=$Piece(TempData,"^",4)
	....Set TNetFee=$Piece(TempData,"^",5)
	....Set TStoreLoc = $Piece(Loc,"-",2)
	....
	....;科室  类组  资产类型  资金来源  原值  本期折旧额  累计折旧额  资产净值 
	....Set SumAmount=SumAmount+TOriginalFee	
	....Set SumDepreFee=SumDepreFee+TDepreFee
	....Set SumDepreYearFee=SumDepreYearFee+TDepreYearFee
	....Set SumDepreTotal=SumDepreTotal+TDepreTotal
	....Set SumNetFee=SumNetFee+TNetFee
	....Do OutputRowFundsDepreLoc
	
	Set TStoreLoc="合计"
	Set TOriginalFee=SumAmount
	Set TDepreFee=SumDepreFee
	Set TDepreYearFee=SumDepreYearFee
	Set TDepreTotal=SumDepreTotal
	Set TNetFee=SumNetFee
	
	Set TEquipType=""
	Set TStatCat=""
	Set TFundsType=""
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	If TotalFlag="1" Set index=1
	Do OutputRowFundsDepreLoc
	
	Kill ^TempDHCEQ("ReportEx","FundsDepreLoc",TJob)
	Quit $$$OK

OutputRowFundsDepreLoc
	Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	Set TDepreFee=##Class(web.DHCEQCommon).FormatNumber(TDepreFee,"",2)
	Set TDepreYearFee=##Class(web.DHCEQCommon).FormatNumber(TDepreYearFee,"",2)
	Set TDepreTotal=##Class(web.DHCEQCommon).FormatNumber(TDepreTotal,"",2)
	Set TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)
	Set Data=$lb(TStoreLoc,TOriginalFee,TDepreFee,TDepreYearFee,TDepreTotal,TNetFee,TJob,TEquipType,TStatCat,TFundsType)
	Set ^TempDHCEQ(TempNode,ToDate,TJob,index)=TStoreLoc_"^"_TOriginalFee_"^"_TDepreFee_"^"_TDepreYearFee_"^"_TDepreTotal_"^"_TNetFee_"^"_TJob_"^"_TEquipType_"^"_TStatCat_"^"_TFundsType
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod FundsDepreLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FundsDepreLocExecute ]
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

ClassMethod FundsDepreLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FundsDepreLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 20140719  Mozy0135
/// 描述:固定资产折旧分摊表
/// d ##class(%ResultSet).RunQuery("web.DHCEQReportEx","DepreCostAllot","2016-04")
Query DepreCostAllot(MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", EquipTypeDR As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TJob:%String,TStoreLoc:%String,TEquipType:%String,TStatCat:%String,TFundsType:%String,CADFee:%String,CADDepreFee:%String") [ SqlProc ]
{
}

ClassMethod DepreCostAllotExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", EquipTypeDR As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set TJob=$Job
 	;s ^DHCEQMozy("DepreCostAllot")=MonthStr_"^"_QXType_"^"_UseLocDR_"^"_EquipTypeDR_"^"_FundsTypeDR_"^"_CurGroupID_"^"_CurLocID
 	Kill ^TempDHCEQ("ReportEx","DepreCostAllot",TJob)
 	Set SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
 	If ((MonthStr="")||(SelfFundsFlag="")) Quit $$$OK
 	Set SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)	;20140729  Mozy0142
 	If SnapID="" Quit $$$OK
 	
	Set index=1
	Set MDRowID=0
	For  Set MDRowID=$Order(^DHCEQMonthDepre(0,"Month",MonthStr,MDRowID)) Quit:MDRowID=""  Do
	.s MDStatus=$p($g(^DHCEQMonthDepre(MDRowID)),"^",20)	//DJ0136
	.q:MDStatus="3"
	.Set EQRowID=$Piece($Get(^DHCEQMonthDepre(MDRowID)),"^",1)
	.Set TEquipTypeDR=$Piece($Get(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",63)
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.Quit:(EquipTypeDR'="")&(TEquipTypeDR'=EquipTypeDR)
	.Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Set TStatCatDR=$Piece($Get(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",75)
	.If TStatCatDR'="" Set TStatCat=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.
	.Set CADRowID=0
	.For  Set CADRowID=$Order(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADRowID)) Quit:CADRowID=""  d
	..Set CADLoc=$Piece($Get(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	..Quit:(UseLocDR'="")&(UseLocDR'=CADLoc)
	..;If CADLoc'="" Set TStoreLoc = $Piece($Get(^CTLOC(CADLoc)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	..If CADLoc'="" Set TStoreLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",CADLoc)  //modify by jyp 2019-10-18 CTLOC调整
	..Set CADCostRate=+$Piece($Get(^DHCEQCostAllotDetail(CADRowID)),"^",4)		;分配比例
	..Set CADDepreFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQCostAllotDetail(CADRowID)),"^",5),"",3)
	..Set CADFundsFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQCostAllotDetail(CADRowID)),"^",6),"",3)
	..Set CADFundsTypeDR=$Piece($Get(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	..Quit:(FundsTypeDR'="")&(FundsTypeDR'=CADFundsTypeDR)
	..Set CADFee=CADFundsFee		;分摊原值
	..If (CADCostRate'=0)&(CADFundsFee'=0) Set CADFee=##Class(web.DHCEQCommon).FormatNumber((CADFundsFee*(CADCostRate/100)),"",2)
	..
	..Set TempData=$Get(^TempDHCEQ("ReportEx","DepreCostAllot",TJob,TStoreLoc,CADFundsTypeDR,TEquipType,TStatCat))
	..Set CADFee=CADFee+$Piece(TempData,"^",1)
	..Set CADDepreFee=CADDepreFee+$Piece(TempData,"^",2)
	..Set ^TempDHCEQ("ReportEx","DepreCostAllot",TJob,TStoreLoc,CADFundsTypeDR,TEquipType,TStatCat)=CADFee_"^"_CADDepreFee
	
	
	//输出明细汇总
	Set Loc=""
	For  Set Loc=$Order(^TempDHCEQ("ReportEx","DepreCostAllot",TJob,Loc)) Quit:(Loc="")  Do
	.Do ResetVariablesGetDepreCostAllot
	.Set TFundsTypeDR=""
	.For  Set TFundsTypeDR=$Order(^TempDHCEQ("ReportEx","DepreCostAllot",TJob,Loc,TFundsTypeDR)) Quit:(TFundsTypeDR="")  Do
	..Set TFundsType = $Piece($Get(^DHCEQCCode("DHCEQCFundsType",TFundsTypeDR)),"^",2)
	..Set TEquipType=""
	..For  Set TEquipType=$Order(^TempDHCEQ("ReportEx","DepreCostAllot",TJob,Loc,TFundsTypeDR,TEquipType)) Quit:(TEquipType="")  Do
	...Set TStatCat=""
	...For  Set TStatCat=$Order(^TempDHCEQ("ReportEx","DepreCostAllot",TJob,Loc,TFundsTypeDR,TEquipType,TStatCat)) Quit:(TStatCat="")  Do
	....Set TempData=$Get(^TempDHCEQ("ReportEx","DepreCostAllot",TJob,Loc,TFundsTypeDR,TEquipType,TStatCat))
	....Set CADFee=$Piece(TempData,"^",1)
	....Set CADDepreFee=$Piece(TempData,"^",2)
	....Set TStoreLoc = Loc		;$Piece(Loc,"-",2)
	....
	....Do OutputRowGetDepreCostAllot
	//输出结束删除临时global
	Kill ^TempDHCEQ("ReportEx","DepreCostAllot",TJob)
	
	Quit $$$OK
OutputRowGetDepreCostAllot
	Set Data=$lb(TJob,TStoreLoc,TEquipType,TStatCat,TFundsType,CADFee,CADDepreFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetDepreCostAllot
	Set (TStoreLoc,TEquipType,TStatCat,TFundsType,CADFee,CADDepreFee)=""
	Quit
}

ClassMethod DepreCostAllotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepreCostAllotExecute ]
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

ClassMethod DepreCostAllotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepreCostAllotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// w ##Class(web.DHCEQReportEx).GetOneLocUsedMonthReport(0,3824)
ClassMethod GetOneALocUsedMonthReport(PNum As %Library.String = "", job As %Library.String = "")
{
	Quit:(PNum="")||(job="") ""
	;^TempDHCEQ("LocUsedMonthReport",3824,3) = "专用设备^设备仓^放射科^4^40000.00" 
	Quit:PNum=0 $Order(^TempDHCEQ("ALocUsedMonthReport",job,""),-1)
	Quit $g(^TempDHCEQ("ALocUsedMonthReport",job,PNum))
}

}
