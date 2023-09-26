/// /对账数据出参类
Class DHCBILL.SelfPay.Entity.GetBills.Respons.Res Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// TransCode 业务类型
Property TransCode As %String(TRUNCATE = 1);

/// BillDate 账单日期
Property BillDate As %String(TRUNCATE = 1);

/// List	就诊信息列表
Property List As list Of DHCBILL.SelfPay.Entity.GetBills.Respons.Item(XMLITEMNAME = "Item", XMLPROJECTION = "COLLECTION");

}
