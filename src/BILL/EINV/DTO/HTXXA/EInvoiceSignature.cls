Class BILL.EINV.DTO.HTXXA.EInvoiceSignature Extends (%RegisteredObject, %XML.Adaptor)
{

Property SignedInfo As BILL.EINV.DTO.HTXXA.EInvoiceSignedInfo(CAPTION = "版本", XMLNAME = "SignedInfo", XMLPROJECTION = "ELEMENT");

Property SignatureTime As %String(CAPTION = "签名时间", XMLPROJECTION = "ELEMENT");

Property SignatureValue As %String(CAPTION = "签名值", XMLPROJECTION = "ELEMENT");

Property KeyInfo As BILL.EINV.DTO.HTXXA.EInvoiceKeyInfo(CAPTION = "证书信息", XMLPROJECTION = "ELEMENT");

}
