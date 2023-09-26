/// DWR.PAT.BS.Patient
Class DWR.PAT.BS.Patient Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "Patient";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// 
Method PatientQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.PAT.BL.Patient).PatientQry(pRequest)
	quit pResponse
}

}
