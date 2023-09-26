/// creator:郭荣勇
/// date:20170524
/// desc:为外部机构建病案信息提供HIS服务接口
Class DHCDoc.Interface.Outside.Template.Service.Template Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Parameter LOCATION = "http://IPAddress/DTHealth/web/DHCDoc.Interface.Outside.Template.Service.Template";
/// Name of the WebService.
Parameter SERVICENAME = "Template";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Method TestNet() As %String [ WebMethod ]
{
	q "OK"
}

/// 查询信息示例
Method GetInfoExample(Input As %String) As DHCDoc.Interface.Outside.Template.Entity.GetPatInfoRp [ WebMethod ]
{
	s RtnObj=##class(DHCDoc.Interface.Outside.Template.Methods).GetInfoExample(Input)
	;d RtnObj.XMLExportToString(.RtnXml,"Response")
	q RtnObj
}

/// 查询科室列表（XML list 结构示例）
Method QueryDepartment(Input As %String) As DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRp [ WebMethod ]
{
	q ##class(DHCDoc.Interface.Outside.Template.Methods).QueryDepartment(Input)
}

/// 查询科室列表（JSON list 结构示例）
Method QueryDepartmentJson(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCDoc.Interface.Outside.Template.Methods).QueryDepartmentJson(Input)
}

}
