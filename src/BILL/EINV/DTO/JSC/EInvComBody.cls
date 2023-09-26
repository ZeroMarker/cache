/// 查询、红冲公用参数
Class BILL.EINV.DTO.JSC.EInvComBody Extends %RegisteredObject
{

Property HOSID As %String(CAPTION = "医疗机构编码", XMLNAME = "HOS_ID");

Property APPID As %String(CAPTION = "业务服务的编码", XMLNAME = "APP_ID");

Property invoicecode As %String(CAPTION = "票据代码", XMLNAME = "invoice_code");

Property invoicenumber As %String(CAPTION = "电子票据号码", XMLNAME = "invoice_number");

}
