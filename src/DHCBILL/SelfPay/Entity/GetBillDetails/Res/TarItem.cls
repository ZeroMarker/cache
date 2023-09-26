Class DHCBILL.SelfPay.Entity.GetBillDetails.Res.TarItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// TarCateCode 项目大类代码
Property TarCateCode As %String(TRUNCATE = 1);

/// TarCateDesc 项目大类名称
Property TarCateDesc As %String(TRUNCATE = 1);

/// ItemCode 项目代码
Property ItemCode As %String(TRUNCATE = 1);

/// ItemDesc 项目名称
Property ItemDesc As %String(TRUNCATE = 1);

/// ItemBillDate 项目账单日期
Property ItemBillDate As %String(TRUNCATE = 1);

/// ItemBillTime 项目账单时间
Property ItemBillTime As %String(TRUNCATE = 1);

/// ItemQty 项目数量
Property ItemQty As %String(TRUNCATE = 1);

/// ItemPrice 项目单价
Property ItemPrice As %String(TRUNCATE = 1);

/// ItemTotalAmount 项目金额
Property ItemTotalAmount As %String(TRUNCATE = 1);

/// ItemDiscAmount 项目折扣金额
Property ItemDiscAmount As %String(TRUNCATE = 1);

/// ItemPayorShare 项目记账金额
Property ItemPayorShare As %String(TRUNCATE = 1);

/// ItemPatShare 项目自付金额
Property ItemPatShare As %String(TRUNCATE = 1);

}
