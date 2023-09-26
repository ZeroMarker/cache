Class DHCBILL.SelfPay.Entity.GetBillDetails.Res.Bill Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// BillStDate 账单开始日期
Property BillStDate As %String(TRUNCATE = 1);

/// BillEndDate 账单结束日期
Property BillEndDate As %String(TRUNCATE = 1);

/// BillTotalAmount 账单总费用
Property BillTotalAmount As %String(TRUNCATE = 1);

/// BillDiscAmount 账单折扣费用
Property BillDiscAmount As %String(TRUNCATE = 1);

/// BillPayorShare 账单记账费用
Property BillPayorShare As %String(TRUNCATE = 1);

/// BillPayorShare 账单自付费用
Property BillPatShare As %String(TRUNCATE = 1);

/// BillStatus 账单状态
Property BillStatus As %String(TRUNCATE = 1);

/// TarCateList 收费项列表
Property TarItemList As list Of DHCBILL.SelfPay.Entity.GetBillDetails.Res.TarItem(XMLITEMNAME = "TarItem", XMLPROJECTION = "COLLECTION");

/// OrdItemList 医嘱列表
Property OrdItemList As list Of DHCBILL.SelfPay.Entity.GetBillDetails.Res.OrdItem(XMLITEMNAME = "OrdItem", XMLPROJECTION = "COLLECTION");

}
