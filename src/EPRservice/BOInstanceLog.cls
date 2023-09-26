Class EPRservice.BOInstanceLog Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/boservice";

/// Name of the WebService. 
Parameter SERVICENAME = "InstanceLogInfo";

//

ClassMethod StatusConventer(argInitStatus As %String, argAction As %String) As %String
{
}

}
