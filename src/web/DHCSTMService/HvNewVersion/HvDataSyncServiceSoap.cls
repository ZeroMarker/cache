Class web.DHCSTMService.HvNewVersion.HvDataSyncServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
/// ps: 此处需要修改!!! 注意虚拟目录
Parameter LOCATION = "http://IP地址:端口/dthealth/web/web.DHCSTMService.HvOldVersion.HvDataSyncService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "HvDataSyncService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method CreateInfoHvForOld(MainInfo As %String, ListData As %String, Type As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	d ..WSSecurityLogin("dhwebservice","dhwebservice")
 Quit ..WebMethod("CreateInfoHvForOld").Invoke($this,"http://tempuri.org/web.DHCSTMService.HvOldVersion.HvDataSyncService.CreateInfoHvForOld",.MainInfo,.ListData,.Type)
}

Method Test() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	d ..WSSecurityLogin("dhwebservice","dhwebservice")
 Quit ..WebMethod("Test").Invoke($this,"http://tempuri.org/web.DHCSTMService.HvOldVersion.HvDataSyncService.Test")
}

}
