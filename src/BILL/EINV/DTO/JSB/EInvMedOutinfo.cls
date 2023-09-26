/// 门诊信息
Class BILL.EINV.DTO.JSB.EInvMedOutinfo Extends %RegisteredObject
{

Property category As %String(CAPTION = "就诊科室");

Property "category_code" As %String(CAPTION = "就诊科室编码");

Property "patient_no" As %String(CAPTION = "患者门诊号");

Property "case_no" As %String(CAPTION = "病历号");

Property "sp_dis_name" As %String(CAPTION = "特殊病种名称");

}
