Class BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxItem Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 对应项目编码
Property AuxItemRelatedCode As %String(XMLPROJECTION = "ELEMENT");

/// 对应项目名称
Property AuxItemRelatedName As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目编码
Property AuxItemCode As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目名称
Property AuxItemName As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目数量
Property AuxItemQuantity As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目单位
Property AuxItemUnit As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目标准
Property AuxItemStd As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目金额
Property AuxItemAmount As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目备注
Property AuxItemRemark As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目滞纳金金额
Property AuxItemLateFee As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目医保编码
Property AuxItemExtInsuranceItemCode As %String(XMLPROJECTION = "ELEMENT");

/// 收费明细项目ID
Property AuxItemExtId As %String(XMLPROJECTION = "ELEMENT");

/// 会计科目代码
Property AuxExtAccountCode As %String(XMLPROJECTION = "ELEMENT");

/// 会计科目名称
Property AuxExtAccountName As %String(XMLPROJECTION = "ELEMENT");

/// 开单科室名称
Property AuxExtDeptName As %String(XMLPROJECTION = "ELEMENT");

/// 科室核算码
Property AuxExtDeptAccountCode As %String(XMLPROJECTION = "ELEMENT");

/// 科室核算码名称
Property AuxExtDeptAccountName As %String(XMLPROJECTION = "ELEMENT");

/// 执行科室名称
Property AuxExtExcuteDeptName As %String(XMLPROJECTION = "ELEMENT");

/// 开单人
Property AuxExtDrawer As %String(XMLPROJECTION = "ELEMENT");

/// 执行人
Property AuxExtExecutor As %String(XMLPROJECTION = "ELEMENT");

}
