/// 作废发票body
Class BILL.EINV.DTO.BWA.InvaildInvBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

/// 开票终端标识
Property kpzdbs As %String(XMLPROJECTION = "ELEMENT");

/// 发票类型代码
Property fplxdm As %String(XMLPROJECTION = "ELEMENT");

/// 作废类型
Property zflx As %String(XMLPROJECTION = "ELEMENT");

/// 发票代码
Property fpdm As %String(XMLPROJECTION = "ELEMENT");

/// 发票号码
Property fphm As %String(XMLPROJECTION = "ELEMENT");

/// 合计金额
Property hjje As %String(XMLPROJECTION = "ELEMENT");

/// 作废人
Property zfr As %String(XMLPROJECTION = "ELEMENT");

}
