Class BILL.EINV.DTO.BWA.ESearchResQtxmGrp Extends %RegisteredObject
{

Parameter XMLIGNORENULL = 1;

Property xh As %String(XMLPROJECTION = "ATTRIBUTE");

/// 税率
Property sl As %String(XMLPROJECTION = "ELEMENT");

/// 金额
Property je As %String(XMLPROJECTION = "ELEMENT");

/// 税额
Property se As %String(XMLPROJECTION = "ELEMENT");

}
