Class DHCEPRFS.ThirdParty.Srv.FCYYBUltraSonic Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "ThirdPartyFCYYBUltraSonic";

ClassMethod GetFTPUser() As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.ThirdParty.BL.FCYYBUltraSonic).GetFTPUserNameAndPassword()
	q ret
}

ClassMethod GetFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.ThirdParty.BL.FCYYBUltraSonic).GetFTPPath(AEpisodeID)
	q ret
}

}
