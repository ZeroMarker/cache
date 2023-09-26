Class BILL.EINV.DTO.BWA.ESearchMsgBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 应用类型代码
Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

/// 开票终端标识
Property kpzdbs As %String(XMLPROJECTION = "ELEMENT");

/// 发票类型代码
Property fplxdm As %String(XMLPROJECTION = "ELEMENT");

/// 查询方式
Property cxfs As %String(XMLPROJECTION = "ELEMENT");

/// 查询条件
Property cxtj As %String(XMLPROJECTION = "ELEMENT");

}
