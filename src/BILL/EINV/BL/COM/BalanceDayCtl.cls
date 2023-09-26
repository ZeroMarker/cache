/// 名称: 		BILL.EINV.BL.COM.BalanceDayCtl.cls
/// 描述: 		电子票据日对总账
/// 编写者：	ZhaoZW
/// 编写日期: 	2019-09-29
Class BILL.EINV.BL.COM.BalanceDayCtl Extends %RegisteredObject
{

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-29
/// Description:   查询表中数据
/// Table：        被访问的表(BILL.EINV.PO.BalanceDay)
/// Input：        BusStDate : 业务开始日期 BusEdDate : 业务结束日期
/// Output：       BusDate : 业务日期 CopyNum : 总笔数 AllTotalAmt : 总金额 AllTotalNum : 总开票数
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.BalanceDayCtl","QueryBalanceDayInfo","2020-09-24","2020-09-24")
Query QueryBalanceDayInfo(BusStDate As %Date, BusEdDate As %Date) As %Query(ROWSPEC = "ind,BusDate:%String,CopyNum:%String,AllTotalAmt:%String,AllTotalNum:%String,HisBusDate,HisCopyNum,HisAllTotalAmt,HisAllTotalNum")
{
}

ClassMethod QueryBalanceDayInfoExecute(ByRef qHandle As %Binary, BusStDate As %Date, BusEdDate As %Date) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    q:(BusStDate="")||(BusEdDate="") $$$OK
    s BusStDate=##class(websys.Conversions).DateHtmlToLogical(BusStDate)
	s BusEdDate=##class(websys.Conversions).DateHtmlToLogical(BusEdDate)
	
	f Date=BusStDate:1:BusEdDate  d
	.s ID=""
    .f  s ID=$o(^BILL.EINV.PO.BalanceDayI("IdxBusDate",Date,ID)) q:ID=""  d
	..s Info=$g(^BILL.EINV.PO.BalanceDayD(ID))
	..s BusDate=$lg(Info,2)					;业务日期
	..s:BusDate'="" BusDate=$zd(BusDate,3)
	..s CopyNum=$lg(Info,3)					;总笔数
	..s AllTotalAmt=$lg(Info,4)				;总金额
	..s AllTotalNum=$lg(Info,5)				;总开票数
	..;add by xubaobao 2020 09 28 取his总账数据
	..s MedicalDayID=$o(^BILL.EINV.PO.HISBalanceDayI("IdxDateAndType",Date,1,""))
	..s (HisCopyNum,HisAllTotalAmt,HisAllTotalNum)="0"
	..s HisBusDate=BusDate
	..i MedicalDayID'="" d
	...s MedicalDayObj=##class(BILL.EINV.PO.HISBalanceDay).%OpenId(MedicalDayID)
	...s HisCopyNum=""
	...s HisAllTotalAmt=MedicalDayObj.ALLTotalAmt
	...s HisAllTotalNum=MedicalDayObj.ALLTotalNum
	..d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,BusDate,CopyNum,AllTotalAmt,AllTotalNum,HisBusDate,HisCopyNum,HisAllTotalAmt,HisAllTotalNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryBalanceDayInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBalanceDayInfoExecute ]
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

ClassMethod QueryBalanceDayInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBalanceDayInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-29
/// Description:   查询表中数据
/// Table：        被访问的表(BILL.EINV.PO.BalanceDay)
/// Input：        BusStDate : 业务开始日期 BusEdDate : 业务结束日期
/// Output：       BusDate : 业务日期 BillBatchCode : 电子票据代码 BillName : 票据种类名称 BgnNo : 起始号码
///          	   EndNo : 终止号码 CopyNum : 票号段内总开票数 TotalAmt : 票号段内总金额
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.BalanceDayCtl","QueryBalanceSubDayInfo","2019-09-28","2019-09-29")
Query QueryBalanceSubDayInfo(BusStDate As %Date, BusEdDate As %Date) As %Query(ROWSPEC = "ind,BusDate:%String,BillBatchCode:%String,BillName:%String,BgnNo:%String,EndNo:%String,CopyNum:%String,TotalAmt:%String")
{
}

ClassMethod QueryBalanceSubDayInfoExecute(ByRef qHandle As %Binary, BusStDate As %Date, BusEdDate As %Date) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    q:(BusStDate="")||(BusEdDate="") $$$OK
    s BusStDate=##class(websys.Conversions).DateHtmlToLogical(BusStDate)
	s BusEdDate=##class(websys.Conversions).DateHtmlToLogical(BusEdDate)
	f Date=BusStDate:1:BusEdDate  d
	.s BillBatchCode=""
    .f  s BillBatchCode=$o(^BILL.EINV.PO.BalanceSubDayI("IdxBillBatchCode",Date,BillBatchCode)) q:BillBatchCode=""  d
	..s ID=""
	..f  s ID=$o(^BILL.EINV.PO.BalanceSubDayI("IdxBillBatchCode",Date,BillBatchCode,ID)) q:ID=""  d
	...s Info=$g(^BILL.EINV.PO.BalanceSubDayD(ID))
	...s BusDate=$lg(Info,2)					;业务日期
	...s:BusDate'="" BusDate=$zd(BusDate,3)		
	...s BillBatchCode=$lg(Info,3)				;电子票据代码
	...s BillName=$lg(Info,4)					;票据种类名称
	...s BgnNo=$lg(Info,5)						;起始号码
	...s EndNo=$lg(Info,6)						;终止号码
	...s CopyNum=$lg(Info,7)					;票号段内总开票数
	...s TotalAmt=$lg(Info,8)					;票号段内总金额
	...d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,BusDate,BillBatchCode,BillName,BgnNo,EndNo,CopyNum,TotalAmt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryBalanceSubDayInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBalanceSubDayInfoExecute ]
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

ClassMethod QueryBalanceSubDayInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBalanceSubDayInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
