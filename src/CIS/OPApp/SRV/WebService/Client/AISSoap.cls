Class CIS.OPApp.SRV.WebService.Client.AISSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://111.231.5.101/dthealth/web/CIS.AN.SRV.WebService.Server.ForOPApp.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "AISAPIForOPApp";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the logon user name provided by the service.
Parameter LogonUser = "_system";

/// This is the logon password provided by the service.
Parameter Password = "SYS";

/// 测试时调用
Method Test(request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("Test").Invoke($this,"http://tempuri.org/CIS.AN.SRV.WebService.Server.ForOPApp.Test",.request)
}

}
