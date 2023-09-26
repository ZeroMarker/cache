Class DHCEPRFS.ThirdParty.SI.PACSInterface Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "PACSInterface";

ClassMethod RegLatePACSReport(AOrdID As %String) As %String [ WebMethod ]
{
    s ret = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReport(AOrdID,"CREATE3RDPACS")
    q ret
}

}
