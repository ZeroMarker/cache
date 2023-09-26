Class web.DHCEkg.Upgrade.UpgradeServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

// Parameter LOCATION = "http://128.28.3.110/trakcare/web/web.DHCEkg.UpgradeService.cls";

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.0.207/trakcare/web/web.DHCEkg.UpgradeService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "UpgradeService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GetConOrdXML(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String, examItemID As %String, execFlag As %String) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	d ..WSSecurityLogin("dhwebservice","dhwebservice")
 Quit ..WebMethod("GetConOrdXML").Invoke($this,"http://tempuri.org/web.DHCEkg.UpgradeService.GetConOrdXML",.locId,.patID,.patName,.stdDate,.endDate,.examItemID,.execFlag)
}

Method GetEKGInfoTxt(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetEKGInfoTxt").Invoke($this,"http://tempuri.org/web.DHCEkg.UpgradeService.GetEKGInfoTxt",.LocId,.InRegNo,.StartDate,.Enddate)
}

Method SentExamInfo(inputStream As %GlobalCharacterStream) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SentExamInfo").Invoke($this,"http://tempuri.org/web.DHCEkg.UpgradeService.SentExamInfo",.inputStream)
}

Method UpdataOrdInfo(OrditmRowids As %String, Status As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("UpdataOrdInfo").Invoke($this,"http://tempuri.org/web.DHCEkg.UpgradeService.UpdataOrdInfo",.OrditmRowids,.Status)
}

}
