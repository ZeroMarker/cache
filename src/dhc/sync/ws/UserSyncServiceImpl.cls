Class dhc.sync.ws.UserSyncServiceImpl Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://111.205.100.101//Common_C91_UserSync/services/UserSyncServiceImpl";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://service.usersync.portal.dhcc.com";

/// This is the name of the Service
Parameter SERVICENAME = "UserSyncServiceImplService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method saveData(source As %String, data As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveData").Invoke($this,"",.source,.data)
}

}
