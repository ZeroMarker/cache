Class DHCBILL.SelfPay.Entity.PrintInvoice.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultMsg As %String(TRUNCATE = 1);

Property AccMRowID As %String(TRUNCATE = 1);

Property InvoiceList As list Of DHCBILL.SelfPay.Entity.PrintInvoice.Res.Invoice;

}
