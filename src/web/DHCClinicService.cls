/// web.DHCClinicService
Class web.DHCClinicService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCClinicService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

ClassMethod SaveClinicData(className As %String, inputFlag As %String, propertyPara As %String, valuePara As %String) As %String [ WebMethod ]
{
	set ret=##class(web.DHCICUImportData).SaveClinicData(className,inputFlag,propertyPara,valuePara)
	quit ret
}

}
