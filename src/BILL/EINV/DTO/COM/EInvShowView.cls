/// 补开电子票据 页面展示对象
Class BILL.EINV.DTO.COM.EInvShowView Extends %RegisteredObject
{

Property PatRegNo As %String(CAPTION = "登记号");

Property PatName As %String(CAPTION = "患者姓名");

Property InvprtAmount As %String(CAPTION = "金额");

Property LocgicType As %String(CAPTION = "业务类型");

Property SFTFFlg As %String(CAPTION = "收费标志");

Property Invprtrowid As %String(CAPTION = "his发票Dr");

Property InitRowid As %String(CAPTION = "原发票Dr");

Property SFDate As %String(CAPTION = "收费日期");

Property SFTime As %String(CAPTION = "收费时间");

Property SFUserDr As %String(CAPTION = "收费员Dr");

Property SFUserName As %String(CAPTION = "收费院名称");

Property AdmLocName As %String(CAPTION = "就诊科室");

Property AdmHospitalDr As %String(CAPTION = "就诊院区Dr");

Property AdmHospitalNM As %String(CAPTION = "就诊院区名称");

Property EInvFlg As %String(CAPTION = "开票标志");

Property EInvCode As %String(CAPTION = "票据代码");

Property EInvSeriNo As %String(CAPTION = "票据号码");

Property BusinessDr As %String(CAPTION = "交易表Dr");

}
