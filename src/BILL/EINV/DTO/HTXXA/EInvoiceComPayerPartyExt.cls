Class BILL.EINV.DTO.HTXXA.EInvoiceComPayerPartyExt Extends (%RegisteredObject, %XML.Adaptor)
{

Property SickId As %String(CAPTION = "病人信息ID", XMLPROJECTION = "ELEMENT");

Property PayerPhoneNo As %String(CAPTION = "交款人手机号码", XMLPROJECTION = "ELEMENT");

Property CardInfos As BILL.EINV.DTO.HTXXA.EInvoiceComCardInfos(CAPTION = "就诊卡片信息", XMLPROJECTION = "ELEMENT");

}
