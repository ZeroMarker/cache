/// 名称：		EMRservice.BOEMRNavigationSchemeItemLoc
/// 描述：		方案项科室BO层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.BOEMRNavSchemeItemLoc Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRNavSchemeItemLocInfo";

/// w ##Class(EMRservice.BOEMROrganSchemeDetails).SelectAllDetails("12||1")
ClassMethod SelectAllLocRowId() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRNavSchemeItemLoc:SelectAllLocRowId")
	d result.SetArgs()
	q result
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定方案项下的所有科室ID
/// Input: aSchemeCode,
/// Return: locid|name^locid|name^locid|name
ClassMethod GetItemLoc(aSchemeCode As %String, aItemCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavSchemeItemLoc).GetItemLoc(aSchemeCode,aItemCode)
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定方案项下所适用的科室
/// Input: docID--docID, sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(aSchemeCode As %String, aItemCode As %String, sltLocs As %String, unSltLocs As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavSchemeItemLoc).ModifyLoc(aSchemeCode,aItemCode,sltLocs,unSltLocs)
}

}
