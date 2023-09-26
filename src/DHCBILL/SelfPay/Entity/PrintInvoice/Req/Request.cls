Class DHCBILL.SelfPay.Entity.PrintInvoice.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property TradeCode As %String(TRUNCATE = 1);

Property HospitalID As %String(TRUNCATE = 1);

Property CardNo As %String(TRUNCATE = 1);

Property SecrityNo As %String(TRUNCATE = 1);

Property CardType As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property UserCode As %String(TRUNCATE = 1);

Property TerminalID As %String(TRUNCATE = 1);

/// TradeChannel 接入方代码
Property TradeChannel As %String(TRUNCATE = 1);

Property AccMRowID As %String(MAXLEN = 30, TRUNCATE = 1);

Property PRTRowIDStr As %String(TRUNCATE = 1);

Property ExpStr As %String(MAXLEN = 256, TRUNCATE = 1);

/// BatchNo 当前票据批次号
Property BatchNo As %String(TRUNCATE = 1);

/// CurrentNo 当前票据号码
Property CurrentNo As %String(TRUNCATE = 1);

}
