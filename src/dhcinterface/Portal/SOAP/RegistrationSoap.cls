Class dhcinterface.Portal.SOAP.RegistrationSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// This is the URL used to access the web service.
/// Parameter LOCATION = "http://10.56.36.109:8972/csp/clover/DTR.ENS.Register.WEB.Registration.cls";
/// Parameter LOCATION = "http://172.168.1.105:8972/csp/clover/DTR.ENS.Register.WEB.Registration.cls";
Parameter LOCATION = "http://172.23.6.12:57772/csp/clover/DTR.ENS.Register.WEB.Registration.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "Registration";

Method AutoRegister(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("AutoRegister").Invoke(##this,"http://tempuri.org/DTR.ENS.Register.WEB.Registration.AutoRegister",.pInput)
}

Method InitPassword(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("InitPassword").Invoke(##this,"http://tempuri.org/DTR.ENS.Register.WEB.Registration.InitPassword",.pInput)
}

Method Register(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Register").Invoke(##this,"http://tempuri.org/DTR.ENS.Register.WEB.Registration.Register",.pInput)
}

}
