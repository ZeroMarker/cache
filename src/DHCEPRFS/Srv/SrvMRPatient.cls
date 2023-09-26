Class DHCEPRFS.Srv.SrvMRPatient Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRPatient";

ClassMethod GetMrPatientInfoByMrEpisodeID(AMrEpisodeID As %String) As DHCEPRFS.Entity.EMRPatient [ WebMethod ]
{
	s entity = ##class(DHCEPRFS.BL.BLMRPatient).GetMrPatientInfoByMrEpisodeID(AMrEpisodeID)
	q entity
}

ClassMethod GetPatientInfoByMRMedRecordNo(AMRMedRecordNo As %String) As DHCEPRFS.Entity.EMRPatient [ WebMethod ]
{
	s entity = ##class(DHCEPRFS.BL.BLMRPatient).GetPatientInfoByMRMedRecordNo(AMRMedRecordNo)
	q entity
}

ClassMethod SaveMRPatientInfo(AEntity As DHCEPRFS.Entity.EMRPatient) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRPatient).SaveMRPatientInfo(AEntity)
	q ret
}

}
