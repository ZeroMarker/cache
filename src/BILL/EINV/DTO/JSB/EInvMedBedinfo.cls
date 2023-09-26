/// 住院信息
Class BILL.EINV.DTO.JSB.EInvMedBedinfo Extends %RegisteredObject
{

Property "patient_type" As %String(CAPTION = "人员类别");

Property "in_category" As %String(CAPTION = "入院科室名称");

Property "in_category_code" As %String(CAPTION = "入院科室编码");

Property "out_category" As %String(CAPTION = "出院科室名称");

Property "out_category_code" As %String(CAPTION = "出院科室编码");

/// 患者住院号，当 med_bedinfo  节点时必填
Property "hospital_no" As %String(CAPTION = "患者住院号");

Property "hospital_area" As %String(CAPTION = "病区");

Property "bed_no" As %String(CAPTION = "床号");

Property "case_no" As %String(CAPTION = "病历号");

/// 住院日期,格式：yyyyMMdd
Property "in_date" As %String(CAPTION = "住院日期");

/// 出院日期,格式：yyyyMMdd
Property "out_date" As %String(CAPTION = "出院日期");

Property hospitalDays As %String(CAPTION = "住院天数");

}
