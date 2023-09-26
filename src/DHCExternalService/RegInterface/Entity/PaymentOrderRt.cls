Class DHCExternalService.RegInterface.Entity.PaymentOrderRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "PaymentOrderRt";

Parameter XMLIGNOREINVALIDTAG = 1;

Property UserID As %String(TRUNCATE = 1, XMLNAME = "UserID");

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property ClientType As %String(TRUNCATE = 1, XMLNAME = "ClientType");

Property HospitalId As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Property ExtUserID As %String(TRUNCATE = 1, XMLNAME = "ExtUserID");

Property TransactionId As %String(TRUNCATE = 1, XMLNAME = "TransactionId");

Property OrderCode As %String(TRUNCATE = 1, XMLNAME = "OrderCode");

Property PayBankCode As %String(TRUNCATE = 1, XMLNAME = "PayBankCode");

Property PayCardNo As %String(TRUNCATE = 1, XMLNAME = "PayCardNo");

Property PayModeCode As %String(TRUNCATE = 1, XMLNAME = "PayModeCode");

Property PayFee As %String(TRUNCATE = 1, XMLNAME = "PayFee");

Property PayInsuFee As %String(TRUNCATE = 1, XMLNAME = "PayInsuFee");

Property PayTradeNo As %String(TRUNCATE = 1, XMLNAME = "PayTradeNo");

Property HISApptID As %String(TRUNCATE = 1, XMLNAME = "HISApptID");

Property SeqCode As %String(TRUNCATE = 1, XMLNAME = "SeqCode");

Property AdmitRange As %String(TRUNCATE = 1, XMLNAME = "AdmitRange");

Property OrderTypeCode As %String(TRUNCATE = 1, XMLNAME = "OrderTypeCode");

Property BankCode As %String(TRUNCATE = 1, XMLNAME = "BankCode");

Property PaymentCode As %String(TRUNCATE = 1, XMLNAME = "PaymentCode");

Property PaymentFee As %String(TRUNCATE = 1, XMLNAME = "PaymentFee");

}
