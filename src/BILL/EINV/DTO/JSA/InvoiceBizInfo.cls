Class BILL.EINV.DTO.JSA.InvoiceBizInfo Extends %RegisteredObject
{

Property biztype As %String(CAPTION = "业务类型", XMLNAME = "biztype");

Property medcaretype As %String(CAPTION = "医保类型名称", XMLNAME = "medcare_type");

Property medcaretypecode As %String(CAPTION = "医保类型编码", XMLNAME = "medcare_type_code");

Property medinsttype As %String(CAPTION = "医疗机构类型", XMLNAME = "med_inst_type");

Property patientid As %String(CAPTION = "患者唯一ID", XMLNAME = "patient_id");

Property sex As %String(CAPTION = "性别：男、女", XMLNAME = "sex");

Property age As %String(CAPTION = "年龄", XMLNAME = "age");

Property medoutinfo As BILL.EINV.DTO.JSA.InvoicemMedoutInfo(CAPTION = "门诊信息", XMLNAME = "med_outinfo");

Property medbedinfo As BILL.EINV.DTO.JSA.InvoiceMedbedInfo(CAPTION = "住院信息", XMLNAME = "med_bedinfo");

Property medreginfo As BILL.EINV.DTO.JSA.InvoiceMedregInfo(CAPTION = "挂号信息", XMLNAME = "med_reginfo");

Property medexaminfo As BILL.EINV.DTO.JSA.InvoiceMedexamInfo(CAPTION = "体检信息", XMLNAME = "med_examinfo");

}
