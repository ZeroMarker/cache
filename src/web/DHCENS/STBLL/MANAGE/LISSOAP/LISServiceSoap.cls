Class web.DHCENS.STBLL.MANAGE.LISSOAP.LISServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "https://localhost:1443/imedical/liswebservice/SII.LIS.Services.CommonService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "LISService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Property WebServiceUserName As %String [ InitialExpression = "dhwebservice" ];

/// webservice密码
Property WebServicePassword As %String [ InitialExpression = "dhwebservice" ];

Method LISService(MethodID As %String, Input As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("LISService").Invoke($this,"http://tempuri.org/SII.LIS.Services.CommonService.LISService",.MethodID,.Input)
}

}
