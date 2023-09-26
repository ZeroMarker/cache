Class web.UDHCOPPrtInfo0 Extends %RegisteredObject
{

/// Debug: w ##class(web.UDHCOPPrtInfo0).GetAccPreDepInfo("xmlPrintFun","346||1","5","Y")
ClassMethod GetAccPreDepInfo(JSFunName As %String, AccDepRowID As %String, UseID As %String, RePrtFlag As %String) As %String
{
	set ^TMP("GetAccPreDepInfo")=$lb(JSFunName, AccDepRowID, UseID, RePrtFlag)

	set myUserCode=$p(^SSU("SSUSR",UseID),"^",1)
	set myUserName=$p(^SSU("SSUSR",UseID),"^",2)
	
	set myAccRowID=+AccDepRowID
	set myAccData=$g(^DHCACD("AccM",+myAccRowID))
	set myPAPMIDR=$p(myAccData,"^",2)
	set myPAName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
	set myPAPMINO=$p(myAccData,"^",3)
	
	set myPreData=$g(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2)))
	set myPreSum=$p(myPreData,"^",2)
	set myRMB=##class(web.UDHCJFBaseCommon).RMBDXXZH(myPreSum)
	set myDate=$p(myPreData,"^",3)
	set myDate=##class(websys.Conversions).DateLogicalToHtml(myDate)
	set myTime=$p(myPreData,"^",4)
	set myTime=##class(websys.Conversions).TimeLogicalToHtml(myTime)
	set myDateTime=myDate_" "_myTime
	set myBillNo=$p(myPreData,"^",6)
	set myBalance=$p(myPreData,"^",8)
	
	set myHospDR=$p(myPreData,"^",15)
	set myHospDesc=$s((+myHospDR'=0):$p($g(^CT("HOSP",myHospDR)),"^",2),1:"")
	
	//2020-11-23 ZhYW 押金类型
	set myDepTypeDR=$p(myPreData,"^",10)
	set myDepType=$s((+myDepTypeDR'=0):$p($g(^ARC("ARCDT",myDepTypeDR)),"^",2),1:"")
	
	//+2023-04-21 ZhYW
	set myCardNo=$p(myPreData,"^",22)        //卡号
	set myCardTypeDR=$p(myPreData,"^",23)    //卡类型
	set myCardType=$s((+myCardTypeDR'=0):$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",2),1:"")

	set myAPMSub=$o(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2),"P",0))
	set myAPMData=$g(^DHCACD("AccM",+myAccRowID,"AccPD",$p(AccDepRowID,"||",2),"P",myAPMSub))
	set myPMDR=$p(myAPMData,"^",1)
	set myPayMode=$p(^CT("CTPM",myPMDR),"^",2)
	set myRPDesc=$s((+RePrtFlag=1):"补打",1:"")
	
	set myPreSum=$fn(myPreSum,"",2)
	set myBalance=$fn(myBalance,"",2)
	
	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("CardType",myCardType).%Set("CardNo",myCardNo)
	do txtDataParaO.%Set("PatName",myPAName).%Set("amt",myPreSum)
	do txtDataParaO.%Set("amtdx",myRMB).%Set("PAPMINO",myPAPMINO)
	do txtDataParaO.%Set("Balance",myBalance).%Set("UsrName",myUserName).%Set("UsrCode",myUserCode)
	do txtDataParaO.%Set("DateTime",myDateTime).%Set("BillNo",myBillNo)
	do txtDataParaO.%Set("RePrintFlag",myRPDesc).%Set("PayMode",myPayMode)
	do txtDataParaO.%Set("HospDesc",myHospDesc).%Set("HospName2",myDepType_"收据")
	
	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	set listDataO=##class(%DynamicArray).%New()
	set prtListInfo=""
	set rtnval=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetAccPreDepInfo", "AccPreDepRcpt", AccDepRowID, txtDataParaO, listDataO, $lb(JSFunName, AccDepRowID, UseID, RePrtFlag))

	//add by lml 2015-01-27 增加打印日志
	set myCondition="{AccDepRowID:"""_AccDepRowID_""",UseID:"""_UseID_""",RePrtFlag:"""_RePrtFlag_"""}"
	set myContent="{AccDepRowID:"""_AccDepRowID_""",AccCardNo:"""_myCardNo_""",AccBillNo:"""_myBillNo_"""}"
 	set mySecretCodeStr=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(myPAPMIDR, "")
 	set mySecretCode=$p(mySecretCodeStr,"^",3)
	set mylog=##class(web.DHCEventLog).EventLog("UDHCAccDeposit.PrintAccPreDep", myCondition, myContent, mySecretCode)
	//end
	quit ""
}

/// Debug: w ##class(web.UDHCOPPrtInfo0).GetAccCarPreDepInfo("","","25","639","1")
ClassMethod GetAccCarPreDepInfo(JSFunName As %String, CardCost As %String = "", CardInvRowID As %String, UseID As %String, RePrtFlag As %String) As %String
{
	set myUserCode=$p(^SSU("SSUSR",UseID),"^",1)
	set myUserName=$p(^SSU("SSUSR",UseID),"^",2)
	
	set myPAPMIDR=$p($g(^DHCCARDINVPRT(CardInvRowID)),"^",1)
	set myPAName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
	set myPAPMINO=$p($g(^PAPER(myPAPMIDR,"PAT",1)),"^",1)
	set myCardNo=""
	set CardInvPayDr=$p($g(^DHCCARDINVPRT(CardInvRowID)),"^",8)
	if (CardInvPayDr'="") {
		set CardID=$o(^DHCCARDi("CF",0,"INVPRT",CardInvPayDr,""))
	}else {
		set CardID=$o(^DHCCARDi("CF",0,"INVPRT",CardInvRowID,""))
	}
	if (CardID'="") {
		set myCardNo=$p($g(^DHCCARD("CF",CardID)),"^",2)
	}
	
	set myPreSum=$p($g(^DHCCARDINVPRT(CardInvRowID)),"^",3)
	set myRMB=##class(web.UDHCJFBaseCommon).RMBDXXZH(myPreSum)
	set myDate=$p($g(^DHCCARDINVPRT(CardInvRowID)),"^",4)
	set myDate=##class(websys.Conversions).DateLogicalToHtml(myDate)
	set myTime=$p($g(^DHCCARDINVPRT(CardInvRowID)),"^",5)
	set myTime=##class(websys.Conversions).TimeLogicalToHtml(myTime)
	set myDateTime=myDate_" "_myTime
	set myBillNo=""
	set myBalance=0
	set myAPMSub=$o(^DHCCARDINVPRT(CardInvRowID,"P",0))
	set myPMDR=$p(^DHCCARDINVPRT(CardInvRowID,"P",myAPMSub),"^",1)
	set myPayMode=$s((+myPMDR'=0):$p($g(^CT("CTPM",myPMDR)),"^",2),1:"")
	set myRPDesc=$s((+RePrtFlag=1):"重新打印",1:"")
	
	set myPreSum=$fn(myPreSum,"",2)
	set myBalance=$fn(myBalance,"",2)
	
	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("CardNo",myCardNo).%Set("PatName",myPAName)
	do txtDataParaO.%Set("Amount",myPreSum).%Set("CostsUpper",myRMB)
	do txtDataParaO.%Set("PatNo",myPAPMINO).%Set("Balance",myBalance)
	do txtDataParaO.%Set("UsrName",myUserName).%Set("UsrCode",myUserCode)
	do txtDataParaO.%Set("PrintDate",myDateTime).%Set("BillNo",myBillNo)
	do txtDataParaO.%Set("RePrintFlag",myRPDesc).%Set("PayMode",myPayMode)
	
	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	set listDataO=##class(%DynamicArray).%New()
	set prtListInfo=""
		
	set rtnval=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetAccCarPreDepInfo", "CardPreDepRcpt", CardInvRowID, txtDataParaO, listDataO, $lb(JSFunName, CardCost, CardInvRowID, UseID, RePrtFlag))

	quit ""
}

/// Creator: hujunbin
/// CreatDate: 2015-02-14
/// Description: 留观押金小条打印数据
/// Input: EPDepRowID:留观押金ID,UseID:用户ID,RePrtFlag:重打标志 1为重打
/// Output:	js调用，返回打印信息
/// Debug: w ##class(web.UDHCOPPrtInfo0).GetEPPreDepInfo("","48||1","1","")
ClassMethod GetEPPreDepInfo(JSFunName As %String, EPDepRowID As %String, UseID As %String, RePrtFlag As %String) As %String
{
	set MyUserCode=$p(^SSU("SSUSR",UseID),"^",1)
	set MyUserName=$p(^SSU("SSUSR",UseID),"^",2)

	set MyEPMRowID=+EPDepRowID
	set MyEposideID=$p($g(^DHCEPM("EPM",MyEPMRowID)),"^",2)
	set MyPAPMIDR=$p($g(^DHCEPM("EPM",MyEPMRowID)),"^",3)
	set MyPAName=$p(^PAPER(MyPAPMIDR,"ALL"),"^",1)
	set MyPAPMINO=$p($g(^DHCEPM("EPM",MyEPMRowID)),"^",4)
	set MyAdmLoc=$p($g(^PAADM(MyEposideID)),"^",4)
	set MyAdmWard=$p($g(^PAADM(MyEposideID)),"^",70)
	set MyAdmBed=$p($g(^PAADM(MyEposideID)),"^",73)
	set MyAdmDate=$p($g(^PAADM(MyEposideID)),"^",6)
	set MyAdmDate=##class(websys.Conversions).DateLogicalToHtml(MyAdmDate)
	set MyAdmReasonID=$p($g(^PAADM(MyEposideID,1)),"^",7)
	set MyAdmReason=$s((+MyAdmReasonID'=0):$p($g(^PAC("ADMREA",MyAdmReasonID)),"^",2),1:"")

	set MyLocDesc=$s((+MyAdmLoc'=0):$p($g(^CTLOC(MyAdmLoc)),"^",2),1:"")
	
	set MyWardDesc=$s((+MyAdmWard'=0):$p($g(^PAWARD(MyAdmWard)),"^",2),1:"")
	
	set MyBedDesc=""
   	if (MyAdmBed'="") {
	   	set BedID1=$p(MyAdmBed,"||",1)
	   	set BedID2=$p(MyAdmBed,"||",2)
	   	if ((BedID1'="")&&(BedID2'="")) {
			set MyBedDesc=$p($g(^PAWARD(BedID1,"BED",BedID2)),"^",1)
	   	}
   	}
   	
	//^DHCEPM("EPM",{DHC_EPManager.EPM_RowID},"EPMD",{EPMD_Sub})
	set MyPreSum=$p($g(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2))),"^",2)
	set MyRMB=##class(web.UDHCJFBaseCommon).RMBDXXZH(MyPreSum)
	set MyDate=$p($g(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2))),"^",3)
	set MyDate=##class(websys.Conversions).DateLogicalToHtml(MyDate)
	set MyTime=$p($g(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2))),"^",4)
	set MyTime=##class(websys.Conversions).TimeLogicalToHtml(MyTime)
	set MyDateTime=MyDate_" "_MyTime
	set MyBillNo=$p($g(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2))),"^",6)
	set MyBalance=$p($g(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2))),"^",8)
	set MyHospDR=$p($g(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2))),"^",13)
	set MyHospDesc=$s((+MyHospDR'=0):$p($g(^CT("HOSP",MyHospDR)),"^",2),1:"")
	set MyAPMSub=$o(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2),"P",0))
	set MyPMDR=$p(^DHCEPM("EPM",+EPDepRowID,"EPMD",$p(EPDepRowID,"||",2),"P",MyAPMSub),"^",1)
	set MyPayMode=$s((+MyPMDR'=0):$p($g(^CT("CTPM",MyPMDR)),"^",2),1:"")
	set MyRPDesc=$s((+RePrtFlag=1):"补打",1:"")
	set MyPreSum=$fn(MyPreSum,"",2)
	set MyBalance=$fn(MyBalance,"",2)
	
	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("PatName",MyPAName).%Set("amt",MyPreSum)
	do txtDataParaO.%Set("amtdx",MyRMB).%Set("PAPMINO",MyPAPMINO)
	do txtDataParaO.%Set("Balance",MyBalance).%Set("UsrName",MyUserName).%Set("UsrCode",MyUserCode)
	do txtDataParaO.%Set("DateTime",MyDateTime).%Set("BillNo",MyBillNo)
	do txtDataParaO.%Set("RePrintFlag",MyRPDesc).%Set("PayMode",MyPayMode)
	do txtDataParaO.%Set("AdmLoc",MyLocDesc).%Set("AdmWard",MyWardDesc)
	do txtDataParaO.%Set("AdmBed",MyBedDesc).%Set("AdmReason",MyAdmReason)
	do txtDataParaO.%Set("AdmDate",MyAdmDate).%Set("HospDesc",MyHospDesc)
	
	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	set listDataO=##class(%DynamicArray).%New()
	set prtListInfo=""
	set RtnVal=JSFunName_"('"_$zcvt(prtTxtInfo,"O","JS")_"','"_$zcvt(prtListInfo,"O","JS")_"');"
	&javascript<#(RtnVal)#>
	
	//+2022-05-20 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetEPPreDepInfo", "EPDepRcpt", EPDepRowID, txtDataParaO, listDataO, $lb(JSFunName, EPDepRowID, UseID, RePrtFlag))

	quit ""
}

}
