Class BILL.EINV.DTO.BWA.PrintInvBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

/// 开票终端标识
Property kpzdbs As %String(XMLPROJECTION = "ELEMENT");

/// 发票类型代码
Property fplxdm As %String(XMLPROJECTION = "ELEMENT");

/// 发票代码
Property fpdm As %String(XMLPROJECTION = "ELEMENT");

/// 发票号码
Property fphm As %String(XMLPROJECTION = "ELEMENT");

/// 打印类型
Property dylx As %String(XMLPROJECTION = "ELEMENT");

/// 打印方式
Property dyfs As %String(XMLPROJECTION = "ELEMENT");

/// 打印机名称
Property printername As %String(XMLPROJECTION = "ELEMENT");

}
