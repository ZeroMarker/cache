Class BILL.EINV.DTO.JSA.EBILLWareHousReq Extends %RegisteredObject
{

Property method As %String(CAPTION = "消息方法");

Property cocode As %String(CAPTION = "医疗机构编码", XMLNAME = "co_code");

Property appid As %String(CAPTION = "业务服务的编码", XMLNAME = "app_id");

Property zonecode As %String(CAPTION = "行政区划", XMLNAME = "zone_code");

Property timestamp As %String(CAPTION = "发送请求的时间");

Property version As %String(CAPTION = "版本号");

Property invoicecode As %String(CAPTION = "电子票据代码", XMLNAME = "invoice_code");

Property invoicename As %String(CAPTION = "电子票据名称", XMLNAME = "invoice_name");

Property count As %String(CAPTION = "电子票据总数");

Property startno As %String(CAPTION = "开始票据号", XMLNAME = "start_no");

Property endno As %String(CAPTION = "结束票据号", XMLNAME = "end_no");

}
