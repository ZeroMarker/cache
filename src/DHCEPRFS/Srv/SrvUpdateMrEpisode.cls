Class DHCEPRFS.Srv.SrvUpdateMrEpisode Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvUpdateMrEpisode";

ClassMethod UpdateMrEpisode() As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrEpisode()
}

}
