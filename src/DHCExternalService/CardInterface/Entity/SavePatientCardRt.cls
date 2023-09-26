/// 发就诊卡
Class DHCExternalService.CardInterface.Entity.SavePatientCardRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

Property CardTypeCode As %String(TRUNCATE = 1);

Property PatientCard As %String(TRUNCATE = 1);

Property SecurityNo As %String(TRUNCATE = 1);

Property ChipSerialNo As %String(TRUNCATE = 1);

Property PatientType As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

Property DOB As %String(TRUNCATE = 1);

Property IDType As %String(TRUNCATE = 1);

Property IDNo As %String(TRUNCATE = 1);

Property Mobile As %String(TRUNCATE = 1);

Property MaritalStatus As %String(TRUNCATE = 1);

Property Nation As %String(TRUNCATE = 1);

Property Occupation As %String(TRUNCATE = 1);

Property Nationality As %String(TRUNCATE = 1);

Property Address As %String(MAXLEN = 60, TRUNCATE = 1);

Property AddressLocus As %String(MAXLEN = 60, TRUNCATE = 1);

Property Zip As %String(TRUNCATE = 1);

Property Company As %String(MAXLEN = 60, TRUNCATE = 1);

Property CompanyAddr As %String(MAXLEN = 60, TRUNCATE = 1);

Property CompanyZip As %String(TRUNCATE = 1);

Property CompanyTelNo As %String(TRUNCATE = 1);

Property TelephoneNo As %String(TRUNCATE = 1);

Property ContactName As %String(TRUNCATE = 1);

Property ContactAddress As %String(MAXLEN = 60, TRUNCATE = 1);

Property Relation As %String(TRUNCATE = 1);

Property ContactTelNo As %String(TRUNCATE = 1);

Property ContactIDNo As %String(TRUNCATE = 1);

Property ContactIDType As %String(TRUNCATE = 1);

Property InsureCardFlag As %String(TRUNCATE = 1);

Property InsureCardNo As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property TerminalID As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

/// 卡押金
Property CardDepositAmt As %String(TRUNCATE = 1);

Property PayModeCode As %String(TRUNCATE = 1);

Property PayBankCode As %String(TRUNCATE = 1);

Property PayCardNo As %String(TRUNCATE = 1);

Property PayTradeStr As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 预交金总额
Property ChargeDepositAmt As %String(TRUNCATE = 1);

Property AccountPassword As %String(TRUNCATE = 1);

Property TheArea As %String(TRUNCATE = 1);

Property BankTradeInfo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property PhotoInfo As %String(TRUNCATE = 1);

/// PayDetails	支付宝、微信接口支付信息
Property PayDetails As DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails;

}
