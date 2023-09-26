Class DHCExternalService.RegInterface.Entity.SelfReg.GetInsuRegParaRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：需要进行医保挂号；100:不需要医保挂号；其他
Property ResultCode As %String(TRUNCATE = 1);

/// 详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

Property AdmReasonAdmSource As %String(TRUNCATE = 1);

Property AdmReason As %String(TRUNCATE = 1);

Property Handle As %String(TRUNCATE = 1);

/// 操作员ID
Property UserID As %String(TRUNCATE = 1);

/// 就诊ID
Property PAAdmID As %String(TRUNCATE = 1);

/// 医保解析串
Property ExpString As %String(TRUNCATE = 1);

}
