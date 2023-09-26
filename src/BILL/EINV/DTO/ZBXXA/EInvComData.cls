/// 中博信息电子发票公共参数
Class BILL.EINV.DTO.ZBXXA.EInvComData Extends %RegisteredObject
{

/// 接口标识	入	String	见本文中的“接口标识”
Property ifCode As %String(CAPTION = "业务流水号");

Property ifUser As %String(CAPTION = "接口系统标识");

Property ifPwd As %String(CAPTION = "接口系统校验码");

Property randKey As %String(CAPTION = "随机密钥");

Property jsonData As %String(CAPTION = "请求报文数据");

// Property returnData As BILL.EINV.DTO.ZBXXA.EInvoiceList(CAPTION = "开具的票据信息");

/// 票面其他信息OtherInfo

}
