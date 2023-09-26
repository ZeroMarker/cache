Class DHCEPRFS.Srv.SrvWaterMark Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvWaterMark";

/// debug: w ##class(DHCEPRFS.Srv.SrvWaterMark).GetWaterMarkText("","283")
ClassMethod GetWaterMarkText(AMREpisodeID As %String, AMRUserID As %String) As %String [ WebMethod ]
{
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	s:(AMRUserID = $c(0)) AMRUserID = ""
	s ret = ##class(DHCEPRFS.BL.BLWaterMarkReplace).GetText(AMREpisodeID, AMRUserID)
	q ret
}

}
