Class DHCEPRFS.Srv.SrvEpisode Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvEpisode";

ClassMethod GetEpisodeList(AParam As %String) As DHCEPRFS.DataSet.EEpisodeListDS [ WebMethod ]
{
	s result = ##class(DHCEPRFS.DataSet.EEpisodeListDS).%New()
	d result.SetArgs(AParam)
	q result
}

ClassMethod GetDetailInfo(APrintDocID As %String, AEpisodeID As %String, AUserID As %String, Attachment As %String, AttachType As %String) As %String [ WebMethod ]
{
	s APatientID = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLEPRInfo).GetDetailInfoToPrint(APrintDocID, AEpisodeID, AUserID, Attachment,AttachType)
	q ret
}

ClassMethod GetEpisode(AParam As %String) As DHCEPRFS.DataSet.EEpisodeGetDS [ WebMethod ]
{
	s result = ##class(DHCEPRFS.DataSet.EEpisodeGetDS).%New()
	d result.SetArgs(AParam)
	q result
}

ClassMethod GetPACSOrderID(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetPACSOrdIdByAdm(AEpisodeID)	
	q ret
}

}
