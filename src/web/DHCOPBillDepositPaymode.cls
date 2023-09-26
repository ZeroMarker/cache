/// 名称: web.DHCOPBillDepositPaymode.cls
/// 描述: 账户的预交金按支付方式汇总
/// 编写者：lrl
/// 编写日期: 2008-09-16
Class web.DHCOPBillDepositPaymode Extends %RegisteredObject
{

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillDepositPaymode","DepositQuery","","")
Query DepositQuery(StartDate As %String, EndDate As %String, HospId As %String, DepTypeId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TDepTypeDesc:%String:押金类型,TPayMDesc:%String:支付方式,TPayDeposit:%Float:收预交金,TRefundDeposit:%Float:退预交金,TPreDeposit:%Float:实收预交金") [ SqlProc ]
{
}

ClassMethod DepositQueryExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospId As %String, DepTypeId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)

	set job=$j
	kill ^||TMP(job)
	
	for date=StartDate:1:EndDate {
		set myAccM=0
		while($o(^DHCACDi("AccM",0,"APDDate",date,myAccM))) {
			set myAccM=$o(^DHCACDi("AccM",0,"APDDate",date,myAccM))
			set myPDSub=0
			while($o(^DHCACDi("AccM",0,"APDDate",date,myAccM,"AccPD",myPDSub))) {
				set myPDSub=$o(^DHCACDi("AccM",0,"APDDate",date,myAccM,"AccPD",myPDSub))
				set myPDData=$g(^DHCACD("AccM",myAccM,"AccPD",myPDSub))
				continue:(myPDData="")
				set myHospDR=$p(myPDData,"^",15)
				continue:(myHospDR'=HospId)
				set myDepTypeDR=$p(myPDData,"^",10)
				continue:((DepTypeId'="")&&(DepTypeId'=myDepTypeDR))
				set myPMSub=0
				while($o(^DHCACD("AccM",myAccM,"AccPD",myPDSub,"P",myPMSub))) {
					set myPMSub=$o(^DHCACD("AccM",myAccM,"AccPD",myPDSub,"P",myPMSub))
					set myAPPMData=$g(^DHCACD("AccM",myAccM,"AccPD",myPDSub,"P",myPMSub))
					continue:(myAPPMData="")
					set myPayMDR=$p(myAPPMData,"^",1)
					set myAmt=$p(myAPPMData,"^",6)
					continue:(+myAmt=0)
					if (+myAmt>0) {
						set ^||TMP(job,myDepTypeDR,myPayMDR,"P")=$g(^||TMP(job,myDepTypeDR,myPayMDR,"P"))+myAmt
					}else {
						set ^||TMP(job,myDepTypeDR,myPayMDR,"R")=$g(^||TMP(job,myDepTypeDR,myPayMDR,"R"))+myAmt
					}
				}
			}
		}
	}
	
	set PayDepositSum=0, RefundDepositSum=0
	set DepTypeID=0
	while($o(^||TMP(job,DepTypeID))) {
		set DepTypeID=$o(^||TMP(job,DepTypeID))
		set DepTypeDesc=$p($g(^ARC("ARCDT",DepTypeID)),"^",2)
		set DepTypeDesc=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", DepTypeDesc, LangId)
		set PayMID=0
		while($o(^||TMP(job,DepTypeID,PayMID))) {
			set PayMID=$o(^||TMP(job,DepTypeID,PayMID))
			set PayMDesc=$p($g(^CT("CTPM",PayMID)),"^",2)
			set PayMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayMDesc, LangId)
			set PayDeposit=+$g(^||TMP(job,DepTypeID,PayMID,"P"))
			set PayDeposit=$fn(PayDeposit,"",2)
			set RefundDeposit=+$g(^||TMP(job,DepTypeID,PayMID,"R"))
			set RefundDeposit=$fn(RefundDeposit,"",2)
			set PreDeposit=PayDeposit+RefundDeposit
			set PreDeposit=$fn(PreDeposit,"",2)
			set PayDepositSum=PayDepositSum+PayDeposit
			set RefundDepositSum=RefundDepositSum+RefundDeposit
			do OutputDepList
		}
	}
	
	if (ind>1) {
		set DepTypeDesc=##class(websys.Translation).Get("", "合计", LangId)
		set PayMDesc=""
		set PayDeposit=PayDepositSum
		set PayDeposit=$fn(PayDeposit,"",2)
		set RefundDeposit=RefundDepositSum
		set RefundDeposit=$fn(RefundDeposit,"",2)
		set PreDeposit=PayDeposit+RefundDeposit
		set PreDeposit=$fn(PreDeposit,"",2)
		do OutputDepList
	}
	
	kill ^||TMP(job)
	
	quit $$$OK
OutputDepList
	set Data=$lb(DepTypeDesc,PayMDesc,PayDeposit,RefundDeposit,PreDeposit)
	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
