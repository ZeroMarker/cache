/// 名称: DHCMed.DCEns.LIS.TSResultWS
/// 描述: 检验系统输入接口服务类
/// 编写者：zhufei
/// 编写日期: 2016-03-04
/// http://10.193.106.128:1972/csp/dhc-app/DHCMed.DCEns.LIS.TSResultWS.cls?WSDL
Class DHCMed.DCEns.LIS.TSResultWS Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "LISInputServiceWS";

Parameter LOCATION = "http://10.193.106.128:1972/csp/dhc-app";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 保存检验结果
Method SaveTSResult(xmlStream As %GlobalCharacterStream) As %String [ WebMethod ]
{
	Set return=##class(DHCMed.DCEns.LIS.TSResultByWS).SaveTSResult(xmlStream)
	Quit return
}

}
