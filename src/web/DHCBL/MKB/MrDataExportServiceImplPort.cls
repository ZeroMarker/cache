Class web.DHCBL.MKB.MrDataExportServiceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
/// 泰安服务器
/// Parameter LOCATION = "http://58.56.200.232:8082/drg/ws/mrDataExport"; 
/// 腾讯云服务器
Parameter LOCATION = "http://drg.mediwaydrg.com:9090/drg/ws/mrDataExport";

/// This is the namespace used by the Service
Parameter NAMESPACE = "MrDataExportService";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "MrDataExportService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method doctorDrgTable(data As %String(REFELEMENTQUALIFIED=0,REFNAMESPACE="doctorDrgTable",XMLREF=1)) As %ListOfObjects(ELEMENTTYPE="web.DHCBL.MKB.tns.entry",XMLITEMNAME="entry",XMLNAME="_return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("doctorDrgTable").Invoke($this,"",.data)
}

Method drgGroupExport(data As %String(ELEMENTQUALIFIED=1), arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("drgGroupExport").Invoke($this,"",.data,.arg1)
}

Method drgInfoForDoctor(data As %String(REFELEMENTQUALIFIED=0,REFNAMESPACE="drgInfoForDoctor",XMLREF=1)) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("drgInfoForDoctor").Invoke($this,"",.data)
}

}
