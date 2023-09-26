Class CHSSWeb.HISInfoTranCardWebService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter LOCATION = "http://localhost/trakcarelivess/trak/Web";

/// Name of the WebService.
Parameter SERVICENAME = "CHSSWeb.HISInfoTranCardWebService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CHSSWeb/HISInfoTranCardWebService";

/// 根据卡号检索病人信息
ClassMethod HISInfoTranCard(XMLPara As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInfoTranCardService).HISInfoTranCard(XMLPara)
	Quit rtn
}

}
