Class EMRservice.BOTemKBApprove Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemKBApproveInfo";

ClassMethod SELECTALL() As EMRservice.dataset.ETemKBApproveDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ETemKBApproveDataset).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SelectTemData() As %XML.DataSet [ WebMethod ]
{
 s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTemKBApprove:SelectTemData")
	d result.SetArgs()
	q result
}

ClassMethod SelectKBData() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTemKBApprove:SelectKBData")
	d result.SetArgs()
	q result
}

ClassMethod SelectByID(aID As %String) As EMRservice.dataset.EMedConceptCateByIDDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ETemKBApproveByIDDataset).%New()
 Do result.SetArgs(aID)
 Quit result
}

/// 增加一个审核备注
ClassMethod CreateTemKB(aTemKB As EMRservice.entity.ETemKBApprove) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemKBApprove).CreateTemKB(aTemKB)
}

/// 删除一个审核备注
ClassMethod DeleteTemKBByID(aTemKBId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemKBApprove).DeleteTemKBByID(aTemKBId)
}

/// 更新一个审核备注
ClassMethod UpdateTemKB(aTemKB As EMRservice.entity.ETemKBApprove) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemKBApprove).UpdateTemKB(aTemKB)
}

/// 批量发布模板
ClassMethod TemPublishVersion(AVerionIDS As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemKBApprove).TemPublishVersion(AVerionIDS)
}

/// 批量启用知识库
ClassMethod KBPublish(AKBNodeIDS As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemKBApprove).KBPublish(AKBNodeIDS)
}

}
