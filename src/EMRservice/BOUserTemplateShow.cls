///  名称：		EMRservice.BOUserTemplateShow
///  描述：		用户模板展现BO层
///  编写者：	yejian
///  编写时间：	2018-1-12
Class EMRservice.BOUserTemplateShow Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "UserTemplateShowInfo";

/// 获取该模板下用户模板
/// Debug: ##class(EMRservice.BOUserTemplate).GetCategory("6")
ClassMethod GetCategory(ACTLocID As %String, schemType As %String = "RUNNING") As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateShow:GetCategory")
	d result.SetArgs(ACTLocID,schemType)
	Quit result
}

/// 获取该模板下用户模板
/// Debug: ##class(EMRservice.BOUserTemplate).GetAllLoc("6")
ClassMethod GetTempCateJsonByCategoryID(AParentID As %String, ACTLocID As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateShow:GetTempCateJsonByCategoryID")
	d result.SetArgs(AParentID,ACTLocID)
	Quit result
}

/// Desc:       根据标题编码取标题信息
/// Creator:    yejian
/// CreateDate: 2018-7-6
/// Input:      ATiteCode 标题编码
/// Debug: d ##Class(EMRservice.BOUserTemplateShow).GetTitleByCode(4)
ClassMethod GetTitleByCode(ATiteCode As %String) As EMRservice.entity.ETitles [ WebMethod ]
{
	 q ##Class(EMRservice.BL.BLUserTemplateShow).GetTitleByCode(ATiteCode)
}

}
