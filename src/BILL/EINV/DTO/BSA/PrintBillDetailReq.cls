/// 打印清单接口参数
Class BILL.EINV.DTO.BSA.PrintBillDetailReq Extends %RegisteredObject
{

Property billBatchCode As %String(CAPTION = "电子票据代码");

Property billNo As %String(CAPTION = "电子票据号");

Property random As %String(CAPTION = "电子票据校验码");

Property total As %String(CAPTION = "总页数");

Property pageNoBgn As %String(CAPTION = "起始页码");

Property pageNoEnd As %String(CAPTION = "终止页码");

}
