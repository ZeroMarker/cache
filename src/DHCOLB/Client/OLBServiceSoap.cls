Class DHCOLB.Client.OLBServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.23.6.205/dthealth/web/DHCOLB.OLBService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "OLBService";

Method GetAvailableLicense() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetAvailableLicense").Invoke(##this,"http://www.dhcc.com.cn/DHCOLB.OLBService.GetAvailableLicense")
}

Method GetConnection(ClientIP As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetConnection").Invoke(##this,"http://www.dhcc.com.cn/DHCOLB.OLBService.GetConnection",.ClientIP)
}

Method GetMinAvailableLicense() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetMinAvailableLicense").Invoke(##this,"http://www.dhcc.com.cn/DHCOLB.OLBService.GetMinAvailableLicense")
}

}
