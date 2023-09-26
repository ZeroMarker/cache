Class DHCBILL.SelfPay.Entity.TransferQuery.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// HospitalID	院区
Property HospitalID As %String(TRUNCATE = 1);

/// UserCode	操作员编码
Property UserCode As %String(TRUNCATE = 1);

/// CardNo	卡号
Property CardNo As %String(TRUNCATE = 1);

/// CardType	卡类型
Property CardType As %String(TRUNCATE = 1);

/// SecrityNo	就诊卡校验码
Property SecrityNo As %String(TRUNCATE = 1);

/// PatientID	患者ID
Property PatientID As %String(TRUNCATE = 1);

/// AdmID	
Property AdmID As %String(TRUNCATE = 1);

/// BillNo	
Property BillNo As %String(TRUNCATE = 1);

/// Invoice
Property Invoice As %String(TRUNCATE = 1);

/// PaidFlag
Property PaidFlag As %String(TRUNCATE = 1);

/// Amount	
Property Amount As %String(TRUNCATE = 1);

/// PayModeCode
Property PayModeCode As %String(TRUNCATE = 1);

/// BankCardNo	
Property BankCardNo As %String(TRUNCATE = 1);

/// TransferInfo //转账账户信息
Property TransferInfo As %String(TRUNCATE = 1);

/// TransTradeNo //转账流水号
Property TransTradeNo As %String(TRUNCATE = 1);

}
