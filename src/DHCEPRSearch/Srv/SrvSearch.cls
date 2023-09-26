Class DHCEPRSearch.Srv.SrvSearch Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprsearchservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvSearch";

ClassMethod CheckMREpisodeTask() As %String [ WebMethod ]
{
	s mrEpisodeID = ##class(DHCEPRSearch.BL.BLSearch).CheckMREpisodeTask()
	q mrEpisodeID
}

ClassMethod GetMREpisodeTask() As %String [ WebMethod ]
{
	s mrEpisodeID = ##class(DHCEPRSearch.BL.BLSearch).GetMREpisodeTask()
	q mrEpisodeID
}

}
