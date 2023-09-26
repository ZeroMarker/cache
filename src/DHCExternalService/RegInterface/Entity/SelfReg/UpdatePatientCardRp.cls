Class DHCExternalService.RegInterface.Entity.SelfReg.UpdatePatientCardRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

//交易代码21002

Property TradeCode As %String(TRUNCATE = 1);

//结果标志（0–成功、-1–失败、-50此卡号已解除绑定）

Property ResultCode As %String(TRUNCATE = 1);

//错误信息

Property ErrorMsg As %String(TRUNCATE = 1);

//交易流水号

Property TransactionId As %String(TRUNCATE = 1);

}
