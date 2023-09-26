/// 电子票据数字签名
Class BILL.EINV.DTO.HTXXA.EInvoiceEInvoiceSignature Extends (%RegisteredObject, %XML.Adaptor)
{

/// 开票单位数字签名、财政部门监制数字签名
Property Signature As BILL.EINV.DTO.HTXXA.EInvoiceSignature(CAPTION = "开票单位数字签名", XMLPROJECTION = "ELEMENT");

}
