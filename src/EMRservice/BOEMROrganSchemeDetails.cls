/// 名称：		EMRservice.BOEMROrganSchemeDetails
/// 描述：		方案明细BO层
/// 编写者：	yejian
/// 编写时间：	2014-9-2
Class EMRservice.BOEMROrganSchemeDetails Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMROrganSchemeDetailsInfo";

/// w ##Class(EMRservice.BOEMROrganSchemeDetails).SelectAllDetails("12||1")
ClassMethod SelectAllDetails(aTypeID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMROrganSchemeDetails:SelectAllDetails")
	d result.SetArgs(aTypeID)
	q result
}

/// 增加一个项目
ClassMethod CreateSchemeDetails(aTypeID As %String, aOrganSchemeDetails As EMRservice.entity.EEMROrganSchemeDetails) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeDetails).CreateSchemeDetails(aTypeID,aOrganSchemeDetails)
}

/// 删除一个项目
ClassMethod DeleteSchemeDetailsByID(aSchemeDetailsId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeDetails).DeleteSchemeDetailsByID(aSchemeDetailsId)
}

/// 更新一个项目
ClassMethod UpdateSchemeDetails(aOrganSchemeDetails As EMRservice.entity.EEMROrganSchemeDetails) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeDetails).UpdateSchemeDetails(aOrganSchemeDetails)
}

/// 更新标题顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeDetails).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMROrganSchemeDetails).GetMaxCode()
}

}
