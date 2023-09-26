Class DHCEPRFS.DHCC.Srv.SrvEKG Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCEKG";

ClassMethod GetFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLEKGInfo).DHCEKGPdfPathOut(AEpisodeID)
	q ret
}

}
