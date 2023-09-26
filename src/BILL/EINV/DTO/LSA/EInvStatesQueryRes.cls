/// 广州乐税信息科技有限公司(乐税)--发票查询出参对象
Class BILL.EINV.DTO.LSA.EInvStatesQueryRes Extends %RegisteredObject
{

///  -1：内部错误
/// 200：返回成功
/// 1001：参数有误
/// 1002：没有接收到数据
/// 1003：单据已被开具	
Property code As %String(CAPTION = "返回码");

Property msg As %String(CAPTION = "返回消息");

Property objects As BILL.EINV.DTO.LSA.EInvStatesBodyRes(CAPTION = "返回对象");

}
