Class web.DHCEntity.PCA.PrintInvoiceRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property TradeCode As %String(TRUNCATE = 1);

Property InvPrtRowIDStr As %String(TRUNCATE = 1);

Property UserCode As %String(TRUNCATE = 1);

Property AccMRowID As %String(MAXLEN = 30, TRUNCATE = 1);

Property PapmiRowid As %String(TRUNCATE = 1);

Property ExpStr As %String(MAXLEN = 256, TRUNCATE = 1);

}
