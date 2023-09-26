Class web.UDHCOPPrtInfo12 Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetRegINVPRTData(JSFunName As %String, CardINVDR As %String) As %String
{
	;专门用来 为卡打印发票的类方法
	;
	;n (JSFunName, CardINVDR, ExpStr)
	s myrtn=0
	s myTxtInfo=""			;打印文本数据
	s prtListInfo=""		;打印列表数据
	s PayMode=""  ;支付方式
	s del="^"
	q:'$d(^DHCCARDINVPRT(CardINVDR)) ""
	S CardInfo=^DHCCARDINVPRT(CardINVDR)
	s PatRid=$p(CardInfo,del,1)
	if ($g(PatRid)'="") d   //为个人
	.s:($g(PatRid)'="") PatInfo=##class(web.DHCFBPat).GetPatInfo(PatRid)
	.q:(PatInfo=0)
	.s CardId=$o(^DHCCARDi("CF",0,"INVPRT",CardINVDR,""))
	.s CardNo=$p(^DHCCARD("CF",CardId),del,2)
	.s CardType=""
	.s FindCFType=$P(^DHCCARD("CF",CardId),"^",16)
	.s:FindCFType'="" CardType=$P(^DHCCARDTYPEDef(FindCFType),"^",2)
	.s PatName=$p(PatInfo,"^",3)
	.s PatNo=CardNo
	if ($g(PatRid)="") d   //为集团
	.s UnitDr=$o(^DHCCARDINVPRT(CardINVDR,"P",0))
	.q:$g(UnitDr)="" 
	.s PatName=$p(^DHCCARDINVPRT(CardINVDR,"P",UnitDr),del,8)
	.s PatNo="",CardNo=""
	q:($g(PatName)="") ""
	s PayMode=""
	s myAPMSub=$o(^DHCCARDINVPRT(CardINVDR,"P",0))
	if (myAPMSub'="") {
		s myPMDR=$p(^DHCCARDINVPRT(CardINVDR,"P",myAPMSub),"^",1)
		i (myPMDR'="") s PayMode=$p($g(^CT("CTPM",myPMDR)),"^",2)
	}
	s InvNo=$p(CardInfo,del,7)
	s Amount=$p(CardInfo,del,3)
	s Amount=$fn(Amount,",")
	s CostsUpper=##class(web.UDHCOPINVPrtIF).RMBConvert(Amount)
	s UsrId=$p(CardInfo,del,6)
	if UsrId'="" d
	.s UsrCode=$p(^SSU("SSUSR",UsrId),del,1)
	.s UsrName=$p(^SSU("SSUSR",UsrId),del,2)
	s PrintDate=$p(CardInfo,del,4)
	S PrintDate1=""
	IF PrintDate'="" D
	.s PrintDate2=..%ZD(PrintDate)
	.S PrintDate=$zd(PrintDate,3)
	.S PrintDate1=$P(PrintDate,"-",1)_$P(PrintDate,"-",2)_$P(PrintDate,"-",3)
	.S PrintDate=$P(PrintDate,"-",1)_" "_$P(PrintDate,"-",2)_" "_$P(PrintDate,"-",3)
	s myTxtInfo="PatName"_$c(2)_PatName_del_"PatNo"_$c(2)_PatNo_del_"InvNo"_$c(2)_InvNo_del_"Amount"_$c(2)_Amount_"元"_del_"CostsUpper"_$c(2)_CostsUpper_del_"CardNo"_$c(2)_CardNo
	s myTxtInfo=myTxtInfo_del_"UsrCode"_$c(2)_UsrCode_del_"UsrName"_$c(2)_UsrName_del_"PrintDate"_$c(2)_PrintDate_del_"PrintDate1"_$c(2)_PrintDate1_del_"CardType"_$c(2)_CardType_del_"PayMode"_$c(2)_PayMode
	s myTxtInfo=myTxtInfo_del_"PrintDate2"_$c(2)_PrintDate2
	;s ^fhq=myTxtInfo
	s rtnval=JSFunName_"('"_$ZCVT($g(myTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	q myrtn
}

}
