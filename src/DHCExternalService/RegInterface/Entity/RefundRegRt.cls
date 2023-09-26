Class DHCExternalService.RegInterface.Entity.RefundRegRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "RefundRegRt";

Parameter XMLIGNOREINVALIDTAG = 1;

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property ClientType As %String(TRUNCATE = 1, XMLNAME = "ClientType");

Property HospitalID As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property ExtUserID As %String(TRUNCATE = 1, XMLNAME = "ExtUserID");

Property BankID As %String(TRUNCATE = 1, XMLNAME = "BankID");

Property TerminalID As %String(TRUNCATE = 1, XMLNAME = "TerminalID");

Property BankDate As %String(TRUNCATE = 1, XMLNAME = "BankDate");

Property BankTradeNo As %String(TRUNCATE = 1, XMLNAME = "BankTradeNo");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Property BankAccDate As %String(TRUNCATE = 1, XMLNAME = "BankAccDate");

Property OrgHISTradeNo As %String(TRUNCATE = 1, XMLNAME = "OrgHISTradeNo");

Property OrgOrderCode As %String(TRUNCATE = 1, XMLNAME = "OrgOrderCode");

Property OrgPayFee As %String(TRUNCATE = 1, XMLNAME = "OrgPayFee");

Property PayInsuFee As %String(TRUNCATE = 1, XMLNAME = "PayInsuFee");

Property PayBankCode As %String(TRUNCATE = 1, XMLNAME = "PayBankCode");

Property OrgPayCardNo As %String(TRUNCATE = 1, XMLNAME = "OrgPayCardNo");

Property OrgPayModeCode As %String(TRUNCATE = 1, XMLNAME = "OrgPayModeCode");

Property OrgBankTradeNo As %String(TRUNCATE = 1, XMLNAME = "OrgBankTradeNo");

Property RefundType As %String(TRUNCATE = 1, XMLNAME = "RefundType");

Property OrderTypeCode As %String(TRUNCATE = 1, XMLNAME = "OrderTypeCode");

}
