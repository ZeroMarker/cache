/// 名称：		EMRservice.BOEMRNavigationSchemeItemLoc
/// 描述：		病历分组科室关联BO
/// 编写者：	yejian
/// 编写时间：	2017-8-15
Class EMRservice.BOEMRTemplateGroupLoc Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOEMRTemplateGroupLocInfo";

/// w ##Class(EMRservice.BOEMRTemplateGroupLoc).SelectAllDetails("12||1")
ClassMethod SelectAllLocRowId() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRTemplateGroupLoc:SelectAllLocRowId")
	d result.SetArgs()
	q result
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定方案项下的所有科室ID
/// Input: aGroupCode
/// Return: locid|name^locid|name^locid|name
ClassMethod GetGroupLoc(aGroupCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupLoc).GetGroupLoc(aGroupCode)
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定方案项下所适用的科室
/// Input: docID--docID, sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(aGroupCode As %String, sltLocs As %String, unSltLocs As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupLoc).ModifyLoc(aGroupCode,sltLocs,unSltLocs)
}

}
