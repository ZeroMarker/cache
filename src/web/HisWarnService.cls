/// web.HisWarnService
Class web.HisWarnService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "MyService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// w ##Class(web.HisWarnService).RequestSubmit("HW10101","B01-WK3-YS26B")
Method RequestSubmit(RequestCode As %String = "", RequestXML As %String = "") As %String [ WebMethod ]
{
	Set $ZTrap = "MessageCatch"
	q:RequestCode="" ""
	s RetStr=""
	i RequestCode="HW10101" d
	.s Index=$I(^DHCHisWarnTest(+$H,"Warn"))
	.s ^DHCHisWarnTest(+$H,"Warn",Index)=RequestXML_"^"_$P($H,",",2)
	.s RetStr=##Class(web.DHCHisWarn).GetClientWarnInfo(RequestXML)
	i RequestCode="HW10100" d
	.s Index=$I(^DHCHisWarnTest(+$H,"Warn"))
	.s ^DHCHisWarnTest(+$H,"Warn",Index)=RequestXML_"^"_$P($H,",",2)
	.s RetStr=##Class(web.DHCHisWarn).SaveClientInfo(RequestXML)
	//s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc><ResultList>"_RetStr_"</ResultList></Response>"
	Quit RetStr
MessageCatch
	Set $ZTrap = ""
	s ResultCode=-100
	s ResultDesc=$$$ERROR($$$GeneralError,"Error in OnProcessInput():  "_$ZError)
	s ResultDesc=$TR(ResultDesc,"<"," ")
	s ResultDesc=$TR(ResultDesc,">"," ")
	s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc></Response>"
  	Quit RetXML
}

}
