Class web.DHCEntity.PCA.PrintInvoiceRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(TRUNCATE = 1);

Property AccMRowID As %String(TRUNCATE = 1);

Property Invoices As list Of web.DHCEntity.PCA.InvoicePrintData;

}
