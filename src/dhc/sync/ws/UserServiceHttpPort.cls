Class dhc.sync.ws.UserServiceHttpPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.3:8080/services/UserService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://service.usersync.webservice.dhcc.com";

/// This is the name of the Service
Parameter SERVICENAME = "UserService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method saveData(in0 As %String, in1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveData").Invoke($this,"",.in0,.in1)
}

}
