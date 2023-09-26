Class DHCEPRFS.Srv.SrvMRMedRecord Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRMedRecord";

ClassMethod GetMedRecordInfo(Apara As DHCEPRFS.Entity.EPatientInfoQueryPara) As DHCEPRFS.DataSet.EMedRecordDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.EMedRecordDS).%New()
	d result.SetArgs(Apara)
	q result
}

/// debug:d ##class(DHCEPRFS.Srv.SrvMRMedRecord).GetMRMedRecordNo("500308","DHC")
ClassMethod GetMRMedRecordNo(AMedRecordNo As %String, ASysCode As %String = "DHC") As DHCEPRFS.DataSet.EMRMedRecordDS [ WebMethod ]
{
	s AMedRecordNo = $zcvt(AMedRecordNo,"U")
	s result = ##Class(DHCEPRFS.DataSet.EMRMedRecordDS).%New()
	d result.SetArgs(AMedRecordNo, ASysCode)
	q result
}

ClassMethod AssignMRMedRecord() As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRMedRecord).AssignMRMedRecord()	
	q ret
}

ClassMethod AssignNext() As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRMedRecord).AssignNext()	
	q ret
}

ClassMethod AssignExistMRMedRecord(AMedRecordNo As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRMedRecord).AssignExistMRMedRecord(AMedRecordNo)	
	q ret
}

}
