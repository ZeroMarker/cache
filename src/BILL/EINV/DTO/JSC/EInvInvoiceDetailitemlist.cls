Class BILL.EINV.DTO.JSC.EInvInvoiceDetailitemlist Extends %RegisteredObject
{

Property itemcode As %String(CAPTION = "项目编码", XMLNAME = "item_code");

Property itemname As %String(CAPTION = "项目名称", XMLNAME = "item_name");

Property itemamount As %String(CAPTION = "金额", XMLNAME = "item_amount");

Property unit As %String(CAPTION = "计量单位");

Property num As %String(CAPTION = "数量");

Property stdtype As %String(CAPTION = "标准类型");

Property Itemext As BILL.EINV.DTO.JSC.EInvInvoiceDetailItemext(CAPTION = "明细信息扩展");

}
