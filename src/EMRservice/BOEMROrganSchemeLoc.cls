/// 名称：		EMRservice.BOEMROrganSchemeLoc
/// 描述：		方案科室BO层
/// 编写者：	yejian
/// 编写时间：	2014-9-3
Class EMRservice.BOEMROrganSchemeLoc Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMROrganSchemeLocInfo";

/// w ##Class(EMRservice.BOEMROrganSchemeDetails).SelectAllDetails("12||1")
ClassMethod SelectAllLocRowId() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMROrganSchemeLoc:SelectAllLocRowId")
	d result.SetArgs()
	q result
}

/// w ##Class(EMRservice.BOEMROrganSchemeDetails).SelectAllDetails("12||1")
ClassMethod SelectAllConLoc(aSchemeID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMROrganSchemeLoc:SelectAllConLoc")
	d result.SetArgs(aSchemeID)
	q result
}

/// 增加方案关联科室
ClassMethod CreateSchemeLoc(aOrganSchemeLoc As EMRservice.entity.EEMROrganizationSchemeLoc) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeLoc).CreateSchemeLoc(aOrganSchemeLoc)
}

/// 删除方案关联科室
ClassMethod DeleteSchemeLocByID(aSchemeLocId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeLoc).DeleteSchemeLocByID(aSchemeLocId)
}

/// 更新方案关联科室
ClassMethod UpdateSchemeLoc(aOrganSchemeLoc As EMRservice.entity.EEMROrganizationSchemeLoc) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeLoc).UpdateSchemeLoc(aOrganSchemeLoc)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeLoc).GetMaxCode()
}

}
