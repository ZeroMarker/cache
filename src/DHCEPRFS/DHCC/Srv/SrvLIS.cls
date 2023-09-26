Class DHCEPRFS.DHCC.Srv.SrvLIS Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCLIS";

ClassMethod GetConnectString() As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetConnectString()
	q ret
}

ClassMethod GetLISPDFPath(AEpisodeID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetLISPDFPathNew(AEpisodeID)
	q ret
}

/// Desc: 发血申请单
ClassMethod GetBLDApplyPDFPath(AEpisodeID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetBLDPath(AEpisodeID,"01007")
	q ret
}

/// Desc: 发血单
ClassMethod GetBLDPDFPath(AEpisodeID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetBLDPath(AEpisodeID,"01003")
	q ret
}

}
