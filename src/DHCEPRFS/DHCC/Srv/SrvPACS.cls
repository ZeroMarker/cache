Class DHCEPRFS.DHCC.Srv.SrvPACS Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCPACS";

ClassMethod GetFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetFTPPath(AEpisodeID)
	q ret
}

/// 检查报告-放射PACS
ClassMethod GetPACSFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetPACSFTPPath(AEpisodeID)
	q ret
}

/// 检查报告-超声US
ClassMethod GetUSFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetUSFTPPath(AEpisodeID)
	q ret
}

/// 检查报告-内镜ES
ClassMethod GetESFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetESFTPPath(AEpisodeID)
	q ret
}

}
