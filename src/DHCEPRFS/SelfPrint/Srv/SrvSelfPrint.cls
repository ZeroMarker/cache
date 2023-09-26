Class DHCEPRFS.SelfPrint.Srv.SrvSelfPrint Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvSelfPrint";

ClassMethod SaveClientLog(ALogType As %String, AClientIP As %String, AClientOS As %String, ACode As %String, AErrMsg As %String, AInfoMsg As %String, ALocalDateTime As %String, AMachineName As %String, ASource As %String, AStackTrace As %String, ATargetSite As %String, AVersion As %String, AWorkDirectory As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).SaveClientLog(ALogType,AClientIP,AClientOS,ACode,AErrMsg,AInfoMsg,ALocalDateTime,AMachineName,ASource,AStackTrace,ATargetSite,AVersion,AWorkDirectory)
	q ret
}

ClassMethod SaveTextCode(ACode As %String, APhoneNo As %String, AIDCardNo As %String, ARegNo As %String, AMRPatientID As %String, AClientIP As %String, ATerminalName As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).SaveTextCode(ACode,APhoneNo,AIDCardNo,ARegNo,AMRPatientID,AClientIP,ATerminalName)
	q ret
}

ClassMethod GetPrintPurpose(APrintPurposeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetPrintPurpose(APrintPurposeID)
	q ret
}

}
