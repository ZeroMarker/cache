Class web.DHCENS.STBLL.MANAGE.PACSSOAP.RISWebServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "https://localhost:1443/imedical/pacswebservice/WebService.RISWebServiceByXml.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "RISWebService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Property WebServiceUserName As %String [ InitialExpression = "dhwebservice" ];

/// webservice密码
Property WebServicePassword As %String [ InitialExpression = "dhwebservice" ];

Method ClinicDealUrgency(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("ClinicDealUrgency").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.ClinicDealUrgency",.Request)
}

Method DiscontinueAllAppInfo(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("DiscontinueAllAppInfo").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.DiscontinueAllAppInfo",.Request)
}

Method DiscontinueAppInfo(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("DiscontinueAppInfo").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.DiscontinueAppInfo",.Request)
}

Method GetHisId(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("GetHisId").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.GetHisId",.Request)
}

Method HXArriveOrCancel(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("HXArriveOrCancel").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.HXArriveOrCancel",.Request)
}

Method SaveAppToRIS(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("SaveAppToRIS").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.SaveAppToRIS",.Request)
}

Method SaveStudyInfoToRIS(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("SaveStudyInfoToRIS").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.SaveStudyInfoToRIS",.Request)
}

Method SetOrditemPaid(Request As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s pwd=##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd(..#LOCATION)
	s:pwd="" pwd=..WebServicePassword
	d ..WSSecurityLogin(..WebServiceUserName,pwd)
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity="0"
 Quit ..WebMethod("SetOrditemPaid").Invoke($this,"http://tempuri.org/WebService.RISWebServiceByXml.SetOrditemPaid",.Request)
}

}
