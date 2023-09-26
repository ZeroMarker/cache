Class BILL.EINV.DTO.HTXXA.EInvoiceRes Extends (%RegisteredObject, %Populate, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "EIFeiMakeResponse";

Property SerialNum As %String(CAPTION = "票据处理请求唯一标识流水号", XMLPROJECTION = "ELEMENT");

Property HoldSerialBiz As %String(CAPTION = "业务流水号", XMLPROJECTION = "ELEMENT");

Property EInvoiceCode As %String(CAPTION = "电子票据代码", XMLPROJECTION = "ELEMENT");

Property EInvoiceNumber As %String(CAPTION = "电子票据号码", XMLPROJECTION = "ELEMENT");

}
