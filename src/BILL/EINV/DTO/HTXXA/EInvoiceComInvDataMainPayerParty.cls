/// 交款人信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainPayerParty Extends (%RegisteredObject, %XML.Adaptor)
{

/// 1:个人; 2:单位
Property PayerPartyType As %String(CAPTION = "交款人类型", XMLPROJECTION = "ELEMENT");

Property PayerPartyCode As %String(CAPTION = "交款人代码", XMLPROJECTION = "ELEMENT");

Property PayerPartyName As %String(CAPTION = "交款人名称", XMLPROJECTION = "ELEMENT");

Property PayerAcct As %String(CAPTION = "交款人账号", XMLPROJECTION = "ELEMENT");

Property PayerOpBk As %String(CAPTION = "交款人开户行", XMLPROJECTION = "ELEMENT");

}
