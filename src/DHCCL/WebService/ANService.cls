/// DHCCL.WebService.ANService
Class DHCCL.WebService.ANService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "ANService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// BI接口-获取麻醉质控接口
Method GetAnaQualityControlDetail(OperScheduleID As %String, EpisodeID As %String, DischargeDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	quit ##class(DHCCL.Factory.ANInterfaceFactory).GetService().GetAnaQualityControlJson(OperScheduleID,EpisodeID,DischargeDate)
}

/// BI接口-获取麻醉主题接口
Method GetAnaOperThemeInfo(OperScheduleID As %String, EpisodeID As %String, DischargeDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	quit ##class(DHCCL.Factory.ANInterfaceFactory).GetService().GetAnaOperThemeInfoJson(OperScheduleID,EpisodeID,DischargeDate)
}

}
