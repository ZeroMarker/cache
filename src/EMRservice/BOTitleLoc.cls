/// 名称：		EMRservice.BOTitleLoc
/// 描述：		标题科室BO层
/// 编写者：	yejian
/// 编写时间：	2015-12-17
Class EMRservice.BOTitleLoc Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TitleLocInfo";

/// w ##Class(EMRservice.BOTitleLoc).SelectAllDetails("12||1")
ClassMethod SelectAllLocRowId() As %XML.DataSet [ WebMethod ]
{
		s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitleLoc:SelectAllLocRowId")
		d result.SetArgs()
		q result
}

/// w ##Class(EMRservice.BOTitleLoc).SelectAllDetails("12||1")
ClassMethod SelectAllConLoc(aTitleID As %String) As %XML.DataSet [ WebMethod ]
{
		s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitleLoc:SelectAllConLoc")
		d result.SetArgs(aTitleID)
		q result
}

/// 增加标题关联科室
ClassMethod CreateTitleLoc(aOrganTitleLoc As EMRservice.entity.ETitleLoc) As %String [ WebMethod ]
{
		q ##Class(EMRservice.BL.BLTitleLoc).CreateTitleLoc(aOrganTitleLoc)
}

/// 删除标题关联科室
ClassMethod DeleteTitleLocByID(aTitleLocId As %String) As %String [ WebMethod ]
{
		q ##Class(EMRservice.BL.BLTitleLoc).DeleteTitleLocByID(aTitleLocId)
}

/// 更新标题关联科室
ClassMethod UpdateTitleLoc(aOrganTitleLoc As EMRservice.entity.ETitleLoc) As %String [ WebMethod ]
{
		q ##Class(EMRservice.BL.BLTitleLoc).UpdateTitleLoc(aOrganTitleLoc)
}

}
