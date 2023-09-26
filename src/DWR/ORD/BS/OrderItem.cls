/// DWR.ORD.BS.OrderItem
Class DWR.ORD.BS.OrderItem Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "OrderItem";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// 查询医嘱
Method OrderItemQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.ORD.BL.OrderItem).OrderItemQry(pRequest)
	quit pResponse
}

/// 查询检验报告
Method LISReportQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.ORD.BL.LISReport).LISReportQry(pRequest)
	quit pResponse
}

/// 查询检验项目图表数据
Method LISTestItemChartQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.ORD.BL.LISReport).LISTestItemChartQry(pRequest)
	quit pResponse
}

/// 查询检查报告
Method RISReportQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.ORD.BL.RISReport).RISReportQry(pRequest)
	quit pResponse
}

}
