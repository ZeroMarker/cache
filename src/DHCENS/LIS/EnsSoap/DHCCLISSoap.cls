Class DHCENS.LIS.EnsSoap.DHCCLISSoap Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://127.0.0.1:8972/csp/dhcens/DHC.LIS.Common.BS.Web.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "DHCC-LIS";

Method dhcService(funName As %String, pInput As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("dhcService").Invoke(##this,"http://tempuri.org/DHC.LIS.Common.BS.Web.dhcService",.funName,.pInput)
}

}
