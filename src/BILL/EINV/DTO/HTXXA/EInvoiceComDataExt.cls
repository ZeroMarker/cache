/// 开票扩展信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComDataExt Extends %RegisteredObject
{

Property PlaceCode As %String(CAPTION = "开票点", XMLPROJECTION = "ELEMENT");

Property PayerPartyExt As BILL.EINV.DTO.HTXXA.EInvoiceComPayerPartyExt(CAPTION = "就诊信息", XMLPROJECTION = "ELEMENT");

Property EInvoiceSignatureExt As BILL.EINV.DTO.HTXXA.EInvoiceComSignatureExt(CAPTION = "签名值扩展节点", XMLPROJECTION = "ELEMENT");

Property WindowNo As %String(CAPTION = "窗口号", XMLPROJECTION = "ELEMENT");

}
