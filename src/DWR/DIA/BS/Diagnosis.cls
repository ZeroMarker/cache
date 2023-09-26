/// DWR.DIA.BS.Diagnosis
Class DWR.DIA.BS.Diagnosis Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "Diagnosis";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// 新增诊断
Method DiagnosisIns(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.DIA.BL.Diagnosis).DiagnosisIns(pRequest)
	quit pResponse
}

/// 查询诊断记录
Method DiagnosisRecQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.DIA.BL.Diagnosis).DiagnosisRecQry(pRequest)
	quit pResponse
}

/// 查询诊断类型
Method DiagnosisTypeQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.DIA.BL.Diagnosis).DiagnosisTypeQry(pRequest)
	quit pResponse
}

/// 查询ICD
Method ICDQry(pRequest As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set pResponse=##Class(DWR.DIA.BL.Diagnosis).ICDQry(pRequest)
	quit pResponse
}

}
