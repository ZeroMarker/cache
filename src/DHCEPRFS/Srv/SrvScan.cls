Class DHCEPRFS.Srv.SrvScan Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvScan";

ClassMethod SetScanStatus(AMREpisodeID As %String, AStatus As %String, AUserID As %String) As %String [ WebMethod ]
{
	s:(AMREpisodeID =$c(0)) AMREpisodeID =""
	s:(AStatus =$c(0)) AStatus =""
	s:(AUserID =$c(0)) AUserID =""
	s ret =##class(DHCEPRFS.BL.BLScan).SetScanStatus(AMREpisodeID,AStatus,AUserID)
	q ret
}

ClassMethod ApplyScan(AMREpisodeID As %String, AUserID As %String, ADeptID As %String, ARequestComment As %String = "") As %String [ WebMethod ]
{
	s:(AMREpisodeID =$c(0)) AMREpisodeID =""
	s:(ADeptID =$c(0)) ADeptID =""
	s:(AUserID =$c(0)) AUserID =""
	s:(ARequestComment =$c(0)) ARequestComment =""
	s ret = ##class(DHCEPRFS.BL.BLScan).ApplyScan(AMREpisodeID,AUserID,ADeptID,ARequestComment)
	q ret
}

ClassMethod GetScanSatusByMREpisode(AMREpisodeID As %String) As %String [ WebMethod ]
{
	s:(AMREpisodeID =$c(0)) AMREpisodeID =""
	s ret = ##class(DHCEPRFS.BL.BLPrivilege).GetScanSatusByMREpisode(AMREpisodeID)
	q ret
}

}
