Class DHCExternalService.BillInterface.DHCEntity.AddOPDepositRp Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(MAXLEN = 256, TRUNCATE = 1);

Property DepositAmount As %String(TRUNCATE = 1);

Property InvoiceNo As %String(TRUNCATE = 1);

Property RechargeTime As %String(TRUNCATE = 1);

}
