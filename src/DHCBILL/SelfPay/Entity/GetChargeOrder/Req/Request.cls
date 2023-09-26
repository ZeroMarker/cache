Class DHCBILL.SelfPay.Entity.GetChargeOrder.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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

/// StartDate	开始日期
Property StartDate As %String(TRUNCATE = 1);

/// EndDate	结束日期
Property EndDate As %String(TRUNCATE = 1);

/// Adm	就诊号
Property Adm As %String(TRUNCATE = 1);

/// ExpStr	扩展信息
Property ExpStr As %String(TRUNCATE = 1);

}
