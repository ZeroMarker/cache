Class DHCEPRFS.Srv.SrvIDScan Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvIDScan";

ClassMethod Create(AMREpisodeID As %String, AMedRecordNo As %String, AUserID As %String, AFileMasterID As %String, AFileMasterPath As %String, AFilePhysicalPath As %String, ATotCount As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLIDScan).Create(AMREpisodeID, AMedRecordNo, AUserID, AFileMasterID, AFileMasterPath, AFilePhysicalPath, ATotCount)	
	q ret
}

ClassMethod GetScanIDList(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String) As DHCEPRFS.DataSet.EIDScanDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EIDScanDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate, AUserName, AMedRecordID)
	q dataset
}

}
