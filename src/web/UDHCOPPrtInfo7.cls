Class web.UDHCOPPrtInfo7 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 59;

/// 专门提供华西一院的类方法
/// 
ClassMethod GetPatInfoForFirstPage(JSFunName As %String, PAPMIDR As %String, ExpStr As %String) As %String
{
	;用来 打印病人首页的信息
	;
	n (JSFunName, PAPMIDR, ExpStr)
	s myrtn=0
	s myTxtInfo=""			;打印文本数据
	s prtListInfo=""		;打印列表数据
	s del="^"
	s PatInfo=##class(web.DHCFBPat).GetPatInfo(PAPMIDR)
	q:PatInfo=0
	s PatName=$p(PatInfo,"^",3),PatNo=$p(PatInfo,"^",2),Sex=$p(PatInfo,"^",5)
	s myTxtInfo="PatName"_$c(2)_PatName_del_"PatNo"_$c(2)_PatNo_del_"Sex"_$c(2)_Sex
	s rtnval=JSFunName_"('"_$ZCVT($g(myTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	q myrtn
}

ClassMethod GetRegINVPRTData(JSFunName As %String, CardINVDR As %String) As %String
{
	;专门用来 为卡打印发票的类方法
	;w ##class(web.UDHCOPPrtInfo7).GetRegINVPRTData("",365)
	n (JSFunName, CardINVDR, ExpStr)
	s myrtn=0
	s myTxtInfo=""			;打印文本数据
	s prtListInfo=""		;打印列表数据
	s del="^"
	q:'$d(^DHCCARDINVPRT(CardINVDR)) ""
	S CardInfo=^DHCCARDINVPRT(CardINVDR)
	s PatRid=$p(CardInfo,del,1)
	if ($g(PatRid)'="") d   //为个人
	.s:($g(PatRid)'="") PatInfo=##class(web.DHCFBPat).GetPatInfo(PatRid)
	.q:(PatInfo=0)
	.s CardId=$o(^DHCCARDi("CF",0,"INVPRT",CardINVDR,""))
	.s CardNo=$p(^DHCCARD("CF",CardId),del,2)
	.s PatName=$p(PatInfo,"^",3)
	.s PatNo=CardNo
	if ($g(PatRid)="") d   //为集团
	.s UnitDr=$o(^DHCCARDINVPRT(CardINVDR,"P",0))
	.q:$g(UnitDr)="" 
	.s PatName=$p(^DHCCARDINVPRT(CardINVDR,"P",UnitDr),del,8)
	.s PatNo=""
	q:($g(PatName)="") ""
	s InvNo=$p(CardInfo,del,7)
	s Amount=$p(CardInfo,del,3)
	s CostsUpper=##class(web.UDHCOPINVPrtIF).RMBConvert(Amount)
	s UsrId=$p(CardInfo,del,6)
	if UsrId'="" d
	.s UsrCode=$p(^SSU("SSUSR",UsrId),del,1)
	.s UsrName=$p(^SSU("SSUSR",UsrId),del,2)
	s PrintDate=$p(CardInfo,del,4)
	S PrintDate1=""
	IF PrintDate'="" D
	.S PrintDate=$zd(PrintDate,3)
	.S PrintDate1=$P(PrintDate,"-",1)_$P(PrintDate,"-",2)_$P(PrintDate,"-",3)
	.S PrintDate=$P(PrintDate,"-",1)_" "_$P(PrintDate,"-",2)_" "_$P(PrintDate,"-",3)
	s myTxtInfo="PatName"_$c(2)_PatName_del_"PatNo"_$c(2)_"卡号:"_PatNo_del_"InvNo"_$c(2)_InvNo_del_"Amount"_$c(2)_Amount_"元"_del_"CostsUpper"_$c(2)_CostsUpper
	s myTxtInfo=myTxtInfo_del_"UsrCode"_$c(2)_UsrCode_del_"UsrName"_$c(2)_UsrName_del_"PrintDate"_$c(2)_PrintDate_del_"PrintDate1"_$c(2)_PrintDate1
	;s ^fhq=myTxtInfo
	s rtnval=JSFunName_"('"_$ZCVT($g(myTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	q myrtn
}

ClassMethod GetAccPreDepInfo(JSFunName As %String, AccDepRowID As %String, UseID As %String, RePrtFlag As %String) As %String
{
	;打印预交金条 类方法
	n (JSFunName, AccDepRowID, UseID, RePrtFlag)
	s myrtn=0
	
	;w ##class(web.UDHCOPPrtInfo0).GetAccPreDepInfo("","9||1","22096",1)
	;TxtInfo=""+c+CardNoobj.value+"^"+
	;""+c+PatNameobj.value+"^"+
	;""+c+val[1]+"^"+
	;""+c+val[2]+"^"
	;^
	;""+c+val[3]+"^"+
	;""+c+GuserCode+"^"+
	;""+c+val[4]
	;TxtInfo+=""+c+val[5];
	;TxtInfo+=""+c+val[6];
	;TxtInfo+=""+c+val[7];
	s myUserCode=$p(^SSU("SSUSR",UseID),"^",1)
	
	s myAccRowID=+AccDepRowID
	s myPAPMIDR=$p($g(^DHCACD("AccM",+myAccRowID)),"^",2)
	s myPAName=$p(^PAPER(myPAPMIDR,"ALL"),"^", 1)
	s myPAPMINO=$p($g(^DHCACD("AccM",+myAccRowID)),"^",3)
	s myCardNo=$p($g(^DHCACD("AccM",+myAccRowID)),"^",4)
	
	s myPreSum=$p($g(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2))),"^",2)
	s myRMB=##class(web.UDHCOPINVPrtIF).RMBConvert(myPreSum)
	s myDate=$p($g(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2))),"^",3)
	s myDate=$zd(myDate,3)
	s myTime=$p($g(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2))),"^",4)
	s myTime=$zt(myTime)
	s myDateTime=myDate_" "_myTime
	s myBillNo=$p($g(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2))),"^",6)
	s myBalance=$p($g(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2))),"^",8)
	s myAPMSub=0
	s myAPMSub=$o(^DHCACD("AccM", +myAccRowID,"AccPD", $p(AccDepRowID,"||",2),"P",0))
	s myPMDR=$p(^DHCACD("AccM", +myAccRowID,"AccPD", $p(AccDepRowID,"||",2),"P",myAPMSub),"^",1)
	s myPayMode=$p(^CT("CTPM",myPMDR),"^",2)
	s myRPDesc=""
	i +RePrtFlag=1 d
	.s myRPDesc="重新打印"
	
	s myPreSum=$fn(myPreSum,"",2)
	s myBalance=$fn(myBalance,"",2)
	
	s myPDInfo="CardNo"_$c(2)_myCardNo_"^PatName"_$c(2)_myPAName_"^amt"_$c(2)_myPreSum
	s myPDInfo=myPDInfo_"^amtdx"_$c(2)_myRMB_"^PAPMINO"_$c(2)_myPAPMINO_"^Balance"_$c(2)_myBalance
	s myPDInfo=myPDInfo_"^Guser"_$c(2)_myUserCode_"^Datetime"_$c(2)_myDateTime_"^BillNo"_$c(2)_myBillNo
	s myPDInfo=myPDInfo_"^RePrintFlag"_$c(2)_myRPDesc_"^StubL"_$c(2)_""
	s myPDInfo=myPDInfo_"^PayMode"_$c(2)_myPayMode
	
	s prtListInfo=""
	
	s rtnval=JSFunName_"('"_$ZCVT($g(myPDInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	q myrtn
}

}
