Class BILL.EINV.DTO.HNA.InvalidReq Extends %RegisteredObject
{

Property ivcCode As %String(CAPTION = "票据代码");

Property ivcNumber As %String(CAPTION = "票据代码");

Property bizCode As %String(CAPTION = "原电子票据业务流水号");

Property paperIvcCode As %String(CAPTION = "红票票据对应纸质票票据代码");

Property paperIvcNumber As %String(CAPTION = "红票据对应纸质票票据号码");

Property reason As %String(CAPTION = "冲红原因");

Property sysCode As %String(CAPTION = "系统代码");

}
