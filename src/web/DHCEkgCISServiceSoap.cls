Class web.DHCEkgCISServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

Property LOCATIONADRESS As %String(TRUNCATE = 1);

Method %OnNew(initvalue As %CacheString) As %Status [ Private, ProcedureBlock = 1 ]
{
    s ..LOCATIONADRESS="192.168.222.1"
    QUIT $$$OK
}

Parameter LOCATION = "http://192.168.222.1/WebEKGStudioNew/Service/DHCEkgCISService.asmx";

/// This is the URL used to access the web service.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn/";

/// This is the name of the Service
Parameter SERVICENAME = "DHCEkgCISService";

Method GetEKGReport(hostname As %String, rowid As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetEKGReport").Invoke(##this,"http://www.dhcc.com.cn/GetEKGReport",.hostname,.rowid)
}

Method GetEKGReportImgLink(hostname As %String, rowid As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 //w ##class(web.DHCEkgCISServiceSoap).GetEKGReportImgLink("","13||9")
 //w ##class(web.DHCEkgCISServiceSoap).HelloWorld()
 Quit ..WebMethod("GetEKGReportImgLink").Invoke(##this,"http://www.dhcc.com.cn/GetEKGReportImgLink",.hostname,.rowid)
}

Method GetEKGReportPdfLink(hostname As %String, rowid As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetEKGReportPdfLink").Invoke(##this,"http://www.dhcc.com.cn/GetEKGReportPdfLink",.hostname,.rowid)
}

Method HelloNumber() As %Integer [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HelloNumber").Invoke(##this,"http://www.dhcc.com.cn/HelloNumber")
}

Method HelloWorld() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HelloWorld").Invoke(##this,"http://www.dhcc.com.cn/HelloWorld")
}

}
