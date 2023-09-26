/// 门诊信息
Class BILL.EINV.DTO.NNWA.EInvPatientData Extends %RegisteredObject
{

Property patientNumber As %String(CAPTION = "门诊号");

Property medicalDate As %String(CAPTION = "就诊日期");

Property caseNumber As %String(CAPTION = "病例号");

Property departmentName As %String(CAPTION = "科室名称");

Property departmentCode As %String(CAPTION = "科室编号");

Property orgType As %String(CAPTION = "医疗机构类型");

Property medicalInsuranceType As %String(CAPTION = "医保类型");

Property medicalInsuranceID As %String(CAPTION = "医保编号");

Property fundPayAmount As %String(CAPTION = "医保统筹基金支付");

Property otherPayAmount As %String(CAPTION = "其他支付");

Property accountPayAmount As %String(CAPTION = "个人账户支付");

Property ownPayAmount As %String(CAPTION = "个人现金支付");

Property selfpaymentAmount As %String(CAPTION = "个人自付");

Property selfpaymentCost As %String(CAPTION = "个人自费");

}
