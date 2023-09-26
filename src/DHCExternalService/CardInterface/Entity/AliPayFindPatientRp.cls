Class DHCExternalService.CardInterface.Entity.AliPayFindPatientRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 返回结果
Property ResultCode As %String(TRUNCATE = 1);

/// 错误信息
Property ErrorMsg As %String(TRUNCATE = 1);

/// 数量
Property RecordCount As %String(TRUNCATE = 1);

/// 记录
Property PatientRecordSet As list Of DHCExternalService.CardInterface.Entity.AliPayRecord(XMLITEMNAME = "Record", XMLNAME = "PatientRecordSet", XMLPROJECTION = "COLLECTION");

}
