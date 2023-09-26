/// 住院信息
Class BILL.EINV.DTO.JSC.EInvInvoiceMedbedinfo Extends %RegisteredObject
{

Property patienttype As %String(CAPTION = "人员类别", XMLNAME = "patient_type");

Property incategory As %String(CAPTION = "入院科室名称", XMLNAME = "in_category");

/// 患者门诊号，当有 med_outinfo节点时必填
Property incategorycode As %String(CAPTION = "入院科室编码", XMLNAME = "in_category_code");

Property outcategory As %String(CAPTION = "出院科室名称", XMLNAME = "out_category");

/// 性别：男、女
Property outcategorycode As %String(CAPTION = "出院科室编码", XMLNAME = "out_category_code");

/// 患者住院号，当有  med_bedinfo 节点时必填
Property hospitalno As %String(CAPTION = "患者住院号", XMLNAME = "hospital_no");

Property hospitalarea As %String(CAPTION = "入院病区", XMLNAME = "hospital_area");

Property hospitalareaout As %String(CAPTION = "出院病区", XMLNAME = "hospital_area_out");

Property bedno As %String(CAPTION = "床号", XMLNAME = "bed_no");

Property caseno As %String(CAPTION = "病历号", XMLNAME = "case_no");

/// 患者住院号，当有  med_bedinfo 节点时必填
Property indate As %String(CAPTION = "住院日期", XMLNAME = "in_date");

Property outdate As %String(CAPTION = "出院日期", XMLNAME = "out_date");

Property inDisName As %String(CAPTION = "入院诊断");

Property inDisCode As %String(CAPTION = "入院诊断编码");

/// 患者住院号，当有  med_bedinfo 节点时必填
Property outDisName As %String(CAPTION = "出院诊断");

Property outDisCode As %String(CAPTION = "出院诊断编码");

Property outDisName2 As %String(CAPTION = "出院诊断2");

Property outDisCode2 As %String(CAPTION = "出院诊断编码2");

Property outStatus As %String(CAPTION = "出院情况（性质）");

Property inWay As %String(CAPTION = "入院方式");

Property inNumber As %String(CAPTION = "本年度住院次数");

Property docno As %String(CAPTION = "医生编码", XMLNAME = "doc_no");

Property docname As %String(CAPTION = "医生姓名", XMLNAME = "doc_name");

}
