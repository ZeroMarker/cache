Class DHCEPRFS.Prison.DHCC.Srv.SrvHC Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvHC";

ClassMethod GetHCPDFPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s pdfPath = ""
	s pdfPath = ##class(DHCEPRFS.Prison.BL.HISInfo.BLHCInfo).GetHCPDFPath(AEpisodeID)
	q pdfPath
}

}
