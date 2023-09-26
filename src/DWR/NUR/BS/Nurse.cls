/// DWR.NUR.BS.Nurse
Class DWR.NUR.BS.Nurse Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "Nurse";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// 
/// 三测单数据查询
Method ThreeSTDataQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.NUR.BL.Nurse).ThreeSTDataQry(pRequest)
	quit pResponse
}

}
