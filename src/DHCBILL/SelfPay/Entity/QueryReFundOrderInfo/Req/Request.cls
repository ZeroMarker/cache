Class DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Property stDate As %String(TRUNCATE = 1, XMLITEMNAME = "START_DATE");

Property endDate As %String(TRUNCATE = 1, XMLITEMNAME = "END_DATE");

Property guser As %String(TRUNCATE = 1, XMLITEMNAME = "APP_HIS_OPERATOR");

}
