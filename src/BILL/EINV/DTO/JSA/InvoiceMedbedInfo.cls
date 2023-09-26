Class BILL.EINV.DTO.JSA.InvoiceMedbedInfo Extends %RegisteredObject
{

Property patienttype As %String(CAPTION = "人员类别", XMLNAME = "patient_type");

Property incategory As %String(CAPTION = "入院科室名称", XMLNAME = "in_category");

Property incategorycode As %String(CAPTION = "入院科室编码", XMLNAME = "in_category_code");

Property outcategory As %String(CAPTION = "出院科室名称", XMLNAME = "out_category");

Property outcategorycode As %String(CAPTION = "出院科室编码", XMLNAME = "out_category_code");

Property hospitalno As %String(CAPTION = "患者住院号", XMLNAME = "hospital_no");

Property hospitalarea As %String(CAPTION = "病区", XMLNAME = "hospital_area");

Property bedno As %String(CAPTION = "床号", XMLNAME = "bed_no");

Property caseno As %String(CAPTION = "病历号", XMLNAME = "case_no");

Property indate As %String(CAPTION = "住院日期", XMLNAME = "in_date");

Property outdate As %String(CAPTION = "出院日期", XMLNAME = "out_date");

Property hospitalDays As %String(CAPTION = "住院天数", XMLNAME = "hospitalDays");

}
