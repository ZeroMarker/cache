/// 广州乐税信息科技有限公司(乐税)--直连开票出参对象
Class BILL.EINV.DTO.LSA.EInvoiceRes Extends %RegisteredObject
{

///  -1：内部错误
/// 200：调用成功
/// 1001：参数有误
/// 1002：没有接收到数据
/// 1003：接收失败	
Property code As %String(CAPTION = "返回码");

Property msg As %String(CAPTION = "返回消息");

Property body As BILL.EINV.DTO.LSA.EInvoiceBodyRes(CAPTION = "开票成功返回的发票信息");

}
