/// EPRservice.BOTerminologyService
Class EPRservice.BOTerminologyService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TerminologyService";

/// TODO: add arguments and implementation.
/// SelectALLTerm
ClassMethod SelectALLTerm() As EPRservice.dataset.ETerminologyDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ETerminologyDataset).%New()
 // Do result.SetArgs(ATemplateId)
 Quit result
}

}
