/// 广州乐税信息科技有限公司(乐税)--发票库存查询出参对象
Class BILL.EINV.DTO.LSA.EInventoryQueryRes Extends %RegisteredObject
{

///  -1：内部错误
/// 200：税盘信息获取成功
/// 201：没有可用税盘（没有税盘在线）
/// 1001：参数有误
/// 1002：平台未维护税号为X的公司主体
/// 9999：系统错误	
Property code As %String(CAPTION = "返回码");

Property msg As %String(CAPTION = "返回消息");

/// 税盘当前时间（yyyy-MM-dd HH:mm:ss）
Property TaxClock As %String(CAPTION = "税盘当前时间");

Property invType As %String(CAPTION = "发票类型");

Property invCode As %String(CAPTION = "发票代码");

Property invNo As %String(CAPTION = "发票号码");

Property invStock As %String(CAPTION = "剩余发票量");

}
