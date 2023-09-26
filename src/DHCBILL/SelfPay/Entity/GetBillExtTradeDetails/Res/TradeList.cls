Class DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Res.TradeList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property Index As %String(TRUNCATE = 1);

Property HISTradeNo As %String(TRUNCATE = 1);

Property HISTradeAmt As %String(TRUNCATE = 1);

Property HISTradeDate As %String(TRUNCATE = 1);

Property HISTradeTime As %String(TRUNCATE = 1);

Property TradeNo As %String(TRUNCATE = 1);

Property TradeAmt As %String(TRUNCATE = 1);

Property PlatformNo As %String(TRUNCATE = 1);

Property TradeChannel As %String(TRUNCATE = 1);

Property TradeType As %String(TRUNCATE = 1);

Property OldHISHISTradeNo As %String(TRUNCATE = 1);

Property TradeUser As %String(TRUNCATE = 1);

Property PatNo As %String(TRUNCATE = 1);

Property PatName As %String(TRUNCATE = 1);

Property HISTradeType As %String(TRUNCATE = 1);

}
