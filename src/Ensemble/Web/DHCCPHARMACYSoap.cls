Class Ensemble.Web.DHCCPHARMACYSoap Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.1.1.56:8972/csp/ditan/DHC.BS.DocToCardiogram2.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DHCC-PHARMACY";

Method DocToCardiogram2(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("DocToCardiogram2").Invoke(##this,"http://tempuri.org/DHC.BS.DocToCardiogram2.DocToCardiogram2",.pInput)
}

}
