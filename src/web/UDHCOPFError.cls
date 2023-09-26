Class web.UDHCOPFError Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 82;

ClassMethod BConGetBillDataErr(billstr As %String = "") As %String
{
	;记录没有结算数据的医嘱明细
	;w ##class(web.UDHCOPFError).BConGetBillDataErr("1710")
	s billidCount=$l(billstr,"^")
	s myDate=+$h
	s myTime=+$p($h,",",2)
	s ^TMP101("GetBillData",$j,myDate,myTime,"G")=billstr
	f billidnum=1:1:billidCount  d
	.s bill=$p(billstr,"^",billidnum)
	.q:bill=""
	.s PBOChildsub=0  f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:PBOChildsub=""  d
	..q:($d(^DHCPB(bill,"O",PBOChildsub))=10)		;;zhao防止错误?
	..;s Prescno=""
	..;s Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s ^TMP101("GetBillData",$j,myDate,myTime,"G",bill,PBOChildsub)=^DHCPB(bill,"O",PBOChildsub)
	
	q 0
}

ClassMethod CheckINVPRTReps() As %String
{
	;w ##class(web.UDHCOPFError).CheckINVPRTReps()
	n (ad)
	s myRepRowID=0
	f  s myRepRowID=$o(^DHCOPInsFoot(myRepRowID)) q:(myRepRowID="")  d
	.q:($d(^DHCOPInsFoot(myRepRowID))=10)
	.s mystr=$g(^DHCOPInsFoot(myRepRowID))
	.s mylen=$l(mystr,"^")
	.w mylen,!
	
	q 0
}

ClassMethod INVPrtPayRepair() As %String
{
	;修复新的支付模式表记录
	;w ##class(web.UDHCOPFError).INVPrtPayRepair()
	s myPRTRowID=0
	s rtn=0
	f  s myPRTRowID=$o(^DHCINVPRT(myPRTRowID)) q:(myPRTRowID="")  d
	.q:($d(^DHCINVPRT(myPRTRowID))=10)
	.s myPM=$o(^DHCINVPRT(myPRTRowID,"P",0))
	.q:(myPM'="")
	.s myARCRowID=$p(^DHCINVPRT(myPRTRowID),"^",2)
	.s myPatSum=$p(^DHCINVPRT(myPRTRowID),"^",16)
	.s myDate=$p(^DHCINVPRT(myPRTRowID),"^",5)
	.s myTime=$p(^DHCINVPRT(myPRTRowID),"^",20)
	.;^ARRCP({AR_Receipts.ARRCP_RowId},"PAYM",{PAYM_Childsub})
	.s myPMSub=0
	.f  s myPMSub=$o(^ARRCP(myARCRowID,"PAYM",myPMSub)) q:(myPMSub="")  d
	..s myPMDR=$p(^ARRCP(myARCRowID,"PAYM",myPMSub),"^",1)
	..k PLIST
	..s PLIST(0)=myPRTRowID
	..s PLIST(3)=myPMDR
	..;s PLIST(3)=$p(PMInfo,"^",1)		;IPM_PayMode_DR
	..s PLIST(5)=myPatSum		;IPM_Amt
	..s PLIST(8)=myDate					;IPM_Date
	..s PLIST(9)=myTime			;IPM_Time
	..s rtn=##class(web.UDHCINVPayMode).INSERT()
	.w myPRTRowID
	.;b	;;;Insert
	
	q 0
}

ClassMethod INVPrtRepsRepair() As %String
{
	;用于修复报表增加字段时
	;w ##class(web.UDHCOPFError).INVPrtRepsRepair()
	n (ad)
	s myRepRowID=0
	f  s myRepRowID=$o(^DHCOPInsFoot(myRepRowID)) q:(myRepRowID="")  d
	.q:($d(^DHCOPInsFoot(myRepRowID))=10)
	.s mystr=$g(^DHCOPInsFoot(myRepRowID))
	.s myrtn=##class(web.UDHCINVPRTReports).SELECT(myRepRowID)
	.s myrtn=##class(web.UDHCINVPRTReports).UPDATE(myRepRowID)
	.s mylen=$l(mystr,"^")
	.w mylen_"      "_myRepRowID,!
	
	q 0
}

ClassMethod INVPRTRepair() As %String
{
	n (ad)		;修复DHC_INVPRT  表的字段
	;w ##class(web.UDHCOPFError).INVPRTRepair()
	;^DHCINVPRT({PRT_Rowid})
	
	s myPRTRowID=0
	
	f  s myPRTRowID=$o(^DHCINVPRT(myPRTRowID))  q:(myPRTRowID="")  d 
	.q:($d(^DHCINVPRT(myPRTRowID))=10)
	.s mystr=$g(^DHCINVPRT(myPRTRowID))
	.s myrtn=##class(web.DHCOPInvoice).SELECT(myPRTRowID)
	.s myrtn=##class(web.DHCOPInvoice).UPDATE(myPRTRowID)
	.s mylen=$l(mystr,"^")
	.w mylen_"      "_myPRTRowID,!
	.
}

ClassMethod GroupSettingsRepair() As %String
{
	;/// 修复安全组新增字段配置表
	;w ##class(web.UDHCOPFError).GroupSettingsRepair()
	
	;^DHCOPGS("GS",{GS_RowID})
	s myGSRowID=0
	f  s myGSRowID=$o(^DHCOPGS("GS",myGSRowID)) q:(myGSRowID="")  d
	.q:($d(^DHCOPGS("GS",myGSRowID))=10)
	.s mystr=^DHCOPGS("GS",myGSRowID)
	.s myrtn=##class(web.UDHCOPGroupSettings).SELECT(myGSRowID)
	.s myrtn=##class(web.UDHCOPGroupSettings).UPDATE(myGSRowID)
	.s mylen=$l(mystr,"^")
	.w mylen_"      "_myGSRowID,!
	.
}

ClassMethod ReadPaySum() As %String
{
	///2006-07-01
	;w ##class(web.UDHCOPFError).ReadPaySum()
	s myPBRowID=0
	s mySum=0
	f  s myPBRowID=$o(^DHCPB(myPBRowID))  q:(myPBRowID="")  d
	.q:($d(^DHCPB(myPBRowID))=10)
	.s myPayFlag=$p(^DHCPB(myPBRowID),"^",16)
	.q:(myPayFlag'="P")
	.s myDate=$p(^DHCPB(myPBRowID),"^",2)
	.q:(myDate'=60446)
	.s myPatSum=$p(^DHCPB(myPBRowID),"^",12)
	.s mySum=mySum+myPatSum
	
	w "DHC_PatientBill:"_mySum
	
	;^DHCBCI({DHCBCI_Rowid})
	s myBCIRowID=0
	s mySum=0
	f  s myBCIRowID=$o(^DHCBCI(myBCIRowID)) q:(myBCIRowID="")  d
	.s myPBRowID=$p(^DHCBCI(myBCIRowID),"^",2)
	.q:($d(^DHCPB(myPBRowID))=10)
	.s myPayFlag=$p(^DHCPB(myPBRowID),"^",16)
	.q:(myPayFlag'="P")
	.s myDate=$p(^DHCPB(myPBRowID),"^",2)
	.q:(myDate'=60446)
	.s myPatSum=$p(^DHCPB(myPBRowID),"^",12)
	.s mySum=mySum+myPatSum
	.
	
	w !, "DHC_:"_mySum
	b
	;^DHCINVPRT({PRT_Rowid})
	;验证每一笔的钱是否一致
	s myPRTRowID=0
	s myPRTSum=0
	f  s myPRTRowID=$o(^DHCINVPRT(myPRTRowID)) q:(myPRTRowID="")  d
	.
	.q:($d(^DHCINVPRT(myPRTRowID))=10)
	.s myPatShare=$p(^DHCINVPRT(myPRTRowID),"^",16)
	.s myPBSum=0
	.s mySum=0
	.;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	.s myBCIRowID=0
	.s myDate=0
	.f  s myBCIRowID=$o(^DHCBCI(0,"INV",myPRTRowID, myBCIRowID)) q:(myBCIRowID="")  d
	..s myPBRowID=$p(^DHCBCI(myBCIRowID),"^",2)
	..q:($d(^DHCPB(myPBRowID))=10)
	..s myPayFlag=$p(^DHCPB(myPBRowID),"^",16)
	..q:(myPayFlag'="P")
	..s myDate=$p(^DHCPB(myPBRowID),"^",2)
	..q:(myDate'=60446)
	..s myPatSum=$p(^DHCPB(myPBRowID),"^",12)
	..s mySum=mySum+myPatSum
	.q:(myDate'=60446)
	.;w !,"myPRTRowID:"_myPRTRowID_"   "_myPatShare
	.s myPRTSum=myPRTSum+myPatShare
	.i +myPatShare'=mySum d
	..w !
	..w "DHC_INVPRT:"_myPRTRowID_"  "_"DHC_PatientBill:"_myPBRowID
	
	w !, myPRTSum
	
	q mySum
}

ClassMethod TCLogReSet(LogName As %String, DifTime As %String) As %String
{
	;w ##class(web.UDHCOPFError).TCLogReSet("Rebill",0.1)
	n (LogName, DifTime)
	
	q:(LogName="")
	
	;设置这个点的目的：
	;可以在查看每秒内的时间差，
	;可以查看每秒内不同进程的时间差
	;可以查看每秒内最大的时间差
	s ^TMPDHCOPChargeTimeDifLog("TDLog",LogName, +$h,$p($h,",",2),$j)=DifTime
	
	q 0
}

}
