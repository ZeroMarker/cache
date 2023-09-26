Class DHCEPRFS.ThirdParty.Srv.OutputCommon Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "OutputCommon";

ClassMethod GetPDFPath(AInputStr As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.ThirdParty.BL.BLOutputCommon).GetPDFPath(AInputStr)
}

}
