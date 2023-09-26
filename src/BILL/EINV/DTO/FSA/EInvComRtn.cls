/// 电子票据开具查询返回值对象定义
Class BILL.EINV.DTO.FSA.EInvComRtn Extends %RegisteredObject
{

Property code As %String(CAPTION = "返回码");

Property msg As %String(CAPTION = "返回消息");

Property data As list Of BILL.EINV.DTO.FSA.EinvoiceResData(CAPTION = "开票返回结果");

}
