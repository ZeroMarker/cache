Class DHCEPRFS.ThirdParty.SI.EndoscopeInterface Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "EndoscopeInterface";

ClassMethod RegLateEndoscopeReport(AOrdID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReport(AOrdID,"CREATEENDOSCOPE")
	q ret
}

}
