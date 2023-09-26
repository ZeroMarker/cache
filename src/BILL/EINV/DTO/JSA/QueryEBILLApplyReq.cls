Class BILL.EINV.DTO.JSA.QueryEBILLApplyReq Extends %RegisteredObject
{

Property method As %String(CAPTION = "消息方法");

Property cocode As %String(CAPTION = "医疗机构编码", XMLNAME = "co_code");

Property appid As %String(CAPTION = "业务服务的编码", XMLNAME = "app_id");

Property zonecode As %String(CAPTION = "行政区划", XMLNAME = "zone_code");

Property timestamp As %String(CAPTION = "发送请求的时间");

Property version As %String(CAPTION = "版本号");

/// applystate(0:所有类型,1:已审核,2:未审核3:作废)
Property applystate As %String(CAPTION = "电子票据状态", XMLNAME = "apply_state");

/// applytype(0：所有类型；3、按照指定单号查询)
Property applytype As %String(CAPTION = "电子票据查询方式", XMLNAME = "apply_type");

Property applyno As %String(CAPTION = "电子票据申请单号", XMLNAME = "apply_no");

}
