Class DHCEPRFS.DHCC.Srv.SrvEMR Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCEMR";

ClassMethod GetNetConnect() As %String [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("NET_CONNECT")
}

ClassMethod GetDecryptKey() As %String [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("DECRYPTKEY")
}

ClassMethod GetLoadRecordParam(AEpisodeID As %String, ACatalogID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetLoadRecordParam(AEpisodeID,ACatalogID)
}

}
