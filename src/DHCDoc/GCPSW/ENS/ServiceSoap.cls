/// CTOR: QP
/// DATE: 2020-11-24
/// DESC: 药量筛选预警对外公共Service
Class DHCDoc.GCPSW.ENS.ServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.160.16.90:57772/dthealth/web/DHCDoc.GCPSW.ENS.CommonService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "CommonService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method RecEnd(LID As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RecEnd").Invoke($this,"http://tempuri.org/DHCDoc.GCPSW.ENS.CommonService.RecEnd",.LID)
}

Method RecStart() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RecStart").Invoke($this,"http://tempuri.org/DHCDoc.GCPSW.ENS.CommonService.RecStart")
}

Method SyncData(mList As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SyncData").Invoke($this,"http://tempuri.org/DHCDoc.GCPSW.ENS.CommonService.SyncData",.mList)
}

Method SyncIndex(mList As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SyncIndex").Invoke($this,"http://tempuri.org/DHCDoc.GCPSW.ENS.CommonService.SyncIndex",.mList)
}

}
