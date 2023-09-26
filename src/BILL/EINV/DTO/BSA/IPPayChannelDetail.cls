/// 缴费渠道列表信息
Class BILL.EINV.DTO.BSA.IPPayChannelDetail Extends %RegisteredObject
{

/// 交费渠道编码
Property payChannelCode As %String(TRUNCATE = 1, XMLNAME = "payChannelCode");

/// 交费渠道值
Property payChannelValue As %String(TRUNCATE = 1, XMLNAME = "payChannelValue");

}
