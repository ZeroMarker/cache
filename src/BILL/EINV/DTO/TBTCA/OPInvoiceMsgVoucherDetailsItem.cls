Class BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetailsItem Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 收费项目代码
Property ItemCode As %String(XMLPROJECTION = "ELEMENT");

/// 收费项目名称
Property ItemName As %String(XMLPROJECTION = "ELEMENT");

/// 项目医保编码
Property InsuranceItemCode As %String(XMLPROJECTION = "ELEMENT");

/// 数量
Property ItemQuantity As %String(XMLPROJECTION = "ELEMENT");

/// 计量单位
Property ItemUnit As %String(XMLPROJECTION = "ELEMENT");

/// 标准
Property ItemStd As %String(XMLPROJECTION = "ELEMENT");

/// 金额
Property ItemAmount As %String(XMLPROJECTION = "ELEMENT");

/// 项目备注
Property ItemRemark As %String(XMLPROJECTION = "ELEMENT");

}
