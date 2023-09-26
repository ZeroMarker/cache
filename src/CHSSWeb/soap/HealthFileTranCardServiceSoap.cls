Class CHSSWeb.soap.HealthFileTranCardServiceSoap Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.74.12.201/trakcarelive/trak/web/dhcservice.HealthFileTranCardService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://hospital.service.com/interface";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "HealthFileTranCardService";

Method HealthFileCheckCard(XMLPara As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HealthFileCheckCard").Invoke(##this,"http://hospital.service.com/interface/dhcservice.HealthFileTranCardService.HealthFileCheckCard",.XMLPara)
}

Method HealthFileTranCard(XMLPara As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HealthFileTranCard").Invoke(##this,"http://hospital.service.com/interface/dhcservice.HealthFileTranCardService.HealthFileTranCard",.XMLPara)
}

}
