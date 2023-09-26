/// 外部系统卡支付接口WebService
Class web.DHCOPBillCardPayWS Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://127.0.0.1/trakcarelive/trak/web";

/// Name of the WebService.
Parameter SERVICENAME = "DHCOPBillCardPay";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://127.0.0.1/trakcarelive/trak/web/DHCOPBillCardPay";

/// TODO: add arguments and implementation.
/// GetPatAdmInfo
Method OPBillCharge(CardNo As %String = "", SecurityNo As %String = "", RegNo As %String = "", OeordStr As %String = "", UserCode As %String = "", LoginLocCode As %String = "", SecurityGroupID As %String = "", ExpStr As %String = "") As %String [ WebMethod ]
{
	set myrtn=##class(web.DHCOPBillCardPayService).OPBillCharge(CardNo, SecurityNo, RegNo, OeordStr, UserCode , LoginLocCode , SecurityGroupID , ExpStr)
	quit myrtn
}

}
