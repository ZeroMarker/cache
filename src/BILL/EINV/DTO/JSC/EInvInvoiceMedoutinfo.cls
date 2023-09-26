/// 门诊信息
Class BILL.EINV.DTO.JSC.EInvInvoiceMedoutinfo Extends %RegisteredObject
{

Property category As %String(CAPTION = "就诊科室");

Property categorycode As %String(CAPTION = "就诊科室编码", XMLNAME = "category_code");

/// 患者门诊号，当有 med_outinfo节点时必填
Property patientno As %String(CAPTION = "患者门诊号", XMLNAME = "patient_no");

Property caseno As %String(CAPTION = "病历号", XMLNAME = "case_no");

Property spdisname As %String(CAPTION = "特殊病种名称", XMLNAME = "sp_dis_name");

Property docno As %String(CAPTION = "医生编码", XMLNAME = "doc_no");

/// 性别：男、女
Property docname As %String(CAPTION = "医生名称", XMLNAME = "doc_name");

Property inDisName As %String(CAPTION = "门诊诊断名称");

Property inDisCode As %String(CAPTION = "门诊诊断编码");

}
