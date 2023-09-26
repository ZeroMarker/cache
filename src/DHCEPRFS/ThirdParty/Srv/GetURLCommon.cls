Class DHCEPRFS.ThirdParty.Srv.GetURLCommon Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "ThirdPartyURLCommon";

ClassMethod GetURLString(AEpisodeID As %String, ATypeCode As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.ThirdParty.BL.BLGetURLCommon).GetURL(AEpisodeID,ATypeCode)
	q ret
}

}
