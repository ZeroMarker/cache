/// 获取电子票据文件出参
Class BILL.EINV.DTO.FSA.EInvMedicalInfo Extends %RegisteredObject
{

Property code As %String(CAPTION = "返回码");

Property msg As %String(CAPTION = "返回消息");

Property data As list Of BILL.EINV.DTO.FSA.EInvMedicalData(CAPTION = "票据文件返回结果");

}
