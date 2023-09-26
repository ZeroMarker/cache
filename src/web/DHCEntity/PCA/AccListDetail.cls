Class web.DHCEntity.PCA.AccListDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property Index As %String(TRUNCATE = 1);

Property PrtDate As %String(TRUNCATE = 1);

Property PrtTime As %String(TRUNCATE = 1);

Property FairType As %String(TRUNCATE = 1);

Property FairTypeFlag As %String(TRUNCATE = 1);

Property Amt As %String(TRUNCATE = 1);

Property User As %String(TRUNCATE = 1);

Property BillNO As %String(TRUNCATE = 1);

Property Left As %String(TRUNCATE = 1);

Property LocDesc As %String(TRUNCATE = 1);

/// 账户支付表指针	dhc_accpaylist
Property PLRowID As %String(TRUNCATE = 1);

/// 小条表指针	dhc_invprt
Property PRTRowID As %String(TRUNCATE = 1);

Property OrderDetails As %String(TRUNCATE = 1);

}
