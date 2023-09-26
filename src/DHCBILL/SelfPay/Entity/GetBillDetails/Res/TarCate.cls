Class DHCBILL.SelfPay.Entity.GetBillDetails.Res.TarCate Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// TarCateCode 分类代码
Property TarCateCode As %String(TRUNCATE = 1);

/// TarCateDesc 分类描述
Property TarCateDesc As %String(TRUNCATE = 1);

/// CateTotalAmount 分类总费用
Property CateTotalAmount As %String(TRUNCATE = 1);

/// CateDiscAmount 分类折扣费用
Property CateDiscAmount As %String(TRUNCATE = 1);

/// CatePayorShare 分类记账费用
Property CatePayorShare As %String(TRUNCATE = 1);

/// CatePayorShare 分类自付费用
Property CatePatShare As %String(TRUNCATE = 1);

/// TarItemList 收费项目列表
Property TarItemList As list Of DHCBILL.SelfPay.Entity.GetBillDetails.Res.TarItem(XMLITEMNAME = "TarItem", XMLPROJECTION = "COLLECTION");

}
