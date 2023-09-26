/// 名称:EMRservice.BOTemplateUserAccess
/// 描述:模板用户模板权限控制BO层
/// 编写者：yejian
/// 编写日期: 2018-12-13
Class EMRservice.BOTemplateUserAccess Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateUserAccessInfo";

/// 获取所有数据
ClassMethod SelectAllData(aSupUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##class(%XML.DataSet).%New("EMRservice.BL.BLTemplateUserAccess:SelectAllData")
	d result.SetArgs(aSupUserID)
	q result
}

/// 获取所有模板用户
ClassMethod SelectALLSUser() As %XML.DataSet [ WebMethod ]
{
    s result=##class(%XML.DataSet).%New("EMRservice.BL.BLTemplateUserAccess:SELECTALL")
	d result.SetArgs()
	q result
}

/// 添加模板用户数据
ClassMethod CreateUserAccess(argEUserAccess As EMRservice.entity.ETemplateUserAccess) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateUserAccess).CreateUserAccess(argEUserAccess)
}

/// 删除模板用户数据
ClassMethod DeleteUserAccess(AIDs As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateUserAccess).DeleteUserAccess(AIDs)
}

}
