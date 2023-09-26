Class web.UDHCACFinBRFootRevise Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 专门用来做矫正的程序
/// 
ClassMethod FootRepRevise() As %String
{
	;d ##class(web.UDHCACFinBRFootRevise).FootRepRevise()
	s mybegin=+$g(^TMPDDDDDDDDDDDDDDPDBack)+1
	f i=mybegin:1:138 d
	.w i,!
	.;b  ;i
	.d ##class(web.UDHCACFinBRFoot0PDBack).ACFinDataAutoFoot()
}

ClassMethod FootRepRoungRevise() As %String
{
	;d ##class(web.UDHCACFinBRFootRevise).FootRepRoungRevise()
	if +$g(^TMPDDDDDDDDDDDDDDPDBack2)'=0 d
	.s ^TMPDDDDDDDDDDDDDDPDBack2=0
	
	s mylen=$o(^DHCACD("AccPF",""),-1)
	
	s mybegin=+$g(^TMPDDDDDDDDDDDDDDPDBack2)+1
	f i=mybegin:1:mylen d
	.w i,!
	.;b  ;i
	.q:('$d(^DHCACD("AccPF",i)))
	.d ##class(web.UDHCACFinBRFoot0PDBack).ACFinDataRound()
}

ClassMethod CheckCardPayMode()
{
	;d ##class(web.UDHCACFinBRFootRevise).CheckCardPayMode()
	;^DHCACDi("AccM",0,"PayDate",{AccPL_PayDate},{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	s mydate=0
	f  s mydate=$o(^DHCACDi("AccM",0,"PayDate",mydate)) q:(mydate="")  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"PayDate",mydate,myAccRowID)) q:(myAccRowID="")  d
	..s mysub=0
	..f  s mysub=$o(^DHCACDi("AccM",0,"PayDate",mydate,myAccRowID,"AccPL",mysub)) q:(mysub="")  d
	...s myPLRowID=myAccRowID_"||"_mysub
	...s myPayNum=+$p(^DHCACD("AccM",myAccRowID,"AccPL",mysub),"^",8)
	...;^DHCINVPRTi(0,"AccPLDR",myPLRowID,{DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	...;b
	...s myPrtRowID=$o(^DHCINVPRTi(0,"AccPLDR",myPLRowID,0))
	...i myPrtRowID="" d
	....s ^TMPCHECKCARDPAYMODE($j,myPLRowID)="DHC_INVPayMode表中没有支付数据"_myPrtRowID_myPayNum
	...q:(myPrtRowID="")
	...s myPRTSub=$o(^DHCINVPRTi(0,"AccPLDR",myPLRowID,myPrtRowID,"P",0))
	...q:(myPRTSub="")
	...s myPRTPaySum=+$p(^DHCINVPRT(myPrtRowID,"P",myPRTSub),"^",3)
	...i myPayNum'=myPRTPaySum d
	....s ^TMPCHECKCARDPAYMODE($j,myPLRowID)="DHC_INVPayMode表与PayList金额不符  "_myPrtRowID_" myPayNum="_myPayNum_"  myPRTPaySum="_myPRTPaySum
	...w myPLRowID_"Date "_mydate,!
}

}
