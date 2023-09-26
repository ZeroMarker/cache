Class web.DHCPE.NetReport.WebServiceHttpPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method ICheckMainInfo(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("ICheckMainInfo")).Invoke($this,"",.in0)
}

Method IDiagnosisInfo(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("IDiagnosisInfo")).Invoke($this,"",.in0)
}

Method ISSDiagnosis(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("ISSDiagnosis")).Invoke($this,"",.in0)
}

Method ISSOrderInfo(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("ISSOrderInfo")).Invoke($this,"",.in0)
}

Method ISSOrderResult(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("ISSOrderResult")).Invoke($this,"",.in0)
}

Method ISSResult(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("ISSResult")).Invoke($this,"",.in0)
}

Method IStationSummarize(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("IStationSummarize")).Invoke($this,"",.in0)
}

Method IuserInfo(in0 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("IuserInfo")).Invoke($this,"",.in0)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.56.32.38:8080/DHC_PE/services/WebService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://webservice.dhcpe.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "WebService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
