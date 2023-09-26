Class BILL.EINV.DTO.JSD.EInvalidData Extends %RegisteredObject
{

/// 数据源，固定参数 “API”
Property dataresources As %String(CAPTION = "数据源", XMLNAME = "data_resources");

Property nsrsbh As %String(CAPTION = "销售方纳税人识别号");

/// 业务单据号；必须是唯一的（不能超过45位）
Property ordernum As %String(CAPTION = "业务单据号", XMLNAME = "order_num");

/// 	税控盘号（使用税控盒子必填，其他设备为空）
Property skph As %String(CAPTION = "税控盘号");

Property kpr As %String(CAPTION = "开票人");

Property skr As %String(CAPTION = "收款人");

Property fhr As %String(CAPTION = "复核人");

Property yfpdm As %String(CAPTION = "原发票代码", XMLNAME = "yfp_dm");

Property yfphm As %String(CAPTION = "原发票号码", XMLNAME = "yfp_hm");

/// 备注长度应减去”对应正数发票代码:XXXXXXXXXXXX号码:YYYYYYYY\n”字样长度，长度剩余140
Property bz As %String(CAPTION = "备注");

}
