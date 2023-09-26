Class DHCEPRFS.DHCC.Srv.SrvNurse.SrvNursePrint Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvNursePrint";

ClassMethod GetNurInfoByCode(ATypeCode As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).GetNurInfoByCode(ATypeCode)
	q ret
}

ClassMethod GetNewSet() As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).GetNewSet()
	q ret
}

ClassMethod GetPatInfo(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).GetPatInfo(AEpisodeID)
	q ret
}

ClassMethod GetId(AEmrCode As %String, AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).GetId(AEmrCode,AEpisodeID)
	q ret
}

ClassMethod GetPerModel(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).GetPerModel(AEpisodeID)
	q ret
}

}
