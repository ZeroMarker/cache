/// 辅助信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailAuxItem Extends (%RegisteredObject, %XML.Adaptor)
{

Property AuxItemRelatedCode As %String(CAPTION = "对应项目编码", XMLPROJECTION = "ELEMENT");

Property AuxItemRelatedName As %String(CAPTION = "对应项目名称", XMLPROJECTION = "ELEMENT");

Property AuxItemCode As %String(CAPTION = "收费明细项目编码", XMLPROJECTION = "ELEMENT");

Property AuxItemName As %String(CAPTION = "收费明细项目名称", XMLPROJECTION = "ELEMENT");

Property AuxItemQuantity As %String(CAPTION = "收费明细项目数量", XMLPROJECTION = "ELEMENT");

Property AuxItemUnit As %String(CAPTION = "收费明细项目单位", XMLPROJECTION = "ELEMENT");

Property AuxItemStd As %String(CAPTION = "收费明细项目标准", XMLPROJECTION = "ELEMENT");

Property AuxItemAmount As %String(CAPTION = "收费明细项目金额", XMLPROJECTION = "ELEMENT");

Property AuxItemRemark As %String(CAPTION = "收费明细项目备注", XMLPROJECTION = "ELEMENT");

}
