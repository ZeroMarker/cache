/// 名称：		EMRservice.BOEMROrganizationScheme
/// 描述：		方案配置BO层
/// 编写者：	yejian
/// 编写时间：	2014-8-30
Class EMRservice.BOEMROrganizationScheme Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMROrganSchemeInfo";

/// d ##Class(EMRservice.BOEMROrganizationScheme).SelectALL()
ClassMethod SelectALL() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMROrganizationScheme:SelectALL")
	d result.SetArgs()
	q result
}

/// 增加一个项目
ClassMethod CreateOrganScheme(aOrganScheme As EMRservice.entity.EEMROrganizationScheme) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganizationScheme).CreateOrganScheme(aOrganScheme)
}

/// 增加一个项目类型
ClassMethod CreateOrganTypeScheme(aOrganScheme As EMRservice.entity.EEMROrganizationScheme) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganizationScheme).CreateOrganTypeScheme(aOrganScheme)
}

/// 删除一个项目
ClassMethod DeleteOrganSchemeByID(aOrganSchemeId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganizationScheme).DeleteOrganSchemeByID(aOrganSchemeId)
}

/// 删除一个项目
ClassMethod DeleteOrganSchemeTypeByID(aOrganSchemetypeId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganizationScheme).DeleteOrganSchemeTypeByID(aOrganSchemetypeId)
}

/// 更新一个项目
ClassMethod UpdateOrganScheme(aOrganScheme As EMRservice.entity.EEMROrganizationScheme) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganizationScheme).UpdateOrganScheme(aOrganScheme)
}

/// 更新标题顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganizationScheme).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganizationScheme).GetMaxCode()
}

}
