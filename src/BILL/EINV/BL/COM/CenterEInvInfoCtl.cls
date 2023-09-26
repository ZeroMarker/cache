Class BILL.EINV.BL.COM.CenterEInvInfoCtl Extends %RegisteredObject
{

/// Creator：      DuWC
/// CreatDate：    2019-09-29
/// Description:： 查询CenterEInvInfo信息
/// Table：       被访问的表 BILL.EINV.PO.CenterEInvInfo
/// Output:      	ID 
/// 		BusNo      业务流水号
/// 			PlaceCode  开票点编码
/// 			BillName  票据种类名称
/// 			BillBatchCode 票据代码
/// 			BillNo  票据号码
/// 			Random  校验码
/// 			TotalAmt  总金额
/// 			BusDate  业务日期
/// 			BusTime  业务时间
/// 			IvcDate  开票日期
/// 			IvcTime  开票时间
/// 			DataType 数据类型
/// 			State  状态
/// 			RelateBillBatchCode  关联电子票据代码
/// 			RelateBillNo  关联电子票据号码
/// 			InvFactoryCD  开发商编码
/// 			InvFactoryNM  开发商名称 
/// 			XStr1  备用1 
/// 			XStr2  备用2 
/// 			XStr3  备用3 
/// 			XStr4  备用4 
/// 			XStr5  备用5 
/// Debug:  d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.CenterEInvInfoCtl","QueryCenterEInvInfo","","","2019-07-01","2019-09-30")
Query QueryCenterEInvInfo(PlCode As %String = "", BBatchCode As %String = "", BiNo As %String = "", stDate As %String = "", edDate As %String = "") As %Query(ROWSPEC = "ID:%String,BusNo:%String,PlaceCode:%String,BillName:%String,BillBatchCode:%String,BillNo:%String,Random:%String,TotalAmt:%String,BusDate:%String,BusTime:%String,IvcDate:%String,IvcTime:%String,DataType:%String,State:%String,RelateBillBatchCode:%String,RelateBillNo:%String,InvFactoryCD:%String,InvFactoryNM:%String,XStr1:%String,XStr2:%String,XStr3:%String,XStr4:%String,XStr5:%String") [ SqlProc ]
{
}

ClassMethod QueryCenterEInvInfoExecute(ByRef qHandle As %Binary, PlCode As %String = "", BBatchCode As %String = "", BiNo As %String = "", stDate As %String = "", edDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    q:(stDate="")||(edDate="") $$$OK
    set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
    set edDate=##class(websys.Conversions).DateHtmlToLogical(edDate)
    f IUDDate=stDate:1:edDate d
    .s ID=""
    .f  s ID=$o(^BILL.EINV.PO.CenterEInvInfoI("IdxBusDate",IUDDate,ID)) q:ID=""  d
    ..s list=$g(^BILL.EINV.PO.CenterEInvInfoD(ID))
    ..s BusNo=$lg(list,2)		 ;业务流水号
    ..s PlaceCode=$lg(list,3)	 ;开票点编码
    ..q:'(PlaceCode[PlCode)&&(PlCode'="")
    ..s BillName=$lg(list,4)		 ;票据种类名称
    ..s BillBatchCode=$lg(list,5) ;票据代码
    ..q:'(BillBatchCode[BBatchCode)&&(BBatchCode'="")
    ..s BillNo=$lg(list,6)		 ;票据号码
    ..q:'(BillNo[BiNo)&&(BiNo'="")
    ..s Random=$lg(list,7)        ;校验码
    ..s TotalAmt=$lg(list,8)		 ;总金额
    ..s BusDate=$lg(list,9)       ;业务日期
    ..s BusTime=$lg(list,10)		 ;业务时间
    ..s IvcDate=$lg(list,11)		 ;开票日期
    ..s IvcTime=$lg(list,12)      ;开票时间
    ..s DataType=$lg(list,13)	 ;数据类型
    ..s DataType=$case(DataType,"1":"正常电子","2":"电子红票","3":"换开纸质","4":"换开纸质红票","5":"空白纸质",:"")
    ..s State=$lg(list,14)		 ;状态
    ..s State=$case(State,"1":"正常","2":"作废",:"")
    ..s RelateBillBatchCode=$lg(list,15) ;关联电子票据代码
    ..s RelateBillNo=$lg(list,16) ;关联电子票据号码
    ..s InvFactoryCD=$lg(list,17) ;开发商编码
    ..s InvFactoryNM=$lg(list,18) ;开发商名称
    ..s XStr1=$lg(list,19)
    ..s XStr2=$lg(list,20)
    ..s XStr3=$lg(list,21)
    ..s XStr4=$lg(list,22)
    ..s XStr5=$lg(list,23)
    ..d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ID,BusNo,PlaceCode,BillName,BillBatchCode,BillNo,Random,TotalAmt,$zd(BusDate,3),BusTime,$zd(IvcDate,3),IvcTime,DataType,State,RelateBillBatchCode,RelateBillNo,InvFactoryCD,InvFactoryNM,XStr1,XStr2,XStr3,XStr4,XStr5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryCenterEInvInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCenterEInvInfoExecute ]
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

ClassMethod QueryCenterEInvInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCenterEInvInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
