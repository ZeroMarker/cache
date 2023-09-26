Class dhc.sync.ws.SynchronizeUserLocSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.58/dthealth/web/dhcservice.SynchronizeUserLoc.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "SynchronizeUserLoc";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GetDeptList(Start As %String, Count As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetDeptList").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.GetDeptList",.Start,.Count)
}

Method GetKeyDir() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetKeyDir").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.GetKeyDir")
}

Method GetUserList(Start As %String, Count As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetUserList").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.GetUserList",.Start,.Count)
}

Method RSADecrypt(Ciphertext As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RSADecrypt").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.RSADecrypt",.Ciphertext)
}

Method RSAEncrypt(Plaintext As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RSAEncrypt").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.RSAEncrypt",.Plaintext)
}

Method Save(Source As %String, Data As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Save").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.Save",.Source,.Data)
}

Method SaveDep(Data As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveDep").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.SaveDep",.Data)
}

Method SaveUser(Data As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveUser").Invoke($this,"http://tempuri.org/dhcservice.SynchronizeUserLoc.SaveUser",.Data)
}

}
