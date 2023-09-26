Class BILL.EINV.DTO.HTXXA.EInvoiceSignedInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Property Reference As %String(CAPTION = "签名原文引用", XMLPROJECTION = "ELEMENT");

Property SignatureAlgorithm As %String(CAPTION = "签名算法", XMLPROJECTION = "ELEMENT");

Property SignatureFormat As %String(CAPTION = "签名格式类型", XMLPROJECTION = "ELEMENT");

}
