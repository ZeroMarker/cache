Class DHCBILL.SelfPay.Entity.GetPatAccList.Res.InvDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property Index As %String(TRUNCATE = 1);

Property PrtDate As %String(TRUNCATE = 1);

Property PrtTime As %String(TRUNCATE = 1);

Property FairType As %String(TRUNCATE = 1);

Property Amt As %String(TRUNCATE = 1);

Property User As %String(TRUNCATE = 1);

Property BillNo As %String(TRUNCATE = 1);

Property Left As %String(TRUNCATE = 1);

Property PayDept As %String(TRUNCATE = 1);

/// 账户支付表指针	dhc_accpaylist
Property PLRowID As %String(TRUNCATE = 1);

/// 小条表指针	dhc_invprt
Property PRTRowID As %String(TRUNCATE = 1);

Property OrderDetails As %String(TRUNCATE = 1);

/// 电票标志EInvFlag
Property EInvFlag As %String(TRUNCATE = 1);

/// EBatcheNo 电票代码
Property EBatcheNo As %String(TRUNCATE = 1);

/// EBillNo 电票号码
Property EInvNo As %String(TRUNCATE = 1);

}
