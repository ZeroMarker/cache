Class Ensemble.DHCCPHARMACYSoap Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.1.1.56:8972/csp/ditan/DHC.BS.PHABAIYAOJI.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DHCC-PHARMACY";

Method BAIYAOJI(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("BAIYAOJI").Invoke(##this,"http://tempuri.org/DHC.BS.PHABAIYAOJI.BAIYAOJI",.pInput)
}

}
