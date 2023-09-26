/// 体检信息
Class BILL.EINV.DTO.JSC.EInvInvoiceMedexaminfo Extends %RegisteredObject
{

Property category As %String(CAPTION = "就诊科室");

Property categorycode As %String(CAPTION = "就诊科室编码", XMLNAME = "category_code");

/// 体检号码，当有 med_examinfo节点时必填
Property examno As %String(CAPTION = "体检号码", XMLNAME = "exam_no");

}
