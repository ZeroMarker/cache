Class web.PhaServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.22.4.11/csp/huaxi/Huaxi.Pha.BS.PhaService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://hospital.service.com/pha";

/// This is the name of the Service
Parameter SERVICENAME = "PhaService";

//Parameter TYPENAMESPACE = "http://www.intersystems.com/SOAPheaders";

/// This is the namespace used for types by the Service
Method Phamarcy(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Phamarcy").Invoke(##this,"http://hospital.service.com/pha/Huaxi.Pha.BS.PhaService.Phamarcy",.pInput)
}

Method Stock(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Stock").Invoke(##this,"http://hospital.service.com/pha/Huaxi.Pha.BS.PhaService.Stock",.pInput)
}

Method StockCorrected() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("StockCorrected").Invoke(##this,"http://hospital.service.com/pha/Huaxi.Pha.BS.PhaService.StockCorrected")
}

Method TarAdjusted(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("TarAdjusted").Invoke(##this,"http://hospital.service.com/pha/Huaxi.Pha.BS.PhaService.TarAdjusted",.pInput)
}

}
