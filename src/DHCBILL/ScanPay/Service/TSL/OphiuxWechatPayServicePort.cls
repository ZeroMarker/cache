Class DHCBILL.ScanPay.Service.TSL.OphiuxWechatPayServicePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method closeOrder(data As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("closeOrder").Invoke($this,"",.data)
}

Method micropay(data As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("micropay").Invoke($this,"",.data)
}

Method queryOrder(data As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("queryOrder").Invoke($this,"",.data)
}

Method queryOrderResult(data As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("queryOrderResult").Invoke($this,"",.data)
}

Method refund(data As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("refund").Invoke($this,"",.data)
}

Method smPay(data As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("smPay").Invoke($this,"",.data)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://winxin.cyfyy.com.cn:2028/OphiuxWeChatPay/ws/service";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://wechatpay.ophiux.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "OphiuxWechatPayServiceService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
