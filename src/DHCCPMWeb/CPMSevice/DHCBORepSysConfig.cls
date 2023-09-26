/// 报表系统配置
Class DHCCPMWeb.CPMSevice.DHCBORepSysConfig Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCBORepSysConfig";

/// Parameter LOCATION = "http://192.168.0.132/trakcare/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 获得系统配置对象
ClassMethod GetRepSysConfig() As DHCCPMWeb.CPMSevice.entity.DHCERepSysConfig [ WebMethod ]
{
	s myobj=##class(DHCCPMWeb.CPMBL.DHCBLRepSysConfig).GetRepSysConfig()
	
	QUIT myobj
}

ClassMethod UPDATEREPCONFIG(ERSC As DHCCPMWeb.CPMSevice.entity.DHCERepSysConfig) As %String [ WebMethod ]
{
	n (ERSC)
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepSysConfig).UPDATE(ERSC)
	
	QUIT myrtn
}

}
