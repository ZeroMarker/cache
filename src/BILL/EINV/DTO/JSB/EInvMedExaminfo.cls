/// 体检信息
Class BILL.EINV.DTO.JSB.EInvMedExaminfo Extends %RegisteredObject
{

Property category As %String(CAPTION = "就诊科室");

Property "category_code" As %String(CAPTION = "就诊科室编码");

/// 体检号码，当有 med_examinfo 节点时必填
Property "exam_no" As %String(CAPTION = "体检号码");

}
