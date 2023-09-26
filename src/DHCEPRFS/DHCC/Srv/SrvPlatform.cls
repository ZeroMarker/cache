Class DHCEPRFS.DHCC.Srv.SrvPlatform Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCPlatform";

ClassMethod GetPlatformPDFPath(AEpisodeID As %String, ATypeCode As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPlatformInfo).GetPlatformPDFPath(AEpisodeID,ATypeCode)
	q ret
}

}
