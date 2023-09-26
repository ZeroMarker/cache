Class DHCEPRFS.Srv.SrvMRLogView Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRLogView";

ClassMethod AddLog(AMREpisodeID As %String, AActUserID As %String, AClientIP) As %String [ WebMethod ]
{
	s logID = ##class(DHCEPRFS.BL.BLMRLogView).AddLog(AMREpisodeID,AActUserID,AClientIP)
	q logID
}

ClassMethod GetViewLogByDate(AStartDate As %String, AEndDate As %String, AActUserName As %String) As DHCEPRFS.DataSet.ELogViewByDateDS [ WebMethod ]
{
	s ds = ##Class(DHCEPRFS.DataSet.ELogViewByDateDS).%New()
	d ds.SetArgs(AStartDate,AEndDate,AActUserName)
	q ds
}

}
