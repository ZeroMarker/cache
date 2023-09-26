/// 卡信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComCardInfos Extends (%RegisteredObject, %XML.Adaptor)
{

Property CardType As %String(CAPTION = "就诊卡类型", XMLPROJECTION = "ELEMENT");

Property CardNum As %String(CAPTION = "就诊卡卡号", XMLPROJECTION = "ELEMENT");

Property Remark As %String(CAPTION = "备注", XMLPROJECTION = "ELEMENT");

}
