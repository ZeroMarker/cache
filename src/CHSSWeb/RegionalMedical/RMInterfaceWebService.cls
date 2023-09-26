/// 区域协同对应接口
/// http://localhost/trakcarelivess/trak/web/CHSSWeb.RegionalMedical.RMInterfaceWebService.cls
Class CHSSWeb.RegionalMedical.RMInterfaceWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter LOCATION = "http://localhost/trakcarelivess/trak/Web";

/// Name of the WebService.
Parameter SERVICENAME = "CHSSWeb.RegionalMedical.RMInterfaceWeb";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CHSSWeb/RegionalMedical/RMInterfaceWeb";

/// TODO:根据身份证号判读是否存在个人档案(返回 0:不存在；1:存在)
ClassMethod GetPersonInfo(IDCard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.RegionalMedical.RMInterface).CheckPersonWithIDCard(IDCard)
	Quit rtn
}

}
