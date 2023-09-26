Class dhcserviceclient.BSTServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

//Parameter LOCATION = "http://172.26.199.14:57772/csp/dhcens/Huaxi.BST.BS.BSTService.cls";

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.16.1.133:57772/csp/dhcens/Huaxi.BST.BS.BSTService.cls";

Parameter NAMESPACE = "http://hospital.service.com/interface";

/// This is the name of the Service
Parameter SERVICENAME = "BSTService";

Method SynAvailableRegCount(streams As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SynAvailableRegCount").Invoke(##this,"http://hospital.service.com/interface/Huaxi.BST.BS.BSTService.SynAvailableRegCount",.streams)
}

Method notifyChangeWork(xmlstr As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("notifyChangeWork").Invoke(##this,"http://hospital.service.com/interface/Huaxi.BST.BS.BSTService.notifyChangeWork",.xmlstr)
}

Method notifyStopWork(xmlstr As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("notifyStopWork").Invoke(##this,"http://hospital.service.com/interface/Huaxi.BST.BS.BSTService.notifyStopWork",.xmlstr)
}

Method updateWorkInfo(streams As %GlobalCharacterStream) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	b ;3
 Quit ..WebMethod("updateWorkInfo").Invoke(##this,"http://hospital.service.com/interface/Huaxi.BST.BS.BSTService.updateWorkInfo",.streams)
	b ;4
}

}
