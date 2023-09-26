Class web.DHCService.CI.Client.PACSServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.22.4.11/csp/huaxi/Huaxi.PACS.BS.PACSService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://hospital.service.com/pacs";

/// This is the name of the Service
Parameter SERVICENAME = "PACSService";

/// This is the namespace used for types by the Service
/// Parameter TYPENAMESPACE = "http://www.intersystems.com/SOAPheaders";
Method TrakToSystem(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("TrakToSystem").Invoke(##this,"http://hospital.service.com/pacs/Huaxi.PACS.BS.PACSService.TrakToSystem",.pInput)
}

}
