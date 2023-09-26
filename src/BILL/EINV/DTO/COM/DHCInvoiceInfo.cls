/// 发票发放表对象
Class BILL.EINV.DTO.COM.DHCInvoiceInfo Extends %RegisteredObject
{

Property INVStartInv As %Date(CAPTION = "开始号码");

Property INVEndInv As %String(CAPTION = "结束号码");

Property INVUsr As %String(CAPTION = "领取人");

Property INVDate As %String(CAPTION = "领取日期");

Property INVTime As %String(CAPTION = "领取时间");

Property INVLastNum As %String(CAPTION = "当前可用号码");

Property INVFinalflag As %String(CAPTION = "可用标志");

Property INVtype As %String(CAPTION = "部门（门诊/住院）");

Property INVStatus As %String(CAPTION = "");

Property INVLinkto As %String(CAPTION = "");

Property INVjynum As %String(CAPTION = "");

Property INVserialno As %String(CAPTION = "");

Property INVUsrJynum As %String(CAPTION = "");

Property INVUsrSerialno As %String(CAPTION = "");

Property INVoriginaldr As %String(CAPTION = "");

Property INVtitle As %String(CAPTION = "");

Property INVcomment1 As %String(CAPTION = "");

Property INVcomment2 As %String(CAPTION = "");

Property INVhospital As %String(CAPTION = "");

Property INVBillInvCode As %String(CAPTION = "票据代码");

Property INVBillInvName As %String(CAPTION = "票据名称");

}
