Class DHCExternalService.CardInterface.Entity.AliPayBindAccountRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 账户号
Property AccNo As %String(TRUNCATE = 1);

/// 患者ID
Property PatientID As %String(TRUNCATE = 1);

/// 结果标志（0–成功、-1–失败、-50此账户号已绑定
Property ResultCode As %String(TRUNCATE = 1);

/// 错误信息
Property ErrorMsg As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

}
