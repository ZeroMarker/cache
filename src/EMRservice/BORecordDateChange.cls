/// 名称：		EMRservice.BORecordDateChange
/// 描述：		2版病历转换新版BO层
/// 编写者：	yejian
/// 编写时间：	2015-6-18
Class EMRservice.BORecordDateChange Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "RecordDateChangeInfo";

/// 取得所有带有模板组信息的template 
ClassMethod GetUserName(AUserID As %String) As %String [ WebMethod ]
{
  	s result= ##Class(EMRservice.BL.BLRecordDateChange).GetUserName(AUserID)
	q result
}

/// 取得所有带有模板组信息的template 
ClassMethod GetTitleName(ACode As %String) As %String [ WebMethod ]
{
  	s result= ##Class(EMRservice.BL.BLRecordDateChange).GetTitleName(ACode)
	q result
}

/// 获取文本信息通过instanceID
ClassMethod getEprInstancedata(InstanceDataID As %String) As %GlobalCharacterStream [ WebMethod ]
{
  	s result= ##Class(EMRservice.BL.BLRecordDateChange).getEprInstancedata(InstanceDataID)
	q result
}

/// 取得所有带有模板组信息的template 
ClassMethod GetInstances(AEpisodeId As %String) As %XML.DataSet [ WebMethod ]
{
  	s result=##class(EMRservice.dataset.ERecordDateCInstancesDataSet).%New()
	d result.SetArgs(AEpisodeId)
	q result
}

}
