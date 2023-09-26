Class DHCEPRFS.Srv.SrvAdmTaskSucceed Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvAdmTaskSucceed";

/// 获取生成成功列表
ClassMethod GetAdmTaskSucceedList(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "") As DHCEPRFS.DataSet.EAdmTaskSucceedDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskSucceedDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType)
	q dataset
}

/// 获取生成成功列表
ClassMethod GetAdmTaskSucceedListPage(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageCount As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "") As DHCEPRFS.DataSet.EAdmTaskSucceedDS [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskSucceedDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,APageCount,APageSize,AEpisodeID,APatientName,AAdmLocID,ADisLocID)
	q dataset
}

ClassMethod GetAdmTaskSucceedListTotalCount(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "") As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s ret = ##class(DHCEPRFS.BL.BLAdmTaskSucceed).GetAdmTaskSucceedTotalCount(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,AEpisodeID,APatientName,AAdmLocID,ADisLocID)
	q ret
}

/// Desc: pdf生成时，生成项和规则项对比校验
ClassMethod CreateCheckExist(AEpisodeID As %String, AVersionTypeCode As %String, ARuleCode As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLIntegrityCheck:CreateCheckExist")
	d ds.SetArgs(AEpisodeID,AVersionTypeCode,ARuleCode)
	q ds
}

/// 获取生成成功列表
ClassMethod GetAdmTaskSucceedListPageByParam(AParam As DHCEPRFS.Entity.EAdmTaskSucceed, AType As %String = "", APageCount As %String = "", APageSize As %String = "") As DHCEPRFS.DataSet.EAdmTaskSucceedDS [ WebMethod ]
{
	s ARegNo =AParam.RegNo
	s AMedRecordNo = AParam.MedRecordNo
	s AStartDate = AParam.StartDate
	s AEndDate = AParam.EndDate
	s AEpisodeID = AParam.EpisodeID
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s APatientName = AParam.PatientName
	s AAdmLocID = AParam.AdmLocID
	s ADisLocID = AParam.DisLocID
	s AObservedNo = AParam.ObservedNo
	s AAdmType = AParam.AdmType
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskSucceedDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,APageCount,APageSize,AEpisodeID,APatientName,AAdmLocID,ADisLocID,AObservedNo,AAdmType)
	q dataset
}

ClassMethod GetAdmTaskSucceedListTotalCountByParam(AParam As DHCEPRFS.Entity.EAdmTaskSucceed, AType As %String = "") As %String [ WebMethod ]
{
	s ARegNo =AParam.RegNo
	s AMedRecordNo = AParam.MedRecordNo
	s AStartDate = AParam.StartDate
	s AEndDate = AParam.EndDate
	s AEpisodeID = AParam.EpisodeID
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s APatientName = AParam.PatientName
	s AAdmLocID = AParam.AdmLocID
	s ADisLocID = AParam.DisLocID
	s AObservedNo = AParam.ObservedNo
	s AAdmType = AParam.AdmType
	s ret = ##class(DHCEPRFS.BL.BLAdmTaskSucceed).GetAdmTaskSucceedTotalCount(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,AEpisodeID,APatientName,AAdmLocID,ADisLocID,AObservedNo,AAdmType)
	q ret
}

}
