/// DHCCL.WebService.ICUService
Class DHCCL.WebService.ICUService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "ICUService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// BI接口-获取重症质控指标病人详细信息
Method GetAnaQualityControlDetail(icuaId As %String, EpisodeID As %String, DischargeDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	quit ##class(DHCCL.Factory.ICUInterfaceFactory).GetService().GetICUQualityControlDetail(icuaId,EpisodeID,DischargeDate)
}

}
