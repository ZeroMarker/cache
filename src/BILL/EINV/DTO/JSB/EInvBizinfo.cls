/// 就诊信息明细
Class BILL.EINV.DTO.JSB.EInvBizinfo Extends %RegisteredObject
{

Property biztype As %String(CAPTION = "业务类型");

Property "medcare_type" As %String(CAPTION = "医保类型名称");

Property "medcare_type_code" As %String(CAPTION = "医保类型编码");

Property "med_inst_type" As %String(CAPTION = "医疗机构类型");

Property "patient_id" As %String(CAPTION = "患者唯一 ID");

Property "patient_name" As %String(CAPTION = "患者姓名");

Property "patient_id_no" As %String(CAPTION = "患者证件号码");

/// 性别：男、女
Property sex As %String(CAPTION = "性别");

Property age As %String(CAPTION = "年龄");

/// biztype 为 02、03、04 时必填
Property "med_outinfo" As BILL.EINV.DTO.JSB.EInvMedOutinfo(CAPTION = "门诊信息");

/// 住院信息,biztyp为01时必填
Property "med_bedinfo" As BILL.EINV.DTO.JSB.EInvMedBedinfo(CAPTION = "住院信息");

/// 挂号信息,biztyp为06时必填
Property "med_reginfo" As BILL.EINV.DTO.JSB.EInvMedReginfo(CAPTION = "挂号信息");

/// 体  检  信 息  ，  biztype   为   05  时  必必填
Property "med_examinfo" As BILL.EINV.DTO.JSB.EInvMedExaminfo(CAPTION = "体检信息");

}
