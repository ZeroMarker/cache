Class EMRservice.BOEPRQuotePage Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRQuotePage";

//查询

ClassMethod GetData() As EMRservice.dataset.EEPRPageURLAllDataset [ WebMethod ]
{
	Set result = ##class(EMRservice.dataset.EEPRPageURLAllDataset).%New()
	quit result
}

//更新

ClassMethod UpdateData(rowID As %String, URL As %String, Paras As %String, Title As %String, Num As %String, Type As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEPRPageURL).UpdateData(rowID,URL,Paras,Title,Num,Type)
}

//增加

ClassMethod AddData(URL As %String, Paras As %String, Title As %String, Num As %String, Type As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEPRPageURL).AddData(URL,Paras,Title,Num,Type)
}

//删除

ClassMethod DeleteData(rowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEPRPageURL).DeleteData(rowID)
}

}
