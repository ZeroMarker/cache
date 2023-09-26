Class DHCEPRFS.Srv.SrvImportScan Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvImportScan";

ClassMethod GetImportScanParam(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLImportScan).GetImportScanParam(AEpisodeID)
	q ret
}

ClassMethod Create(AMedRecordNo As %String, APatientName As %String, AAdmDate As %String, ADisDate As %String, AParamXML As %String, AUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLImportScan).Create(AMedRecordNo,APatientName,AAdmDate,ADisDate,AParamXML,AUserID)
	q ret
}

ClassMethod GetImportList(AStartDate As %String, AEndDate As %String) As DHCEPRFS.DataSet.EImportScanListDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EImportScanListDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate)
	q dataset
}

ClassMethod GetImportHistory(AEpisodeID As %String) As DHCEPRFS.DataSet.EImportScanHistoryDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EImportScanHistoryDS).%New()
	d dataset.SetArgs(AEpisodeID)
	q dataset
}

ClassMethod GetMRItemID(AThirdPartyName As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLImportScan).GetMRItemID(AThirdPartyName)
	q ret
}

}
