Class DHCEPRFS.ThirdParty.SI.UltrasonicInterface Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "UltrasonicInterface";

ClassMethod RegLateUltrasonicReport(AOrdID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReport(AOrdID,"CREATEULTRASONIC")
	q ret
}

}
