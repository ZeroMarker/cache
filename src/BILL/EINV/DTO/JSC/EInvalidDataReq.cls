Class BILL.EINV.DTO.JSC.EInvalidDataReq Extends %RegisteredObject
{

Property invoicecode As %String(CAPTION = "票据代码", XMLNAME = "invoice_code");

Property invoicenumber As %String(CAPTION = "票据号码", XMLNAME = "invoice_number");

Property Sftype As %String(CAPTION = "收费类型", XMLNAME = "Sftype");

Property applyusername As %String(CAPTION = "开票人姓名", XMLNAME = "apply_username");

Property applyuserid As %String(CAPTION = "开票人ID", XMLNAME = "apply_userid");

}
