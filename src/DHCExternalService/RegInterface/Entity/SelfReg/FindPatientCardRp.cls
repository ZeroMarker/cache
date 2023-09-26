Class DHCExternalService.RegInterface.Entity.SelfReg.FindPatientCardRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 结果标志（0–成功、-1–失败、-50此卡号已建卡、-51已有同类型的卡）
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ErrorMsg");

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 就诊卡卡押金
Property CardDepositAmt As %String(TRUNCATE = 1);

}
