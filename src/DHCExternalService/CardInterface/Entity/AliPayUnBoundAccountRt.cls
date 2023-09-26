Class DHCExternalService.CardInterface.Entity.AliPayUnBoundAccountRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 病人登记号
Property PatientID As %String(TRUNCATE = 1);

/// 银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 病人姓名
Property PatientName As %String(TRUNCATE = 1);

/// 终端ID
Property TransactionId As %String(TRUNCATE = 1);

/// 卡类型
Property CardTypeCode As %String(TRUNCATE = 1);

/// 病人卡号
Property PatientCard As %String(TRUNCATE = 1);

}
