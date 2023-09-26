Class web.DHCEQ.Soap.ForPacs Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost/EQWebService/Service.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// This is the name of the Service
Parameter SERVICENAME = "Service";

Method GetBussListData(BeginTime As %String, EndTime As %String) As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetBussListData").Invoke(##this,"http://tempuri.org/GetBussListData",.BeginTime,.EndTime)
}

Method GetItemInfo(id As %String) As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetItemInfo").Invoke(##this,"http://tempuri.org/GetItemInfo",.id)
}

Method HelloWorld() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HelloWorld").Invoke(##this,"http://tempuri.org/HelloWorld")
}

}
