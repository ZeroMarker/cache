Class CIS.AN.SRV.WebService.Client.OPAppSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Version of the web client.
Parameter Version = "0.1.0";

/// This is the URL used to access the web service.
Parameter LOCATION = "http://111.231.5.101/dthealth/web//CIS.OPApp.SRV.WebService.Server.ForAIS.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "OPAppAPIForAIS";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the logon user name provided by the service.
Parameter LogonUser = "_system";

/// This is the logon password provided by the service.
Parameter Password = "SYS";

/// [查询]手术预约数据
Method GetOperAppointmentList(request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
	write "soap invoke web method",!
 	set ret=..WebMethod("GetOperAppointmentList").Invoke($this,"http://tempuri.org/CIS.OPApp.SRV.WebService.Server.ForAIS.GetOperAppointmentList",.request)
 	write "soap web method returns:",ret.Read(),!
 	Quit ret
}

Method Test(request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
	write "soap invoke web method",!
 	set ret=..WebMethod("Test").Invoke($this,"http://tempuri.org/CIS.OPApp.SRV.WebService.Server.ForAIS.Test",.request)
 	write "soap web method returns:",ret.Read(),!
 	Quit ret
}

}
