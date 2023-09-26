Class EMRservice.BOVersionLib Extends %SOAP.WebService
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/emrservice";

/// Name of the WebService. 
Parameter SERVICENAME = "VresionLib";

ClassMethod GetVersion() As %String [ WebMethod ]
{
	s quality =  ##Class(EPRmeta.Quality.VresionLib).GetVersion()
	s emr = ##Class(EMRmeta.VersionLib).GetVersion()
	q emr_" | "_quality
}

}
