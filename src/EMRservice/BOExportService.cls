Class EMRservice.BOExportService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ExportServiceInfo";

/// 查询AEpisodeId获取病历实例ID
ClassMethod GetAllInstanceIDByEpisodeID(AEpisodeId As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLExportService:GetAllInstanceIDByEpisodeID")
	d result.SetArgs(AEpisodeId)
	q result
}

/// 获取签名信息
ClassMethod GetSignInfo(AInstanceID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLExportService:GetSignInfo")
	d result.SetArgs(AInstanceID)
	q result
}

/// 获取文档名称
ClassMethod GetRecordDocName(AInstanceID As %String) As %String [ WebMethod ]
{
	s result=##Class(EMRservice.BL.BLExportService).GetRecordDocName(AInstanceID)
	q result
}

}
