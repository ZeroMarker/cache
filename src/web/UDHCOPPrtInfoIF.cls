Class web.UDHCOPPrtInfoIF Extends %RegisteredObject
{

/// 专门针对于非发票的打印
/// w ##class(web.UDHCOPPrtInfoIF).GetPrtInfo("","",)
ClassMethod GetPrtInfo(JSFunName As %String, PrtXMLName As %String, TabRowID As %String, UseID As %String, ExpStr As %String) As %String
{
	set myrtn=0
	//门诊预交金打印小条信息
	if (PrtXMLName="UDHCAccDeposit"){
		set RePrtFlag=$p(ExpStr,"^",1)
		set myrtn=##class(web.UDHCOPPrtInfo0).GetAccPreDepInfo(JSFunName, TabRowID, UseID, RePrtFlag)
	}
	//+2014-2-14 hujunbin 留观押金打印小条信息
	if (PrtXMLName="UDHCEPMDeposit"){
		set RePrtFlag=$p(ExpStr,"^",1)
		set myrtn=##class(web.UDHCOPPrtInfo0).GetEPPreDepInfo(JSFunName, TabRowID, UseID, RePrtFlag)
	}
	quit myrtn
}

/// 用来 打印病人首页的信息
ClassMethod GetPatInfoForFirstPage(JSFunName As %String, PrtXMLName As %String, PAPMIDR As %String, UserDR As %String, ExpStr As %String) As %String
{
	s myrtn=0
	
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	s myClsName="web.UDHCOPPrtInfo"_myVer
	
	s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"GetPatInfoForFirstPage")
	if (myflag) {
		s myrtn= $ZOBJCLASSMETHOD(myClsName, "GetPatInfoForFirstPage", JSFunName, PAPMIDR)
	}else{
		if (+myVer=0){
			
		}elseif(+myVer=1){
			
		}elseif(+myVer=7){
			;华西一院
			s myrtn=##class(web.UDHCOPPrtInfo7).GetPatInfoForFirstPage(JSFunName, PAPMIDR, ExpStr)
		}
	}
	q myrtn
}

/// 获取发卡时打印的发票 小条
/// w ##class(web.UDHCOPPrtInfoIF).GetRegINVPRTData("","","")
ClassMethod GetRegINVPRTData(JSFunName As %String, PrtXMLName As %String, CardINVDR As %String, UserDR As %String, ExpStr As %String) As %String
{
	
	s myrtn=0
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myClsName="web.UDHCOPPrtInfo"_myVer
	
	s myflag=##class(websys.Conversions).IsValidMethodName(myClsName, "GetRegINVPRTData")
	if (myflag) {
		s myrtn=$ZOBJCLASSMETHOD(myClsName, "GetRegINVPRTData", JSFunName, CardINVDR)
	}else{
		
	}
	
	q myrtn
}

}
