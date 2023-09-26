/// 广州乐税信息科技有限公司(乐税)--税盘状态查询出参对象
Class BILL.EINV.DTO.LSA.EInvTaxDiscStatesQueryRes Extends %RegisteredObject
{

///   -1：内部错误
///  200：税盘信息获取成功
///  201：没有可用税盘（没有税盘在线）
/// 1001：参数有误
/// 1002：平台未维护税号为X的公司主体
/// 9999：系统错误	
Property code As %String(CAPTION = "返回码");

Property msg As %String(CAPTION = "返回消息");

Property body As list Of BILL.EINV.DTO.LSA.EInvTaxDiscStatesBodyRes(CAPTION = "返回对象");

}
