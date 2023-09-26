Class DHCEPRFS.Srv.SrvMREpisodeFP Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMREpisodeFP";

ClassMethod AddFPDiagnosis(AMREpisodeID As %String, ADiagnosisType As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisodeFP).AddFPDiagnosis(AMREpisodeID, ADiagnosisType, ADiagnosisDesc, ADiagnosisCode, ADiagnosisState)
	q ret
}

ClassMethod GetFPDiagnosisList(AMREpisodeID As %String) As DHCEPRFS.DataSet.EMREpisodeFPDiagnosisDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.EMREpisodeFPDiagnosisDS).%New()
	d result.SetArgs(AMREpisodeID)
	q result
}

ClassMethod AddFPOperation(AMREpisodeID As %String, AOperationDesc As %String, AOperationCode As %String, AOperationDate As %String, AOperationLevel As %String, AOperationAnaMethod As %String, AOperationCutLevel As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisodeFP).AddFPOperation(AMREpisodeID, AOperationDesc, AOperationCode, AOperationDate, AOperationLevel,AOperationAnaMethod, AOperationCutLevel)
	q ret
}

ClassMethod GetFPOperationList(AMREpisodeID As %String) As DHCEPRFS.DataSet.EMREpisodeFPOperationDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.EMREpisodeFPOperationDS).%New()
	d result.SetArgs(AMREpisodeID)
	q result
}

ClassMethod DeleteDiagOrOper(AMREpisodeID As %String, AType As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisodeFP).DeleteDiagOrOper(AMREpisodeID, AType)
	q ret
}

}
