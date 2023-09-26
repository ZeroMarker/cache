/// 死亡证明书编号系统接口
/// http://10.193.106.128:1972/csp/dhc-app/DHCMed.DTHCustom.RepNoWS.cls?WSDL
Class DHCMed.DTHCustom.RepNoWS Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter SERVICENAME = "DTHRepNoWS";

Parameter LOCATION = "http://10.193.106.128:1972/csp/dhc-app";

Parameter NAMESPACE = "http://tempuri.org";

/// w ##class(DHCMed.DTHCustom.RepNoWS).GetNewDeathNo()
ClassMethod GetNewDeathNo(aDTHHospCode As %String) As %String [ WebMethod ]
{
	Set return=##Class(DHCMed.DTHService.RepNoSrv).GetNewDeathNo("",aDTHHospCode)
	Quit return
}

}
