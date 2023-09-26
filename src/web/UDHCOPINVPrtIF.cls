Class web.UDHCOPINVPrtIF Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.UDHCOPINVPrtIF).GetOPCommPrtData()
ClassMethod GetOPCommPrtData(JSFunName As %String, ClassName As %String, MethodName As %String, PrtXMLName As %String = "", InvRowID As %String, UseID As %String, PayMode As %String, ExpStr As %String) As %String
{
	new (ClassName, MethodName, PrtXMLName, JSFunName, InvRowID, UseID, PayMode, ExpStr, %session)
	set ^TMP("GetOPCommPrtData")=$lb(ClassName, MethodName, PrtXMLName, JSFunName, InvRowID, UseID, PayMode, ExpStr)
	set myrtn=$classmethod(ClassName, MethodName, JSFunName, PrtXMLName, InvRowID, UseID, PayMode, ExpStr)
	quit myrtn
}

/// w ##class(web.UDHCOPINVPrtIF).GetOPPrtDataOtherDevice("DHCWCOM_OtherPrintDeviceEquip","web.DHCBL.Register.PrintInfo","PrintBarCode","44","0^440240^","")
ClassMethod GetOPPrtDataOtherDevice(JSFunName As %String, ClassName As %String, MethodName As %String, PrintDeviceDR As %String, InvRowID As %String, ExpStr As %String) As %String
{
	new (JSFunName, ClassName, MethodName, PrintDeviceDR, InvRowID, ExpStr)		
	set myrtn=$classmethod(ClassName, MethodName, JSFunName, PrintDeviceDR, InvRowID, ExpStr)
	quit myrtn
}

/// 传入参数的分析
/// 提供一个门诊发票的统一打印接口
/// 1.门诊结算时需要打印的发票或结算小条
/// 2.账户结算的费用统一打印发票
/// w ##class(web.UDHCOPINVPrtIF).GetOPPrtData("", "INVPRT","1996","10534","HDD","")
ClassMethod GetOPPrtData(JSFunName As %String, PrtXMLName As %String = "", InvRowID As %String, UseID As %String, PayMode As %String, ExpStr As %String) As %String
{
	new (PrtXMLName, JSFunName, InvRowID, UseID, PayMode, ExpStr, %session)
	set myrtn=0
	set myVer=##class(web.DHCOPConfig).GetVersion()
	
	set myFactpay=$p(ExpStr,"^",1)
	set myChange=$p(ExpStr,"^",2)
	set myGroupDR=$p(ExpStr,"^",3)
	
	if (+myVer=0) {
		
	}elseif(+myVer=12){
		if (PrtXMLName="INVPrtFlag2007") {
			//门诊收费打印模版
			quit ##class(web.UDHCOPINVPrtData12).GetOPPrtData(JSFunName, InvRowID, UseID, PayMode,"INVPrtFlag2007")
		}
		if (PrtXMLName="INVPrtFlagCPP") {
			//卡支付集中打印发票
			quit ##class(web.UDHCOPINVPrtData12).GetOPAccPayPrtData(JSFunName,PrtXMLName, InvRowID, UseID, PayMode, ExpStr)
		}
		if (PrtXMLName="OPCCardPayPrt") {
			//卡支付时，打印的小票
			quit ##class(web.UDHCOPINVPrtData12).GetOPAccPayList(JSFunName, InvRowID, UseID, PayMode)
		}
	}else {
		quit ##class(web.UDHCOPINVPrtData).GetOPPrtData(JSFunName, InvRowID, UseID, PayMode, myFactpay)
	}
	
	quit myrtn
}

ClassMethod OtherDeviceTest(JSFunName As %String, PrintDeviceDR As %String, InvRowID As %String, ExpStr As %String) As %String
{
	;前面需要写参数值
	;后面
	set myInPara1="2"
	set myInPara2=""
	set myInPara3="1"
	
	set rtnval=JSFunName_"('"_$ZCVT($g(PrintDeviceDR),"O","JS")_"','"_$ZCVT($g(myInPara1),"O","JS")_"','"_$ZCVT($g(myInPara2),"O","JS")_"','"
	set rtnval=rtnval_$ZCVT($g(myInPara3),"O","JS")_"');"
	&javascript<#(rtnval)#>
}

/// w ##class(web.UDHCOPINVPrtIF).RMBConvert()
ClassMethod RMBConvert(numstr As %String) As %String
{
	quit ##class(web.UDHCJFBaseCommon).RMBDXXZH(numstr)
}

}
