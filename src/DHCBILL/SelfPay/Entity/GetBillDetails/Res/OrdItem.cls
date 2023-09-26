Class DHCBILL.SelfPay.Entity.GetBillDetails.Res.OrdItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// OrdCode 医嘱代码
Property OrdCode As %String(TRUNCATE = 1);

/// OrdDesc 医嘱名称
Property OrdDesc As %String(TRUNCATE = 1);

/// OrdDate 日期
Property OrdDate As %String(TRUNCATE = 1);

/// OrdTime 时间
Property OrdTime As %String(TRUNCATE = 1);

/// OrdQty 数量
Property OrdQty As %String(TRUNCATE = 1);

/// OrdPrice 单价
Property OrdPrice As %String(TRUNCATE = 1);

/// OrdUom 
Property OrdUom As %String(TRUNCATE = 1);

/// OrdTotalAmount 金额
Property OrdTotalAmount As %String(TRUNCATE = 1);

/// OrdDiscAmount 折扣金额
Property OrdDiscAmount As %String(TRUNCATE = 1);

/// OrdPayorShare 记账金额
Property OrdPayorShare As %String(TRUNCATE = 1);

/// OrdPatShare 自付金额
Property OrdPatShare As %String(TRUNCATE = 1);

}
