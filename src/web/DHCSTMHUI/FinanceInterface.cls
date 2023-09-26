Import sqluser

/// Descript:财务接口相关
/// Creater:lxt
/// CreateDate:	2016-08-22
Class web.DHCSTMHUI.FinanceInterface Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 根据时间取月报明细
/// Author:lxt
/// Date:2016-08-23
/// Argu:
/// StkMonth -时间 type-TK(出库)，RG(入库) 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.FinanceInterface","DHCStkMonSumTransLoc","2016-11-01","RG")
Query DHCStkMonSumTransLoc(StkMonth As %String, type As %String) As Query(ROWSPEC = "RowId,SM,Type,LocDesc,RelaLoc,stkCat,SCG,Vendor,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod DHCStkMonSumTransLocExecute(ByRef qHandle As %Binary, StkMonth As %String, type As %String) As %Status
{
 i StkMonth="" q $$$OK
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 s StkMonth=$G(StkMonth)
 s StkMonth=$replace(StkMonth,"/","-")
 s StkMonth=$e(StkMonth,1,7)
 s StkMonth=StkMonth_"-01"
 s StkMonth=$zdh(StkMonth,3)
 
 s sql="SELECT SUMTL_RowId RowId,SUMTL_SM_DR SM,SUMTL_Type Type,SUMTL_RelaLoc_DR->CTLOC_Desc RelaLoc,SUMTL_stkCat_DR->INCSC_Desc stkCat,SUMTL_SCG_DR->SCG_Desc SCG,SUMTL_Relaorg Vendor,SUMTL_RpAmt RpAmt,SUMTL_SpAmt SpAmt FROM DHC_StkMonSum_TransLoc"
 i StkMonth'=""  s sql=sql_" WHERE SUMTL_SM_DR IN (SELECT DHCSM_Rowid FROM DHC_StkMon where DHCSM_Month='"_StkMonth_"') "
 i type'="" s sql=sql_" and SUMTL_Type='"_type_"'"
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.RuntimeModeSet(0)
 d xrs.Prepare(sql)
 s ret=xrs.Execute()
 i $$$ISERR(ret) q $$$OK
 while (xrs.Next()) 
 {
  s RowId=xrs.Data("RowId")
  s SM=xrs.Data("SM")
  s Type=xrs.Data("Type")
  s LocDesc=""
  s LocDR=$p(^DHCSM(SM),"^",1)
  s LocDesc=$p(^CTLOC(LocDR),"^",2)
  s RelaLoc=xrs.Data("RelaLoc")
  s stkCat=xrs.Data("stkCat")
  s SCG=xrs.Data("SCG")
  s Vendor=xrs.Data("Vendor")
  i Type="RG"  d
  .s Vendor=$p(^APC("APCVM",Vendor),"^",3)
  e  d
  .s Vendor=""
  s RpAmt=xrs.Data("RpAmt")
  s SpAmt=xrs.Data("SpAmt")
 d OutPutRow
 } 

 Quit $$$OK

OutPutRow
 s Data=$lb(RowId,SM,Type,LocDesc,RelaLoc,stkCat,SCG,Vendor,RpAmt,SpAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 根据月报号更新凭证号，凭证日期，凭证PDF
/// Author:lxt
/// Date:2016-08-23
/// Argu:月报号
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.FinanceInterface).UpdateAcctVoucherInfo("QXKKFMON20170523003","123","2017-06-12","")
ClassMethod UpdateAcctVoucherInfo(StkMonNo As %String, AcctVoucherCode As %String, AcctVoucherDate As %String, PdfFile As %String) As %String
{
   s Ret=##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherInfo(StkMonNo,AcctVoucherCode,AcctVoucherDate,PdfFile)
   q Ret
}

/// 根据月报号更新凭证号状态
/// Author:lxt
/// Date:2016-08-23
/// Argu: 月报号 (A,P,R):Accepted,Passed,Returned
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.FinanceInterface).UpdateAcctVoucherStatus("QXKKFMON20170523003","A","1")
ClassMethod UpdateAcctVoucherStatus(StkMonNo As %String, AcctVoucherStatus As %String, User As %String = "") As %String
{
   s Ret=##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherStatus(StkMonNo,AcctVoucherStatus,User)
   q Ret
}

/// 根据月报号更新凭证号，凭证日期，凭证PDF(入库凭证)
/// Author:lxt
/// Date:2017-06-12
/// Argu:月报号
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.FinanceInterface).UpdateAcctVoucherInfoRec("QXKKFMON20170523003","234","2017-06-12","")
ClassMethod UpdateAcctVoucherInfoRec(StkMonNo As %String, AcctVoucherCode As %String, AcctVoucherDate As %String, PdfFile As %String) As %String
{
   s Ret=##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherInfoRec(StkMonNo,AcctVoucherCode,AcctVoucherDate,PdfFile)
   q Ret
}

/// 根据月报号更新凭证号状态(入库凭证)
/// Author:lxt
/// Date:2017-06-12
/// Argu: 月报号 (A,P,R):Accepted,Passed,Returned
/// Return:	成功返回0 其他返回错误
/// w ##class(web.DHCSTMHUI.FinanceInterface).UpdateAcctVoucherStatusRec("QXKKFMON20170523003","A",1)
ClassMethod UpdateAcctVoucherStatusRec(StkMonNo As %String, AcctVoucherStatus As %String, User As %String = "") As %String
{
   s Ret=##class(web.DHCSTMHUI.DHCStkMon).UpdateAcctVoucherStatusRec(StkMonNo,AcctVoucherStatus,User)
   q Ret
}

}
