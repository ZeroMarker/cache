/// 证书信息
Class BILL.EINV.DTO.HTXXA.EInvoiceKeyInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Property SerialNumber As %String(CAPTION = "证书编号", XMLPROJECTION = "ELEMENT");

Property X509IssuerName As %String(CAPTION = "X.509证书颁发者名称", XMLPROJECTION = "ELEMENT");

}
