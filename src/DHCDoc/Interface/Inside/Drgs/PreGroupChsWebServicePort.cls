Class DHCDoc.Interface.Inside.Drgs.PreGroupChsWebServicePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// DRGs地址
Parameter LOCATION = "https://111.205.6.229:1443/api/ws/service/pre/group";

/// DIP地址
/// Parameter LOCATION = "http://222.132.155.203:8089/dipmi/ws/web/pre/group";
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://group.service.mediway.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "PreGroupWebServiceImplService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method drgInfoForDoctorXml(xmlData As %String(ELEMENTQUALIFIED=1)) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("drgInfoForDoctorXml").Invoke($this,"",.xmlData)
}

Method group(data As %String(ELEMENTQUALIFIED=1)) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("group").Invoke($this,"",.data)
}

Method recGroup(data As %String(ELEMENTQUALIFIED=1)) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("recGroup").Invoke($this,"",.data)
}

}
