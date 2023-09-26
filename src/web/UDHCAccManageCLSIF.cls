/// 为了账户信息的版本控制新增接口
Class web.UDHCAccManageCLSIF Extends %RegisteredObject
{

/// w ##class(web.UDHCAccManageCLSIF).AccInfoTip("337","Foot","")
ClassMethod AccInfoTip(AccRowID As %String, TipType As %String, ExpStr As %String) As %String
{
	s mystrTip=""
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		i (TipType="Foot") d
		.s mystrTip=##class(web.UDHCAccManageCLS).AccInfoTip(AccRowID, TipType)
	}else{
		
	}
	
	;myTipRtn=1  提示
	;myTipRtn=0  不提示
	q mystrTip
}

/// w ##class(web.UDHCAccManageCLSIF).GetAccMDepPrice("25", "","")
ClassMethod GetAccMDepPrice(AccRowID As %String, AdmStrInfo As %String, ExpStr As %String) As %String
{
	s myDPrice=0
	;q:(AccRowID="") 0
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		;北京积水潭	
		s myDPrice=##class(web.UDHCAccManageCLS0).GetAccMDepPrice(AccRowID, AdmStrInfo)
	}elseif(+myVer=1){
		
	}else{
		s myDPrice=##class(web.UDHCAccManageCLS7).GetAccMDepPrice(AccRowID, AdmStrInfo)
	}
	
	q myDPrice
}

/// w ##class(web.UDHCAccManageCLSIF).getaccinfofromcardno("000000999883","",""_$c(2)_"1"_$c(2)_"PatInfo")
ClassMethod getaccinfofromcardno(cardno As %Library.String, securityno As %Library.String, ExpStr As %String) As %Library.String
{
	;可以增加任何的扩展参数
	;ExpStr=AdmStr_$c(2)_CardTypeDR
	;AdmStr=AdmRowID1^AdmRowID2^AdmRowID3
	;CardTypeDR  卡类型的RowID
	;
	;ExpStr=""_$c(2)_""_$c(2)_"PatInfo"
	s myAccInfo=""
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	s myAdmStr=$p(ExpStr,$c(2),1)
	s myCardTypeDR=$p(ExpStr,$c(2),2)
	s myCheckSecurityFlag=$p(ExpStr,$c(2),3)
	s myHospDR=$p(ExpStr,$c(2),4)     //2022-03-14 ZhYW
	if securityno[$c(0) set securityno=$p(securityno,$c(0),1)  //liuyewu 20120410修改
	
	if (+myVer=0) {
		//北京积水潭
		s myAccInfo=##class(web.UDHCAccManageCLS0).getaccinfofromcardno(cardno, securityno, myAdmStr)
	}elseif(+myVer=1){
		s myAccInfo=##class(web.UDHCAccManageCLS).getaccinfofromcardno(cardno, securityno)
	}else{
		s myExpStr=myHospDR
		s myAccInfo=##class(web.UDHCAccManageCLS7).getaccinfofromcardno(cardno, securityno, myCardTypeDR, myAdmStr, myCheckSecurityFlag, myExpStr)
	}
	
	q myAccInfo
}

/// w ##class(web.UDHCAccManageCLSIF).GetAccInfoByPAPMI("00000117","00000117","")
ClassMethod GetAccInfoByPAPMI(CardNO As %String, PAPMINO As %String, ExpStr As %String) As %String
{
	;;为了解决读卡过程中显示
	;;;此处的前提是卡已经有效，此处不在判断卡是否有效
	;;;CardNo=卡号
	;;;PAPMINO=登记号
	;;;ExpStr=参数1_$c(2)_参数2_$c(2)_参数3
	;;;参数=^^^^的组合
	
	s myAccInfo=""
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		s myAdmInfo=$p(ExpStr,$c(2),1)
		s myAccInfo=##class(web.UDHCAccManageCLS0).GetAccInfoByPAPMI(CardNO, PAPMINO, myAdmInfo)
	}else{
		s myAccInfo=##class(web.UDHCAccManageCLS0).GetAccInfoByPAPMI(CardNO, PAPMINO,"")
	}
	
	q myAccInfo
}

/// 结算账户激活功能
/// 
ClassMethod AccCallBack(AccRowID As %String, UserDR As %String, CardInfo As %String, CompIP As %String, ExpStr As %String) As %String
{
	;ExpStr 组成： 
	;ExpStr 组成：  CardRowID^
	s ^TMPAccCallBack=$lb(AccRowID, UserDR, CardInfo, CompIP, ExpStr)
	
	s myrtn=0
	s myCardRowID=$p(ExpStr,"^",1)
	s myrtn=##class(web.UDHCAccManageCLS12).AccCallBack(AccRowID,UserDR, CardInfo, CompIP, myCardRowID, ExpStr)
	
	q myrtn
}

/// w ##class(web.UDHCAccManageCLSIF).AccCallBackTest()
ClassMethod AccCallBackTest() As %String
{
	;s ^TMPAccCallBack=$lb(AccRowID, UserDR, CardInfo, CompIP, ExpStr)
	s AccRowID=$list(^TMPAccCallBack,1)
	s UserDR=$list(^TMPAccCallBack,2)
	s CardInfo=$list(^TMPAccCallBack,3)
	s CompIP=$list(^TMPAccCallBack,4)
	s ExpStr=$list(^TMPAccCallBack,5)
	s myrtn=..AccCallBack(AccRowID, UserDR, CardInfo, CompIP, ExpStr)
	
	q myrtn
}

/// w ##class(web.UDHCAccManageCLSIF).CheckCheque("100")
ClassMethod CheckCheque(AccRowID As %String) As %String
{
	s rtn="false"
	q:$g(AccRowID)="" rtn
	s AccPDSub="0"
	f  s AccPDSub=$o(^DHCACD("AccM",AccRowID,"AccPD",AccPDSub)) q:(AccPDSub="")||(rtn="true")  d
	.s AccPDPMsub="0"
	.f  s AccPDPMsub=$o(^DHCACD("AccM",AccRowID,"AccPD",AccPDSub,"P",AccPDPMsub)) q:(AccPDPMsub="")||(rtn="true")  d
	..s myPayModeDR=$p(^DHCACD("AccM",AccRowID,"AccPD",AccPDSub,"P",AccPDPMsub),"^",1)
	..q:myPayModeDR=""
	..s myPayModeDesc=$p($g(^CT("CTPM",myPayModeDR)),"^",2)
	..q:myPayModeDesc=""
	..q:myPayModeDesc="现金"
	..s rtn="true"
	q rtn
}

}
