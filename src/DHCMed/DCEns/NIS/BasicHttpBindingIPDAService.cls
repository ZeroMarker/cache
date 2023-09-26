Class DHCMed.DCEns.NIS.BasicHttpBindingIPDAService Extends %SOAP.WebClient
{

Method GetData(regNo As %String, admID As %String, itemName As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetData").Invoke(##this,"http://tempuri.org/IPDAService/GetData",.regNo,.admID,.itemName)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.2.18/PDAService/PDAService.svc";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PDAService";

}
