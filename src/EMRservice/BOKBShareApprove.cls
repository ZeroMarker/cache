///  名称：		EMRservice.BOKBShareApprove
///  描述：		个人知识库分享审核BO层
///  编写者：	yejian
///  编写时间：	2019-6-19
Class EMRservice.BOKBShareApprove Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBShareApproveInfo";

ClassMethod SelectKBData() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLKBShareApprove:SelectKBData")
	d result.SetArgs()
	q result
}

/// 批量更新审核备注
ClassMethod UpdateKBShareStatus(AKBNodeShareIDS As %String, AStatus As %String, aAuditID As %String, Remark As %String = "") As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBShareApprove).UpdateKBShareStatus(AKBNodeShareIDS,AStatus,aAuditID,Remark)
}

/// 更新一个审核备注
ClassMethod UpdateKBShare(aKBNodeShare As EMRservice.entity.EKBNodeShare) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBShareApprove).UpdateKBShare(aKBNodeShare)
}

}
