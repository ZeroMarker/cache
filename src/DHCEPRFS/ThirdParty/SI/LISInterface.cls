Class DHCEPRFS.ThirdParty.SI.LISInterface Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "LISInterface";

ClassMethod RegLateLISReport(AOrdID As %String) As %String [ WebMethod ]
{
    s ret = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReport(AOrdID,"CREATE3RDLIS")
    q ret
}

}
