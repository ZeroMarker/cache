Class BILL.EINV.DTO.FSA.EinvoiceResData Extends %RegisteredObject
{

Property einvoiceid As %String(CAPTION = "电子票据ID");

Property einvoicecode As %String(CAPTION = "电子票据代码");

Property einvoicenumber As %String(CAPTION = "电子票据号码");

Property randomnumber As %String(CAPTION = "校验码");

Property einvoicefilename As %String(CAPTION = "电子票据文件名称");

Property state As %String(CAPTION = "开票状态");

Property bizcode As %String(CAPTION = "业务流水号");

}
