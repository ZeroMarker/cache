/// 票据明细信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailItem Extends (%RegisteredObject, %XML.Adaptor)
{

Property ItemCode As %String(CAPTION = "项目编码", XMLPROJECTION = "ELEMENT");

Property ItemName As %String(CAPTION = "项目名称", XMLPROJECTION = "ELEMENT");

Property ItemAmount As %String(CAPTION = "金额", XMLPROJECTION = "ELEMENT");

Property ItemUnit As %String(CAPTION = "单位", XMLPROJECTION = "ELEMENT");

Property ItemQuantity As %String(CAPTION = "数量", XMLPROJECTION = "ELEMENT");

Property ItemStd As %String(CAPTION = "标准", XMLPROJECTION = "ELEMENT");

Property ItemRemark As %String(CAPTION = "项目备注", XMLPROJECTION = "ELEMENT");

Property ItemExt As BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailItemExt(CAPTION = "明细信息扩展", XMLPROJECTION = "ELEMENT");

}
