Class DHCEPRFS.Srv.SrvSearch Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvSearch";

ClassMethod CheckMREpisodeTask() As %String [ WebMethod ]
{
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLSearch).CheckMREpisodeTask()
	q mrEpisodeID
}

ClassMethod GetMREpisodeTask() As %String [ WebMethod ]
{
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLSearch).GetMREpisodeTask()
	q mrEpisodeID
}

}
