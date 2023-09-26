Class BILL.EINV.DTO.JSA.InvoiceListDetail Extends %RegisteredObject
{

Property itemcode As %String(CAPTION = "项目编码", XMLNAME = "item_code");

Property itemname As %String(CAPTION = "项目名称", XMLNAME = "item_name");

Property itemamount As %String(CAPTION = "金额", XMLNAME = "item_amount");

Property unit As %String(CAPTION = "计量单位", XMLNAME = "unit");

Property num As %String(CAPTION = "数量", XMLNAME = "num");

Property stdtype As %String(CAPTION = "标准类型", XMLNAME = "stdtype");

Property Itemext As BILL.EINV.DTO.JSA.InvoiceItemText(CAPTION = "明细信息扩展", XMLNAME = "Itemext");

}
