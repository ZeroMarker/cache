Class EMRservice.BOSystemParameter Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SystemParameterInfo";

/// 增加一个项目
ClassMethod SetEMRShowTreeNodeDelete() As %String [ WebMethod ]
{
	q ##Class(EMRservice.SystemParameter).SetEMRShowTreeNodeDelete()
}

/// 创建模板方式
ClassMethod GetCreateStatus() As %String [ WebMethod ]
{
	q ##Class(EMRservice.SystemParameter).GetCreateStatus()
}

}
