Class DHCBILL.SelfPay.Entity.GetChargeOrder.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// PayOrdCount 结算单数量
Property PayOrdCount As %String(TRUNCATE = 1);

/// PayOrdList	就诊信息列表
Property PayOrdList As list Of DHCBILL.SelfPay.Entity.GetChargeOrder.Res.PayOrder(XMLITEMNAME = "PayOrder", XMLPROJECTION = "COLLECTION");

}
