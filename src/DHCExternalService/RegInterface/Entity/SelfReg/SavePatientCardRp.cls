Class DHCExternalService.RegInterface.Entity.SelfReg.SavePatientCardRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ErrorMsg");

/// 结果标志（0–成功、-1–失败、-50此卡号已建卡、-51已有同类型的卡）
Property TradeCode As %String(TRUNCATE = 1);

/// 就诊卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 就诊卡校验码
Property SecurityNo As %String(TRUNCATE = 1);

/// 患者ID
Property PatientID As %String(TRUNCATE = 1);

/// 是否需要激活标志(0—不需要激活就能正常使用；1—存在多个患者ID，需要激活后才能在医院内使用；2—医保患者身份需确认、激活后才能在医院内使用；)
Property ActiveFlag As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

}
