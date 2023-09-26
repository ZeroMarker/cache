/// Desc:       范例病历迁移工具类
/// Creator:    yejian
/// CreateDate: 2018-8-6
Class EMRservice.BOExampleTool Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ExampleToolInfo";

/// 获取所有范例病历
/// Debug:w ##class(EMRservice.BOExampleTool).GetModelInstanceIDs()
ClassMethod GetModelInstanceIDs() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLExampleTool:GetModelInstanceIDs")
	d result.SetArgs()
	Quit result
}

}
