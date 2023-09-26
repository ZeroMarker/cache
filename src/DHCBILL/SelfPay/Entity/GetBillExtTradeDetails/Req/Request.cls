Class DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property TradeCode As %String(TRUNCATE = 1);

Property HospitalID As %String(TRUNCATE = 1);

Property TradeChannel As %String(TRUNCATE = 1);

Property StartDate As %String(TRUNCATE = 1);

Property EndDate As %String(TRUNCATE = 1);

Property ExpStr As %String(TRUNCATE = 1);

}
