Class DHCBILL.SelfPay.Entity.CompleteCharge.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// HospitalID	院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// CardNo	卡号
Property CardNo As %String(TRUNCATE = 1);

/// CardType	卡类型
Property CardType As %String(TRUNCATE = 1);

/// SecrityNo	校验码
Property SecrityNo As %String(TRUNCATE = 1);

/// PatientID	患者ID(HIS登记号)
Property PatientID As %String(TRUNCATE = 1);

/// UserCode 用户代码
Property UserCode As %String(TRUNCATE = 1);

/// TerminalID 终端号（自助机编号）
Property TerminalID As %String(TRUNCATE = 1);

/// InvoiceNoStr	结算票据流水串（^分割）
Property InvoiceNoStr As %String(TRUNCATE = 1);

/// OrderNo	结算单号
Property OrderNo As %String(TRUNCATE = 1);

/// PayDetails	就诊信息列表
Property PayDetails As DHCBILL.SelfPay.Entity.CompleteCharge.Req.PayDetails;

/// InsuPersonInfo 医保参保人信息
Property InsuPersonInfo As %String(TRUNCATE = 1);

/// InsuDivide 医保结算结果
Property InsuDivide As %GlobalCharacterStream;

/// InsuTradeOut 医保确认结果
Property InsuTradeOut As %GlobalCharacterStream;

}
