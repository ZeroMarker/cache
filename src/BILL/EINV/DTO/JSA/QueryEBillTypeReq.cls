Class BILL.EINV.DTO.JSA.QueryEBillTypeReq Extends %RegisteredObject
{

Property method As %String(CAPTION = "消息方法");

Property cocode As %String(CAPTION = "医疗机构编码", XMLNAME = "co_code");

Property appid As %String(CAPTION = "业务服务的编码", XMLNAME = "app_id");

Property zonecode As %String(CAPTION = "行政区划", XMLNAME = "zone_code");

Property timestamp As %String(CAPTION = "发送请求的时间");

Property version As %String(CAPTION = "版本号");

Property busno As %String(CAPTION = "申请业务编码", XMLNAME = "bus_no");

Property invoicetypecode As %String(CAPTION = "电子票据种类代码", XMLNAME = "invoice_type_code");

Property invoicetypename As %String(CAPTION = "电子票据种类名称", XMLNAME = "invoice_type_name");

Property count As %Integer(CAPTION = "电子票据总数");

Property applyno As %String(CAPTION = "申请单号", XMLNAME = "apply_no");

Property remark As %String(CAPTION = "申请单备注");

Property applystate As %String(CAPTION = "申请单状态", XMLNAME = "apply_state");

Property applytype As %String(CAPTION = "申请类型", XMLNAME = "apply_type");

}
