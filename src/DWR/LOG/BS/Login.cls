/// DWR.LOG.BS.Login
Class DWR.LOG.BS.Login Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "Login";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// 
Method Logon(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.LOG.BL.Login).Logon(pRequest)
	quit pResponse
}

}
