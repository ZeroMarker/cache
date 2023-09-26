/// 名称：		EMRservice.BOEMRNavigationScheme
/// 描述：		方案配置BO层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.BOEMRNavigationScheme Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRNavSchemeeInfo";

/// d ##Class(EMRservice.BOEMRNavigationScheme).SelectALL()
ClassMethod SelectALL() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRNavigationScheme:SelectALL")
	d result.SetArgs()
	q result
}

/// q ##Class(EMRservice.BOEMRNavigationScheme).TestCategory("","6","Running")
ClassMethod TestCategory(AEpisodeID As %String, ASSGroup As %String, ACTLocID As %String) As EMRservice.dataset.EEMRNavigationSchemeShowDataSet [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EEMRNavigationSchemeShowDataSet).%New()
	d result.SetArgs(ACTLocID,ASSGroup,AEpisodeID)
	Quit result
}

/// 增加一个项目
ClassMethod CreateOrganScheme(aOrganScheme As EMRservice.entity.EEMRNavigationScheme) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationScheme).CreateOrganScheme(aOrganScheme)
}

/// 删除一个项目
ClassMethod DeleteOrganSchemeByID(aOrganSchemeId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationScheme).DeleteOrganSchemeByID(aOrganSchemeId)
}

/// 更新一个项目
ClassMethod UpdateOrganScheme(aOrganScheme As EMRservice.entity.EEMRNavigationScheme) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationScheme).UpdateOrganScheme(aOrganScheme)
}

/// 更新标题顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationScheme).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod CheckCode(aCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationScheme).CheckCode(aCode)
}

}
