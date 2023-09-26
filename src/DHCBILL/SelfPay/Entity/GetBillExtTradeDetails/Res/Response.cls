Class DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultMsg As %String(TRUNCATE = 1);

Property TradeLists As list Of DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Res.TradeList;

}
