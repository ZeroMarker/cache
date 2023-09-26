Class DHCEPRFS.ThirdParty.WebService.LianZ.XieHeLianZWebServicePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.160.28.194:49616/pdbg/WebService.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "WebService";

/// This service supports both SOAP 1.1 and SOAP 1.2.
Parameter SOAPVERSION;

Method HelloWorld() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HelloWorld").Invoke($this,"http://tempuri.org/HelloWorld")
}

Method WSREPORTNUM(ShenQingLX As %String, BingRenLX As %String, DaYinLX As %String, KaiShiSJ As %String, JieShuSJ As %String, bingRenId As %String) As %String(XMLNAME="WS_REPORT_NUMResult") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_REPORT_NUM").Invoke($this,"http://tempuri.org/WS_REPORT_NUM",.ShenQingLX,.BingRenLX,.DaYinLX,.KaiShiSJ,.JieShuSJ,.bingRenId)
}

}
