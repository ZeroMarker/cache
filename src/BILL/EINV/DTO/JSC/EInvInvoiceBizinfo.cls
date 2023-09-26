/// 就诊信息明细
Class BILL.EINV.DTO.JSC.EInvInvoiceBizinfo Extends %RegisteredObject
{

Property biztype As %String(CAPTION = "业务类型");

/// 医保类型名称，例如城镇职工基本医疗保险、城镇居民基本医疗保险、新型农村合作医疗、其它医疗保险等
Property medcaretype As %String(CAPTION = "医保类型名称", XMLNAME = "medcare_type");

Property medcaretypecode As %String(CAPTION = "医保类型编码", XMLNAME = "medcare_type_code");

Property medinsttype As %String(CAPTION = "医疗机构类型", XMLNAME = "med_inst_type");

Property patientid As %String(CAPTION = "患者唯一ID", XMLNAME = "patient_id");

/// 性别：男、女
Property sex As %String(CAPTION = "性别");

Property age As %String(CAPTION = "年龄");

/// 门诊信息， biztype为02、03、04时必填
Property medoutinfo As BILL.EINV.DTO.JSC.EInvInvoiceMedoutinfo(CAPTION = "门诊信息", XMLNAME = "med_outinfo");

/// 住院信息， biztype为01时必填
Property medbedinfo As BILL.EINV.DTO.JSC.EInvInvoiceMedbedinfo(CAPTION = "住院信息", XMLNAME = "med_bedinfo");

/// 挂号信息， biztype为06时必填
Property medreginfo As BILL.EINV.DTO.JSC.EInvInvoiceMedreginfo(CAPTION = "挂号信息", XMLNAME = "med_reginfo");

/// 体检信息， biztype为06时必填
Property medexaminfo As BILL.EINV.DTO.JSC.EInvInvoiceMedexaminfo(CAPTION = "体检信息", XMLNAME = "med_examinfo");

}
