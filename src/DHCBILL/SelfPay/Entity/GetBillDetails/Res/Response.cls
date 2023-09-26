Class DHCBILL.SelfPay.Entity.GetBillDetails.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// BillList 账单列表
Property BillList As list Of DHCBILL.SelfPay.Entity.GetBillDetails.Res.Bill(XMLITEMNAME = "Bill", XMLPROJECTION = "COLLECTION");

}
